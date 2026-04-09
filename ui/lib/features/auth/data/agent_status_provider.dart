import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../core/logging/app_logger.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/field/v1/field.pb.dart';
import 'auth_repository.dart';
import 'auth_state_provider.dart';

part 'agent_status_provider.g.dart';

enum AgentOnboardingStatus { notAgent, pendingTnc, active, loading, error }

@Riverpod(keepAlive: true)
Future<AgentOnboardingStatus> agentOnboardingStatus(Ref ref) async {
  // Wait for auth to be fully established before making API calls.
  // This prevents races where old tokens trigger logout during the
  // OAuth redirect flow.
  final authState = await ref.watch(authStateProvider.future);
  if (authState != AuthState.authenticated) {
    return AgentOnboardingStatus.notAgent;
  }

  final authRepo = ref.watch(authRepositoryProvider);
  final profileId = await authRepo.getCurrentProfileId();
  if (profileId == null || profileId.isEmpty) {
    return AgentOnboardingStatus.notAgent;
  }

  try {
    final client = ref.watch(fieldServiceClientProvider);
    final stream = client.agentSearch(
      AgentSearchRequest(
        query: profileId,
        cursor: PageCursor(limit: 10),
      ),
    );

    final agents = await collectStream(
      stream,
      extract: (response) => response.data,
      maxPages: 1,
    );

    // Find an agent whose profileId matches exactly.
    final matching = agents.where((a) => a.profileId == profileId);
    if (matching.isEmpty) {
      return AgentOnboardingStatus.notAgent;
    }

    final agent = matching.first;
    if (agent.state == STATE.CREATED) {
      return AgentOnboardingStatus.pendingTnc;
    }

    return AgentOnboardingStatus.active;
  } catch (e, stack) {
    AppLogger.error(
      'Failed to check agent onboarding status',
      error: e,
      stackTrace: stack,
    );
    // On error, allow through to dashboard rather than blocking access.
    return AgentOnboardingStatus.notAgent;
  }
}
