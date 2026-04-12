import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';

part 'system_user_providers.g.dart';

@riverpod
Future<List<SystemUserObject>> systemUserList(
  Ref ref, {
  required String query,
  required String branchId,
  SystemUserRole role = SystemUserRole.SYSTEM_USER_ROLE_UNSPECIFIED,
}) async {
  final client = ref.watch(identityServiceClientProvider);
  final request = SystemUserSearchRequest(
    query: query,
    branchId: branchId,
    role: role,
    cursor: PageCursor(limit: 50),
  );

  return collectStream(
    client.systemUserSearch(request),
    extract: (response) => response.data,
  );
}

@riverpod
class SystemUserNotifier extends _$SystemUserNotifier {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<SystemUserObject> save(SystemUserObject user) async {
    final client = ref.read(identityServiceClientProvider);
    final response = await client.systemUserSave(
      SystemUserSaveRequest(data: user),
    );
    ref.invalidate(systemUserListProvider);
    return response.data;
  }
}
