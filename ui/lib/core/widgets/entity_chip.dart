import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../api/name_resolver.dart';

/// Entity types that can be displayed as tappable navigation chips.
enum EntityType { client, agent, product, application, loan }

/// A tappable chip that resolves an entity name and navigates to its detail.
///
/// Usage:
/// ```dart
/// EntityChip(type: EntityType.client, id: app.clientId)
/// ```
class EntityChip extends ConsumerWidget {
  const EntityChip({
    super.key,
    required this.type,
    required this.id,
    this.label,
  });

  final EntityType type;
  final String id;

  /// Override the resolved name with a static label.
  final String? label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (id.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final resolvedName = label ?? _resolveName(ref);
    final (icon, color) = _typeAppearance(theme);

    return InkWell(
      onTap: () => _navigate(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(40)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                resolvedName,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _resolveName(WidgetRef ref) {
    final fallback =
        id.length > 12 ? '${id.substring(0, 12)}...' : id;

    return switch (type) {
      EntityType.client => ref
          .watch(clientNameProvider(id))
          .when(data: (n) => n, loading: () => fallback, error: (_, _) => fallback),
      EntityType.product => ref
          .watch(productNameProvider(id))
          .when(data: (n) => n, loading: () => fallback, error: (_, _) => fallback),
      _ => fallback,
    };
  }

  (IconData, Color) _typeAppearance(ThemeData theme) {
    return switch (type) {
      EntityType.client => (Icons.person_outline, theme.colorScheme.primary),
      EntityType.agent => (Icons.person_pin_outlined, Colors.indigo),
      EntityType.product => (Icons.inventory_2_outlined, Colors.teal),
      EntityType.application => (Icons.description_outlined, Colors.orange),
      EntityType.loan => (Icons.credit_score_outlined, Colors.green),
    };
  }

  void _navigate(BuildContext context) {
    final route = switch (type) {
      EntityType.client => '/field/clients/$id',
      EntityType.product => '/loans/products',
      EntityType.application => '/origination/applications/$id',
      EntityType.loan => '/loans/$id',
      EntityType.agent => '/field/agents',
    };
    context.go(route);
  }
}
