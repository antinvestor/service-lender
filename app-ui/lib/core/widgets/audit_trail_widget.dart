import 'package:flutter/material.dart';

/// Displays a single audit trail entry with who, what, when, why.
class AuditTrailEntry extends StatelessWidget {
  const AuditTrailEntry({
    super.key,
    required this.action,
    required this.timestamp,
    this.performedBy,
    this.reason,
    this.details,
    this.icon,
    this.color,
  });

  final String action;      // "Approved", "Rejected", "Verified", etc.
  final String timestamp;   // RFC3339 or display date
  final String? performedBy; // who did it
  final String? reason;     // why
  final Map<String, String>? details; // additional context
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: (color ?? theme.colorScheme.primary).withValues(alpha: 0.1),
              child: Icon(icon ?? Icons.history, size: 18, color: color ?? theme.colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(action, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(timestamp, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  if (performedBy != null && performedBy!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 14, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Expanded(child: Text('By: $performedBy', style: theme.textTheme.bodySmall)),
                      ],
                    ),
                  ],
                  if (reason != null && reason!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.notes_outlined, size: 14, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Expanded(child: Text('Reason: $reason', style: theme.textTheme.bodySmall)),
                      ],
                    ),
                  ],
                  if (details != null && details!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    ...details!.entries.map((e) => Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text('${e.key}: ${e.value}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays a list of audit trail entries with a header.
class AuditTrailList extends StatelessWidget {
  const AuditTrailList({
    super.key,
    required this.entries,
    this.title = 'Activity History',
  });

  final List<AuditTrailEntry> entries;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('No activity recorded yet', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      itemBuilder: (context, index) => entries[index],
    );
  }
}
