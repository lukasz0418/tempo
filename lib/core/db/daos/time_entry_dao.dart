import 'package:drift/drift.dart';

import '../../util/dates.dart';
import '../database.dart';
import '../enums.dart';
import '../sync_stamp.dart';
import '../tables.dart';

part 'time_entry_dao.g.dart';

/// Trwający pomiar wraz z informacją, skąd pochodzi.
class RunningEntry {
  const RunningEntry({required this.entry, required this.isThisDevice});

  final TimeEntry entry;

  /// Fałsz, jeśli stoper został uruchomiony na innym urządzeniu —
  /// UI mówi wtedy wprost „chodzi od 3 h na Pixelu", zamiast udawać,
  /// że to twój lokalny pomiar.
  final bool isThisDevice;

  Duration get elapsed => DateTime.now().toUtc().difference(entry.startedAt);
}

@DriftAccessor(tables: [TimeEntries, Tasks, Categories])
class TimeEntryDao extends DatabaseAccessor<AppDatabase>
    with _$TimeEntryDaoMixin {
  TimeEntryDao(super.db);

  SimpleSelectStatement<$TimeEntriesTable, TimeEntry> _alive() =>
      select(timeEntries)..where((t) => t.deleted.equals(false));

  /// Trwający pomiar, jeśli jakiś jest.
  ///
  /// Zwraca **najnowszy**, gdyby przejściowo było ich kilka. Taka sytuacja
  /// jest realna: uruchamiasz stoper na telefonie, tracisz zasięg, odpalasz
  /// drugi na PC. Baza tego nie blokuje — lepiej pogodzić dwa wiersze
  /// w [reconcileRunning] niż wywalić zapis błędem i stracić pomiar.
  Stream<TimeEntry?> watchRunningRaw() {
    final q = _alive()
      ..where((t) => t.endedAt.isNull())
      ..orderBy([(t) => OrderingTerm(expression: t.startedAt, mode: OrderingMode.desc)])
      ..limit(1);
    return q.watchSingleOrNull();
  }

  Future<List<TimeEntry>> runningEntries() {
    return (_alive()..where((t) => t.endedAt.isNull())).get();
  }

  /// Startuje pomiar, domykając wcześniejszy, jeśli istnieje.
  ///
  /// Zwraca id nowego wpisu oraz — o ile coś domknięto — poprzedni wpis,
  /// żeby UI mógł pokazać „zamknąłem stoper z telefonu po 3 h, poprawić?".
  Future<({String id, TimeEntry? closed})> start({
    required String deviceId,
    String? taskId,
    String? categoryId,

    /// Ćwiczona umiejętność. Dzięki temu godziny ćwiczeń liczą się same
    /// z tego samego pomiaru, który obsługuje resztę aplikacji —
    /// sesja gry na gitarze nie potrzebuje osobnego stopera.
    String? skillId,
    String description = '',
    TimeEntrySource source = TimeEntrySource.timer,
  }) async {
    return transaction(() async {
      final closed = await _closeAllRunning();

      final id = SyncStamp.newId();
      final now = SyncStamp.now();
      await into(timeEntries).insert(TimeEntriesCompanion.insert(
        id: id,
        startedAt: now,
        createdAt: now,
        updatedAt: now,
        taskId: Value(taskId),
        categoryId: Value(categoryId),
        skillId: Value(skillId),
        description: Value(description),
        source: Value(source),
        deviceId: Value(deviceId),
        dirty: const Value(true),
      ));

      // Zadanie przechodzi w „robię" — inaczej lista zadań i stoper
      // pokazują dwie różne wersje rzeczywistości.
      if (taskId != null) {
        await (update(tasks)..where((t) => t.id.equals(taskId))).write(
          TasksCompanion(
            status: const Value(TaskStatus.doing),
            updatedAt: Value(now),
            dirty: const Value(true),
          ),
        );
      }

      return (id: id, closed: closed.isEmpty ? null : closed.first);
    });
  }

  Future<List<TimeEntry>> _closeAllRunning() async {
    final running = await runningEntries();
    if (running.isEmpty) return const [];

    final now = SyncStamp.now();
    for (final e in running) {
      await (update(timeEntries)..where((t) => t.id.equals(e.id))).write(
        TimeEntriesCompanion(
          endedAt: Value(now),
          updatedAt: Value(now),
          dirty: const Value(true),
        ),
      );
    }
    return running;
  }

  Future<void> stop() async {
    await _closeAllRunning();
  }

  /// Domyka pomiar konkretną chwilą — używane, gdy użytkownik poprawia
  /// zapomniany stoper („naprawdę 6 h? przytnij do 45 min").
  Future<void> stopAt(String id, DateTime endedAt) {
    final now = SyncStamp.now();
    return (update(timeEntries)..where((t) => t.id.equals(id))).write(
      TimeEntriesCompanion(
        endedAt: Value(endedAt.toUtc()),
        updatedAt: Value(now),
        dirty: const Value(true),
      ),
    );
  }

  /// Wpis dodany ręcznie, zwykle wstecz.
  ///
  /// Bez tej ścieżki aplikacja umiera po tygodniu: zapomnisz włączyć stoper,
  /// nie będzie jak tego nadrobić i przestaniesz ufać danym.
  Future<String> addManual({
    required DateTime startedAt,
    required DateTime endedAt,
    required String deviceId,
    String? taskId,
    String? categoryId,
    String description = '',
    Productivity? productivity,
  }) async {
    final id = SyncStamp.newId();
    final now = SyncStamp.now();
    await into(timeEntries).insert(TimeEntriesCompanion.insert(
      id: id,
      startedAt: startedAt.toUtc(),
      createdAt: now,
      updatedAt: now,
      endedAt: Value(endedAt.toUtc()),
      taskId: Value(taskId),
      categoryId: Value(categoryId),
      description: Value(description),
      productivity: Value(productivity),
      source: const Value(TimeEntrySource.manual),
      deviceId: Value(deviceId),
      dirty: const Value(true),
    ));
    return id;
  }

  /// Wpisy z danego dnia (po czasie **startu**, w strefie lokalnej).
  Stream<List<TimeEntry>> watchForDay(DateTime day) {
    final from = startOfDay(day).toUtc();
    final to = endOfDay(day).toUtc();
    final q = _alive()
      ..where((t) =>
          t.startedAt.isBiggerOrEqualValue(from) & t.startedAt.isSmallerThanValue(to))
      ..orderBy([(t) => OrderingTerm(expression: t.startedAt, mode: OrderingMode.desc)]);
    return q.watch();
  }

  /// Suma zmierzonego czasu dla zadania. Podstawa porównania z estymatą.
  Future<Duration> totalForTask(String taskId) async {
    final rows = await (_alive()
          ..where((t) => t.taskId.equals(taskId) & t.endedAt.isNotNull()))
        .get();
    var total = Duration.zero;
    for (final e in rows) {
      total += e.endedAt!.difference(e.startedAt);
    }
    return total;
  }

  Future<void> setMood(String id, int mood) {
    return (update(timeEntries)..where((t) => t.id.equals(id))).write(
      TimeEntriesCompanion(
        moodAfter: Value(mood),
        updatedAt: Value(SyncStamp.now()),
        dirty: const Value(true),
      ),
    );
  }

  Future<void> softDelete(String id) => _setDeleted(id, deleted: true);

  /// Cofnięcie usunięcia. Działa, bo wiersz nigdy fizycznie nie znika.
  Future<void> restore(String id) => _setDeleted(id, deleted: false);

  Future<void> _setDeleted(String id, {required bool deleted}) {
    return (update(timeEntries)..where((t) => t.id.equals(id))).write(
      TimeEntriesCompanion(
        deleted: Value(deleted),
        updatedAt: Value(SyncStamp.now()),
        dirty: const Value(true),
      ),
    );
  }

  /// Sprząta po synchronizacji: jeśli po pobraniu danych zostało kilka
  /// otwartych pomiarów, przy życiu zostaje najnowszy, reszta domykana
  /// jest chwilą startu następnego. Wywoływane po każdym udanym pull.
  Future<int> reconcileRunning() async {
    final running = await runningEntries();
    if (running.length < 2) return 0;

    running.sort((a, b) => a.startedAt.compareTo(b.startedAt));
    final now = SyncStamp.now();
    var fixed = 0;

    for (var i = 0; i < running.length - 1; i++) {
      final entry = running[i];
      final nextStart = running[i + 1].startedAt;
      await (update(timeEntries)..where((t) => t.id.equals(entry.id))).write(
        TimeEntriesCompanion(
          endedAt: Value(nextStart),
          updatedAt: Value(now),
          dirty: const Value(true),
        ),
      );
      fixed++;
    }
    return fixed;
  }
}
