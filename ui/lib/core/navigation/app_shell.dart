import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../responsive/breakpoints.dart';
import 'app_sidebar.dart';

/// The app shell provides persistent sidebar navigation for all
/// authenticated routes.
///
/// - Desktop/Tablet: persistent sidebar + content area
/// - Mobile: hamburger drawer + full-width content
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final currentRoute =
        GoRouterState.of(context).matchedLocation;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = AppBreakpoints.isMobile(constraints.maxWidth);

        if (isMobile) {
          return _MobileShell(
            currentRoute: currentRoute,
            child: navigationShell,
          );
        }

        return _DesktopShell(
          currentRoute: currentRoute,
          child: navigationShell,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop / tablet layout: persistent sidebar
// ─────────────────────────────────────────────────────────────────────────────

class _DesktopShell extends StatelessWidget {
  const _DesktopShell({
    required this.currentRoute,
    required this.child,
  });

  final String currentRoute;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppSidebar(currentRoute: currentRoute),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mobile layout: drawer sidebar
// ─────────────────────────────────────────────────────────────────────────────

class _MobileShell extends StatelessWidget {
  const _MobileShell({
    required this.currentRoute,
    required this.child,
  });

  final String currentRoute;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _MobileAppBar(currentRoute: currentRoute),
      drawer: Drawer(
        child: AppSidebar(
          currentRoute: currentRoute,
          isDrawer: true,
          onNavigate: () => Navigator.of(context).pop(),
        ),
      ),
      body: child,
    );
  }
}

class _MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _MobileAppBar({required this.currentRoute});
  final String currentRoute;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  String get _title {
    if (currentRoute.startsWith('/organization/banks')) return 'Banks';
    if (currentRoute.startsWith('/organization/branches')) return 'Branches';
    if (currentRoute.startsWith('/field/agents')) return 'Agents';
    if (currentRoute.startsWith('/field/hierarchy')) return 'Hierarchy';
    if (currentRoute.startsWith('/field/clients')) return 'Clients';
    if (currentRoute.startsWith('/organization/investors')) return 'Investors';
    if (currentRoute.startsWith('/field/reassignment')) return 'Reassignment';
    if (currentRoute.startsWith('/admin/users')) return 'System Users';
    if (currentRoute.startsWith('/admin/roles')) return 'Roles & Permissions';
    if (currentRoute.startsWith('/admin/audit')) return 'Audit Log';
    if (currentRoute.startsWith('/settings')) return 'Settings';
    return 'Dashboard';
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_title),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
          tooltip: 'Search',
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
