import 'package:drift/drift.dart';

import '../database.dart';
import '../sync_stamp.dart';
import '../tables.dart';

part 'reminder_dao.g.dart';

@DriftAccessor(tables: [Reminders])
class ReminderDao extends DatabaseAccessor<AppDatabase>
    with _$ReminderDaoMixin {
  ReminderDao(super.db);

  SimpleSelectStatement<$RemindersTable, Reminder> _alive() =>
      select(reminders)..where((r) => r.deleted.equals(false));

  Stream<List<Reminder>> watchAll() {
    final q = _alive()
      ..orderBy([
        (r) => OrderingTerm(expression: r.minuteOfDay),
      ]);
    return q.watch();
  }

  /// Włączone przypomnienia — te, które trzeba zaplanować w systemie.
  Future<List<Reminder>> enabled() {
    return (_alive()..where((r) => r.enabled.equals(true))).get();
  }

  Future<String> create({
    required String title,
    required int minuteOfDay,
    String? body,
    List<int> weekdays = const [],
    String? skillId,
    String? goalId,
  }) async {
    final id = SyncStamp.newId();
    final now = SyncStamp.now();
    await into(reminders).insert(RemindersCompanion.insert(
      id: id,
      title: title,
      minuteOfDay: minuteOfDay,
      createdAt: now,
      updatedAt: now,
      body: Value(body),
      weekdays: Value(weekdays.join(',')),
      skillId: Value(skillId),
      goalId: Value(goalId),
      dirty: const Value(true),
    ));
    return id;
  }

  Future<void> save(RemindersCompanion patch) {
    assert(patch.id.present, 'save() wymaga id w companionie');
    return (update(reminders)..where((r) => r.id.equals(patch.id.value))).write(
      patch.copyWith(
        updatedAt: Value(SyncStamp.now()),
        dirty: const Value(true),
      ),
    );
  }

  Future<void> setEnabled(String id, {required bool enabled}) =>
      save(RemindersCompanion(id: Value(id), enabled: Value(enabled)));

  Future<void> markFired(String id) =>
      save(RemindersCompanion(id: Value(id), lastFiredAt: Value(SyncStamp.now())));

  Future<void> softDelete(String id) =>
      save(RemindersCompanion(id: Value(id), deleted: const Value(true)));

  Future<void> restore(String id) =>
      save(RemindersCompanion(id: Value(id), deleted: const Value(false)));
}

/// Dni tygodnia zapisane w kolumnie `weekdays`.
///
/// Pusta lista oznacza „codziennie" — to najczęstszy przypadek i nie ma
/// powodu, żeby wymagał zaznaczania siedmiu pól.
List<int> parseWeekdays(String raw) {
  if (raw.trim().isEmpty) return const [];
  return raw
      .split(',')
      .map((s) => int.tryParse(s.trim()))
      .whereType<int>()
      .where((d) => d >= DateTime.monday && d <= DateTime.sunday)
      .toList()
    ..sort();
}

String formatMinuteOfDay(int minuteOfDay) {
  final h = (minuteOfDay ~/ 60).toString().padLeft(2, '0');
  final m = (minuteOfDay % 60).toString().padLeft(2, '0');
  return '$h:$m';
}

String describeWeekdays(List<int> days) {
  if (days.isEmpty) return 'codziennie';
  if (days.length == 7) return 'codziennie';

  const names = {
    DateTime.monday: 'pon',
    DateTime.tuesday: 'wt',
    DateTime.wednesday: 'śr',
    DateTime.thursday: 'czw',
    DateTime.friday: 'pt',
    DateTime.saturday: 'sob',
    DateTime.sunday: 'niedz',
  };

  const workdays = [1, 2, 3, 4, 5];
  const weekend = [6, 7];
  if (_sameSet(days, workdays)) return 'w dni robocze';
  if (_sameSet(days, weekend)) return 'w weekendy';

  return days.map((d) => names[d]).join(', ');
}

bool _sameSet(List<int> a, List<int> b) =>
    a.length == b.length && a.toSet().containsAll(b);
