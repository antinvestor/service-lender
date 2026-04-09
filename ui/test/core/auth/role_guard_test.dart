import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lender_ui/core/auth/role_guard.dart';
import 'package:lender_ui/core/auth/role_provider.dart';

void main() {
  group('RoleGuard', () {
    testWidgets('shows child when user has required role', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserRolesProvider.overrideWith(
              (_) async => {LenderRole.admin},
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RoleGuard(
                requiredRoles: {LenderRole.admin},
                child: Text('Admin Content'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Admin Content'), findsOneWidget);
    });

    testWidgets('hides child when user lacks required role', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserRolesProvider.overrideWith(
              (_) async => {LenderRole.agent},
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RoleGuard(
                requiredRoles: {LenderRole.admin, LenderRole.owner},
                child: Text('Admin Content'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Admin Content'), findsNothing);
    });

    testWidgets('shows fallback when user lacks role', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserRolesProvider.overrideWith(
              (_) async => {LenderRole.viewer},
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RoleGuard(
                requiredRoles: {LenderRole.admin},
                fallback: Text('No Access'),
                child: Text('Admin Content'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Admin Content'), findsNothing);
      expect(find.text('No Access'), findsOneWidget);
    });

    testWidgets('shows child when requiredRoles is empty (any role)', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserRolesProvider.overrideWith(
              (_) async => {LenderRole.viewer},
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RoleGuard(requiredRoles: {}, child: Text('Public Content')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Public Content'), findsOneWidget);
    });

    testWidgets('shows child with intersection match', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserRolesProvider.overrideWith(
              (_) async => {LenderRole.agent, LenderRole.verifier},
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RoleGuard(
                requiredRoles: {LenderRole.verifier, LenderRole.approver},
                child: Text('Verification Content'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Verification Content'), findsOneWidget);
    });
  });

  group('RouteRoleGuard', () {
    testWidgets('shows Access Denied when user lacks role', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserRolesProvider.overrideWith(
              (_) async => {LenderRole.agent},
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RouteRoleGuard(
                requiredRoles: {LenderRole.admin},
                child: Text('Admin Page'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Admin Page'), findsNothing);
      expect(find.text('Access Denied'), findsOneWidget);
    });

    testWidgets('shows child when user has role', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserRolesProvider.overrideWith(
              (_) async => {LenderRole.admin},
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RouteRoleGuard(
                requiredRoles: {LenderRole.admin},
                child: Text('Admin Page'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Admin Page'), findsOneWidget);
    });
  });
}
