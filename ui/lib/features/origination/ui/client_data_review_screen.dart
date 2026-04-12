import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/profile_badge.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../auth/data/auth_repository.dart';
import '../../field/data/client_data_providers.dart';

/// Per-field verification review screen for client data entries.
///
/// Displays all client data entries with status badges and reviewer actions
/// (verify, reject, request info). Intended to be embedded in the
/// application detail Forms tab.
class ClientDataReviewScreen extends ConsumerWidget {
  const ClientDataReviewScreen({
    super.key,
    required this.clientId,
    this.applicationId,
  });

  final String clientId;
  final String? applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync =
        ref.watch(clientDataListProvider(clientId: clientId));

    return entriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading client data: $e')),
      data: (entries) {
        if (entries.isEmpty) {
          return Center(
            child: Text(
              'No client data entries found',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withAlpha(140),
                  ),
            ),
          );
        }
        return _ClientDataReviewBody(
          entries: entries,
          clientId: clientId,
        );
      },
    );
  }
}

class _ClientDataReviewBody extends ConsumerWidget {
  const _ClientDataReviewBody({
    required this.entries,
    required this.clientId,
  });

  final List<ClientDataEntryObject> entries;
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final verified = entries
        .where((e) =>
            e.verificationStatus ==
            DataVerificationStatus.DATA_VERIFICATION_STATUS_VERIFIED)
        .length;
    final rejected = entries
        .where((e) =>
            e.verificationStatus ==
            DataVerificationStatus.DATA_VERIFICATION_STATUS_REJECTED)
        .length;
    final pending = entries.length - verified - rejected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Summary bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              Text(
                '${entries.length} entries',
                style: theme.textTheme.labelLarge,
              ),
              _SummaryChip(
                label: '$verified verified',
                color: Colors.green,
              ),
              _SummaryChip(
                label: '$pending pending',
                color: Colors.blue,
              ),
              _SummaryChip(
                label: '$rejected rejected',
                color: Colors.red,
              ),
            ],
          ),
        ),

        // Bulk verify button
        if (pending > 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: _VerifyAllButton(
                entries: entries,
                clientId: clientId,
              ),
            ),
          ),

        // Entry cards
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            itemCount: entries.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) => _ClientDataEntryCard(
              entry: entries[i],
              clientId: clientId,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Summary chip
// ---------------------------------------------------------------------------

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Verify All button
// ---------------------------------------------------------------------------

class _VerifyAllButton extends ConsumerStatefulWidget {
  const _VerifyAllButton({
    required this.entries,
    required this.clientId,
  });

  final List<ClientDataEntryObject> entries;
  final String clientId;

  @override
  ConsumerState<_VerifyAllButton> createState() => _VerifyAllButtonState();
}

class _VerifyAllButtonState extends ConsumerState<_VerifyAllButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: _loading ? null : _verifyAll,
      icon: _loading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.done_all, size: 18),
      label: const Text('Verify All Pending'),
    );
  }

  Future<void> _verifyAll() async {
    final profileId = ref.read(currentProfileIdProvider).value ?? '';
    if (profileId.isEmpty) return;

    setState(() => _loading = true);
    try {
      final notifier = ref.read(clientDataProvider.notifier);
      final pendingEntries = widget.entries.where((e) =>
          e.verificationStatus !=
              DataVerificationStatus.DATA_VERIFICATION_STATUS_VERIFIED &&
          e.verificationStatus !=
              DataVerificationStatus.DATA_VERIFICATION_STATUS_REJECTED);

      for (final entry in pendingEntries) {
        await notifier.verify(entry.id, profileId);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All pending entries verified'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

// ---------------------------------------------------------------------------
// Entry card
// ---------------------------------------------------------------------------

class _ClientDataEntryCard extends ConsumerWidget {
  const _ClientDataEntryCard({
    required this.entry,
    required this.clientId,
  });

  final ClientDataEntryObject entry;
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final status = entry.verificationStatus;
    final borderColor = _borderColorForStatus(status);
    final isVerified = status ==
        DataVerificationStatus.DATA_VERIFICATION_STATUS_VERIFIED;
    final isPhoto = entry.valueType == 'photo' || entry.valueType == 'signature';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: borderColor, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: field key + status badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    entry.fieldKey,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _StatusBadge(status: status),
              ],
            ),
            const SizedBox(height: 8),

            // Value display
            if (isPhoto)
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.image_outlined, size: 28),
                ),
              )
            else
              Text(
                entry.value.isNotEmpty ? entry.value : '(empty)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: entry.value.isEmpty
                      ? theme.colorScheme.onSurface.withAlpha(100)
                      : null,
                ),
              ),

            // Reviewer comment (for rejected / more-info)
            if (entry.reviewerComment.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer.withAlpha(40),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.comment_outlined,
                        size: 16, color: theme.colorScheme.error),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        entry.reviewerComment,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Reviewer profile avatar
            if (entry.reviewerId.isNotEmpty) ...[
              const SizedBox(height: 8),
              ProfileAvatar(
                profileId: entry.reviewerId,
                name: entry.reviewerId.substring(
                    0, entry.reviewerId.length.clamp(0, 8)),
                description: 'Reviewer',
                size: 24,
              ),
            ],

            // Action buttons (non-verified only)
            if (!isVerified) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _VerifyButton(entryId: entry.id),
                  const SizedBox(width: 8),
                  _RejectButton(entryId: entry.id),
                  const SizedBox(width: 8),
                  _RequestInfoButton(entryId: entry.id),
                ],
              ),
            ],

            // Expandable history
            _HistoryExpansion(entryId: entry.id),
          ],
        ),
      ),
    );
  }

  Color _borderColorForStatus(DataVerificationStatus status) {
    switch (status) {
      case DataVerificationStatus.DATA_VERIFICATION_STATUS_VERIFIED:
        return Colors.green;
      case DataVerificationStatus.DATA_VERIFICATION_STATUS_REJECTED:
        return Colors.red;
      case DataVerificationStatus.DATA_VERIFICATION_STATUS_MORE_INFO_NEEDED:
        return Colors.orange;
      case DataVerificationStatus.DATA_VERIFICATION_STATUS_UNDER_REVIEW:
        return Colors.blue;
      case DataVerificationStatus.DATA_VERIFICATION_STATUS_COLLECTED:
        return Colors.grey;
      case DataVerificationStatus.DATA_VERIFICATION_STATUS_EXPIRED:
        return Colors.brown;
      default:
        return Colors.grey.shade300;
    }
  }
}

