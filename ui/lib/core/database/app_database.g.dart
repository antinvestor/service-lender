// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalClientsTable extends LocalClients
    with TableInfo<$LocalClientsTable, LocalClient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _agentIdMeta = const VerificationMeta(
    'agentId',
  );
  @override
  late final GeneratedColumn<String> agentId = GeneratedColumn<String>(
    'agent_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<int> state = GeneratedColumn<int>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _propertiesJsonMeta = const VerificationMeta(
    'propertiesJson',
  );
  @override
  late final GeneratedColumn<String> propertiesJson = GeneratedColumn<String>(
    'properties_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, int> syncStatus =
      GeneratedColumn<int>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: Constant(SyncStatus.pending.index),
      ).withConverter<SyncStatus>($LocalClientsTable.$convertersyncStatus);
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    rowId,
    id,
    name,
    profileId,
    agentId,
    state,
    propertiesJson,
    syncStatus,
    syncError,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_clients';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalClient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    }
    if (data.containsKey('agent_id')) {
      context.handle(
        _agentIdMeta,
        agentId.isAcceptableOrUnknown(data['agent_id']!, _agentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_agentIdMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('properties_json')) {
      context.handle(
        _propertiesJsonMeta,
        propertiesJson.isAcceptableOrUnknown(
          data['properties_json']!,
          _propertiesJsonMeta,
        ),
      );
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  LocalClient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalClient(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      agentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}agent_id'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}state'],
      )!,
      propertiesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}properties_json'],
      )!,
      syncStatus: $LocalClientsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalClientsTable createAlias(String alias) {
    return $LocalClientsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, int, int> $convertersyncStatus =
      const EnumIndexConverter<SyncStatus>(SyncStatus.values);
}

class LocalClient extends DataClass implements Insertable<LocalClient> {
  /// Local auto-increment primary key for Drift.
  final int rowId;

  /// Backend ID. Empty string for records not yet synced.
  final String id;

  /// Display name of the client.
  final String name;

  /// Profile service user ID.
  final String profileId;

  /// Agent managing this client.
  final String agentId;

  /// Current state (maps to STATE enum: 0=CREATED, 2=ACTIVE, etc.).
  final int state;

  /// JSON-encoded properties (google.protobuf.Struct equivalent).
  final String propertiesJson;

  /// Sync status: synced, pending, or failed.
  final SyncStatus syncStatus;

  /// Last sync error message (null if no error).
  final String? syncError;

  /// When this record was created locally.
  final DateTime createdAt;

