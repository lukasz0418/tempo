import 'package:drift/drift.dart';

import '../../util/dates.dart';
import '../../util/streak.dart';
import '../database.dart';
import '../enums.dart';
import '../sync_stamp.dart';
import '../tables.dart';

part 'goal_dao.g.dart';

/// Stan realizacji jednego celu.
class GoalProgress {
  const GoalProgress({
    required this.current,
    required this.target,
    required this.metric,
    this.deadline,
  });

  final int current;
  final int target;
  final GoalMetric metric;
  final DateTime? deadline;

  double get fraction => target <= 0 ? 0 : (current / target).clamp(0.0, 1.0);

  bool get isReached => current >= target;

  /// Ile dni zostało do terminu. Null, gdy celu nie ograniczono datą.
  int? get daysLeft {
    final d = deadline;
    if (d == null) return null;
    return startOfDay(d).difference(startOfDay(DateTime.now())).inDays;
  }

  bool get isOverdue => (daysLeft ?? 1) < 0;

  /// Opis postępu w jednostkach właściwych dla metryki.
  String describe() {
    return switch (metric) {
      GoalMetric.minutes =>
        '${formatDuration(Duration(minutes: current))} '
            'z ${formatDuration(Duration(minutes: target))}',
      GoalMetric.sessions => '$current z $target sesji',
      GoalMetric.streakDays => '$current z $target dni z rzędu',
      GoalMetric.practiceDays => '$current z $target dni ćwiczeń',
      GoalMetric.milestone => current >= 1 ? 'Osiągnięte' : 'Jeszcze nie',
      GoalMetric.custom => '$current z $target',
    };
  }
}

@DriftAccessor(tables: [Goals, TimeEntries, JournalEntries, Skills])
class GoalDao extends DatabaseAccessor<AppDatabase> with _$GoalDaoMixin {
  GoalDao(super.db);

  SimpleSelectStatement<$GoalsTable, Goal> _alive() =>
      select(goals)..where((g) => g.deleted.equals(false));

  Stream<List<Goal>> watchActive({String? skillId}) {
    final q = _alive()
      ..where((g) => g.status.equals(GoalStatus.active.name))
      ..orderBy([
        // Krótkoterminowe najpierw: to one mówią, co robić w tym tygodniu.
        (g) => OrderingTerm(expression: g.horizon),
        (g) => OrderingTerm(expression: g.deadline),
        (g) => OrderingTerm(expression: g.sortOrder),
      ]);
    if (skillId != null) q.where((g) => g.skillId.equals(skillId));
    return q.watch();
  }

  Stream<List<Goal>> watchForSkill(String skillId) {
    final q = _alive()
      ..where((g) => g.skillId.equals(skillId))
      ..orderBy([
        (g) => OrderingTerm(expression: g.status),
        (g) => OrderingTerm(expression: g.horizon),
        (g) => OrderingTerm(expression: g.deadline),
      ]);
    return q.watch();
  }

  Future<List<Goal>> childrenOf(String goalId) {
    return (_alive()..where((g) => g.parentGoalId.equals(goalId))).get();
  }

  Future<Goal?> byId(String id) =>
      (select(goals)..where((g) => g.id.equals(id))).getSingleOrNull();

  Future<String> create({
    required String title,
    String? skillId,
    String? parentGoalId,
    String? notes,
    GoalHorizon horizon = GoalHorizon.short,
    GoalMetric metric = GoalMetric.minutes,
    int targetValue = 1,
    DateTime? deadline,
    DateTime? startsFrom,
  }) async {
    final id = SyncStamp.newId();
    final now = SyncStamp.now();
    await into(goals).insert(GoalsCompanion.insert(
      id: id,
      title: title,
      // Postęp liczy się od założenia celu, nie od zawsze — inaczej cel
      // „przećwiczyć 50 godzin" byłby spełniony w chwili utworzenia
      // przez historię, która go poprzedza.
      startsFrom: startsFrom ?? now,
      createdAt: now,
      updatedAt: now,
      skillId: Value(skillId),
      parentGoalId: Value(parentGoalId),
      notes: Value(notes),
      horizon: Value(horizon),
      metric: Value(metric),
      targetValue: Value(metric == GoalMetric.milestone ? 1 : targetValue),
      deadline: Value(deadline),
      dirty: const Value(true),
    ));
    return id;
  }

  Future<void> save(GoalsCompanion patch) {
    assert(patch.id.present, 'save() wymaga id w companionie');
    return (update(goals)..where((g) => g.id.equals(patch.id.value))).write(
      patch.copyWith(
        updatedAt: Value(SyncStamp.now()),
        dirty: const Value(true),
      ),
    );
  }

