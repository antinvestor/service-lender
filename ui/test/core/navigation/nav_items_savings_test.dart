import 'package:flutter_test/flutter_test.dart';

import 'package:lender_ui/core/auth/role_provider.dart';
import 'package:lender_ui/core/navigation/nav_items.dart';

void main() {
  group('Savings nav items', () {
    test('savings section visible to admin', () {
      final items = buildNavItems();
      final adminRoles = {LenderRole.admin};
      final filtered = items
          .map((item) => item.filterByAccess(adminRoles, const {}))
          .whereType<NavItem>()
          .toList();
      final ids = _collectIds(filtered);
      expect(ids, contains('savings'));
      expect(ids, contains('savings_accounts'));
    });

    test('savings section visible to agent', () {
      final items = buildNavItems();
      final agentRoles = {LenderRole.fieldWorker};
      final filtered = items
          .map((item) => item.filterByAccess(agentRoles, const {}))
          .whereType<NavItem>()
          .toList();
      final ids = _collectIds(filtered);
      expect(ids, contains('savings'));
    });

    test('savings section not visible to empty roles', () {
      final items = buildNavItems();
      final noRoles = <LenderRole>{};
      final filtered = items
          .map((item) => item.filterByAccess(noRoles, const {}))
          .whereType<NavItem>()
          .toList();
      final ids = _collectIds(filtered);
      expect(ids, isNot(contains('savings')));
    });
  });
}

List<String> _collectIds(List<NavItem> items) {
  final result = <String>[];
  for (final item in items) {
    result.add(item.id);
    result.addAll(_collectIds(item.children));
  }
  return result;
}
