import 'package:flutter/material.dart';

import '../auth/role_provider.dart';

/// A single navigation item that can contain children (submenus).
class NavItem {
  const NavItem({
    required this.id,
    required this.label,
    required this.icon,
    this.activeIcon,
    this.route,
    this.children = const [],
    this.requiredRoles = const {},
    this.badge,
  });

  final String id;
  final String label;
  final IconData icon;
  final IconData? activeIcon;

  /// Route path. Null for parent-only items (section headers).
  final String? route;

  /// Sub-menu items.
  final List<NavItem> children;

  /// If non-empty, user must have at least one of these roles.
  final Set<LenderRole> requiredRoles;

  /// Optional badge text (e.g. count).
  final String? badge;

  bool get hasChildren => children.isNotEmpty;

  /// Whether this item or any of its children match the given route.
  bool matchesRoute(String currentRoute) {
    if (route != null && currentRoute.startsWith(route!)) return true;
    return children.any((c) => c.matchesRoute(currentRoute));
  }

  /// Filter this item by roles. Returns null if user can't see it.
  NavItem? filterByRoles(Set<LenderRole> userRoles) {
    // If no role restriction, allow. Otherwise check intersection.
    if (requiredRoles.isNotEmpty &&
        userRoles.intersection(requiredRoles).isEmpty) {
      return null;
    }

    // Filter children recursively
    final filteredChildren = children
        .map((c) => c.filterByRoles(userRoles))
        .whereType<NavItem>()
        .toList();

    // If this is a parent-only item and all children were filtered out, hide it
    if (route == null && filteredChildren.isEmpty && children.isNotEmpty) {
      return null;
    }

    return NavItem(
      id: id,
      label: label,
      icon: icon,
      activeIcon: activeIcon,
      route: route,
      children: filteredChildren,
      requiredRoles: requiredRoles,
      badge: badge,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Navigation tree definition
// ─────────────────────────────────────────────────────────────────────────────

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

const _adminRoles = {LenderRole.owner, LenderRole.admin};

const _fieldRoles = {
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

/// The full navigation tree for the app.
List<NavItem> buildNavItems() => [
  const NavItem(
    id: 'dashboard',
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
    activeIcon: Icons.dashboard,
    route: '/',
  ),
  NavItem(
    id: 'organization',
    label: 'Organization',
    icon: Icons.business_outlined,
    activeIcon: Icons.business,
    requiredRoles: _viewRoles,
    children: [
      NavItem(
        id: 'organizations',
        label: 'Organizations',
        icon: Icons.account_balance_outlined,
        activeIcon: Icons.account_balance,
        route: '/organization/organizations',
        requiredRoles: _viewRoles,
      ),
      NavItem(
        id: 'branches',
        label: 'Branches',
        icon: Icons.store_outlined,
        activeIcon: Icons.store,
        route: '/organization/branches',
        requiredRoles: _viewRoles,
      ),
      NavItem(
        id: 'agents',
        label: 'Agents',
        icon: Icons.person_pin_outlined,
        activeIcon: Icons.person_pin,
        route: '/organization/agents',
        requiredRoles: _allViewRoles,
      ),
      NavItem(
        id: 'investors',
        label: 'Investors',
        icon: Icons.trending_up_outlined,
        activeIcon: Icons.trending_up,
        route: '/organization/investors',
        requiredRoles: _viewRoles,
      ),
    ],
  ),
  NavItem(
    id: 'field_operations',
    label: 'Field Operations',
    icon: Icons.groups_outlined,
    activeIcon: Icons.groups,
    requiredRoles: _allViewRoles,
    children: [
      NavItem(
        id: 'clients',
        label: 'Clients',
        icon: Icons.people_outline,
        activeIcon: Icons.people,
        route: '/field/clients',
        requiredRoles: _allViewRoles,
      ),
      NavItem(
        id: 'client_reassignment',
        label: 'Reassignment',
        icon: Icons.swap_horiz_outlined,
        activeIcon: Icons.swap_horiz,
        route: '/field/reassignment',
        requiredRoles: _fieldRoles,
      ),
    ],
  ),
  NavItem(
    id: 'origination',
    label: 'Origination',
    icon: Icons.description_outlined,
    activeIcon: Icons.description,
    requiredRoles: _allViewRoles,
    children: [
      NavItem(
        id: 'pending_cases',
        label: 'Pending Cases',
        icon: Icons.assignment_late_outlined,
        activeIcon: Icons.assignment_late,
        route: '/origination/pending',
        requiredRoles: _allViewRoles,
      ),
      NavItem(
        id: 'applications',
        label: 'Applications',
        icon: Icons.assignment_outlined,
        activeIcon: Icons.assignment,
        route: '/origination/applications',
        requiredRoles: _allViewRoles,
      ),
      NavItem(
        id: 'form_templates',
        label: 'Form Templates',
        icon: Icons.dynamic_form_outlined,
        activeIcon: Icons.dynamic_form,
        route: '/origination/templates',
        requiredRoles: _adminRoles,
      ),
    ],
  ),
  NavItem(
    id: 'loan_management',
    label: 'Loan Management',
    icon: Icons.account_balance_wallet_outlined,
    activeIcon: Icons.account_balance_wallet,
    requiredRoles: _allViewRoles,
    children: [
      NavItem(
        id: 'loan_products',
        label: 'Loan Products',
        icon: Icons.inventory_2_outlined,
        activeIcon: Icons.inventory_2,
        route: '/loans/products',
        requiredRoles: _allViewRoles,
      ),
      NavItem(
        id: 'loan_accounts',
        label: 'Loan Accounts',
        icon: Icons.credit_score_outlined,
        activeIcon: Icons.credit_score,
        route: '/loans',
        requiredRoles: _allViewRoles,
      ),
    ],
  ),
  NavItem(
    id: 'savings',
    label: 'Savings',
    icon: Icons.savings_outlined,
    activeIcon: Icons.savings,
    requiredRoles: _allViewRoles,
    children: [
      NavItem(
        id: 'savings_accounts',
        label: 'Savings Accounts',
        icon: Icons.account_balance_outlined,
        activeIcon: Icons.account_balance,
        route: '/savings',
        requiredRoles: _allViewRoles,
      ),
    ],
  ),
  NavItem(
    id: 'reports',
    label: 'Reports',
    icon: Icons.bar_chart_outlined,
    activeIcon: Icons.bar_chart,
    requiredRoles: _viewRoles,
    children: [
      NavItem(
        id: 'portfolio_summary',
        label: 'Portfolio Summary',
        icon: Icons.pie_chart_outline,
        activeIcon: Icons.pie_chart,
        route: '/reports/portfolio',
        requiredRoles: _viewRoles,
      ),
      NavItem(
        id: 'loan_book',
        label: 'Loan Book',
        icon: Icons.menu_book_outlined,
        activeIcon: Icons.menu_book,
        route: '/reports/loan-book',
        requiredRoles: _viewRoles,
      ),
    ],
  ),
  NavItem(
    id: 'operations',
    label: 'Operations',
    icon: Icons.sync_alt_outlined,
    activeIcon: Icons.sync_alt,
    requiredRoles: _viewRoles,
    children: [
      NavItem(
        id: 'disbursement_queue',
        label: 'Disbursement Queue',
        icon: Icons.send_outlined,
        activeIcon: Icons.send,
        route: '/operations/disbursements',
        requiredRoles: _viewRoles,
      ),
      NavItem(
        id: 'transfer_orders',
        label: 'Transfer Orders',
        icon: Icons.swap_horiz_outlined,
        activeIcon: Icons.swap_horiz,
        route: '/operations/transfers',
        requiredRoles: _viewRoles,
      ),
      NavItem(
        id: 'notification_templates',
        label: 'Notification Templates',
        icon: Icons.mail_outlined,
        activeIcon: Icons.mail,
        route: '/operations/templates',
        requiredRoles: _adminRoles,
      ),
    ],
  ),
  NavItem(
    id: 'admin',
    label: 'Administration',
    icon: Icons.admin_panel_settings_outlined,
    activeIcon: Icons.admin_panel_settings,
    requiredRoles: {..._adminRoles, LenderRole.auditor},
    children: [
      NavItem(
        id: 'system_users',
        label: 'System Users',
        icon: Icons.manage_accounts_outlined,
        activeIcon: Icons.manage_accounts,
        route: '/admin/users',
        requiredRoles: _adminRoles,
      ),
      NavItem(
        id: 'roles',
        label: 'Roles & Permissions',
        icon: Icons.security_outlined,
        activeIcon: Icons.security,
        route: '/admin/roles',
        requiredRoles: _adminRoles,
      ),
      NavItem(
        id: 'audit_log',
        label: 'Audit Log',
        icon: Icons.history_outlined,
        activeIcon: Icons.history,
        route: '/admin/audit',
        requiredRoles: {LenderRole.owner, LenderRole.admin, LenderRole.auditor},
      ),
    ],
  ),
];
