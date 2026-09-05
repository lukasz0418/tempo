import 'package:flutter_test/flutter_test.dart';
import 'package:tempo/core/db/enums.dart';
import 'package:tempo/core/estimation/estimation.dart';
import 'package:tempo/core/review/day_review.dart';

DayFacts facts({
  Duration productive = Duration.zero,
  Duration distraction = Duration.zero,
  Duration leisure = Duration.zero,
  Duration neutral = Duration.zero,
  Duration unknown = Duration.zero,
  int tasksCompleted = 0,
  int tasksPlanned = 0,
  Duration longestFocus = Duration.zero,
  int distractionSwitches = 0,
  ({String name, Duration time})? topDistraction,
  EstimateStats estimateStats = EstimateStats.empty,
  int? availableMinutes,
  Duration plannedWork = Duration.zero,
}) {
  return DayFacts(
    day: DateTime(2026, 3, 10),
    split: {
      Productivity.productive: productive,
      Productivity.distraction: distraction,
      Productivity.leisure: leisure,
      Productivity.neutral: neutral,
      Productivity.unknown: unknown,
    },
    tracked: productive,
    tasksCompleted: tasksCompleted,
    tasksPlanned: tasksPlanned,
    longestFocus: longestFocus,
    distractionSwitches: distractionSwitches,
    topDistraction: topDistraction,
    estimateStats: estimateStats,
    availableMinutes: availableMinutes,
    plannedWork: plannedWork,
  );
}

Iterable<String> textsOf(List<ReviewNote> notes) => notes.map((n) => n.text);

void main() {
  group('DayReviewer', () {
    test('milczy, gdy dzień jest praktycznie niezmierzony', () {
      // Wnioski z dziesięciu minut danych byłyby gorsze niż ich brak.
      final verdict = DayReviewer.analyze(
        facts(productive: const Duration(minutes: 10)),
      );

      expect(verdict.wins, isEmpty);
      expect(verdict.problems, isEmpty);
      expect(verdict.headline, contains('Za mało danych'));
    });

    test('mocny dzień trafia do sukcesów', () {
      final verdict = DayReviewer.analyze(facts(
        productive: const Duration(hours: 4),
        distraction: const Duration(minutes: 10),
        longestFocus: const Duration(minutes: 90),
        distractionSwitches: 1,
      ));

      expect(textsOf(verdict.wins), contains('Długi blok skupienia'));
      expect(verdict.headline, contains('Bardzo dobry dzień'));
      expect(verdict.problems, isEmpty);
    });

    test('nazywa po imieniu dzień przegrany z rozpraszaczami', () {
      final verdict = DayReviewer.analyze(facts(
        productive: const Duration(hours: 1),
        distraction: const Duration(hours: 3),
        longestFocus: const Duration(minutes: 40),
        topDistraction: (name: 'YouTube', time: const Duration(hours: 2)),
      ));

      expect(verdict.headline, contains('Rozpraszacze wygrały'));
      expect(
        verdict.problems.any((p) => p.detail?.contains('YouTube') ?? false),
        isTrue,
      );
    });

    test('wykrywa pracę porozbijaną na kawałki', () {
      final verdict = DayReviewer.analyze(facts(
        productive: const Duration(hours: 2),
        longestFocus: const Duration(minutes: 12),
        distractionSwitches: 14,
      ));

      expect(textsOf(verdict.problems), contains('Praca w kawałkach'));
      expect(
        verdict.problems.any((p) => p.text.contains('Przerywałeś sobie 14')),
        isTrue,
      );
    });

    test('przeplanowanie jest osobnym wnioskiem', () {
      // Najczęstszy powód „nieudanego" dnia to błąd arytmetyczny
      // o poranku, a nie brak dyscypliny — i tak ma być opisany.
      final verdict = DayReviewer.analyze(facts(
        productive: const Duration(hours: 2),
        longestFocus: const Duration(minutes: 60),
        availableMinutes: 180,
        plannedWork: const Duration(hours: 8),
        tasksPlanned: 6,
        tasksCompleted: 2,
      ));

      expect(textsOf(verdict.problems), contains('Dzień był przeplanowany'));
    });

    test('wykonany plan dnia to sukces', () {
      final verdict = DayReviewer.analyze(facts(
        productive: const Duration(hours: 2),
        longestFocus: const Duration(minutes: 60),
        tasksPlanned: 3,
        tasksCompleted: 3,
      ));

      expect(textsOf(verdict.wins), contains('Plan dnia wykonany'));
    });

    test('zerowe wykonanie planu to problem', () {
      final verdict = DayReviewer.analyze(facts(
        productive: const Duration(hours: 2),
        longestFocus: const Duration(minutes: 60),
        tasksPlanned: 4,
        tasksCompleted: 0,
      ));

      expect(
        textsOf(verdict.problems),
        contains('Żadne zaplanowane zadanie nie zostało zamknięte'),
      );
    });

    test('duży udział czasu bez klasyfikacji trafia do obserwacji', () {
      final verdict = DayReviewer.analyze(facts(
        productive: const Duration(hours: 1),
        unknown: const Duration(hours: 3),
        longestFocus: const Duration(minutes: 30),
      ));

      expect(
        verdict.observations.any((o) => o.text.contains('bez klasyfikacji')),
        isTrue,
      );
    });

    test('nie ocenia estymat przy niewiarygodnej próbce', () {
      final weak = EstimateStats(
        sampleCount: 2,
        medianRatio: 3,
        withinRangeShare: 0,
      );

      final verdict = DayReviewer.analyze(facts(
        productive: const Duration(hours: 2),
        longestFocus: const Duration(minutes: 60),
        estimateStats: weak,
      ));

      expect(
        verdict.observations.any((o) => o.text.contains('estymaty')),
        isFalse,
      );
    });
  });
}
