import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/field/v1/field.pb.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/data/auth_state_provider.dart';

part 'current_agent_provider.g.dart';

/// Resolves the current user's agent record by searching for an agent
/// whose profileId matches the logged-in user's profile ID.
///
/// Returns the agent ID, or null if the user is not an agent.
@Riverpod(keepAlive: true)
Future<String?> currentAgentId(Ref ref) async {
  final authState = await ref.watch(authStateProvider.future);
  if (authState != AuthState.authenticated) return null;

  final authRepo = ref.watch(authRepositoryProvider);
  final profileId = await authRepo.getCurrentProfileId();
  if (profileId == null || profileId.isEmpty) return null;

  try {
    final client = ref.watch(fieldServiceClientProvider);
    final stream = client.agentSearch(
      AgentSearchRequest(query: profileId, cursor: PageCursor(limit: 10)),
    );

    final agents = await collectStream(
      stream,
      extract: (response) => response.data,
      maxPages: 1,
    );

    final matching = agents.where((a) => a.profileId == profileId);
    if (matching.isEmpty) return null;

    return matching.first.id;
  } catch (_) {
    return null;
  }
}
