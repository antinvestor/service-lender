import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/api/api_provider.dart' show resetAuthFailureGuard;
import '../core/auth/tenancy_context.dart';
import '../core/auth/role_guard.dart';
import '../core/auth/route_permissions.dart';
import '../core/navigation/app_shell.dart';
import '../features/admin/ui/audit_log_screen.dart';
import '../features/admin/ui/roles_screen.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/data/auth_state_provider.dart';
import '../features/auth/ui/login_screen.dart';
import '../features/auth/ui/terms_screen.dart';
import '../features/dashboard/ui/dashboard_screen.dart';
import '../features/field/ui/client_detail_screen.dart';
import '../features/field/ui/client_onboard_screen.dart';
import '../features/field/ui/clients_screen.dart';
import '../features/organization/ui/org_unit_detail_screen.dart';
import '../features/organization/ui/org_units_screen.dart';
import '../features/organization/ui/organization_detail_screen.dart';
import '../features/organization/ui/organizations_screen.dart';
import '../features/organization/ui/investors_screen.dart';
import '../features/loan_management/ui/loan_account_detail_screen.dart';
import '../features/loan_management/ui/loan_accounts_screen.dart';
import '../features/loan_management/ui/loan_product_detail_screen.dart';
import '../features/loan_management/ui/loan_products_screen.dart';
import '../features/operations/ui/disbursement_queue_screen.dart';
import '../features/operations/ui/notification_templates_screen.dart';
import '../features/operations/ui/transfer_orders_screen.dart';
import '../features/funding/ui/investor_account_detail_screen.dart';
import '../features/funding/ui/investor_accounts_screen.dart';
import '../features/reporting/ui/portfolio_summary_screen.dart';
import '../features/savings/ui/savings_account_detail_screen.dart';
import '../features/savings/ui/savings_accounts_screen.dart';
import '../features/savings/ui/savings_products_screen.dart';
import '../features/reporting/ui/loan_book_screen.dart';
import '../features/settings/ui/settings_screen.dart';
import '../features/workforce/data/workforce_member_status_provider.dart';
import '../features/workforce/ui/access_roles_screen.dart';
import '../features/workforce/ui/workforce_member_create_screen.dart';
import '../features/workforce/ui/workforce_member_detail_screen.dart';
import '../features/workforce/ui/client_team_transfer_screen.dart';
import '../features/workforce/ui/workforce_members_screen.dart';

part 'router.g.dart';