// ---------------------------------------------------------------------------
// Status badge
// ---------------------------------------------------------------------------

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final DataVerificationStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = _labelAndColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  (String, Color) get _labelAndColor {
    switch (status) {
      case DataVerificationStatus.DATA_VERIFICATION_STATUS_VERIFIED:
        return ('Verified', Colors.green);
      case DataVerificationStatus.DATA_VERIFICATION_STATUS_REJECTED:
        return ('Rejected', Colors.red);
      case DataVerificationStatus.DATA_VERIFICATION_STATUS_MORE_INFO_NEEDED:
        return ('More Info Needed', Colors.orange);
      case DataVerificationStatus.DATA_VERIFICATION_STATUS_UNDER_REVIEW:
        return ('Under Review', Colors.blue);
      case DataVerificationStatus.DATA_VERIFICATION_STATUS_COLLECTED:
        return ('Collected', Colors.grey);
      case DataVerificationStatus.DATA_VERIFICATION_STATUS_EXPIRED:
        return ('Expired', Colors.brown);
      default:
        return ('Unknown', Colors.grey);
    }
  }
}

// ---------------------------------------------------------------------------
// Action buttons
// ---------------------------------------------------------------------------

class _VerifyButton extends ConsumerWidget {
  const _VerifyButton({required this.entryId});
  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.tonalIcon(
      onPressed: () async {
        final profileId = ref.read(currentProfileIdProvider).value ?? '';
        if (profileId.isEmpty) return;
        try {
          await ref
              .read(clientDataProvider.notifier)
              .verify(entryId, profileId);
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Verify failed: $e')),
            );
          }
        }
      },
      icon: const Icon(Icons.check, size: 16),
      label: const Text('Verify'),
    );
  }
}

class _RejectButton extends ConsumerWidget {
  const _RejectButton({required this.entryId});
  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
      ),
      onPressed: () => _showRejectDialog(context, ref),
      icon: const Icon(Icons.close, size: 16),
      label: const Text('Reject'),
    );
  }

  Future<void> _showRejectDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Entry'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Reason for rejection',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (reason == null || reason.trim().isEmpty) return;

    final profileId = ref.read(currentProfileIdProvider).value ?? '';
    if (profileId.isEmpty) return;
    try {
      await ref
          .read(clientDataProvider.notifier)
          .reject(entryId, profileId, reason.trim());
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reject failed: $e')),
        );
      }
    }
  }
}

class _RequestInfoButton extends ConsumerWidget {
  const _RequestInfoButton({required this.entryId});
  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.orange,
        side: const BorderSide(color: Colors.orange),
      ),
      onPressed: () => _showRequestInfoDialog(context, ref),
      icon: const Icon(Icons.help_outline, size: 16),
      label: const Text('Request Info'),
    );
  }

  Future<void> _showRequestInfoDialog(
      BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final comment = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Request More Information'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'What information is needed?',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            child: const Text('Send'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (comment == null || comment.trim().isEmpty) return;

    final profileId = ref.read(currentProfileIdProvider).value ?? '';
    if (profileId.isEmpty) return;
    try {
      await ref
          .read(clientDataProvider.notifier)
          .requestInfo(entryId, profileId, comment.trim());
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request info failed: $e')),
        );
      }
    }
  }
}

// ---------------------------------------------------------------------------
// History expansion
// ---------------------------------------------------------------------------

class _HistoryExpansion extends ConsumerWidget {
  const _HistoryExpansion({required this.entryId});

  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 4),
      title: Text('History', style: theme.textTheme.labelMedium),
      children: [
        Consumer(
          builder: (context, ref, _) {
            final histAsync = ref.watch(
                clientDataHistoryProvider(entryId: entryId));
            return histAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Error: $e',
                    style: theme.textTheme.bodySmall),
              ),
              data: (history) {
                if (history.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text('No history yet',
                        style: theme.textTheme.bodySmall),
                  );
                }
                return Column(
                  children: history.map((h) => _HistoryRow(entry: h)).toList(),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});

  final ClientDataEntryHistoryObject entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 5, right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withAlpha(150),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.action} (rev ${entry.revision})',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (entry.comment.isNotEmpty)
                  Text(entry.comment, style: theme.textTheme.bodySmall),
                if (entry.createdAt.isNotEmpty)
                  Text(
                    entry.createdAt,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(100),
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
