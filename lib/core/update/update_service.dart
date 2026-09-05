import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

/// Opis najnowszego wydania, pobierany z manifestu JSON.
///
/// Manifest jest zwykłym plikiem statycznym — może leżeć w GitHub Releases,
/// na dowolnym hostingu albo za tunelem do twojego PC. Aplikacja nie wie
/// i nie musi wiedzieć, co go serwuje.
class UpdateManifest {
  const UpdateManifest({
    required this.versionCode,
    required this.versionName,
    required this.apkUrl,
    this.notes,
    this.sha256,
    this.minSupportedCode,
  });

  /// Odpowiednik `versionCode` z Androida — jedyna liczba, po której
  /// porównujemy wersje. Nazwa wersji jest dla człowieka i bywa myląca
  /// („1.0.10" jest tekstowo mniejsze niż „1.0.9").
  final int versionCode;
  final String versionName;
  final String apkUrl;
  final String? notes;

  /// Suma kontrolna pliku APK.
  ///
  /// Chroni przed **uszkodzonym pobraniem**, nie przed atakiem: manifest
  /// i plik pochodzą z tego samego źródła, więc ktoś, kto podmieni jedno,
  /// podmieni i drugie. Przed podmianą chroni wyłącznie HTTPS —
  /// dlatego [UpdateService] odrzuca adresy inne niż `https://`.
  final String? sha256;

  /// Najstarsza wersja, która potrafi się zaktualizować sama.
  /// Poniżej niej trzeba wgrać APK ręcznie — np. gdy zmienił się podpis.
  final int? minSupportedCode;

  static UpdateManifest? tryParse(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final code = json['versionCode'];
      final url = json['apkUrl'];
      if (code is! int || url is! String) return null;

      return UpdateManifest(
        versionCode: code,
        versionName: (json['versionName'] as String?) ?? '$code',
        apkUrl: url,
        notes: json['notes'] as String?,
        sha256: json['sha256'] as String?,
        minSupportedCode: json['minSupportedCode'] as int?,
      );
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }
}

/// Wynik sprawdzenia aktualizacji.
sealed class UpdateCheck {
  const UpdateCheck();
}

class UpToDate extends UpdateCheck {
  const UpToDate(this.currentCode);
  final int currentCode;
}

class UpdateAvailable extends UpdateCheck {
  const UpdateAvailable(this.manifest, this.currentCode);
  final UpdateManifest manifest;
  final int currentCode;

  /// Aktualizacja jest za stara, żeby przeskoczyć ją automatycznie.
  bool get needsManualInstall =>
      manifest.minSupportedCode != null &&
      currentCode < manifest.minSupportedCode!;
}

class UpdateCheckFailed extends UpdateCheck {
  const UpdateCheckFailed(this.reason);
  final String reason;
}

/// Aktualizacja aplikacji na telefonie bez sklepu.
///
/// Cały mechanizm to trzy kroki: pobierz manifest, porównaj `versionCode`,
/// ściągnij APK i oddaj go systemowemu instalatorowi. Android sam pokaże
/// ekran potwierdzenia — nie da się (i nie powinno dać) zainstalować
/// aktualizacji po cichu.
///
/// **Ograniczenie, o którym warto pamiętać:** ta ścieżka wymienia całą
/// aplikację, więc obsługuje każdą zmianę — także w kodzie natywnym
/// i zależnościach. Jest za to głośna: przy każdej aktualizacji zobaczysz
/// systemowy dialog instalatora. Dla zmian wyłącznie w kodzie Dart
/// alternatywą jest Shorebird (code push), który podmienia sam kod
/// bez reinstalacji — ale nie przeniesie zmian w Kotlinie ani nowych paczek.
class UpdateService {
  UpdateService({http.Client? client}) : _client = client ?? http.Client();

  static const _installerChannel = MethodChannel('tempo/installer');

  final http.Client _client;

