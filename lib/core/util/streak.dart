import 'dates.dart';

/// Liczy serię dni ćwiczeń.
///
/// Wydzielone z DAO jako czysta funkcja, bo reguła jest podchwytliwa
/// i łatwo ją zepsuć niezauważenie: licznik serii, który myli się o jeden,
/// wygląda wiarygodnie i nikt tego nie sprawdza.
abstract final class Streaks {
  /// Liczba dni z rzędu zakończona dziś albo wczoraj.
  ///
  /// Kluczowa decyzja: **brak dzisiejszej sesji nie zeruje serii.** Dzień
  /// jeszcze trwa, więc liczenie zaczyna się od wczoraj. Bez tego seria
  /// kasowałaby się każdego ranka i licznik byłby bezużyteczny —
  /// pokazywałby zero przez większość doby.
  ///
  /// Zwraca 0, jeśli ostatnia sesja była wcześniej niż wczoraj.
  static int current(Set<String> practicedDayKeys, {DateTime? today}) {
    if (practicedDayKeys.isEmpty) return 0;

    final start = startOfDay(today ?? DateTime.now());
    var cursor =
        practicedDayKeys.contains(dayKey(start)) ? start : _yesterday(start);

    var streak = 0;
    while (practicedDayKeys.contains(dayKey(cursor))) {
      streak++;
      cursor = _yesterday(cursor);
    }
    return streak;
  }

  /// Najdłuższa seria w całej historii.
  static int longest(Set<String> practicedDayKeys) {
    if (practicedDayKeys.isEmpty) return 0;

    final days = practicedDayKeys.map(parseDayKey).toList()..sort();

    var best = 1;
    var run = 1;
    for (var i = 1; i < days.length; i++) {
      // Porównanie po dniach kalendarzowych, nie po różnicy czasu:
      // zmiana czasu z letniego na zimowy sprawia, że doba ma 23 lub 25
      // godzin, a `difference(...).inDays` gubi wtedy dzień.
      if (_isNextDay(days[i - 1], days[i])) {
        run++;
        if (run > best) best = run;
      } else {
        run = 1;
      }
    }
    return best;
  }

  static DateTime _yesterday(DateTime d) =>
      DateTime(d.year, d.month, d.day - 1);

  static bool _isNextDay(DateTime a, DateTime b) {
    final next = DateTime(a.year, a.month, a.day + 1);
    return next.year == b.year && next.month == b.month && next.day == b.day;
  }
}
