import 'package:antinvestor_ui_core/widgets/money_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A pending disbursement item displayed in the queue.
///
/// The consuming application must populate this from its loan account data.
class DisbursementItem {
  const DisbursementItem({
    required this.id,
    required this.clientId,
    required this.principalAmount,
    this.currencyCode = '',
  });

  final String id;
  final String clientId;

  /// The principal amount as a proto Money object (or similar with `units`
  /// and `currencyCode` fields). Pass the raw proto object so that
  /// [formatMoney] can render it.
  final dynamic principalAmount;
  final String currencyCode;
}

/// Provider that the consuming application must override with a list of
/// pending disbursement items. By default it returns an empty list.
final disbursementQueueProvider =
    FutureProvider<List<DisbursementItem>>((ref) async => []);

/// Callback type for disbursement actions.
typedef DisbursementCallback = Future<void> Function(DisbursementItem item);

class DisbursementQueueScreen extends ConsumerStatefulWidget {
  const DisbursementQueueScreen({
    super.key,
    this.onDisburse,
    this.onViewDetails,
  });

  /// Called when the user confirms disbursement of an item.
  final DisbursementCallback? onDisburse;

  /// Called when the user taps "Details" on an item.
  final void Function(DisbursementItem item)? onViewDetails;

  @override
  ConsumerState<DisbursementQueueScreen> createState() =>
      _DisbursementQueueScreenState();
}

class _DisbursementQueueScreenState
    extends ConsumerState<DisbursementQueueScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final queueAsync = ref.watch(disbursementQueueProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            children: [
              Icon(
                Icons.send_outlined,
                size: 28,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Disbursement Queue',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: () => ref.invalidate(disbursementQueueProvider),
              ),
            ],
          ),
        ),

        // Summary
        queueAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (items) {
            if (items.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Card(
                color: theme.colorScheme.surfaceContainerLow,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _SummaryChip(
                        label: 'Pending',
                        value: '${items.length}',
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // List
        Expanded(
          child: queueAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text('Failed to load: $e'),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: () =>
                        ref.invalidate(disbursementQueueProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (items) {
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
                        child: const Icon(
                          Icons.check_circle_outline,
                          size: 28,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No pending disbursements',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.orange.withAlpha(20),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.payments_outlined,
                              color: Colors.orange,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatMoney(item.principalAmount),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Client: ${_shortId(item.clientId)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  'Loan: ${_shortId(item.id)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.onDisburse != null)
                                FilledButton.icon(
                                  onPressed: () => _showDisburseConfirmation(
                                    context,
                                    item,
                                  ),
                                  icon: const Icon(Icons.send, size: 16),
                                  label: const Text('Disburse'),
                                ),
                              if (widget.onViewDetails != null) ...[
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () =>
                                      widget.onViewDetails!(item),
                                  child: const Text('Details'),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDisburseConfirmation(
    BuildContext context,
    DisbursementItem item,
  ) {
    final amount = formatMoney(item.principalAmount);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Disbursement'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Are you sure you want to disburse this loan?'),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Amount: ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            amount,
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Client: ${item.clientId}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _executeDisbursement(context, item);
            },
            icon: const Icon(Icons.send, size: 18),
            label: const Text('Disburse'),
          ),
        ],
      ),
    );
  }

  Future<void> _executeDisbursement(
    BuildContext context,
    DisbursementItem item,
  ) async {
    try {
      await widget.onDisburse!(item);
      ref.invalidate(disbursementQueueProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Disbursement initiated successfully'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to disburse: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  String _shortId(String id) =>
      id.length > 12 ? '${id.substring(0, 12)}...' : id;
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
