import 'package:flutter/material.dart';
import '../../sdk/src/google/protobuf/struct.pb.dart' as struct_pb;
import 'profile_badge.dart';

class ApprovalCasePanel extends StatelessWidget {
  const ApprovalCasePanel({
    super.key,
    required this.properties,
    this.title = 'Approval Case',
    this.onVerify,
    this.onApprove,
    this.onReject,
  });

  final Map<String, struct_pb.Value>? properties;
  final String title;
  final VoidCallback? onVerify;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  bool get hasCase =>
      _string('approval_case_status').isNotEmpty ||
      _string('approval_case_id').isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (!hasCase) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final status = _string('approval_case_status');
    final summary = _string('approval_case_summary');
    final requestedValue = _string('approval_case_requested_value');

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _iconForStatus(status),
                  size: 20,
                  color: _colorForStatus(theme, status),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _StatusChip(status: status),
              ],
            ),
            if (summary.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                summary,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (requestedValue.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'Requested value: $requestedValue',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _ActorPill(
                  label: 'Requested',
                  actorId: _string('approval_case_requested_by'),
                  timestamp: _string('approval_case_requested_at'),
                ),
                if (_string('approval_case_verified_by').isNotEmpty)
                  _ActorPill(
                    label: 'Verified',
                    actorId: _string('approval_case_verified_by'),
                    timestamp: _string('approval_case_verified_at'),
                  ),
                if (_string('approval_case_approved_by').isNotEmpty)
                  _ActorPill(
                    label: 'Approved',
                    actorId: _string('approval_case_approved_by'),
                    timestamp: _string('approval_case_approved_at'),
                  ),
                if (_string('approval_case_rejected_by').isNotEmpty)
                  _ActorPill(
                    label: 'Rejected',
                    actorId: _string('approval_case_rejected_by'),
                    timestamp: _string('approval_case_rejected_at'),
                  ),
              ],
            ),
            if (_string('approval_case_comment').isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _string('approval_case_comment'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (_showActions(status)) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (status == 'pending_verification' && onVerify != null)
                    OutlinedButton.icon(
                      onPressed: onVerify,
                      icon: const Icon(Icons.verified_user_outlined, size: 18),
                      label: const Text('Verify'),
                    ),
                  if (status == 'pending_approval' && onApprove != null)
                    FilledButton.icon(
                      onPressed: onApprove,
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('Approve'),
                    ),
                  if ((status == 'pending_verification' ||
                          status == 'pending_approval') &&
                      onReject != null)
                    TextButton.icon(
                      onPressed: onReject,
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: const Text('Reject'),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _showActions(String status) =>
      (status == 'pending_verification' && onVerify != null) ||
      (status == 'pending_approval' && onApprove != null) ||
      ((status == 'pending_verification' || status == 'pending_approval') &&
          onReject != null);

  String _string(String key) {
    final value = properties?[key];
    if (value == null) return '';
    if (value.hasStringValue()) return value.stringValue;
    if (value.hasNumberValue()) return value.numberValue.toString();
    if (value.hasBoolValue()) return value.boolValue.toString();
    return '';
  }

  IconData _iconForStatus(String status) => switch (status) {
    'pending_verification' => Icons.fact_check_outlined,
    'pending_approval' => Icons.gavel_outlined,
    'approved' => Icons.task_alt_outlined,
    'rejected' => Icons.highlight_off_outlined,
    _ => Icons.assignment_outlined,
  };

  Color _colorForStatus(ThemeData theme, String status) => switch (status) {
    'pending_verification' => theme.colorScheme.tertiary,
    'pending_approval' => theme.colorScheme.primary,
    'approved' => Colors.green.shade700,
    'rejected' => theme.colorScheme.error,
    _ => theme.colorScheme.primary,
  };
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (status) {
      'pending_verification' => theme.colorScheme.tertiary,
      'pending_approval' => theme.colorScheme.primary,
      'approved' => Colors.green.shade700,
      'rejected' => theme.colorScheme.error,
      _ => theme.colorScheme.outline,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(24),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(96)),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: theme.textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ActorPill extends StatelessWidget {
  const _ActorPill({
    required this.label,
    required this.actorId,
    required this.timestamp,
  });

  final String label;
  final String actorId;
  final String timestamp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(90),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileAvatar(profileId: actorId, name: actorId, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                actorId,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (timestamp.isNotEmpty)
                Text(
                  timestamp,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
