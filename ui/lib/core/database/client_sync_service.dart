import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' as drift show Value;

import '../../sdk/src/common/v1/common.pb.dart' show PageCursor;
import '../../sdk/src/common/v1/common.pbenum.dart' as pb_enum;
import '../../sdk/src/field/v1/field.connect.client.dart';
import '../../sdk/src/field/v1/field.pb.dart';
import '../../sdk/src/google/protobuf/struct.pb.dart' as struct_pb;
import '../../sdk/src/google/protobuf/struct.pbenum.dart' as struct_enum;
import 'app_database.dart';

/// Bidirectional sync service for client data.
///
/// - Pushes locally-created/modified clients to the backend.
/// - Pulls backend clients into the local database for offline access.
class ClientSyncService {
  ClientSyncService({required this.db, required this.apiClient});

  final AppDatabase db;
  final FieldServiceClient apiClient;

  /// Push all pending local clients to the backend.
  /// Returns the number of successfully synced records.
  ///
  /// Validates each record before pushing — records with invalid data
  /// are marked as failed immediately without hitting the server.
  Future<int> pushPendingClients() async {
    final pending = await db.getPendingSyncClients();
    var synced = 0;

    for (final local in pending) {
      // Validate required fields before attempting API call
      final validationError = _validateLocal(local);
      if (validationError != null) {
        await db.markClientSyncFailed(
          local.rowId,
          'Validation: $validationError',
        );
        continue;
      }

      try {
        final clientObj = _localToClient(local);
        final response = await apiClient.clientSave(
          ClientSaveRequest(data: clientObj),
        );
        await db.markClientSynced(local.rowId, response.data.id);
        synced++;
      } catch (e) {
        await db.markClientSyncFailed(local.rowId, e.toString());
      }
    }

    return synced;
  }

  /// Validates a local client record has the minimum required data.
  /// Returns an error string or null if valid.
  static String? _validateLocal(LocalClient local) {
    if (local.name.trim().isEmpty) return 'Name is empty';
    if (local.name.trim().length < 2) return 'Name too short';
    if (local.agentId.trim().isEmpty) return 'Agent ID is empty';
    if (local.propertiesJson.isNotEmpty && local.propertiesJson != '{}') {
      try {
        jsonDecode(local.propertiesJson);
      } catch (_) {
        return 'Malformed properties JSON';
      }
    }
    return null;
  }

  /// Pull clients from the backend and store locally.
  /// Preserves any pending (unsynced) local records.
  Future<int> pullClients({String query = '', String agentId = ''}) async {
    final companions = <LocalClientsCompanion>[];

    final stream = apiClient.clientSearch(
      ClientSearchRequest(
        query: query,
        agentId: agentId,
        cursor: PageCursor(limit: 200),
      ),
    );

    var pages = 0;
    await for (final response in stream) {
      for (final item in response.data) {
        companions.add(_clientToCompanion(item));
      }
      if (++pages >= 10 || response.data.isEmpty) break;
    }

    await db.replaceAllClientsFromBackend(companions);
    return companions.length;
  }

  /// Full sync: push pending, then pull fresh data.
  Future<({int pushed, int pulled})> fullSync({
    String query = '',
    String agentId = '',
  }) async {
    final pushed = await pushPendingClients();
    final pulled = await pullClients(query: query, agentId: agentId);
    return (pushed: pushed, pulled: pulled);
  }

  /// Check if device has network connectivity.
  static Future<bool> hasConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Conversion helpers
  // ─────────────────────────────────────────────────────────────────────────

  static ClientObject _localToClient(LocalClient local) {
    final clientObj = ClientObject(
      id: local.id.isNotEmpty ? local.id : null,
      name: local.name,
      profileId: local.profileId,
      agentId: local.agentId,
      state: pb_enum.STATE.valueOf(local.state) ?? pb_enum.STATE.CREATED,
    );

    if (local.propertiesJson.isNotEmpty && local.propertiesJson != '{}') {
      try {
        final map = jsonDecode(local.propertiesJson) as Map<String, dynamic>;
        final struct = struct_pb.Struct();
        _populateStruct(struct, map);
        clientObj.properties = struct;
      } catch (_) {
        // Ignore malformed JSON
      }
    }

    return clientObj;
  }

  static LocalClientsCompanion _clientToCompanion(ClientObject client) {
    String propertiesJson = '{}';
    if (client.hasProperties()) {
      try {
        propertiesJson = jsonEncode(_structToMap(client.properties));
      } catch (_) {
        // fallback
      }
    }

    return LocalClientsCompanion(
      id: drift.Value(client.id),
      name: drift.Value(client.name),
      profileId: drift.Value(client.profileId),
      agentId: drift.Value(client.agentId),
      state: drift.Value(client.state.value),
      propertiesJson: drift.Value(propertiesJson),
      syncStatus: drift.Value(SyncStatus.synced),
      updatedAt: drift.Value(DateTime.now()),
    );
  }

  /// Convert a ClientObject to a LocalClientsCompanion for a new local record.
  static LocalClientsCompanion clientToLocalPending(ClientObject client) {
    String propertiesJson = '{}';
    if (client.hasProperties()) {
      try {
        propertiesJson = jsonEncode(_structToMap(client.properties));
      } catch (_) {}
    }

    return LocalClientsCompanion(
      id: drift.Value(client.id.isNotEmpty ? client.id : ''),
      name: drift.Value(client.name),
      profileId: drift.Value(client.profileId),
      agentId: drift.Value(client.agentId),
      state: drift.Value(client.state.value),
      propertiesJson: drift.Value(propertiesJson),
      syncStatus: drift.Value(SyncStatus.pending),
      updatedAt: drift.Value(DateTime.now()),
    );
  }

  static Map<String, dynamic> _structToMap(struct_pb.Struct struct) {
    final result = <String, dynamic>{};
    for (final entry in struct.fields.entries) {
      result[entry.key] = _valueToObject(entry.value);
    }
    return result;
  }

  static dynamic _valueToObject(struct_pb.Value value) {
    if (value.hasStringValue()) return value.stringValue;
    if (value.hasNumberValue()) return value.numberValue;
    if (value.hasBoolValue()) return value.boolValue;
    if (value.hasStructValue()) return _structToMap(value.structValue);
    if (value.hasListValue()) {
      return value.listValue.values.map(_valueToObject).toList();
    }
    return null;
  }

  static void _populateStruct(
    struct_pb.Struct struct,
    Map<String, dynamic> map,
  ) {
    for (final entry in map.entries) {
      struct.fields[entry.key] = _objectToValue(entry.value);
    }
  }

  static struct_pb.Value _objectToValue(dynamic obj) {
    final v = struct_pb.Value();
    if (obj is String) {
      v.stringValue = obj;
    } else if (obj is num) {
      v.numberValue = obj.toDouble();
    } else if (obj is bool) {
      v.boolValue = obj;
    } else if (obj is Map<String, dynamic>) {
      final nested = struct_pb.Struct();
      _populateStruct(nested, obj);
      v.structValue = nested;
    } else if (obj is List) {
      v.listValue = struct_pb.ListValue(
        values: obj.map(_objectToValue).toList(),
      );
    } else {
      v.nullValue = struct_enum.NullValue.NULL_VALUE;
    }
    return v;
  }
}
