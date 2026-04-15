import 'package:antinvestor_ui_core/api/api_base.dart';
import 'package:antinvestor_ui_core/auth/role_provider.dart';
import 'package:antinvestor_ui_core/permissions/permission_provider.dart';
import 'package:antinvestor_ui_funding/antinvestor_ui_funding.dart'
    show fundingTransportProvider;
import 'package:antinvestor_ui_identity/antinvestor_ui_identity.dart'
    show identityTransportProvider;
import 'package:antinvestor_ui_loans/antinvestor_ui_loans.dart'
    show loansTransportProvider;
import 'package:antinvestor_ui_operations/antinvestor_ui_operations.dart'
    show operationsTransportProvider;
import 'package:antinvestor_ui_savings/antinvestor_ui_savings.dart'
    show savingsTransportProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'app/router.dart';
import 'core/auth/auth_bridge.dart';
import 'core/auth/permission_checker.dart';
import 'core/auth/permission_manifests.dart';
import 'core/config/app_config.dart';
import 'core/config/url_strategy.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureUrlStrategy();

  // Register permission manifests before app starts.
  registerPermissionManifests();

  runApp(
    ProviderScope(
      overrides: [
        // Bridge lender auth → ui_core AuthTokenProvider.
        authTokenProviderProvider.overrideWith((ref) {
          final authRepo = ref.watch(authRepositoryProvider);
          return LenderAuthTokenBridge(authRepo);
        }),

        // Bridge lender JWT roles → ui_core string-based roles.
        currentUserRolesProvider.overrideWith((ref) async {
          final authRepo = ref.watch(authRepositoryProvider);
          final roles = await authRepo.getUserRoles();
          return roles.toSet();
        }),

        // Batch permission check at startup.
        userPermissionsProvider.overrideWith((ref) async {
          final authRepo = ref.watch(authRepositoryProvider);
          final token = await authRepo.getAccessToken();
          if (token == null || token.isEmpty) return const <String>{};

          final checker = PermissionBatchChecker(
            http.Client(),
            AppConfig.identityBaseUrl,
          );
          return checker.checkAll(token);
        }),

        // ── Library endpoint overrides ──────────────────────────────
        // Override each library's transport to use AppConfig endpoints.
        identityTransportProvider.overrideWith((ref) {
          final auth = ref.watch(authTokenProviderProvider);
          return createTransport(auth, baseUrl: AppConfig.identityBaseUrl);
        }),
        loansTransportProvider.overrideWith((ref) {
          final auth = ref.watch(authTokenProviderProvider);
          return createTransport(auth, baseUrl: AppConfig.loansBaseUrl);
        }),
        savingsTransportProvider.overrideWith((ref) {
          final auth = ref.watch(authTokenProviderProvider);
          return createTransport(auth, baseUrl: AppConfig.savingsBaseUrl);
        }),
        fundingTransportProvider.overrideWith((ref) {
          final auth = ref.watch(authTokenProviderProvider);
          return createTransport(auth, baseUrl: AppConfig.fundingBaseUrl);
        }),
        operationsTransportProvider.overrideWith((ref) {
          final auth = ref.watch(authTokenProviderProvider);
          return createTransport(auth, baseUrl: AppConfig.operationsBaseUrl);
        }),
      ],
      child: const LenderApp(),
    ),
  );
}

class LenderApp extends ConsumerWidget {
  const LenderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'AntInvestor Lender',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
