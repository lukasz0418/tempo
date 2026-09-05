import '../db/enums.dart';
import '../estimation/estimation.dart';
import '../util/dates.dart';

/// Zebrane liczby o jednym dniu. Same fakty, bez ocen.
class DayFacts {
  const DayFacts({
    required this.day,
    required this.split,
    required this.tracked,
    required this.tasksCompleted,
    required this.tasksPlanned,
    required this.longestFocus,
    required this.distractionSwitches,
    this.topDistraction,
    this.estimateStats = EstimateStats.empty,
    this.availableMinutes,
    this.plannedWork = Duration.zero,
  });

  final DateTime day;

  /// Czas wg klasy produktywności, z automatycznie wykrytej aktywności.
  final Map<Productivity, Duration> split;

  /// Czas zmierzony stoperem — czyli to, co świadomie śledziłeś.
  final Duration tracked;

  final int tasksCompleted;
  final int tasksPlanned;
  final Duration longestFocus;

  /// Ile razy przeskoczyłeś z pracy prosto w rozpraszacz.
  final int distractionSwitches;

  final ({String name, Duration time})? topDistraction;
  final EstimateStats estimateStats;

  /// Budżet czasu zadeklarowany rano.
  final int? availableMinutes;

  /// Suma estymat zadań zaplanowanych na ten dzień.
  final Duration plannedWork;

  Duration get productive => split[Productivity.productive] ?? Duration.zero;
  Duration get distraction => split[Productivity.distraction] ?? Duration.zero;
  Duration get leisure => split[Productivity.leisure] ?? Duration.zero;
  Duration get neutral => split[Productivity.neutral] ?? Duration.zero;
  Duration get unknown => split[Productivity.unknown] ?? Duration.zero;

  Duration get totalObserved =>
      productive + distraction + leisure + neutral + unknown;

  /// Udział czasu, którego nie umiemy zaklasyfikować.
  double get unknownShare {
    final total = totalObserved.inSeconds;
    return total == 0 ? 0 : unknown.inSeconds / total;
  }
}

/// Pojedynczy wniosek.
class ReviewNote {
  const ReviewNote(this.text, {this.detail});

  final String text;

  /// Konkret pod spodem — liczba, nazwa aplikacji, porównanie.
  final String? detail;
}

/// Werdykt dnia: co poszło dobrze, co nie, i co z tego wynika.
class DayVerdict {
  const DayVerdict({
    required this.headline,
    required this.wins,
    required this.problems,
    required this.observations,
  });

  final String headline;
  final List<ReviewNote> wins;
  final List<ReviewNote> problems;

  /// Rzeczy warte odnotowania, ale nieoceniane w żadną stronę.
  final List<ReviewNote> observations;

  bool get isEmpty =>
      wins.isEmpty && problems.isEmpty && observations.isEmpty;
}

/// Zamienia liczby o dniu w konkretne wnioski.
///
/// Dwie zasady, które rządzą tym plikiem:
///
///  * **Fakt zamiast morału.** „Rozpraszacze zjadły 3 h 20, praca 1 h 45"
///    jest użyteczne. „Marnujesz czas" nie jest — i po tygodniu takich
///    komunikatów przestaje się otwierać podsumowanie.
///  * **Cisza przy braku danych.** Jeśli w danym dniu nic nie mierzyłeś,
///    werdykt jest pusty. Wnioski z trzech próbek są gorsze niż ich brak.
abstract final class DayReviewer {
  // Progi. Wyciągnięte na wierzch, bo to jedyna rzecz, którą realnie
  // będziesz kręcić pod siebie po kilku tygodniach używania.
  static const _goodProductive = Duration(hours: 3);
  static const _decentProductive = Duration(hours: 1);
  static const _goodFocusBlock = Duration(minutes: 50);
  static const _fragmentedFocusBlock = Duration(minutes: 25);
  static const _lowDistraction = Duration(minutes: 30);
  static const _highDistraction = Duration(hours: 2);
  static const _manySwitches = 10;
  static const _fewSwitches = 3;
  static const _minObservedForVerdict = Duration(minutes: 30);

