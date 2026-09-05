import 'package:drift/drift.dart';

import '../../util/dates.dart';
import '../database.dart';
import '../enums.dart';
import '../sync_stamp.dart';
import '../tables.dart';

part 'insight_dao.g.dart';

/// Para „ile szacowałem / ile zajęło" dla jednego zadania.
class EstimateSample {
  const EstimateSample({
    required this.taskId,
    required this.title,
    required this.categoryId,
    required this.estimated,
    required this.actual,
  });

  final String taskId;
  final String title;
  final String? categoryId;

  /// Środek zakresu estymaty.
  final Duration estimated;
  final Duration actual;

  /// Ile razy dłużej, niż zakładałeś. 1.0 = trafiona estymata.
  double get ratio =>
      estimated.inSeconds == 0 ? 1 : actual.inSeconds / estimated.inSeconds;
}

/// Ile czasu poszło w którą klasę.
typedef ProductivitySplit = Map<Productivity, Duration>;

@DriftAccessor(tables: [Tasks, TimeEntries, AppUsages, Categories, DayPlans])
class InsightDao extends DatabaseAccessor<AppDatabase> with _$InsightDaoMixin {
  InsightDao(super.db);

  /// Podział czasu wg klasy produktywności, liczony z **automatycznie
  /// wykrytej aktywności**.
  ///
  /// Świadomie z [AppUsages], nie z [TimeEntries]: stoper pokazuje, co
  /// *chciałeś* robić, a ta tabela — co faktycznie działo się na ekranie.
  /// Do pytania „gdzie ucieka czas" liczy się tylko to drugie.
  Future<ProductivitySplit> productivitySplit(DateTime from, DateTime to) async {
    final sum = appUsages.durationSeconds.sum();
    final q = selectOnly(appUsages)
      ..addColumns([appUsages.productivity, sum])
      ..where(appUsages.deleted.equals(false) &
          appUsages.idle.equals(false) &
          appUsages.startedAt.isBiggerOrEqualValue(from.toUtc()) &
          appUsages.startedAt.isSmallerThanValue(to.toUtc()))
      ..groupBy([appUsages.productivity]);

    final out = <Productivity, Duration>{};
    for (final row in await q.get()) {
      final p = row.readWithConverter(appUsages.productivity) ??
          Productivity.unknown;
      out[p] = Duration(seconds: row.read(sum) ?? 0);
    }
    return out;
  }

  Stream<ProductivitySplit> watchProductivitySplit(DateTime day) {
    // Strumień oparty o tabelę źródłową: każda nowa próbka odświeża widok.
    return appUsages
        .select()
        .watch()
        .asyncMap((_) => productivitySplit(startOfDay(day), endOfDay(day)));
  }

  /// Podział zmierzonego czasu wg kategorii — tu już z [TimeEntries],
  /// bo pytanie brzmi „na co poszedł mój świadomy czas", a nie
  /// „co było na ekranie".
  Future<Map<String?, Duration>> categorySplit(
      DateTime from, DateTime to) async {
    final rows = await (select(timeEntries)
          ..where((t) =>
              t.deleted.equals(false) &
              t.endedAt.isNotNull() &
              t.startedAt.isBiggerOrEqualValue(from.toUtc()) &
              t.startedAt.isSmallerThanValue(to.toUtc())))
        .get();

    final out = <String?, Duration>{};
    for (final e in rows) {
      final d = e.endedAt!.difference(e.startedAt);
      out[e.categoryId] = (out[e.categoryId] ?? Duration.zero) + d;
    }
    return out;
  }

