import 'package:flutter/material.dart';

/// Reusable entity list page with search bar, action button, and item list.
class EntityListPage<T> extends StatelessWidget {
  const EntityListPage({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
    required this.itemBuilder,
    this.isLoading = false,
    this.error,
    this.onRetry,
    this.searchHint,
    this.onSearchChanged,
    this.actionLabel,
    this.onAction,
    this.canAction = true,
    this.filterWidget,
  });

  final String title;
  final IconData icon;
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final bool isLoading;
  final String? error;
  final VoidCallback? onRetry;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool canAction;
  final Widget? filterWidget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            children: [
              Icon(icon, size: 28, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              if (actionLabel != null && canAction)
                FilledButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(actionLabel!),
                ),
            ],
          ),
        ),

        // Search + filters
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: searchHint ?? 'Search...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              if (filterWidget != null) ...[
                const SizedBox(width: 12),
                filterWidget!,
              ],
            ],
          ),
        ),

        // Content
        Expanded(
          child: _buildContent(context, theme),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(error!, style: theme.textTheme.bodyLarge),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      );
    }

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withAlpha(60),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 28,
                color: theme.colorScheme.primary.withAlpha(160),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No $title found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(140),
              ),
            ),
            if (actionLabel != null && canAction) ...[
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add, size: 18),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 2),
      itemBuilder: (context, index) => itemBuilder(context, items[index]),
    );
  }
}
