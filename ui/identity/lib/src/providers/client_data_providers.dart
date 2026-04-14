import 'package:antinvestor_api_identity/antinvestor_api_identity.dart';
import 'package:antinvestor_ui_core/api/stream_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'identity_transport_provider.dart';

/// List client data entries for a given client.
final clientDataListProvider =
    FutureProvider.family<List<ClientDataEntryObject>, String>(
        (ref, clientId) async {
  final client = ref.watch(identityServiceClientProvider);
  final stream = client.clientDataList(
    ClientDataListRequest(
      clientId: clientId,
      cursor: PageCursor(limit: 50),
    ),
  );
  return collectStream(stream, extract: (response) => response.data);
});

/// Notifier for client data entry mutations.
class ClientDataNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  IdentityServiceClient get _client =>
      ref.read(identityServiceClientProvider);

  Future<ClientDataEntryObject> save(ClientDataEntryObject entry) async {
    state = const AsyncValue.loading();
    try {
      final resp =
          await _client.clientDataSave(ClientDataSaveRequest(data: entry));
      ref.invalidate(clientDataListProvider);
      state = const AsyncValue.data(null);
      return resp.data;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> verify(String entryId, String reviewerId,
      {String comment = ''}) async {
    state = const AsyncValue.loading();
    try {
      await _client.clientDataVerify(ClientDataVerifyRequest(
        entryId: entryId,
        reviewerId: reviewerId,
        comment: comment,
      ));
      ref.invalidate(clientDataListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> reject(
      String entryId, String reviewerId, String reason) async {
    state = const AsyncValue.loading();
    try {
      await _client.clientDataReject(ClientDataRejectRequest(
        entryId: entryId,
        reviewerId: reviewerId,
        reason: reason,
      ));
      ref.invalidate(clientDataListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> requestInfo(
      String entryId, String reviewerId, String comment) async {
    state = const AsyncValue.loading();
    try {
      await _client.clientDataRequestInfo(ClientDataRequestInfoRequest(
        entryId: entryId,
        reviewerId: reviewerId,
        comment: comment,
      ));
      ref.invalidate(clientDataListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final clientDataNotifierProvider =
    NotifierProvider<ClientDataNotifier, AsyncValue<void>>(
        ClientDataNotifier.new);

/// Get history for a specific client data entry.
final clientDataHistoryProvider = FutureProvider.family<
    List<ClientDataEntryHistoryObject>, String>((ref, entryId) async {
  final client = ref.watch(identityServiceClientProvider);
  final resp = await client.clientDataHistory(
    ClientDataHistoryRequest(entryId: entryId),
  );
  return resp.data;
});