  /// Zamknięte zadania z estymatą i zmierzonym czasem.
  ///
  /// Podstawa „współczynnika optymizmu". Bierzemy tylko zadania, które
  /// naprawdę mierzyłeś — zadanie odhaczone bez ani jednej sekundy pomiaru
  /// nic nie mówi o twoim szacowaniu, a wciągnięte do statystyki
  /// zaniżałoby mnożnik do zera.
  Future<List<EstimateSample>> estimateSamples({
    String? categoryId,
    int limit = 200,
  }) async {
    final q = select(tasks)
      ..where((t) =>
          t.deleted.equals(false) &
          t.status.equals(TaskStatus.done.name) &
          t.estimateMinSeconds.isNotNull())
      ..orderBy([
        (t) => OrderingTerm(expression: t.completedAt, mode: OrderingMode.desc)
      ])
      ..limit(limit);
    if (categoryId != null) {
      q.where((t) => t.categoryId.equals(categoryId));
    }

    final rows = await q.get();
    final out = <EstimateSample>[];

    for (final t in rows) {
      final entries = await (select(timeEntries)
            ..where((e) =>
                e.taskId.equals(t.id) &
                e.deleted.equals(false) &
                e.endedAt.isNotNull()))
          .get();
      if (entries.isEmpty) continue;

      var actual = Duration.zero;
      for (final e in entries) {
        actual += e.endedAt!.difference(e.startedAt);
      }

      final lo = t.estimateMinSeconds ?? 0;
      final hi = t.estimateMaxSeconds ?? lo;
      out.add(EstimateSample(
        taskId: t.id,
        title: t.title,
        categoryId: t.categoryId,
        estimated: Duration(seconds: (lo + hi) ~/ 2),
        actual: actual,
      ));
    }
    return out;
  }

  /// Rozkład aktywności po godzinach doby (0–23) dla danej klasy.
  /// Zasila mapę „kiedy realnie jestem produktywny".
  Future<List<Duration>> hourlyHeatmap(
    DateTime from,
    DateTime to, {
    Productivity? only,
  }) async {
    final rows = await (select(appUsages)
          ..where((t) =>
              t.deleted.equals(false) &
              t.idle.equals(false) &
              t.startedAt.isBiggerOrEqualValue(from.toUtc()) &
              t.startedAt.isSmallerThanValue(to.toUtc())))
        .get();

    final buckets = List.filled(24, Duration.zero);
    for (final r in rows) {
      if (only != null && r.productivity != only) continue;
      // Blok przypisujemy do godziny jego startu (czas lokalny).
      // Uproszczenie: dwugodzinny blok nie jest rozbijany między kubełki.
      // Dla pytania „o której siadam do roboty" to bez znaczenia,
      // a rozbijanie kosztowałoby pętlę po minutach.
      final hour = r.startedAt.toLocal().hour;
      buckets[hour] += Duration(seconds: r.durationSeconds);
    }
    return buckets;
  }

  /// Najdłuższy nieprzerwany blok produktywny w danym dniu.
  Future<Duration> longestFocusBlock(DateTime day) async {
    final rows = await (select(appUsages)
          ..where((t) =>
              t.deleted.equals(false) &
              t.idle.equals(false) &
              t.productivity.equals(Productivity.productive.name) &
              t.startedAt.isBiggerOrEqualValue(startOfDay(day).toUtc()) &
              t.startedAt.isSmallerThanValue(endOfDay(day).toUtc()))
          ..orderBy([(t) => OrderingTerm(expression: t.startedAt)]))
        .get();
    if (rows.isEmpty) return Duration.zero;

    // Bloki oddzielone przerwą krótszą niż 5 minut traktujemy jako jeden
    // ciąg skupienia — zerknięcie w telefon nie kończy godziny pracy.
    const tolerance = Duration(minutes: 5);
    var best = Duration.zero;
    var current = Duration(seconds: rows.first.durationSeconds);
    var cursor = rows.first.endedAt;

    for (final r in rows.skip(1)) {
      if (r.startedAt.difference(cursor) <= tolerance) {
        current += Duration(seconds: r.durationSeconds);
      } else {
        if (current > best) best = current;
        current = Duration(seconds: r.durationSeconds);
      }
      cursor = r.endedAt;
    }
    return current > best ? current : best;
  }

