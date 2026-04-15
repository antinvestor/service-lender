import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/dynamic_form.dart' show mapToStruct;
import '../../sdk/src/identity/v1/identity.pb.dart';
import '../../sdk/src/loans/v1/loans.pb.dart';
import '../../features/auth/data/auth_repository.dart';
import '../data/form_template_providers.dart';
import 'dynamic_form_renderer.dart';

/// Generic multi-form wizard that walks a user through each required form.
///
/// Decoupled from loan origination — can be used for client onboarding,
/// group setup, stawi products, or any flow that has form requirements.
///
/// [entityId] is the owning entity (application ID, client ID, group ID, etc.)
/// used as the `entityId` in FormSubmissionObject.
class FormRequirementWizard extends ConsumerStatefulWidget {
  const FormRequirementWizard({
    super.key,
    required this.entityId,
    required this.requirements,
    required this.onAllCompleted,
    this.clientId,
    this.stage = 'application',
    this.submitLabel = 'Submit',
  });

  /// The entity this form data belongs to (application, client, group, etc.).
  final String entityId;

  /// Form requirements to present. Filtered by [stage] if non-empty.
  final List<ProductFormRequirement> requirements;

  /// Called when all required forms are completed and the user submits.
  final VoidCallback onAllCompleted;

  /// Optional client ID for client-data-aware rendering.
  final String? clientId;

  /// Stage filter applied to [requirements]. Empty string = no filter.
  final String stage;

  /// Label for the final submit button.
  final String submitLabel;

  @override
  ConsumerState<FormRequirementWizard> createState() =>
      _FormRequirementWizardState();
}

