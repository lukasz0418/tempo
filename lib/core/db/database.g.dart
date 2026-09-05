// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Productivity, String>
  defaultProductivity = GeneratedColumn<String>(
    'default_productivity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('neutral'),
  ).withConverter<Productivity>($CategoriesTable.$converterdefaultProductivity);
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deleted,
    dirty,
    name,
    color,
    icon,
    defaultProductivity,
    archived,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      defaultProductivity: $CategoriesTable.$converterdefaultProductivity
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}default_productivity'],
            )!,
          ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Productivity, String, String>
  $converterdefaultProductivity = const EnumNameConverter<Productivity>(
    Productivity.values,
  );
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final DateTime createdAt;

  /// Znacznik ostatniej zmiany. Ustawiany lokalnie przy każdym zapisie
  /// i porównywany z serwerem przy synchronizacji.
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final String name;

  /// ARGB. Trzymane jako int, żeby nie parsować stringów przy każdym renderze.
  final int color;

  /// Nazwa ikony z Material Icons; null = kropka w kolorze kategorii.
  final String? icon;
  final Productivity defaultProductivity;
  final bool archived;
  final int sortOrder;
  const Category({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    required this.name,
    required this.color,
    this.icon,
    required this.defaultProductivity,
    required this.archived,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    {
      map['default_productivity'] = Variable<String>(
        $CategoriesTable.$converterdefaultProductivity.toSql(
          defaultProductivity,
        ),
      );
    }
    map['archived'] = Variable<bool>(archived);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      name: Value(name),
      color: Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      defaultProductivity: Value(defaultProductivity),
      archived: Value(archived),
      sortOrder: Value(sortOrder),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
      defaultProductivity: $CategoriesTable.$converterdefaultProductivity
          .fromJson(serializer.fromJson<String>(json['defaultProductivity'])),
      archived: serializer.fromJson<bool>(json['archived']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'icon': serializer.toJson<String?>(icon),
      'defaultProductivity': serializer.toJson<String>(
        $CategoriesTable.$converterdefaultProductivity.toJson(
          defaultProductivity,
        ),
      ),
      'archived': serializer.toJson<bool>(archived),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Category copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    String? name,
    int? color,
    Value<String?> icon = const Value.absent(),
    Productivity? defaultProductivity,
    bool? archived,
    int? sortOrder,
  }) => Category(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    name: name ?? this.name,
    color: color ?? this.color,
    icon: icon.present ? icon.value : this.icon,
    defaultProductivity: defaultProductivity ?? this.defaultProductivity,
    archived: archived ?? this.archived,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      defaultProductivity: data.defaultProductivity.present
          ? data.defaultProductivity.value
          : this.defaultProductivity,
      archived: data.archived.present ? data.archived.value : this.archived,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('defaultProductivity: $defaultProductivity, ')
          ..write('archived: $archived, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deleted,
    dirty,
    name,
    color,
    icon,
    defaultProductivity,
    archived,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.name == this.name &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.defaultProductivity == this.defaultProductivity &&
          other.archived == this.archived &&
          other.sortOrder == this.sortOrder);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<String> name;
  final Value<int> color;
  final Value<String?> icon;
  final Value<Productivity> defaultProductivity;
  final Value<bool> archived;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.defaultProductivity = const Value.absent(),
    this.archived = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    required String name,
    required int color,
    this.icon = const Value.absent(),
    this.defaultProductivity = const Value.absent(),
    this.archived = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name),
       color = Value(color);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<String>? name,
    Expression<int>? color,
    Expression<String>? icon,
    Expression<String>? defaultProductivity,
    Expression<bool>? archived,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (defaultProductivity != null)
        'default_productivity': defaultProductivity,
      if (archived != null) 'archived': archived,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<String>? name,
    Value<int>? color,
    Value<String?>? icon,
    Value<Productivity>? defaultProductivity,
    Value<bool>? archived,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      defaultProductivity: defaultProductivity ?? this.defaultProductivity,
      archived: archived ?? this.archived,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (defaultProductivity.present) {
      map['default_productivity'] = Variable<String>(
        $CategoriesTable.$converterdefaultProductivity.toSql(
          defaultProductivity.value,
        ),
      );
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('defaultProductivity: $defaultProductivity, ')
          ..write('archived: $archived, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimateMinSecondsMeta =
      const VerificationMeta('estimateMinSeconds');
  @override
  late final GeneratedColumn<int> estimateMinSeconds = GeneratedColumn<int>(
    'estimate_min_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimateMaxSecondsMeta =
      const VerificationMeta('estimateMaxSeconds');
  @override
  late final GeneratedColumn<int> estimateMaxSeconds = GeneratedColumn<int>(
    'estimate_max_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimateWasSuggestedMeta =
      const VerificationMeta('estimateWasSuggested');
  @override
  late final GeneratedColumn<bool> estimateWasSuggested = GeneratedColumn<bool>(
    'estimate_was_suggested',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("estimate_was_suggested" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('inbox'),
      ).withConverter<TaskStatus>($TasksTable.$converterstatus);
  @override
  late final GeneratedColumnWithTypeConverter<EnergyKind?, String> energy =
      GeneratedColumn<String>(
        'energy',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<EnergyKind?>($TasksTable.$converterenergyn);
  @override
  late final GeneratedColumnWithTypeConverter<TaskContext?, String> context =
      GeneratedColumn<String>(
        'context',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<TaskContext?>($TasksTable.$convertercontextn);
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startAtMeta = const VerificationMeta(
    'startAt',
  );
  @override
  late final GeneratedColumn<DateTime> startAt = GeneratedColumn<DateTime>(
    'start_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedForMeta = const VerificationMeta(
    'plannedFor',
  );
  @override
  late final GeneratedColumn<String> plannedFor = GeneratedColumn<String>(
    'planned_for',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurrenceRuleMeta = const VerificationMeta(
    'recurrenceRule',
  );
  @override
  late final GeneratedColumn<String> recurrenceRule = GeneratedColumn<String>(
    'recurrence_rule',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurrenceFromCompletionMeta =
      const VerificationMeta('recurrenceFromCompletion');
  @override
  late final GeneratedColumn<bool> recurrenceFromCompletion =
      GeneratedColumn<bool>(
        'recurrence_from_completion',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("recurrence_from_completion" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _postponedCountMeta = const VerificationMeta(
    'postponedCount',
  );
  @override
  late final GeneratedColumn<int> postponedCount = GeneratedColumn<int>(
    'postponed_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deleted,
    dirty,
    title,
    notes,
    categoryId,
    parentId,
    estimateMinSeconds,
    estimateMaxSeconds,
    estimateWasSuggested,
    status,
    energy,
    context,
    priority,
    dueAt,
    startAt,
    plannedFor,
    completedAt,
    recurrenceRule,
    recurrenceFromCompletion,
    postponedCount,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('estimate_min_seconds')) {
      context.handle(
        _estimateMinSecondsMeta,
        estimateMinSeconds.isAcceptableOrUnknown(
          data['estimate_min_seconds']!,
          _estimateMinSecondsMeta,
        ),
      );
    }
    if (data.containsKey('estimate_max_seconds')) {
      context.handle(
        _estimateMaxSecondsMeta,
        estimateMaxSeconds.isAcceptableOrUnknown(
          data['estimate_max_seconds']!,
          _estimateMaxSecondsMeta,
        ),
      );
    }
    if (data.containsKey('estimate_was_suggested')) {
      context.handle(
        _estimateWasSuggestedMeta,
        estimateWasSuggested.isAcceptableOrUnknown(
          data['estimate_was_suggested']!,
          _estimateWasSuggestedMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('start_at')) {
      context.handle(
        _startAtMeta,
        startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta),
      );
    }
    if (data.containsKey('planned_for')) {
      context.handle(
        _plannedForMeta,
        plannedFor.isAcceptableOrUnknown(data['planned_for']!, _plannedForMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('recurrence_rule')) {
      context.handle(
        _recurrenceRuleMeta,
        recurrenceRule.isAcceptableOrUnknown(
          data['recurrence_rule']!,
          _recurrenceRuleMeta,
        ),
      );
    }
    if (data.containsKey('recurrence_from_completion')) {
      context.handle(
        _recurrenceFromCompletionMeta,
        recurrenceFromCompletion.isAcceptableOrUnknown(
          data['recurrence_from_completion']!,
          _recurrenceFromCompletionMeta,
        ),
      );
    }
    if (data.containsKey('postponed_count')) {
      context.handle(
        _postponedCountMeta,
        postponedCount.isAcceptableOrUnknown(
          data['postponed_count']!,
          _postponedCountMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      estimateMinSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimate_min_seconds'],
      ),
      estimateMaxSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimate_max_seconds'],
      ),
      estimateWasSuggested: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}estimate_was_suggested'],
      )!,
      status: $TasksTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      energy: $TasksTable.$converterenergyn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}energy'],
        ),
      ),
      context: $TasksTable.$convertercontextn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}context'],
        ),
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      ),
      startAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_at'],
      ),
      plannedFor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}planned_for'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      recurrenceRule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence_rule'],
      ),
      recurrenceFromCompletion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}recurrence_from_completion'],
      )!,
      postponedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}postponed_count'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskStatus, String, String> $converterstatus =
      const EnumNameConverter<TaskStatus>(TaskStatus.values);
  static JsonTypeConverter2<EnergyKind, String, String> $converterenergy =
      const EnumNameConverter<EnergyKind>(EnergyKind.values);
  static JsonTypeConverter2<EnergyKind?, String?, String?> $converterenergyn =
      JsonTypeConverter2.asNullable($converterenergy);
  static JsonTypeConverter2<TaskContext, String, String> $convertercontext =
      const EnumNameConverter<TaskContext>(TaskContext.values);
  static JsonTypeConverter2<TaskContext?, String?, String?> $convertercontextn =
      JsonTypeConverter2.asNullable($convertercontext);
}

class Task extends DataClass implements Insertable<Task> {
  final String id;
  final DateTime createdAt;

  /// Znacznik ostatniej zmiany. Ustawiany lokalnie przy każdym zapisie
  /// i porównywany z serwerem przy synchronizacji.
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final String title;
  final String? notes;
  final String? categoryId;

  /// Podzadania. Estymaty dzieci sumują się do rodzica w widoku,
  /// ale nie są tu denormalizowane — liczone są zapytaniem.
  final String? parentId;

  /// Estymata jako **zakres**, nie punkt.
  ///
  /// Ludzie myślą „jakieś 30–60 minut" i wymuszanie jednej liczby
  /// tylko produkuje fałszywą precyzję. Przy szacowaniu punktowym
  /// obie kolumny dostają tę samą wartość.
  final int? estimateMinSeconds;
  final int? estimateMaxSeconds;

  /// Czy estymata została podpowiedziana przez aplikację i przyjęta bez zmian.
  /// Pozwala później sprawdzić, czy podpowiedzi w ogóle pomagają.
  final bool estimateWasSuggested;
  final TaskStatus status;
  final EnergyKind? energy;
  final TaskContext? context;

  /// 0 = brak, wyżej = ważniejsze. Świadomie zwykły int, bez enuma —
  /// skale priorytetów i tak każdy nagina do siebie.
  final int priority;

  /// Twardy termin. Rozdzielony od [startAt], bo mieszanie tych dwóch
  /// rzeczy jest głównym powodem, dla którego listy zadań stają się nieczytelne:
  /// zadanie z terminem za miesiąc nie powinno krzyczeć dzisiaj.
  final DateTime? dueAt;

  /// Najwcześniejszy sensowny moment startu — do tego czasu zadanie jest ukryte.
  final DateTime? startAt;

  /// Dzień, na który zadanie jest zaplanowane, jako `YYYY-MM-DD`.
  ///
  /// Tekst, a nie DateTime, bo to jest data kalendarzowa bez strefy czasowej —
  /// przy DateTime „dzisiaj" potrafi się przesunąć po zmianie strefy,
  /// a grupowanie po dniu wymagałoby liczenia na timestampach.
  final String? plannedFor;
  final DateTime? completedAt;

  /// Reguła powtarzania w uproszczonym RRULE (`FREQ=WEEKLY;BYDAY=MO,WE`).
  final String? recurrenceRule;

  /// Czy kolejne wystąpienie liczyć od **wykonania**, czy od terminu.
  ///
  /// Dla podlewania kwiatów liczy się „3 dni od ostatniego podlania",
  /// nie „co 3 dni od zawsze" — inaczej po tygodniu urlopu dostajesz
  /// pięć zaległych kopii tego samego.
  final bool recurrenceFromCompletion;