  static DayVerdict analyze(DayFacts f) {
    if (f.totalObserved < _minObservedForVerdict) {
      return DayVerdict(
        headline: 'Za mało danych, żeby cokolwiek powiedzieć o tym dniu.',
        wins: const [],
        problems: const [],
        observations: [
          ReviewNote(
            'Zmierzono tylko ${formatDuration(f.totalObserved)}.',
            detail: 'Włącz śledzenie aktywności albo dopisz wpisy ręcznie.',
          ),
        ],
      );
    }

    final wins = <ReviewNote>[];
    final problems = <ReviewNote>[];
    final observations = <ReviewNote>[];

    _judgeProductiveTime(f, wins, problems);
    _judgeFocus(f, wins, problems);
    _judgeDistraction(f, wins, problems);
    _judgeTasks(f, wins, problems);
    _judgePlanning(f, problems, observations);
    _judgeEstimates(f, wins, observations);
    _judgeCoverage(f, observations);

    return DayVerdict(
      headline: _headline(f),
      wins: wins,
      problems: problems,
      observations: observations,
    );
  }

  static String _headline(DayFacts f) {
    final p = f.productive;
    final d = f.distraction;

    if (p >= _goodProductive && d <= _lowDistraction) {
      return 'Bardzo dobry dzień: ${formatDuration(p)} roboty, '
          'rozpraszacze prawie nieobecne.';
    }
    if (d > p) {
      return 'Rozpraszacze wygrały z pracą: '
          '${formatDuration(d)} kontra ${formatDuration(p)}.';
    }
    if (p >= _goodProductive) {
      return 'Mocny dzień pracy: ${formatDuration(p)}.';
    }
    if (p >= _decentProductive) {
      return 'Przeciętny dzień: ${formatDuration(p)} realnej roboty.';
    }
    return 'Chudy dzień — ${formatDuration(p)} produktywnego czasu.';
  }

  static void _judgeProductiveTime(
      DayFacts f, List<ReviewNote> wins, List<ReviewNote> problems) {
    if (f.productive >= _goodProductive) {
      wins.add(ReviewNote(
        'Ponad ${_goodProductive.inHours} h produktywnego czasu',
        detail: formatDuration(f.productive),
      ));
    } else if (f.productive < _decentProductive &&
        f.totalObserved > const Duration(hours: 2)) {
      problems.add(ReviewNote(
        'Mało realnej pracy',
        detail: 'Tylko ${formatDuration(f.productive)} '
            'z ${formatDuration(f.totalObserved)} przy komputerze.',
      ));
    }
  }

  static void _judgeFocus(
      DayFacts f, List<ReviewNote> wins, List<ReviewNote> problems) {
    if (f.longestFocus >= _goodFocusBlock) {
      wins.add(ReviewNote(
        'Długi blok skupienia',
        detail: '${formatDuration(f.longestFocus)} bez przerwy.',
      ));
      return;
    }

    // Rozdrobnienie ma sens tylko wtedy, gdy w ogóle było co rozdrabniać.
    if (f.longestFocus < _fragmentedFocusBlock &&
        f.productive >= _decentProductive) {
      problems.add(ReviewNote(
        'Praca w kawałkach',
        detail: 'Najdłuższy nieprzerwany blok to '
            '${formatDuration(f.longestFocus)}.',
      ));
    }
  }

