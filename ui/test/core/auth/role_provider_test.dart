import 'package:flutter_test/flutter_test.dart';

import 'package:lender_ui/core/auth/role_provider.dart';

void main() {
  group('parseLenderRole', () {
    test('parses standard role names', () {
      expect(parseLenderRole('owner'), LenderRole.owner);
      expect(parseLenderRole('admin'), LenderRole.admin);
      expect(parseLenderRole('manager'), LenderRole.manager);
      expect(parseLenderRole('agent'), LenderRole.agent);
      expect(parseLenderRole('verifier'), LenderRole.verifier);
      expect(parseLenderRole('approver'), LenderRole.approver);
      expect(parseLenderRole('auditor'), LenderRole.auditor);
      expect(parseLenderRole('viewer'), LenderRole.viewer);
      expect(parseLenderRole('service'), LenderRole.service);
    });

    test('is case-insensitive', () {
      expect(parseLenderRole('OWNER'), LenderRole.owner);
      expect(parseLenderRole('Admin'), LenderRole.admin);
      expect(parseLenderRole('MANAGER'), LenderRole.manager);
    });

    test('strips underscores', () {
      expect(parseLenderRole('ver_ifier'), LenderRole.verifier);
      expect(parseLenderRole('app_rover'), LenderRole.approver);
    });

    test('returns null for unrecognized roles', () {
      expect(parseLenderRole('superadmin'), isNull);
      expect(parseLenderRole(''), isNull);
      expect(parseLenderRole('unknown_role'), isNull);
    });
  });
}
