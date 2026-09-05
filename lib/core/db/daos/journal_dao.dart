import 'package:drift/drift.dart';

import '../../util/dates.dart';
import '../database.dart';
import '../enums.dart';
import '../sync_stamp.dart';
import '../tables.dart';

part 'journal_dao.g.dart';

/// Wpis razem z jego załącznikami — jedna strona dziennika.
class JournalPage {
  const JournalPage({required this.entry, required this.attachments});

  final JournalEntry entry;
  final List<Attachment> attachments;
}

@DriftAccessor(tables: [JournalEntries, Attachments, Skills])
class JournalDao extends DatabaseAccessor<AppDatabase> with _$JournalDaoMixin {
  JournalDao(super.db);

  SimpleSelectStatement<$JournalEntriesTable, JournalEntry> _alive() =>
      select(journalEntries)..where((j) => j.deleted.equals(false));

  Stream<List<JournalEntry>> watchForSkill(String skillId) {
    final q = _alive()
      ..where((j) => j.skillId.equals(skillId))
      ..orderBy([
        (j) => OrderingTerm(expression: j.date, mode: OrderingMode.desc),
        (j) => OrderingTerm(expression: j.createdAt, mode: OrderingMode.desc),
      ]);
    return q.watch();
  }

  /// Same kamienie milowe — osobna oś czasu, do której wraca się po roku.
  Stream<List<JournalEntry>> watchMilestones(String skillId) {
    final q = _alive()
      ..where((j) => j.skillId.equals(skillId) & j.isMilestone.equals(true))
      ..orderBy([(j) => OrderingTerm(expression: j.date, mode: OrderingMode.desc)]);
    return q.watch();
  }

  Future<JournalEntry?> byId(String id) =>
      (select(journalEntries)..where((j) => j.id.equals(id))).getSingleOrNull();

  Stream<JournalPage?> watchPage(String entryId) {
    return (select(journalEntries)..where((j) => j.id.equals(entryId)))
        .watchSingleOrNull()
        .asyncMap((entry) async {
      if (entry == null) return null;
      return JournalPage(
        entry: entry,
        attachments: await attachmentsFor(entryId),
      );
    });
  }

  Future<String> create({
    required String skillId,
    String? date,
    String title = '',
    String body = '',
    int? selfRating,
    bool isMilestone = false,
    String? timeEntryId,
  }) async {
    final id = SyncStamp.newId();
    final now = SyncStamp.now();
    await into(journalEntries).insert(JournalEntriesCompanion.insert(
      id: id,
      skillId: skillId,
      date: date ?? todayKey(),
      createdAt: now,
      updatedAt: now,
      title: Value(title),
      body: Value(body),
      selfRating: Value(selfRating),
      isMilestone: Value(isMilestone),
      timeEntryId: Value(timeEntryId),
      dirty: const Value(true),
    ));
    return id;
  }

  Future<void> save(JournalEntriesCompanion patch) {
    assert(patch.id.present, 'save() wymaga id w companionie');
    return (update(journalEntries)..where((j) => j.id.equals(patch.id.value)))
        .write(patch.copyWith(
      updatedAt: Value(SyncStamp.now()),
      dirty: const Value(true),
    ));
  }

  Future<void> softDelete(String id) =>
      save(JournalEntriesCompanion(id: Value(id), deleted: const Value(true)));

  Future<void> restore(String id) =>
      save(JournalEntriesCompanion(id: Value(id), deleted: const Value(false)));

  // --- załączniki ---------------------------------------------------------

  Future<List<Attachment>> attachmentsFor(String entryId) {
    return (select(attachments)
          ..where((a) => a.entryId.equals(entryId) & a.deleted.equals(false))
          ..orderBy([
            (a) => OrderingTerm(expression: a.sortOrder),
            (a) => OrderingTerm(expression: a.createdAt),
          ]))
        .get();
  }

  Stream<List<Attachment>> watchAttachments(String entryId) {
    return (select(attachments)
          ..where((a) => a.entryId.equals(entryId) & a.deleted.equals(false))
          ..orderBy([
            (a) => OrderingTerm(expression: a.sortOrder),
            (a) => OrderingTerm(expression: a.createdAt),
          ]))
        .watch();
  }

  Future<String> addAttachment({
    required String entryId,
    required AttachmentKind kind,
    required String fileName,
    required String sha256,
    String label = '',
    String mimeType = '',
    int bytes = 0,
    int? durationMs,
  }) async {
    final id = SyncStamp.newId();
    final now = SyncStamp.now();
    await into(attachments).insert(AttachmentsCompanion.insert(
      id: id,
      entryId: entryId,
      kind: kind,
      fileName: fileName,
      createdAt: now,
      updatedAt: now,
      label: Value(label),
      mimeType: Value(mimeType),
      bytes: Value(bytes),
      durationMs: Value(durationMs),
      sha256: Value(sha256),
      dirty: const Value(true),
    ));
    return id;
  }

  Future<void> softDeleteAttachment(String id) {
    return (update(attachments)..where((a) => a.id.equals(id))).write(
      AttachmentsCompanion(
        deleted: const Value(true),
        updatedAt: Value(SyncStamp.now()),
        dirty: const Value(true),
      ),
    );
  }

  Future<void> restoreAttachment(String id) {
    return (update(attachments)..where((a) => a.id.equals(id))).write(
      AttachmentsCompanion(
        deleted: const Value(false),
        updatedAt: Value(SyncStamp.now()),
        dirty: const Value(true),
      ),
    );
  }

  /// Nazwy plików, do których odwołuje się jakikolwiek żywy załącznik.
  ///
  /// Potrzebne przy szukaniu osieroconych plików w magazynie. Bierzemy też
  /// wiersze skasowane miękko — tombstone nadal wskazuje na plik, a wpis
  /// da się przywrócić, więc kasowanie pliku byłoby nieodwracalną stratą
  /// przy odwracalnej operacji.
  Future<Set<String>> referencedFileNames() async {
    final rows = await select(attachments).get();
    return rows.map((a) => a.fileName).toSet();
  }

  /// Ile razy dany plik jest używany. Przy nazwach z sumy kontrolnej
  /// ten sam plik bywa podpięty pod kilka wpisów, więc kasowanie go
  /// przy usuwaniu jednego załącznika zepsułoby pozostałe.
  Future<int> fileUsageCount(String fileName) async {
    final rows = await (select(attachments)
          ..where((a) => a.fileName.equals(fileName) & a.deleted.equals(false)))
        .get();
    return rows.length;
  }
}
