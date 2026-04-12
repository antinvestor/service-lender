import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../sdk/src/identity/v1/identity.pb.dart';
import '../../sdk/src/origination/v1/origination.pb.dart';
import '../../features/field/data/client_data_providers.dart';
import 'signature_pad.dart';

/// Callback when the form is submitted with the collected data.
typedef FormSubmitCallback = Future<void> Function(
  Map<String, dynamic> data,
  Map<String, Uint8List> fileData,
);

/// Wraps [DynamicFormRenderer] with client data store awareness.
///
/// When [clientId] is provided, loads existing client data entries and renders
/// fields with verification-aware decorations:
/// - Verified fields are read-only with a green border
/// - Rejected fields show reviewer comment with red border
/// - More-info-needed fields show comment with orange border
/// - Collected/under-review fields pre-fill values
class ClientDataAwareFormRenderer extends ConsumerWidget {
  const ClientDataAwareFormRenderer({
    super.key,
    required this.template,
    required this.clientId,
    this.initialData = const {},
    this.onSubmit,
    this.readOnly = false,
  });

  final FormTemplateObject template;
  final String clientId;
  final Map<String, dynamic> initialData;
  final FormSubmitCallback? onSubmit;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientDataAsync =
        ref.watch(clientDataListProvider(clientId: clientId));

    return clientDataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) {
        // Fallback to normal rendering on error.
        return DynamicFormRenderer(
          template: template,
          initialData: initialData,
          onSubmit: onSubmit,
          readOnly: readOnly,
        );
      },
      data: (entries) {
        // Build lookup map keyed by fieldKey.
        final dataMap = <String, ClientDataEntryObject>{};
        for (final entry in entries) {
          dataMap[entry.fieldKey] = entry;
        }

        // Merge verified/collected values into initialData.
        final mergedData = Map<String, dynamic>.from(initialData);
        for (final entry in entries) {
          if (entry.value.isNotEmpty && !mergedData.containsKey(entry.fieldKey)) {
            mergedData[entry.fieldKey] = entry.value;
          }
        }

        return DynamicFormRenderer(
          template: template,
          initialData: mergedData,
          onSubmit: onSubmit,
          readOnly: readOnly,
          clientDataMap: dataMap,
        );
      },
    );
  }
}

/// Renders a [FormTemplateObject] as a step-by-step wizard, grouped by section.
///
/// This is the core reusable form rendering infrastructure — it takes any
/// form template and renders its fields with full validation, multi-step
/// navigation, and optional client data verification decorations.
///
/// Used by loan origination, client onboarding, group setup, and any other
/// feature that needs template-driven forms.
class DynamicFormRenderer extends StatefulWidget {
  const DynamicFormRenderer({
    super.key,
    required this.template,
    this.initialData = const {},
    this.onSubmit,
    this.readOnly = false,
    this.clientDataMap,
  });

  final FormTemplateObject template;
  final Map<String, dynamic> initialData;
  final FormSubmitCallback? onSubmit;
  final bool readOnly;

  /// When non-null, per-field verification decorations are applied.
  final Map<String, ClientDataEntryObject>? clientDataMap;

  @override
  State<DynamicFormRenderer> createState() => _DynamicFormRendererState();
}

