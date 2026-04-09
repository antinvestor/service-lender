import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../sdk/src/google/protobuf/struct.pb.dart' as struct_pb;

/// A single field definition parsed from a product's `kyc_schema`.
class DynamicFieldDef {
  const DynamicFieldDef({
    required this.key,
    required this.label,
    required this.type,
    this.required = false,
    this.group = '',
    this.hint = '',
    this.options = const [],
  });

  final String key;
  final String label;

  /// One of: text, number, date, select, phone, boolean, photo, location
  final String type;
  final bool required;

  /// Grouping key for collapsible sections (personal, financial, etc.)
  final String group;
  final String hint;

  /// For 'select' type fields
  final List<String> options;
}

/// Parses a Struct-based kyc_schema into a list of [DynamicFieldDef].
///
/// The schema is stored as a Struct with a `fields` key containing a
/// ListValue of Structs, each representing a field definition.
/// Alternatively, it may be stored directly as a ListValue in a
/// well-known key like "schema" or the fields themselves may be
/// top-level entries.
List<DynamicFieldDef> parseKycSchema(struct_pb.Struct? schema) {
  if (schema == null) return [];

  // Try well-known wrapper keys first
  for (final wrapperKey in ['schema', 'fields', 'kyc_schema']) {
    final wrapper = schema.fields[wrapperKey];
    if (wrapper != null && wrapper.hasListValue()) {
      return _parseFieldList(wrapper.listValue);
    }
  }

  // If the struct has a ListValue at any key, try that
  for (final entry in schema.fields.entries) {
    if (entry.value.hasListValue() && entry.value.listValue.values.isNotEmpty) {
      final first = entry.value.listValue.values.first;
      if (first.hasStructValue() &&
          first.structValue.fields.containsKey('key')) {
        return _parseFieldList(entry.value.listValue);
      }
    }
  }

  // Try treating top-level Struct entries as individual field defs
  if (schema.fields.containsKey('key')) {
    return [_parseOneField(schema)];
  }

  return [];
}

List<DynamicFieldDef> _parseFieldList(struct_pb.ListValue list) {
  return list.values
      .where((v) => v.hasStructValue())
      .map((v) => _parseOneField(v.structValue))
      .toList();
}

DynamicFieldDef _parseOneField(struct_pb.Struct s) {
  String str(String key) {
    final v = s.fields[key];
    if (v == null) return '';
    if (v.hasStringValue()) return v.stringValue;
    return '';
  }

  bool boolean(String key) {
    final v = s.fields[key];
    if (v == null) return false;
    if (v.hasBoolValue()) return v.boolValue;
    if (v.hasStringValue()) return v.stringValue.toLowerCase() == 'true';
    return false;
  }

  List<String> stringList(String key) {
    final v = s.fields[key];
    if (v == null) return [];
    if (v.hasListValue()) {
      return v.listValue.values
          .where((item) => item.hasStringValue())
          .map((item) => item.stringValue)
          .toList();
    }
    return [];
  }

  return DynamicFieldDef(
    key: str('key'),
    label: str('label'),
    type: str('type').isNotEmpty ? str('type') : 'text',
    required: boolean('required'),
    group: str('group'),
    hint: str('hint'),
    options: stringList('options'),
  );
}

/// Groups field definitions by their `group` value.
/// Empty-group fields are placed in "General".
Map<String, List<DynamicFieldDef>> groupFields(List<DynamicFieldDef> fields) {
  final groups = <String, List<DynamicFieldDef>>{};
  for (final f in fields) {
    final key = f.group.isNotEmpty ? f.group : 'General';
    groups.putIfAbsent(key, () => []).add(f);
  }
  return groups;
}

/// A form widget that dynamically renders fields based on a KYC schema.
///
/// [fields] — parsed from product's kyc_schema via [parseKycSchema].
/// [initialValues] — pre-filled values keyed by field key.
/// [onChanged] — called on every value change with the full values map.
class DynamicForm extends StatefulWidget {
  const DynamicForm({
    super.key,
    required this.fields,
    this.initialValues = const {},
    this.onChanged,
    this.readOnly = false,
  });

