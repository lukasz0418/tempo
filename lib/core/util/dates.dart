/// Praca z datą kalendarzową jako tekstem `YYYY-MM-DD`.
///
/// Dzień w tej aplikacji to pojęcie **lokalne i bez strefy czasowej**:
/// „wtorek" jest wtorkiem niezależnie od tego, gdzie jesteś. Trzymanie go
/// jako `DateTime` w UTC kończy się tym, że po locie do innej strefy
/// wczorajsze wpisy przeskakują na dziś.
library;

String dayKey(DateTime d) {
  final local = d.isUtc ? d.toLocal() : d;
  final m = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '${local.year}-$m-$day';
}

String todayKey() => dayKey(DateTime.now());

DateTime parseDayKey(String key) => DateTime.parse('${key}T00:00:00');

/// Początek dnia lokalnego, jako moment w czasie.
DateTime startOfDay(DateTime d) {
  final local = d.isUtc ? d.toLocal() : d;
  return DateTime(local.year, local.month, local.day);
}

DateTime endOfDay(DateTime d) => startOfDay(d).add(const Duration(days: 1));

/// Poniedziałek tygodnia, w którym leży [d].
DateTime startOfWeek(DateTime d) {
  final s = startOfDay(d);
  return s.subtract(Duration(days: s.weekday - DateTime.monday));
}

/// Formatuje czas trwania krótko: `2 h 05`, `45 min`, `30 s`.
///
/// Sekundy pojawiają się tylko poniżej minuty — na liście dnia nikogo
/// nie interesuje, czy zadanie trwało 42 czy 43 sekundy, a dłuższe
/// napisy rozjeżdżają układ.
String formatDuration(Duration d) {
  if (d.inSeconds < 60) return '${d.inSeconds} s';
  if (d.inMinutes < 60) return '${d.inMinutes} min';
  final h = d.inHours;
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  return '$h h $m';
}

/// Wersja dla zakresu estymaty: `30–60 min`.
String formatEstimate(Duration? min, Duration? max) {
  if (min == null && max == null) return '—';
  if (min == null || max == null) return formatDuration(min ?? max!);
  if (min == max) return formatDuration(min);
  return '${formatDuration(min)}–${formatDuration(max)}';
}
