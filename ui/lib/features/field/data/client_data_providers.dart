import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';

part 'client_data_providers.g.dart';

@riverpod
Future<List<ClientDataEntryObject>> clientDataList(
  Ref ref, {
  required String clientId,
}) async {
  final client = ref.watch(identityServiceClientProvider);
  final stream = client.clientDataList(
    ClientDataListRequest(
      clientId: clientId,
      cursor: PageCursor(limit: 50),
    ),
  );
  return collectStream(stream, extract: (response) => response.data);
}

@riverpod
class ClientDataNotifier extends _$ClientDataNotifier {
  @override
  FutureOr<void> build() {}

  Future<ClientDataEntryObject> save(ClientDataEntryObject entry) async {
    final client = ref.read(identityServiceClientProvider);
    final resp = await client.clientDataSave(ClientDataSaveRequest(data: entry));
    ref.invalidate(clientDataListProvider);
    return resp.data;
  }

  Future<void> verify(String entryId, String reviewerId,
      {String comment = ''}) async {
    final client = ref.read(identityServiceClientProvider);
    await client.clientDataVerify(ClientDataVerifyRequest(
      entryId: entryId,
      reviewerId: reviewerId,
      comment: comment,
    ));
    ref.invalidate(clientDataListProvider);
  }

  Future<void> reject(
      String entryId, String reviewerId, String reason) async {
    final client = ref.read(identityServiceClientProvider);
    await client.clientDataReject(ClientDataRejectRequest(
      entryId: entryId,
      reviewerId: reviewerId,
      reason: reason,
    ));
    ref.invalidate(clientDataListProvider);
  }

  Future<void> requestInfo(
      String entryId, String reviewerId, String comment) async {
    final client = ref.read(identityServiceClientProvider);
    await client.clientDataRequestInfo(ClientDataRequestInfoRequest(
      entryId: entryId,
      reviewerId: reviewerId,
      comment: comment,
    ));
    ref.invalidate(clientDataListProvider);
  }
}

@riverpod
Future<List<ClientDataEntryHistoryObject>> clientDataHistory(
  Ref ref, {
  required String entryId,
}) async {
  final client = ref.watch(identityServiceClientProvider);
  final resp = await client.clientDataHistory(
    ClientDataHistoryRequest(entryId: entryId),
  );
  return resp.data;
}
