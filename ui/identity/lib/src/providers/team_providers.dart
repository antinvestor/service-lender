import 'package:antinvestor_api_identity/antinvestor_api_identity.dart';
import 'package:antinvestor_ui_core/api/stream_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'identity_transport_provider.dart';

/// Search internal teams.
typedef InternalTeamListParams = ({
  String query,
  String organizationId,
});

final internalTeamListProvider = FutureProvider.family<
    List<InternalTeamObject>, InternalTeamListParams>((ref, params) async {
  final client = ref.watch(identityServiceClientProvider);
  final stream = client.internalTeamSearch(
    InternalTeamSearchRequest(
      query: params.query,
      organizationId: params.organizationId,
      cursor: PageCursor(limit: 50),
    ),
  );
  return collectStream(stream, extract: (response) => response.data);
});

/// Notifier for internal team mutations.
class InternalTeamNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  IdentityServiceClient get _client =>
      ref.read(identityServiceClientProvider);

  Future<InternalTeamObject> save(InternalTeamObject team) async {
    state = const AsyncValue.loading();
    try {
      final response = await _client.internalTeamSave(
        InternalTeamSaveRequest(data: team),
      );
      ref.invalidate(internalTeamListProvider);
      state = const AsyncValue.data(null);
      return response.data;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final internalTeamNotifierProvider =
    NotifierProvider<InternalTeamNotifier, AsyncValue<void>>(
        InternalTeamNotifier.new);

/// Search team memberships.
typedef TeamMembershipListParams = ({
  String teamId,
  String memberId,
});

final teamMembershipListProvider = FutureProvider.family<
    List<TeamMembershipObject>, TeamMembershipListParams>(
    (ref, params) async {
  final client = ref.watch(identityServiceClientProvider);
  final stream = client.teamMembershipSearch(
    TeamMembershipSearchRequest(
      teamId: params.teamId,
      memberId: params.memberId,
      cursor: PageCursor(limit: 50),
    ),
  );
  return collectStream(stream, extract: (response) => response.data);
});

/// Notifier for team membership mutations.
class TeamMembershipNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  IdentityServiceClient get _client =>
      ref.read(identityServiceClientProvider);

  Future<TeamMembershipObject> save(TeamMembershipObject membership) async {
    state = const AsyncValue.loading();
    try {
      final response = await _client.teamMembershipSave(
        TeamMembershipSaveRequest(data: membership),
      );
      ref.invalidate(teamMembershipListProvider);
      state = const AsyncValue.data(null);
      return response.data;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final teamMembershipNotifierProvider =
    NotifierProvider<TeamMembershipNotifier, AsyncValue<void>>(
        TeamMembershipNotifier.new);
