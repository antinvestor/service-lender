import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../core/logging/app_logger.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/data/auth_state_provider.dart';

part 'workforce_member_status_provider.g.dart';

enum WorkforceMemberOnboardingStatus {
  notMember,
  pendingActivation,
  active,
  loading,
  error,
}

@Riverpod(keepAlive: true)
Future<WorkforceMemberOnboardingStatus> workforceMemberStatus(Ref ref) async {
  // Wait for auth to be fully established before making API calls.
  final authState = await ref.watch(authStateProvider.future);
  if (authState != AuthState.authenticated) {
    return WorkforceMemberOnboardingStatus.notMember;
  }

  final authRepo = ref.watch(authRepositoryProvider);
  final profileId = await authRepo.getCurrentProfileId();
  if (profileId == null || profileId.isEmpty) {
    return WorkforceMemberOnboardingStatus.notMember;
  }

  try {
    final client = ref.watch(identityServiceClientProvider);
    final stream = client.workforceMemberSearch(
      WorkforceMemberSearchRequest(
        query: profileId,
        cursor: PageCursor(limit: 10),
      ),
    );

    final members = await collectStream(
      stream,
      extract: (response) => response.data,
      maxPages: 1,
    );

    // Find a member whose profileId matches exactly.
    final matching = members.where((m) => m.profileId == profileId);
    if (matching.isEmpty) {
      return WorkforceMemberOnboardingStatus.notMember;
    }

    final member = matching.first;
    if (member.state == STATE.CREATED) {
      return WorkforceMemberOnboardingStatus.pendingActivation;
    }

    return WorkforceMemberOnboardingStatus.active;
  } catch (e, stack) {
    AppLogger.error(
      'Failed to check workforce member onboarding status',
      error: e,
      stackTrace: stack,
    );
    // On error, allow through to dashboard rather than blocking access.
    return WorkforceMemberOnboardingStatus.notMember;
  }
}
