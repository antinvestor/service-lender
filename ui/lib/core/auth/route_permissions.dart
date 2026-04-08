import 'role_provider.dart';

/// Maps route prefixes to their required roles.
///
/// The router uses this to guard access at the route level, preventing
/// users from accessing pages by typing URLs directly even when the
/// sidebar nav items are filtered out.
///
/// A route matches if the current location starts with any key.
/// More specific prefixes are checked first (longest match wins).
/// An empty set means "any authenticated user can access".
const Map<String, Set<LenderRole>> routePermissions = {
  // Admin — owner and admin only
  '/admin/users': {LenderRole.owner, LenderRole.admin},
  '/admin/roles': {LenderRole.owner, LenderRole.admin},
  '/admin/audit': {
    LenderRole.owner,
    LenderRole.admin,
    LenderRole.auditor,
  },

  // Organization — all view roles (not bare agents)
  '/organization/organizations': _viewRoles,
  '/organization/investors': _viewRoles,

  // Field Operations — broad access but reassignment restricted
  '/field/reassignment': _fieldMgmtRoles,
  '/field/agents': _allViewRoles,
  '/field/hierarchy': _allViewRoles,
  '/field/clients': _allViewRoles,

  // Origination — all operational roles
  '/origination/pending': _allViewRoles,
  '/origination/applications': _allViewRoles,

  // Loan Management — all operational roles
  '/loans/products': _allViewRoles,
  '/loans': _allViewRoles,

  // Reports — view roles
  '/reports/portfolio': _viewRoles,
  '/reports/loan-book': _viewRoles,

  // Operations — view roles
  '/operations/disbursements': _viewRoles,
  '/operations/transfers': _viewRoles,
  '/operations/templates': {LenderRole.owner, LenderRole.admin},

  // Savings — operational roles
  '/savings': _allViewRoles,

  // Settings — any authenticated user
  '/settings': {},

  // Dashboard — any authenticated user
  '/': {},
};

const _viewRoles = {
  LenderRole.owner,
  LenderRole.admin,
  LenderRole.manager,
  LenderRole.verifier,
  LenderRole.approver,
  LenderRole.auditor,
  LenderRole.viewer,
  LenderRole.member,
  LenderRole.service,
};

const _fieldMgmtRoles = {
  LenderRole.owner,
  LenderRole.admin,
  LenderRole.manager,
  LenderRole.agent,
};

const _allViewRoles = {
  LenderRole.owner,
  LenderRole.admin,
  LenderRole.manager,
  LenderRole.agent,
  LenderRole.verifier,
  LenderRole.approver,
  LenderRole.auditor,
  LenderRole.viewer,
  LenderRole.member,
  LenderRole.service,
};

/// Returns the required roles for a given route location.
/// Uses longest-prefix matching. Returns empty set if no match (allow all).
Set<LenderRole> requiredRolesForRoute(String location) {
  // Sort keys by length descending for longest-prefix matching
  final sorted = routePermissions.keys.toList()
    ..sort((a, b) => b.length.compareTo(a.length));

  for (final prefix in sorted) {
    if (location == prefix || location.startsWith('$prefix/') || prefix == location) {
      return routePermissions[prefix]!;
    }
  }
  // Also check exact match for '/'
  if (location == '/') {
    return routePermissions['/'] ?? {};
  }
  return {};
}
