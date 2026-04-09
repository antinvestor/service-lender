import 'package:flutter_test/flutter_test.dart';

import 'package:lender_ui/core/auth/role_provider.dart';
import 'package:lender_ui/core/auth/route_permissions.dart';

void main() {
  group('requiredRolesForRoute', () {
    test('admin routes require owner or admin', () {
      final roles = requiredRolesForRoute('/admin/users');
      expect(roles, contains(LenderRole.owner));
      expect(roles, contains(LenderRole.admin));
      expect(roles, isNot(contains(LenderRole.agent)));
      expect(roles, isNot(contains(LenderRole.viewer)));
    });

    test('admin roles route also requires owner/admin', () {
      final roles = requiredRolesForRoute('/admin/roles');
      expect(roles, {LenderRole.owner, LenderRole.admin});
    });

    test('audit log allows auditor too', () {
      final roles = requiredRolesForRoute('/admin/audit');
      expect(roles, contains(LenderRole.auditor));
      expect(roles, contains(LenderRole.owner));
      expect(roles, contains(LenderRole.admin));
    });

    test('field reassignment requires field management roles', () {
      final roles = requiredRolesForRoute('/field/reassignment');
      expect(roles, contains(LenderRole.owner));
      expect(roles, contains(LenderRole.admin));
      expect(roles, contains(LenderRole.manager));
      expect(roles, contains(LenderRole.agent));
      expect(roles, isNot(contains(LenderRole.viewer)));
    });

    test('clients route allows all view roles', () {
      final roles = requiredRolesForRoute('/field/clients');
      expect(roles, contains(LenderRole.agent));
      expect(roles, contains(LenderRole.verifier));
      expect(roles, contains(LenderRole.viewer));
    });

    test('child routes inherit from parent prefix', () {
      final roles = requiredRolesForRoute('/field/clients/abc123');
      expect(roles, contains(LenderRole.agent));
    });

    test('dashboard requires no specific roles', () {
      final roles = requiredRolesForRoute('/');
      expect(roles, isEmpty);
    });

    test('settings requires no specific roles', () {
      final roles = requiredRolesForRoute('/settings');
      expect(roles, isEmpty);
    });

    test('organization routes exclude agents', () {
      final roles = requiredRolesForRoute('/organization/organizations');
      expect(roles, isNot(contains(LenderRole.agent)));
      expect(roles, contains(LenderRole.viewer));
    });

    test('reports require view roles', () {
      final roles = requiredRolesForRoute('/reports/portfolio');
      expect(roles, contains(LenderRole.viewer));
      expect(roles, isNot(contains(LenderRole.agent)));
    });

    test('longest prefix wins for nested routes', () {
      // /field/clients should match /field/clients, not /organization/agents
      final clientRoles = requiredRolesForRoute('/field/clients/detail');
      final agentRoles = requiredRolesForRoute('/organization/agents');
      // Both should be the all-view set
      expect(clientRoles, agentRoles);
    });
  });
}
