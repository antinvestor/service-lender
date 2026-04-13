import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';

part 'access_role_providers.g.dart';

/// Well-known role keys matching the backend constants.
class AccessRoleKeys {
  static const approvalVerifier = 'approval_verifier';
  static const approvalApprover = 'approval_approver';
  static const identityAdministrator = 'identity_administrator';
}

/// Human-readable label for a role key.
String accessRoleLabel(String roleKey) => switch (roleKey) {
  AccessRoleKeys.approvalVerifier => 'Verifier',
  AccessRoleKeys.approvalApprover => 'Approver',
  AccessRoleKeys.identityAdministrator => 'Administrator',
  _ => roleKey,
};

/// All selectable role keys for dropdowns.
const selectableRoleKeys = [
  AccessRoleKeys.approvalVerifier,
  AccessRoleKeys.approvalApprover,
  AccessRoleKeys.identityAdministrator,
];

@riverpod
Future<List<AccessRoleAssignmentObject>> accessRoleAssignmentList(
  Ref ref, {
  required String query,
  String roleKey = '',
  String scopeId = '',
}) async {
  final client = ref.watch(identityServiceClientProvider);
  final request = AccessRoleAssignmentSearchRequest(
    query: query,
    roleKey: roleKey,
    scopeId: scopeId,
    cursor: PageCursor(limit: 50),
  );

  return collectStream(
    client.accessRoleAssignmentSearch(request),
    extract: (response) => response.data,
  );
}

@riverpod
class AccessRoleAssignmentNotifier extends _$AccessRoleAssignmentNotifier {
  @override
  FutureOr<void> build() {}

  Future<AccessRoleAssignmentObject> save(
    AccessRoleAssignmentObject assignment,
  ) async {
    final client = ref.read(identityServiceClientProvider);
    final response = await client.accessRoleAssignmentSave(
      AccessRoleAssignmentSaveRequest(data: assignment),
    );
    ref.invalidate(accessRoleAssignmentListProvider);
    return response.data;
  }
}
