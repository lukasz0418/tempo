/// Minimalny podzbiór RRULE — tyle, ile realnie potrzeba w prywatnym życiu.
///
/// Obsługiwane: `FREQ=DAILY|WEEKLY|MONTHLY`, `INTERVAL=n`, `BYDAY=MO,WE,FR`.
/// Świadomie **nie** implementujemy pełnego RFC 5545: reguły typu
/// „druga środa miesiąca, chyba że święto" nie pojawiają się przy podlewaniu
/// kwiatów i wymianie filtra, a pełny parser to kilkaset linii i własna
/// klasa błędów.
library;

enum Frequency { daily, weekly, monthly }

class RecurrenceRule {
  const RecurrenceRule({
    required this.frequency,
    this.interval = 1,
    this.byWeekdays = const [],
  });

  final Frequency frequency;

  /// Co ile jednostek. `FREQ=WEEKLY;INTERVAL=2` to co dwa tygodnie.
  final int interval;

  /// Dni tygodnia wg [DateTime.monday]..[DateTime.sunday].
  /// Znaczące tylko dla [Frequency.weekly].
  final List<int> byWeekdays;

  static const _dayCodes = {
    'MO': DateTime.monday,
    'TU': DateTime.tuesday,
    'WE': DateTime.wednesday,
    'TH': DateTime.thursday,
    'FR': DateTime.friday,
    'SA': DateTime.saturday,
    'SU': DateTime.sunday,
  };

  /// Parsuje regułę. Zwraca null, jeśli tekst jest pusty lub niezrozumiały —
  /// zepsuta reguła ma sprawić, że zadanie przestanie się powtarzać,
  /// a nie że aplikacja wybuchnie przy odhaczaniu.
  static RecurrenceRule? tryParse(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;

    final parts = <String, String>{};
    for (final chunk in raw.toUpperCase().split(';')) {
      final i = chunk.indexOf('=');
      if (i <= 0) continue;
      parts[chunk.substring(0, i).trim()] = chunk.substring(i + 1).trim();
    }

    final freq = switch (parts['FREQ']) {
      'DAILY' => Frequency.daily,
      'WEEKLY' => Frequency.weekly,
      'MONTHLY' => Frequency.monthly,
      _ => null,
    };
    if (freq == null) return null;

    final interval = int.tryParse(parts['INTERVAL'] ?? '1') ?? 1;

    final days = <int>[];
    for (final code in (parts['BYDAY'] ?? '').split(',')) {
      final d = _dayCodes[code.trim()];
      if (d != null) days.add(d);
    }
    days.sort();

    return RecurrenceRule(
      frequency: freq,
      interval: interval < 1 ? 1 : interval,
      byWeekdays: days,
    );
  }

  String encode() {
    final buf = StringBuffer('FREQ=${frequency.name.toUpperCase()}');
    if (interval != 1) buf.write(';INTERVAL=$interval');
    if (byWeekdays.isNotEmpty) {
      final codes = byWeekdays
          .map((d) => _dayCodes.entries.firstWhere((e) => e.value == d).key);
      buf.write(';BYDAY=${codes.join(',')}');
    }
    return buf.toString();
  }

  /// Następne wystąpienie **ściśle po** [after].
  ///
  /// Liczone zawsze od daty przekazanej przez wywołującego, nie od „dziś" —
  /// to on decyduje, czy punktem odniesienia jest termin, czy moment
  /// faktycznego wykonania (patrz `Tasks.recurrenceFromCompletion`).
  DateTime nextAfter(DateTime after) {
    final base = DateTime(after.year, after.month, after.day);

    return switch (frequency) {
      Frequency.daily => base.add(Duration(days: interval)),
      Frequency.weekly => _nextWeekly(base),
      Frequency.monthly => _addMonths(base, interval),
    };
  }

  DateTime _nextWeekly(DateTime base) {
    if (byWeekdays.isEmpty) return base.add(Duration(days: 7 * interval));

    // Najbliższy wskazany dzień w tym tygodniu...
    for (var i = 1; i <= 7; i++) {
      final candidate = base.add(Duration(days: i));
      if (byWeekdays.contains(candidate.weekday)) return candidate;
    }
    // ...a jeśli żadnego nie ma, pierwszy dzień po przeskoku o interwał.
    return base.add(Duration(days: 7 * interval));
  }

  /// Dodaje miesiące, przycinając dzień do długości miesiąca docelowego.
  ///
  /// Bez tego 31 stycznia + 1 miesiąc daje w Dart 2 albo 3 marca, bo
  /// `DateTime` przepełnia dni. Zadanie „co miesiąc 31." ma wypaść
  /// 28 lutego, a nie na początku marca.
  static DateTime _addMonths(DateTime d, int months) {
    final totalMonths = d.month - 1 + months;
    final year = d.year + (totalMonths ~/ 12);
    final month = totalMonths % 12 + 1;
    final lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, d.day < lastDay ? d.day : lastDay);
  }

  /// Opis po polsku do pokazania w UI.
  String describe() {
    final every = switch (frequency) {
      Frequency.daily => interval == 1 ? 'codziennie' : 'co $interval dni',
      Frequency.weekly =>
        interval == 1 ? 'co tydzień' : 'co $interval tygodnie',
      Frequency.monthly =>
        interval == 1 ? 'co miesiąc' : 'co $interval miesiące',
    };
    if (frequency != Frequency.weekly || byWeekdays.isEmpty) return every;

    const names = {
      DateTime.monday: 'pon',
      DateTime.tuesday: 'wt',
      DateTime.wednesday: 'śr',
      DateTime.thursday: 'czw',
      DateTime.friday: 'pt',
      DateTime.saturday: 'sob',
      DateTime.sunday: 'niedz',
    };
    return '$every w ${byWeekdays.map((d) => names[d]).join(', ')}';
  }
}
