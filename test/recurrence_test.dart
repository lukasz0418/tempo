import 'package:flutter_test/flutter_test.dart';
import 'package:tempo/core/recurrence/recurrence.dart';

void main() {
  group('RecurrenceRule.tryParse', () {
    test('pusty i niezrozumiały tekst daje null', () {
      expect(RecurrenceRule.tryParse(null), isNull);
      expect(RecurrenceRule.tryParse(''), isNull);
      expect(RecurrenceRule.tryParse('CO_TYDZIEN_MOZE'), isNull);
    });

    test('parsuje częstotliwość, interwał i dni tygodnia', () {
      final rule = RecurrenceRule.tryParse('FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,WE');

      expect(rule, isNotNull);
      expect(rule!.frequency, Frequency.weekly);
      expect(rule.interval, 2);
      expect(rule.byWeekdays, [DateTime.monday, DateTime.wednesday]);
    });

    test('interwał zerowy lub ujemny jest podnoszony do jedynki', () {
      final rule = RecurrenceRule.tryParse('FREQ=DAILY;INTERVAL=0');

      expect(rule!.interval, 1);
    });

    test('encode i tryParse są wzajemnie odwrotne', () {
      const original = RecurrenceRule(
        frequency: Frequency.weekly,
        interval: 3,
        byWeekdays: [DateTime.friday],
      );

      final round = RecurrenceRule.tryParse(original.encode())!;

      expect(round.frequency, original.frequency);
      expect(round.interval, original.interval);
      expect(round.byWeekdays, original.byWeekdays);
    });
  });

  group('nextAfter', () {
    test('dzienna z interwałem', () {
      final rule = RecurrenceRule.tryParse('FREQ=DAILY;INTERVAL=3')!;

      final next = rule.nextAfter(DateTime(2026, 3, 10));

      expect(next, DateTime(2026, 3, 13));
    });

    test('tygodniowa trafia w najbliższy wskazany dzień', () {
      // 2026-03-10 to wtorek; najbliższa środa to 11 marca.
      final rule = RecurrenceRule.tryParse('FREQ=WEEKLY;BYDAY=MO,WE')!;

      final next = rule.nextAfter(DateTime(2026, 3, 10));

      expect(next, DateTime(2026, 3, 11));
      expect(next.weekday, DateTime.wednesday);
    });

    test('miesięczna przycina dzień do długości miesiąca', () {
      // Bez przycinania 31 stycznia + miesiąc daje 3 marca,
      // bo DateTime przepełnia dni.
      final rule = RecurrenceRule.tryParse('FREQ=MONTHLY')!;

      final next = rule.nextAfter(DateTime(2026, 1, 31));

      expect(next, DateTime(2026, 2, 28));
    });

    test('miesięczna radzi sobie z przełomem roku', () {
      final rule = RecurrenceRule.tryParse('FREQ=MONTHLY;INTERVAL=2')!;

      final next = rule.nextAfter(DateTime(2026, 11, 15));

      expect(next, DateTime(2027, 1, 15));
    });

    test('wynik jest zawsze ściśle po dacie odniesienia', () {
      for (final encoded in const [
        'FREQ=DAILY',
        'FREQ=WEEKLY',
        'FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR,SA,SU',
        'FREQ=MONTHLY',
      ]) {
        final rule = RecurrenceRule.tryParse(encoded)!;
        final from = DateTime(2026, 6, 15);

        expect(rule.nextAfter(from).isAfter(from), isTrue, reason: encoded);
      }
    });
  });
}