  static void _judgeDistraction(
      DayFacts f, List<ReviewNote> wins, List<ReviewNote> problems) {
    if (f.distraction <= _lowDistraction) {
      wins.add(ReviewNote(
        'Rozpraszacze pod kontrolą',
        detail: formatDuration(f.distraction),
      ));
    } else if (f.distraction >= _highDistraction) {
      final top = f.topDistraction;
      problems.add(ReviewNote(
        '${formatDuration(f.distraction)} na rozpraszaczach',
        detail: top == null
            ? null
            : 'Najwięcej: ${top.name} (${formatDuration(top.time)}).',
      ));
    }

    if (f.distractionSwitches >= _manySwitches) {
      problems.add(ReviewNote(
        'Przerywałeś sobie ${f.distractionSwitches} razy',
        detail: 'Tyle razy przeskoczyłeś z pracy prosto w rozpraszacz.',
      ));
    } else if (f.distractionSwitches <= _fewSwitches &&
        f.productive >= _decentProductive) {
      wins.add(const ReviewNote('Prawie bez przeskoków w rozpraszacze'));
    }
  }

  static void _judgeTasks(
      DayFacts f, List<ReviewNote> wins, List<ReviewNote> problems) {
    if (f.tasksPlanned == 0) {
      if (f.tasksCompleted > 0) {
        wins.add(ReviewNote('Zamknięte zadania: ${f.tasksCompleted}'));
      }
      return;
    }

    if (f.tasksCompleted >= f.tasksPlanned) {
      wins.add(ReviewNote(
        'Plan dnia wykonany',
        detail: '${f.tasksCompleted} z ${f.tasksPlanned} zadań.',
      ));
    } else if (f.tasksCompleted == 0) {
      problems.add(ReviewNote(
        'Żadne zaplanowane zadanie nie zostało zamknięte',
        detail: 'Zaplanowanych było ${f.tasksPlanned}.',
      ));
    } else {
      _judgePartialPlan(f, problems);
    }
  }

  /// Częściowe wykonanie planu nie jest ani sukcesem, ani porażką —
  /// ląduje jako problem tylko wtedy, gdy zostało naprawdę dużo.
  static void _judgePartialPlan(DayFacts f, List<ReviewNote> problems) {
    final done = f.tasksCompleted;
    final planned = f.tasksPlanned;
    if (planned >= 3 && done / planned < 0.34) {
      problems.add(ReviewNote(
        'Plan dnia w dużej części niewykonany',
        detail: '$done z $planned zadań.',
      ));
    }
  }

  static void _judgePlanning(
      DayFacts f, List<ReviewNote> problems, List<ReviewNote> observations) {
    final budget = f.availableMinutes;
    if (budget == null || f.plannedWork == Duration.zero) return;

    final planned = f.plannedWork.inMinutes;
    if (planned <= budget) return;

    // Przeplanowanie to najczęstszy powód, dla którego dzień „nie wyszedł".
    // Warto je nazwać po imieniu, bo inaczej wygląda na brak dyscypliny,
    // a było zwykłym błędem arytmetycznym o poranku.
    problems.add(ReviewNote(
      'Dzień był przeplanowany',
      detail: 'Zadania na ${formatDuration(Duration(minutes: planned))} '
          'przy budżecie ${formatDuration(Duration(minutes: budget))}.',
    ));
  }

  static void _judgeEstimates(
      DayFacts f, List<ReviewNote> wins, List<ReviewNote> observations) {
    final stats = f.estimateStats;
    if (!stats.isReliable) return;

    if ((stats.medianRatio - 1).abs() <= 0.15) {
      wins.add(ReviewNote(
        'Trafne estymaty',
        detail: stats.describe(),
      ));
    } else {
      observations.add(ReviewNote(
        'Twoje estymaty są systematycznie przesunięte',
        detail: stats.describe(),
      ));
    }
  }

  static void _judgeCoverage(DayFacts f, List<ReviewNote> observations) {
    if (f.unknownShare < 0.4) return;
    observations.add(ReviewNote(
      '${(f.unknownShare * 100).round()}% czasu bez klasyfikacji',
      detail: 'Dodaj reguły dla aplikacji z listy przeglądu, '
          'żeby statystyki miały sens.',
    ));
  }
}
