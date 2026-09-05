import 'package:drift/drift.dart';

import '../../util/dates.dart';
import '../database.dart';
import '../enums.dart';
import '../sync_stamp.dart';
import '../tables.dart';

part 'app_usage_dao.g.dart';

@DriftAccessor(tables: [AppUsages, ActivityRules, Categories])
class AppUsageDao extends DatabaseAccessor<AppDatabase>
    with _$AppUsageDaoMixin {
  AppUsageDao(super.db);

  /// Maksymalna przerwa, przy której próbka wciąż dokleja się do
  /// poprzedniego bloku. Pomiar chodzi co ~5 s, więc 30 s znosi
  /// zgubione takty (uśpiony ekran, chwilowe zawieszenie) bez sklejania
  /// dwóch osobnych sesji tej samej aplikacji w jedną.
  static const _mergeGap = Duration(seconds: 30);

  SimpleSelectStatement<$AppUsagesTable, AppUsage> _alive() =>
      select(appUsages)..where((t) => t.deleted.equals(false));

  /// Dopisuje próbkę aktywności, doklejając ją do trwającego bloku,
  /// jeśli to wciąż ta sama aplikacja.
  ///
  /// Bez scalania pomiar co 5 sekund produkowałby ~17 tysięcy wierszy
  /// na dobę i statystyki miesięczne stałyby się nie do policzenia.
  /// Zamiast tego jeden blok „VS Code, 14:00–15:32" rośnie w miejscu.
  Future<void> record({
    required String deviceId,
    required DevicePlatform platform,
    required String appId,
    required String appName,
    String? windowTitle,
    required DateTime at,
    required Duration sampleLength,
    required Productivity productivity,
    String? ruleId,
    String? categoryId,
    bool idle = false,
  }) async {
    final now = SyncStamp.now();
    final endedAt = at.toUtc();
    final startedAt = endedAt.subtract(sampleLength);

    final last = await (_alive()
          ..where((t) => t.deviceId.equals(deviceId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.endedAt, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .getSingleOrNull();

    final canMerge = last != null &&
        last.appId == appId &&
        last.windowTitle == windowTitle &&
        last.idle == idle &&
        !last.reviewed &&
        endedAt.difference(last.endedAt) <= _mergeGap + sampleLength;

    if (canMerge) {
      final newEnd = endedAt.isAfter(last.endedAt) ? endedAt : last.endedAt;
      await (update(appUsages)..where((t) => t.id.equals(last.id))).write(
        AppUsagesCompanion(
          endedAt: Value(newEnd),
          durationSeconds:
              Value(newEnd.difference(last.startedAt).inSeconds),
          updatedAt: Value(now),
          dirty: const Value(true),
        ),
      );
      return;
    }

    await into(appUsages).insert(AppUsagesCompanion.insert(
      id: SyncStamp.newId(),
      deviceId: deviceId,
      appId: appId,
      startedAt: startedAt,
      endedAt: endedAt,
      durationSeconds: sampleLength.inSeconds,
      createdAt: now,
      updatedAt: now,
      platform: Value(platform),
      appName: Value(appName),
      windowTitle: Value(windowTitle),
      productivity: Value(productivity),
      ruleId: Value(ruleId),
      categoryId: Value(categoryId),
      idle: Value(idle),
      dirty: const Value(true),
    ));
  }

  /// Wstawia gotowy przedział — używane przez import z Androida,
  /// gdzie `UsageStatsManager` oddaje od razu całe odcinki wstecz,
  /// więc nie ma czego scalać.
  Future<void> insertInterval({
    required String deviceId,
    required DevicePlatform platform,
    required String appId,
    required String appName,
    required DateTime startedAt,
    required DateTime endedAt,
    required Productivity productivity,
    String? ruleId,
    String? categoryId,
  }) async {
    final now = SyncStamp.now();
    final from = startedAt.toUtc();
    final to = endedAt.toUtc();

    // Import bywa uruchamiany wielokrotnie na zachodzącym na siebie oknie
    // czasu, więc odsiewamy odcinki, które już mamy.
    final dup = await (_alive()
          ..where((t) =>
              t.deviceId.equals(deviceId) &
              t.appId.equals(appId) &
              t.startedAt.equals(from))
          ..limit(1))
        .getSingleOrNull();
    if (dup != null) return;

    await into(appUsages).insert(AppUsagesCompanion.insert(
      id: SyncStamp.newId(),
      deviceId: deviceId,
      appId: appId,
      startedAt: from,
      endedAt: to,
      durationSeconds: to.difference(from).inSeconds,
      createdAt: now,
      updatedAt: now,
      platform: Value(platform),
      appName: Value(appName),
      productivity: Value(productivity),
      ruleId: Value(ruleId),
      categoryId: Value(categoryId),
      dirty: const Value(true),
    ));
  }

  Stream<List<AppUsage>> watchForDay(DateTime day) {
    final from = startOfDay(day).toUtc();
    final to = endOfDay(day).toUtc();
    final q = _alive()
      ..where((t) =>
          t.startedAt.isBiggerOrEqualValue(from) &
          t.startedAt.isSmallerThanValue(to) &
          t.idle.equals(false))
      ..orderBy([
        (t) => OrderingTerm(expression: t.startedAt, mode: OrderingMode.desc)
      ]);
    return q.watch();
  }

  /// Bloki czekające na ręczną klasyfikację — dłuższe niż [minSeconds],
  /// żeby nie zasypywać przeglądu pięciosekundowymi przełączeniami okna.
  Stream<List<AppUsage>> watchUnclassified({int minSeconds = 120}) {
    final q = _alive()
      ..where((t) =>
          t.productivity.equals(Productivity.unknown.name) &
          t.reviewed.equals(false) &
          t.idle.equals(false) &
          t.durationSeconds.isBiggerOrEqualValue(minSeconds))
      ..orderBy([
        (t) => OrderingTerm(
            expression: t.durationSeconds, mode: OrderingMode.desc)
      ])
      ..limit(50);
    return q.watch();
  }

  /// Ręczna zmiana klasyfikacji. Ustawia `reviewed`, przez co blok staje się
  /// odporny na późniejsze przeklasyfikowanie regułami — twoja decyzja
  /// nie może zostać nadpisana przez automat.
  Future<void> reclassify(
    String id,
    Productivity productivity, {
    String? categoryId,
  }) {
    return (update(appUsages)..where((t) => t.id.equals(id))).write(
      AppUsagesCompanion(
        productivity: Value(productivity),
        categoryId: Value(categoryId),
        ruleId: const Value(null),
        reviewed: const Value(true),
        updatedAt: Value(SyncStamp.now()),
        dirty: const Value(true),
      ),
    );
  }

  /// Przelicza klasyfikację po zmianie reguł.
  ///
  /// Pomija wiersze z `reviewed` — patrz [reclassify]. Zwraca liczbę
  /// zmienionych bloków, żeby ekran reguł mógł powiedzieć
  /// „przeklasyfikowano 42 bloki" zamiast milczeć.
  Future<int> reclassifyUnreviewed(
    Productivity Function(AppUsage row) classify,
  ) async {
    final rows = await (_alive()..where((t) => t.reviewed.equals(false))).get();
    final now = SyncStamp.now();
    var changed = 0;

    await batch((b) {
      for (final row in rows) {
        final next = classify(row);
        if (next == row.productivity) continue;
        changed++;
        b.update(
          appUsages,
          AppUsagesCompanion(
            productivity: Value(next),
            updatedAt: Value(now),
            dirty: const Value(true),
          ),
          where: (t) => t.id.equals(row.id),
        );
      }
    });
    return changed;
  }

  /// Najdłużej używane aplikacje w zadanym oknie czasu.
  Future<List<({String appId, String appName, Productivity productivity, Duration total})>>
      topApps(DateTime from, DateTime to, {int limit = 10}) async {
    final durationSum = appUsages.durationSeconds.sum();
    final query = selectOnly(appUsages)
      ..addColumns([
        appUsages.appId,
        appUsages.appName,
        appUsages.productivity,
        durationSum,
      ])
      ..where(appUsages.deleted.equals(false) &
          appUsages.idle.equals(false) &
          appUsages.startedAt.isBiggerOrEqualValue(from.toUtc()) &
          appUsages.startedAt.isSmallerThanValue(to.toUtc()))
      ..groupBy([appUsages.appId, appUsages.appName, appUsages.productivity])
      ..orderBy([OrderingTerm(expression: durationSum, mode: OrderingMode.desc)])
      ..limit(limit);

    final rows = await query.get();
    return rows.map((r) {
      return (
        appId: r.read(appUsages.appId) ?? '',
        appName: r.read(appUsages.appName) ?? '',
        productivity:
            r.readWithConverter(appUsages.productivity) ?? Productivity.unknown,
        total: Duration(seconds: r.read(durationSum) ?? 0),
      );
    }).toList();
  }
}
