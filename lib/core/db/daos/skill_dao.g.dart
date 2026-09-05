// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_dao.dart';

// ignore_for_file: type=lint
mixin _$SkillDaoMixin on DatabaseAccessor<AppDatabase> {
  $SkillsTable get skills => attachedDatabase.skills;
  $CategoriesTable get categories => attachedDatabase.categories;
  $TasksTable get tasks => attachedDatabase.tasks;
  $TimeEntriesTable get timeEntries => attachedDatabase.timeEntries;
  $JournalEntriesTable get journalEntries => attachedDatabase.journalEntries;
  SkillDaoManager get managers => SkillDaoManager(this);
}

class SkillDaoManager {
  final _$SkillDaoMixin _db;
  SkillDaoManager(this._db);
  $$SkillsTableTableManager get skills =>
      $$SkillsTableTableManager(_db.attachedDatabase, _db.skills);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db.attachedDatabase, _db.tasks);
  $$TimeEntriesTableTableManager get timeEntries =>
      $$TimeEntriesTableTableManager(_db.attachedDatabase, _db.timeEntries);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(
        _db.attachedDatabase,
        _db.journalEntries,
      );
}
