import 'package:flutter_test/flutter_test.dart';
import 'package:tempo/core/util/dates.dart';
import 'package:tempo/core/util/streak.dart';

/// Zbiór dni ćwiczeń wyrażony jako „ile dni temu".
Set<String> daysAgo(DateTime today, List<int> offsets) {
  return offsets
      .map((d) => dayKey(DateTime(today.year, today.month, today.day - d)))
      .toSet();
}

void main() {
  final today = DateTime(2026, 3, 15);

  group('Streaks.current', () {
    test('pusty zbiór daje zero', () {
      expect(Streaks.current({}, today: today), 0);
    });

    test('liczy serię zakończoną dzisiaj', () {
      final days = daysAgo(today, [0, 1, 2, 3]);

      expect(Streaks.current(days, today: today), 4);
    });

    test('brak dzisiejszej sesji NIE zeruje serii', () {
      // Najważniejszy przypadek: dzień jeszcze trwa. Gdyby seria kasowała
      // się o północy, licznik pokazywałby zero przez większość doby
      // i nie dałoby się mu ufać.
      final days = daysAgo(today, [1, 2, 3]);

      expect(Streaks.current(days, today: today), 3);
    });

    test('przerwa dłuższa niż jeden dzień kończy serię', () {
      final days = daysAgo(today, [2, 3, 4]);

      expect(Streaks.current(days, today: today), 0);
    });

    test('luka w środku ucina serię na luce', () {
      // Ćwiczone dziś i wczoraj, potem dziura, potem znowu trzy dni.
      final days = daysAgo(today, [0, 1, 3, 4, 5]);

      expect(Streaks.current(days, today: today), 2);
    });

    test('pojedynczy dzisiejszy dzień to seria równa jeden', () {
      expect(Streaks.current(daysAgo(today, [0]), today: today), 1);
    });

    test('seria przechodzi przez granicę miesiąca', () {
      final firstOfMarch = DateTime(2026, 3, 1);
      final days = daysAgo(firstOfMarch, [0, 1, 2]); // 1 III, 28 II, 27 II

      expect(Streaks.current(days, today: firstOfMarch), 3);
    });

    test('seria przechodzi przez 29 lutego w roku przestępnym', () {
      final march1 = DateTime(2028, 3, 1);
      final days = daysAgo(march1, [0, 1, 2]); // 1 III, 29 II, 28 II

      expect(days.contains('2028-02-29'), isTrue);
      expect(Streaks.current(days, today: march1), 3);
    });
  });

  group('Streaks.longest', () {
    test('pusty zbiór daje zero', () {
      expect(Streaks.longest({}), 0);
    });

    test('znajduje najdłuższy ciąg, nie ostatni', () {
      final days = <String>{
        ...daysAgo(today, [0, 1]), // seria 2
        ...daysAgo(today, [5, 6, 7, 8]), // seria 4
      };

      expect(Streaks.longest(days), 4);
    });

    test('same rozproszone dni dają jeden', () {
      final days = daysAgo(today, [0, 3, 7, 20]);

      expect(Streaks.longest(days), 1);
    });

    test('ciąg przez granicę roku', () {
      final days = {'2025-12-30', '2025-12-31', '2026-01-01', '2026-01-02'};

      expect(Streaks.longest(days), 4);
    });
  });
}
