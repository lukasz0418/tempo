import 'package:drift/drift.dart';

import '../../util/dates.dart';
import '../../util/streak.dart';
import '../database.dart';
import '../sync_stamp.dart';
import '../tables.dart';

part 'skill_dao.g.dart';

/// Postęp w jednej umiejętności.
///
/// Trzy liczby obok siebie, bo żadna z osobna nie wystarcza: można
/// przećwiczyć dwieście godzin bez ruchu do przodu, można ćwiczyć
/// codziennie po pięć minut, i można mieć świetną regularność przy
/// poczuciu, że się stoi w miejscu.
class SkillProgress {
  const SkillProgress({
    required this.total,
    required this.last30Days,
    required this.daysPracticedLast30,
    required this.currentStreak,
    required this.sessionCount,
    required this.milestoneCount,
    this.averageRating,
    this.ratingTrend = const [],
    this.lastPracticedAt,
  });

  /// Suma zmierzonego czasu od zawsze.
  final Duration total;

  final Duration last30Days;

  /// Ile z ostatnich trzydziestu dni miało choć jedną sesję.
  ///
  /// Przy nauce to mocniejszy predyktor postępu niż suma godzin —
  /// dlatego stoi obok niej, a nie pod nią.
  final int daysPracticedLast30;

  /// Ile dni z rzędu do dziś włącznie.
  final int currentStreak;

  final int sessionCount;
  final int milestoneCount;

  final double? averageRating;

  /// Samooceny w czasie, od najstarszej. Do wykresu trendu.
  final List<({DateTime date, int rating})> ratingTrend;

  final DateTime? lastPracticedAt;

  static const empty = SkillProgress(
    total: Duration.zero,
    last30Days: Duration.zero,
    daysPracticedLast30: 0,
    currentStreak: 0,
    sessionCount: 0,
    milestoneCount: 0,
  );

  /// Udział dni ćwiczonych w ostatnim miesiącu, 0..1.
  double get consistency => daysPracticedLast30 / 30;
}

@DriftAccessor(tables: [Skills, TimeEntries, JournalEntries])
class SkillDao extends DatabaseAccessor<AppDatabase> with _$SkillDaoMixin {
  SkillDao(super.db);

  SimpleSelectStatement<$SkillsTable, Skill> _alive() =>
      select(skills)..where((s) => s.deleted.equals(false));

  Stream<List<Skill>> watchActive() {
    final q = _alive()
      ..where((s) => s.archived.equals(false))
      ..orderBy([
        (s) => OrderingTerm(expression: s.sortOrder),
        (s) => OrderingTerm(expression: s.name),
      ]);
    return q.watch();
  }

  Stream<List<Skill>> watchAll() {
    final q = _alive()
      ..orderBy([
        (s) => OrderingTerm(expression: s.archived),
        (s) => OrderingTerm(expression: s.sortOrder),
      ]);
    return q.watch();
  }

  Future<Skill?> byId(String id) =>
      (select(skills)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<String> create({
    required String name,
    required int color,
    String? intent,
    String? icon,
    int? weeklyTargetMinutes,
  }) async {
    final id = SyncStamp.newId();
    final now = SyncStamp.now();
    await into(skills).insert(SkillsCompanion.insert(
      id: id,
      name: name,
      color: color,
      createdAt: now,
      updatedAt: now,
      intent: Value(intent),
      icon: Value(icon),
      startedAt: Value(now),
      weeklyTargetMinutes: Value(weeklyTargetMinutes),
      dirty: const Value(true),
    ));
    return id;
  }

  Future<void> save(SkillsCompanion patch) {
    assert(patch.id.present, 'save() wymaga id w companionie');
    return (update(skills)..where((s) => s.id.equals(patch.id.value))).write(
      patch.copyWith(
        updatedAt: Value(SyncStamp.now()),
        dirty: const Value(true),
      ),
    );
  }

  Future<void> setArchived(String id, {required bool archived}) =>
      save(SkillsCompanion(id: Value(id), archived: Value(archived)));

  Future<void> softDelete(String id) =>
      save(SkillsCompanion(id: Value(id), deleted: const Value(true)));

  Future<void> restore(String id) =>
      save(SkillsCompanion(id: Value(id), deleted: const Value(false)));

  /// Liczy komplet statystyk dla jednej umiejętności.
  Future<SkillProgress> progress(String skillId) async {
    final entries = await (select(timeEntries)
          ..where((t) =>
              t.skillId.equals(skillId) &
              t.deleted.equals(false) &
              t.endedAt.isNotNull()))
        .get();

    final journal = await (select(journalEntries)
          ..where((j) => j.skillId.equals(skillId) & j.deleted.equals(false))
          ..orderBy([(j) => OrderingTerm(expression: j.date)]))
        .get();

    if (entries.isEmpty && journal.isEmpty) return SkillProgress.empty;

    final cutoff = startOfDay(DateTime.now()).subtract(const Duration(days: 29));

    var total = Duration.zero;
    var last30 = Duration.zero;
    DateTime? lastAt;
    final practicedDays = <String>{};

    for (final e in entries) {
      final duration = e.endedAt!.difference(e.startedAt);
      total += duration;

      final localStart = e.startedAt.toLocal();
      if (!localStart.isBefore(cutoff)) {
        last30 += duration;
        practicedDays.add(dayKey(localStart));
      }
      if (lastAt == null || localStart.isAfter(lastAt)) lastAt = localStart;
    }

    // Wpisy w dzienniku też liczą się jako dzień ćwiczenia — notatka bez
    // uruchomionego stopera nadal znaczy, że tego dnia coś robiłeś.
    final allPracticedDays = <String>{...practicedDays};
    for (final j in journal) {
      final date = DateTime.tryParse(j.date);
      if (date != null && !date.isBefore(cutoff)) {
        allPracticedDays.add(j.date);
      }
    }

    final ratings = journal
        .where((j) => j.selfRating != null)
        .map((j) => (
              date: DateTime.tryParse(j.date) ?? DateTime.now(),
              rating: j.selfRating!,
            ))
        .toList();

    final average = ratings.isEmpty
        ? null
        : ratings.map((r) => r.rating).reduce((a, b) => a + b) / ratings.length;

    return SkillProgress(
      total: total,
      last30Days: last30,
      daysPracticedLast30: allPracticedDays.length,
      currentStreak: Streaks.current(_allDayKeys(entries, journal)),
      sessionCount: entries.length,
      milestoneCount: journal.where((j) => j.isMilestone).length,
      averageRating: average,
      ratingTrend: ratings,
      lastPracticedAt: lastAt,
    );
  }

  static Set<String> _allDayKeys(
      List<TimeEntry> entries, List<JournalEntry> journal) {
    return {
      for (final e in entries) dayKey(e.startedAt.toLocal()),
      for (final j in journal) j.date,
    };
  }

}
