import 'package:flutter/material.dart';

import '../responsive/breakpoints.dart';

/// Reusable entity list page with search, actions, pagination, and
/// automatic master-detail layout on desktop.
///
/// To enable master-detail, provide [detailBuilder] and [idOf]:
/// ```dart
/// EntityListPage<LoanAccountObject>(
///   // ... existing props ...
///   idOf: (loan) => loan.id,
///   detailBuilder: (id) => LoanAccountDetailScreen(loanId: id),
///   onNavigate: (id) => context.go('/loans/$id'),
/// )
/// ```
///
/// On desktop (≥1200px): list on left, detail on right. Selection is
/// managed internally — no state in the calling screen.
///
/// On mobile (<1200px): tapping an item calls [onNavigate] for full-page
/// navigation. If [onNavigate] is null, nothing happens.
class EntityListPage<T> extends StatefulWidget {
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
    this.idOf,
    this.detailBuilder,
    this.onNavigate,
    this.emptyDetailMessage = 'Select an item to view details',
  });

  final String title;
  final IconData icon;
  final List<T> items;

  /// Builds a list tile/card for each item. The item's tap behavior is
  /// handled internally — do NOT add `onTap` navigation in the builder.
  /// If you need custom card content, wrap it in a plain widget; tapping
  /// is wired by EntityListPage.
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

  /// Extracts a unique ID from an item. Required for master-detail.
  final String Function(T item)? idOf;

  /// Builds the detail panel for a given item ID. When provided and on
  /// desktop, the page renders as master-detail automatically.
  final Widget Function(String id)? detailBuilder;

  /// Called on mobile when an item is tapped — should navigate to the
  /// detail page (e.g. `context.go('/loans/$id')`).
  final void Function(String id)? onNavigate;

  /// Message shown in the empty detail area before anything is selected.
  final String emptyDetailMessage;

  @override
  State<EntityListPage<T>> createState() => _EntityListPageState<T>();
}

class _EntityListPageState<T> extends State<EntityListPage<T>> {
  String? _selectedId;

  void _onItemTap(T item) {
    final id = widget.idOf?.call(item);
    if (id == null) return;

    final width = MediaQuery.of(context).size.width;
    if (AppBreakpoints.isDesktop(width) && widget.detailBuilder != null) {
      setState(() => _selectedId = id);
    } else {
      widget.onNavigate?.call(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showDetail = AppBreakpoints.isDesktop(constraints.maxWidth) &&
            widget.detailBuilder != null;

        final listPanel = _ListPanel<T>(
          title: widget.title,
          icon: widget.icon,
          items: widget.items,
          itemBuilder: widget.itemBuilder,
          isLoading: widget.isLoading,
          error: widget.error,
          onRetry: widget.onRetry,
          searchHint: widget.searchHint,
          onSearchChanged: widget.onSearchChanged,
          actionLabel: widget.actionLabel,
          onAction: widget.onAction,
          canAction: widget.canAction,
          filterWidget: widget.filterWidget,
          hasMore: widget.hasMore,
          isLoadingMore: widget.isLoadingMore,
          onLoadMore: widget.onLoadMore,
          totalHint: widget.totalHint,
          idOf: widget.idOf,
          selectedId: _selectedId,
          onItemTap: _onItemTap,
          compact: showDetail,
        );

        if (!showDetail) return listPanel;

        final theme = Theme.of(context);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: constraints.maxWidth * 0.38,
              child: listPanel,
            ),
            VerticalDivider(
              width: 1,
              color: theme.colorScheme.outlineVariant.withAlpha(60),
            ),
            Expanded(
              child: _selectedId != null
                  ? widget.detailBuilder!(_selectedId!)
                  : _EmptyDetail(
                      message: widget.emptyDetailMessage,
                      icon: widget.icon,
                    ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// List panel (full-screen on mobile, left panel on desktop)
// ---------------------------------------------------------------------------

class _ListPanel<T> extends StatelessWidget {
  const _ListPanel({
    required this.title,
    required this.icon,
    required this.items,
    required this.itemBuilder,
    required this.isLoading,
    required this.onItemTap,
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
    this.idOf,
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
  final String Function(T)? idOf;
  final String? selectedId;
  final void Function(T item) onItemTap;
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
            final item = items[index];
            final id = idOf?.call(item);
            final isSelected = id != null && id == selectedId;

            return _SelectableItemWrapper(
              isSelected: isSelected,
              onTap: () => onItemTap(item),
              child: itemBuilder(context, item),
            );
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
// Selection wrapper — adds highlight and tap handler around any item widget
// ---------------------------------------------------------------------------

class _SelectableItemWrapper extends StatelessWidget {
  const _SelectableItemWrapper({
    required this.isSelected,
    required this.onTap,
    required this.child,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                color: theme.colorScheme.primaryContainer.withAlpha(40),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.primary.withAlpha(120),
                  width: 1.5,
                ),
              )
            : null,
        child: child,
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