  /// Ile razy w ciągu dnia przeskoczyłeś z pracy w rozpraszacz.
  ///
  /// Sama liczba minut nie oddaje kosztu: pięć przerwanych godzin boli
  /// bardziej niż jedna godzina obejrzana świadomie.
  Future<int> distractionSwitches(DateTime day) async {
    final rows = await (select(appUsages)
          ..where((t) =>
              t.deleted.equals(false) &
              t.idle.equals(false) &
              t.startedAt.isBiggerOrEqualValue(startOfDay(day).toUtc()) &
              t.startedAt.isSmallerThanValue(endOfDay(day).toUtc()))
          ..orderBy([(t) => OrderingTerm(expression: t.startedAt)]))
        .get();

    var switches = 0;
    Productivity? prev;
    for (final r in rows) {
      if (prev == Productivity.productive &&
          r.productivity == Productivity.distraction) {
        switches++;
      }
      prev = r.productivity;
    }
    return switches;
  }

  Future<List<Task>> tasksCompletedOn(DateTime day) {
    return (select(tasks)
          ..where((t) =>
              t.deleted.equals(false) &
              t.completedAt.isBiggerOrEqualValue(startOfDay(day).toUtc()) &
              t.completedAt.isSmallerThanValue(endOfDay(day).toUtc())))
        .get();
  }

  Future<List<Task>> tasksPlannedFor(String day) {
    return (select(tasks)
          ..where((t) => t.deleted.equals(false) & t.plannedFor.equals(day)))
        .get();
  }

  Future<Duration> trackedTimeOn(DateTime day) async {
    final rows = await (select(timeEntries)
          ..where((t) =>
              t.deleted.equals(false) &
              t.endedAt.isNotNull() &
              t.startedAt.isBiggerOrEqualValue(startOfDay(day).toUtc()) &
              t.startedAt.isSmallerThanValue(endOfDay(day).toUtc())))
        .get();
    var total = Duration.zero;
    for (final e in rows) {
      total += e.endedAt!.difference(e.startedAt);
    }
    return total;
  }

  Future<DayPlan?> dayPlan(String day) {
    return (select(dayPlans)..where((t) => t.date.equals(day)))
        .getSingleOrNull();
  }

  Stream<DayPlan?> watchDayPlan(String day) {
    return (select(dayPlans)..where((t) => t.date.equals(day)))
        .watchSingleOrNull();
  }

  /// Zapisuje plan i podsumowanie dnia.
  ///
  /// Upsert po dacie, bo wiersz powstaje w różnych momentach: rano przy
  /// ustawianiu budżetu czasu albo dopiero wieczorem przy rozliczeniu.
  /// Przekazanie `null` w polu zostawia dotychczasową wartość — inaczej
  /// zapis podsumowania kasowałby poranną intencję.
  Future<void> saveDayPlan(
    String day, {
    int? availableMinutes,
    String? intention,
    String? wins,
    String? struggles,
    String? changeTomorrow,
    int? moodEnd,
    bool markReviewed = false,
  }) async {
    final now = SyncStamp.now();
    final existing = await dayPlan(day);

    if (existing == null) {
      await into(dayPlans).insert(DayPlansCompanion.insert(
        id: SyncStamp.newId(),
        date: day,
        createdAt: now,
        updatedAt: now,
        availableMinutes: Value(availableMinutes),
        intention: Value(intention),
        wins: Value(wins),
        struggles: Value(struggles),
        changeTomorrow: Value(changeTomorrow),
        moodEnd: Value(moodEnd),
        reviewedAt: Value(markReviewed ? now : null),
        dirty: const Value(true),
      ));
      return;
    }

    await (update(dayPlans)..where((t) => t.id.equals(existing.id))).write(
      DayPlansCompanion(
        availableMinutes: availableMinutes == null
            ? const Value.absent()
            : Value(availableMinutes),
        intention: intention == null ? const Value.absent() : Value(intention),
        wins: wins == null ? const Value.absent() : Value(wins),
        struggles:
            struggles == null ? const Value.absent() : Value(struggles),
        changeTomorrow: changeTomorrow == null
            ? const Value.absent()
            : Value(changeTomorrow),
        moodEnd: moodEnd == null ? const Value.absent() : Value(moodEnd),
        reviewedAt: markReviewed ? Value(now) : const Value.absent(),
        updatedAt: Value(now),
        dirty: const Value(true),
      ),
    );
  }
}
