import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/data/auth_repository.dart';

part 'role_provider.g.dart';

/// User roles in the lender system.
/// Matches the authz roles from the Go backend.
enum LenderRole {
  owner,
  admin,
  manager,
  agent,
  verifier,
  approver,
  auditor,
  viewer,
  service,
}

LenderRole? parseLenderRole(String role) {
  final normalized = role.toLowerCase().replaceAll('_', '');
  for (final r in LenderRole.values) {
    if (r.name == normalized) return r;
  }
  return null;
}

/// Returns the current user's lender roles.
///
/// Lender-specific roles (owner, admin, etc.) are extracted from the JWT.
/// If no recognized roles are found, the user gets an empty set — they can
/// see the dashboard but no functional sections or action buttons. The
/// backend enforces the same restrictions via OPL relation tuples.
@riverpod
Future<Set<LenderRole>> currentUserRoles(Ref ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final roleStrings = await authRepo.getUserRoles();
  final roles = <LenderRole>{};
  for (final roleStr in roleStrings) {
    final role = parseLenderRole(roleStr);
    if (role != null) roles.add(role);
  }
  return roles;
}

/// Check if user has any of the specified roles
@riverpod
Future<bool> hasAnyRole(Ref ref, List<LenderRole> requiredRoles) async {
  final roles = await ref.watch(currentUserRolesProvider.future);
  return requiredRoles.any(roles.contains);
}

/// Whether the current user can manage organizations/branches
@riverpod
Future<bool> canManageOrganizations(Ref ref) async {
  final roles = await ref.watch(currentUserRolesProvider.future);
  return roles.any((r) => [LenderRole.owner, LenderRole.admin].contains(r));
}

/// Whether the current user can manage agents
@riverpod
Future<bool> canManageAgents(Ref ref) async {
  final roles = await ref.watch(currentUserRolesProvider.future);
  return roles.any(
    (r) =>
        [LenderRole.owner, LenderRole.admin, LenderRole.manager].contains(r),
  );
}

/// Whether the current user can manage clients
@riverpod
Future<bool> canManageClients(Ref ref) async {
  final roles = await ref.watch(currentUserRolesProvider.future);
  return roles.any(
    (r) => [
      LenderRole.owner,
      LenderRole.admin,
      LenderRole.manager,
      LenderRole.agent,
    ].contains(r),
  );
}

/// Whether the current user can manage investors
@riverpod
Future<bool> canManageInvestors(Ref ref) async {
  final roles = await ref.watch(currentUserRolesProvider.future);
  return roles.any(
    (r) => [LenderRole.owner, LenderRole.admin].contains(r),
  );
}

/// Whether the current user can create loan applications
@riverpod
Future<bool> canCreateApplications(Ref ref) async {
  final roles = await ref.watch(currentUserRolesProvider.future);
  return roles.any(
    (r) => [
      LenderRole.owner,
      LenderRole.admin,
      LenderRole.manager,
      LenderRole.agent,
    ].contains(r),
  );
}

/// Whether the current user can manage loan products
@riverpod
Future<bool> canManageLoanProducts(Ref ref) async {
  final roles = await ref.watch(currentUserRolesProvider.future);
  return roles.any(
    (r) => [LenderRole.owner, LenderRole.admin].contains(r),
  );
}

/// Whether the current user can manage verification tasks
@riverpod
Future<bool> canManageVerification(Ref ref) async {
  final roles = await ref.watch(currentUserRolesProvider.future);
  return roles.any(
    (r) => [
      LenderRole.owner,
      LenderRole.admin,
      LenderRole.verifier,
    ].contains(r),
  );
}

/// Whether the current user can make underwriting decisions
@riverpod
Future<bool> canManageUnderwriting(Ref ref) async {
  final roles = await ref.watch(currentUserRolesProvider.future);
  return roles.any(
    (r) => [
      LenderRole.owner,
      LenderRole.admin,
      LenderRole.approver,
    ].contains(r),
  );
}

/// Whether the current user can manage loans (disbursements, etc.)
@riverpod
Future<bool> canManageLoans(Ref ref) async {
  final roles = await ref.watch(currentUserRolesProvider.future);
  return roles.any(
    (r) => [
      LenderRole.owner,
      LenderRole.admin,
      LenderRole.manager,
    ].contains(r),
  );
}

/// Whether the current user can record repayments
@riverpod
Future<bool> canRecordRepayments(Ref ref) async {
  final roles = await ref.watch(currentUserRolesProvider.future);
  return roles.any(
    (r) => [
      LenderRole.owner,
      LenderRole.admin,
      LenderRole.manager,
    ].contains(r),
  );
}

/// Whether the current user can manage system users
@riverpod
Future<bool> canManageSystemUsers(Ref ref) async {
  final roles = await ref.watch(currentUserRolesProvider.future);
  return roles.any((r) => [LenderRole.owner, LenderRole.admin].contains(r));
}

/// Whether the current user can manage penalties
@riverpod
Future<bool> canManagePenalties(Ref ref) async {
  final roles = await ref.watch(currentUserRolesProvider.future);
  return roles.any(
    (r) => [
      LenderRole.owner,
      LenderRole.admin,
      LenderRole.manager,
    ].contains(r),
  );
}

/// Whether the current user can manage loan restructuring
@riverpod
Future<bool> canManageRestructuring(Ref ref) async {
  final roles = await ref.watch(currentUserRolesProvider.future);
  return roles.any(
    (r) => [
      LenderRole.owner,
      LenderRole.admin,
      LenderRole.manager,
    ].contains(r),
  );
}
