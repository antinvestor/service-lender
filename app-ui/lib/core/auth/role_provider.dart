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
/// Lender-specific roles (owner, admin, etc.) are managed by the backend's
/// relation-based authorization system, not embedded in the JWT. The JWT only
/// contains generic roles (e.g. "user"). Since the backend enforces real
/// permissions on every API call, the frontend grants full UI access to any
/// authenticated user so all navigation and actions are visible. Unauthorized
/// operations will be rejected server-side with a clear error.
@riverpod
Future<Set<LenderRole>> currentUserRoles(Ref ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final roleStrings = await authRepo.getUserRoles();
  final roles = <LenderRole>{};
  for (final roleStr in roleStrings) {
    final role = parseLenderRole(roleStr);
    if (role != null) roles.add(role);
  }

  // If no lender-specific roles were found in the JWT, grant full UI access.
  // The backend authorizer is the real enforcement layer — it checks relation
  // tuples on every RPC call and will reject unauthorized operations.
  if (roles.isEmpty) {
    return LenderRole.values.toSet();
  }
  return roles;
}

/// Check if user has any of the specified roles
@riverpod
Future<bool> hasAnyRole(Ref ref, List<LenderRole> requiredRoles) async {
  final roles = await ref.watch(currentUserRolesProvider.future);
  return requiredRoles.any(roles.contains);
}

/// Whether the current user can manage banks/branches
@riverpod
Future<bool> canManageBanks(Ref ref) async {
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

/// Whether the current user can manage borrowers
@riverpod
Future<bool> canManageBorrowers(Ref ref) async {
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
