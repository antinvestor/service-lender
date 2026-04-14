import 'package:antinvestor_ui_core/responsive/breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigation/app_sidebar.dart';

/// Seed app shell: persistent sidebar on desktop, drawer on mobile.
class SeedShell extends StatelessWidget {
  const SeedShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).matchedLocation;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = AppBreakpoints.isMobile(constraints.maxWidth);

        if (isMobile) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Seed'),
              leading: Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              ),
            ),
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

        return Scaffold(
          body: Row(
            children: [
              AppSidebar(currentRoute: currentRoute),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }
}
