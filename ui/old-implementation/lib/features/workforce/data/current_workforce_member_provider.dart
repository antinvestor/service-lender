import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/data/auth_state_provider.dart';

part 'current_workforce_member_provider.g.dart';

/// Resolves the current user's workforce member record by searching for a
/// member whose profileId matches the logged-in user's profile ID.
///
/// Returns the member ID, or null if the user is not a workforce member.
@Riverpod(keepAlive: true)
Future<String?> currentWorkforceMemberId(Ref ref) async {
  final authState = await ref.watch(authStateProvider.future);
  if (authState != AuthState.authenticated) return null;

  final authRepo = ref.watch(authRepositoryProvider);
  final profileId = await authRepo.getCurrentProfileId();
  if (profileId == null || profileId.isEmpty) return null;

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

    final matching = members.where((m) => m.profileId == profileId);
    if (matching.isEmpty) return null;

    return matching.first.id;
  } catch (_) {
    return null;
  }
}
