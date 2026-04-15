import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/client_sync_service.dart';
import '../../../core/database/database_provider.dart';
import '../../../sdk/src/google/protobuf/struct.pb.dart' as struct_pb;
import '../../../sdk/src/google/protobuf/struct.pbenum.dart' as struct_enum;
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
  required String memberId,
}) async {
  final db = ref.watch(appDatabaseProvider);
  final apiClient = ref.watch(fieldServiceClientProvider);

  // Try to sync from backend if online.
  final isOnline = await ClientSyncService.hasConnectivity();
  if (isOnline) {
    try {
      final syncService = ClientSyncService(db: db, apiClient: apiClient);
      // Push any pending local records first, then pull fresh data.
      await syncService.fullSync(query: query, memberId: memberId);
    } catch (_) {
      // Sync failed — fall through to local data.
    }
  }

  // Always return from local database.
  final localClients = await db.getClients(
    memberId: memberId.isNotEmpty ? memberId : null,
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
    owningTeamId: local.responsibleMemberId,
    state: pb_enum.STATE.valueOf(local.state) ?? pb_enum.STATE.CREATED,
  );
  if (local.propertiesJson.isNotEmpty && local.propertiesJson != '{}') {
    try {
      final struct = struct_pb.Struct();
      _populateStruct(
        struct,
        jsonDecode(local.propertiesJson) as Map<String, dynamic>,
      );
      client.properties = struct;
    } catch (_) {}
  }
  return client;
}

void _populateStruct(struct_pb.Struct struct, Map<String, dynamic> map) {
  for (final entry in map.entries) {
    struct.fields[entry.key] = _objectToValue(entry.value);
  }
}

struct_pb.Value _objectToValue(dynamic obj) {
  final value = struct_pb.Value();
  if (obj is String) {
    value.stringValue = obj;
  } else if (obj is num) {
    value.numberValue = obj.toDouble();
  } else if (obj is bool) {
    value.boolValue = obj;
  } else if (obj is Map<String, dynamic>) {
    final nested = struct_pb.Struct();
    _populateStruct(nested, obj);
    value.structValue = nested;
  } else if (obj is List) {
    value.listValue = struct_pb.ListValue(
      values: obj.map(_objectToValue).toList(),
    );
  } else {
    value.nullValue = struct_enum.NullValue.NULL_VALUE;
  }
  return value;
}
