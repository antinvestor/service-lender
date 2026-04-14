import 'package:antinvestor_ui_core/navigation/nav_items.dart';
import 'package:antinvestor_ui_core/permissions/permission_manifest.dart';
import 'package:antinvestor_ui_core/routing/route_module.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/dashboard_screen.dart';
import '../screens/loan_account_detail_screen.dart';
import '../screens/loan_accounts_screen.dart';
import '../screens/loan_book_screen.dart';
import '../screens/loan_product_detail_screen.dart';
import '../screens/loan_products_screen.dart';
import '../screens/loan_request_detail_screen.dart';
import '../screens/loan_requests_screen.dart';
import '../screens/portfolio_summary_screen.dart';

class LoansRouteModule extends RouteModule {
  @override
  String get moduleId => 'loans';

  @override
  List<RouteBase> buildRoutes() => [
        GoRoute(
          path: '/loans',
          builder: (context, state) => const LoanAccountsScreen(),
          routes: [
            GoRoute(
              path: 'dashboard',
              builder: (context, state) => const LoansDashboardScreen(),
            ),
            GoRoute(
              path: 'products',
              builder: (context, state) => const LoanProductsScreen(),
              routes: [
                GoRoute(
                  path: ':productId',
                  builder: (context, state) => LoanProductDetailScreen(
                    productId: state.pathParameters['productId']!,
                  ),
                ),
              ],
            ),
            GoRoute(
              path: 'requests',
              builder: (context, state) => const LoanRequestsScreen(),
              routes: [
                GoRoute(
                  path: 'pending',
                  builder: (context, state) =>
                      const LoanRequestsScreen(pendingOnly: true),
                ),
                GoRoute(
                  path: ':requestId',
                  builder: (context, state) => LoanRequestDetailScreen(
                    requestId: state.pathParameters['requestId']!,
                  ),
                ),
              ],
            ),
            GoRoute(
              path: ':loanId',
              builder: (context, state) => LoanAccountDetailScreen(
                loanId: state.pathParameters['loanId']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/reports/portfolio',
          builder: (context, state) => const PortfolioSummaryScreen(),
        ),
        GoRoute(
          path: '/reports/loan-book',
          builder: (context, state) => const LoanBookScreen(),
        ),
      ];

  @override
  List<NavItem> buildNavItems() => [
        const NavItem(
          id: 'loans',
          label: 'Loans',
          icon: Icons.account_balance_wallet_outlined,
          activeIcon: Icons.account_balance_wallet,
          route: '/loans',
          requiredPermissions: {'loan_view'},
        ),
        const NavItem(
          id: 'loans_dashboard',
          label: 'Dashboard',
          icon: Icons.dashboard_outlined,
          activeIcon: Icons.dashboard,
          route: '/loans/dashboard',
          requiredPermissions: {'loan_view'},
        ),
      ];

  @override
  Map<String, Set<String>> get routePermissions => {
        '/loans': {'loan_view'},
        '/loans/dashboard': {'loan_view'},
        '/loans/products': {'loan_product_view'},
        '/loans/requests': {'loan_request_view'},
        '/reports/portfolio': {'portfolio_view'},
        '/reports/loan-book': {'portfolio_view'},
      };

  @override
  PermissionManifest get permissionManifest => const PermissionManifest(
        namespace: 'service_loans',
        permissions: [
          PermissionEntry(
            key: 'loan_view',
            label: 'View Loans',
            scope: PermissionScope.service,
          ),
          PermissionEntry(
            key: 'loan_manage',
            label: 'Manage Loans',
            scope: PermissionScope.action,
          ),
          PermissionEntry(
            key: 'loan_product_view',
            label: 'View Loan Products',
            scope: PermissionScope.feature,
          ),
          PermissionEntry(
            key: 'loan_product_manage',
            label: 'Manage Loan Products',
            scope: PermissionScope.action,
          ),
          PermissionEntry(
            key: 'loan_request_view',
            label: 'View Loan Requests',
            scope: PermissionScope.feature,
          ),
          PermissionEntry(
            key: 'loan_request_manage',
            label: 'Manage Loan Requests',
            scope: PermissionScope.action,
          ),
          PermissionEntry(
            key: 'repayment_record',
            label: 'Record Repayments',
            scope: PermissionScope.action,
          ),
          PermissionEntry(
            key: 'disbursement_manage',
            label: 'Manage Disbursements',
            scope: PermissionScope.action,
          ),
          PermissionEntry(
            key: 'portfolio_view',
            label: 'View Portfolio Reports',
            scope: PermissionScope.feature,
          ),
        ],
      );
}
