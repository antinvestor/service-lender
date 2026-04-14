import 'package:antinvestor_api_identity/antinvestor_api_identity.dart';
import 'package:antinvestor_ui_core/api/stream_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'identity_transport_provider.dart';

/// Search workforce members with optional filters.
typedef WorkforceMemberListParams = ({
  String query,
  String organizationId,
  String homeOrgUnitId,
});

final workforceMemberListProvider = FutureProvider.family<
    List<WorkforceMemberObject>, WorkforceMemberListParams>(
    (ref, params) async {
  final client = ref.watch(identityServiceClientProvider);
  final stream = client.workforceMemberSearch(
    WorkforceMemberSearchRequest(
      query: params.query,
      organizationId: params.organizationId,
      homeOrgUnitId: params.homeOrgUnitId,
      cursor: PageCursor(limit: 50),
    ),
  );
  return collectStream(stream, extract: (response) => response.data);
});

/// Notifier for workforce member mutations.
class WorkforceMemberNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  IdentityServiceClient get _client =>
      ref.read(identityServiceClientProvider);

  Future<WorkforceMemberObject> save(WorkforceMemberObject member) async {
    state = const AsyncValue.loading();
    try {
      final response = await _client.workforceMemberSave(
        WorkforceMemberSaveRequest(data: member),
      );
      ref.invalidate(workforceMemberListProvider);
      state = const AsyncValue.data(null);
      return response.data;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> activate(String memberId) async {
    state = const AsyncValue.loading();
    try {
      final response = await _client.workforceMemberGet(
        WorkforceMemberGetRequest(id: memberId),
      );
      final member = response.data;
      member.state = STATE.ACTIVE;
      await _client.workforceMemberSave(
        WorkforceMemberSaveRequest(data: member),
      );
      ref.invalidate(workforceMemberListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final workforceMemberNotifierProvider =
    NotifierProvider<WorkforceMemberNotifier, AsyncValue<void>>(
        WorkforceMemberNotifier.new);
