import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Sync status for locally-created or modified records.
enum SyncStatus { synced, pending, failed }

/// Local clients table for offline-first client data capture.
///
/// Maps to the backend ClientObject but stored locally so field agents
/// can onboard clients without network connectivity. Records are synced
/// to the backend when connectivity is restored.
class LocalClients extends Table {
  /// Local auto-increment primary key for Drift.
  IntColumn get rowId => integer().autoIncrement()();

  /// Backend ID. Empty string for records not yet synced.
  TextColumn get id => text().withDefault(const Constant(''))();

  /// Display name of the client.
  TextColumn get name => text()();

  /// Profile service user ID.
  TextColumn get profileId => text().withDefault(const Constant(''))();

  /// Agent managing this client.
  TextColumn get agentId => text()();

  /// Current state (maps to STATE enum: 0=CREATED, 2=ACTIVE, etc.).
  IntColumn get state => integer().withDefault(const Constant(0))();

  /// JSON-encoded properties (google.protobuf.Struct equivalent).
  TextColumn get propertiesJson => text().withDefault(const Constant('{}'))();

  /// Sync status: synced, pending, or failed.
  IntColumn get syncStatus =>
      intEnum<SyncStatus>().withDefault(Constant(SyncStatus.pending.index))();

  /// Last sync error message (null if no error).
  TextColumn get syncError => text().nullable()();

  /// When this record was created locally.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// When this record was last modified locally.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [LocalClients])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal(super.e);

  /// Singleton instance.
  static AppDatabase? _instance;

  /// Get the shared database instance.
  static AppDatabase instance() {
    return _instance ??= AppDatabase._internal(_openConnection());
  }

  /// For testing — inject a custom query executor.
  factory AppDatabase.forTesting(QueryExecutor e) => AppDatabase._internal(e);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'lender_app',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Client DAO methods
  // ─────────────────────────────────────────────────────────────────────────

  /// Insert or update a client locally.
  Future<int> upsertClient(LocalClientsCompanion client) {
    return into(localClients).insertOnConflictUpdate(client);
  }

  /// Get all clients, optionally filtered by agent and/or search query.
  Future<List<LocalClient>> getClients({String? agentId, String? query}) {
    final q = select(localClients);
    if (agentId != null && agentId.isNotEmpty) {
      q.where((c) => c.agentId.equals(agentId));
    }
    if (query != null && query.isNotEmpty) {
      q.where((c) => c.name.like('%$query%') | c.profileId.like('%$query%'));
    }
    q.orderBy([(c) => OrderingTerm.desc(c.updatedAt)]);
    return q.get();
  }

  /// Get a single client by backend ID.
  Future<LocalClient?> getClientById(String id) {
    return (select(
      localClients,
    )..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  /// Get a single client by local row ID.
  Future<LocalClient?> getClientByRowId(int rowId) {
    return (select(
      localClients,
    )..where((c) => c.rowId.equals(rowId))).getSingleOrNull();
  }

  /// Get all clients pending sync.
  Future<List<LocalClient>> getPendingSyncClients() {
    return (select(localClients)
          ..where((c) => c.syncStatus.equalsValue(SyncStatus.pending))
          ..orderBy([(c) => OrderingTerm.asc(c.createdAt)]))
        .get();
  }

  /// Mark a client as synced with the backend ID.
  Future<void> markClientSynced(int rowId, String backendId) {
    return (update(localClients)..where((c) => c.rowId.equals(rowId))).write(
      LocalClientsCompanion(
        id: Value(backendId),
        syncStatus: const Value(SyncStatus.synced),
        syncError: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Mark a client sync as failed with an error message.
  Future<void> markClientSyncFailed(int rowId, String error) {
    return (update(localClients)..where((c) => c.rowId.equals(rowId))).write(
      LocalClientsCompanion(
        syncStatus: const Value(SyncStatus.failed),
        syncError: Value(error),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Bulk insert clients from backend (used during initial sync/refresh).
  Future<void> replaceAllClientsFromBackend(
    List<LocalClientsCompanion> clients,
  ) async {
    await batch((batch) {
      // Only delete synced records — keep pending locals.
      batch.deleteWhere(
        localClients,
        (c) => c.syncStatus.equalsValue(SyncStatus.synced),
      );
      batch.insertAll(localClients, clients);
    });
  }
}
