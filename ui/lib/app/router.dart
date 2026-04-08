import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/auth/role_guard.dart';
import '../core/auth/route_permissions.dart';
import '../core/navigation/app_shell.dart';
import '../features/admin/ui/audit_log_screen.dart';
import '../features/admin/ui/roles_screen.dart';
import '../features/admin/ui/system_users_screen.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/data/auth_state_provider.dart';
import '../features/auth/ui/login_screen.dart';
import '../features/dashboard/ui/dashboard_screen.dart';
import '../features/field/ui/agent_create_screen.dart';
import '../features/field/ui/agents_screen.dart';
import '../features/field/ui/client_detail_screen.dart';
import '../features/field/ui/client_onboard_screen.dart';
import '../features/field/ui/clients_screen.dart';
import '../features/field/ui/hierarchy_screen.dart';
import '../features/field/ui/reassignment_screen.dart';
import '../features/organization/ui/organization_detail_screen.dart';
import '../features/organization/ui/organizations_screen.dart';
import '../features/organization/ui/investors_screen.dart';
import '../features/loan_management/ui/loan_account_detail_screen.dart';
import '../features/loan_management/ui/loan_accounts_screen.dart';
import '../features/loan_management/ui/loan_product_detail_screen.dart';
import '../features/origination/ui/application_create_screen.dart';
import '../features/origination/ui/application_detail_screen.dart';
import '../features/origination/ui/applications_screen.dart';
import '../features/loan_management/ui/loan_products_screen.dart';
import '../features/origination/ui/pending_cases_screen.dart';
import '../features/operations/ui/disbursement_queue_screen.dart';
import '../features/operations/ui/transfer_orders_screen.dart';
import '../features/reporting/ui/portfolio_summary_screen.dart';
import '../features/savings/ui/savings_account_detail_screen.dart';
import '../features/savings/ui/savings_accounts_screen.dart';
import '../features/reporting/ui/loan_book_screen.dart';
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

