import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';

import '../db/enums.dart';
import 'media_store.dart';

/// Świeżo przechwycony plik, jeszcze przed zapisaniem w bazie.
class CapturedMedia {
  const CapturedMedia({
    required this.stored,
    required this.kind,
    this.label = '',
    this.durationMs,
  });

  final StoredMedia stored;
  final AttachmentKind kind;
  final String label;
  final int? durationMs;
}

/// Nagrywanie dźwięku i przechwytywanie zdjęć oraz wideo.
///
/// Wszystko trafia do [MediaStore], czyli **jest kopiowane** do katalogu
/// aplikacji. Kasowanie oryginału w galerii nie ma po tym żadnego wpływu
/// na dziennik.
class MediaCapture {
  MediaCapture(this._store);

  final MediaStore _store;
  final ImagePicker _picker = ImagePicker();
  AudioRecorder? _recorder;

  /// Jakość kolejnych nagrań. Ustawiana z ekranu ustawień.
  AudioQuality quality = AudioQuality.practice;

  /// Parametry nagrania dla bieżącej jakości.
  ///
  /// Częstotliwość próbkowania zostaje 44,1 kHz niezależnie od ustawienia:
  /// jej obniżenie obcina górę pasma, czyli szum oddechu i wybrzmienia
  /// strun — akurat to, po czym słychać różnicę między nagraniem sprzed
  /// pół roku a dzisiejszym. Oszczędność miejsca idzie przez bitrate,
  /// nie przez pasmo.
  RecordConfig get _audioConfig => RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: quality.bitRate,
        sampleRate: 44100,
        numChannels: quality.channels,
      );

  bool get isRecording => _recorder != null;

  /// Czy da się w ogóle nagrywać (uprawnienie do mikrofonu).
  ///
  /// Wywołanie z `request: true` samo prosi użytkownika o zgodę,
  /// więc nie ma potrzeby osobnego pakietu do uprawnień.
  Future<bool> canRecord() async {
    final recorder = AudioRecorder();
    try {
      return await recorder.hasPermission();
    } finally {
      await recorder.dispose();
    }
  }

  /// Rozpoczyna nagrywanie. Zwraca false, gdy brak zgody na mikrofon.
  Future<bool> startRecording() async {
    if (_recorder != null) return true;

    final recorder = AudioRecorder();
    if (!await recorder.hasPermission()) {
      await recorder.dispose();
      return false;
    }

    // Nagranie leci od razu do katalogu mediów, a nie do folderu
    // tymczasowego. Dzięki temu przerwanie aplikacji w trakcie zostawia
    // plik w miejscu, z którego da się go odzyskać, zamiast w katalogu,
    // który system czyści bez ostrzeżenia.
    final target = await _store.scratchFile('.m4a');
    await recorder.start(_audioConfig, path: target.path);
    _recorder = recorder;
    return true;
  }

  /// Kończy nagrywanie i przenosi plik pod nazwę kanoniczną.
  ///
  /// Zwraca null, gdy nic nie było nagrywane albo plik okazał się pusty
  /// (zdarza się przy natychmiastowym zatrzymaniu).
  Future<CapturedMedia?> stopRecording({int? durationMs}) async {
    final recorder = _recorder;
    if (recorder == null) return null;

    final path = await recorder.stop();
    await recorder.dispose();
    _recorder = null;

    if (path == null) return null;
    final file = File(path);
    if (!file.existsSync() || file.lengthSync() == 0) {
      if (file.existsSync()) await file.delete();
      return null;
    }

    final stored = await _store.adopt(file, kind: AttachmentKind.audio);
    return CapturedMedia(
      stored: stored,
      kind: AttachmentKind.audio,
      label: 'Nagranie',
      durationMs: durationMs,
    );
  }

  /// Porzuca trwające nagranie i kasuje plik.
  Future<void> cancelRecording() async {
    final recorder = _recorder;
    if (recorder == null) return;

    final path = await recorder.stop();
    await recorder.dispose();
    _recorder = null;

    if (path == null) return;
    final file = File(path);
    if (file.existsSync()) await file.delete();
  }

  Future<CapturedMedia?> takePhoto() =>
      _pickImage(ImageSource.camera, 'Zdjęcie');

  Future<CapturedMedia?> pickPhoto() =>
      _pickImage(ImageSource.gallery, 'Zdjęcie');

  Future<CapturedMedia?> recordVideo() =>
      _pickVideo(ImageSource.camera, 'Nagranie wideo');

  Future<CapturedMedia?> pickVideo() =>
      _pickVideo(ImageSource.gallery, 'Wideo');

  /// Kilka zdjęć naraz — typowy przypadek przy dokumentowaniu treningu.
  Future<List<CapturedMedia>> pickPhotos() async {
    final files = await _picker.pickMultiImage();
    final out = <CapturedMedia>[];
    for (final f in files) {
      final stored = await _store.import(
        File(f.path),
        kind: AttachmentKind.photo,
      );
      out.add(CapturedMedia(
        stored: stored,
        kind: AttachmentKind.photo,
        label: f.name,
      ));
    }
    return out;
  }

  Future<CapturedMedia?> _pickImage(ImageSource source, String label) async {
    final file = await _picker.pickImage(source: source);
    if (file == null) return null;

    final stored = await _store.import(
      File(file.path),
      kind: AttachmentKind.photo,
    );
    return CapturedMedia(
      stored: stored,
      kind: AttachmentKind.photo,
      label: label,
    );
  }

  Future<CapturedMedia?> _pickVideo(ImageSource source, String label) async {
    final file = await _picker.pickVideo(source: source);
    if (file == null) return null;

    // Wideo kopiujemy bez przekodowywania: transkodowanie na telefonie
    // trwa minutami i obniża jakość nagrania, które właśnie chciałeś
    // zachować. Kosztem jest rozmiar — ekran ustawień pokazuje,
    // ile miejsca zajmuje magazyn.
    final stored = await _store.import(
      File(file.path),
      kind: AttachmentKind.video,
    );
    return CapturedMedia(
      stored: stored,
      kind: AttachmentKind.video,
      label: label,
    );
  }

  Future<void> dispose() async {
    await _recorder?.dispose();
    _recorder = null;
  }
}
