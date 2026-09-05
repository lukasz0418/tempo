import 'package:flutter_test/flutter_test.dart';
import 'package:tempo/core/db/daos/goal_dao.dart';
import 'package:tempo/core/db/enums.dart';

GoalProgress progress({
  int current = 0,
  int target = 10,
  GoalMetric metric = GoalMetric.sessions,
  DateTime? deadline,
}) {
  return GoalProgress(
    current: current,
    target: target,
    metric: metric,
    deadline: deadline,
  );
}

void main() {
  group('GoalProgress.fraction', () {
    test('liczy udział', () {
      expect(progress(current: 5, target: 10).fraction, 0.5);
    });

    test('nie przekracza jedynki po przebiciu celu', () {
      // Pasek postępu przy 150% wyglądałby na zepsuty.
      expect(progress(current: 15, target: 10).fraction, 1.0);
    });

    test('cel zerowy nie dzieli przez zero', () {
      expect(progress(current: 5, target: 0).fraction, 0);
    });
  });

  group('GoalProgress.isReached', () {
    test('dokładne trafienie liczy się jako osiągnięte', () {
      expect(progress(current: 10, target: 10).isReached, isTrue);
    });

    test('brak jednego to jeszcze nie', () {
      expect(progress(current: 9, target: 10).isReached, isFalse);
    });
  });

  group('GoalProgress.daysLeft', () {
    test('bez terminu zwraca null i nie jest po czasie', () {
      final p = progress();

      expect(p.daysLeft, isNull);
      expect(p.isOverdue, isFalse);
    });

    test('termin w przyszłości daje dodatnią liczbę dni', () {
      final p = progress(
        deadline: DateTime.now().add(const Duration(days: 5)),
      );

      expect(p.daysLeft, 5);
      expect(p.isOverdue, isFalse);
    });

    test('termin dzisiaj to zero dni, jeszcze nie po czasie', () {
      final p = progress(deadline: DateTime.now());

      expect(p.daysLeft, 0);
      expect(p.isOverdue, isFalse);
    });

    test('termin w przeszłości oznacza przekroczenie', () {
      final p = progress(
        deadline: DateTime.now().subtract(const Duration(days: 3)),
      );

      expect(p.daysLeft, -3);
      expect(p.isOverdue, isTrue);
    });
  });

  group('GoalProgress.describe', () {
    test('minuty pokazuje jako czas, nie jako liczbę', () {
      final text = progress(
        current: 90,
        target: 600,
        metric: GoalMetric.minutes,
      ).describe();

      // 90 minut ma się pokazać jako „1 h 30", a nie „90".
      expect(text, contains('1 h 30'));
      expect(text, contains('10 h'));
    });

    test('kamień milowy jest zero-jedynkowy', () {
      expect(
        progress(current: 0, target: 1, metric: GoalMetric.milestone)
            .describe(),
        'Jeszcze nie',
      );
      expect(
        progress(current: 1, target: 1, metric: GoalMetric.milestone)
            .describe(),
        'Osiągnięte',
      );
    });

    test('sesje i dni mają własne jednostki', () {
      expect(
        progress(current: 3, target: 10, metric: GoalMetric.sessions)
            .describe(),
        '3 z 10 sesji',
      );
      expect(
        progress(current: 4, target: 30, metric: GoalMetric.streakDays)
            .describe(),
        '4 z 30 dni z rzędu',
      );
    });
  });
}