  /// When this record was last modified locally.
  final DateTime updatedAt;
  const LocalClient({
    required this.rowId,
    required this.id,
    required this.name,
    required this.profileId,
    required this.agentId,
    required this.state,
    required this.propertiesJson,
    required this.syncStatus,
    this.syncError,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['profile_id'] = Variable<String>(profileId);
    map['agent_id'] = Variable<String>(agentId);
    map['state'] = Variable<int>(state);
    map['properties_json'] = Variable<String>(propertiesJson);
    {
      map['sync_status'] = Variable<int>(
        $LocalClientsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalClientsCompanion toCompanion(bool nullToAbsent) {
    return LocalClientsCompanion(
      rowId: Value(rowId),
      id: Value(id),
      name: Value(name),
      profileId: Value(profileId),
      agentId: Value(agentId),
      state: Value(state),
      propertiesJson: Value(propertiesJson),
      syncStatus: Value(syncStatus),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalClient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalClient(
      rowId: serializer.fromJson<int>(json['rowId']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      profileId: serializer.fromJson<String>(json['profileId']),
      agentId: serializer.fromJson<String>(json['agentId']),
      state: serializer.fromJson<int>(json['state']),
      propertiesJson: serializer.fromJson<String>(json['propertiesJson']),
      syncStatus: $LocalClientsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<int>(json['syncStatus']),
      ),
      syncError: serializer.fromJson<String?>(json['syncError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'profileId': serializer.toJson<String>(profileId),
      'agentId': serializer.toJson<String>(agentId),
      'state': serializer.toJson<int>(state),
      'propertiesJson': serializer.toJson<String>(propertiesJson),
      'syncStatus': serializer.toJson<int>(
        $LocalClientsTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'syncError': serializer.toJson<String?>(syncError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalClient copyWith({
    int? rowId,
    String? id,
    String? name,
    String? profileId,
    String? agentId,
    int? state,
    String? propertiesJson,
    SyncStatus? syncStatus,
    Value<String?> syncError = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LocalClient(
    rowId: rowId ?? this.rowId,
    id: id ?? this.id,
    name: name ?? this.name,
    profileId: profileId ?? this.profileId,
    agentId: agentId ?? this.agentId,
    state: state ?? this.state,
    propertiesJson: propertiesJson ?? this.propertiesJson,
    syncStatus: syncStatus ?? this.syncStatus,
    syncError: syncError.present ? syncError.value : this.syncError,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalClient copyWithCompanion(LocalClientsCompanion data) {
    return LocalClient(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      agentId: data.agentId.present ? data.agentId.value : this.agentId,
      state: data.state.present ? data.state.value : this.state,
      propertiesJson: data.propertiesJson.present
          ? data.propertiesJson.value
          : this.propertiesJson,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalClient(')
          ..write('rowId: $rowId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('profileId: $profileId, ')
          ..write('agentId: $agentId, ')
          ..write('state: $state, ')
          ..write('propertiesJson: $propertiesJson, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncError: $syncError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rowId,
    id,
    name,
    profileId,
    agentId,
    state,
    propertiesJson,
    syncStatus,
    syncError,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalClient &&
          other.rowId == this.rowId &&
          other.id == this.id &&
          other.name == this.name &&
          other.profileId == this.profileId &&
          other.agentId == this.agentId &&
          other.state == this.state &&
          other.propertiesJson == this.propertiesJson &&
          other.syncStatus == this.syncStatus &&
          other.syncError == this.syncError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalClientsCompanion extends UpdateCompanion<LocalClient> {
  final Value<int> rowId;
  final Value<String> id;
  final Value<String> name;
  final Value<String> profileId;
  final Value<String> agentId;
  final Value<int> state;
  final Value<String> propertiesJson;
  final Value<SyncStatus> syncStatus;
  final Value<String?> syncError;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const LocalClientsCompanion({
    this.rowId = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.profileId = const Value.absent(),
    this.agentId = const Value.absent(),
    this.state = const Value.absent(),
    this.propertiesJson = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  LocalClientsCompanion.insert({
    this.rowId = const Value.absent(),
    this.id = const Value.absent(),
    required String name,
    this.profileId = const Value.absent(),
    required String agentId,
    this.state = const Value.absent(),
    this.propertiesJson = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       agentId = Value(agentId);
  static Insertable<LocalClient> custom({
    Expression<int>? rowId,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? profileId,
    Expression<String>? agentId,
    Expression<int>? state,
    Expression<String>? propertiesJson,
    Expression<int>? syncStatus,
    Expression<String>? syncError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (profileId != null) 'profile_id': profileId,
      if (agentId != null) 'agent_id': agentId,
      if (state != null) 'state': state,
      if (propertiesJson != null) 'properties_json': propertiesJson,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncError != null) 'sync_error': syncError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  LocalClientsCompanion copyWith({
    Value<int>? rowId,
    Value<String>? id,
    Value<String>? name,
    Value<String>? profileId,
    Value<String>? agentId,
    Value<int>? state,
    Value<String>? propertiesJson,
    Value<SyncStatus>? syncStatus,
    Value<String?>? syncError,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return LocalClientsCompanion(
      rowId: rowId ?? this.rowId,
      id: id ?? this.id,
      name: name ?? this.name,
      profileId: profileId ?? this.profileId,
      agentId: agentId ?? this.agentId,
      state: state ?? this.state,
      propertiesJson: propertiesJson ?? this.propertiesJson,
      syncStatus: syncStatus ?? this.syncStatus,
      syncError: syncError ?? this.syncError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (agentId.present) {
      map['agent_id'] = Variable<String>(agentId.value);
    }
    if (state.present) {
      map['state'] = Variable<int>(state.value);
    }
    if (propertiesJson.present) {
      map['properties_json'] = Variable<String>(propertiesJson.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(
        $LocalClientsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalClientsCompanion(')
          ..write('rowId: $rowId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('profileId: $profileId, ')
          ..write('agentId: $agentId, ')
          ..write('state: $state, ')
          ..write('propertiesJson: $propertiesJson, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncError: $syncError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalClientsTable localClients = $LocalClientsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [localClients];
}

typedef $$LocalClientsTableCreateCompanionBuilder =
    LocalClientsCompanion Function({
      Value<int> rowId,
      Value<String> id,
      required String name,
      Value<String> profileId,
      required String agentId,
      Value<int> state,
      Value<String> propertiesJson,
      Value<SyncStatus> syncStatus,
      Value<String?> syncError,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$LocalClientsTableUpdateCompanionBuilder =
    LocalClientsCompanion Function({
      Value<int> rowId,
      Value<String> id,
      Value<String> name,
      Value<String> profileId,
      Value<String> agentId,
      Value<int> state,
      Value<String> propertiesJson,
      Value<SyncStatus> syncStatus,
      Value<String?> syncError,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$LocalClientsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalClientsTable> {
  $$LocalClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get agentId => $composableBuilder(
    column: $table.agentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get propertiesJson => $composableBuilder(
    column: $table.propertiesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, int> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
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
}

class $$LocalClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalClientsTable> {
  $$LocalClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get agentId => $composableBuilder(
    column: $table.agentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get propertiesJson => $composableBuilder(
    column: $table.propertiesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
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
}

class $$LocalClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalClientsTable> {
  $$LocalClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get agentId =>
      $composableBuilder(column: $table.agentId, builder: (column) => column);

  GeneratedColumn<int> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get propertiesJson => $composableBuilder(
    column: $table.propertiesJson,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SyncStatus, int> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalClientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalClientsTable,
          LocalClient,
          $$LocalClientsTableFilterComposer,
          $$LocalClientsTableOrderingComposer,
          $$LocalClientsTableAnnotationComposer,
          $$LocalClientsTableCreateCompanionBuilder,
          $$LocalClientsTableUpdateCompanionBuilder,
          (
            LocalClient,
            BaseReferences<_$AppDatabase, $LocalClientsTable, LocalClient>,
          ),
          LocalClient,
          PrefetchHooks Function()
        > {
  $$LocalClientsTableTableManager(_$AppDatabase db, $LocalClientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> agentId = const Value.absent(),
                Value<int> state = const Value.absent(),
                Value<String> propertiesJson = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => LocalClientsCompanion(
                rowId: rowId,
                id: id,
                name: name,
                profileId: profileId,
                agentId: agentId,
                state: state,
                propertiesJson: propertiesJson,
                syncStatus: syncStatus,
                syncError: syncError,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> id = const Value.absent(),
                required String name,
                Value<String> profileId = const Value.absent(),
                required String agentId,
                Value<int> state = const Value.absent(),
                Value<String> propertiesJson = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => LocalClientsCompanion.insert(
                rowId: rowId,
                id: id,
                name: name,
                profileId: profileId,
                agentId: agentId,
                state: state,
                propertiesJson: propertiesJson,
                syncStatus: syncStatus,
                syncError: syncError,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalClientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalClientsTable,
      LocalClient,
      $$LocalClientsTableFilterComposer,
      $$LocalClientsTableOrderingComposer,
      $$LocalClientsTableAnnotationComposer,
      $$LocalClientsTableCreateCompanionBuilder,
      $$LocalClientsTableUpdateCompanionBuilder,
      (
        LocalClient,
        BaseReferences<_$AppDatabase, $LocalClientsTable, LocalClient>,
      ),
      LocalClient,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalClientsTableTableManager get localClients =>
      $$LocalClientsTableTableManager(_db, _db.localClients);
}
