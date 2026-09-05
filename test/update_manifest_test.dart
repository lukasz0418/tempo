import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tempo/core/update/update_service.dart';

String manifestJson(Map<String, Object?> overrides) {
  final base = <String, Object?>{
    'versionCode': 5,
    'versionName': '1.0.5',
    'apkUrl': 'https://example.com/tempo-5-arm64-v8a.apk',
    'notes': 'Nowa wersja',
    'sha256': 'abc123',
  };
  return jsonEncode({...base, ...overrides});
}

void main() {
  group('UpdateManifest.tryParse', () {
    test('czyta poprawny manifest', () {
      final m = UpdateManifest.tryParse(manifestJson({}));

      expect(m, isNotNull);
      expect(m!.versionCode, 5);
      expect(m.versionName, '1.0.5');
      expect(m.apkUrl, 'https://example.com/tempo-5-arm64-v8a.apk');
      expect(m.notes, 'Nowa wersja');
      expect(m.sha256, 'abc123');
    });

    test('pola opcjonalne mogą być nieobecne', () {
      final json = jsonEncode({
        'versionCode': 5,
        'apkUrl': 'https://example.com/a.apk',
      });

      final m = UpdateManifest.tryParse(json);

      expect(m, isNotNull);
      expect(m!.notes, isNull);
      expect(m.sha256, isNull);
      expect(m.minSupportedCode, isNull);
      // Brak nazwy wersji degraduje się do numeru builda,
      // zamiast wywalać cały manifest.
      expect(m.versionName, '5');
    });

    test('odrzuca manifest bez versionCode', () {
      final json = jsonEncode({'apkUrl': 'https://example.com/a.apk'});

      expect(UpdateManifest.tryParse(json), isNull);
    });

    test('odrzuca manifest bez apkUrl', () {
      final json = jsonEncode({'versionCode': 5});

      expect(UpdateManifest.tryParse(json), isNull);
    });

    test('odrzuca versionCode podany jako tekst', () {
      // Realny błąd przy ręcznym pisaniu manifestu: "5" zamiast 5.
      // Porównanie wersji na stringu dawałoby ciche, złe wyniki,
      // więc lepiej odrzucić całość.
      final m = UpdateManifest.tryParse(manifestJson({'versionCode': '5'}));

      expect(m, isNull);
    });

    test('nie wywraca się na niepoprawnym JSON-ie', () {
      // Typowy przypadek: serwer zwrócił stronę błędu zamiast pliku.
      expect(UpdateManifest.tryParse('<html>404</html>'), isNull);
      expect(UpdateManifest.tryParse(''), isNull);
      expect(UpdateManifest.tryParse('{niedomkniete'), isNull);
    });

    test('nie wywraca się, gdy JSON jest tablicą zamiast obiektu', () {
      expect(UpdateManifest.tryParse('[1, 2, 3]'), isNull);
    });

    test('radzi sobie z BOM na początku pliku', () {
      // Realny przypadek, na którym to się wyłożyło: PowerShell 5.1
      // dopisuje BOM przy `Set-Content -Encoding utf8`, Notatnik też.
      // Znaku nie widać w treści, a jsonDecode odrzucał cały manifest
      // komunikatem „nieoczekiwany format".
      final withBom = '\u{FEFF}${manifestJson({})}';

      final m = UpdateManifest.tryParse(withBom);

      expect(m, isNotNull);
      expect(m!.versionCode, 5);
    });

    test('czyta minSupportedCode', () {
      final m = UpdateManifest.tryParse(manifestJson({'minSupportedCode': 4}));

      expect(m!.minSupportedCode, 4);
    });
  });

  group('UpdateAvailable', () {
    UpdateManifest manifest({int? minSupported}) => UpdateManifest(
          versionCode: 10,
          versionName: '1.0.10',
          apkUrl: 'https://example.com/a.apk',
          minSupportedCode: minSupported,
        );

    test('bez minSupportedCode aktualizacja jest automatyczna', () {
      final check = UpdateAvailable(manifest(), 5);

      expect(check.needsManualInstall, isFalse);
    });

    test('wersja poniżej progu wymaga ręcznej instalacji', () {
      // Ustawiane, gdy zmienił się klucz podpisujący — bez tego
      // stara wersja w kółko odbijałaby się od instalatora.
      final check = UpdateAvailable(manifest(minSupported: 8), 5);

      expect(check.needsManualInstall, isTrue);
    });

    test('wersja na progu instaluje się automatycznie', () {
      final check = UpdateAvailable(manifest(minSupported: 5), 5);

      expect(check.needsManualInstall, isFalse);
    });
  });
}
