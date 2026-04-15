import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';

part 'team_providers.g.dart';

@riverpod
Future<List<InternalTeamObject>> internalTeamList(
  Ref ref, {
  required String query,
  String organizationId = '',
}) async {
  final client = ref.watch(identityServiceClientProvider);
  final stream = client.internalTeamSearch(
    InternalTeamSearchRequest(
      query: query,
      organizationId: organizationId,
      cursor: PageCursor(limit: 50),
    ),
  );
  return collectStream(stream, extract: (response) => response.data);
}

@riverpod
class InternalTeamNotifier extends _$InternalTeamNotifier {
  @override
  FutureOr<void> build() {}

  Future<InternalTeamObject> save(InternalTeamObject team) async {
    final client = ref.read(identityServiceClientProvider);
    final response = await client.internalTeamSave(
      InternalTeamSaveRequest(data: team),
    );
    ref.invalidate(internalTeamListProvider);
    return response.data;
  }
}

@riverpod
Future<List<TeamMembershipObject>> teamMembershipList(
  Ref ref, {
  required String teamId,
  String memberId = '',
}) async {
  final client = ref.watch(identityServiceClientProvider);
  final stream = client.teamMembershipSearch(
    TeamMembershipSearchRequest(
      teamId: teamId,
      memberId: memberId,
      cursor: PageCursor(limit: 50),
    ),
  );
  return collectStream(stream, extract: (response) => response.data);
}

@riverpod
class TeamMembershipNotifier extends _$TeamMembershipNotifier {
  @override
  FutureOr<void> build() {}

  Future<TeamMembershipObject> save(TeamMembershipObject membership) async {
    final client = ref.read(identityServiceClientProvider);
    final response = await client.teamMembershipSave(
      TeamMembershipSaveRequest(data: membership),
    );
    ref.invalidate(teamMembershipListProvider);
    return response.data;
  }
}