  Future<void> setStatus(String id, GoalStatus status) => save(GoalsCompanion(
        id: Value(id),
        status: Value(status),
        achievedAt: Value(status == GoalStatus.achieved ? SyncStamp.now() : null),
      ));

  /// Podbija ręczny licznik. Dla kamienia milowego działa jak przełącznik.
  Future<void> bumpManual(String id, int delta) async {
    final goal = await byId(id);
    if (goal == null) return;

    final next = (goal.manualProgress + delta).clamp(0, 1 << 30);
    await save(GoalsCompanion(id: Value(id), manualProgress: Value(next)));

    // Cel ręczny domykamy sami — przy metrykach liczonych automatycznie
    // robi to [refreshAchievements].
    if (next >= goal.targetValue && goal.status == GoalStatus.active) {
      await setStatus(id, GoalStatus.achieved);
    }
  }

  Future<void> softDelete(String id) =>
      save(GoalsCompanion(id: Value(id), deleted: const Value(true)));

  Future<void> restore(String id) =>
      save(GoalsCompanion(id: Value(id), deleted: const Value(false)));

  /// Liczy postęp celu.
  ///
  /// Cztery z sześciu metryk wyliczają się z danych, które aplikacja zbiera
  /// i tak — nie trzeba niczego odhaczać, żeby cel się wypełniał.
  Future<GoalProgress> progress(Goal goal) async {
    final current = switch (goal.metric) {
      GoalMetric.milestone || GoalMetric.custom => goal.manualProgress,
      GoalMetric.minutes => (await _practicedTime(goal)).inMinutes,
      GoalMetric.sessions => (await _sessions(goal)).length,
      GoalMetric.practiceDays => (await _practiceDayKeys(goal)).length,
      GoalMetric.streakDays => Streaks.current(await _practiceDayKeys(goal)),
    };

    return GoalProgress(
      current: current,
      target: goal.targetValue,
      metric: goal.metric,
      deadline: goal.deadline,
    );
  }

  Future<List<TimeEntry>> _sessions(Goal goal) {
    return (select(timeEntries)
          ..where((t) {
            var cond = t.deleted.equals(false) &
                t.endedAt.isNotNull() &
                t.startedAt.isBiggerOrEqualValue(goal.startsFrom);
            // Cel ogólny (bez umiejętności) liczy cały mierzony czas.
            if (goal.skillId != null) {
              cond = cond & t.skillId.equals(goal.skillId!);
            }
            return cond;
          }))
        .get();
  }

  Future<Duration> _practicedTime(Goal goal) async {
    var total = Duration.zero;
    for (final e in await _sessions(goal)) {
      total += e.endedAt!.difference(e.startedAt);
    }
    return total;
  }

  /// Dni, w których cokolwiek się wydarzyło — sesja albo wpis w dzienniku.
  ///
  /// Wpis bez uruchomionego stopera też liczy się jako dzień ćwiczenia:
  /// zapomniany stoper nie powinien kasować serii, na której komuś zależy.
  Future<Set<String>> _practiceDayKeys(Goal goal) async {
    final days = <String>{
      for (final e in await _sessions(goal)) dayKey(e.startedAt.toLocal()),
    };

    if (goal.skillId != null) {
      final entries = await (select(journalEntries)
            ..where((j) =>
                j.skillId.equals(goal.skillId!) & j.deleted.equals(false)))
          .get();
      final from = dayKey(goal.startsFrom.toLocal());
      for (final j in entries) {
        // Porównanie tekstowe działa, bo klucz dnia ma format `YYYY-MM-DD`,
        // w którym porządek leksykograficzny pokrywa się z chronologicznym.
        if (j.date.compareTo(from) >= 0) days.add(j.date);
      }
    }
    return days;
  }

  /// Domyka cele, które właśnie zostały spełnione.
  ///
  /// Wywoływane po zatrzymaniu stopera. Bez tego cel liczony automatycznie
  /// wisiałby jako aktywny mimo osiągnięcia progu — i trzeba by go domykać
  /// ręcznie, czyli dokładnie tak, jak nie chcieliśmy.
  Future<List<Goal>> refreshAchievements() async {
    final active = await (_alive()
          ..where((g) => g.status.equals(GoalStatus.active.name)))
        .get();

    final justAchieved = <Goal>[];
    for (final goal in active) {
      if (goal.metric == GoalMetric.milestone ||
          goal.metric == GoalMetric.custom) {
        continue;
      }
      final p = await progress(goal);
      if (p.isReached) {
        await setStatus(goal.id, GoalStatus.achieved);
        justAchieved.add(goal);
      }
    }
    return justAchieved;
  }
}
