import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../sdk/src/origination/v1/origination.pb.dart';
import '../data/form_template_providers.dart';

/// Admin screen for designing KYC form templates.
///
/// Two-column layout: field definitions table on the left, live mobile
/// preview on the right, with schema health cards at the bottom.
class FormTemplateDesignerScreen extends ConsumerStatefulWidget {
  const FormTemplateDesignerScreen({super.key, this.templateId});

  final String? templateId;

  @override
  ConsumerState<FormTemplateDesignerScreen> createState() =>
      _FormTemplateDesignerScreenState();
}

class _FormTemplateDesignerScreenState
    extends ConsumerState<FormTemplateDesignerScreen> {
  late FormTemplateObject _template;
  bool _loaded = false;
  bool _saving = false;
  int _previewSection = 0;

  @override
  void initState() {
    super.initState();
    if (widget.templateId == null) {
      _template = FormTemplateObject(
        name: 'New KYC Form',
        description: '',
        status: FormTemplateStatus.FORM_TEMPLATE_STATUS_DRAFT,
        sections: ['Personal Info', 'Financial Details', 'Documents'],
      );
      _loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.templateId != null && !_loaded) {
      final asyncTemplate = ref.watch(
        formTemplateDetailProvider(widget.templateId!),
      );
      return asyncTemplate.when(
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Scaffold(
          body: Center(child: Text('Error loading template: $e')),
        ),
        data: (template) {
          // Copy into local mutable state on first load.
          if (!_loaded) {
            _template = template.clone();
            _loaded = true;
          }
          return _buildContent(context);
        },
      );
    }
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final isDraft =
        _template.status == FormTemplateStatus.FORM_TEMPLATE_STATUS_DRAFT ||
            _template.status ==
                FormTemplateStatus.FORM_TEMPLATE_STATUS_UNSPECIFIED;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go('/origination/form-templates'),
        ),
        title: Row(
          children: [
            Flexible(child: Text(_template.name)),
            const SizedBox(width: 12),
            if (isDraft)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'DRAFT MODE',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onTertiaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          OutlinedButton.icon(
            onPressed: _saving ? null : _saveDraft,
            icon: const Icon(Icons.save_outlined, size: 18),
            label: const Text('Save Draft'),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: _saving || !isDraft ? null : _publishTemplate,
            icon: const Icon(Icons.publish, size: 18),
            label: const Text('Publish Schema'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 900;
          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildFieldPanel(context)),
                const VerticalDivider(width: 1),
                Expanded(flex: 2, child: _buildPreviewPanel(context)),
              ],
            );
          }
          return _buildFieldPanel(context);
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Left panel: field definitions + schema health
  // ---------------------------------------------------------------------------

  Widget _buildFieldPanel(BuildContext context) {
    final theme = Theme.of(context);
    final fields = _template.fields;
    final requiredCount = fields.where((f) => f.required).length;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Name + description
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: _template.name,
                decoration: const InputDecoration(
                  labelText: 'Template Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() => _template.name = v),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                initialValue: _template.description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() => _template.description = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Field table header
        Row(
          children: [
            Text(
              'Field Definitions',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: () => _showFieldDialog(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Field'),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Field table
        if (fields.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.dynamic_form_outlined,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(height: 12),
                    Text(
                      'No fields yet. Click "Add Field" to start designing your KYC schema.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Card(
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 24,
                columns: const [
                  DataColumn(label: Text('KEY')),
                  DataColumn(label: Text('LABEL')),
                  DataColumn(label: Text('TYPE')),
                  DataColumn(label: Text('REQUIRED')),
                  DataColumn(label: Text('GROUP')),
                  DataColumn(label: Text('')),
                ],
                rows: List.generate(fields.length, (i) {
                  final f = fields[i];
                  return DataRow(cells: [
                    DataCell(Text(
                      f.key,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                    DataCell(Text(f.label)),
                    DataCell(Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_fieldTypeIcon(f.fieldType), size: 16),
                        const SizedBox(width: 4),
                        Text(_fieldTypeLabel(f.fieldType)),
                      ],
                    )),
                    DataCell(Switch(
                      value: f.required,
                      onChanged: (v) => setState(() => f.required = v),
                    )),
                    DataCell(_GroupBadge(group: f.group)),
                    DataCell(Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () =>
                              _showFieldDialog(context, index: i),
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline,
                              size: 18,
                              color: theme.colorScheme.error),
                          onPressed: () => _removeField(i),
                          tooltip: 'Remove',
                        ),
                      ],
                    )),
                  ]);
                }),
              ),
            ),
          ),
        const SizedBox(height: 24),

        // Bottom cards row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildEncryptionCard(context)),
            const SizedBox(width: 16),
            Expanded(child: _buildValidationCard(context)),
            const SizedBox(width: 16),
            Expanded(child: _buildHealthCard(context, fields.length, requiredCount)),
          ],
        ),
      ],
    );
  }

  Widget _buildEncryptionCard(BuildContext context) {
    final theme = Theme.of(context);
    final personalCount = _template.fields
        .where((f) => f.group == FormFieldGroup.FORM_FIELD_GROUP_PERSONAL)
        .length;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lock_outline,
                    size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('Data Encryption',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "All $personalCount field(s) marked as 'Personal' will be "
              'automatically hashed at rest using AES-256.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValidationCard(BuildContext context) {
    final theme = Theme.of(context);
    final validationCount = _template.fields
        .where((f) => f.validationPattern.isNotEmpty)
        .length;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.rule_outlined,
                    size: 20, color: theme.colorScheme.tertiary),
                const SizedBox(width: 8),
                Text('Validation Rules',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$validationCount active validation trigger(s) detected.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard(
      BuildContext context, int totalFields, int requiredCount) {
    final theme = Theme.of(context);
    final estMinutes = (totalFields * 0.3).toStringAsFixed(1);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.monitor_heart_outlined,
                    size: 20, color: theme.colorScheme.secondary),
                const SizedBox(width: 8),
                Text('Schema Health',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            _HealthRow(label: 'Total Fields', value: '$totalFields'),
            const SizedBox(height: 4),
            _HealthRow(label: 'Required', value: '$requiredCount'),
            const SizedBox(height: 4),
            _HealthRow(
              label: 'Est. Completion',
              value: '$estMinutes min',
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Right panel: mobile preview
  // ---------------------------------------------------------------------------

  Widget _buildPreviewPanel(BuildContext context) {
    final theme = Theme.of(context);
    final sections = _template.sections.isNotEmpty
        ? _template.sections
        : ['Default'];
    final currentSection =
        _previewSection < sections.length ? sections[_previewSection] : sections.first;
    final sectionFields = _template.fields
        .where((f) =>
            f.section.isEmpty
                ? _previewSection == 0
                : f.section == currentSection)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Live Preview',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: 320,
            constraints: const BoxConstraints(minHeight: 500),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: theme.colorScheme.outlineVariant,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Phone header
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _template.name.isEmpty
                            ? 'KYC Form'
                            : _template.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Step ${_previewSection + 1} of ${sections.length}: $currentSection',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Progress bar
                LinearProgressIndicator(
                  value: sections.isEmpty
                      ? 0
                      : (_previewSection + 1) / sections.length,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                ),

                // Field previews
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: sectionFields.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Text(
                            'No fields in this section yet.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final field in sectionFields)
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 16),
                                child: _PreviewField(field: field),
                              ),
                          ],
                        ),
                ),

                // Navigation
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_previewSection > 0)
                        TextButton(
                          onPressed: () => setState(
                              () => _previewSection--),
                          child: const Text('Back'),
                        )
                      else
                        const SizedBox.shrink(),
                      if (_previewSection < sections.length - 1)
                        FilledButton(
                          onPressed: () => setState(
                              () => _previewSection++),
                          child: const Text('Next Step'),
                        )
                      else
                        FilledButton(
                          onPressed: null,
                          child: const Text('Submit'),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Add/Edit field dialog
  // ---------------------------------------------------------------------------

  void _showFieldDialog(BuildContext context, {int? index}) {
    final isEdit = index != null;
    final existing =
        isEdit ? _template.fields[index] : FormFieldDefinition();

    final keyCtrl = TextEditingController(text: existing.key);
    final labelCtrl = TextEditingController(text: existing.label);
    final placeholderCtrl = TextEditingController(text: existing.placeholder);
    final descCtrl = TextEditingController(text: existing.description);
    final patternCtrl =
        TextEditingController(text: existing.validationPattern);
    final minLenCtrl = TextEditingController(
        text: existing.minLength > 0 ? '${existing.minLength}' : '');
    final maxLenCtrl = TextEditingController(
        text: existing.maxLength > 0 ? '${existing.maxLength}' : '');
    final minValCtrl = TextEditingController(text: existing.minValue);
    final maxValCtrl = TextEditingController(text: existing.maxValue);
    final optionsCtrl =
        TextEditingController(text: existing.options.join(', '));

    var fieldType = existing.fieldType;
    var group = existing.group;
    var required = existing.required;
    var section = existing.section.isNotEmpty
        ? existing.section
        : (_template.sections.isNotEmpty ? _template.sections.first : '');

    // Auto-generate key from label
    labelCtrl.addListener(() {
      if (!isEdit || keyCtrl.text.isEmpty) {
        keyCtrl.text = labelCtrl.text
            .toLowerCase()
            .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
            .replaceAll(RegExp(r'^_|_$'), '');
      }
    });

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final showOptions = fieldType == FormFieldType.FORM_FIELD_TYPE_SELECT ||
              fieldType == FormFieldType.FORM_FIELD_TYPE_MULTI_SELECT;

          return AlertDialog(
            title: Text(isEdit ? 'Edit Field' : 'Add Field'),
            content: SizedBox(
              width: 520,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: labelCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Label *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: keyCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Key',
                        border: OutlineInputBorder(),
                        helperText: 'Auto-generated from label',
                      ),
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<FormFieldType>(
                            initialValue: fieldType,
                            decoration: const InputDecoration(
                              labelText: 'Type',
                              border: OutlineInputBorder(),
                            ),
                            items: FormFieldType.values
                                .where((t) =>
                                    t != FormFieldType.FORM_FIELD_TYPE_UNSPECIFIED)
                                .map((t) => DropdownMenuItem(
                                      value: t,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(_fieldTypeIcon(t), size: 16),
                                          const SizedBox(width: 8),
                                          Text(_fieldTypeLabel(t)),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            onChanged: (v) => setDialogState(
                                () => fieldType = v ?? fieldType),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<FormFieldGroup>(
                            initialValue: group,
                            decoration: const InputDecoration(
                              labelText: 'Group',
                              border: OutlineInputBorder(),
                            ),
                            items: FormFieldGroup.values
                                .where((g) =>
                                    g !=
                                    FormFieldGroup
                                        .FORM_FIELD_GROUP_UNSPECIFIED)
                                .map((g) => DropdownMenuItem(
                                      value: g,
                                      child: Text(_groupLabel(g)),
                                    ))
                                .toList(),
                            onChanged: (v) =>
                                setDialogState(() => group = v ?? group),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _template.sections.contains(section)
                                ? section
                                : (_template.sections.isNotEmpty
                                    ? _template.sections.first
                                    : null),
                            decoration: const InputDecoration(
                              labelText: 'Section',
                              border: OutlineInputBorder(),
                            ),
                            items: _template.sections
                                .map((s) =>
                                    DropdownMenuItem(value: s, child: Text(s)))
                                .toList(),
                            onChanged: (v) =>
                                setDialogState(() => section = v ?? section),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 140,
                          child: SwitchListTile(
                            title: const Text('Required'),
                            value: required,
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (v) =>
                                setDialogState(() => required = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: placeholderCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Placeholder',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: descCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    if (showOptions) ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: optionsCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Options (comma-separated)',
                          border: OutlineInputBorder(),
                          helperText: 'e.g. Employed, Self-employed, Retired',
                        ),
                        maxLines: 2,
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: patternCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Validation Pattern (regex)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: minLenCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Min Length',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: maxLenCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Max Length',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: minValCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Min Value',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: maxValCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Max Value',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  if (labelCtrl.text.trim().isEmpty) return;

                  final field = FormFieldDefinition(
                    key: keyCtrl.text.trim(),
                    label: labelCtrl.text.trim(),
                    fieldType: fieldType,
                    group: group,
                    required: required,
                    placeholder: placeholderCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    validationPattern: patternCtrl.text.trim(),
                    minLength: int.tryParse(minLenCtrl.text.trim()) ?? 0,
                    maxLength: int.tryParse(maxLenCtrl.text.trim()) ?? 0,
                    minValue: minValCtrl.text.trim(),
                    maxValue: maxValCtrl.text.trim(),
                    section: section,
                    order: isEdit ? existing.order : _template.fields.length,
                    options: showOptions
                        ? optionsCtrl.text
                            .split(',')
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty)
                            .toList()
                        : [],
                    encrypted:
                        group == FormFieldGroup.FORM_FIELD_GROUP_PERSONAL,
                  );

                  setState(() {
                    if (isEdit) {
                      _template.fields[index] = field;
                    } else {
                      _template.fields.add(field);
                    }
                  });
                  Navigator.of(ctx).pop();
                },
                child: Text(isEdit ? 'Update' : 'Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _removeField(int index) {
    setState(() {
      _template.fields.removeAt(index);
    });
  }

  // ---------------------------------------------------------------------------
  // Save & publish
  // ---------------------------------------------------------------------------

  Future<void> _saveDraft() async {
    setState(() => _saving = true);
    try {
      final saved = await ref
          .read(formTemplateProvider.notifier)
          .save(_template);
      if (mounted) {
        setState(() {
          _template = saved.clone();
          _saving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Draft saved')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: $e')),
        );
      }
    }
  }

  Future<void> _publishTemplate() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Publish Schema'),
        content: const Text(
          'Publishing will increment the version and make this schema available '
          'for new applications. Existing submissions will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Publish'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _saving = true);
    try {
      // Save first, then publish.
      final saved = await ref
          .read(formTemplateProvider.notifier)
          .save(_template);
      final published = await ref
          .read(formTemplateProvider.notifier)
          .publish(saved.id);
      if (mounted) {
        setState(() {
          _template = published.clone();
          _saving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schema published')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Publish failed: $e')),
        );
      }
    }
  }
}

// =============================================================================
// Helper widgets
// =============================================================================

class _GroupBadge extends StatelessWidget {
  const _GroupBadge({required this.group});
  final FormFieldGroup group;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (group) {
      FormFieldGroup.FORM_FIELD_GROUP_PERSONAL => ('PERSONAL', Colors.blue),
      FormFieldGroup.FORM_FIELD_GROUP_FINANCIAL => ('FINANCIAL', Colors.green),
      FormFieldGroup.FORM_FIELD_GROUP_LEGAL => ('LEGAL', Colors.purple),
      FormFieldGroup.FORM_FIELD_GROUP_DOCUMENTS => ('DOCUMENTS', Colors.orange),
      FormFieldGroup.FORM_FIELD_GROUP_LOCATION => ('LOCATION', Colors.teal),
      _ => ('UNSET', Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _HealthRow extends StatelessWidget {
  const _HealthRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )),
        Text(value,
            style: theme.textTheme.bodySmall
                ?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _PreviewField extends StatelessWidget {
  const _PreviewField({required this.field});
  final FormFieldDefinition field;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelText =
        '${field.label}${field.required ? ' *' : ''}';

    switch (field.fieldType) {
      case FormFieldType.FORM_FIELD_TYPE_CHECKBOX:
        return CheckboxListTile(
          value: false,
          onChanged: null,
          title: Text(labelText, style: theme.textTheme.bodyMedium),
          dense: true,
          contentPadding: EdgeInsets.zero,
        );

      case FormFieldType.FORM_FIELD_TYPE_SELECT:
        return InputDecorator(
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.arrow_drop_down),
            isDense: true,
          ),
          child: Text(
            field.placeholder.isNotEmpty ? field.placeholder : 'Select...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        );

      case FormFieldType.FORM_FIELD_TYPE_MULTI_SELECT:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(labelText, style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              children: field.options.isEmpty
                  ? [const Chip(label: Text('Option 1'))]
                  : field.options
                      .map((o) => Chip(label: Text(o)))
                      .toList(),
            ),
          ],
        );

      case FormFieldType.FORM_FIELD_TYPE_DATE:
        return InputDecorator(
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today, size: 18),
            isDense: true,
          ),
          child: Text(
            'DD/MM/YYYY',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        );

      case FormFieldType.FORM_FIELD_TYPE_PHOTO:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(labelText, style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            Container(
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(
                    color: theme.colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt_outlined,
                        color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(height: 4),
                    Text('Tap to capture',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        )),
                  ],
                ),
              ),
            ),
          ],
        );

      case FormFieldType.FORM_FIELD_TYPE_FILE:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(labelText, style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.attach_file, size: 18),
              label: const Text('Choose File'),
            ),
          ],
        );

      case FormFieldType.FORM_FIELD_TYPE_LOCATION:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(labelText, style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.location_on_outlined, size: 18),
              label: const Text('Capture GPS Location'),
            ),
          ],
        );

      case FormFieldType.FORM_FIELD_TYPE_SIGNATURE:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(labelText, style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            Container(
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(
                    color: theme.colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text('Sign here',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    )),
              ),
            ),
          ],
        );

      case FormFieldType.FORM_FIELD_TYPE_TEXTAREA:
        return TextField(
          decoration: InputDecoration(
            labelText: labelText,
            hintText: field.placeholder,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          maxLines: 3,
          enabled: false,
        );

      case FormFieldType.FORM_FIELD_TYPE_CURRENCY:
        return TextField(
          decoration: InputDecoration(
            labelText: labelText,
            hintText: field.placeholder,
            prefixText: '\$ ',
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          enabled: false,
          keyboardType: TextInputType.number,
        );

      case FormFieldType.FORM_FIELD_TYPE_PHONE:
        return TextField(
          decoration: InputDecoration(
            labelText: labelText,
            hintText: field.placeholder.isNotEmpty
                ? field.placeholder
                : '+254...',
            prefixIcon: const Icon(Icons.phone, size: 18),
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          enabled: false,
        );

      case FormFieldType.FORM_FIELD_TYPE_EMAIL:
        return TextField(
          decoration: InputDecoration(
            labelText: labelText,
            hintText: field.placeholder.isNotEmpty
                ? field.placeholder
                : 'email@example.com',
            prefixIcon: const Icon(Icons.email_outlined, size: 18),
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          enabled: false,
        );

      case FormFieldType.FORM_FIELD_TYPE_NUMBER:
        return TextField(
          decoration: InputDecoration(
            labelText: labelText,
            hintText: field.placeholder,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          enabled: false,
          keyboardType: TextInputType.number,
        );

      // TEXT + fallback
      default:
        return TextField(
          decoration: InputDecoration(
            labelText: labelText,
            hintText: field.placeholder,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          enabled: false,
        );
    }
  }
}

// =============================================================================
// Helpers
// =============================================================================

IconData _fieldTypeIcon(FormFieldType type) {
  return switch (type) {
    FormFieldType.FORM_FIELD_TYPE_TEXT => Icons.text_fields,
    FormFieldType.FORM_FIELD_TYPE_NUMBER => Icons.pin,
    FormFieldType.FORM_FIELD_TYPE_CURRENCY => Icons.attach_money,
    FormFieldType.FORM_FIELD_TYPE_PHONE => Icons.phone,
    FormFieldType.FORM_FIELD_TYPE_EMAIL => Icons.email,
    FormFieldType.FORM_FIELD_TYPE_DATE => Icons.calendar_today,
    FormFieldType.FORM_FIELD_TYPE_SELECT => Icons.list,
    FormFieldType.FORM_FIELD_TYPE_MULTI_SELECT => Icons.checklist,
    FormFieldType.FORM_FIELD_TYPE_PHOTO => Icons.camera_alt,
    FormFieldType.FORM_FIELD_TYPE_FILE => Icons.attach_file,
    FormFieldType.FORM_FIELD_TYPE_LOCATION => Icons.location_on,
    FormFieldType.FORM_FIELD_TYPE_SIGNATURE => Icons.draw,
    FormFieldType.FORM_FIELD_TYPE_CHECKBOX => Icons.check_box,
    FormFieldType.FORM_FIELD_TYPE_TEXTAREA => Icons.notes,
    _ => Icons.help_outline,
  };
}

String _fieldTypeLabel(FormFieldType type) {
  return switch (type) {
    FormFieldType.FORM_FIELD_TYPE_TEXT => 'Text',
    FormFieldType.FORM_FIELD_TYPE_NUMBER => 'Number',
    FormFieldType.FORM_FIELD_TYPE_CURRENCY => 'Currency',
    FormFieldType.FORM_FIELD_TYPE_PHONE => 'Phone',
    FormFieldType.FORM_FIELD_TYPE_EMAIL => 'Email',
    FormFieldType.FORM_FIELD_TYPE_DATE => 'Date',
    FormFieldType.FORM_FIELD_TYPE_SELECT => 'Select',
    FormFieldType.FORM_FIELD_TYPE_MULTI_SELECT => 'Multi-Select',
    FormFieldType.FORM_FIELD_TYPE_PHOTO => 'Photo',
    FormFieldType.FORM_FIELD_TYPE_FILE => 'File',
    FormFieldType.FORM_FIELD_TYPE_LOCATION => 'Location',
    FormFieldType.FORM_FIELD_TYPE_SIGNATURE => 'Signature',
    FormFieldType.FORM_FIELD_TYPE_CHECKBOX => 'Checkbox',
    FormFieldType.FORM_FIELD_TYPE_TEXTAREA => 'Textarea',
    _ => 'Unknown',
  };
}

String _groupLabel(FormFieldGroup group) {
  return switch (group) {
    FormFieldGroup.FORM_FIELD_GROUP_PERSONAL => 'Personal',
    FormFieldGroup.FORM_FIELD_GROUP_FINANCIAL => 'Financial',
    FormFieldGroup.FORM_FIELD_GROUP_LEGAL => 'Legal',
    FormFieldGroup.FORM_FIELD_GROUP_DOCUMENTS => 'Documents',
    FormFieldGroup.FORM_FIELD_GROUP_LOCATION => 'Location',
    _ => 'Unspecified',
  };
}
