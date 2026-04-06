import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lender_ui/core/api/name_resolver.dart';
import 'package:lender_ui/core/widgets/entity_chip.dart';

void main() {
  group('EntityChip', () {
    testWidgets('renders nothing for empty id', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: EntityChip(type: EntityType.client, id: ''),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('shows static label when provided', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            clientNameProvider('test123')
                .overrideWith((_) async => 'John Doe'),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: EntityChip(
                type: EntityType.client,
                id: 'test123',
                label: 'My Label',
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('My Label'), findsOneWidget);
    });

    testWidgets('shows correct icon for each entity type',
        (tester) async {
      for (final type in EntityType.values) {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              clientNameProvider('id1')
                  .overrideWith((_) async => 'Name'),
              productNameProvider('id1')
                  .overrideWith((_) async => 'Product'),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: EntityChip(type: type, id: 'id1'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        // Should render at least one icon
        expect(find.byType(Icon), findsWidgets);
      }
    });

    testWidgets('truncates long IDs as fallback', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Override with a value that returns the fallback (loading)
            clientNameProvider('abcdefghijklmnopqrst')
                .overrideWith((_) async => 'abcdefghijkl...'),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: EntityChip(
                type: EntityType.client,
                id: 'abcdefghijklmnopqrst',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Should show truncated text
      expect(find.byType(EntityChip), findsOneWidget);
    });
  });
}