  final List<DynamicFieldDef> fields;
  final Map<String, dynamic> initialValues;
  final ValueChanged<Map<String, dynamic>>? onChanged;
  final bool readOnly;

  @override
  State<DynamicForm> createState() => DynamicFormState();
}

class DynamicFormState extends State<DynamicForm> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, dynamic> _values;
  late final Map<String, TextEditingController> _textControllers;

  @override
  void initState() {
    super.initState();
    _values = Map<String, dynamic>.from(widget.initialValues);
    _textControllers = {};
    for (final field in widget.fields) {
      if (_isTextType(field.type)) {
        final initial = _values[field.key]?.toString() ?? '';
        _textControllers[field.key] = TextEditingController(text: initial);
      }
    }
  }

  @override
  void dispose() {
    for (final ctrl in _textControllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  bool _isTextType(String type) {
    return const {'text', 'number', 'phone', 'date'}.contains(type);
  }

  /// Validate all fields. Returns true if valid.
  bool validate() => _formKey.currentState?.validate() ?? false;

  /// Returns the current form values.
  Map<String, dynamic> get values => Map.unmodifiable(_values);

  void _onFieldChanged(String key, dynamic value) {
    _values[key] = value;
    widget.onChanged?.call(Map.unmodifiable(_values));
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupFields(widget.fields);
    final groupNames = grouped.keys.toList();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < groupNames.length; i++) ...[
            _GroupSection(
              title: _humanizeGroup(groupNames[i]),
              initiallyExpanded: i == 0,
              children: [
                for (final field in grouped[groupNames[i]]!)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildField(field),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildField(DynamicFieldDef field) {
    return switch (field.type) {
      'number' => _buildNumberField(field),
      'phone' => _buildPhoneField(field),
      'date' => _buildDateField(field),
      'select' => _buildSelectField(field),
      'boolean' => _buildBooleanField(field),
      _ => _buildTextField(field),
    };
  }

  Widget _buildTextField(DynamicFieldDef field) {
    return TextFormField(
      controller: _textControllers[field.key],
      decoration: InputDecoration(
        labelText: field.label + (field.required ? ' *' : ''),
        hintText: field.hint.isNotEmpty ? field.hint : null,
      ),
      readOnly: widget.readOnly,
      textInputAction: TextInputAction.next,
      onChanged: (v) => _onFieldChanged(field.key, v),
      validator: field.required
          ? (v) => (v == null || v.trim().isEmpty)
                ? '${field.label} is required'
                : null
          : null,
    );
  }

  Widget _buildNumberField(DynamicFieldDef field) {
    return TextFormField(
      controller: _textControllers[field.key],
      decoration: InputDecoration(
        labelText: field.label + (field.required ? ' *' : ''),
        hintText: field.hint.isNotEmpty ? field.hint : null,
      ),
      readOnly: widget.readOnly,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
      textInputAction: TextInputAction.next,
      onChanged: (v) => _onFieldChanged(field.key, double.tryParse(v) ?? v),
      validator: field.required
          ? (v) {
              if (v == null || v.trim().isEmpty) {
                return '${field.label} is required';
              }
              if (double.tryParse(v.trim()) == null) {
                return 'Enter a valid number';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildPhoneField(DynamicFieldDef field) {
    return TextFormField(
      controller: _textControllers[field.key],
      decoration: InputDecoration(
        labelText: field.label + (field.required ? ' *' : ''),
        hintText: field.hint.isNotEmpty ? field.hint : 'e.g. +254712345678',
        prefixIcon: const Icon(Icons.phone, size: 20),
      ),
      readOnly: widget.readOnly,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d+\-\s]')),
      ],
      textInputAction: TextInputAction.next,
      onChanged: (v) => _onFieldChanged(field.key, v),
      validator: field.required
          ? (v) {
              if (v == null || v.trim().isEmpty) {
                return '${field.label} is required';
              }
              final cleaned = v.trim().replaceAll(RegExp(r'[\s\-]'), '');
              if (cleaned.length < 7 || cleaned.length > 15) {
                return 'Enter a valid phone number';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildDateField(DynamicFieldDef field) {
    return TextFormField(
      controller: _textControllers[field.key],
      decoration: InputDecoration(
        labelText: field.label + (field.required ? ' *' : ''),
        hintText: 'YYYY-MM-DD',
        suffixIcon: widget.readOnly
            ? null
            : IconButton(
                icon: const Icon(Icons.calendar_today, size: 20),
                onPressed: () => _pickDate(field),
              ),
      ),
      readOnly: true,
      onTap: widget.readOnly ? null : () => _pickDate(field),
      validator: field.required
          ? (v) => (v == null || v.trim().isEmpty)
                ? '${field.label} is required'
                : null
          : null,
    );
  }

  Future<void> _pickDate(DynamicFieldDef field) async {
    final initial =
        DateTime.tryParse(_textControllers[field.key]?.text ?? '') ??
        DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1920),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      final formatted =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      _textControllers[field.key]?.text = formatted;
      _onFieldChanged(field.key, formatted);
    }
  }

  Widget _buildSelectField(DynamicFieldDef field) {
    final current = _values[field.key]?.toString();
    return DropdownButtonFormField<String>(
      initialValue: (current != null && field.options.contains(current))
          ? current
          : null,
      decoration: InputDecoration(
        labelText: field.label + (field.required ? ' *' : ''),
      ),
      items: field.options
          .map((o) => DropdownMenuItem(value: o, child: Text(o)))
          .toList(),
      onChanged: widget.readOnly
          ? null
          : (v) => setState(() => _onFieldChanged(field.key, v)),
      validator: field.required
          ? (v) =>
                (v == null || v.isEmpty) ? '${field.label} is required' : null
          : null,
    );
  }

  Widget _buildBooleanField(DynamicFieldDef field) {
    final current = _values[field.key] == true;
    return SwitchListTile(
      title: Text(field.label),
      subtitle: field.hint.isNotEmpty ? Text(field.hint) : null,
      value: current,
      onChanged: widget.readOnly
          ? null
          : (v) => setState(() => _onFieldChanged(field.key, v)),
      contentPadding: EdgeInsets.zero,
    );
  }

  String _humanizeGroup(String group) {
    return group
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '',
        )
        .join(' ');
  }
}

/// Collapsible section for grouping fields.
class _GroupSection extends StatelessWidget {
  const _GroupSection({
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
  });

  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ExpansionTile(
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      initiallyExpanded: initiallyExpanded,
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 8),
      children: children,
    );
  }
}

/// Extracts values from a protobuf Struct into a flat map
/// suitable for pre-filling a DynamicForm.
Map<String, dynamic> structToMap(struct_pb.Struct? s) {
  if (s == null) return {};
  final result = <String, dynamic>{};
  for (final entry in s.fields.entries) {
    result[entry.key] = _valueToNative(entry.value);
  }
  return result;
}

dynamic _valueToNative(struct_pb.Value v) {
  if (v.hasStringValue()) return v.stringValue;
  if (v.hasNumberValue()) return v.numberValue;
  if (v.hasBoolValue()) return v.boolValue;
  if (v.hasNullValue()) return null;
  if (v.hasListValue()) {
    return v.listValue.values.map(_valueToNative).toList();
  }
  if (v.hasStructValue()) return structToMap(v.structValue);
  return null;
}

/// Converts a flat map back into a protobuf Struct.
struct_pb.Struct mapToStruct(Map<String, dynamic> map) {
  final s = struct_pb.Struct();
  for (final entry in map.entries) {
    s.fields[entry.key] = _nativeToValue(entry.value);
  }
  return s;
}

struct_pb.Value _nativeToValue(dynamic v) {
  final val = struct_pb.Value();
  if (v == null) {
    val.nullValue = struct_pb.NullValue.NULL_VALUE;
  } else if (v is String) {
    val.stringValue = v;
  } else if (v is num) {
    val.numberValue = v.toDouble();
  } else if (v is bool) {
    val.boolValue = v;
  } else if (v is List) {
    val.listValue = struct_pb.ListValue(values: v.map(_nativeToValue).toList());
  } else if (v is Map<String, dynamic>) {
    val.structValue = mapToStruct(v);
  } else {
    val.stringValue = v.toString();
  }
  return val;
}