/// Notifier that triggers router refresh when auth state changes.
class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier(Ref ref) {
    ref.listen(authStateProvider, (previous, next) {
      notifyListeners();
    });
    ref.listen(workforceMemberStatusProvider, (previous, next) {
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
      final isLoginRoute =
          location == '/login' || location.startsWith('/login/');
      final isAuthCallback = location == '/auth/callback';
      final isTermsRoute = location == '/terms';

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

      // T&C check for authenticated users.
      if (isLoggedIn) {
        final memberStatus = ref.read(workforceMemberStatusProvider);
        final status = memberStatus.value;
        if (status != null) {
          if (!isTermsRoute &&
              status ==
                  WorkforceMemberOnboardingStatus.pendingActivation) {
            return '/terms';
          }
          if (isTermsRoute &&
              (status == WorkforceMemberOnboardingStatus.active ||
                  status == WorkforceMemberOnboardingStatus.notMember)) {
            return '/';
          }
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/login/:clientId',
        builder: (context, state) =>
            LoginScreen(initialClientId: state.pathParameters['clientId']),
      ),
      GoRoute(
        path: '/auth/callback',
        builder: (context, state) => const _AuthCallbackScreen(),
      ),
      GoRoute(path: '/terms', builder: (context, state) => const TermsScreen()),

      ShellRoute(
        builder: (context, state, child) => AppShellSimple(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => _guarded('/', const DashboardScreen()),
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
                    organizationId: state.pathParameters['organizationId']!,
                  ),
                ),
                routes: [
                  GoRoute(
                    path: 'org-units/:orgUnitId',
                    builder: (context, state) => _guarded(
                      '/organization/organizations',
                      OrgUnitDetailScreen(
                        orgUnitId: state.pathParameters['orgUnitId']!,
                        organizationId: state.pathParameters['organizationId']!,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/organization/org-units',
            builder: (context, state) =>
                _guarded('/organization/org-units', const OrgUnitsScreen()),
            routes: [
              GoRoute(
                path: ':orgUnitId',
                builder: (context, state) => _guarded(
                  '/organization/org-units',
                  OrgUnitDetailScreen(
                    orgUnitId: state.pathParameters['orgUnitId']!,
                    organizationId: '',
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/organization/investors',
            builder: (context, state) =>
                _guarded('/organization/investors', const InvestorsScreen()),
          ),
          // Workforce routes
          GoRoute(
            path: '/workforce/members',
            builder: (context, state) => _guarded(
              '/workforce/members',
              const WorkforceMembersScreen(),
            ),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => _guarded(
                  '/workforce/members',
                  const WorkforceMemberCreateScreen(),
                ),
              ),
              GoRoute(
                path: ':memberId',
                builder: (context, state) => _guarded(
                  '/workforce/members',
                  WorkforceMemberDetailScreen(
                    memberId: state.pathParameters['memberId']!,
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/workforce/transfers',
            builder: (context, state) => _guarded(
              '/workforce/transfers',
              const ClientTeamTransferScreen(),
            ),
          ),
          GoRoute(
            path: '/field/clients',
            builder: (context, state) =>
                _guarded('/field/clients', const ClientsScreen()),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) =>
                    _guarded('/field/clients', const ClientOnboardScreen()),
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
          // TODO: Add loan request routes after Dart SDK regeneration
          // from the new loans.proto LoanRequest types.
          GoRoute(
            path: '/loans/products',
            builder: (context, state) =>
                _guarded('/loans/products', const LoanProductsScreen()),
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
            builder: (context, state) =>
                _guarded('/loans', const LoanAccountsScreen()),
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
            path: '/savings/products',
            builder: (context, state) =>
                _guarded('/savings/products', const SavingsProductsScreen()),
          ),
          GoRoute(
            path: '/savings',
            builder: (context, state) =>
                _guarded('/savings', const SavingsAccountsScreen()),
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
            path: '/funding/accounts',
            builder: (context, state) =>
                _guarded('/funding/accounts', const InvestorAccountsScreen()),
            routes: [
              GoRoute(
                path: ':accountId',
                builder: (context, state) => _guarded(
                  '/funding/accounts',
                  InvestorAccountDetailScreen(
                    accountId: state.pathParameters['accountId']!,
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/reports/portfolio',
            builder: (context, state) =>
                _guarded('/reports/portfolio', const PortfolioSummaryScreen()),
          ),
          GoRoute(
            path: '/reports/loan-book',
            builder: (context, state) =>
                _guarded('/reports/loan-book', const LoanBookScreen()),
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
            builder: (context, state) =>
                _guarded('/operations/transfers', const TransferOrdersScreen()),
          ),
          GoRoute(
            path: '/operations/templates',
            builder: (context, state) => _guarded(
              '/operations/templates',
              const NotificationTemplatesScreen(),
            ),
          ),
          GoRoute(
            path: '/admin/access-roles',
            builder: (context, state) =>
                _guarded('/admin/access-roles', const AccessRolesScreen()),
          ),
          GoRoute(
            path: '/admin/roles',
            builder: (context, state) =>
                _guarded('/admin/roles', const RolesScreen()),
          ),
          GoRoute(
            path: '/admin/audit',
            builder: (context, state) =>
                _guarded('/admin/audit', const AuditLogScreen()),
          ),
          GoRoute(
            path: '/admin/form-templates',
            builder: (context, state) =>
                _guarded('/admin/form-templates', const FormTemplatesScreen()),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => _guarded(
                  '/admin/form-templates',
                  const FormTemplateDesignerScreen(),
                ),
              ),
              GoRoute(
                path: ':templateId',
                builder: (context, state) => _guarded(
                  '/admin/form-templates',
                  FormTemplateDesignerScreen(
                    templateId: state.pathParameters['templateId'],
                  ),
                ),
              ),
            ],
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

    final loggedIn = await authRepo.isLoggedIn();

    if (!mounted) return;

    if (loggedIn) {
      resetAuthFailureGuard();

      await _initializeTenancyFromJwt(ref);

      if (!mounted) return;

      ref.invalidate(authStateProvider);
      ref.invalidate(workforceMemberStatusProvider);
    }

    context.go('/');
  }

  Future<void> _initializeTenancyFromJwt(WidgetRef ref) async {
    try {
      final authRepo = ref.read(authRepositoryProvider);
      final partitionId = await authRepo.getCurrentPartitionId();
      final tenancy = ref.read(tenancyContextProvider);
      final loginContext = await authRepo.getStoredLoginContext();

      if (loginContext != null) {
        tenancy.initializeFromLogin(
          loginContext.level,
          partitionId: partitionId,
          orgId: loginContext.orgId,
          orgName: loginContext.orgName,
          branchId: loginContext.branchId,
          branchName: loginContext.branchName,
        );
      } else {
        tenancy.initializeFromLogin(LoginLevel.root, partitionId: partitionId);
      }
    } catch (e) {
      debugPrint('Failed to initialize tenancy: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
