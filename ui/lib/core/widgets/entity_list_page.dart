import 'package:flutter/material.dart';

import '../responsive/breakpoints.dart';

/// Reusable entity list page with search bar, action button, item count,
/// paginated item list, and optional master-detail layout.
///
/// On desktop, when [detailBuilder] is provided, the list appears on the left
/// and the detail panel on the right. Selecting an item calls [onItemSelected]
/// to update the detail. On mobile, [onItemSelected] should navigate to a
/// full-screen detail page.
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
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.totalHint,
    this.selectedId,
    this.detailBuilder,
    this.emptyDetailMessage = 'Select an item to view details',
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
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  final String? totalHint;

  /// The ID of the currently selected item. Used to highlight the active
  /// row and drive the detail panel.
  final String? selectedId;

  /// Builds the detail panel for the given item ID. When non-null and on
  /// desktop, the list shows in a left panel and the detail on the right.
  final Widget Function(String id)? detailBuilder;

  /// Message shown in the detail area when no item is selected.
  final String emptyDetailMessage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showDetail = AppBreakpoints.isDesktop(constraints.maxWidth) &&
            detailBuilder != null;

        final listPanel = _ListPanel(
          title: title,
          icon: icon,
          items: items,
          itemBuilder: itemBuilder,
          isLoading: isLoading,
          error: error,
          onRetry: onRetry,
          searchHint: searchHint,
          onSearchChanged: onSearchChanged,
          actionLabel: actionLabel,
          onAction: onAction,
          canAction: canAction,
          filterWidget: filterWidget,
          hasMore: hasMore,
          isLoadingMore: isLoadingMore,
          onLoadMore: onLoadMore,
          totalHint: totalHint,
          selectedId: selectedId,
          compact: showDetail,
        );

        if (!showDetail) return listPanel;

        final theme = Theme.of(context);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Master: list panel
            SizedBox(
              width: constraints.maxWidth * 0.38,
              child: listPanel,
            ),
            VerticalDivider(
              width: 1,
              color: theme.colorScheme.outlineVariant.withAlpha(60),
            ),
            // Detail panel
            Expanded(
              child: selectedId != null
                  ? detailBuilder!(selectedId!)
                  : _EmptyDetail(
                      message: emptyDetailMessage,
                      icon: icon,
                    ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// List panel (used standalone on mobile, or as left panel on desktop)
// ---------------------------------------------------------------------------

class _ListPanel<T> extends StatelessWidget {
  const _ListPanel({
    required this.title,
    required this.icon,
    required this.items,
    required this.itemBuilder,
    required this.isLoading,
    this.error,
    this.onRetry,
    this.searchHint,
    this.onSearchChanged,
    this.actionLabel,
    this.onAction,
    this.canAction = true,
    this.filterWidget,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.totalHint,
    this.selectedId,
    this.compact = false,
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
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  final String? totalHint;
  final String? selectedId;

  /// When true, reduces padding and hides the icon for the compact
  /// master panel in master-detail mode.
  final bool compact;

  double get _hPad => compact ? 16 : 24;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.fromLTRB(_hPad, compact ? 16 : 24, _hPad, 0),
          child: Row(
            children: [
              if (!compact) ...[
                Icon(icon, size: 28, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: (compact
                              ? theme.textTheme.titleMedium
                              : theme.textTheme.headlineSmall)
                          ?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (items.isNotEmpty)
                      Text(
                        totalHint ??
                            '${items.length} items${hasMore ? '+' : ''}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (actionLabel != null && canAction)
                compact
                    ? IconButton(
                        onPressed: onAction,
                        icon: const Icon(Icons.add),
                        tooltip: actionLabel,
                      )
                    : FilledButton.icon(
                        onPressed: onAction,
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(actionLabel!),
                      ),
            ],
          ),
        ),

        // Search + filters
        Padding(
          padding: EdgeInsets.fromLTRB(_hPad, 16, _hPad, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: searchHint ?? 'Search...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                  ),
                ),
              ),
              if (filterWidget != null && !compact) ...[
                const SizedBox(width: 12),
                filterWidget!,
              ],
            ],
          ),
        ),

        // Content
        Expanded(child: _buildContent(context, theme)),
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
                color: theme.colorScheme.surfaceContainerLow,
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
                color: theme.colorScheme.onSurfaceVariant,
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

    final itemCount = items.length + (hasMore ? 1 : 0);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            hasMore &&
            !isLoadingMore &&
            onLoadMore != null) {
          final metrics = notification.metrics;
          if (metrics.pixels >= metrics.maxScrollExtent - 200) {
            onLoadMore!();
          }
        }
        return false;
      },
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: _hPad, vertical: 8),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index < items.length) {
            return itemBuilder(context, items[index]);
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: isLoadingMore
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : TextButton(
                      onPressed: onLoadMore,
                      child: const Text('Load More'),
                    ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty detail panel
// ---------------------------------------------------------------------------

class _EmptyDetail extends StatelessWidget {
  const _EmptyDetail({required this.message, required this.icon});
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withAlpha(80),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(140),
            ),
          ),
        ],
      ),
    );
  }
}
