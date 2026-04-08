import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../auth/role_provider.dart';
import 'nav_items.dart';

part 'nav_state.g.dart';

/// Provides the filtered navigation items based on current user roles.
@Riverpod(keepAlive: true)
Future<List<NavItem>> filteredNavItems(Ref ref) async {
  final roles = await ref.watch(currentUserRolesProvider.future);
  final allItems = buildNavItems();
  return allItems
      .map((item) => item.filterByRoles(roles))
      .whereType<NavItem>()
      .toList();
}

/// Tracks which parent nav sections are expanded in the sidebar.
class SidebarExpansionState extends ChangeNotifier {
  final Set<String> _expanded = {};

  bool isExpanded(String id) => _expanded.contains(id);

  void toggle(String id) {
    if (_expanded.contains(id)) {
      _expanded.remove(id);
    } else {
      _expanded.add(id);
    }
    notifyListeners();
  }

  void expand(String id) {
    if (_expanded.add(id)) notifyListeners();
  }

  void collapse(String id) {
    if (_expanded.remove(id)) notifyListeners();
  }

  /// Auto-expand the section that contains the current route.
  void expandForRoute(String route, List<NavItem> items) {
    for (final item in items) {
      if (item.hasChildren && item.matchesRoute(route)) {
        _expanded.add(item.id);
      }
    }
    notifyListeners();
  }
}

@Riverpod(keepAlive: true)
SidebarExpansionState sidebarExpansion(Ref ref) {
  return SidebarExpansionState();
}