/// Wraps a screen with [RouteRoleGuard] using the permissions defined
/// in [routePermissions] for the given [routePrefix].
Widget _guarded(String routePrefix, Widget child) {
  final roles = requiredRolesForRoute(routePrefix);
  if (roles.isEmpty) return child;
  return RouteRoleGuard(requiredRoles: roles, child: child);
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final authChangeNotifier = ref.watch(authChangeProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authChangeNotifier,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isLoginRoute = location == '/login';
      final isAuthCallback = location == '/auth/callback';

      // Synchronous check — avoids microtask delays on every navigation.
      // Cache is warm after the first login check.
      final cachedAuth = authRepository.isLoggedInSync;
      if (cachedAuth == null) {
        // Cold start: do async check (only happens once on app launch).
        return authRepository.isLoggedIn().then((isLoggedIn) {
          if (isAuthCallback) return isLoggedIn ? '/' : null;
          if (!isLoggedIn && !isLoginRoute) return '/login';
          if (isLoggedIn && isLoginRoute) return '/';
          return null;
        });
      }

      final isLoggedIn = cachedAuth;
      if (isAuthCallback) return isLoggedIn ? '/' : null;
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
        builder: (context, state) => const _AuthCallbackScreen(),
      ),

      // All authenticated routes live inside the shell.
      // Each route is wrapped with RouteRoleGuard to enforce
      // permissions even when a user navigates via URL directly.
      // All authenticated routes inside a lightweight ShellRoute.
      // No StatefulShellBranch overhead — each page renders fresh inside
      // the persistent sidebar shell.
      ShellRoute(
        builder: (context, state, child) =>
            AppShellSimple(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/organization/organizations',
            builder: (context, state) => _guarded(
              '/organization/organizations',
              const OrganizationsScreen(),
            ),
            routes: [
              GoRoute(
                path: ':organizationId',
                builder: (context, state) => _guarded(
                  '/organization/organizations',
                  OrganizationDetailScreen(
                    organizationId:
                        state.pathParameters['organizationId']!,
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/organization/investors',
            builder: (context, state) => _guarded(
              '/organization/investors',
              const InvestorsScreen(),
            ),
          ),
          GoRoute(
            path: '/field/agents',
            builder: (context, state) => _guarded(
              '/field/agents',
              const AgentsScreen(),
            ),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => _guarded(
                  '/field/agents',
                  const AgentCreateScreen(),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/field/hierarchy',
            builder: (context, state) => _guarded(
              '/field/hierarchy',
              const HierarchyScreen(),
            ),
          ),
          GoRoute(
            path: '/field/clients',
            builder: (context, state) => _guarded(
              '/field/clients',
              const ClientsScreen(),
            ),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => _guarded(
                  '/field/clients',
                  const ClientOnboardScreen(),
                ),
              ),
              GoRoute(
                path: ':clientId',
                builder: (context, state) => _guarded(
                  '/field/clients',
                  ClientDetailScreen(
                    clientId: state.pathParameters['clientId']!,
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/field/reassignment',
            builder: (context, state) => _guarded(
              '/field/reassignment',
              const ReassignmentScreen(),
            ),
          ),
          GoRoute(
            path: '/origination/pending',
            builder: (context, state) => _guarded(
              '/origination/pending',
              const PendingCasesScreen(),
            ),
          ),
          GoRoute(
            path: '/origination/applications',
            builder: (context, state) => _guarded(
              '/origination/applications',
              const ApplicationsScreen(),
            ),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => _guarded(
                  '/origination/applications',
                  ApplicationCreateScreen(
                    clientId: state.uri.queryParameters['clientId'],
                  ),
                ),
              ),
              GoRoute(
                path: ':applicationId',
                builder: (context, state) => _guarded(
                  '/origination/applications',
                  ApplicationDetailScreen(
                    applicationId:
                        state.pathParameters['applicationId']!,
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/loans/products',
            builder: (context, state) => _guarded(
              '/loans/products',
              const LoanProductsScreen(),
            ),
            routes: [
              GoRoute(
                path: ':productId',
                builder: (context, state) => _guarded(
                  '/loans/products',
                  LoanProductDetailScreen(
                    productId: state.pathParameters['productId']!,
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/loans',
            builder: (context, state) => _guarded(
              '/loans',
              const LoanAccountsScreen(),
            ),
            routes: [
              GoRoute(
                path: ':loanId',
                builder: (context, state) => _guarded(
                  '/loans',
                  LoanAccountDetailScreen(
                    loanId: state.pathParameters['loanId']!,
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/savings',
            builder: (context, state) => _guarded(
              '/savings',
              const SavingsAccountsScreen(),
            ),
            routes: [
              GoRoute(
                path: ':accountId',
                builder: (context, state) => _guarded(
                  '/savings',
                  SavingsAccountDetailScreen(
                    accountId: state.pathParameters['accountId']!,
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/reports/portfolio',
            builder: (context, state) => _guarded(
              '/reports/portfolio',
              const PortfolioSummaryScreen(),
            ),
          ),
          GoRoute(
            path: '/reports/loan-book',
            builder: (context, state) => _guarded(
              '/reports/loan-book',
              const LoanBookScreen(),
            ),
          ),
          GoRoute(
            path: '/operations/disbursements',
            builder: (context, state) => _guarded(
              '/operations/disbursements',
              const DisbursementQueueScreen(),
            ),
          ),
          GoRoute(
            path: '/operations/transfers',
            builder: (context, state) => _guarded(
              '/operations/transfers',
              const TransferOrdersScreen(),
            ),
          ),
          GoRoute(
            path: '/admin/users',
            builder: (context, state) => _guarded(
              '/admin/users',
              const SystemUsersScreen(),
            ),
          ),
          GoRoute(
            path: '/admin/roles',
            builder: (context, state) => _guarded(
              '/admin/roles',
              const RolesScreen(),
            ),
          ),
          GoRoute(
            path: '/admin/audit',
            builder: (context, state) => _guarded(
              '/admin/audit',
              const AuditLogScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}

/// Handles the OAuth callback: shows a loading spinner while the token
/// exchange completes, then redirects to '/'. If already authenticated
/// (e.g. page refresh with a warm session), redirects immediately.
class _AuthCallbackScreen extends ConsumerStatefulWidget {
  const _AuthCallbackScreen();

  @override
  ConsumerState<_AuthCallbackScreen> createState() =>
      _AuthCallbackScreenState();
}

class _AuthCallbackScreenState extends ConsumerState<_AuthCallbackScreen> {
  @override
  void initState() {
    super.initState();
    _processCallback();
  }

  Future<void> _processCallback() async {
    final authRepo = ref.read(authRepositoryProvider);

    // isAuthenticated() detects the OAuth redirect result (code + state
    // in the URL), exchanges them for tokens, and caches the session.
    final loggedIn = await authRepo.isLoggedIn();

    if (!mounted) return;

    if (loggedIn) {
      // Invalidate auth state so the router picks up the new session.
      ref.invalidate(authStateProvider);
    }

    // Navigate to root — the router redirect handles the rest.
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
