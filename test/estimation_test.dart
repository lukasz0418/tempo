import 'package:flutter_test/flutter_test.dart';
import 'package:tempo/core/db/daos/insight_dao.dart';
import 'package:tempo/core/estimation/estimation.dart';

EstimateSample sample(int estimatedMin, int actualMin) => EstimateSample(
      taskId: 't',
      title: 'zadanie',
      categoryId: null,
      estimated: Duration(minutes: estimatedMin),
      actual: Duration(minutes: actualMin),
    );

void main() {
  group('Estimator.stats', () {
    test('pusta lista nie wywraca się i nie twierdzi niczego', () {
      final stats = Estimator.stats([]);

      expect(stats.sampleCount, 0);
      expect(stats.isReliable, isFalse);
    });

    test('mediana odporna na pojedynczy skrajny wynik', () {
      // Osiem zadań szacowanych trafnie i jedno, które wybuchło.
      // Średnia poszłaby w kosmos; mediana ma zostać przy jedynce.
      final samples = [
        for (var i = 0; i < 8; i++) sample(30, 30),
        sample(30, 600),
      ];

      final stats = Estimator.stats(samples);

      expect(stats.medianRatio, closeTo(1.0, 0.01));
      expect(stats.isReliable, isTrue);
    });

    test('wykrywa systematyczny optymizm', () {
      final samples = [for (var i = 0; i < 10; i++) sample(30, 60)];

      final stats = Estimator.stats(samples);

      expect(stats.medianRatio, closeTo(2.0, 0.01));
      expect(stats.describe(), contains('200%'));
    });

    test('liczy udział zadań mieszczących się w zakresie', () {
      final samples = [
        for (var i = 0; i < 5; i++) sample(60, 60), // trafione
        for (var i = 0; i < 5; i++) sample(60, 180), // pudło
      ];

      final stats = Estimator.stats(samples);

      expect(stats.withinRangeShare, closeTo(0.5, 0.01));
    });
  });

  group('Estimator.adjust', () {
    test('nie rusza estymaty przy zbyt małej próbce', () {
      // Kluczowa własność: dopóki nie wiemy, jak szacujesz,
      // nie wolno „poprawiać" twojej liczby.
      final weak = Estimator.stats([for (var i = 0; i < 3; i++) sample(30, 90)]);

      final result = Estimator.adjust(const Duration(minutes: 30), weak);

      expect(result, const Duration(minutes: 30));
    });

    test('mnoży estymatę, gdy próbka jest wiarygodna', () {
      final strong =
          Estimator.stats([for (var i = 0; i < 10; i++) sample(30, 60)]);

      final result = Estimator.adjust(const Duration(minutes: 30), strong);

      expect(result, const Duration(minutes: 60));
    });

    test('null zostaje nullem', () {
      expect(Estimator.adjust(null, EstimateStats.empty), isNull);
    });
  });

  group('Estimator.suggestFrom', () {
    test('milczy przy mniej niż trzech próbkach', () {
      expect(
        Estimator.suggestFrom([const Duration(minutes: 30)]),
        isNull,
      );
    });

    test('zwraca kwartyle zamiast skrajności', () {
      final suggestion = Estimator.suggestFrom([
        const Duration(minutes: 30),
        const Duration(minutes: 40),
        const Duration(minutes: 45),
        const Duration(minutes: 50),
        const Duration(minutes: 180), // jednorazowy wyskok
      ]);

      expect(suggestion, isNotNull);
      expect(suggestion!.mid, const Duration(minutes: 45));
      // Górny kwartyl ma pozostać w okolicy realnej wartości,
      // a nie skoczyć do trzech godzin.
      expect(suggestion.high.inMinutes, lessThan(90));
    });
  });
}
