import 'package:drift/drift.dart';

import '../../recurrence/recurrence.dart';
import '../../util/dates.dart';
import '../database.dart';
import '../enums.dart';
import '../sync_stamp.dart';
import '../tables.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: [Tasks, TimeEntries, Categories])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.db);

  /// Wszystkie żywe zadania (bez tombstone'ów).
  SimpleSelectStatement<$TasksTable, Task> _alive() =>
      select(tasks)..where((t) => t.deleted.equals(false));

  Stream<List<Task>> watchOpen() {
    final q = _alive()
      ..where((t) => t.status.isNotIn([TaskStatus.done.name, TaskStatus.dropped.name]))
      ..orderBy([
        (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.dueAt),
        (t) => OrderingTerm(expression: t.sortOrder),
      ]);
    return q.watch();
  }

  /// Zadania zaplanowane na dany dzień.
  Stream<List<Task>> watchPlannedFor(String day) {
    final q = _alive()
      ..where((t) => t.plannedFor.equals(day))
      ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]);
    return q.watch();
  }

  /// Zadania gotowe do zrobienia teraz: bez daty startu w przyszłości
  /// i opcjonalnie przefiltrowane po energii i kontekście.
  ///
  /// To jest zapytanie stojące za trybem „co teraz?" — o 22:00 filtrujesz
  /// po [EnergyKind.shallow] i dostajesz rzeczy, które faktycznie zrobisz,
  /// zamiast listy, na którą nie masz siły patrzeć.
  Stream<List<Task>> watchActionable({
    EnergyKind? energy,
    TaskContext? context,
  }) {
    final now = DateTime.now();
    final q = _alive()
      ..where((t) {
        var cond = t.status.isIn([TaskStatus.todo.name, TaskStatus.doing.name]) &
            (t.startAt.isNull() | t.startAt.isSmallerOrEqualValue(now));
        if (energy != null) cond = cond & t.energy.equals(energy.name);
        if (context != null) {
          cond = cond &
              (t.context.equals(context.name) |
                  t.context.equals(TaskContext.anywhere.name));
        }
        return cond;
      })
      ..orderBy([
        (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.dueAt),
      ]);
    return q.watch();
  }

  Future<Task?> byId(String id) =>
      (select(tasks)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<String> create({
    required String title,
    String? notes,
    String? categoryId,
    Duration? estimateMin,
    Duration? estimateMax,
    bool estimateWasSuggested = false,
    TaskStatus status = TaskStatus.todo,
    EnergyKind? energy,
    TaskContext? context,
    int priority = 0,
    DateTime? dueAt,
    DateTime? startAt,
    String? plannedFor,
    String? parentId,
    String? recurrenceRule,
    bool recurrenceFromCompletion = true,
  }) async {
    final id = SyncStamp.newId();
    final now = SyncStamp.now();

    await into(tasks).insert(TasksCompanion.insert(
      id: id,
      title: title,
      createdAt: now,
      updatedAt: now,
      notes: Value(notes),
      categoryId: Value(categoryId),
      estimateMinSeconds: Value(estimateMin?.inSeconds),
      estimateMaxSeconds: Value(estimateMax?.inSeconds),
      estimateWasSuggested: Value(estimateWasSuggested),
      status: Value(status),
      energy: Value(energy),
      context: Value(context),
      priority: Value(priority),
      dueAt: Value(dueAt),
      startAt: Value(startAt),
      plannedFor: Value(plannedFor),
      parentId: Value(parentId),
      recurrenceRule: Value(recurrenceRule),
      recurrenceFromCompletion: Value(recurrenceFromCompletion),
      dirty: const Value(true),
    ));
    return id;
  }

  /// Zapisuje zmiany, samodzielnie odświeżając znaczniki synchronizacji.
  Future<void> save(TasksCompanion patch) {
    assert(patch.id.present, 'save() wymaga id w companionie');
    return (update(tasks)..where((t) => t.id.equals(patch.id.value))).write(
      patch.copyWith(updatedAt: Value(SyncStamp.now()), dirty: const Value(true)),
    );
  }

  /// Odhacza zadanie i — jeśli jest cykliczne — zakłada kolejne wystąpienie.
  ///
  /// Zwraca id nowo utworzonego zadania albo null.
  Future<String?> complete(String id) async {
    final task = await byId(id);
    if (task == null) return null;

    final now = SyncStamp.now();
    await save(TasksCompanion(
      id: Value(id),
      status: const Value(TaskStatus.done),
      completedAt: Value(now),
    ));

    final rule = RecurrenceRule.tryParse(task.recurrenceRule);
    if (rule == null) return null;

    // Punkt odniesienia: moment wykonania albo pierwotny termin.
    // Przy podlewaniu kwiatów liczy się „3 dni od podlania"; przy czynszu
    // — „10. dnia miesiąca", niezależnie od tego, kiedy zapłaciłeś.
    final anchor = task.recurrenceFromCompletion
        ? now.toLocal()
        : (task.dueAt?.toLocal() ?? now.toLocal());
    final next = rule.nextAfter(anchor);

    return create(
      title: task.title,
      notes: task.notes,
      categoryId: task.categoryId,
      estimateMin: task.estimateMinSeconds == null
          ? null
          : Duration(seconds: task.estimateMinSeconds!),
      estimateMax: task.estimateMaxSeconds == null
          ? null
          : Duration(seconds: task.estimateMaxSeconds!),
      status: TaskStatus.todo,
      energy: task.energy,
      context: task.context,
      priority: task.priority,
      dueAt: task.dueAt == null ? null : next,
      startAt: task.startAt == null ? null : next,
      plannedFor: null,
      recurrenceRule: task.recurrenceRule,
      recurrenceFromCompletion: task.recurrenceFromCompletion,
    );
  }

  /// Przekłada zadanie i podbija licznik odkładania.
  ///
  /// Licznik nie jest ozdobą — ekran zadań zaczepia przy siódmym przełożeniu,
  /// bo zadanie odkładane tyle razy zwykle nie czeka na lepszy moment,
  /// tylko na skasowanie.
  Future<void> postpone(String id, DateTime until) async {
    final task = await byId(id);
    if (task == null) return;
    await save(TasksCompanion(
      id: Value(id),
      startAt: Value(until),
      plannedFor: Value(dayKey(until)),
      postponedCount: Value(task.postponedCount + 1),
    ));
  }

  Future<void> planFor(String id, String? day) =>
      save(TasksCompanion(id: Value(id), plannedFor: Value(day)));

  /// Usunięcie miękkie — wiersz zostaje jako tombstone, żeby kasowanie
  /// dotarło na drugie urządzenie przy najbliższej synchronizacji.
  Future<void> softDelete(String id) => save(
        TasksCompanion(id: Value(id), deleted: const Value(true)),
      );

  Future<List<Task>> subtasksOf(String parentId) =>
      (_alive()..where((t) => t.parentId.equals(parentId))).get();
}
