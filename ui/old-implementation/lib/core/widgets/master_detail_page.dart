import 'package:flutter/material.dart';

import '../responsive/breakpoints.dart';

/// A responsive master-detail layout.
///
/// On desktop (>= 1200px): shows the [master] list on the left and the
/// [detail] panel on the right side-by-side. Selecting an item in the list
/// updates the detail panel without navigating away.
///
/// On mobile/tablet (< 1200px): shows only the [master] list. Item
/// selection triggers [onNavigateToDetail] which should do a full-page
/// navigation via `context.go(...)`.
///
/// Usage:
/// ```dart
/// MasterDetailPage<LoanAccountObject>(
///   master: EntityListPage(..., onItemSelected: _select),
///   detailBuilder: (id) => LoanAccountDetailScreen(loanId: id),
///   selectedId: _selectedId,
///   onNavigateToDetail: (id) => context.go('/loans/$id'),
///   emptyDetailMessage: 'Select a loan to view details',
/// )
/// ```
class MasterDetailPage extends StatelessWidget {
  const MasterDetailPage({
    super.key,
    required this.master,
    this.detailBuilder,
    this.selectedId,
    this.onNavigateToDetail,
    this.emptyDetailMessage = 'Select an item to view details',
    this.masterFlex = 2,
    this.detailFlex = 3,
  });

  /// The list/table widget shown on the left (or full-screen on mobile).
  final Widget master;

  /// Builds the detail panel for the selected item ID.
  /// Called only on desktop when [selectedId] is non-null.
  final Widget Function(String id)? detailBuilder;

  /// The currently selected item ID. Null means no selection.
  final String? selectedId;

  /// Called on mobile/tablet when an item is selected — should navigate
  /// to the detail page. Not called on desktop (detail shows inline).
  final void Function(String id)? onNavigateToDetail;

  /// Message shown in the detail panel when no item is selected.
  final String emptyDetailMessage;

  /// Flex ratio for the master panel.
  final int masterFlex;

  /// Flex ratio for the detail panel.
  final int detailFlex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (AppBreakpoints.isDesktop(constraints.maxWidth) &&
            detailBuilder != null) {
          return _DesktopLayout(
            master: master,
            detailBuilder: detailBuilder!,
            selectedId: selectedId,
            emptyDetailMessage: emptyDetailMessage,
            masterFlex: masterFlex,
            detailFlex: detailFlex,
          );
        }
        // Mobile/tablet: just show the master list.
        return master;
      },
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.master,
    required this.detailBuilder,
    required this.selectedId,
    required this.emptyDetailMessage,
    required this.masterFlex,
    required this.detailFlex,
  });

  final Widget master;
  final Widget Function(String id) detailBuilder;
  final String? selectedId;
  final String emptyDetailMessage;
  final int masterFlex;
  final int detailFlex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Master panel (list)
        Expanded(
          flex: masterFlex,
          child: master,
        ),

        // Divider
        VerticalDivider(
          width: 1,
          color: theme.colorScheme.outlineVariant.withAlpha(60),
        ),

        // Detail panel
        Expanded(
          flex: detailFlex,
          child: selectedId != null
              ? detailBuilder(selectedId!)
              : _EmptyDetail(message: emptyDetailMessage),
        ),
      ],
    );
  }
}

class _EmptyDetail extends StatelessWidget {
  const _EmptyDetail({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.touch_app_outlined,
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