  /// Ile razy zadanie zostało przełożone na później.
  ///
  /// Nie jest ozdobą: po przekroczeniu progu aplikacja pyta wprost,
  /// czy to zadanie w ogóle ma sens. Odkładane po raz siódmy zwykle nie ma.
  final int postponedCount;
  final int sortOrder;
  const Task({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    required this.title,
    this.notes,
    this.categoryId,
    this.parentId,
    this.estimateMinSeconds,
    this.estimateMaxSeconds,
    required this.estimateWasSuggested,
    required this.status,
    this.energy,
    this.context,
    required this.priority,
    this.dueAt,
    this.startAt,
    this.plannedFor,
    this.completedAt,
    this.recurrenceRule,
    required this.recurrenceFromCompletion,
    required this.postponedCount,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    if (!nullToAbsent || estimateMinSeconds != null) {
      map['estimate_min_seconds'] = Variable<int>(estimateMinSeconds);
    }
    if (!nullToAbsent || estimateMaxSeconds != null) {
      map['estimate_max_seconds'] = Variable<int>(estimateMaxSeconds);
    }
    map['estimate_was_suggested'] = Variable<bool>(estimateWasSuggested);
    {
      map['status'] = Variable<String>(
        $TasksTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || energy != null) {
      map['energy'] = Variable<String>(
        $TasksTable.$converterenergyn.toSql(energy),
      );
    }
    if (!nullToAbsent || context != null) {
      map['context'] = Variable<String>(
        $TasksTable.$convertercontextn.toSql(context),
      );
    }
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<DateTime>(dueAt);
    }
    if (!nullToAbsent || startAt != null) {
      map['start_at'] = Variable<DateTime>(startAt);
    }
    if (!nullToAbsent || plannedFor != null) {
      map['planned_for'] = Variable<String>(plannedFor);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || recurrenceRule != null) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule);
    }
    map['recurrence_from_completion'] = Variable<bool>(
      recurrenceFromCompletion,
    );
    map['postponed_count'] = Variable<int>(postponedCount);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      title: Value(title),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      estimateMinSeconds: estimateMinSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(estimateMinSeconds),
      estimateMaxSeconds: estimateMaxSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(estimateMaxSeconds),
      estimateWasSuggested: Value(estimateWasSuggested),
      status: Value(status),
      energy: energy == null && nullToAbsent
          ? const Value.absent()
          : Value(energy),
      context: context == null && nullToAbsent
          ? const Value.absent()
          : Value(context),
      priority: Value(priority),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      startAt: startAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startAt),
      plannedFor: plannedFor == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedFor),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      recurrenceRule: recurrenceRule == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceRule),
      recurrenceFromCompletion: Value(recurrenceFromCompletion),
      postponedCount: Value(postponedCount),
      sortOrder: Value(sortOrder),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      estimateMinSeconds: serializer.fromJson<int?>(json['estimateMinSeconds']),
      estimateMaxSeconds: serializer.fromJson<int?>(json['estimateMaxSeconds']),
      estimateWasSuggested: serializer.fromJson<bool>(
        json['estimateWasSuggested'],
      ),
      status: $TasksTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      energy: $TasksTable.$converterenergyn.fromJson(
        serializer.fromJson<String?>(json['energy']),
      ),
      context: $TasksTable.$convertercontextn.fromJson(
        serializer.fromJson<String?>(json['context']),
      ),
      priority: serializer.fromJson<int>(json['priority']),
      dueAt: serializer.fromJson<DateTime?>(json['dueAt']),
      startAt: serializer.fromJson<DateTime?>(json['startAt']),
      plannedFor: serializer.fromJson<String?>(json['plannedFor']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      recurrenceRule: serializer.fromJson<String?>(json['recurrenceRule']),
      recurrenceFromCompletion: serializer.fromJson<bool>(
        json['recurrenceFromCompletion'],
      ),
      postponedCount: serializer.fromJson<int>(json['postponedCount']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String?>(notes),
      'categoryId': serializer.toJson<String?>(categoryId),
      'parentId': serializer.toJson<String?>(parentId),
      'estimateMinSeconds': serializer.toJson<int?>(estimateMinSeconds),
      'estimateMaxSeconds': serializer.toJson<int?>(estimateMaxSeconds),
      'estimateWasSuggested': serializer.toJson<bool>(estimateWasSuggested),
      'status': serializer.toJson<String>(
        $TasksTable.$converterstatus.toJson(status),
      ),
      'energy': serializer.toJson<String?>(
        $TasksTable.$converterenergyn.toJson(energy),
      ),
      'context': serializer.toJson<String?>(
        $TasksTable.$convertercontextn.toJson(context),
      ),
      'priority': serializer.toJson<int>(priority),
      'dueAt': serializer.toJson<DateTime?>(dueAt),
      'startAt': serializer.toJson<DateTime?>(startAt),
      'plannedFor': serializer.toJson<String?>(plannedFor),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'recurrenceRule': serializer.toJson<String?>(recurrenceRule),
      'recurrenceFromCompletion': serializer.toJson<bool>(
        recurrenceFromCompletion,
      ),
      'postponedCount': serializer.toJson<int>(postponedCount),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Task copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    String? title,
    Value<String?> notes = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> parentId = const Value.absent(),
    Value<int?> estimateMinSeconds = const Value.absent(),
    Value<int?> estimateMaxSeconds = const Value.absent(),
    bool? estimateWasSuggested,
    TaskStatus? status,
    Value<EnergyKind?> energy = const Value.absent(),
    Value<TaskContext?> context = const Value.absent(),
    int? priority,
    Value<DateTime?> dueAt = const Value.absent(),
    Value<DateTime?> startAt = const Value.absent(),
    Value<String?> plannedFor = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    Value<String?> recurrenceRule = const Value.absent(),
    bool? recurrenceFromCompletion,
    int? postponedCount,
    int? sortOrder,
  }) => Task(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    title: title ?? this.title,
    notes: notes.present ? notes.value : this.notes,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    parentId: parentId.present ? parentId.value : this.parentId,
    estimateMinSeconds: estimateMinSeconds.present
        ? estimateMinSeconds.value
        : this.estimateMinSeconds,
    estimateMaxSeconds: estimateMaxSeconds.present
        ? estimateMaxSeconds.value
        : this.estimateMaxSeconds,
    estimateWasSuggested: estimateWasSuggested ?? this.estimateWasSuggested,
    status: status ?? this.status,
    energy: energy.present ? energy.value : this.energy,
    context: context.present ? context.value : this.context,
    priority: priority ?? this.priority,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    startAt: startAt.present ? startAt.value : this.startAt,
    plannedFor: plannedFor.present ? plannedFor.value : this.plannedFor,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    recurrenceRule: recurrenceRule.present
        ? recurrenceRule.value
        : this.recurrenceRule,
    recurrenceFromCompletion:
        recurrenceFromCompletion ?? this.recurrenceFromCompletion,
    postponedCount: postponedCount ?? this.postponedCount,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      estimateMinSeconds: data.estimateMinSeconds.present
          ? data.estimateMinSeconds.value
          : this.estimateMinSeconds,
      estimateMaxSeconds: data.estimateMaxSeconds.present
          ? data.estimateMaxSeconds.value
          : this.estimateMaxSeconds,
      estimateWasSuggested: data.estimateWasSuggested.present
          ? data.estimateWasSuggested.value
          : this.estimateWasSuggested,
      status: data.status.present ? data.status.value : this.status,
      energy: data.energy.present ? data.energy.value : this.energy,
      context: data.context.present ? data.context.value : this.context,
      priority: data.priority.present ? data.priority.value : this.priority,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      plannedFor: data.plannedFor.present
          ? data.plannedFor.value
          : this.plannedFor,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      recurrenceRule: data.recurrenceRule.present
          ? data.recurrenceRule.value
          : this.recurrenceRule,
      recurrenceFromCompletion: data.recurrenceFromCompletion.present
          ? data.recurrenceFromCompletion.value
          : this.recurrenceFromCompletion,
      postponedCount: data.postponedCount.present
          ? data.postponedCount.value
          : this.postponedCount,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('categoryId: $categoryId, ')
          ..write('parentId: $parentId, ')
          ..write('estimateMinSeconds: $estimateMinSeconds, ')
          ..write('estimateMaxSeconds: $estimateMaxSeconds, ')
          ..write('estimateWasSuggested: $estimateWasSuggested, ')
          ..write('status: $status, ')
          ..write('energy: $energy, ')
          ..write('context: $context, ')
          ..write('priority: $priority, ')
          ..write('dueAt: $dueAt, ')
          ..write('startAt: $startAt, ')
          ..write('plannedFor: $plannedFor, ')
          ..write('completedAt: $completedAt, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('recurrenceFromCompletion: $recurrenceFromCompletion, ')
          ..write('postponedCount: $postponedCount, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    createdAt,
    updatedAt,
    deleted,
    dirty,
    title,
    notes,
    categoryId,
    parentId,
    estimateMinSeconds,
    estimateMaxSeconds,
    estimateWasSuggested,
    status,
    energy,
    context,
    priority,
    dueAt,
    startAt,
    plannedFor,
    completedAt,
    recurrenceRule,
    recurrenceFromCompletion,
    postponedCount,
    sortOrder,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.categoryId == this.categoryId &&
          other.parentId == this.parentId &&
          other.estimateMinSeconds == this.estimateMinSeconds &&
          other.estimateMaxSeconds == this.estimateMaxSeconds &&
          other.estimateWasSuggested == this.estimateWasSuggested &&
          other.status == this.status &&
          other.energy == this.energy &&
          other.context == this.context &&
          other.priority == this.priority &&
          other.dueAt == this.dueAt &&
          other.startAt == this.startAt &&
          other.plannedFor == this.plannedFor &&
          other.completedAt == this.completedAt &&
          other.recurrenceRule == this.recurrenceRule &&
          other.recurrenceFromCompletion == this.recurrenceFromCompletion &&
          other.postponedCount == this.postponedCount &&
          other.sortOrder == this.sortOrder);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<String> title;
  final Value<String?> notes;
  final Value<String?> categoryId;
  final Value<String?> parentId;
  final Value<int?> estimateMinSeconds;
  final Value<int?> estimateMaxSeconds;
  final Value<bool> estimateWasSuggested;
  final Value<TaskStatus> status;
  final Value<EnergyKind?> energy;
  final Value<TaskContext?> context;
  final Value<int> priority;
  final Value<DateTime?> dueAt;
  final Value<DateTime?> startAt;
  final Value<String?> plannedFor;
  final Value<DateTime?> completedAt;
  final Value<String?> recurrenceRule;
  final Value<bool> recurrenceFromCompletion;
  final Value<int> postponedCount;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.estimateMinSeconds = const Value.absent(),
    this.estimateMaxSeconds = const Value.absent(),
    this.estimateWasSuggested = const Value.absent(),
    this.status = const Value.absent(),
    this.energy = const Value.absent(),
    this.context = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.startAt = const Value.absent(),
    this.plannedFor = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.recurrenceFromCompletion = const Value.absent(),
    this.postponedCount = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    required String title,
    this.notes = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.estimateMinSeconds = const Value.absent(),
    this.estimateMaxSeconds = const Value.absent(),
    this.estimateWasSuggested = const Value.absent(),
    this.status = const Value.absent(),
    this.energy = const Value.absent(),
    this.context = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.startAt = const Value.absent(),
    this.plannedFor = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.recurrenceFromCompletion = const Value.absent(),
    this.postponedCount = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       title = Value(title);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<String>? categoryId,
    Expression<String>? parentId,
    Expression<int>? estimateMinSeconds,
    Expression<int>? estimateMaxSeconds,
    Expression<bool>? estimateWasSuggested,
    Expression<String>? status,
    Expression<String>? energy,
    Expression<String>? context,
    Expression<int>? priority,
    Expression<DateTime>? dueAt,
    Expression<DateTime>? startAt,
    Expression<String>? plannedFor,
    Expression<DateTime>? completedAt,
    Expression<String>? recurrenceRule,
    Expression<bool>? recurrenceFromCompletion,
    Expression<int>? postponedCount,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (categoryId != null) 'category_id': categoryId,
      if (parentId != null) 'parent_id': parentId,
      if (estimateMinSeconds != null)
        'estimate_min_seconds': estimateMinSeconds,
      if (estimateMaxSeconds != null)
        'estimate_max_seconds': estimateMaxSeconds,
      if (estimateWasSuggested != null)
        'estimate_was_suggested': estimateWasSuggested,
      if (status != null) 'status': status,
      if (energy != null) 'energy': energy,
      if (context != null) 'context': context,
      if (priority != null) 'priority': priority,
      if (dueAt != null) 'due_at': dueAt,
      if (startAt != null) 'start_at': startAt,
      if (plannedFor != null) 'planned_for': plannedFor,
      if (completedAt != null) 'completed_at': completedAt,
      if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
      if (recurrenceFromCompletion != null)
        'recurrence_from_completion': recurrenceFromCompletion,
      if (postponedCount != null) 'postponed_count': postponedCount,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<String>? title,
    Value<String?>? notes,
    Value<String?>? categoryId,
    Value<String?>? parentId,
    Value<int?>? estimateMinSeconds,
    Value<int?>? estimateMaxSeconds,
    Value<bool>? estimateWasSuggested,
    Value<TaskStatus>? status,
    Value<EnergyKind?>? energy,
    Value<TaskContext?>? context,
    Value<int>? priority,
    Value<DateTime?>? dueAt,
    Value<DateTime?>? startAt,
    Value<String?>? plannedFor,
    Value<DateTime?>? completedAt,
    Value<String?>? recurrenceRule,
    Value<bool>? recurrenceFromCompletion,
    Value<int>? postponedCount,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      categoryId: categoryId ?? this.categoryId,
      parentId: parentId ?? this.parentId,
      estimateMinSeconds: estimateMinSeconds ?? this.estimateMinSeconds,
      estimateMaxSeconds: estimateMaxSeconds ?? this.estimateMaxSeconds,
      estimateWasSuggested: estimateWasSuggested ?? this.estimateWasSuggested,
      status: status ?? this.status,
      energy: energy ?? this.energy,
      context: context ?? this.context,
      priority: priority ?? this.priority,
      dueAt: dueAt ?? this.dueAt,
      startAt: startAt ?? this.startAt,
      plannedFor: plannedFor ?? this.plannedFor,
      completedAt: completedAt ?? this.completedAt,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      recurrenceFromCompletion:
          recurrenceFromCompletion ?? this.recurrenceFromCompletion,
      postponedCount: postponedCount ?? this.postponedCount,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (estimateMinSeconds.present) {
      map['estimate_min_seconds'] = Variable<int>(estimateMinSeconds.value);
    }
    if (estimateMaxSeconds.present) {
      map['estimate_max_seconds'] = Variable<int>(estimateMaxSeconds.value);
    }
    if (estimateWasSuggested.present) {
      map['estimate_was_suggested'] = Variable<bool>(
        estimateWasSuggested.value,
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $TasksTable.$converterstatus.toSql(status.value),
      );
    }
    if (energy.present) {
      map['energy'] = Variable<String>(
        $TasksTable.$converterenergyn.toSql(energy.value),
      );
    }
    if (context.present) {
      map['context'] = Variable<String>(
        $TasksTable.$convertercontextn.toSql(context.value),
      );
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (startAt.present) {
      map['start_at'] = Variable<DateTime>(startAt.value);
    }
    if (plannedFor.present) {
      map['planned_for'] = Variable<String>(plannedFor.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (recurrenceRule.present) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule.value);
    }
    if (recurrenceFromCompletion.present) {
      map['recurrence_from_completion'] = Variable<bool>(
        recurrenceFromCompletion.value,
      );
    }
    if (postponedCount.present) {
      map['postponed_count'] = Variable<int>(postponedCount.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('categoryId: $categoryId, ')
          ..write('parentId: $parentId, ')
          ..write('estimateMinSeconds: $estimateMinSeconds, ')
          ..write('estimateMaxSeconds: $estimateMaxSeconds, ')
          ..write('estimateWasSuggested: $estimateWasSuggested, ')
          ..write('status: $status, ')
          ..write('energy: $energy, ')
          ..write('context: $context, ')
          ..write('priority: $priority, ')
          ..write('dueAt: $dueAt, ')
          ..write('startAt: $startAt, ')
          ..write('plannedFor: $plannedFor, ')
          ..write('completedAt: $completedAt, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('recurrenceFromCompletion: $recurrenceFromCompletion, ')
          ..write('postponedCount: $postponedCount, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TimeEntriesTable extends TimeEntries
    with TableInfo<$TimeEntriesTable, TimeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimeEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Productivity?, String>
  productivity = GeneratedColumn<String>(
    'productivity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Productivity?>($TimeEntriesTable.$converterproductivityn);
  static const VerificationMeta _moodAfterMeta = const VerificationMeta(
    'moodAfter',
  );
  @override
  late final GeneratedColumn<int> moodAfter = GeneratedColumn<int>(
    'mood_after',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _energyAfterMeta = const VerificationMeta(
    'energyAfter',
  );
  @override
  late final GeneratedColumn<int> energyAfter = GeneratedColumn<int>(
    'energy_after',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TimeEntrySource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('timer'),
      ).withConverter<TimeEntrySource>($TimeEntriesTable.$convertersource);
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deleted,
    dirty,
    taskId,
    categoryId,
    description,
    startedAt,
    endedAt,
    productivity,
    moodAfter,
    energyAfter,
    source,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'time_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('mood_after')) {
      context.handle(
        _moodAfterMeta,
        moodAfter.isAcceptableOrUnknown(data['mood_after']!, _moodAfterMeta),
      );
    }
    if (data.containsKey('energy_after')) {
      context.handle(
        _energyAfterMeta,
        energyAfter.isAcceptableOrUnknown(
          data['energy_after']!,
          _energyAfterMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimeEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      productivity: $TimeEntriesTable.$converterproductivityn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}productivity'],
        ),
      ),
      moodAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood_after'],
      ),
      energyAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}energy_after'],
      ),
      source: $TimeEntriesTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $TimeEntriesTable createAlias(String alias) {
    return $TimeEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Productivity, String, String>
  $converterproductivity = const EnumNameConverter<Productivity>(
    Productivity.values,
  );
  static JsonTypeConverter2<Productivity?, String?, String?>
  $converterproductivityn = JsonTypeConverter2.asNullable(
    $converterproductivity,
  );
  static JsonTypeConverter2<TimeEntrySource, String, String> $convertersource =
      const EnumNameConverter<TimeEntrySource>(TimeEntrySource.values);
}

class TimeEntry extends DataClass implements Insertable<TimeEntry> {
  final String id;
  final DateTime createdAt;

  /// Znacznik ostatniej zmiany. Ustawiany lokalnie przy każdym zapisie
  /// i porównywany z serwerem przy synchronizacji.
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;

  /// Null dla wpisu bez zadania („kawa", „rozmowa z mamą").
  final String? taskId;
  final String? categoryId;
  final String description;
  final DateTime startedAt;

  /// Null = stoper wciąż chodzi.
  final DateTime? endedAt;

  /// Nadpisanie klasyfikacji dla tego konkretnego wpisu.
  /// Null = weź z kategorii albo z reguł.
  final Productivity? productivity;

  /// Samopoczucie po zadaniu, 1–5.
  ///
  /// Po miesiącu to najbardziej zaskakujące dane w całej aplikacji: pokazuje,
  /// które „produktywne" rzeczy tak naprawdę cię wypalają.
  final int? moodAfter;
  final int? energyAfter;
  final TimeEntrySource source;

  /// Na którym urządzeniu powstał wpis. Potrzebne, żeby wykryć
  /// stoper zapomniany na telefonie przy starcie nowego na PC.
  final String deviceId;
  const TimeEntry({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    this.taskId,
    this.categoryId,
    required this.description,
    required this.startedAt,
    this.endedAt,
    this.productivity,
    this.moodAfter,
    this.energyAfter,
    required this.source,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['description'] = Variable<String>(description);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    if (!nullToAbsent || productivity != null) {
      map['productivity'] = Variable<String>(
        $TimeEntriesTable.$converterproductivityn.toSql(productivity),
      );
    }
    if (!nullToAbsent || moodAfter != null) {
      map['mood_after'] = Variable<int>(moodAfter);
    }
    if (!nullToAbsent || energyAfter != null) {
      map['energy_after'] = Variable<int>(energyAfter);
    }
    {
      map['source'] = Variable<String>(
        $TimeEntriesTable.$convertersource.toSql(source),
      );
    }
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  TimeEntriesCompanion toCompanion(bool nullToAbsent) {
    return TimeEntriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      description: Value(description),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      productivity: productivity == null && nullToAbsent
          ? const Value.absent()
          : Value(productivity),
      moodAfter: moodAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(moodAfter),
      energyAfter: energyAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(energyAfter),
      source: Value(source),
      deviceId: Value(deviceId),
    );
  }

  factory TimeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimeEntry(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      description: serializer.fromJson<String>(json['description']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      productivity: $TimeEntriesTable.$converterproductivityn.fromJson(
        serializer.fromJson<String?>(json['productivity']),
      ),
      moodAfter: serializer.fromJson<int?>(json['moodAfter']),
      energyAfter: serializer.fromJson<int?>(json['energyAfter']),
      source: $TimeEntriesTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'taskId': serializer.toJson<String?>(taskId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'description': serializer.toJson<String>(description),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'productivity': serializer.toJson<String?>(
        $TimeEntriesTable.$converterproductivityn.toJson(productivity),
      ),
      'moodAfter': serializer.toJson<int?>(moodAfter),
      'energyAfter': serializer.toJson<int?>(energyAfter),
      'source': serializer.toJson<String>(
        $TimeEntriesTable.$convertersource.toJson(source),
      ),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  TimeEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    Value<String?> taskId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    String? description,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    Value<Productivity?> productivity = const Value.absent(),
    Value<int?> moodAfter = const Value.absent(),
    Value<int?> energyAfter = const Value.absent(),
    TimeEntrySource? source,
    String? deviceId,
  }) => TimeEntry(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    taskId: taskId.present ? taskId.value : this.taskId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    description: description ?? this.description,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    productivity: productivity.present ? productivity.value : this.productivity,
    moodAfter: moodAfter.present ? moodAfter.value : this.moodAfter,
    energyAfter: energyAfter.present ? energyAfter.value : this.energyAfter,
    source: source ?? this.source,
    deviceId: deviceId ?? this.deviceId,
  );
  TimeEntry copyWithCompanion(TimeEntriesCompanion data) {
    return TimeEntry(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      description: data.description.present
          ? data.description.value
          : this.description,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      productivity: data.productivity.present
          ? data.productivity.value
          : this.productivity,
      moodAfter: data.moodAfter.present ? data.moodAfter.value : this.moodAfter,
      energyAfter: data.energyAfter.present
          ? data.energyAfter.value
          : this.energyAfter,
      source: data.source.present ? data.source.value : this.source,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimeEntry(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('taskId: $taskId, ')
          ..write('categoryId: $categoryId, ')
          ..write('description: $description, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('productivity: $productivity, ')
          ..write('moodAfter: $moodAfter, ')
          ..write('energyAfter: $energyAfter, ')
          ..write('source: $source, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deleted,
    dirty,
    taskId,
    categoryId,
    description,
    startedAt,
    endedAt,
    productivity,
    moodAfter,
    energyAfter,
    source,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimeEntry &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.taskId == this.taskId &&
          other.categoryId == this.categoryId &&
          other.description == this.description &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.productivity == this.productivity &&
          other.moodAfter == this.moodAfter &&
          other.energyAfter == this.energyAfter &&
          other.source == this.source &&
          other.deviceId == this.deviceId);
}

class TimeEntriesCompanion extends UpdateCompanion<TimeEntry> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<String?> taskId;
  final Value<String?> categoryId;
  final Value<String> description;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<Productivity?> productivity;
  final Value<int?> moodAfter;
  final Value<int?> energyAfter;
  final Value<TimeEntrySource> source;
  final Value<String> deviceId;
  final Value<int> rowid;
  const TimeEntriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.taskId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.description = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.productivity = const Value.absent(),
    this.moodAfter = const Value.absent(),
    this.energyAfter = const Value.absent(),
    this.source = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimeEntriesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.taskId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.description = const Value.absent(),
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.productivity = const Value.absent(),
    this.moodAfter = const Value.absent(),
    this.energyAfter = const Value.absent(),
    this.source = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       startedAt = Value(startedAt);
  static Insertable<TimeEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<String>? taskId,
    Expression<String>? categoryId,
    Expression<String>? description,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? productivity,
    Expression<int>? moodAfter,
    Expression<int>? energyAfter,
    Expression<String>? source,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (taskId != null) 'task_id': taskId,
      if (categoryId != null) 'category_id': categoryId,
      if (description != null) 'description': description,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (productivity != null) 'productivity': productivity,
      if (moodAfter != null) 'mood_after': moodAfter,
      if (energyAfter != null) 'energy_after': energyAfter,
      if (source != null) 'source': source,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimeEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<String?>? taskId,
    Value<String?>? categoryId,
    Value<String>? description,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<Productivity?>? productivity,
    Value<int?>? moodAfter,
    Value<int?>? energyAfter,
    Value<TimeEntrySource>? source,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return TimeEntriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      taskId: taskId ?? this.taskId,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      productivity: productivity ?? this.productivity,
      moodAfter: moodAfter ?? this.moodAfter,
      energyAfter: energyAfter ?? this.energyAfter,
      source: source ?? this.source,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (productivity.present) {
      map['productivity'] = Variable<String>(
        $TimeEntriesTable.$converterproductivityn.toSql(productivity.value),
      );
    }
    if (moodAfter.present) {
      map['mood_after'] = Variable<int>(moodAfter.value);
    }
    if (energyAfter.present) {
      map['energy_after'] = Variable<int>(energyAfter.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $TimeEntriesTable.$convertersource.toSql(source.value),
      );
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimeEntriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('taskId: $taskId, ')
          ..write('categoryId: $categoryId, ')
          ..write('description: $description, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('productivity: $productivity, ')
          ..write('moodAfter: $moodAfter, ')
          ..write('energyAfter: $energyAfter, ')
          ..write('source: $source, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppUsagesTable extends AppUsages
    with TableInfo<$AppUsagesTable, AppUsage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppUsagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DevicePlatform, String> platform =
      GeneratedColumn<String>(
        'platform',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('unknown'),
      ).withConverter<DevicePlatform>($AppUsagesTable.$converterplatform);
  static const VerificationMeta _appIdMeta = const VerificationMeta('appId');
  @override
  late final GeneratedColumn<String> appId = GeneratedColumn<String>(
    'app_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appNameMeta = const VerificationMeta(
    'appName',
  );
  @override
  late final GeneratedColumn<String> appName = GeneratedColumn<String>(
    'app_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _windowTitleMeta = const VerificationMeta(
    'windowTitle',
  );
  @override
  late final GeneratedColumn<String> windowTitle = GeneratedColumn<String>(
    'window_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Productivity, String>
  productivity = GeneratedColumn<String>(
    'productivity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unknown'),
  ).withConverter<Productivity>($AppUsagesTable.$converterproductivity);
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<String> ruleId = GeneratedColumn<String>(
    'rule_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _reviewedMeta = const VerificationMeta(
    'reviewed',
  );
  @override
  late final GeneratedColumn<bool> reviewed = GeneratedColumn<bool>(
    'reviewed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reviewed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _timeEntryIdMeta = const VerificationMeta(
    'timeEntryId',
  );
  @override
  late final GeneratedColumn<String> timeEntryId = GeneratedColumn<String>(
    'time_entry_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES time_entries (id)',
    ),
  );
  static const VerificationMeta _idleMeta = const VerificationMeta('idle');
  @override
  late final GeneratedColumn<bool> idle = GeneratedColumn<bool>(
    'idle',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("idle" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deleted,
    dirty,
    deviceId,
    platform,
    appId,
    appName,
    windowTitle,
    startedAt,
    endedAt,
    durationSeconds,
    productivity,
    ruleId,
    categoryId,
    reviewed,
    timeEntryId,
    idle,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_usages';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppUsage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('app_id')) {
      context.handle(
        _appIdMeta,
        appId.isAcceptableOrUnknown(data['app_id']!, _appIdMeta),
      );
    } else if (isInserting) {
      context.missing(_appIdMeta);
    }
    if (data.containsKey('app_name')) {
      context.handle(
        _appNameMeta,
        appName.isAcceptableOrUnknown(data['app_name']!, _appNameMeta),
      );
    }
    if (data.containsKey('window_title')) {
      context.handle(
        _windowTitleMeta,
        windowTitle.isAcceptableOrUnknown(
          data['window_title']!,
          _windowTitleMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('rule_id')) {
      context.handle(
        _ruleIdMeta,
        ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('reviewed')) {
      context.handle(
        _reviewedMeta,
        reviewed.isAcceptableOrUnknown(data['reviewed']!, _reviewedMeta),
      );
    }
    if (data.containsKey('time_entry_id')) {
      context.handle(
        _timeEntryIdMeta,
        timeEntryId.isAcceptableOrUnknown(
          data['time_entry_id']!,
          _timeEntryIdMeta,
        ),
      );
    }
    if (data.containsKey('idle')) {
      context.handle(
        _idleMeta,
        idle.isAcceptableOrUnknown(data['idle']!, _idleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppUsage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppUsage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      platform: $AppUsagesTable.$converterplatform.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}platform'],
        )!,
      ),
      appId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_id'],
      )!,
      appName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_name'],
      )!,
      windowTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}window_title'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      productivity: $AppUsagesTable.$converterproductivity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}productivity'],
        )!,
      ),
      ruleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      reviewed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reviewed'],
      )!,
      timeEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_entry_id'],
      ),
      idle: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}idle'],
      )!,
    );
  }

  @override
  $AppUsagesTable createAlias(String alias) {
    return $AppUsagesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DevicePlatform, String, String> $converterplatform =
      const EnumNameConverter<DevicePlatform>(DevicePlatform.values);
  static JsonTypeConverter2<Productivity, String, String>
  $converterproductivity = const EnumNameConverter<Productivity>(
    Productivity.values,
  );
}

class AppUsage extends DataClass implements Insertable<AppUsage> {
  final String id;
  final DateTime createdAt;

  /// Znacznik ostatniej zmiany. Ustawiany lokalnie przy każdym zapisie
  /// i porównywany z serwerem przy synchronizacji.
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final String deviceId;
  final DevicePlatform platform;

  /// `chrome.exe`, `steam.exe`, `com.google.android.youtube`.
  final String appId;

  /// Nazwa czytelna dla człowieka („Google Chrome").
  final String appName;

  /// Tytuł okna w chwili próbki. Na Androidzie prawie zawsze null.
  final String? windowTitle;
  final DateTime startedAt;
  final DateTime endedAt;

  /// Denormalizowane, bo statystyki liczą po tym w każdej agregacji,
  /// a przeliczanie z [startedAt]/[endedAt] przy każdym zapytaniu
  /// zabijałoby wykresy miesięczne.
  final int durationSeconds;

  /// Wynik reguł w momencie zapisu.
  final Productivity productivity;

  /// Która reguła zadecydowała. Null przy ręcznej zmianie przez użytkownika.
  final String? ruleId;
  final String? categoryId;

  /// Czy człowiek potwierdził klasyfikację.
  ///
  /// Potwierdzone wiersze są odporne na późniejsze zmiany reguł —
  /// przeklasyfikowanie wstecz nie może kasować twoich własnych decyzji.
  final bool reviewed;

  /// Ustawione, jeśli z tej aktywności zrobiono normalny wpis czasu.
  final String? timeEntryId;

  /// Czy w tym czasie użytkownik był bezczynny (brak inputu).
  /// Odfiltrowuje godziny, gdy edytor stał otwarty, a ciebie nie było.
  final bool idle;
  const AppUsage({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    required this.deviceId,
    required this.platform,
    required this.appId,
    required this.appName,
    this.windowTitle,
    required this.startedAt,
    required this.endedAt,
    required this.durationSeconds,
    required this.productivity,
    this.ruleId,
    this.categoryId,
    required this.reviewed,
    this.timeEntryId,
    required this.idle,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    map['device_id'] = Variable<String>(deviceId);
    {
      map['platform'] = Variable<String>(
        $AppUsagesTable.$converterplatform.toSql(platform),
      );
    }
    map['app_id'] = Variable<String>(appId);
    map['app_name'] = Variable<String>(appName);
    if (!nullToAbsent || windowTitle != null) {
      map['window_title'] = Variable<String>(windowTitle);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    {
      map['productivity'] = Variable<String>(
        $AppUsagesTable.$converterproductivity.toSql(productivity),
      );
    }
    if (!nullToAbsent || ruleId != null) {
      map['rule_id'] = Variable<String>(ruleId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['reviewed'] = Variable<bool>(reviewed);
    if (!nullToAbsent || timeEntryId != null) {
      map['time_entry_id'] = Variable<String>(timeEntryId);
    }
    map['idle'] = Variable<bool>(idle);
    return map;
  }

  AppUsagesCompanion toCompanion(bool nullToAbsent) {
    return AppUsagesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      deviceId: Value(deviceId),
      platform: Value(platform),
      appId: Value(appId),
      appName: Value(appName),
      windowTitle: windowTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(windowTitle),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      durationSeconds: Value(durationSeconds),
      productivity: Value(productivity),
      ruleId: ruleId == null && nullToAbsent
          ? const Value.absent()
          : Value(ruleId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      reviewed: Value(reviewed),
      timeEntryId: timeEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(timeEntryId),
      idle: Value(idle),
    );
  }

  factory AppUsage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppUsage(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      platform: $AppUsagesTable.$converterplatform.fromJson(
        serializer.fromJson<String>(json['platform']),
      ),
      appId: serializer.fromJson<String>(json['appId']),
      appName: serializer.fromJson<String>(json['appName']),
      windowTitle: serializer.fromJson<String?>(json['windowTitle']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      productivity: $AppUsagesTable.$converterproductivity.fromJson(
        serializer.fromJson<String>(json['productivity']),
      ),
      ruleId: serializer.fromJson<String?>(json['ruleId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      reviewed: serializer.fromJson<bool>(json['reviewed']),
      timeEntryId: serializer.fromJson<String?>(json['timeEntryId']),
      idle: serializer.fromJson<bool>(json['idle']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'deviceId': serializer.toJson<String>(deviceId),
      'platform': serializer.toJson<String>(
        $AppUsagesTable.$converterplatform.toJson(platform),
      ),
      'appId': serializer.toJson<String>(appId),
      'appName': serializer.toJson<String>(appName),
      'windowTitle': serializer.toJson<String?>(windowTitle),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'productivity': serializer.toJson<String>(
        $AppUsagesTable.$converterproductivity.toJson(productivity),
      ),
      'ruleId': serializer.toJson<String?>(ruleId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'reviewed': serializer.toJson<bool>(reviewed),
      'timeEntryId': serializer.toJson<String?>(timeEntryId),
      'idle': serializer.toJson<bool>(idle),
    };
  }

  AppUsage copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    String? deviceId,
    DevicePlatform? platform,
    String? appId,
    String? appName,
    Value<String?> windowTitle = const Value.absent(),
    DateTime? startedAt,
    DateTime? endedAt,
    int? durationSeconds,
    Productivity? productivity,
    Value<String?> ruleId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    bool? reviewed,
    Value<String?> timeEntryId = const Value.absent(),
    bool? idle,
  }) => AppUsage(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    deviceId: deviceId ?? this.deviceId,
    platform: platform ?? this.platform,
    appId: appId ?? this.appId,
    appName: appName ?? this.appName,
    windowTitle: windowTitle.present ? windowTitle.value : this.windowTitle,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    productivity: productivity ?? this.productivity,
    ruleId: ruleId.present ? ruleId.value : this.ruleId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    reviewed: reviewed ?? this.reviewed,
    timeEntryId: timeEntryId.present ? timeEntryId.value : this.timeEntryId,
    idle: idle ?? this.idle,
  );
  AppUsage copyWithCompanion(AppUsagesCompanion data) {
    return AppUsage(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      platform: data.platform.present ? data.platform.value : this.platform,
      appId: data.appId.present ? data.appId.value : this.appId,
      appName: data.appName.present ? data.appName.value : this.appName,
      windowTitle: data.windowTitle.present
          ? data.windowTitle.value
          : this.windowTitle,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      productivity: data.productivity.present
          ? data.productivity.value
          : this.productivity,
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      reviewed: data.reviewed.present ? data.reviewed.value : this.reviewed,
      timeEntryId: data.timeEntryId.present
          ? data.timeEntryId.value
          : this.timeEntryId,
      idle: data.idle.present ? data.idle.value : this.idle,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppUsage(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('deviceId: $deviceId, ')
          ..write('platform: $platform, ')
          ..write('appId: $appId, ')
          ..write('appName: $appName, ')
          ..write('windowTitle: $windowTitle, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('productivity: $productivity, ')
          ..write('ruleId: $ruleId, ')
          ..write('categoryId: $categoryId, ')
          ..write('reviewed: $reviewed, ')
          ..write('timeEntryId: $timeEntryId, ')
          ..write('idle: $idle')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deleted,
    dirty,
    deviceId,
    platform,
    appId,
    appName,
    windowTitle,
    startedAt,
    endedAt,
    durationSeconds,
    productivity,
    ruleId,
    categoryId,
    reviewed,
    timeEntryId,
    idle,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppUsage &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.deviceId == this.deviceId &&
          other.platform == this.platform &&
          other.appId == this.appId &&
          other.appName == this.appName &&
          other.windowTitle == this.windowTitle &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationSeconds == this.durationSeconds &&
          other.productivity == this.productivity &&
          other.ruleId == this.ruleId &&
          other.categoryId == this.categoryId &&
          other.reviewed == this.reviewed &&
          other.timeEntryId == this.timeEntryId &&
          other.idle == this.idle);
}

class AppUsagesCompanion extends UpdateCompanion<AppUsage> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<String> deviceId;
  final Value<DevicePlatform> platform;
  final Value<String> appId;
  final Value<String> appName;
  final Value<String?> windowTitle;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> durationSeconds;
  final Value<Productivity> productivity;
  final Value<String?> ruleId;
  final Value<String?> categoryId;
  final Value<bool> reviewed;
  final Value<String?> timeEntryId;
  final Value<bool> idle;
  final Value<int> rowid;
  const AppUsagesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.platform = const Value.absent(),
    this.appId = const Value.absent(),
    this.appName = const Value.absent(),
    this.windowTitle = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.productivity = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.reviewed = const Value.absent(),
    this.timeEntryId = const Value.absent(),
    this.idle = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppUsagesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    required String deviceId,
    this.platform = const Value.absent(),
    required String appId,
    this.appName = const Value.absent(),
    this.windowTitle = const Value.absent(),
    required DateTime startedAt,
    required DateTime endedAt,
    required int durationSeconds,
    this.productivity = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.reviewed = const Value.absent(),
    this.timeEntryId = const Value.absent(),
    this.idle = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId),
       appId = Value(appId),
       startedAt = Value(startedAt),
       endedAt = Value(endedAt),
       durationSeconds = Value(durationSeconds);
  static Insertable<AppUsage> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<String>? deviceId,
    Expression<String>? platform,
    Expression<String>? appId,
    Expression<String>? appName,
    Expression<String>? windowTitle,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? durationSeconds,
    Expression<String>? productivity,
    Expression<String>? ruleId,
    Expression<String>? categoryId,
    Expression<bool>? reviewed,
    Expression<String>? timeEntryId,
    Expression<bool>? idle,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (deviceId != null) 'device_id': deviceId,
      if (platform != null) 'platform': platform,
      if (appId != null) 'app_id': appId,
      if (appName != null) 'app_name': appName,
      if (windowTitle != null) 'window_title': windowTitle,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (productivity != null) 'productivity': productivity,
      if (ruleId != null) 'rule_id': ruleId,
      if (categoryId != null) 'category_id': categoryId,
      if (reviewed != null) 'reviewed': reviewed,
      if (timeEntryId != null) 'time_entry_id': timeEntryId,
      if (idle != null) 'idle': idle,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppUsagesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<String>? deviceId,
    Value<DevicePlatform>? platform,
    Value<String>? appId,
    Value<String>? appName,
    Value<String?>? windowTitle,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<int>? durationSeconds,
    Value<Productivity>? productivity,
    Value<String?>? ruleId,
    Value<String?>? categoryId,
    Value<bool>? reviewed,
    Value<String?>? timeEntryId,
    Value<bool>? idle,
    Value<int>? rowid,
  }) {
    return AppUsagesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      deviceId: deviceId ?? this.deviceId,
      platform: platform ?? this.platform,
      appId: appId ?? this.appId,
      appName: appName ?? this.appName,
      windowTitle: windowTitle ?? this.windowTitle,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      productivity: productivity ?? this.productivity,
      ruleId: ruleId ?? this.ruleId,
      categoryId: categoryId ?? this.categoryId,
      reviewed: reviewed ?? this.reviewed,
      timeEntryId: timeEntryId ?? this.timeEntryId,
      idle: idle ?? this.idle,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(
        $AppUsagesTable.$converterplatform.toSql(platform.value),
      );
    }
    if (appId.present) {
      map['app_id'] = Variable<String>(appId.value);
    }
    if (appName.present) {
      map['app_name'] = Variable<String>(appName.value);
    }
    if (windowTitle.present) {
      map['window_title'] = Variable<String>(windowTitle.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (productivity.present) {
      map['productivity'] = Variable<String>(
        $AppUsagesTable.$converterproductivity.toSql(productivity.value),
      );
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<String>(ruleId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (reviewed.present) {
      map['reviewed'] = Variable<bool>(reviewed.value);
    }
    if (timeEntryId.present) {
      map['time_entry_id'] = Variable<String>(timeEntryId.value);
    }
    if (idle.present) {
      map['idle'] = Variable<bool>(idle.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppUsagesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('deviceId: $deviceId, ')
          ..write('platform: $platform, ')
          ..write('appId: $appId, ')
          ..write('appName: $appName, ')
          ..write('windowTitle: $windowTitle, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('productivity: $productivity, ')
          ..write('ruleId: $ruleId, ')
          ..write('categoryId: $categoryId, ')
          ..write('reviewed: $reviewed, ')
          ..write('timeEntryId: $timeEntryId, ')
          ..write('idle: $idle, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityRulesTable extends ActivityRules
    with TableInfo<$ActivityRulesTable, ActivityRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<MatchTarget, String> matchTarget =
      GeneratedColumn<String>(
        'match_target',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('appId'),
      ).withConverter<MatchTarget>($ActivityRulesTable.$convertermatchTarget);
  @override
  late final GeneratedColumnWithTypeConverter<MatchType, String> matchType =
      GeneratedColumn<String>(
        'match_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('contains'),
      ).withConverter<MatchType>($ActivityRulesTable.$convertermatchType);
  static const VerificationMeta _patternMeta = const VerificationMeta(
    'pattern',
  );
  @override
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
    'pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DevicePlatform?, String>
  platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<DevicePlatform?>($ActivityRulesTable.$converterplatformn);
  @override
  late final GeneratedColumnWithTypeConverter<Productivity, String>
  productivity = GeneratedColumn<String>(
    'productivity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Productivity>($ActivityRulesTable.$converterproductivity);
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isBuiltinMeta = const VerificationMeta(
    'isBuiltin',
  );
  @override
  late final GeneratedColumn<bool> isBuiltin = GeneratedColumn<bool>(
    'is_builtin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_builtin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deleted,
    dirty,
    label,
    matchTarget,
    matchType,
    pattern,
    platform,
    productivity,
    categoryId,
    priority,
    enabled,
    isBuiltin,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('pattern')) {
      context.handle(
        _patternMeta,
        pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta),
      );
    } else if (isInserting) {
      context.missing(_patternMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('is_builtin')) {
      context.handle(
        _isBuiltinMeta,
        isBuiltin.isAcceptableOrUnknown(data['is_builtin']!, _isBuiltinMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      matchTarget: $ActivityRulesTable.$convertermatchTarget.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}match_target'],
        )!,
      ),
      matchType: $ActivityRulesTable.$convertermatchType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}match_type'],
        )!,
      ),
      pattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern'],
      )!,
      platform: $ActivityRulesTable.$converterplatformn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}platform'],
        ),
      ),
      productivity: $ActivityRulesTable.$converterproductivity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}productivity'],
        )!,
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      isBuiltin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_builtin'],
      )!,
    );
  }

  @override
  $ActivityRulesTable createAlias(String alias) {
    return $ActivityRulesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MatchTarget, String, String> $convertermatchTarget =
      const EnumNameConverter<MatchTarget>(MatchTarget.values);
  static JsonTypeConverter2<MatchType, String, String> $convertermatchType =
      const EnumNameConverter<MatchType>(MatchType.values);
  static JsonTypeConverter2<DevicePlatform, String, String> $converterplatform =
      const EnumNameConverter<DevicePlatform>(DevicePlatform.values);
  static JsonTypeConverter2<DevicePlatform?, String?, String?>
  $converterplatformn = JsonTypeConverter2.asNullable($converterplatform);
  static JsonTypeConverter2<Productivity, String, String>
  $converterproductivity = const EnumNameConverter<Productivity>(
    Productivity.values,
  );
}

class ActivityRule extends DataClass implements Insertable<ActivityRule> {
  final String id;
  final DateTime createdAt;

  /// Znacznik ostatniej zmiany. Ustawiany lokalnie przy każdym zapisie
  /// i porównywany z serwerem przy synchronizacji.
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;

  /// Etykieta dla człowieka („Gry na Steamie").
  final String label;
  final MatchTarget matchTarget;
  final MatchType matchType;
  final String pattern;

  /// Null = reguła działa na każdej platformie.
  final DevicePlatform? platform;
  final Productivity productivity;
  final String? categoryId;
  final int priority;
  final bool enabled;

  /// Reguła z zestawu wbudowanego. Można ją wyłączyć lub nadpisać,
  /// ale przy aktualizacji seeda wracają tylko wiersze wbudowane —
  /// twoje własne nigdy nie są ruszane.
  final bool isBuiltin;
  const ActivityRule({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    required this.label,
    required this.matchTarget,
    required this.matchType,
    required this.pattern,
    this.platform,
    required this.productivity,
    this.categoryId,
    required this.priority,
    required this.enabled,
    required this.isBuiltin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    map['label'] = Variable<String>(label);
    {
      map['match_target'] = Variable<String>(
        $ActivityRulesTable.$convertermatchTarget.toSql(matchTarget),
      );
    }
    {
      map['match_type'] = Variable<String>(
        $ActivityRulesTable.$convertermatchType.toSql(matchType),
      );
    }
    map['pattern'] = Variable<String>(pattern);
    if (!nullToAbsent || platform != null) {
      map['platform'] = Variable<String>(
        $ActivityRulesTable.$converterplatformn.toSql(platform),
      );
    }
    {
      map['productivity'] = Variable<String>(
        $ActivityRulesTable.$converterproductivity.toSql(productivity),
      );
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['priority'] = Variable<int>(priority);
    map['enabled'] = Variable<bool>(enabled);
    map['is_builtin'] = Variable<bool>(isBuiltin);
    return map;
  }

  ActivityRulesCompanion toCompanion(bool nullToAbsent) {
    return ActivityRulesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      label: Value(label),
      matchTarget: Value(matchTarget),
      matchType: Value(matchType),
      pattern: Value(pattern),
      platform: platform == null && nullToAbsent
          ? const Value.absent()
          : Value(platform),
      productivity: Value(productivity),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      priority: Value(priority),
      enabled: Value(enabled),
      isBuiltin: Value(isBuiltin),
    );
  }

  factory ActivityRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityRule(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      label: serializer.fromJson<String>(json['label']),
      matchTarget: $ActivityRulesTable.$convertermatchTarget.fromJson(
        serializer.fromJson<String>(json['matchTarget']),
      ),
      matchType: $ActivityRulesTable.$convertermatchType.fromJson(
        serializer.fromJson<String>(json['matchType']),
      ),
      pattern: serializer.fromJson<String>(json['pattern']),
      platform: $ActivityRulesTable.$converterplatformn.fromJson(
        serializer.fromJson<String?>(json['platform']),
      ),
      productivity: $ActivityRulesTable.$converterproductivity.fromJson(
        serializer.fromJson<String>(json['productivity']),
      ),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      priority: serializer.fromJson<int>(json['priority']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      isBuiltin: serializer.fromJson<bool>(json['isBuiltin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'label': serializer.toJson<String>(label),
      'matchTarget': serializer.toJson<String>(
        $ActivityRulesTable.$convertermatchTarget.toJson(matchTarget),
      ),
      'matchType': serializer.toJson<String>(
        $ActivityRulesTable.$convertermatchType.toJson(matchType),
      ),
      'pattern': serializer.toJson<String>(pattern),
      'platform': serializer.toJson<String?>(
        $ActivityRulesTable.$converterplatformn.toJson(platform),
      ),
      'productivity': serializer.toJson<String>(
        $ActivityRulesTable.$converterproductivity.toJson(productivity),
      ),
      'categoryId': serializer.toJson<String?>(categoryId),
      'priority': serializer.toJson<int>(priority),
      'enabled': serializer.toJson<bool>(enabled),
      'isBuiltin': serializer.toJson<bool>(isBuiltin),
    };
  }

  ActivityRule copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    String? label,
    MatchTarget? matchTarget,
    MatchType? matchType,
    String? pattern,
    Value<DevicePlatform?> platform = const Value.absent(),
    Productivity? productivity,
    Value<String?> categoryId = const Value.absent(),
    int? priority,
    bool? enabled,
    bool? isBuiltin,
  }) => ActivityRule(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    label: label ?? this.label,
    matchTarget: matchTarget ?? this.matchTarget,
    matchType: matchType ?? this.matchType,
    pattern: pattern ?? this.pattern,
    platform: platform.present ? platform.value : this.platform,
    productivity: productivity ?? this.productivity,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    priority: priority ?? this.priority,
    enabled: enabled ?? this.enabled,
    isBuiltin: isBuiltin ?? this.isBuiltin,
  );
  ActivityRule copyWithCompanion(ActivityRulesCompanion data) {
    return ActivityRule(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      label: data.label.present ? data.label.value : this.label,
      matchTarget: data.matchTarget.present
          ? data.matchTarget.value
          : this.matchTarget,
      matchType: data.matchType.present ? data.matchType.value : this.matchType,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      platform: data.platform.present ? data.platform.value : this.platform,
      productivity: data.productivity.present
          ? data.productivity.value
          : this.productivity,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      priority: data.priority.present ? data.priority.value : this.priority,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      isBuiltin: data.isBuiltin.present ? data.isBuiltin.value : this.isBuiltin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityRule(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('label: $label, ')
          ..write('matchTarget: $matchTarget, ')
          ..write('matchType: $matchType, ')
          ..write('pattern: $pattern, ')
          ..write('platform: $platform, ')
          ..write('productivity: $productivity, ')
          ..write('categoryId: $categoryId, ')
          ..write('priority: $priority, ')
          ..write('enabled: $enabled, ')
          ..write('isBuiltin: $isBuiltin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deleted,
    dirty,
    label,
    matchTarget,
    matchType,
    pattern,
    platform,
    productivity,
    categoryId,
    priority,
    enabled,
    isBuiltin,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityRule &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.label == this.label &&
          other.matchTarget == this.matchTarget &&
          other.matchType == this.matchType &&
          other.pattern == this.pattern &&
          other.platform == this.platform &&
          other.productivity == this.productivity &&
          other.categoryId == this.categoryId &&
          other.priority == this.priority &&
          other.enabled == this.enabled &&
          other.isBuiltin == this.isBuiltin);
}

class ActivityRulesCompanion extends UpdateCompanion<ActivityRule> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<String> label;
  final Value<MatchTarget> matchTarget;
  final Value<MatchType> matchType;
  final Value<String> pattern;
  final Value<DevicePlatform?> platform;
  final Value<Productivity> productivity;
  final Value<String?> categoryId;
  final Value<int> priority;
  final Value<bool> enabled;
  final Value<bool> isBuiltin;
  final Value<int> rowid;
  const ActivityRulesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.label = const Value.absent(),
    this.matchTarget = const Value.absent(),
    this.matchType = const Value.absent(),
    this.pattern = const Value.absent(),
    this.platform = const Value.absent(),
    this.productivity = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.priority = const Value.absent(),
    this.enabled = const Value.absent(),
    this.isBuiltin = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityRulesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.label = const Value.absent(),
    this.matchTarget = const Value.absent(),
    this.matchType = const Value.absent(),
    required String pattern,
    this.platform = const Value.absent(),
    required Productivity productivity,
    this.categoryId = const Value.absent(),
    this.priority = const Value.absent(),
    this.enabled = const Value.absent(),
    this.isBuiltin = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       pattern = Value(pattern),
       productivity = Value(productivity);
  static Insertable<ActivityRule> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<String>? label,
    Expression<String>? matchTarget,
    Expression<String>? matchType,
    Expression<String>? pattern,
    Expression<String>? platform,
    Expression<String>? productivity,
    Expression<String>? categoryId,
    Expression<int>? priority,
    Expression<bool>? enabled,
    Expression<bool>? isBuiltin,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (label != null) 'label': label,
      if (matchTarget != null) 'match_target': matchTarget,
      if (matchType != null) 'match_type': matchType,
      if (pattern != null) 'pattern': pattern,
      if (platform != null) 'platform': platform,
      if (productivity != null) 'productivity': productivity,
      if (categoryId != null) 'category_id': categoryId,
      if (priority != null) 'priority': priority,
      if (enabled != null) 'enabled': enabled,
      if (isBuiltin != null) 'is_builtin': isBuiltin,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityRulesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<String>? label,
    Value<MatchTarget>? matchTarget,
    Value<MatchType>? matchType,
    Value<String>? pattern,
    Value<DevicePlatform?>? platform,
    Value<Productivity>? productivity,
    Value<String?>? categoryId,
    Value<int>? priority,
    Value<bool>? enabled,
    Value<bool>? isBuiltin,
    Value<int>? rowid,
  }) {
    return ActivityRulesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      label: label ?? this.label,
      matchTarget: matchTarget ?? this.matchTarget,
      matchType: matchType ?? this.matchType,
      pattern: pattern ?? this.pattern,
      platform: platform ?? this.platform,
      productivity: productivity ?? this.productivity,
      categoryId: categoryId ?? this.categoryId,
      priority: priority ?? this.priority,
      enabled: enabled ?? this.enabled,
      isBuiltin: isBuiltin ?? this.isBuiltin,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (matchTarget.present) {
      map['match_target'] = Variable<String>(
        $ActivityRulesTable.$convertermatchTarget.toSql(matchTarget.value),
      );
    }
    if (matchType.present) {
      map['match_type'] = Variable<String>(
        $ActivityRulesTable.$convertermatchType.toSql(matchType.value),
      );
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(
        $ActivityRulesTable.$converterplatformn.toSql(platform.value),
      );
    }
    if (productivity.present) {
      map['productivity'] = Variable<String>(
        $ActivityRulesTable.$converterproductivity.toSql(productivity.value),
      );
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (isBuiltin.present) {
      map['is_builtin'] = Variable<bool>(isBuiltin.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityRulesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('label: $label, ')
          ..write('matchTarget: $matchTarget, ')
          ..write('matchType: $matchType, ')
          ..write('pattern: $pattern, ')
          ..write('platform: $platform, ')
          ..write('productivity: $productivity, ')
          ..write('categoryId: $categoryId, ')
          ..write('priority: $priority, ')
          ..write('enabled: $enabled, ')
          ..write('isBuiltin: $isBuiltin, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IdeasTable extends Ideas with TableInfo<$IdeasTable, Idea> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IdeasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 300,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<IdeaKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('feature'),
      ).withConverter<IdeaKind>($IdeasTable.$converterkind);
  @override
  late final GeneratedColumnWithTypeConverter<IdeaStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('inbox'),
      ).withConverter<IdeaStatus>($IdeasTable.$converterstatus);
  static const VerificationMeta _impactMeta = const VerificationMeta('impact');
  @override
  late final GeneratedColumn<int> impact = GeneratedColumn<int>(
    'impact',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _effortMeta = const VerificationMeta('effort');
  @override
  late final GeneratedColumn<int> effort = GeneratedColumn<int>(
    'effort',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _exportedAtMeta = const VerificationMeta(
    'exportedAt',
  );
  @override
  late final GeneratedColumn<DateTime> exportedAt = GeneratedColumn<DateTime>(
    'exported_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceScreenMeta = const VerificationMeta(
    'sourceScreen',
  );
  @override
  late final GeneratedColumn<String> sourceScreen = GeneratedColumn<String>(
    'source_screen',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deleted,
    dirty,
    title,
    body,
    kind,
    status,
    impact,
    effort,
    tags,
    exportedAt,
    sourceScreen,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ideas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Idea> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('impact')) {
      context.handle(
        _impactMeta,
        impact.isAcceptableOrUnknown(data['impact']!, _impactMeta),
      );
    }
    if (data.containsKey('effort')) {
      context.handle(
        _effortMeta,
        effort.isAcceptableOrUnknown(data['effort']!, _effortMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('exported_at')) {
      context.handle(
        _exportedAtMeta,
        exportedAt.isAcceptableOrUnknown(data['exported_at']!, _exportedAtMeta),
      );
    }
    if (data.containsKey('source_screen')) {
      context.handle(
        _sourceScreenMeta,
        sourceScreen.isAcceptableOrUnknown(
          data['source_screen']!,
          _sourceScreenMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Idea map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Idea(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      ),
      kind: $IdeasTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      status: $IdeasTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      impact: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}impact'],
      ),
      effort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}effort'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      exportedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}exported_at'],
      ),
      sourceScreen: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_screen'],
      ),
    );
  }

  @override
  $IdeasTable createAlias(String alias) {
    return $IdeasTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<IdeaKind, String, String> $converterkind =
      const EnumNameConverter<IdeaKind>(IdeaKind.values);
  static JsonTypeConverter2<IdeaStatus, String, String> $converterstatus =
      const EnumNameConverter<IdeaStatus>(IdeaStatus.values);
}

class Idea extends DataClass implements Insertable<Idea> {
  final String id;
  final DateTime createdAt;

  /// Znacznik ostatniej zmiany. Ustawiany lokalnie przy każdym zapisie
  /// i porównywany z serwerem przy synchronizacji.
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final String title;
  final String? body;
  final IdeaKind kind;
  final IdeaStatus status;

  /// 1–5. Razem z [effort] daje prostą macierz „co robić najpierw".
  final int? impact;
  final int? effort;

  /// Tagi po przecinku. Świadomie bez osobnej tabeli — przy kilkuset
  /// wierszach relacja wiele-do-wielu to koszt bez zysku.
  final String tags;

  /// Kiedy ostatnio trafiło do eksportu. Pozwala wygenerować paczkę
  /// „tylko nowe od ostatniego razu" zamiast wklejać wszystko od nowa.
  final DateTime? exportedAt;

  /// Gdzie byłeś w aplikacji, gdy to zapisałeś — kontekst, który
  /// inaczej wyparowuje do następnego dnia.
  final String? sourceScreen;
  const Idea({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    required this.title,
    this.body,
    required this.kind,
    required this.status,
    this.impact,
    this.effort,
    required this.tags,
    this.exportedAt,
    this.sourceScreen,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    {
      map['kind'] = Variable<String>($IdeasTable.$converterkind.toSql(kind));
    }
    {
      map['status'] = Variable<String>(
        $IdeasTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || impact != null) {
      map['impact'] = Variable<int>(impact);
    }
    if (!nullToAbsent || effort != null) {
      map['effort'] = Variable<int>(effort);
    }
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || exportedAt != null) {
      map['exported_at'] = Variable<DateTime>(exportedAt);
    }
    if (!nullToAbsent || sourceScreen != null) {
      map['source_screen'] = Variable<String>(sourceScreen);
    }
    return map;
  }

  IdeasCompanion toCompanion(bool nullToAbsent) {
    return IdeasCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      title: Value(title),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      kind: Value(kind),
      status: Value(status),
      impact: impact == null && nullToAbsent
          ? const Value.absent()
          : Value(impact),
      effort: effort == null && nullToAbsent
          ? const Value.absent()
          : Value(effort),
      tags: Value(tags),
      exportedAt: exportedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(exportedAt),
      sourceScreen: sourceScreen == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceScreen),
    );
  }

  factory Idea.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Idea(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String?>(json['body']),
      kind: $IdeasTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      status: $IdeasTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      impact: serializer.fromJson<int?>(json['impact']),
      effort: serializer.fromJson<int?>(json['effort']),
      tags: serializer.fromJson<String>(json['tags']),
      exportedAt: serializer.fromJson<DateTime?>(json['exportedAt']),
      sourceScreen: serializer.fromJson<String?>(json['sourceScreen']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String?>(body),
      'kind': serializer.toJson<String>(
        $IdeasTable.$converterkind.toJson(kind),
      ),
      'status': serializer.toJson<String>(
        $IdeasTable.$converterstatus.toJson(status),
      ),
      'impact': serializer.toJson<int?>(impact),
      'effort': serializer.toJson<int?>(effort),
      'tags': serializer.toJson<String>(tags),
      'exportedAt': serializer.toJson<DateTime?>(exportedAt),
      'sourceScreen': serializer.toJson<String?>(sourceScreen),
    };
  }

  Idea copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    String? title,
    Value<String?> body = const Value.absent(),
    IdeaKind? kind,
    IdeaStatus? status,
    Value<int?> impact = const Value.absent(),
    Value<int?> effort = const Value.absent(),
    String? tags,
    Value<DateTime?> exportedAt = const Value.absent(),
    Value<String?> sourceScreen = const Value.absent(),
  }) => Idea(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    title: title ?? this.title,
    body: body.present ? body.value : this.body,
    kind: kind ?? this.kind,
    status: status ?? this.status,
    impact: impact.present ? impact.value : this.impact,
    effort: effort.present ? effort.value : this.effort,
    tags: tags ?? this.tags,
    exportedAt: exportedAt.present ? exportedAt.value : this.exportedAt,
    sourceScreen: sourceScreen.present ? sourceScreen.value : this.sourceScreen,
  );
  Idea copyWithCompanion(IdeasCompanion data) {
    return Idea(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      kind: data.kind.present ? data.kind.value : this.kind,
      status: data.status.present ? data.status.value : this.status,
      impact: data.impact.present ? data.impact.value : this.impact,
      effort: data.effort.present ? data.effort.value : this.effort,
      tags: data.tags.present ? data.tags.value : this.tags,
      exportedAt: data.exportedAt.present
          ? data.exportedAt.value
          : this.exportedAt,
      sourceScreen: data.sourceScreen.present
          ? data.sourceScreen.value
          : this.sourceScreen,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Idea(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('impact: $impact, ')
          ..write('effort: $effort, ')
          ..write('tags: $tags, ')
          ..write('exportedAt: $exportedAt, ')
          ..write('sourceScreen: $sourceScreen')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deleted,
    dirty,
    title,
    body,
    kind,
    status,
    impact,
    effort,
    tags,
    exportedAt,
    sourceScreen,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Idea &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.title == this.title &&
          other.body == this.body &&
          other.kind == this.kind &&
          other.status == this.status &&
          other.impact == this.impact &&
          other.effort == this.effort &&
          other.tags == this.tags &&
          other.exportedAt == this.exportedAt &&
          other.sourceScreen == this.sourceScreen);
}

class IdeasCompanion extends UpdateCompanion<Idea> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<String> title;
  final Value<String?> body;
  final Value<IdeaKind> kind;
  final Value<IdeaStatus> status;
  final Value<int?> impact;
  final Value<int?> effort;
  final Value<String> tags;
  final Value<DateTime?> exportedAt;
  final Value<String?> sourceScreen;
  final Value<int> rowid;
  const IdeasCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.kind = const Value.absent(),
    this.status = const Value.absent(),
    this.impact = const Value.absent(),
    this.effort = const Value.absent(),
    this.tags = const Value.absent(),
    this.exportedAt = const Value.absent(),
    this.sourceScreen = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IdeasCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    required String title,
    this.body = const Value.absent(),
    this.kind = const Value.absent(),
    this.status = const Value.absent(),
    this.impact = const Value.absent(),
    this.effort = const Value.absent(),
    this.tags = const Value.absent(),
    this.exportedAt = const Value.absent(),
    this.sourceScreen = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       title = Value(title);
  static Insertable<Idea> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? kind,
    Expression<String>? status,
    Expression<int>? impact,
    Expression<int>? effort,
    Expression<String>? tags,
    Expression<DateTime>? exportedAt,
    Expression<String>? sourceScreen,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (kind != null) 'kind': kind,
      if (status != null) 'status': status,
      if (impact != null) 'impact': impact,
      if (effort != null) 'effort': effort,
      if (tags != null) 'tags': tags,
      if (exportedAt != null) 'exported_at': exportedAt,
      if (sourceScreen != null) 'source_screen': sourceScreen,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IdeasCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<String>? title,
    Value<String?>? body,
    Value<IdeaKind>? kind,
    Value<IdeaStatus>? status,
    Value<int?>? impact,
    Value<int?>? effort,
    Value<String>? tags,
    Value<DateTime?>? exportedAt,
    Value<String?>? sourceScreen,
    Value<int>? rowid,
  }) {
    return IdeasCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      title: title ?? this.title,
      body: body ?? this.body,
      kind: kind ?? this.kind,
      status: status ?? this.status,
      impact: impact ?? this.impact,
      effort: effort ?? this.effort,
      tags: tags ?? this.tags,
      exportedAt: exportedAt ?? this.exportedAt,
      sourceScreen: sourceScreen ?? this.sourceScreen,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $IdeasTable.$converterkind.toSql(kind.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $IdeasTable.$converterstatus.toSql(status.value),
      );
    }
    if (impact.present) {
      map['impact'] = Variable<int>(impact.value);
    }
    if (effort.present) {
      map['effort'] = Variable<int>(effort.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (exportedAt.present) {
      map['exported_at'] = Variable<DateTime>(exportedAt.value);
    }
    if (sourceScreen.present) {
      map['source_screen'] = Variable<String>(sourceScreen.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IdeasCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('impact: $impact, ')
          ..write('effort: $effort, ')
          ..write('tags: $tags, ')
          ..write('exportedAt: $exportedAt, ')
          ..write('sourceScreen: $sourceScreen, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DayPlansTable extends DayPlans with TableInfo<$DayPlansTable, DayPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _availableMinutesMeta = const VerificationMeta(
    'availableMinutes',
  );
  @override
  late final GeneratedColumn<int> availableMinutes = GeneratedColumn<int>(
    'available_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intentionMeta = const VerificationMeta(
    'intention',
  );
  @override
  late final GeneratedColumn<String> intention = GeneratedColumn<String>(
    'intention',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _winsMeta = const VerificationMeta('wins');
  @override
  late final GeneratedColumn<String> wins = GeneratedColumn<String>(
    'wins',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _strugglesMeta = const VerificationMeta(
    'struggles',
  );
  @override
  late final GeneratedColumn<String> struggles = GeneratedColumn<String>(
    'struggles',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _changeTomorrowMeta = const VerificationMeta(
    'changeTomorrow',
  );
  @override
  late final GeneratedColumn<String> changeTomorrow = GeneratedColumn<String>(
    'change_tomorrow',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moodEndMeta = const VerificationMeta(
    'moodEnd',
  );
  @override
  late final GeneratedColumn<int> moodEnd = GeneratedColumn<int>(
    'mood_end',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reviewedAtMeta = const VerificationMeta(
    'reviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reviewedAt = GeneratedColumn<DateTime>(
    'reviewed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deleted,
    dirty,
    date,
    availableMinutes,
    intention,
    wins,
    struggles,
    changeTomorrow,
    moodEnd,
    reviewedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<DayPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('available_minutes')) {
      context.handle(
        _availableMinutesMeta,
        availableMinutes.isAcceptableOrUnknown(
          data['available_minutes']!,
          _availableMinutesMeta,
        ),
      );
    }
    if (data.containsKey('intention')) {
      context.handle(
        _intentionMeta,
        intention.isAcceptableOrUnknown(data['intention']!, _intentionMeta),
      );
    }
    if (data.containsKey('wins')) {
      context.handle(
        _winsMeta,
        wins.isAcceptableOrUnknown(data['wins']!, _winsMeta),
      );
    }
    if (data.containsKey('struggles')) {
      context.handle(
        _strugglesMeta,
        struggles.isAcceptableOrUnknown(data['struggles']!, _strugglesMeta),
      );
    }
    if (data.containsKey('change_tomorrow')) {
      context.handle(
        _changeTomorrowMeta,
        changeTomorrow.isAcceptableOrUnknown(
          data['change_tomorrow']!,
          _changeTomorrowMeta,
        ),
      );
    }
    if (data.containsKey('mood_end')) {
      context.handle(
        _moodEndMeta,
        moodEnd.isAcceptableOrUnknown(data['mood_end']!, _moodEndMeta),
      );
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
        _reviewedAtMeta,
        reviewedAt.isAcceptableOrUnknown(data['reviewed_at']!, _reviewedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DayPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      availableMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}available_minutes'],
      ),
      intention: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}intention'],
      ),
      wins: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wins'],
      ),
      struggles: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}struggles'],
      ),
      changeTomorrow: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}change_tomorrow'],
      ),
      moodEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood_end'],
      ),
      reviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reviewed_at'],
      ),
    );
  }

  @override
  $DayPlansTable createAlias(String alias) {
    return $DayPlansTable(attachedDatabase, alias);
  }
}

class DayPlan extends DataClass implements Insertable<DayPlan> {
  final String id;
  final DateTime createdAt;

  /// Znacznik ostatniej zmiany. Ustawiany lokalnie przy każdym zapisie
  /// i porównywany z serwerem przy synchronizacji.
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;

  /// `YYYY-MM-DD`. Unikalne — jeden plan na dzień.
  final String date;

  /// Ile realnie masz dziś wolnego czasu, w minutach.
  ///
  /// Bez tej liczby nie da się powiedzieć „to się nie zmieści",
  /// a to jest jedyny mechanizm w całej aplikacji, który naprawdę
  /// ratuje przed zaplanowaniem dziesięciu godzin na pięć.
  final int? availableMinutes;

  /// Jedno zdanie na rano: po co jest ten dzień.
  final String? intention;

  /// Wieczorne podsumowanie własnymi słowami — co poszło dobrze.
  ///
  /// Rozdzielone od [struggles], a nie wrzucone w jedno pole „notatki",
  /// bo puste pole zachęca do napisania niczego. Dwa konkretne pytania
  /// dostają odpowiedzi; jedno ogólne nie dostaje żadnej.
  final String? wins;

  /// Co nie wyszło i dlaczego.
  final String? struggles;

  /// Jedna rzecz do zmiany jutro. Celowo pojedyncza —
  /// lista pięciu postanowień to lista zero postanowień.
  final String? changeTomorrow;

  /// Ocena dnia 1–5, wystawiona ręcznie przy zamykaniu podsumowania.
  final int? moodEnd;

  /// Kiedy domknięto podsumowanie. Null = dzień jeszcze nierozliczony,
  /// po tym pozna się, które dni pominąłeś.
  final DateTime? reviewedAt;
  const DayPlan({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    required this.date,
    this.availableMinutes,
    this.intention,
    this.wins,
    this.struggles,
    this.changeTomorrow,
    this.moodEnd,
    this.reviewedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || availableMinutes != null) {
      map['available_minutes'] = Variable<int>(availableMinutes);
    }
    if (!nullToAbsent || intention != null) {
      map['intention'] = Variable<String>(intention);
    }
    if (!nullToAbsent || wins != null) {
      map['wins'] = Variable<String>(wins);
    }
    if (!nullToAbsent || struggles != null) {
      map['struggles'] = Variable<String>(struggles);
    }
    if (!nullToAbsent || changeTomorrow != null) {
      map['change_tomorrow'] = Variable<String>(changeTomorrow);
    }
    if (!nullToAbsent || moodEnd != null) {
      map['mood_end'] = Variable<int>(moodEnd);
    }
    if (!nullToAbsent || reviewedAt != null) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt);
    }
    return map;
  }

  DayPlansCompanion toCompanion(bool nullToAbsent) {
    return DayPlansCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      date: Value(date),
      availableMinutes: availableMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(availableMinutes),
      intention: intention == null && nullToAbsent
          ? const Value.absent()
          : Value(intention),
      wins: wins == null && nullToAbsent ? const Value.absent() : Value(wins),
      struggles: struggles == null && nullToAbsent
          ? const Value.absent()
          : Value(struggles),
      changeTomorrow: changeTomorrow == null && nullToAbsent
          ? const Value.absent()
          : Value(changeTomorrow),
      moodEnd: moodEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(moodEnd),
      reviewedAt: reviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewedAt),
    );
  }

  factory DayPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayPlan(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      date: serializer.fromJson<String>(json['date']),
      availableMinutes: serializer.fromJson<int?>(json['availableMinutes']),
      intention: serializer.fromJson<String?>(json['intention']),
      wins: serializer.fromJson<String?>(json['wins']),
      struggles: serializer.fromJson<String?>(json['struggles']),
      changeTomorrow: serializer.fromJson<String?>(json['changeTomorrow']),
      moodEnd: serializer.fromJson<int?>(json['moodEnd']),
      reviewedAt: serializer.fromJson<DateTime?>(json['reviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'date': serializer.toJson<String>(date),
      'availableMinutes': serializer.toJson<int?>(availableMinutes),
      'intention': serializer.toJson<String?>(intention),
      'wins': serializer.toJson<String?>(wins),
      'struggles': serializer.toJson<String?>(struggles),
      'changeTomorrow': serializer.toJson<String?>(changeTomorrow),
      'moodEnd': serializer.toJson<int?>(moodEnd),
      'reviewedAt': serializer.toJson<DateTime?>(reviewedAt),
    };
  }

  DayPlan copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    String? date,
    Value<int?> availableMinutes = const Value.absent(),
    Value<String?> intention = const Value.absent(),
    Value<String?> wins = const Value.absent(),
    Value<String?> struggles = const Value.absent(),
    Value<String?> changeTomorrow = const Value.absent(),
    Value<int?> moodEnd = const Value.absent(),
    Value<DateTime?> reviewedAt = const Value.absent(),
  }) => DayPlan(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    date: date ?? this.date,
    availableMinutes: availableMinutes.present
        ? availableMinutes.value
        : this.availableMinutes,
    intention: intention.present ? intention.value : this.intention,
    wins: wins.present ? wins.value : this.wins,
    struggles: struggles.present ? struggles.value : this.struggles,
    changeTomorrow: changeTomorrow.present
        ? changeTomorrow.value
        : this.changeTomorrow,
    moodEnd: moodEnd.present ? moodEnd.value : this.moodEnd,
    reviewedAt: reviewedAt.present ? reviewedAt.value : this.reviewedAt,
  );
  DayPlan copyWithCompanion(DayPlansCompanion data) {
    return DayPlan(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      date: data.date.present ? data.date.value : this.date,
      availableMinutes: data.availableMinutes.present
          ? data.availableMinutes.value
          : this.availableMinutes,
      intention: data.intention.present ? data.intention.value : this.intention,
      wins: data.wins.present ? data.wins.value : this.wins,
      struggles: data.struggles.present ? data.struggles.value : this.struggles,
      changeTomorrow: data.changeTomorrow.present
          ? data.changeTomorrow.value
          : this.changeTomorrow,
      moodEnd: data.moodEnd.present ? data.moodEnd.value : this.moodEnd,
      reviewedAt: data.reviewedAt.present
          ? data.reviewedAt.value
          : this.reviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayPlan(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('date: $date, ')
          ..write('availableMinutes: $availableMinutes, ')
          ..write('intention: $intention, ')
          ..write('wins: $wins, ')
          ..write('struggles: $struggles, ')
          ..write('changeTomorrow: $changeTomorrow, ')
          ..write('moodEnd: $moodEnd, ')
          ..write('reviewedAt: $reviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deleted,
    dirty,
    date,
    availableMinutes,
    intention,
    wins,
    struggles,
    changeTomorrow,
    moodEnd,
    reviewedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayPlan &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.date == this.date &&
          other.availableMinutes == this.availableMinutes &&
          other.intention == this.intention &&
          other.wins == this.wins &&
          other.struggles == this.struggles &&
          other.changeTomorrow == this.changeTomorrow &&
          other.moodEnd == this.moodEnd &&
          other.reviewedAt == this.reviewedAt);
}

class DayPlansCompanion extends UpdateCompanion<DayPlan> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<String> date;
  final Value<int?> availableMinutes;
  final Value<String?> intention;
  final Value<String?> wins;
  final Value<String?> struggles;
  final Value<String?> changeTomorrow;
  final Value<int?> moodEnd;
  final Value<DateTime?> reviewedAt;
  final Value<int> rowid;
  const DayPlansCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.date = const Value.absent(),
    this.availableMinutes = const Value.absent(),
    this.intention = const Value.absent(),
    this.wins = const Value.absent(),
    this.struggles = const Value.absent(),
    this.changeTomorrow = const Value.absent(),
    this.moodEnd = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DayPlansCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    required String date,
    this.availableMinutes = const Value.absent(),
    this.intention = const Value.absent(),
    this.wins = const Value.absent(),
    this.struggles = const Value.absent(),
    this.changeTomorrow = const Value.absent(),
    this.moodEnd = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       date = Value(date);
  static Insertable<DayPlan> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<String>? date,
    Expression<int>? availableMinutes,
    Expression<String>? intention,
    Expression<String>? wins,
    Expression<String>? struggles,
    Expression<String>? changeTomorrow,
    Expression<int>? moodEnd,
    Expression<DateTime>? reviewedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (date != null) 'date': date,
      if (availableMinutes != null) 'available_minutes': availableMinutes,
      if (intention != null) 'intention': intention,
      if (wins != null) 'wins': wins,
      if (struggles != null) 'struggles': struggles,
      if (changeTomorrow != null) 'change_tomorrow': changeTomorrow,
      if (moodEnd != null) 'mood_end': moodEnd,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DayPlansCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<String>? date,
    Value<int?>? availableMinutes,
    Value<String?>? intention,
    Value<String?>? wins,
    Value<String?>? struggles,
    Value<String?>? changeTomorrow,
    Value<int?>? moodEnd,
    Value<DateTime?>? reviewedAt,
    Value<int>? rowid,
  }) {
    return DayPlansCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      date: date ?? this.date,
      availableMinutes: availableMinutes ?? this.availableMinutes,
      intention: intention ?? this.intention,
      wins: wins ?? this.wins,
      struggles: struggles ?? this.struggles,
      changeTomorrow: changeTomorrow ?? this.changeTomorrow,
      moodEnd: moodEnd ?? this.moodEnd,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (availableMinutes.present) {
      map['available_minutes'] = Variable<int>(availableMinutes.value);
    }
    if (intention.present) {
      map['intention'] = Variable<String>(intention.value);
    }
    if (wins.present) {
      map['wins'] = Variable<String>(wins.value);
    }
    if (struggles.present) {
      map['struggles'] = Variable<String>(struggles.value);
    }
    if (changeTomorrow.present) {
      map['change_tomorrow'] = Variable<String>(changeTomorrow.value);
    }
    if (moodEnd.present) {
      map['mood_end'] = Variable<int>(moodEnd.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayPlansCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('date: $date, ')
          ..write('availableMinutes: $availableMinutes, ')
          ..write('intention: $intention, ')
          ..write('wins: $wins, ')
          ..write('struggles: $struggles, ')
          ..write('changeTomorrow: $changeTomorrow, ')
          ..write('moodEnd: $moodEnd, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DevicesTable extends Devices with TableInfo<$DevicesTable, Device> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DevicePlatform, String> platform =
      GeneratedColumn<String>(
        'platform',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DevicePlatform>($DevicesTable.$converterplatform);
  static const VerificationMeta _lastSeenAtMeta = const VerificationMeta(
    'lastSeenAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeenAt = GeneratedColumn<DateTime>(
    'last_seen_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deleted,
    dirty,
    name,
    platform,
    lastSeenAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Device> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('last_seen_at')) {
      context.handle(
        _lastSeenAtMeta,
        lastSeenAt.isAcceptableOrUnknown(
          data['last_seen_at']!,
          _lastSeenAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSeenAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Device map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Device(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      platform: $DevicesTable.$converterplatform.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}platform'],
        )!,
      ),
      lastSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen_at'],
      )!,
    );
  }

  @override
  $DevicesTable createAlias(String alias) {
    return $DevicesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DevicePlatform, String, String> $converterplatform =
      const EnumNameConverter<DevicePlatform>(DevicePlatform.values);
}

class Device extends DataClass implements Insertable<Device> {
  final String id;
  final DateTime createdAt;

  /// Znacznik ostatniej zmiany. Ustawiany lokalnie przy każdym zapisie
  /// i porównywany z serwerem przy synchronizacji.
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final String name;
  final DevicePlatform platform;
  final DateTime lastSeenAt;
  const Device({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    required this.name,
    required this.platform,
    required this.lastSeenAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    map['name'] = Variable<String>(name);
    {
      map['platform'] = Variable<String>(
        $DevicesTable.$converterplatform.toSql(platform),
      );
    }
    map['last_seen_at'] = Variable<DateTime>(lastSeenAt);
    return map;
  }

  DevicesCompanion toCompanion(bool nullToAbsent) {
    return DevicesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      name: Value(name),
      platform: Value(platform),
      lastSeenAt: Value(lastSeenAt),
    );
  }

  factory Device.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Device(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      name: serializer.fromJson<String>(json['name']),
      platform: $DevicesTable.$converterplatform.fromJson(
        serializer.fromJson<String>(json['platform']),
      ),
      lastSeenAt: serializer.fromJson<DateTime>(json['lastSeenAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'name': serializer.toJson<String>(name),
      'platform': serializer.toJson<String>(
        $DevicesTable.$converterplatform.toJson(platform),
      ),
      'lastSeenAt': serializer.toJson<DateTime>(lastSeenAt),
    };
  }

  Device copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    String? name,
    DevicePlatform? platform,
    DateTime? lastSeenAt,
  }) => Device(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    name: name ?? this.name,
    platform: platform ?? this.platform,
    lastSeenAt: lastSeenAt ?? this.lastSeenAt,
  );
  Device copyWithCompanion(DevicesCompanion data) {
    return Device(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      name: data.name.present ? data.name.value : this.name,
      platform: data.platform.present ? data.platform.value : this.platform,
      lastSeenAt: data.lastSeenAt.present
          ? data.lastSeenAt.value
          : this.lastSeenAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Device(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('name: $name, ')
          ..write('platform: $platform, ')
          ..write('lastSeenAt: $lastSeenAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deleted,
    dirty,
    name,
    platform,
    lastSeenAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Device &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.name == this.name &&
          other.platform == this.platform &&
          other.lastSeenAt == this.lastSeenAt);
}

class DevicesCompanion extends UpdateCompanion<Device> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<String> name;
  final Value<DevicePlatform> platform;
  final Value<DateTime> lastSeenAt;
  final Value<int> rowid;
  const DevicesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.name = const Value.absent(),
    this.platform = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DevicesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    required String name,
    required DevicePlatform platform,
    required DateTime lastSeenAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name),
       platform = Value(platform),
       lastSeenAt = Value(lastSeenAt);
  static Insertable<Device> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<String>? name,
    Expression<String>? platform,
    Expression<DateTime>? lastSeenAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (name != null) 'name': name,
      if (platform != null) 'platform': platform,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DevicesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<String>? name,
    Value<DevicePlatform>? platform,
    Value<DateTime>? lastSeenAt,
    Value<int>? rowid,
  }) {
    return DevicesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      name: name ?? this.name,
      platform: platform ?? this.platform,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(
        $DevicesTable.$converterplatform.toSql(platform.value),
      );
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DevicesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('name: $name, ')
          ..write('platform: $platform, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSettingsTable extends LocalSettings
    with TableInfo<$LocalSettingsTable, LocalSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  LocalSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $LocalSettingsTable createAlias(String alias) {
    return $LocalSettingsTable(attachedDatabase, alias);
  }
}

class LocalSetting extends DataClass implements Insertable<LocalSetting> {
  final String key;
  final String value;
  const LocalSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  LocalSettingsCompanion toCompanion(bool nullToAbsent) {
    return LocalSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory LocalSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  LocalSetting copyWith({String? key, String? value}) =>
      LocalSetting(key: key ?? this.key, value: value ?? this.value);
  LocalSetting copyWithCompanion(LocalSettingsCompanion data) {
    return LocalSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class LocalSettingsCompanion extends UpdateCompanion<LocalSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const LocalSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<LocalSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return LocalSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $TimeEntriesTable timeEntries = $TimeEntriesTable(this);
  late final $AppUsagesTable appUsages = $AppUsagesTable(this);
  late final $ActivityRulesTable activityRules = $ActivityRulesTable(this);
  late final $IdeasTable ideas = $IdeasTable(this);
  late final $DayPlansTable dayPlans = $DayPlansTable(this);
  late final $DevicesTable devices = $DevicesTable(this);
  late final $LocalSettingsTable localSettings = $LocalSettingsTable(this);
  late final Index idxCategoriesUpdated = Index(
    'idx_categories_updated',
    'CREATE INDEX idx_categories_updated ON categories (updated_at)',
  );
  late final Index idxTasksStatus = Index(
    'idx_tasks_status',
    'CREATE INDEX idx_tasks_status ON tasks (status)',
  );
  late final Index idxTasksPlanned = Index(
    'idx_tasks_planned',
    'CREATE INDEX idx_tasks_planned ON tasks (planned_for)',
  );
  late final Index idxTasksUpdated = Index(
    'idx_tasks_updated',
    'CREATE INDEX idx_tasks_updated ON tasks (updated_at)',
  );
  late final Index idxEntriesStarted = Index(
    'idx_entries_started',
    'CREATE INDEX idx_entries_started ON time_entries (started_at)',
  );
  late final Index idxEntriesTask = Index(
    'idx_entries_task',
    'CREATE INDEX idx_entries_task ON time_entries (task_id)',
  );
  late final Index idxEntriesUpdated = Index(
    'idx_entries_updated',
    'CREATE INDEX idx_entries_updated ON time_entries (updated_at)',
  );
  late final Index idxUsageStarted = Index(
    'idx_usage_started',
    'CREATE INDEX idx_usage_started ON app_usages (started_at)',
  );
  late final Index idxUsageUpdated = Index(
    'idx_usage_updated',
    'CREATE INDEX idx_usage_updated ON app_usages (updated_at)',
  );
  late final Index idxRulesUpdated = Index(
    'idx_rules_updated',
    'CREATE INDEX idx_rules_updated ON activity_rules (updated_at)',
  );
  late final Index idxIdeasUpdated = Index(
    'idx_ideas_updated',
    'CREATE INDEX idx_ideas_updated ON ideas (updated_at)',
  );
  late final Index idxDayplansUpdated = Index(
    'idx_dayplans_updated',
    'CREATE INDEX idx_dayplans_updated ON day_plans (updated_at)',
  );
  late final TaskDao taskDao = TaskDao(this as AppDatabase);
  late final TimeEntryDao timeEntryDao = TimeEntryDao(this as AppDatabase);
  late final AppUsageDao appUsageDao = AppUsageDao(this as AppDatabase);
  late final RuleDao ruleDao = RuleDao(this as AppDatabase);
  late final IdeaDao ideaDao = IdeaDao(this as AppDatabase);
  late final InsightDao insightDao = InsightDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    tasks,
    timeEntries,
    appUsages,
    activityRules,
    ideas,
    dayPlans,
    devices,
    localSettings,
    idxCategoriesUpdated,
    idxTasksStatus,
    idxTasksPlanned,
    idxTasksUpdated,
    idxEntriesStarted,
    idxEntriesTask,
    idxEntriesUpdated,
    idxUsageStarted,
    idxUsageUpdated,
    idxRulesUpdated,
    idxIdeasUpdated,
    idxDayplansUpdated,
  ];
}

typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  required String name,
  required int color,
  Value<String?> icon,
  Value<Productivity> defaultProductivity,
  Value<bool> archived,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<String> name,
  Value<int> color,
  Value<String?> icon,
  Value<Productivity> defaultProductivity,
  Value<bool> archived,
  Value<int> sortOrder,
  Value<int> rowid,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: 'categories__id__tasks__category_id',
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TimeEntriesTable, List<TimeEntry>>
  _timeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timeEntries,
    aliasName: 'categories__id__time_entries__category_id',
  );

  $$TimeEntriesTableProcessedTableManager get timeEntriesRefs {
    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_timeEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AppUsagesTable, List<AppUsage>>
  _appUsagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.appUsages,
    aliasName: 'categories__id__app_usages__category_id',
  );

  $$AppUsagesTableProcessedTableManager get appUsagesRefs {
    final manager = $$AppUsagesTableTableManager(
      $_db,
      $_db.appUsages,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_appUsagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ActivityRulesTable, List<ActivityRule>>
  _activityRulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.activityRules,
    aliasName: 'categories__id__activity_rules__category_id',
  );

  $$ActivityRulesTableProcessedTableManager get activityRulesRefs {
    final manager = $$ActivityRulesTableTableManager(
      $_db,
      $_db.activityRules,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_activityRulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Productivity, Productivity, String>
  get defaultProductivity => $composableBuilder(
    column: $table.defaultProductivity,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> timeEntriesRefs(
    Expression<bool> Function($$TimeEntriesTableFilterComposer f) f,
  ) {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> appUsagesRefs(
    Expression<bool> Function($$AppUsagesTableFilterComposer f) f,
  ) {
    final $$AppUsagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appUsages,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppUsagesTableFilterComposer(
            $db: $db,
            $table: $db.appUsages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> activityRulesRefs(
    Expression<bool> Function($$ActivityRulesTableFilterComposer f) f,
  ) {
    final $$ActivityRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activityRules,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivityRulesTableFilterComposer(
            $db: $db,
            $table: $db.activityRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultProductivity => $composableBuilder(
    column: $table.defaultProductivity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Productivity, String>
  get defaultProductivity => $composableBuilder(
    column: $table.defaultProductivity,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> timeEntriesRefs<T extends Object>(
    Expression<T> Function($$TimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> appUsagesRefs<T extends Object>(
    Expression<T> Function($$AppUsagesTableAnnotationComposer a) f,
  ) {
    final $$AppUsagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appUsages,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppUsagesTableAnnotationComposer(
            $db: $db,
            $table: $db.appUsages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> activityRulesRefs<T extends Object>(
    Expression<T> Function($$ActivityRulesTableAnnotationComposer a) f,
  ) {
    final $$ActivityRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activityRules,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivityRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.activityRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({
            bool tasksRefs,
            bool timeEntriesRefs,
            bool appUsagesRefs,
            bool activityRulesRefs,
          })
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<Productivity> defaultProductivity = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                name: name,
                color: color,
                icon: icon,
                defaultProductivity: defaultProductivity,
                archived: archived,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                required String name,
                required int color,
                Value<String?> icon = const Value.absent(),
                Value<Productivity> defaultProductivity = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                name: name,
                color: color,
                icon: icon,
                defaultProductivity: defaultProductivity,
                archived: archived,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, Category>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                tasksRefs = false,
                timeEntriesRefs = false,
                appUsagesRefs = false,
                activityRulesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (tasksRefs) db.tasks,
                    if (timeEntriesRefs) db.timeEntries,
                    if (appUsagesRefs) db.appUsages,
                    if (activityRulesRefs) db.activityRules,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (tasksRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Task
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._tasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).tasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (timeEntriesRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          TimeEntry
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._timeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).timeEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (appUsagesRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          AppUsage
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._appUsagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).appUsagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activityRulesRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          ActivityRule
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._activityRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).activityRulesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({
        bool tasksRefs,
        bool timeEntriesRefs,
        bool appUsagesRefs,
        bool activityRulesRefs,
      })
    >;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  required String title,
  Value<String?> notes,
  Value<String?> categoryId,
  Value<String?> parentId,
  Value<int?> estimateMinSeconds,
  Value<int?> estimateMaxSeconds,
  Value<bool> estimateWasSuggested,
  Value<TaskStatus> status,
  Value<EnergyKind?> energy,
  Value<TaskContext?> context,
  Value<int> priority,
  Value<DateTime?> dueAt,
  Value<DateTime?> startAt,
  Value<String?> plannedFor,
  Value<DateTime?> completedAt,
  Value<String?> recurrenceRule,
  Value<bool> recurrenceFromCompletion,
  Value<int> postponedCount,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<String> title,
  Value<String?> notes,
  Value<String?> categoryId,
  Value<String?> parentId,
  Value<int?> estimateMinSeconds,
  Value<int?> estimateMaxSeconds,
  Value<bool> estimateWasSuggested,
  Value<TaskStatus> status,
  Value<EnergyKind?> energy,
  Value<TaskContext?> context,
  Value<int> priority,
  Value<DateTime?> dueAt,
  Value<DateTime?> startAt,
  Value<String?> plannedFor,
  Value<DateTime?> completedAt,
  Value<String?> recurrenceRule,
  Value<bool> recurrenceFromCompletion,
  Value<int> postponedCount,
  Value<int> sortOrder,
  Value<int> rowid,
});

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, Task> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('tasks__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TimeEntriesTable, List<TimeEntry>>
  _timeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timeEntries,
    aliasName: 'tasks__id__time_entries__task_id',
  );

  $$TimeEntriesTableProcessedTableManager get timeEntriesRefs {
    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_timeEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimateMinSeconds => $composableBuilder(
    column: $table.estimateMinSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimateMaxSeconds => $composableBuilder(
    column: $table.estimateMaxSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get estimateWasSuggested => $composableBuilder(
    column: $table.estimateWasSuggested,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskStatus, TaskStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<EnergyKind?, EnergyKind, String> get energy =>
      $composableBuilder(
        column: $table.energy,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<TaskContext?, TaskContext, String>
  get context => $composableBuilder(
    column: $table.context,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plannedFor => $composableBuilder(
    column: $table.plannedFor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrenceRule => $composableBuilder(
    column: $table.recurrenceRule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get recurrenceFromCompletion => $composableBuilder(
    column: $table.recurrenceFromCompletion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get postponedCount => $composableBuilder(
    column: $table.postponedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> timeEntriesRefs(
    Expression<bool> Function($$TimeEntriesTableFilterComposer f) f,
  ) {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimateMinSeconds => $composableBuilder(
    column: $table.estimateMinSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimateMaxSeconds => $composableBuilder(
    column: $table.estimateMaxSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get estimateWasSuggested => $composableBuilder(
    column: $table.estimateWasSuggested,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get energy => $composableBuilder(
    column: $table.energy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get context => $composableBuilder(
    column: $table.context,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plannedFor => $composableBuilder(
    column: $table.plannedFor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrenceRule => $composableBuilder(
    column: $table.recurrenceRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get recurrenceFromCompletion => $composableBuilder(
    column: $table.recurrenceFromCompletion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get postponedCount => $composableBuilder(
    column: $table.postponedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<int> get estimateMinSeconds => $composableBuilder(
    column: $table.estimateMinSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimateMaxSeconds => $composableBuilder(
    column: $table.estimateMaxSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get estimateWasSuggested => $composableBuilder(
    column: $table.estimateWasSuggested,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TaskStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EnergyKind?, String> get energy =>
      $composableBuilder(column: $table.energy, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskContext?, String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<DateTime> get startAt =>
      $composableBuilder(column: $table.startAt, builder: (column) => column);

  GeneratedColumn<String> get plannedFor => $composableBuilder(
    column: $table.plannedFor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurrenceRule => $composableBuilder(
    column: $table.recurrenceRule,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get recurrenceFromCompletion => $composableBuilder(
    column: $table.recurrenceFromCompletion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get postponedCount => $composableBuilder(
    column: $table.postponedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> timeEntriesRefs<T extends Object>(
    Expression<T> Function($$TimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, $$TasksTableReferences),
          Task,
          PrefetchHooks Function({bool categoryId, bool timeEntriesRefs})
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<int?> estimateMinSeconds = const Value.absent(),
                Value<int?> estimateMaxSeconds = const Value.absent(),
                Value<bool> estimateWasSuggested = const Value.absent(),
                Value<TaskStatus> status = const Value.absent(),
                Value<EnergyKind?> energy = const Value.absent(),
                Value<TaskContext?> context = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<DateTime?> startAt = const Value.absent(),
                Value<String?> plannedFor = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> recurrenceRule = const Value.absent(),
                Value<bool> recurrenceFromCompletion = const Value.absent(),
                Value<int> postponedCount = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                title: title,
                notes: notes,
                categoryId: categoryId,
                parentId: parentId,
                estimateMinSeconds: estimateMinSeconds,
                estimateMaxSeconds: estimateMaxSeconds,
                estimateWasSuggested: estimateWasSuggested,
                status: status,
                energy: energy,
                context: context,
                priority: priority,
                dueAt: dueAt,
                startAt: startAt,
                plannedFor: plannedFor,
                completedAt: completedAt,
                recurrenceRule: recurrenceRule,
                recurrenceFromCompletion: recurrenceFromCompletion,
                postponedCount: postponedCount,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                required String title,
                Value<String?> notes = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<int?> estimateMinSeconds = const Value.absent(),
                Value<int?> estimateMaxSeconds = const Value.absent(),
                Value<bool> estimateWasSuggested = const Value.absent(),
                Value<TaskStatus> status = const Value.absent(),
                Value<EnergyKind?> energy = const Value.absent(),
                Value<TaskContext?> context = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<DateTime?> startAt = const Value.absent(),
                Value<String?> plannedFor = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> recurrenceRule = const Value.absent(),
                Value<bool> recurrenceFromCompletion = const Value.absent(),
                Value<int> postponedCount = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                title: title,
                notes: notes,
                categoryId: categoryId,
                parentId: parentId,
                estimateMinSeconds: estimateMinSeconds,
                estimateMaxSeconds: estimateMaxSeconds,
                estimateWasSuggested: estimateWasSuggested,
                status: status,
                energy: energy,
                context: context,
                priority: priority,
                dueAt: dueAt,
                startAt: startAt,
                plannedFor: plannedFor,
                completedAt: completedAt,
                recurrenceRule: recurrenceRule,
                recurrenceFromCompletion: recurrenceFromCompletion,
                postponedCount: postponedCount,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TasksTable, Task>(table),
                  $$TasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoryId = false, timeEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (timeEntriesRefs) db.timeEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$TasksTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$TasksTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (timeEntriesRefs)
                        await $_getPrefetchedData<Task, $TasksTable, TimeEntry>(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._timeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).timeEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, $$TasksTableReferences),
      Task,
      PrefetchHooks Function({bool categoryId, bool timeEntriesRefs})
    >;
typedef $$TimeEntriesTableCreateCompanionBuilder =
    TimeEntriesCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> deleted,
      Value<bool> dirty,
      Value<String?> taskId,
      Value<String?> categoryId,
      Value<String> description,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<Productivity?> productivity,
      Value<int?> moodAfter,
      Value<int?> energyAfter,
      Value<TimeEntrySource> source,
      Value<String> deviceId,
      Value<int> rowid,
    });
typedef $$TimeEntriesTableUpdateCompanionBuilder =
    TimeEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<bool> dirty,
      Value<String?> taskId,
      Value<String?> categoryId,
      Value<String> description,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<Productivity?> productivity,
      Value<int?> moodAfter,
      Value<int?> energyAfter,
      Value<TimeEntrySource> source,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$TimeEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $TimeEntriesTable, TimeEntry> {
  $$TimeEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TasksTable _taskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias('time_entries__task_id__tasks__id');

  $$TasksTableProcessedTableManager? get taskId {
    final $_column = $_itemColumn<String>('task_id');
    if ($_column == null) return null;
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('time_entries__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AppUsagesTable, List<AppUsage>>
  _appUsagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.appUsages,
    aliasName: 'time_entries__id__app_usages__time_entry_id',
  );

  $$AppUsagesTableProcessedTableManager get appUsagesRefs {
    final manager = $$AppUsagesTableTableManager(
      $_db,
      $_db.appUsages,
    ).filter((f) => f.timeEntryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_appUsagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TimeEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TimeEntriesTable> {
  $$TimeEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Productivity?, Productivity, String>
  get productivity => $composableBuilder(
    column: $table.productivity,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get moodAfter => $composableBuilder(
    column: $table.moodAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get energyAfter => $composableBuilder(
    column: $table.energyAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TimeEntrySource, TimeEntrySource, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> appUsagesRefs(
    Expression<bool> Function($$AppUsagesTableFilterComposer f) f,
  ) {
    final $$AppUsagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appUsages,
      getReferencedColumn: (t) => t.timeEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppUsagesTableFilterComposer(
            $db: $db,
            $table: $db.appUsages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TimeEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TimeEntriesTable> {
  $$TimeEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productivity => $composableBuilder(
    column: $table.productivity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get moodAfter => $composableBuilder(
    column: $table.moodAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get energyAfter => $composableBuilder(
    column: $table.energyAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimeEntriesTable> {
  $$TimeEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Productivity?, String> get productivity =>
      $composableBuilder(
        column: $table.productivity,
        builder: (column) => column,
      );

  GeneratedColumn<int> get moodAfter =>
      $composableBuilder(column: $table.moodAfter, builder: (column) => column);

  GeneratedColumn<int> get energyAfter => $composableBuilder(
    column: $table.energyAfter,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TimeEntrySource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> appUsagesRefs<T extends Object>(
    Expression<T> Function($$AppUsagesTableAnnotationComposer a) f,
  ) {
    final $$AppUsagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appUsages,
      getReferencedColumn: (t) => t.timeEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppUsagesTableAnnotationComposer(
            $db: $db,
            $table: $db.appUsages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TimeEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimeEntriesTable,
          TimeEntry,
          $$TimeEntriesTableFilterComposer,
          $$TimeEntriesTableOrderingComposer,
          $$TimeEntriesTableAnnotationComposer,
          $$TimeEntriesTableCreateCompanionBuilder,
          $$TimeEntriesTableUpdateCompanionBuilder,
          (TimeEntry, $$TimeEntriesTableReferences),
          TimeEntry,
          PrefetchHooks Function({
            bool taskId,
            bool categoryId,
            bool appUsagesRefs,
          })
        > {
  $$TimeEntriesTableTableManager(_$AppDatabase db, $TimeEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimeEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimeEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimeEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<Productivity?> productivity = const Value.absent(),
                Value<int?> moodAfter = const Value.absent(),
                Value<int?> energyAfter = const Value.absent(),
                Value<TimeEntrySource> source = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimeEntriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                taskId: taskId,
                categoryId: categoryId,
                description: description,
                startedAt: startedAt,
                endedAt: endedAt,
                productivity: productivity,
                moodAfter: moodAfter,
                energyAfter: energyAfter,
                source: source,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> description = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<Productivity?> productivity = const Value.absent(),
                Value<int?> moodAfter = const Value.absent(),
                Value<int?> energyAfter = const Value.absent(),
                Value<TimeEntrySource> source = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimeEntriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                taskId: taskId,
                categoryId: categoryId,
                description: description,
                startedAt: startedAt,
                endedAt: endedAt,
                productivity: productivity,
                moodAfter: moodAfter,
                energyAfter: energyAfter,
                source: source,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TimeEntriesTable, TimeEntry>(table),
                  $$TimeEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({taskId = false, categoryId = false, appUsagesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (appUsagesRefs) db.appUsages],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (taskId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.taskId,
                            referencedTable: $$TimeEntriesTableReferences
                                ._taskIdTable(db),
                            referencedColumn: $$TimeEntriesTableReferences
                                ._taskIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$TimeEntriesTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$TimeEntriesTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (appUsagesRefs)
                        await $_getPrefetchedData<
                          TimeEntry,
                          $TimeEntriesTable,
                          AppUsage
                        >(
                          currentTable: table,
                          referencedTable: $$TimeEntriesTableReferences
                              ._appUsagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TimeEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).appUsagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.timeEntryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TimeEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimeEntriesTable,
      TimeEntry,
      $$TimeEntriesTableFilterComposer,
      $$TimeEntriesTableOrderingComposer,
      $$TimeEntriesTableAnnotationComposer,
      $$TimeEntriesTableCreateCompanionBuilder,
      $$TimeEntriesTableUpdateCompanionBuilder,
      (TimeEntry, $$TimeEntriesTableReferences),
      TimeEntry,
      PrefetchHooks Function({bool taskId, bool categoryId, bool appUsagesRefs})
    >;
typedef $$AppUsagesTableCreateCompanionBuilder = AppUsagesCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  required String deviceId,
  Value<DevicePlatform> platform,
  required String appId,
  Value<String> appName,
  Value<String?> windowTitle,
  required DateTime startedAt,
  required DateTime endedAt,
  required int durationSeconds,
  Value<Productivity> productivity,
  Value<String?> ruleId,
  Value<String?> categoryId,
  Value<bool> reviewed,
  Value<String?> timeEntryId,
  Value<bool> idle,
  Value<int> rowid,
});
typedef $$AppUsagesTableUpdateCompanionBuilder = AppUsagesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<String> deviceId,
  Value<DevicePlatform> platform,
  Value<String> appId,
  Value<String> appName,
  Value<String?> windowTitle,
  Value<DateTime> startedAt,
  Value<DateTime> endedAt,
  Value<int> durationSeconds,
  Value<Productivity> productivity,
  Value<String?> ruleId,
  Value<String?> categoryId,
  Value<bool> reviewed,
  Value<String?> timeEntryId,
  Value<bool> idle,
  Value<int> rowid,
});

final class $$AppUsagesTableReferences
    extends BaseReferences<_$AppDatabase, $AppUsagesTable, AppUsage> {
  $$AppUsagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('app_usages__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TimeEntriesTable _timeEntryIdTable(_$AppDatabase db) =>
      db.timeEntries.createAlias('app_usages__time_entry_id__time_entries__id');

  $$TimeEntriesTableProcessedTableManager? get timeEntryId {
    final $_column = $_itemColumn<String>('time_entry_id');
    if ($_column == null) return null;
    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_timeEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AppUsagesTableFilterComposer
    extends Composer<_$AppDatabase, $AppUsagesTable> {
  $$AppUsagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DevicePlatform, DevicePlatform, String>
  get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get appId => $composableBuilder(
    column: $table.appId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appName => $composableBuilder(
    column: $table.appName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get windowTitle => $composableBuilder(
    column: $table.windowTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Productivity, Productivity, String>
  get productivity => $composableBuilder(
    column: $table.productivity,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get ruleId => $composableBuilder(
    column: $table.ruleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reviewed => $composableBuilder(
    column: $table.reviewed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get idle => $composableBuilder(
    column: $table.idle,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TimeEntriesTableFilterComposer get timeEntryId {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.timeEntryId,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppUsagesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppUsagesTable> {
  $$AppUsagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appId => $composableBuilder(
    column: $table.appId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appName => $composableBuilder(
    column: $table.appName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get windowTitle => $composableBuilder(
    column: $table.windowTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productivity => $composableBuilder(
    column: $table.productivity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleId => $composableBuilder(
    column: $table.ruleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reviewed => $composableBuilder(
    column: $table.reviewed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get idle => $composableBuilder(
    column: $table.idle,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TimeEntriesTableOrderingComposer get timeEntryId {
    final $$TimeEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.timeEntryId,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppUsagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppUsagesTable> {
  $$AppUsagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DevicePlatform, String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get appId =>
      $composableBuilder(column: $table.appId, builder: (column) => column);

  GeneratedColumn<String> get appName =>
      $composableBuilder(column: $table.appName, builder: (column) => column);

  GeneratedColumn<String> get windowTitle => $composableBuilder(
    column: $table.windowTitle,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Productivity, String> get productivity =>
      $composableBuilder(
        column: $table.productivity,
        builder: (column) => column,
      );

  GeneratedColumn<String> get ruleId =>
      $composableBuilder(column: $table.ruleId, builder: (column) => column);

  GeneratedColumn<bool> get reviewed =>
      $composableBuilder(column: $table.reviewed, builder: (column) => column);

  GeneratedColumn<bool> get idle =>
      $composableBuilder(column: $table.idle, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TimeEntriesTableAnnotationComposer get timeEntryId {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.timeEntryId,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppUsagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppUsagesTable,
          AppUsage,
          $$AppUsagesTableFilterComposer,
          $$AppUsagesTableOrderingComposer,
          $$AppUsagesTableAnnotationComposer,
          $$AppUsagesTableCreateCompanionBuilder,
          $$AppUsagesTableUpdateCompanionBuilder,
          (AppUsage, $$AppUsagesTableReferences),
          AppUsage,
          PrefetchHooks Function({bool categoryId, bool timeEntryId})
        > {
  $$AppUsagesTableTableManager(_$AppDatabase db, $AppUsagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppUsagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppUsagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppUsagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DevicePlatform> platform = const Value.absent(),
                Value<String> appId = const Value.absent(),
                Value<String> appName = const Value.absent(),
                Value<String?> windowTitle = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> endedAt = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<Productivity> productivity = const Value.absent(),
                Value<String?> ruleId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<bool> reviewed = const Value.absent(),
                Value<String?> timeEntryId = const Value.absent(),
                Value<bool> idle = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppUsagesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                deviceId: deviceId,
                platform: platform,
                appId: appId,
                appName: appName,
                windowTitle: windowTitle,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                productivity: productivity,
                ruleId: ruleId,
                categoryId: categoryId,
                reviewed: reviewed,
                timeEntryId: timeEntryId,
                idle: idle,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                required String deviceId,
                Value<DevicePlatform> platform = const Value.absent(),
                required String appId,
                Value<String> appName = const Value.absent(),
                Value<String?> windowTitle = const Value.absent(),
                required DateTime startedAt,
                required DateTime endedAt,
                required int durationSeconds,
                Value<Productivity> productivity = const Value.absent(),
                Value<String?> ruleId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<bool> reviewed = const Value.absent(),
                Value<String?> timeEntryId = const Value.absent(),
                Value<bool> idle = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppUsagesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                deviceId: deviceId,
                platform: platform,
                appId: appId,
                appName: appName,
                windowTitle: windowTitle,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                productivity: productivity,
                ruleId: ruleId,
                categoryId: categoryId,
                reviewed: reviewed,
                timeEntryId: timeEntryId,
                idle: idle,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppUsagesTable, AppUsage>(table),
                  $$AppUsagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false, timeEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$AppUsagesTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$AppUsagesTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (timeEntryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.timeEntryId,
                        referencedTable: $$AppUsagesTableReferences
                            ._timeEntryIdTable(db),
                        referencedColumn: $$AppUsagesTableReferences
                            ._timeEntryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AppUsagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppUsagesTable,
      AppUsage,
      $$AppUsagesTableFilterComposer,
      $$AppUsagesTableOrderingComposer,
      $$AppUsagesTableAnnotationComposer,
      $$AppUsagesTableCreateCompanionBuilder,
      $$AppUsagesTableUpdateCompanionBuilder,
      (AppUsage, $$AppUsagesTableReferences),
      AppUsage,
      PrefetchHooks Function({bool categoryId, bool timeEntryId})
    >;
typedef $$ActivityRulesTableCreateCompanionBuilder =
    ActivityRulesCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> deleted,
      Value<bool> dirty,
      Value<String> label,
      Value<MatchTarget> matchTarget,
      Value<MatchType> matchType,
      required String pattern,
      Value<DevicePlatform?> platform,
      required Productivity productivity,
      Value<String?> categoryId,
      Value<int> priority,
      Value<bool> enabled,
      Value<bool> isBuiltin,
      Value<int> rowid,
    });
typedef $$ActivityRulesTableUpdateCompanionBuilder =
    ActivityRulesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<bool> dirty,
      Value<String> label,
      Value<MatchTarget> matchTarget,
      Value<MatchType> matchType,
      Value<String> pattern,
      Value<DevicePlatform?> platform,
      Value<Productivity> productivity,
      Value<String?> categoryId,
      Value<int> priority,
      Value<bool> enabled,
      Value<bool> isBuiltin,
      Value<int> rowid,
    });

final class $$ActivityRulesTableReferences
    extends BaseReferences<_$AppDatabase, $ActivityRulesTable, ActivityRule> {
  $$ActivityRulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('activity_rules__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActivityRulesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityRulesTable> {
  $$ActivityRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MatchTarget, MatchTarget, String>
  get matchTarget => $composableBuilder(
    column: $table.matchTarget,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<MatchType, MatchType, String> get matchType =>
      $composableBuilder(
        column: $table.matchType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DevicePlatform?, DevicePlatform, String>
  get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Productivity, Productivity, String>
  get productivity => $composableBuilder(
    column: $table.productivity,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBuiltin => $composableBuilder(
    column: $table.isBuiltin,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityRulesTable> {
  $$ActivityRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matchTarget => $composableBuilder(
    column: $table.matchTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matchType => $composableBuilder(
    column: $table.matchType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productivity => $composableBuilder(
    column: $table.productivity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBuiltin => $composableBuilder(
    column: $table.isBuiltin,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityRulesTable> {
  $$ActivityRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MatchTarget, String> get matchTarget =>
      $composableBuilder(
        column: $table.matchTarget,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<MatchType, String> get matchType =>
      $composableBuilder(column: $table.matchType, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DevicePlatform?, String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Productivity, String> get productivity =>
      $composableBuilder(
        column: $table.productivity,
        builder: (column) => column,
      );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get isBuiltin =>
      $composableBuilder(column: $table.isBuiltin, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityRulesTable,
          ActivityRule,
          $$ActivityRulesTableFilterComposer,
          $$ActivityRulesTableOrderingComposer,
          $$ActivityRulesTableAnnotationComposer,
          $$ActivityRulesTableCreateCompanionBuilder,
          $$ActivityRulesTableUpdateCompanionBuilder,
          (ActivityRule, $$ActivityRulesTableReferences),
          ActivityRule,
          PrefetchHooks Function({bool categoryId})
        > {
  $$ActivityRulesTableTableManager(_$AppDatabase db, $ActivityRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<MatchTarget> matchTarget = const Value.absent(),
                Value<MatchType> matchType = const Value.absent(),
                Value<String> pattern = const Value.absent(),
                Value<DevicePlatform?> platform = const Value.absent(),
                Value<Productivity> productivity = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> isBuiltin = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityRulesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                label: label,
                matchTarget: matchTarget,
                matchType: matchType,
                pattern: pattern,
                platform: platform,
                productivity: productivity,
                categoryId: categoryId,
                priority: priority,
                enabled: enabled,
                isBuiltin: isBuiltin,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<MatchTarget> matchTarget = const Value.absent(),
                Value<MatchType> matchType = const Value.absent(),
                required String pattern,
                Value<DevicePlatform?> platform = const Value.absent(),
                required Productivity productivity,
                Value<String?> categoryId = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> isBuiltin = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityRulesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                label: label,
                matchTarget: matchTarget,
                matchType: matchType,
                pattern: pattern,
                platform: platform,
                productivity: productivity,
                categoryId: categoryId,
                priority: priority,
                enabled: enabled,
                isBuiltin: isBuiltin,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActivityRulesTable, ActivityRule>(table),
                  $$ActivityRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$ActivityRulesTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$ActivityRulesTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActivityRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityRulesTable,
      ActivityRule,
      $$ActivityRulesTableFilterComposer,
      $$ActivityRulesTableOrderingComposer,
      $$ActivityRulesTableAnnotationComposer,
      $$ActivityRulesTableCreateCompanionBuilder,
      $$ActivityRulesTableUpdateCompanionBuilder,
      (ActivityRule, $$ActivityRulesTableReferences),
      ActivityRule,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$IdeasTableCreateCompanionBuilder = IdeasCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  required String title,
  Value<String?> body,
  Value<IdeaKind> kind,
  Value<IdeaStatus> status,
  Value<int?> impact,
  Value<int?> effort,
  Value<String> tags,
  Value<DateTime?> exportedAt,
  Value<String?> sourceScreen,
  Value<int> rowid,
});
typedef $$IdeasTableUpdateCompanionBuilder = IdeasCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<String> title,
  Value<String?> body,
  Value<IdeaKind> kind,
  Value<IdeaStatus> status,
  Value<int?> impact,
  Value<int?> effort,
  Value<String> tags,
  Value<DateTime?> exportedAt,
  Value<String?> sourceScreen,
  Value<int> rowid,
});

class $$IdeasTableFilterComposer extends Composer<_$AppDatabase, $IdeasTable> {
  $$IdeasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<IdeaKind, IdeaKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<IdeaStatus, IdeaStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get impact => $composableBuilder(
    column: $table.impact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get effort => $composableBuilder(
    column: $table.effort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get exportedAt => $composableBuilder(
    column: $table.exportedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceScreen => $composableBuilder(
    column: $table.sourceScreen,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IdeasTableOrderingComposer
    extends Composer<_$AppDatabase, $IdeasTable> {
  $$IdeasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get impact => $composableBuilder(
    column: $table.impact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get effort => $composableBuilder(
    column: $table.effort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get exportedAt => $composableBuilder(
    column: $table.exportedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceScreen => $composableBuilder(
    column: $table.sourceScreen,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IdeasTableAnnotationComposer
    extends Composer<_$AppDatabase, $IdeasTable> {
  $$IdeasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumnWithTypeConverter<IdeaKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumnWithTypeConverter<IdeaStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get impact =>
      $composableBuilder(column: $table.impact, builder: (column) => column);

  GeneratedColumn<int> get effort =>
      $composableBuilder(column: $table.effort, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get exportedAt => $composableBuilder(
    column: $table.exportedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceScreen => $composableBuilder(
    column: $table.sourceScreen,
    builder: (column) => column,
  );
}

class $$IdeasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IdeasTable,
          Idea,
          $$IdeasTableFilterComposer,
          $$IdeasTableOrderingComposer,
          $$IdeasTableAnnotationComposer,
          $$IdeasTableCreateCompanionBuilder,
          $$IdeasTableUpdateCompanionBuilder,
          (Idea, BaseReferences<_$AppDatabase, $IdeasTable, Idea>),
          Idea,
          PrefetchHooks Function()
        > {
  $$IdeasTableTableManager(_$AppDatabase db, $IdeasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IdeasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IdeasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IdeasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> body = const Value.absent(),
                Value<IdeaKind> kind = const Value.absent(),
                Value<IdeaStatus> status = const Value.absent(),
                Value<int?> impact = const Value.absent(),
                Value<int?> effort = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<DateTime?> exportedAt = const Value.absent(),
                Value<String?> sourceScreen = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdeasCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                title: title,
                body: body,
                kind: kind,
                status: status,
                impact: impact,
                effort: effort,
                tags: tags,
                exportedAt: exportedAt,
                sourceScreen: sourceScreen,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                required String title,
                Value<String?> body = const Value.absent(),
                Value<IdeaKind> kind = const Value.absent(),
                Value<IdeaStatus> status = const Value.absent(),
                Value<int?> impact = const Value.absent(),
                Value<int?> effort = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<DateTime?> exportedAt = const Value.absent(),
                Value<String?> sourceScreen = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdeasCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                title: title,
                body: body,
                kind: kind,
                status: status,
                impact: impact,
                effort: effort,
                tags: tags,
                exportedAt: exportedAt,
                sourceScreen: sourceScreen,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IdeasTable, Idea>(table),
                  BaseReferences<_$AppDatabase, $IdeasTable, Idea>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IdeasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IdeasTable,
      Idea,
      $$IdeasTableFilterComposer,
      $$IdeasTableOrderingComposer,
      $$IdeasTableAnnotationComposer,
      $$IdeasTableCreateCompanionBuilder,
      $$IdeasTableUpdateCompanionBuilder,
      (Idea, BaseReferences<_$AppDatabase, $IdeasTable, Idea>),
      Idea,
      PrefetchHooks Function()
    >;
typedef $$DayPlansTableCreateCompanionBuilder = DayPlansCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  required String date,
  Value<int?> availableMinutes,
  Value<String?> intention,
  Value<String?> wins,
  Value<String?> struggles,
  Value<String?> changeTomorrow,
  Value<int?> moodEnd,
  Value<DateTime?> reviewedAt,
  Value<int> rowid,
});
typedef $$DayPlansTableUpdateCompanionBuilder = DayPlansCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<String> date,
  Value<int?> availableMinutes,
  Value<String?> intention,
  Value<String?> wins,
  Value<String?> struggles,
  Value<String?> changeTomorrow,
  Value<int?> moodEnd,
  Value<DateTime?> reviewedAt,
  Value<int> rowid,
});

class $$DayPlansTableFilterComposer
    extends Composer<_$AppDatabase, $DayPlansTable> {
  $$DayPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get availableMinutes => $composableBuilder(
    column: $table.availableMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get intention => $composableBuilder(
    column: $table.intention,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wins => $composableBuilder(
    column: $table.wins,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get struggles => $composableBuilder(
    column: $table.struggles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changeTomorrow => $composableBuilder(
    column: $table.changeTomorrow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get moodEnd => $composableBuilder(
    column: $table.moodEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DayPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $DayPlansTable> {
  $$DayPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get availableMinutes => $composableBuilder(
    column: $table.availableMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get intention => $composableBuilder(
    column: $table.intention,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wins => $composableBuilder(
    column: $table.wins,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get struggles => $composableBuilder(
    column: $table.struggles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changeTomorrow => $composableBuilder(
    column: $table.changeTomorrow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get moodEnd => $composableBuilder(
    column: $table.moodEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DayPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayPlansTable> {
  $$DayPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get availableMinutes => $composableBuilder(
    column: $table.availableMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get intention =>
      $composableBuilder(column: $table.intention, builder: (column) => column);

  GeneratedColumn<String> get wins =>
      $composableBuilder(column: $table.wins, builder: (column) => column);

  GeneratedColumn<String> get struggles =>
      $composableBuilder(column: $table.struggles, builder: (column) => column);

  GeneratedColumn<String> get changeTomorrow => $composableBuilder(
    column: $table.changeTomorrow,
    builder: (column) => column,
  );

  GeneratedColumn<int> get moodEnd =>
      $composableBuilder(column: $table.moodEnd, builder: (column) => column);

  GeneratedColumn<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => column,
  );
}

class $$DayPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DayPlansTable,
          DayPlan,
          $$DayPlansTableFilterComposer,
          $$DayPlansTableOrderingComposer,
          $$DayPlansTableAnnotationComposer,
          $$DayPlansTableCreateCompanionBuilder,
          $$DayPlansTableUpdateCompanionBuilder,
          (DayPlan, BaseReferences<_$AppDatabase, $DayPlansTable, DayPlan>),
          DayPlan,
          PrefetchHooks Function()
        > {
  $$DayPlansTableTableManager(_$AppDatabase db, $DayPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int?> availableMinutes = const Value.absent(),
                Value<String?> intention = const Value.absent(),
                Value<String?> wins = const Value.absent(),
                Value<String?> struggles = const Value.absent(),
                Value<String?> changeTomorrow = const Value.absent(),
                Value<int?> moodEnd = const Value.absent(),
                Value<DateTime?> reviewedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayPlansCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                date: date,
                availableMinutes: availableMinutes,
                intention: intention,
                wins: wins,
                struggles: struggles,
                changeTomorrow: changeTomorrow,
                moodEnd: moodEnd,
                reviewedAt: reviewedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                required String date,
                Value<int?> availableMinutes = const Value.absent(),
                Value<String?> intention = const Value.absent(),
                Value<String?> wins = const Value.absent(),
                Value<String?> struggles = const Value.absent(),
                Value<String?> changeTomorrow = const Value.absent(),
                Value<int?> moodEnd = const Value.absent(),
                Value<DateTime?> reviewedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayPlansCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                date: date,
                availableMinutes: availableMinutes,
                intention: intention,
                wins: wins,
                struggles: struggles,
                changeTomorrow: changeTomorrow,
                moodEnd: moodEnd,
                reviewedAt: reviewedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DayPlansTable, DayPlan>(table),
                  BaseReferences<_$AppDatabase, $DayPlansTable, DayPlan>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DayPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DayPlansTable,
      DayPlan,
      $$DayPlansTableFilterComposer,
      $$DayPlansTableOrderingComposer,
      $$DayPlansTableAnnotationComposer,
      $$DayPlansTableCreateCompanionBuilder,
      $$DayPlansTableUpdateCompanionBuilder,
      (DayPlan, BaseReferences<_$AppDatabase, $DayPlansTable, DayPlan>),
      DayPlan,
      PrefetchHooks Function()
    >;
typedef $$DevicesTableCreateCompanionBuilder = DevicesCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  required String name,
  required DevicePlatform platform,
  required DateTime lastSeenAt,
  Value<int> rowid,
});
typedef $$DevicesTableUpdateCompanionBuilder = DevicesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<String> name,
  Value<DevicePlatform> platform,
  Value<DateTime> lastSeenAt,
  Value<int> rowid,
});

class $$DevicesTableFilterComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DevicePlatform, DevicePlatform, String>
  get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DevicePlatform, String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => column,
  );
}

class $$DevicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DevicesTable,
          Device,
          $$DevicesTableFilterComposer,
          $$DevicesTableOrderingComposer,
          $$DevicesTableAnnotationComposer,
          $$DevicesTableCreateCompanionBuilder,
          $$DevicesTableUpdateCompanionBuilder,
          (Device, BaseReferences<_$AppDatabase, $DevicesTable, Device>),
          Device,
          PrefetchHooks Function()
        > {
  $$DevicesTableTableManager(_$AppDatabase db, $DevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DevicePlatform> platform = const Value.absent(),
                Value<DateTime> lastSeenAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DevicesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                name: name,
                platform: platform,
                lastSeenAt: lastSeenAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                required String name,
                required DevicePlatform platform,
                required DateTime lastSeenAt,
                Value<int> rowid = const Value.absent(),
              }) => DevicesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                name: name,
                platform: platform,
                lastSeenAt: lastSeenAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DevicesTable, Device>(table),
                  BaseReferences<_$AppDatabase, $DevicesTable, Device>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DevicesTable,
      Device,
      $$DevicesTableFilterComposer,
      $$DevicesTableOrderingComposer,
      $$DevicesTableAnnotationComposer,
      $$DevicesTableCreateCompanionBuilder,
      $$DevicesTableUpdateCompanionBuilder,
      (Device, BaseReferences<_$AppDatabase, $DevicesTable, Device>),
      Device,
      PrefetchHooks Function()
    >;
typedef $$LocalSettingsTableCreateCompanionBuilder =
    LocalSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$LocalSettingsTableUpdateCompanionBuilder =
    LocalSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$LocalSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$LocalSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalSettingsTable,
          LocalSetting,
          $$LocalSettingsTableFilterComposer,
          $$LocalSettingsTableOrderingComposer,
          $$LocalSettingsTableAnnotationComposer,
          $$LocalSettingsTableCreateCompanionBuilder,
          $$LocalSettingsTableUpdateCompanionBuilder,
          (
            LocalSetting,
            BaseReferences<_$AppDatabase, $LocalSettingsTable, LocalSetting>,
          ),
          LocalSetting,
          PrefetchHooks Function()
        > {
  $$LocalSettingsTableTableManager(_$AppDatabase db, $LocalSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => LocalSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => LocalSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalSettingsTable, LocalSetting>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalSettingsTable,
                    LocalSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalSettingsTable,
      LocalSetting,
      $$LocalSettingsTableFilterComposer,
      $$LocalSettingsTableOrderingComposer,
      $$LocalSettingsTableAnnotationComposer,
      $$LocalSettingsTableCreateCompanionBuilder,
      $$LocalSettingsTableUpdateCompanionBuilder,
      (
        LocalSetting,
        BaseReferences<_$AppDatabase, $LocalSettingsTable, LocalSetting>,
      ),
      LocalSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$TimeEntriesTableTableManager get timeEntries =>
      $$TimeEntriesTableTableManager(_db, _db.timeEntries);
  $$AppUsagesTableTableManager get appUsages =>
      $$AppUsagesTableTableManager(_db, _db.appUsages);
  $$ActivityRulesTableTableManager get activityRules =>
      $$ActivityRulesTableTableManager(_db, _db.activityRules);
  $$IdeasTableTableManager get ideas =>
      $$IdeasTableTableManager(_db, _db.ideas);
  $$DayPlansTableTableManager get dayPlans =>
      $$DayPlansTableTableManager(_db, _db.dayPlans);
  $$DevicesTableTableManager get devices =>
      $$DevicesTableTableManager(_db, _db.devices);
  $$LocalSettingsTableTableManager get localSettings =>
      $$LocalSettingsTableTableManager(_db, _db.localSettings);
}
