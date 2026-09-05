import 'package:flutter_test/flutter_test.dart';
import 'package:tempo/core/db/enums.dart';

void main() {
  group('AudioQuality', () {
    test('bitrate rośnie wraz z jakością', () {
      expect(
        AudioQuality.note.bitRate < AudioQuality.practice.bitRate,
        isTrue,
      );
      expect(
        AudioQuality.practice.bitRate < AudioQuality.high.bitRate,
        isTrue,
      );
    });

    test('tylko najwyższa jakość jest stereo', () {
      // Przy nagrywaniu własnego głosu stereo podwaja rozmiar bez zysku —
      // ma sens dopiero przy instrumencie albo pomieszczeniu.
      expect(AudioQuality.note.channels, 1);
      expect(AudioQuality.practice.channels, 1);
      expect(AudioQuality.high.channels, 2);
    });

    test('rozmiar na minutę zgadza się z bitrate', () {
      // 128 kbps = 16 kB/s = 960 kB/min ≈ 0,9 MB
      expect(AudioQuality.practice.sizePerMinute, '0.9 MB/min');
      // 64 kbps = 8 kB/s = 480 kB/min ≈ 0,5 MB
      expect(AudioQuality.note.sizePerMinute, '0.5 MB/min');
      // 192 kbps = 24 kB/s = 1440 kB/min ≈ 1,4 MB
      expect(AudioQuality.high.sizePerMinute, '1.4 MB/min');
    });

    test('bezstratna jest oznaczona i ma inne rozszerzenie', () {
      // Rozszerzenie musi iść za kodekiem, bo po nim aplikacja rozpoznaje
      // typ MIME — plik FLAC z nazwą .m4a nie odtworzyłby się nigdzie.
      expect(AudioQuality.lossless.isLossless, isTrue);
      expect(AudioQuality.lossless.fileExtension, '.flac');

      for (final q in AudioQuality.values.where((q) => !q.isLossless)) {
        expect(q.fileExtension, '.m4a', reason: q.name);
      }
    });

    test('rozmiar bezstratnej podany orientacyjnie', () {
      // FLAC nie ma stałej przepływności, więc liczba jest szacunkiem —
      // tylda w tekście mówi o tym wprost, zamiast udawać precyzję.
      expect(AudioQuality.lossless.sizePerMinute, startsWith('~'));
    });

    test('każda jakość ma opis i etykietę', () {
      for (final q in AudioQuality.values) {
        expect(q.label, isNotEmpty);
        expect(q.description, isNotEmpty);
      }
    });

    test('godzina nagrania w jakości ćwiczeniowej mieści się w 60 MB', () {
      // Sanity check skali: dwieście trzyminutowych sesji to ~570 MB,
      // czyli nic przy dzisiejszych telefonach. Gdyby ktoś kiedyś
      // podniósł bitrate bez zastanowienia, ten test zaprotestuje.
      final bytesPerHour = AudioQuality.practice.bitRate * 3600 / 8;
      expect(bytesPerHour / (1024 * 1024), lessThan(60));
    });
  });
}
