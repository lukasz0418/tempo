// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry_dao.dart';

// ignore_for_file: type=lint
mixin _$TimeEntryDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $TasksTable get tasks => attachedDatabase.tasks;
  $SkillsTable get skills => attachedDatabase.skills;
  $TimeEntriesTable get timeEntries => attachedDatabase.timeEntries;
  TimeEntryDaoManager get managers => TimeEntryDaoManager(this);
}

class TimeEntryDaoManager {
  final _$TimeEntryDaoMixin _db;
  TimeEntryDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db.attachedDatabase, _db.tasks);
  $$SkillsTableTableManager get skills =>
      $$SkillsTableTableManager(_db.attachedDatabase, _db.skills);
  $$TimeEntriesTableTableManager get timeEntries =>
      $$TimeEntriesTableTableManager(_db.attachedDatabase, _db.timeEntries);
}
