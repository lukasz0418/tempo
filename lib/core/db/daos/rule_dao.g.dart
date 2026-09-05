// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule_dao.dart';

// ignore_for_file: type=lint
mixin _$RuleDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $ActivityRulesTable get activityRules => attachedDatabase.activityRules;
  RuleDaoManager get managers => RuleDaoManager(this);
}

class RuleDaoManager {
  final _$RuleDaoMixin _db;
  RuleDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$ActivityRulesTableTableManager get activityRules =>
      $$ActivityRulesTableTableManager(_db.attachedDatabase, _db.activityRules);
}
