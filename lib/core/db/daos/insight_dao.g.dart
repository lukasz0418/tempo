// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_dao.dart';

// ignore_for_file: type=lint
mixin _$InsightDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $TasksTable get tasks => attachedDatabase.tasks;
  $TimeEntriesTable get timeEntries => attachedDatabase.timeEntries;
  $AppUsagesTable get appUsages => attachedDatabase.appUsages;
  $DayPlansTable get dayPlans => attachedDatabase.dayPlans;
  InsightDaoManager get managers => InsightDaoManager(this);
}

class InsightDaoManager {
  final _$InsightDaoMixin _db;
  InsightDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db.attachedDatabase, _db.tasks);
  $$TimeEntriesTableTableManager get timeEntries =>
      $$TimeEntriesTableTableManager(_db.attachedDatabase, _db.timeEntries);
  $$AppUsagesTableTableManager get appUsages =>
      $$AppUsagesTableTableManager(_db.attachedDatabase, _db.appUsages);
  $$DayPlansTableTableManager get dayPlans =>
      $$DayPlansTableTableManager(_db.attachedDatabase, _db.dayPlans);
}
