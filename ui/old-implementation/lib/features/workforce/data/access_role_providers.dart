import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';

part 'access_role_providers.g.dart';

/// Well-known role keys matching the backend OPL constants.
///
/// These correspond to the Keto relation tuple roles defined in the
/// OPL namespace configuration. Each key maps to a specific set of
/// permissions enforced by the authorization system.
class AccessRoleKeys {
  // Approval workflow roles
  static const approvalVerifier = 'approval_verifier';
  static const approvalApprover = 'approval_approver';

  // Identity & admin roles
  static const identityAdministrator = 'identity_administrator';
  static const organizationOwner = 'organization_owner';
  static const organizationAdmin = 'organization_admin';

  // Operational roles
  static const loanManager = 'loan_manager';
  static const fieldWorker = 'field_worker';
  static const branchManager = 'branch_manager';
  static const auditor = 'auditor';
  static const viewer = 'viewer';

  // Financial roles
  static const disbursementOfficer = 'disbursement_officer';
  static const repaymentOfficer = 'repayment_officer';
  static const treasuryManager = 'treasury_manager';

  // Service account role
  static const serviceAccount = 'service_account';
}

/// Human-readable label for a role key.
String accessRoleLabel(String roleKey) => switch (roleKey) {
  AccessRoleKeys.approvalVerifier => 'Verifier',
  AccessRoleKeys.approvalApprover => 'Approver',
  AccessRoleKeys.identityAdministrator => 'Administrator',
  AccessRoleKeys.organizationOwner => 'Organization Owner',
  AccessRoleKeys.organizationAdmin => 'Organization Admin',
  AccessRoleKeys.loanManager => 'Loan Manager',
  AccessRoleKeys.fieldWorker => 'Field Worker',
  AccessRoleKeys.branchManager => 'Branch Manager',
  AccessRoleKeys.auditor => 'Auditor',
  AccessRoleKeys.viewer => 'Viewer',
  AccessRoleKeys.disbursementOfficer => 'Disbursement Officer',
  AccessRoleKeys.repaymentOfficer => 'Repayment Officer',
  AccessRoleKeys.treasuryManager => 'Treasury Manager',
  AccessRoleKeys.serviceAccount => 'Service Account',
  _ => roleKey,
};

/// Description of what each role grants.
String accessRoleDescription(String roleKey) => switch (roleKey) {
  AccessRoleKeys.approvalVerifier =>
    'Can verify loan applications and org unit approvals.',
  AccessRoleKeys.approvalApprover =>
    'Can approve or reject loan applications and key workflows.',
  AccessRoleKeys.identityAdministrator =>
    'Full administrative access to identity, organizations, and workforce.',
  AccessRoleKeys.organizationOwner =>
    'Full control over the organization and all its resources.',
  AccessRoleKeys.organizationAdmin =>
    'Manage organization settings, members, and operational configuration.',
  AccessRoleKeys.loanManager =>
    'Manage loan accounts, disbursements, repayments, and restructuring.',
  AccessRoleKeys.fieldWorker =>
    'Create clients, submit loan applications, and record field activities.',
  AccessRoleKeys.branchManager =>
    'Manage a specific branch/org unit and its workforce members.',
  AccessRoleKeys.auditor =>
    'Read-only access to all records for compliance and audit purposes.',
  AccessRoleKeys.viewer =>
    'View-only access to dashboards and reports.',
  AccessRoleKeys.disbursementOfficer =>
    'Process and authorize loan disbursements.',
  AccessRoleKeys.repaymentOfficer =>
    'Record and manage loan repayments.',
  AccessRoleKeys.treasuryManager =>
    'Manage funding accounts, investor relations, and treasury operations.',
  AccessRoleKeys.serviceAccount =>
    'Automated service access for integrations and background processes.',
  _ => 'Custom role.',
};

/// All selectable role keys for dropdowns.
const selectableRoleKeys = [
  AccessRoleKeys.organizationOwner,
  AccessRoleKeys.organizationAdmin,
  AccessRoleKeys.identityAdministrator,
  AccessRoleKeys.branchManager,
  AccessRoleKeys.loanManager,
  AccessRoleKeys.approvalVerifier,
  AccessRoleKeys.approvalApprover,
  AccessRoleKeys.fieldWorker,
  AccessRoleKeys.disbursementOfficer,
  AccessRoleKeys.repaymentOfficer,
  AccessRoleKeys.treasuryManager,
  AccessRoleKeys.auditor,
  AccessRoleKeys.viewer,
  AccessRoleKeys.serviceAccount,
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
