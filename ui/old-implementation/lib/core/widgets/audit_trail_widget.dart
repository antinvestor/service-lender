import 'package:flutter/material.dart';

import 'profile_badge.dart';

/// Displays a single audit trail entry with who, what, when, why, and where.
///
/// Features:
/// - Actor profile badge (avatar + name) when [actorName] is provided
/// - Action description with state transition support
/// - Timestamp display
/// - Location (city, country) and GPS coordinates
/// - Reason/notes
/// - Extra detail chips (entity type, IDs, custom metadata)
class AuditTrailEntry extends StatelessWidget {
  const AuditTrailEntry({
    super.key,
    required this.action,
    required this.timestamp,
    this.performedBy,
    this.actorName,
    this.reason,
    this.location,
    this.coordinates,
    this.details,
    this.fromState,
    this.toState,
    this.icon,
    this.color,
  });

  final String action;
  final String timestamp;
  final String? performedBy; // profile ID of who did it
  final String? actorName; // display name of the actor
  final String? reason;
  final String? location; // "Nairobi, Kenya"
  final String? coordinates; // lat,long
  final Map<String, String>? details;
  final String? fromState; // for state transitions
  final String? toState;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = color ?? theme.colorScheme.primary;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withAlpha(38),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: icon or actor avatar
            if (performedBy != null && performedBy!.isNotEmpty)
              ProfileAvatar(
                profileId: performedBy!,
                name: actorName ?? performedBy!,
                size: 36,
              )
            else
              CircleAvatar(
                radius: 18,
                backgroundColor: badgeColor.withAlpha(26),
                child: Icon(
                  icon ?? Icons.history,
                  size: 18,
                  color: badgeColor,
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Action + state transition
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          action,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // State transition badges
                  if (fromState != null || toState != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (fromState != null && fromState!.isNotEmpty)
                          _StatePill(
                            label: fromState!,
                            color: theme.colorScheme.error,
                            theme: theme,
                          ),
                        if (fromState != null &&
                            fromState!.isNotEmpty &&
                            toState != null &&
                            toState!.isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        if (toState != null && toState!.isNotEmpty)
                          _StatePill(
                            label: toState!,
                            color: theme.colorScheme.tertiary,
                            theme: theme,
                          ),
                      ],
                    ),
                  ],

                  // Timestamp
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        timestamp,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  // Who (name with profile badge)
                  if (actorName != null && actorName!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            actorName!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else if (performedBy != null &&
                      performedBy!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'By: ${performedBy!}',
                            style: theme.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Where
                  if (location != null && location!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _iconRow(Icons.location_on_outlined, location!, theme),
                  ],
                  if (coordinates != null && coordinates!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    _iconRow(
                      Icons.gps_fixed,
                      coordinates!,
                      theme,
                      color: theme.colorScheme.onSurfaceVariant
                          .withAlpha(153),
                    ),
                  ],

                  // Why
                  if (reason != null && reason!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withAlpha(100),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.format_quote,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              reason!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Extra details
                  if (details != null && details!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: details!.entries
                          .map(
                            (e) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${e.key}: ${e.value}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconRow(
    IconData iconData,
    String text,
    ThemeData theme, {
    Color? color,
  }) {
    return Row(
      children: [
        Icon(
          iconData,
          size: 14,
          color: color ?? theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class _StatePill extends StatelessWidget {
  const _StatePill({
    required this.label,
    required this.color,
    required this.theme,
  });

  final String label;
  final Color color;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
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
          child: Text(
            'No activity recorded yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
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
