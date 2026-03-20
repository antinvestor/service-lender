import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/navigation/app_shell.dart';
import '../features/admin/ui/audit_log_screen.dart';
import '../features/admin/ui/roles_screen.dart';
import '../features/admin/ui/system_users_screen.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/data/auth_state_provider.dart';
import '../features/auth/ui/login_screen.dart';
import '../features/dashboard/ui/dashboard_screen.dart';
import '../features/field/ui/agents_screen.dart';
import '../features/field/ui/borrowers_screen.dart';
import '../features/field/ui/hierarchy_screen.dart';
import '../features/field/ui/reassignment_screen.dart';
import '../features/organization/ui/bank_detail_screen.dart';
import '../features/organization/ui/banks_screen.dart';
import '../features/organization/ui/investors_screen.dart';
import '../features/loan_management/ui/loan_account_detail_screen.dart';
import '../features/loan_management/ui/loan_accounts_screen.dart';
import '../features/origination/ui/application_detail_screen.dart';
import '../features/origination/ui/applications_screen.dart';
import '../features/origination/ui/loan_products_screen.dart';
import '../features/settings/ui/settings_screen.dart';

part 'router.g.dart';

/// Notifier that triggers router refresh when auth state changes.
class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier(Ref ref) {
    ref.listen(authStateProvider, (previous, next) {
      notifyListeners();
    });
  }
}

@Riverpod(keepAlive: true)
AuthChangeNotifier authChange(Ref ref) => AuthChangeNotifier(ref);

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final authChangeNotifier = ref.watch(authChangeProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authChangeNotifier,
    redirect: (context, state) async {
      final isLoggedIn = await authRepository.isLoggedIn();
      final location = state.matchedLocation;
      final isLoginRoute = location == '/login';
      final isAuthCallback = location == '/auth/callback';

      if (isAuthCallback) {
        if (isLoggedIn) {
          ref.invalidate(authStateProvider);
          return '/';
        }
        return '/login';
      }

      if (!isLoggedIn && !isLoginRoute) return '/login';
      if (isLoggedIn && isLoginRoute) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/callback',
        builder: (context, state) => const LoginScreen(),
      ),

      // All authenticated routes live inside the shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          // Dashboard (root)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),

          // Organization — Banks (list + detail with branches)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/organization/banks',
                builder: (context, state) => const BanksScreen(),
                routes: [
                  GoRoute(
                    path: ':bankId',
                    builder: (context, state) => BankDetailScreen(
                      bankId: state.pathParameters['bankId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/organization/investors',
                builder: (context, state) => const InvestorsScreen(),
              ),
            ],
          ),

          // Field Operations
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/field/agents',
                builder: (context, state) => const AgentsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/field/hierarchy',
                builder: (context, state) => const HierarchyScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/field/borrowers',
                builder: (context, state) => const BorrowersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/field/reassignment',
                builder: (context, state) => const ReassignmentScreen(),
              ),
            ],
          ),

          // Origination — Loan Products
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/origination/products',
                builder: (context, state) => const LoanProductsScreen(),
              ),
            ],
          ),
          // Origination — Applications (list + detail)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/origination/applications',
                builder: (context, state) => const ApplicationsScreen(),
                routes: [
                  GoRoute(
                    path: ':applicationId',
                    builder: (context, state) => ApplicationDetailScreen(
                      applicationId: state.pathParameters['applicationId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Loan Management — Loan Accounts (list + detail)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/loans',
                builder: (context, state) => const LoanAccountsScreen(),
                routes: [
                  GoRoute(
                    path: ':loanId',
                    builder: (context, state) => LoanAccountDetailScreen(
                      loanId: state.pathParameters['loanId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Administration
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/users',
                builder: (context, state) => const SystemUsersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/roles',
                builder: (context, state) => const RolesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/audit',
                builder: (context, state) => const AuditLogScreen(),
              ),
            ],
          ),

          // Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
