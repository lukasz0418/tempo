import 'package:drift/drift.dart';

import '../database.dart';
import '../enums.dart';
import '../sync_stamp.dart';
import '../tables.dart';

part 'idea_dao.g.dart';

@DriftAccessor(tables: [Ideas])
class IdeaDao extends DatabaseAccessor<AppDatabase> with _$IdeaDaoMixin {
  IdeaDao(super.db);

  SimpleSelectStatement<$IdeasTable, Idea> _alive() =>
      select(ideas)..where((t) => t.deleted.equals(false));

  Stream<List<Idea>> watchAll({IdeaStatus? status}) {
    final q = _alive()
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    if (status != null) {
      q.where((t) => t.status.equals(status.name));
    }
    return q.watch();
  }

  /// Pomysły otwarte — to, co realnie czeka na decyzję.
  Stream<List<Idea>> watchOpen() {
    final q = _alive()
      ..where((t) => t.status.isIn([
            IdeaStatus.inbox.name,
            IdeaStatus.considering.name,
            IdeaStatus.planned.name,
          ]))
      ..orderBy([
        (t) => OrderingTerm(expression: t.status),
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    return q.watch();
  }

  Future<String> add({
    required String title,
    String? body,
    IdeaKind kind = IdeaKind.feature,
    int? impact,
    int? effort,
    String tags = '',
    String? sourceScreen,
  }) async {
    final id = SyncStamp.newId();
    final now = SyncStamp.now();
    await into(ideas).insert(IdeasCompanion.insert(
      id: id,
      title: title,
      createdAt: now,
      updatedAt: now,
      body: Value(body),
      kind: Value(kind),
      impact: Value(impact),
      effort: Value(effort),
      tags: Value(tags),
      sourceScreen: Value(sourceScreen),
      dirty: const Value(true),
    ));
    return id;
  }

  Future<void> save(IdeasCompanion patch) {
    assert(patch.id.present, 'save() wymaga id w companionie');
    return (update(ideas)..where((t) => t.id.equals(patch.id.value))).write(
      patch.copyWith(
        updatedAt: Value(SyncStamp.now()),
        dirty: const Value(true),
      ),
    );
  }

  Future<void> setStatus(String id, IdeaStatus status) =>
      save(IdeasCompanion(id: Value(id), status: Value(status)));

  Future<void> softDelete(String id) =>
      save(IdeasCompanion(id: Value(id), deleted: const Value(true)));

  /// Przywraca skasowany pomysł.
  ///
  /// Możliwe wyłącznie dlatego, że kasowanie jest miękkie — wiersz zostaje
  /// w bazie jako tombstone na potrzeby synchronizacji. Odzyskiwanie danych
  /// jest efektem ubocznym tamtej decyzji, ale skoro jest za darmo,
  /// nie ma powodu, żeby użytkownik nie miał do niego dostępu.
  Future<void> restore(String id) =>
      save(IdeasCompanion(id: Value(id), deleted: const Value(false)));

  /// Skasowane pomysły, od najświeższych.
  Stream<List<Idea>> watchDeleted() {
    final q = select(ideas)
      ..where((t) => t.deleted.equals(true))
      ..orderBy([
        (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
      ])
      ..limit(100);
    return q.watch();
  }

  /// Pomysły, które jeszcze nie trafiły do żadnego eksportu.
  Future<List<Idea>> newSinceLastExport() {
    return (_alive()
          ..where((t) => t.exportedAt.isNull())
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .get();
  }

  /// Stempluje wyeksportowane pomysły.
  ///
  /// Osobna kolumna zamiast statusu, bo eksport nie jest decyzją o pomyśle:
  /// ten sam wpis można wkleić do rozmowy kilka razy, a jego status
  /// ma mówić, czy go robimy, a nie czy go skopiowałeś.
  Future<void> markExported(List<String> ids) async {
    if (ids.isEmpty) return;
    final now = SyncStamp.now();
    await (update(ideas)..where((t) => t.id.isIn(ids))).write(
      IdeasCompanion(
        exportedAt: Value(now),
        updatedAt: Value(now),
        dirty: const Value(true),
      ),
    );
  }
}