class _FormRequirementWizardState
    extends ConsumerState<FormRequirementWizard> {
  late List<ProductFormRequirement> _forms;

  int _currentStep = 0;
  final Set<String> _completedTemplateIds = {};
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _forms = widget.requirements
        .where((r) =>
            widget.stage.isEmpty ||
            r.stage.toLowerCase() == widget.stage.toLowerCase())
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  int get _totalSteps => _forms.length + 1; // +1 for Review

  bool get _isReviewStep => _currentStep == _forms.length;

  String _stepLabel(int index) {
    if (index < _forms.length) {
      final req = _forms[index];
      return req.description.isNotEmpty
          ? req.description
          : 'Form ${index + 1}';
    }
    return 'Review & Submit';
  }

  void _goToStep(int index) {
    if (index < 0 || index >= _totalSteps) return;
    if (index <= _currentStep ||
        _completedTemplateIds
            .contains(_forms[_currentStep].templateId)) {
      setState(() => _currentStep = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Step indicator chips
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _totalSteps,
              separatorBuilder: (_, _) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              itemBuilder: (context, i) {
                final isActive = i == _currentStep;
                final isCompleted = i < _forms.length &&
                    _completedTemplateIds
                        .contains(_forms[i].templateId);
                final isReview = i == _forms.length;

                return InkWell(
                  onTap: () => _goToStep(i),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? theme.colorScheme.primary
                          : isCompleted
                              ? Colors.green.withAlpha(30)
                              : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                      border: isCompleted
                          ? Border.all(color: Colors.green, width: 1.5)
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isCompleted) ...[
                          const Icon(Icons.check_circle,
                              size: 16, color: Colors.green),
                          const SizedBox(width: 4),
                        ],
                        if (isReview && !isActive)
                          Icon(Icons.rate_review,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant),
                        if (isReview && !isActive) const SizedBox(width: 4),
                        Text(
                          _stepLabel(i),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: isActive
                                ? theme.colorScheme.onPrimary
                                : isCompleted
                                    ? Colors.green.shade700
                                    : theme.colorScheme.onSurfaceVariant,
                            fontWeight:
                                isActive ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Progress summary
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              Text(
                '${_completedTemplateIds.length} of ${_forms.length} forms completed',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                'Step ${_currentStep + 1} of $_totalSteps',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        const Divider(height: 24),

        // Content
        Expanded(
          child: _isReviewStep ? _buildReviewStep() : _buildFormStep(),
        ),

        // Navigation bar
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                  color: theme.colorScheme.outlineVariant.withAlpha(60)),
            ),
          ),
          child: Row(
            children: [
              if (_currentStep > 0)
                OutlinedButton.icon(
                  onPressed: _submitting
                      ? null
                      : () => setState(() => _currentStep--),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Previous'),
                ),
              const Spacer(),
              if (!_isReviewStep)
                FilledButton.icon(
                  onPressed: _canAdvance() && !_submitting
                      ? () => setState(() => _currentStep++)
                      : null,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('Next Form'),
                )
              else
                FilledButton.icon(
                  onPressed: _allRequiredCompleted() && !_submitting
                      ? _submitAll
                      : null,
                  icon: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.send, size: 18),
                  label: Text(widget.submitLabel),
                ),
            ],
          ),
        ),
      ],
    );
  }

  bool _canAdvance() {
    if (_currentStep >= _forms.length) return false;
    final req = _forms[_currentStep];
    return _completedTemplateIds.contains(req.templateId);
  }

  bool _allRequiredCompleted() {
    for (final req in _forms) {
      if (req.required && !_completedTemplateIds.contains(req.templateId)) {
        return false;
      }
    }
    return true;
  }

  Future<void> _submitAll() async {
    setState(() => _submitting = true);
    try {
      widget.onAllCompleted();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  // ── Individual form step ──────────────────────────────────────────────────

  Widget _buildFormStep() {
    final req = _forms[_currentStep];
    final templateAsync = ref.watch(formTemplateDetailProvider(req.templateId));

    return templateAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error loading form template: $e'),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: () =>
                  ref.invalidate(formTemplateDetailProvider(req.templateId)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (template) {
        final isCompleted = _completedTemplateIds.contains(req.templateId);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (template.description.isNotEmpty)
                          Text(
                            template.description,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                      ],
                    ),
                  ),
                  if (isCompleted)
                    Chip(
                      avatar:
                          const Icon(Icons.check_circle, color: Colors.green),
                      label: const Text('Completed'),
                      backgroundColor: Colors.green.withAlpha(20),
                      side: BorderSide.none,
                    ),
                  if (req.required && !isCompleted)
                    Chip(
                      label: const Text('Required'),
                      backgroundColor: Colors.orange.withAlpha(20),
                      side: BorderSide.none,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // The form renderer — use client-data-aware if clientId given.
            Expanded(
              child: widget.clientId != null
                  ? ClientDataAwareFormRenderer(
                      key: ValueKey('form_${req.templateId}'),
                      template: template,
                      clientId: widget.clientId!,
                      readOnly: isCompleted,
                      onSubmit: (data, fileData) =>
                          _saveSubmission(req, template, data, fileData),
                    )
                  : DynamicFormRenderer(
                      key: ValueKey('form_${req.templateId}'),
                      template: template,
                      readOnly: isCompleted,
                      onSubmit: (data, fileData) =>
                          _saveSubmission(req, template, data, fileData),
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveSubmission(
    ProductFormRequirement req,
    FormTemplateObject template,
    Map<String, dynamic> data,
    Map<String, Uint8List> fileData,
  ) async {
    final profileId = ref.read(currentProfileIdProvider).value ?? '';
    final messenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;

    try {
      final submission = FormSubmissionObject(
        entityId: widget.entityId,
        templateId: req.templateId,
        templateVersion: template.version,
        submittedBy: profileId,
        data: mapToStruct(data),
      );

      if (fileData.isNotEmpty) {
        // Encode binary file data as base64 strings for storage.
        final fileRefMap = <String, dynamic>{};
        for (final entry in fileData.entries) {
          fileRefMap[entry.key] = base64Encode(entry.value);
        }
        submission.fileRefs = mapToStruct(fileRefMap);
      }

      await ref.read(formSubmissionProvider.notifier).save(submission);

      setState(() {
        _completedTemplateIds.add(req.templateId);
      });

      messenger.showSnackBar(
        SnackBar(content: Text('${template.name} saved successfully')),
      );

      // Auto-advance to next step
      if (_currentStep < _totalSteps - 1) {
        setState(() => _currentStep++);
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Failed to save form: $e'),
          backgroundColor: errorColor,
        ),
      );
    }
  }

  // ── Review step ───────────────────────────────────────────────────────────

  Widget _buildReviewStep() {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _forms.length,
      itemBuilder: (context, i) {
        final req = _forms[i];
        final isCompleted = _completedTemplateIds.contains(req.templateId);
        final templateAsync =
            ref.watch(formTemplateDetailProvider(req.templateId));

        final templateName = templateAsync.when(
          data: (t) => t.name,
          loading: () => 'Loading...',
          error: (_, _) => req.description.isNotEmpty
              ? req.description
              : 'Form ${i + 1}',
        );

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isCompleted ? Colors.green : theme.colorScheme.outline,
              width: isCompleted ? 1.5 : 1,
            ),
          ),
          child: ListTile(
            leading: Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? Colors.green : Colors.orange,
            ),
            title: Text(
              templateName,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              isCompleted
                  ? 'Completed'
                  : req.required
                      ? 'Required - Pending'
                      : 'Optional - Pending',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isCompleted ? Colors.green : Colors.orange,
              ),
            ),
            trailing: !isCompleted
                ? FilledButton.tonal(
                    onPressed: () => setState(() => _currentStep = i),
                    child: const Text('Fill Now'),
                  )
                : IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    tooltip: 'Edit form',
                    onPressed: () {
                      setState(() {
                        _completedTemplateIds.remove(req.templateId);
                        _currentStep = i;
                      });
                    },
                  ),
          ),
        );
      },
    );
  }
}
