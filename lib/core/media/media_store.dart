import 'dart:io';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../db/enums.dart';

/// Wynik zaimportowania pliku do magazynu aplikacji.
class StoredMedia {
  const StoredMedia({
    required this.fileName,
    required this.bytes,
    required this.sha256,
    required this.mimeType,
    this.wasDeduplicated = false,
  });

  final String fileName;
  final int bytes;
  final String sha256;
  final String mimeType;

  /// Plik o tej samej zawartości już był w magazynie — nie skopiowano
  /// go drugi raz, tylko wskazano istniejący.
  final bool wasDeduplicated;
}

/// Magazyn plików dołączanych do dziennika.
///
/// **Pliki są kopiowane, nie tylko wskazywane.** Referencja do zdjęcia
/// w galerii jest tańsza, ale przy dzienniku prowadzonym latami skasowanie
/// tego zdjęcia to kwestia „kiedy", nie „czy" — a wtedy wpis zostaje
/// z martwym odnośnikiem i nie da się już odtworzyć, co tam było.
///
/// Nazwa pliku w magazynie pochodzi z sumy kontrolnej zawartości. Daje to
/// deduplikację za darmo: dorzucenie tego samego zdjęcia do dwóch wpisów
/// nie zajmuje miejsca dwa razy.
class MediaStore {
  MediaStore._(this._root);

  final Directory _root;

  static MediaStore? _instance;

  /// Maksymalny bok zdjęcia po imporcie.
  ///
  /// Zdjęcie z telefonu ma dziś ~4000 px i 4 MB. Do dziennika, oglądanego
  /// na ekranie telefonu, 2048 px w zupełności wystarcza, a plik schodzi
  /// do ~500 KB. Przy kilkuset wpisach to różnica między setkami megabajtów
  /// a kilkoma.
  static const _maxPhotoEdge = 2048;
  static const _photoQuality = 85;

  static Future<MediaStore> instance() async {
    final existing = _instance;
    if (existing != null) return existing;

    final base = await _resolveBaseDirectory();
    final media = Directory(p.join(base.path, 'media'));
    if (!media.existsSync()) {
      await media.create(recursive: true);
    }
    return _instance = MediaStore._(media);
  }

  /// Katalog bazowy magazynu.
  ///
  /// Na Androidzie celowo katalog zewnętrzny aplikacji
  /// (`Android/data/com.franek.tempo/files`), a nie wewnętrzny: jest widoczny
  /// w menedżerze plików, więc da się go skopiować na komputer bez roota.
  /// Nie wymaga przy tym żadnych uprawnień od Androida 10.
  ///
  /// Uwaga, której nie da się obejść po tej stronie: **odinstalowanie
  /// aplikacji kasuje ten katalog**. Przed kopią zapasową w chmurze chroni
  /// przed tym tylko ręczny eksport.
  static Future<Directory> _resolveBaseDirectory() async {
    if (Platform.isAndroid) {
      final external = await getExternalStorageDirectory();
      if (external != null) return external;
    }
    return getApplicationSupportDirectory();
  }

  String pathFor(String fileName) => p.join(_root.path, fileName);

  File fileFor(String fileName) => File(pathFor(fileName));

  bool exists(String fileName) => fileFor(fileName).existsSync();

  /// Kopiuje plik do magazynu i zwraca jego opis.
  ///
  /// Zdjęcia są po drodze zmniejszane i przekodowywane; audio, wideo
  /// i pozostałe pliki kopiowane bez zmian — przekodowywanie wideo na
  /// telefonie trwa minutami i psuje jakość nagrania, które właśnie
  /// chciałeś zachować.
  Future<StoredMedia> import(
    File source, {
    required AttachmentKind kind,
    String? preferredExtension,
  }) async {
    if (!source.existsSync()) {
      throw FileSystemException('Plik źródłowy nie istnieje', source.path);
    }

    final bytes = kind == AttachmentKind.photo
        ? await _compressPhoto(source)
        : await source.readAsBytes();

    final digest = sha256.convert(bytes).toString();
    final ext = kind == AttachmentKind.photo
        ? '.jpg'
        : (preferredExtension ?? p.extension(source.path)).toLowerCase();
    final fileName = '$digest$ext';
    final target = fileFor(fileName);

    if (target.existsSync()) {
      return StoredMedia(
        fileName: fileName,
        bytes: target.lengthSync(),
        sha256: digest,
        mimeType: _mimeFor(ext, kind),
        wasDeduplicated: true,
      );
    }

    await target.writeAsBytes(bytes, flush: true);

    return StoredMedia(
      fileName: fileName,
      bytes: bytes.length,
      sha256: digest,
      mimeType: _mimeFor(ext, kind),
    );
  }

