import 'package:drift/drift.dart';

import '../../tracking/rule_engine.dart';
import '../database.dart';
import '../enums.dart';
import '../sync_stamp.dart';
import '../tables.dart';

part 'rule_dao.g.dart';

@DriftAccessor(tables: [ActivityRules])
class RuleDao extends DatabaseAccessor<AppDatabase> with _$RuleDaoMixin {
  RuleDao(super.db);

  SimpleSelectStatement<$ActivityRulesTable, ActivityRule> _alive() =>
      select(activityRules)..where((t) => t.deleted.equals(false));

  Stream<List<ActivityRule>> watchAll() {
    final q = _alive()
      ..orderBy([
        (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.label),
      ]);
    return q.watch();
  }

  /// Reguły w postaci, którą rozumie [RuleEngine].
  ///
  /// Mapowanie żyje tutaj, a nie w silniku, celowo: dzięki temu silnik
  /// nie zna drifta i da się go testować bez bazy.
  Stream<List<Rule>> watchEngineRules() =>
      watchAll().map((rows) => rows.map(toEngineRule).toList());

  Future<List<Rule>> engineRules() async =>
      (await _alive().get()).map(toEngineRule).toList();

  static Rule toEngineRule(ActivityRule r) => Rule(
        id: r.id,
        pattern: r.pattern,
        productivity: r.productivity,
        matchTarget: r.matchTarget,
        matchType: r.matchType,
        platform: r.platform,
        categoryId: r.categoryId,
        priority: r.priority,
        enabled: r.enabled,
      );

  /// Reguła użytkownika. Priorytet domyślnie ponad wbudowanymi (100),
  /// bo skoro ktoś ją napisał ręcznie, to wie lepiej niż nasz seed.
  Future<String> createCustom({
    required String label,
    required String pattern,
    required Productivity productivity,
    MatchTarget matchTarget = MatchTarget.appId,
    MatchType matchType = MatchType.contains,
    DevicePlatform? platform,
    String? categoryId,
    int priority = 200,
  }) async {
    final id = SyncStamp.newId();
    final now = SyncStamp.now();
    await into(activityRules).insert(ActivityRulesCompanion.insert(
      id: id,
      pattern: pattern,
      productivity: productivity,
      createdAt: now,
      updatedAt: now,
      label: Value(label),
      matchTarget: Value(matchTarget),
      matchType: Value(matchType),
      platform: Value(platform),
      categoryId: Value(categoryId),
      priority: Value(priority),
      isBuiltin: const Value(false),
      dirty: const Value(true),
    ));
    return id;
  }

  Future<void> setEnabled(String id, {required bool enabled}) {
    return (update(activityRules)..where((t) => t.id.equals(id))).write(
      ActivityRulesCompanion(
        enabled: Value(enabled),
        updatedAt: Value(SyncStamp.now()),
        dirty: const Value(true),
      ),
    );
  }

  Future<void> save(ActivityRulesCompanion patch) {
    assert(patch.id.present, 'save() wymaga id w companionie');
    return (update(activityRules)..where((t) => t.id.equals(patch.id.value)))
        .write(patch.copyWith(
      updatedAt: Value(SyncStamp.now()),
      dirty: const Value(true),
    ));
  }

  /// Miękkie usunięcie. Reguły wbudowane są tylko wyłączane —
  /// skasowana wróciłaby przy najbliższym seedzie i wyglądałoby to
  /// na błąd aplikacji.
  Future<void> remove(String id) async {
    final rule =
        await (_alive()..where((t) => t.id.equals(id))).getSingleOrNull();
    if (rule == null) return;

    if (rule.isBuiltin) {
      await setEnabled(id, enabled: false);
      return;
    }
    await save(ActivityRulesCompanion(
      id: Value(id),
      deleted: const Value(true),
    ));
  }
}
