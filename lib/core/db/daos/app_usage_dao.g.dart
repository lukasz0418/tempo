// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_usage_dao.dart';

// ignore_for_file: type=lint
mixin _$AppUsageDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $TasksTable get tasks => attachedDatabase.tasks;
  $SkillsTable get skills => attachedDatabase.skills;
  $TimeEntriesTable get timeEntries => attachedDatabase.timeEntries;
  $AppUsagesTable get appUsages => attachedDatabase.appUsages;
  $ActivityRulesTable get activityRules => attachedDatabase.activityRules;
  AppUsageDaoManager get managers => AppUsageDaoManager(this);
}

class AppUsageDaoManager {
  final _$AppUsageDaoMixin _db;
  AppUsageDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db.attachedDatabase, _db.tasks);
  $$SkillsTableTableManager get skills =>
      $$SkillsTableTableManager(_db.attachedDatabase, _db.skills);
  $$TimeEntriesTableTableManager get timeEntries =>
      $$TimeEntriesTableTableManager(_db.attachedDatabase, _db.timeEntries);
  $$AppUsagesTableTableManager get appUsages =>
      $$AppUsagesTableTableManager(_db.attachedDatabase, _db.appUsages);
  $$ActivityRulesTableTableManager get activityRules =>
      $$ActivityRulesTableTableManager(_db.attachedDatabase, _db.activityRules);
}