class _DynamicFormRendererState extends State<DynamicFormRenderer> {
  late int _currentStep;
  late List<String> _sections;
  final Map<String, dynamic> _data = {};
  final Map<String, Uint8List> _fileData = {};
  final Map<String, GlobalKey<SignaturePadState>> _signatureKeys = {};
  final _formKey = GlobalKey<FormState>();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _currentStep = 0;
    _data.addAll(widget.initialData);
    _sections = widget.template.sections.isNotEmpty
        ? List<String>.from(widget.template.sections)
        : ['Default'];
  }

  List<FormFieldDefinition> _fieldsForSection(String section) {
    return widget.template.fields
        .where((f) =>
            f.section == section ||
            (f.section.isEmpty && section == _sections.first))
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final section = _sections[_currentStep];
    final fields = _fieldsForSection(section);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Step indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              for (var i = 0; i < _sections.length; i++) ...[
                if (i > 0)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: i <= _currentStep
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: i <= _currentStep
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  child: i < _currentStep
                      ? Icon(Icons.check,
                          size: 14,
                          color: theme.colorScheme.onPrimary)
                      : Text(
                          '${i + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: i == _currentStep
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
              ],
            ],
          ),
        ),

        // Section title
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Text(
            section,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Fields
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: fields.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, i) =>
                  _buildField(context, fields[i]),
            ),
          ),
        ),

        // Navigation buttons
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (_currentStep > 0)
                OutlinedButton(
                  onPressed: () => setState(() => _currentStep--),
                  child: const Text('Back'),
                ),
              const Spacer(),
              if (_currentStep < _sections.length - 1)
                FilledButton(
                  onPressed: _nextStep,
                  child: const Text('Next'),
                )
              else
                FilledButton(
                  onPressed: _submitting || widget.readOnly
                      ? null
                      : _submit,
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit'),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _nextStep() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      setState(() => _currentStep++);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState!.save();

    // Collect any signature data.
    for (final entry in _signatureKeys.entries) {
      final bytes = await entry.value.currentState?.toPngBytes();
      if (bytes != null) {
        _fileData[entry.key] = bytes;
      }
    }

    setState(() => _submitting = true);
    try {
      await widget.onSubmit?.call(_data, _fileData);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Field renderers
  // ---------------------------------------------------------------------------

  Widget _buildField(BuildContext context, FormFieldDefinition field) {
    final cdMap = widget.clientDataMap;

    // If we have client data for this field, apply verification-aware rendering.
    if (cdMap != null && cdMap.containsKey(field.key)) {
      final entry = cdMap[field.key]!;
      final status = entry.verificationStatus;

      // Verified: check expiry before showing read-only card.
      if (status ==
              DataVerificationStatus.DATA_VERIFICATION_STATUS_VERIFIED) {
        final isExpired = entry.expiresAt.isNotEmpty &&
            DateTime.tryParse(entry.expiresAt)?.isBefore(DateTime.now()) == true;

        if (!isExpired) {
          return VerifiedFieldCard(
            field: field,
            entry: entry,
          );
        }
        // Expired verification — show as editable with expiry notice.
        final normalField = _buildFieldInner(context, field, entry: entry);
        return StatusDecoratedField(
          status: DataVerificationStatus.DATA_VERIFICATION_STATUS_EXPIRED,
          comment: 'Verification expired — please re-verify',
          child: normalField,
        );
      }

      // For all other statuses, wrap the normal field with status decoration.
      final normalField = _buildFieldInner(context, field, entry: entry);
      return StatusDecoratedField(
        status: status,
        comment: entry.reviewerComment,
        child: normalField,
      );
    }

    return _buildFieldInner(context, field);
  }

  Widget _buildFieldInner(BuildContext context, FormFieldDefinition field,
      {ClientDataEntryObject? entry}) {
    // Rejected fields require re-entry; more-info allows editing.
    final isRejected = entry?.verificationStatus ==
        DataVerificationStatus.DATA_VERIFICATION_STATUS_REJECTED;
    final readOnly = widget.readOnly &&
        !isRejected &&
        entry?.verificationStatus !=
            DataVerificationStatus.DATA_VERIFICATION_STATUS_MORE_INFO_NEEDED;

    switch (field.fieldType) {
      case FormFieldType.FORM_FIELD_TYPE_TEXT:
        return _textField(field, readOnly: readOnly);

      case FormFieldType.FORM_FIELD_TYPE_NUMBER:
        return _textField(
          field,
          readOnly: readOnly,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
        );

      case FormFieldType.FORM_FIELD_TYPE_CURRENCY:
        return _textField(
          field,
          readOnly: readOnly,
          keyboardType: TextInputType.number,
          prefixText: '\$ ',
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.,]'))],
        );

      case FormFieldType.FORM_FIELD_TYPE_PHONE:
        return _textField(
          field,
          readOnly: readOnly,
          keyboardType: TextInputType.phone,
          prefixIcon: const Icon(Icons.phone, size: 18),
        );

      case FormFieldType.FORM_FIELD_TYPE_EMAIL:
        return _textField(
          field,
          readOnly: readOnly,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined, size: 18),
        );

      case FormFieldType.FORM_FIELD_TYPE_TEXTAREA:
        return _textField(field, readOnly: readOnly, maxLines: 4);

      case FormFieldType.FORM_FIELD_TYPE_DATE:
        return _dateField(context, field, readOnly: readOnly);

      case FormFieldType.FORM_FIELD_TYPE_SELECT:
        return _selectField(field, readOnly: readOnly);

      case FormFieldType.FORM_FIELD_TYPE_MULTI_SELECT:
        return _multiSelectField(field, readOnly: readOnly);

      case FormFieldType.FORM_FIELD_TYPE_CHECKBOX:
        return _checkboxField(field, readOnly: readOnly);

      case FormFieldType.FORM_FIELD_TYPE_PHOTO:
        return _captureField(
          field,
          icon: Icons.camera_alt_outlined,
          label: 'Capture Photo',
          readOnly: readOnly,
        );

      case FormFieldType.FORM_FIELD_TYPE_FILE:
        return _captureField(
          field,
          icon: Icons.attach_file,
          label: 'Choose File',
          readOnly: readOnly,
        );

      case FormFieldType.FORM_FIELD_TYPE_LOCATION:
        return _locationField(field, readOnly: readOnly);

      case FormFieldType.FORM_FIELD_TYPE_SIGNATURE:
        return _signatureField(field, readOnly: readOnly);

      default:
        return _textField(field, readOnly: readOnly);
    }
  }

  Widget _textField(
    FormFieldDefinition field, {
    bool readOnly = false,
    TextInputType? keyboardType,
    String? prefixText,
    Widget? prefixIcon,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final label =
        '${field.label}${field.required ? ' *' : ''}';
    return TextFormField(
      initialValue: _data[field.key]?.toString() ?? field.defaultValue,
      decoration: InputDecoration(
        labelText: label,
        hintText: field.placeholder,
        helperText: field.description.isNotEmpty ? field.description : null,
        border: const OutlineInputBorder(),
        prefixText: prefixText,
        prefixIcon: prefixIcon,
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      inputFormatters: inputFormatters,
      validator: (v) => _validateField(field, v),
      onSaved: (v) => _data[field.key] = v?.trim() ?? '',
    );
  }

  Widget _dateField(
    BuildContext context,
    FormFieldDefinition field, {
    bool readOnly = false,
  }) {
    final label =
        '${field.label}${field.required ? ' *' : ''}';
    final current = _data[field.key]?.toString() ?? '';
    return TextFormField(
      controller: TextEditingController(text: current),
      decoration: InputDecoration(
        labelText: label,
        hintText: 'YYYY-MM-DD',
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today, size: 18),
        helperText: field.description.isNotEmpty ? field.description : null,
      ),
      readOnly: true,
      onTap: readOnly
          ? null
          : () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                final formatted =
                    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                setState(() => _data[field.key] = formatted);
              }
            },
      validator: (v) => _validateField(field, v),
      onSaved: (v) {
        if (v != null && v.isNotEmpty) _data[field.key] = v;
      },
    );
  }

  Widget _selectField(FormFieldDefinition field, {bool readOnly = false}) {
    final label =
        '${field.label}${field.required ? ' *' : ''}';
    return DropdownButtonFormField<String>(
      initialValue: _data[field.key]?.toString(),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        helperText: field.description.isNotEmpty ? field.description : null,
      ),
      items: field.options
          .map((o) => DropdownMenuItem(value: o, child: Text(o)))
          .toList(),
      onChanged: readOnly ? null : (v) => setState(() => _data[field.key] = v),
      validator: (v) => field.required && (v == null || v.isEmpty)
          ? '${field.label} is required'
          : null,
      onSaved: (v) {
        if (v != null) _data[field.key] = v;
      },
    );
  }

  Widget _multiSelectField(FormFieldDefinition field,
      {bool readOnly = false}) {
    final label =
        '${field.label}${field.required ? ' *' : ''}';
    final selected = (_data[field.key] as List<String>?) ?? [];

    return FormField<List<String>>(
      initialValue: selected,
      validator: (v) => field.required && (v == null || v.isEmpty)
          ? '${field.label} is required'
          : null,
      onSaved: (v) => _data[field.key] = v ?? [],
      builder: (state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            errorText: state.errorText,
            helperText:
                field.description.isNotEmpty ? field.description : null,
          ),
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: field.options.map((option) {
              final isSelected = selected.contains(option);
              return FilterChip(
                label: Text(option),
                selected: isSelected,
                onSelected: readOnly
                    ? null
                    : (v) {
                        setState(() {
                          final list =
                              List<String>.from(selected);
                          v ? list.add(option) : list.remove(option);
                          _data[field.key] = list;
                        });
                      },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _checkboxField(FormFieldDefinition field, {bool readOnly = false}) {
    final val = _data[field.key] == true;
    return FormField<bool>(
      initialValue: val,
      validator: (v) =>
          field.required && v != true ? '${field.label} is required' : null,
      onSaved: (v) => _data[field.key] = v ?? false,
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            value: val,
            title: Text(field.label),
            subtitle: field.description.isNotEmpty
                ? Text(field.description)
                : null,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            onChanged: readOnly
                ? null
                : (v) => setState(() => _data[field.key] = v ?? false),
          ),
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                state.errorText!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _captureField(
    FormFieldDefinition field, {
    required IconData icon,
    required String label,
    bool readOnly = false,
  }) {
    final hasData = _fileData.containsKey(field.key) ||
        (_data[field.key] != null && _data[field.key].toString().isNotEmpty);
    return FormField<String>(
      validator: (v) => field.required && !hasData
          ? '${field.label} is required'
          : null,
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${field.label}${field.required ? ' *' : ''}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (field.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                field.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
              ),
            ),
          const SizedBox(height: 8),
          if (hasData)
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outlineVariant),
              ),
              child: const Center(
                child: Icon(Icons.check_circle, color: Colors.green),
              ),
            )
          else
            OutlinedButton.icon(
              onPressed: readOnly
                  ? null
                  : () {
                      // TODO: invoke image_picker or file_picker for real
                      // capture. For now, store a placeholder sentinel in
                      // both _data (for validation) and _fileData (for
                      // the onSubmit callback).
                      setState(() {
                        _data[field.key] = 'pending_upload';
                        _fileData[field.key] = Uint8List(0);
                      });
                    },
              icon: Icon(icon, size: 18),
              label: Text(label),
            ),
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                state.errorText!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _locationField(FormFieldDefinition field,
      {bool readOnly = false}) {
    final loc = _data[field.key]?.toString() ?? '';
    return FormField<String>(
      initialValue: loc,
      validator: (v) =>
          field.required && (v == null || v.isEmpty)
              ? '${field.label} is required'
              : null,
      onSaved: (v) {
        if (v != null) _data[field.key] = v;
      },
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${field.label}${field.required ? ' *' : ''}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          if (loc.isNotEmpty)
            Text(loc,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ))
          else
            OutlinedButton.icon(
              onPressed: readOnly
                  ? null
                  : () {
                      // In production, use geolocator package.
                      setState(() {
                        _data[field.key] = '0.0, 0.0';
                      });
                    },
              icon: const Icon(Icons.location_on_outlined, size: 18),
              label: const Text('Capture GPS Location'),
            ),
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                state.errorText!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _signatureField(FormFieldDefinition field,
      {bool readOnly = false}) {
    final sigKey = _signatureKeys.putIfAbsent(
      field.key,
      () => GlobalKey<SignaturePadState>(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${field.label}${field.required ? ' *' : ''}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (field.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              field.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
            ),
          ),
        const SizedBox(height: 8),
        IgnorePointer(
          ignoring: readOnly,
          child: SignaturePad(
            key: sigKey,
            height: 150,
            penColor: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Validation
  // ---------------------------------------------------------------------------

  String? _validateField(FormFieldDefinition field, String? value) {
    final v = value?.trim() ?? '';

    if (field.required && v.isEmpty) {
      return '${field.label} is required';
    }

    if (v.isEmpty) return null;

    if (field.validationPattern.isNotEmpty) {
      final regex = RegExp(field.validationPattern);
      if (!regex.hasMatch(v)) {
        return field.validationMessage.isNotEmpty
            ? field.validationMessage
            : 'Invalid format';
      }
    }

    if (field.minLength > 0 && v.length < field.minLength) {
      return 'Minimum ${field.minLength} characters';
    }

    if (field.maxLength > 0 && v.length > field.maxLength) {
      return 'Maximum ${field.maxLength} characters';
    }

    if (field.minValue.isNotEmpty || field.maxValue.isNotEmpty) {
      final num? numVal = num.tryParse(v);
      if (numVal != null) {
        if (field.minValue.isNotEmpty) {
          final min = num.tryParse(field.minValue);
          if (min != null && numVal < min) {
            return 'Minimum value is ${field.minValue}';
          }
        }
        if (field.maxValue.isNotEmpty) {
          final max = num.tryParse(field.maxValue);
          if (max != null && numVal > max) {
            return 'Maximum value is ${field.maxValue}';
          }
        }
      }
    }

    return null;
  }
}

// ---------------------------------------------------------------------------
// Verification-aware field wrappers
// ---------------------------------------------------------------------------

/// Read-only card for verified fields, shown with a green border and badge.
class VerifiedFieldCard extends StatelessWidget {
  const VerifiedFieldCard({
    super.key,
    required this.field,
    required this.entry,
  });

  final FormFieldDefinition field;
  final ClientDataEntryObject entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.green, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    field.label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green.withAlpha(100)),
                  ),
                  child: Text(
                    'Verified',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              entry.value.isNotEmpty ? entry.value : '(empty)',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// Wraps a field widget with a colored border and optional helper text
/// based on verification status.
class StatusDecoratedField extends StatelessWidget {
  const StatusDecoratedField({
    super.key,
    required this.status,
    required this.comment,
    required this.child,
  });

  final DataVerificationStatus status;
  final String comment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final color = _colorForStatus(status);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1.2),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
          if (comment.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.info_outline, size: 14, color: color),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    comment,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _colorForStatus(DataVerificationStatus s) {
    switch (s) {
      case DataVerificationStatus.DATA_VERIFICATION_STATUS_REJECTED:
        return Colors.red;
      case DataVerificationStatus.DATA_VERIFICATION_STATUS_MORE_INFO_NEEDED:
        return Colors.orange;
      case DataVerificationStatus.DATA_VERIFICATION_STATUS_UNDER_REVIEW:
        return Colors.blue;
      case DataVerificationStatus.DATA_VERIFICATION_STATUS_EXPIRED:
        return Colors.red.shade300;
      default:
        return Colors.grey;
    }
  }
}
