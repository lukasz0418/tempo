import '../db/daos/insight_dao.dart';

/// Statystyka trafności twoich estymat.
class EstimateStats {
  const EstimateStats({
    required this.sampleCount,
    required this.medianRatio,
    required this.withinRangeShare,
  });

  final int sampleCount;

  /// Mediana ilorazu „czas rzeczywisty / estymata".
  ///
  /// Mediana, nie średnia: jedno zadanie, które miało zająć 15 minut,
  /// a zeżarło pół dnia, wywindowałoby średnią do bzdury i mnożnik
  /// przestałby cokolwiek znaczyć.
  final double medianRatio;

  /// Jaki ułamek zadań zmieścił się w zadeklarowanym zakresie (±25%).
  final double withinRangeShare;

  /// Czy próbka jest na tyle duża, żeby w ogóle coś twierdzić.
  ///
  /// Poniżej tego progu aplikacja milczy zamiast pokazywać mnożnik
  /// policzony z trzech zadań — fałszywa precyzja jest gorsza
  /// niż uczciwe „za mało danych".
  bool get isReliable => sampleCount >= minimumSamples;

  static const minimumSamples = 8;

  static const empty =
      EstimateStats(sampleCount: 0, medianRatio: 1, withinRangeShare: 0);

  /// Krótki opis po polsku albo null, gdy brak podstaw do wniosków.
  String? describe() {
    if (!isReliable) {
      return 'Za mało danych — potrzeba $minimumSamples zamkniętych zadań '
          'z estymatą (masz $sampleCount).';
    }
    final pct = (medianRatio * 100).round();
    if (medianRatio >= 1.15) {
      return 'Zadania zajmują ci zwykle $pct% zakładanego czasu. '
          'Mnożysz estymaty przez ${medianRatio.toStringAsFixed(1)}.';
    }
    if (medianRatio <= 0.85) {
      return 'Kończysz szybciej, niż zakładasz — zwykle $pct% estymaty.';
    }
    return 'Szacujesz trafnie: mediana $pct% estymaty.';
  }
}

/// Liczy trafność estymat i podpowiada skorygowany czas.
abstract final class Estimator {
  /// Zadanie uznajemy za „w zakresie", jeśli zmieściło się w ±25%
  /// środka estymaty. Sztywne trafienie co do minuty nie zdarza się
  /// nikomu i nie ma sensu tego mierzyć.
  static const _tolerance = 0.25;

  static EstimateStats stats(List<EstimateSample> samples) {
    if (samples.isEmpty) return EstimateStats.empty;

    final ratios = samples.map((s) => s.ratio).toList()..sort();
    final median = _median(ratios);

    final within = samples
        .where((s) => (s.ratio - 1).abs() <= _tolerance)
        .length;

    return EstimateStats(
      sampleCount: samples.length,
      medianRatio: median,
      withinRangeShare: within / samples.length,
    );
  }

  static double _median(List<double> sorted) {
    if (sorted.isEmpty) return 1;
    final mid = sorted.length ~/ 2;
    if (sorted.length.isOdd) return sorted[mid];
    return (sorted[mid - 1] + sorted[mid]) / 2;
  }

  /// Koryguje estymatę użytkownika o jego historyczny optymizm.
  ///
  /// Zwraca wejście bez zmian, jeśli próbka jest za mała — lepiej nie ruszać
  /// niż „poprawiać" na podstawie trzech zadań.
  static Duration? adjust(Duration? raw, EstimateStats stats) {
    if (raw == null) return null;
    if (!stats.isReliable) return raw;
    return Duration(
      seconds: (raw.inSeconds * stats.medianRatio).round(),
    );
  }

  /// Podpowiedź na podstawie historii podobnych zadań.
  ///
  /// Zwraca medianę czasu rzeczywistego oraz zakres międzykwartylowy,
  /// czyli „ostatnio zajmowało to 35–50 minut, najczęściej 42".
  /// Kwartyle, a nie minimum i maksimum: jeden dzień, w którym zakupy
  /// trwały trzy godziny, bo utknąłeś w korku, nie może rozciągać
  /// podpowiedzi na zawsze.
  static ({Duration low, Duration mid, Duration high})? suggestFrom(
    List<Duration> pastDurations,
  ) {
    if (pastDurations.length < 3) return null;

    final sorted = [...pastDurations]..sort();
    final seconds = sorted.map((d) => d.inSeconds.toDouble()).toList();

    return (
      low: Duration(seconds: _quantile(seconds, 0.25).round()),
      mid: Duration(seconds: _median(seconds).round()),
      high: Duration(seconds: _quantile(seconds, 0.75).round()),
    );
  }

  static double _quantile(List<double> sorted, double q) {
    if (sorted.isEmpty) return 0;
    if (sorted.length == 1) return sorted.first;
    final pos = (sorted.length - 1) * q;
    final lo = pos.floor();
    final hi = pos.ceil();
    if (lo == hi) return sorted[lo];
    return sorted[lo] + (sorted[hi] - sorted[lo]) * (pos - lo);
  }
}