  /// Przyjmuje plik już leżący w magazynie (np. świeże nagranie zapisane
  /// przez nagrywarkę prosto do katalogu), licząc sumę i zmieniając nazwę
  /// na kanoniczną.
  Future<StoredMedia> adopt(
    File file, {
    required AttachmentKind kind,
  }) async {
    final digest = await _hashStream(file);
    final ext = p.extension(file.path).toLowerCase();
    final fileName = '$digest$ext';
    final target = fileFor(fileName);

    if (p.equals(file.path, target.path)) {
      return StoredMedia(
        fileName: fileName,
        bytes: file.lengthSync(),
        sha256: digest,
        mimeType: _mimeFor(ext, kind),
      );
    }

    if (target.existsSync()) {
      // Identyczna zawartość już jest w magazynie — kasujemy świeży plik
      // zamiast trzymać dwie kopie tego samego nagrania.
      await file.delete();
      return StoredMedia(
        fileName: fileName,
        bytes: target.lengthSync(),
        sha256: digest,
        mimeType: _mimeFor(ext, kind),
        wasDeduplicated: true,
      );
    }

    await file.rename(target.path);
    return StoredMedia(
      fileName: fileName,
      bytes: target.lengthSync(),
      sha256: digest,
      mimeType: _mimeFor(ext, kind),
    );
  }

  /// Ścieżka na świeże nagranie, zanim pozna się jego sumę kontrolną.
  Future<File> scratchFile(String extension) async {
    final name = 'nagranie-${DateTime.now().millisecondsSinceEpoch}$extension';
    return fileFor(name);
  }

  /// Kasuje plik, o ile nie używa go żaden inny załącznik.
  ///
  /// Sprawdzenie należy do wywołującego — magazyn nie zna bazy danych,
  /// a przy nazwach z sumy kontrolnej ten sam plik bywa współdzielony
  /// przez kilka wpisów.
  Future<void> deleteFile(String fileName) async {
    final f = fileFor(fileName);
    if (f.existsSync()) await f.delete();
  }

  /// Pliki w magazynie, których nie zna żaden załącznik w bazie.
  ///
  /// Powstają po skasowaniu wpisu albo po przerwanym imporcie. Zwracamy
  /// listę zamiast kasować od razu, żeby decyzję podjął ekran ustawień —
  /// cichy proces kasujący pliki multimedialne w tle to zły pomysł.
  Future<List<File>> findOrphans(Set<String> knownFileNames) async {
    if (!_root.existsSync()) return const [];

    final orphans = <File>[];
    await for (final entity in _root.list()) {
      if (entity is! File) continue;
      if (!knownFileNames.contains(p.basename(entity.path))) {
        orphans.add(entity);
      }
    }
    return orphans;
  }

  Future<int> totalBytes() async {
    if (!_root.existsSync()) return 0;
    var total = 0;
    await for (final entity in _root.list()) {
      if (entity is File) total += entity.lengthSync();
    }
    return total;
  }

  String get rootPath => _root.path;

  /// Liczy sumę kontrolną strumieniowo.
  ///
  /// Wideo potrafi mieć setki megabajtów — wczytanie go w całości do pamięci
  /// tylko po to, żeby policzyć skrót, wywróciłoby aplikację na telefonie.
  static Future<String> _hashStream(File file) async {
    final digest = await sha256.bind(file.openRead()).first;
    return digest.toString();
  }

  /// Zmniejsza i przekodowuje zdjęcie.
  ///
  /// Leci w osobnym izolacie, bo dekodowanie kilkumegapikselowego JPEG-a
  /// zajmuje ułamki sekundy, w trakcie których interfejs stałby zamrożony.
  static Future<List<int>> _compressPhoto(File source) async {
    final raw = await source.readAsBytes();
    return Isolate.run(() {
      final decoded = img.decodeImage(raw);
      // Format nierozpoznany przez bibliotekę (HEIC, egzotyczny RAW):
      // zapisujemy oryginał bez zmian, zamiast odrzucać zdjęcie.
      if (decoded == null) return raw;

      final longest =
          decoded.width > decoded.height ? decoded.width : decoded.height;
      final resized = longest <= _maxPhotoEdge
          ? decoded
          : img.copyResize(
              decoded,
              width: decoded.width >= decoded.height ? _maxPhotoEdge : null,
              height: decoded.height > decoded.width ? _maxPhotoEdge : null,
              interpolation: img.Interpolation.average,
            );

      return img.encodeJpg(resized, quality: _photoQuality);
    });
  }

  static String _mimeFor(String ext, AttachmentKind kind) {
    return switch (ext.toLowerCase()) {
      '.jpg' || '.jpeg' => 'image/jpeg',
      '.png' => 'image/png',
      '.webp' => 'image/webp',
      '.heic' => 'image/heic',
      '.m4a' || '.aac' => 'audio/mp4',
      '.flac' => 'audio/flac',
      '.mp3' => 'audio/mpeg',
      '.wav' => 'audio/wav',
      '.ogg' || '.opus' => 'audio/ogg',
      '.mp4' => 'video/mp4',
      '.mov' => 'video/quicktime',
      '.pdf' => 'application/pdf',
      _ => switch (kind) {
          AttachmentKind.audio => 'audio/*',
          AttachmentKind.photo => 'image/*',
          AttachmentKind.video => 'video/*',
          AttachmentKind.file => 'application/octet-stream',
        },
    };
  }
}

/// Rozmiar pliku w formie czytelnej dla człowieka.
String formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).round()} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
}
