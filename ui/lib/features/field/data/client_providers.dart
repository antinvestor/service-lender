import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/client_sync_service.dart';
import '../../../core/database/database_provider.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart' as pb_enum;
import '../../../sdk/src/field/v1/field.pb.dart';

part 'client_providers.g.dart';

/// Fetches clients using an offline-first strategy:
/// 1. Return local Drift data immediately.
/// 2. If online, sync from backend in the background and refresh.
@riverpod
Future<List<ClientObject>> clientList(
  Ref ref, {
  required String query,
  required String agentId,
}) async {
  final db = ref.watch(appDatabaseProvider);
  final apiClient = ref.watch(fieldServiceClientProvider);

  // Try to sync from backend if online.
  final isOnline = await ClientSyncService.hasConnectivity();
  if (isOnline) {
    try {
      final syncService = ClientSyncService(db: db, apiClient: apiClient);
      // Push any pending local records first, then pull fresh data.
      await syncService.fullSync(query: query, agentId: agentId);
    } catch (_) {
      // Sync failed — fall through to local data.
    }
  }

  // Always return from local database.
  final localClients = await db.getClients(
    agentId: agentId.isNotEmpty ? agentId : null,
    query: query.isNotEmpty ? query : null,
  );

  return localClients.map(_localToClient).toList();
}

/// Provides the count of clients pending sync.
@riverpod
Future<int> pendingSyncCount(Ref ref) async {
  final db = ref.watch(appDatabaseProvider);
  final pending = await db.getPendingSyncClients();
  return pending.length;
}

@riverpod
class ClientNotifier extends _$ClientNotifier {
  @override
  FutureOr<void> build() {}

  /// Save a client — writes to local DB first, then attempts backend sync.
  Future<ClientObject> save(ClientObject client) async {
    final db = ref.read(appDatabaseProvider);
    final apiClient = ref.read(fieldServiceClientProvider);

    // Always save locally first.
    final companion = ClientSyncService.clientToLocalPending(client);
    final rowId = await db.upsertClient(companion);

    // Attempt backend sync if online.
    final isOnline = await ClientSyncService.hasConnectivity();
    if (isOnline) {
      try {
        final response = await apiClient.clientSave(
          ClientSaveRequest(data: client),
        );
        await db.markClientSynced(rowId, response.data.id);
        ref.invalidate(clientListProvider);
        return response.data;
      } catch (e) {
        await db.markClientSyncFailed(rowId, e.toString());
      }
    }

    // Return local version if offline or sync failed.
    ref.invalidate(clientListProvider);
    return client;
  }

  /// Manually trigger sync for all pending records.
  Future<int> syncPending() async {
    final db = ref.read(appDatabaseProvider);
    final apiClient = ref.read(fieldServiceClientProvider);
    final syncService = ClientSyncService(db: db, apiClient: apiClient);
    final count = await syncService.pushPendingClients();
    ref.invalidate(clientListProvider);
    ref.invalidate(pendingSyncCountProvider);
    return count;
  }
}

ClientObject _localToClient(LocalClient local) {
  final client = ClientObject(
    id: local.id.isNotEmpty ? local.id : 'local_${local.rowId}',
    name: local.name,
    profileId: local.profileId,
    agentId: local.agentId,
    state: pb_enum.STATE.valueOf(local.state) ?? pb_enum.STATE.CREATED,
  );
  return client;
}
