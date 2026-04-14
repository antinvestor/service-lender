import 'package:antinvestor_api_identity/antinvestor_api_identity.dart';
import 'package:antinvestor_ui_core/api/stream_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'identity_transport_provider.dart';

/// Search branches by query and organization.
typedef BranchListParams = ({String query, String organizationId});

final branchListProvider =
    FutureProvider.family<List<BranchObject>, BranchListParams>(
        (ref, params) async {
  final client = ref.watch(identityServiceClientProvider);
  final stream = client.branchSearch(
    BranchSearchRequest(
      query: params.query,
      organizationId: params.organizationId,
      cursor: PageCursor(limit: 50),
    ),
  );
  return collectStream(stream, extract: (response) => response.data);
});

/// Notifier for branch mutations.
class BranchNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  IdentityServiceClient get _client =>
      ref.read(identityServiceClientProvider);

  Future<void> save(BranchObject branch) async {
    state = const AsyncValue.loading();
    try {
      await _client.branchSave(BranchSaveRequest(data: branch));
      ref.invalidate(branchListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final branchNotifierProvider =
    NotifierProvider<BranchNotifier, AsyncValue<void>>(BranchNotifier.new);
