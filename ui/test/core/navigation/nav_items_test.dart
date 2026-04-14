import 'package:flutter_test/flutter_test.dart';

import 'package:lender_ui/core/auth/role_provider.dart';
import 'package:lender_ui/core/navigation/nav_items.dart';

void main() {
  group('NavItem.filterByAccess', () {
    test('agent cannot see admin section', () {
      final items = buildNavItems();
      final agentRoles = {LenderRole.fieldWorker};

      final filtered = items
          .map((item) => item.filterByAccess(agentRoles, const {}))
          .whereType<NavItem>()
          .toList();

      final ids = _collectIds(filtered);
      expect(ids, isNot(contains('admin')));
      expect(ids, isNot(contains('system_users')));
      expect(ids, isNot(contains('roles')));
      expect(ids, isNot(contains('audit_log')));
    });

    test('agent cannot see organization section', () {
      final items = buildNavItems();
      final agentRoles = {LenderRole.fieldWorker};

      final filtered = items
          .map((item) => item.filterByAccess(agentRoles, const {}))
          .whereType<NavItem>()
          .toList();

      final ids = _collectIds(filtered);
      expect(ids, isNot(contains('organization')));
      expect(ids, isNot(contains('organizations')));
    });

    test('agent can see field operations', () {
      final items = buildNavItems();
      final agentRoles = {LenderRole.fieldWorker};

      final filtered = items
          .map((item) => item.filterByAccess(agentRoles, const {}))
          .whereType<NavItem>()
          .toList();

      final ids = _collectIds(filtered);
      expect(ids, contains('field_operations'));
      expect(ids, contains('clients'));
    });

    test('agent can see origination', () {
      final items = buildNavItems();
      final agentRoles = {LenderRole.fieldWorker};

      final filtered = items
          .map((item) => item.filterByAccess(agentRoles, const {}))
          .whereType<NavItem>()
          .toList();

      final ids = _collectIds(filtered);
      expect(ids, contains('origination'));
      expect(ids, contains('applications'));
    });

    test('admin sees all sections', () {
      final items = buildNavItems();
      final adminRoles = {LenderRole.admin};

      final filtered = items
          .map((item) => item.filterByAccess(adminRoles, const {}))
          .whereType<NavItem>()
          .toList();

      final ids = _collectIds(filtered);
      expect(ids, contains('dashboard'));
      expect(ids, contains('organization'));
      expect(ids, contains('field_operations'));
      expect(ids, contains('origination'));
      expect(ids, contains('loan_management'));
      expect(ids, contains('reports'));
      expect(ids, contains('operations'));
      expect(ids, contains('admin'));
    });

    test('auditor can see audit log but not system users', () {
      final items = buildNavItems();
      final auditorRoles = {LenderRole.auditor};

      final filtered = items
          .map((item) => item.filterByAccess(auditorRoles, const {}))
          .whereType<NavItem>()
          .toList();

      final ids = _collectIds(filtered);
      // Admin parent now allows auditors through
      expect(ids, contains('admin'));
      expect(ids, contains('audit_log'));
      // But system_users and roles require {owner, admin} only
      expect(ids, isNot(contains('system_users')));
      expect(ids, isNot(contains('roles')));
    });

    test('verifier can see pending cases', () {
      final items = buildNavItems();
      final verifierRoles = {LenderRole.verifier};

      final filtered = items
          .map((item) => item.filterByAccess(verifierRoles, const {}))
          .whereType<NavItem>()
          .toList();

      final ids = _collectIds(filtered);
      expect(ids, contains('pending_cases'));
    });

    test('viewer cannot see client reassignment', () {
      final items = buildNavItems();
      final viewerRoles = {LenderRole.viewer};

      final filtered = items
          .map((item) => item.filterByAccess(viewerRoles, const {}))
          .whereType<NavItem>()
          .toList();

      final ids = _collectIds(filtered);
      expect(ids, isNot(contains('client_reassignment')));
    });

    test('empty roles set sees only dashboard', () {
      final items = buildNavItems();
      final noRoles = <LenderRole>{};

      final filtered = items
          .map((item) => item.filterByAccess(noRoles, const {}))
          .whereType<NavItem>()
          .toList();

      // Dashboard has no requiredRoles, so it passes
      final ids = _collectIds(filtered);
      expect(ids, contains('dashboard'));
      // All other sections have requiredRoles, so they're filtered out
      expect(ids, isNot(contains('admin')));
      expect(ids, isNot(contains('organization')));
    });
  });
}

/// Recursively collect all NavItem IDs for assertion.
List<String> _collectIds(List<NavItem> items) {
  final result = <String>[];
  for (final item in items) {
    result.add(item.id);
    result.addAll(_collectIds(item.children));
  }
  return result;
}