  /// Sprawdza, czy pod [manifestUrl] czeka nowsza wersja.
  Future<UpdateCheck> check(String manifestUrl) async {
    if (!Platform.isAndroid) {
      return const UpdateCheckFailed(
          'Aktualizacje przez APK działają tylko na Androidzie.');
    }

    final uri = Uri.tryParse(manifestUrl);
    if (uri == null || !uri.isScheme('https')) {
      // Bez HTTPS każdy w tej samej sieci może podstawić własny plik APK,
      // a użytkownik zobaczy zwykły ekran instalacji. To jedyne miejsce,
      // w którym ten mechanizm może naprawdę zaszkodzić.
      return const UpdateCheckFailed('Adres manifestu musi zaczynać się od https://');
    }

    final info = await PackageInfo.fromPlatform();
    final currentCode = int.tryParse(info.buildNumber) ?? 0;

    try {
      final response =
          await _client.get(uri).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        return UpdateCheckFailed('Serwer odpowiedział ${response.statusCode}');
      }

      final manifest = UpdateManifest.tryParse(response.body);
      if (manifest == null) {
        return const UpdateCheckFailed('Manifest ma nieoczekiwany format');
      }

      if (manifest.versionCode <= currentCode) return UpToDate(currentCode);
      return UpdateAvailable(manifest, currentCode);
    } on SocketException {
      return const UpdateCheckFailed('Brak połączenia z siecią');
    } on http.ClientException catch (e) {
      return UpdateCheckFailed('Błąd pobierania: ${e.message}');
    }
  }

  /// Pobiera APK i oddaje go systemowemu instalatorowi.
  ///
  /// [onProgress] dostaje wartość 0..1 albo null, gdy serwer nie podał
  /// długości treści — pasek postępu przechodzi wtedy w tryb nieokreślony
  /// zamiast kłamać, że jest na 0%.
  Future<String?> downloadAndInstall(
    UpdateManifest manifest, {
    void Function(double? progress)? onProgress,
  }) async {
    final uri = Uri.tryParse(manifest.apkUrl);
    if (uri == null || !uri.isScheme('https')) {
      return 'Adres APK musi zaczynać się od https://';
    }

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/tempo-${manifest.versionCode}.apk');

    try {
      final request = http.Request('GET', uri);
      final response = await _client.send(request);
      if (response.statusCode != 200) {
        return 'Serwer odpowiedział ${response.statusCode}';
      }

      final total = response.contentLength;
      var received = 0;
      final sink = file.openWrite();

      try {
        await for (final chunk in response.stream) {
          sink.add(chunk);
          received += chunk.length;
          onProgress?.call(total == null ? null : received / total);
        }
      } finally {
        await sink.close();
      }

      final expected = manifest.sha256;
      if (expected != null) {
        final actual = sha256.convert(await file.readAsBytes()).toString();
        if (actual.toLowerCase() != expected.toLowerCase()) {
          // Uszkodzone pobranie. Kasujemy plik, żeby kolejna próba
          // nie trafiła na śmieci z poprzedniej.
          await file.delete();
          return 'Pobrany plik jest uszkodzony (suma kontrolna się nie zgadza)';
        }
      }

      await _installerChannel.invokeMethod<void>('install', {'path': file.path});
      return null;
    } on SocketException {
      return 'Połączenie przerwane w trakcie pobierania';
    } on PlatformException catch (e) {
      return 'Nie udało się uruchomić instalatora: ${e.message}';
    }
  }

  /// Czy użytkownik pozwolił tej aplikacji instalować pakiety.
  Future<bool> canInstall() async {
    if (!Platform.isAndroid) return false;
    try {
      return await _installerChannel.invokeMethod<bool>('canInstall') ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Otwiera systemowy ekran „Instalowanie nieznanych aplikacji".
  Future<void> requestInstallPermission() async {
    if (!Platform.isAndroid) return;
    try {
      await _installerChannel.invokeMethod<void>('requestInstallPermission');
    } on PlatformException {
      // Brak takiego ekranu na tej nakładce — użytkownik i tak zobaczy
      // prośbę o zgodę w momencie instalacji.
    }
  }

  void dispose() => _client.close();
}
