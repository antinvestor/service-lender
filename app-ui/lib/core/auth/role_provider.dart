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
