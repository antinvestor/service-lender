import 'package:antinvestor_ui_core/permissions/permission_provider.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'nav_items.dart';

part 'nav_state.g.dart';

/// Provides navigation items filtered by granted permissions.
/// Fails open — if permissions can't be loaded, shows all nav items.
@Riverpod(keepAlive: true)
Future<List<NavItem>> filteredNavItems(Ref ref) async {
  Set<String> permissions;
  try {
    permissions = await ref.watch(userPermissionsProvider.future);
  } catch (_) {
    // Fail open — show all items if permission check fails.
    permissions = const {};
  }

  final allItems = buildNavItems();
  // Empty permissions set means no filtering (show everything).
  if (permissions.isEmpty) return allItems;

  return allItems
      .map((item) => item.filterByPermissions(permissions))
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
