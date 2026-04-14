import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/data/auth_repository.dart';

part 'role_provider.g.dart';

/// User roles in the lender system.
/// Matches the authz roles from the Go backend.
enum LenderRole {
  owner,
  admin,
  manager,
  fieldWorker,
  verifier,
  approver,
  auditor,
  viewer,
  member,
  service,
}

LenderRole? parseLenderRole(String role) {
  final normalized = role.toLowerCase().replaceAll('_', '');
  if (normalized == 'agent' || normalized == 'fieldworker') {
    return LenderRole.fieldWorker;
  }
  for (final r in LenderRole.values) {
    if (r.name == normalized) return r;
  }
  return null;
}

@Riverpod(keepAlive: true)
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
