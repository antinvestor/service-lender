import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/dynamic_form.dart' show structToMap;
import '../../../core/widgets/profile_badge.dart';
import '../../../sdk/src/origination/v1/origination.pb.dart';
import '../data/form_template_providers.dart';

/// Canonical ordering of form stages in the origination pipeline.
const _stageOrder = [
  'application',
  'verification',
  'underwriting',
  'disbursement',
];

/// A reusable timeline widget that shows all required forms for an application,
/// grouped by stage, with their completion status and expandable read-only data.
class FormSubmissionsTimeline extends ConsumerWidget {
  const FormSubmissionsTimeline({
    super.key,
    required this.applicationId,
    required this.requiredForms,
    this.isReadOnly = true,
    this.onFillForm,
  });

  final String applicationId;
  final List<ProductFormRequirement> requiredForms;
  final bool isReadOnly;

  /// Called when the agent taps "Fill Now" on a pending form (non-read-only).
  final void Function(ProductFormRequirement requirement)? onFillForm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submissionsAsync =
        ref.watch(formSubmissionListProvider(applicationId: applicationId));

    return submissionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading submissions: $e')),
      data: (submissions) {
        // Build a lookup map: templateId -> submission
        final submissionMap = <String, FormSubmissionObject>{};
        for (final sub in submissions) {
          submissionMap[sub.templateId] = sub;
        }

        // Group requirements by stage.
        final grouped = <String, List<ProductFormRequirement>>{};
        for (final req in requiredForms) {
          final stage = req.stage.toLowerCase();
          grouped.putIfAbsent(stage, () => []).add(req);
        }
        // Sort each group by order.
        for (final list in grouped.values) {
          list.sort((a, b) => a.order.compareTo(b.order));
        }

        // Build ordered stage list.
        final orderedStages = <String>[];
        for (final s in _stageOrder) {
          if (grouped.containsKey(s)) orderedStages.add(s);
        }
        // Add any stages not in the canonical list.
        for (final s in grouped.keys) {
          if (!orderedStages.contains(s)) orderedStages.add(s);
        }

        if (orderedStages.isEmpty) {
          return Center(
            child: Text(
              'No required forms configured for this product',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withAlpha(140),
                  ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orderedStages.length,
          itemBuilder: (context, i) {
            final stage = orderedStages[i];
            final reqs = grouped[stage]!;
            return _StageSection(
              stage: stage,
              requirements: reqs,
              submissionMap: submissionMap,
              isReadOnly: isReadOnly,
              isLast: i == orderedStages.length - 1,
              onFillForm: onFillForm,
            );
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Stage section
// ---------------------------------------------------------------------------

class _StageSection extends StatelessWidget {
  const _StageSection({
    required this.stage,
    required this.requirements,
    required this.submissionMap,
    required this.isReadOnly,
    required this.isLast,
    this.onFillForm,
  });

  final String stage;
  final List<ProductFormRequirement> requirements;
  final Map<String, FormSubmissionObject> submissionMap;
  final bool isReadOnly;
  final bool isLast;
  final void Function(ProductFormRequirement)? onFillForm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stageName = stage.toUpperCase();

    // Count completed in this stage.
    final completedCount = requirements
        .where((r) => submissionMap.containsKey(r.templateId))
        .length;
    final allDone = completedCount == requirements.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stage header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: allDone
                ? Colors.green.withAlpha(20)
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: allDone
                  ? Colors.green.withAlpha(80)
                  : theme.colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Icon(
                allDone ? Icons.check_circle : Icons.pending,
                size: 18,
                color: allDone ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(
                '$stageName STAGE',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: allDone
                      ? Colors.green.shade700
                      : theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                '$completedCount / ${requirements.length}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Timeline entries for this stage
        for (var j = 0; j < requirements.length; j++)
          _TimelineEntry(
            requirement: requirements[j],
            submission: submissionMap[requirements[j].templateId],
            isReadOnly: isReadOnly,
            isLastInStage: j == requirements.length - 1,
            onFillForm: onFillForm,
          ),

        if (!isLast) const SizedBox(height: 8),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Individual timeline entry
// ---------------------------------------------------------------------------

class _TimelineEntry extends ConsumerStatefulWidget {
  const _TimelineEntry({
    required this.requirement,
    required this.submission,
    required this.isReadOnly,
    required this.isLastInStage,
    this.onFillForm,
  });

  final ProductFormRequirement requirement;
  final FormSubmissionObject? submission;
  final bool isReadOnly;
  final bool isLastInStage;
  final void Function(ProductFormRequirement)? onFillForm;

  @override
  ConsumerState<_TimelineEntry> createState() => _TimelineEntryState();
}

class _TimelineEntryState extends ConsumerState<_TimelineEntry> {
  bool _expanded = false;

  bool get _isCompleted => widget.submission != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final templateAsync =
        ref.watch(formTemplateDetailProvider(widget.requirement.templateId));

    final templateName = templateAsync.when(
      data: (t) => t.name,
      loading: () => 'Loading...',
      error: (_, _) => widget.requirement.description.isNotEmpty
          ? widget.requirement.description
          : widget.requirement.templateId,
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline connector
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 8,
                  color: theme.colorScheme.outlineVariant,
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isCompleted
                        ? Colors.green
                        : widget.requirement.required
                            ? Colors.orange
                            : theme.colorScheme.surfaceContainerHighest,
                    border: _isCompleted
                        ? null
                        : Border.all(
                            color: theme.colorScheme.outlineVariant,
                            width: 1.5,
                          ),
                  ),
                  child: _isCompleted
                      ? const Icon(Icons.check,
                          size: 12, color: Colors.white)
                      : null,
                ),
                if (!widget.isLastInStage)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Card(
                elevation: 0,
                margin: const EdgeInsets.only(left: 4, right: 0, top: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: _isCompleted
                        ? Colors.green.withAlpha(80)
                        : theme.colorScheme.outlineVariant,
                  ),
                ),
                child: Column(
                  children: [
                    // Header row
                    InkWell(
                      onTap: _isCompleted
                          ? () => setState(() => _expanded = !_expanded)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    templateName,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  _StatusLabel(
                                    isCompleted: _isCompleted,
                                    isRequired: widget.requirement.required,
                                  ),
                                ],
                              ),
                            ),
                            if (_isCompleted &&
                                widget.submission!.submittedBy.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ProfileBadge(
                                  profileId: widget.submission!.submittedBy,
                                  name: 'Agent',
                                  description: 'Filled by',
                                  avatarSize: 24,
                                ),
                              ),
                            if (_isCompleted)
                              Icon(
                                _expanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                size: 20,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            if (!_isCompleted && !widget.isReadOnly)
                              FilledButton.tonal(
                                onPressed: () => widget.onFillForm
                                    ?.call(widget.requirement),
                                child: const Text('Fill Now'),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Expanded data viewer
                    if (_expanded && _isCompleted)
                      _FormDataViewer(
                        submission: widget.submission!,
                        templateAsync: templateAsync,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Status label
// ---------------------------------------------------------------------------

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.isCompleted, required this.isRequired});

  final bool isCompleted;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Text(
        'Completed',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.green.shade700,
              fontWeight: FontWeight.w500,
            ),
      );
    }
    if (isRequired) {
      return Text(
        'Pending',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.orange.shade700,
              fontWeight: FontWeight.w500,
            ),
      );
    }
    return Text(
      'Not Required',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}

// ---------------------------------------------------------------------------
// Read-only form data viewer
// ---------------------------------------------------------------------------

class _FormDataViewer extends StatelessWidget {
  const _FormDataViewer({
    required this.submission,
    required this.templateAsync,
  });

  final FormSubmissionObject submission;
  final AsyncValue<FormTemplateObject> templateAsync;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataMap = submission.hasData() ? structToMap(submission.data) : {};
    final fileRefMap =
        submission.hasFileRefs() ? structToMap(submission.fileRefs) : {};

    if (dataMap.isEmpty && fileRefMap.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Text(
          'No data submitted',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    // Try to get field definitions for better labels.
    final fieldDefs = templateAsync.when(
      data: (t) {
        final map = <String, FormFieldDefinition>{};
        for (final f in t.fields) {
          map[f.key] = f;
        }
        return map;
      },
      loading: () => <String, FormFieldDefinition>{},
      error: (_, _) => <String, FormFieldDefinition>{},
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Template version badge
          Row(
            children: [
              Text(
                templateAsync.when(
                  data: (t) => '${t.name} (v${submission.templateVersion})',
                  loading: () => 'Form v${submission.templateVersion}',
                  error: (_, _) => 'Form v${submission.templateVersion}',
                ),
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Divider(height: 16),

          // Data fields
          for (final entry in dataMap.entries)
            _buildFieldRow(context, entry.key, entry.value, fieldDefs, theme),

          // File references
          if (fileRefMap.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final entry in fileRefMap.entries)
              _buildFileRow(context, entry.key, entry.value, fieldDefs, theme),
          ],
        ],
      ),
    );
  }

  Widget _buildFieldRow(
    BuildContext context,
    String key,
    dynamic value,
    Map<String, FormFieldDefinition> fieldDefs,
    ThemeData theme,
  ) {
    final fieldDef = fieldDefs[key];
    final label = fieldDef?.label ?? _humanizeKey(key);
    final fieldType = fieldDef?.fieldType;

    // Handle photo/signature types - show as thumbnail indicator.
    if (fieldType == FormFieldType.FORM_FIELD_TYPE_PHOTO ||
        fieldType == FormFieldType.FORM_FIELD_TYPE_SIGNATURE) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 140,
              child: Text(
                '$label:',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: theme.colorScheme.surfaceContainerHighest,
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Icon(
                fieldType == FormFieldType.FORM_FIELD_TYPE_SIGNATURE
                    ? Icons.draw
                    : Icons.image,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              _formatValue(value, fieldType),
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileRow(
    BuildContext context,
    String key,
    dynamic value,
    Map<String, FormFieldDefinition> fieldDefs,
    ThemeData theme,
  ) {
    final fieldDef = fieldDefs[key];
    final label = fieldDef?.label ?? _humanizeKey(key);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(Icons.attach_file,
                    size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  value.toString(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatValue(dynamic value, FormFieldType? fieldType) {
    if (value == null) return '-';
    if (value is List) return value.join(', ');
    if (value is bool) return value ? 'Yes' : 'No';
    if (fieldType == FormFieldType.FORM_FIELD_TYPE_CURRENCY) {
      final num? n = num.tryParse(value.toString());
      if (n != null) return '\$ ${n.toStringAsFixed(2)}';
    }
    return value.toString();
  }

  static String _humanizeKey(String key) {
    return key
        .replaceAll('_', ' ')
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (m) => '${m.group(1)} ${m.group(2)}',
        )
        .split(' ')
        .map((w) =>
            w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }
}
