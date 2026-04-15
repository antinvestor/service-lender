import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/form_field_card.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/google/protobuf/struct.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../geography/ui/coverage_area_field.dart';
import '../data/org_unit_providers.dart';
import 'organizations_screen.dart';

String orgUnitTypeLabel(OrgUnitType type) {
  switch (type) {
    case OrgUnitType.ORG_UNIT_TYPE_REGION:
      return 'Region';
    case OrgUnitType.ORG_UNIT_TYPE_ZONE:
      return 'Zone';
    case OrgUnitType.ORG_UNIT_TYPE_AREA:
      return 'Area';
    case OrgUnitType.ORG_UNIT_TYPE_CLUSTER:
      return 'Cluster';
    case OrgUnitType.ORG_UNIT_TYPE_BRANCH:
      return 'Branch';
    case OrgUnitType.ORG_UNIT_TYPE_OTHER:
      return 'Other';
    case OrgUnitType.ORG_UNIT_TYPE_UNSPECIFIED:
      return 'Unspecified';
  }
  return 'Unspecified';
}

const editableOrgUnitTypes = <OrgUnitType>[
  OrgUnitType.ORG_UNIT_TYPE_REGION,
  OrgUnitType.ORG_UNIT_TYPE_ZONE,
  OrgUnitType.ORG_UNIT_TYPE_AREA,
  OrgUnitType.ORG_UNIT_TYPE_CLUSTER,
  OrgUnitType.ORG_UNIT_TYPE_BRANCH,
  OrgUnitType.ORG_UNIT_TYPE_OTHER,
];

class OrgUnitFormDialog extends ConsumerStatefulWidget {
  const OrgUnitFormDialog({
    super.key,
    this.orgUnit,
    required this.organizations,
    this.fixedOrganizationId,
    this.fixedParentId,
  });

  final OrgUnitObject? orgUnit;
  final List<OrganizationObject> organizations;
  final String? fixedOrganizationId;
  final String? fixedParentId;

  @override
  ConsumerState<OrgUnitFormDialog> createState() => _OrgUnitFormDialogState();
}

class _OrgUnitFormDialogState extends ConsumerState<OrgUnitFormDialog> {
  static const _stepCount = 3;
  static const _stepLabels = ['Details', 'Contacts', 'Location'];

  final _formKeys = List.generate(_stepCount, (_) => GlobalKey<FormState>());
  int _currentStep = 0;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _descriptionCtrl;
  late STATE _selectedState;
  late OrgUnitType _selectedType;
  late String _selectedOrganizationId;
  late String _selectedParentId;
  late String _selectedGeoId;
  String? _selectedGeoName;
  String? _geoErrorText;

  // Contacts
  ContactPurpose _contactPurpose = ContactPurpose.general;
  ContactType _contactType = ContactType.email;
  late final TextEditingController _contactValueCtrl;
  final List<OrganizationContact> _contacts = [];

  // Location
  late final TextEditingController _streetCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _countryCtrl;
  late final TextEditingController _postalCodeCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;

  bool get _isEditing => widget.orgUnit != null;

  String _propStr(String key) {
    if (widget.orgUnit == null || !widget.orgUnit!.hasProperties()) return '';
    final field = widget.orgUnit!.properties.fields[key];
    if (field == null || !field.hasStringValue()) return '';
    return field.stringValue;
  }

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.orgUnit?.name ?? '');
    _codeCtrl = TextEditingController(text: widget.orgUnit?.code ?? '');
    _descriptionCtrl = TextEditingController(text: _propStr('description'));
    _selectedState = widget.orgUnit?.state ?? STATE.CREATED;
    _selectedType = widget.orgUnit?.type ?? OrgUnitType.ORG_UNIT_TYPE_BRANCH;
    _selectedOrganizationId =
        widget.fixedOrganizationId ??
        widget.orgUnit?.organizationId ??
        (widget.organizations.isNotEmpty ? widget.organizations.first.id : '');
    _selectedParentId = widget.fixedParentId ?? widget.orgUnit?.parentId ?? '';
    _selectedGeoId = widget.orgUnit?.geoId ?? '';
    _contactValueCtrl = TextEditingController();
    _streetCtrl = TextEditingController(text: _propStr('address_street'));
    _cityCtrl = TextEditingController(text: _propStr('address_city'));
    _countryCtrl = TextEditingController(text: _propStr('address_country'));
    _postalCodeCtrl = TextEditingController(text: _propStr('address_postal_code'));
    _phoneCtrl = TextEditingController(text: _propStr('phone'));
    _emailCtrl = TextEditingController(text: _propStr('email'));

    // Load existing contacts
    if (widget.orgUnit != null && widget.orgUnit!.hasProperties()) {
      final field = widget.orgUnit!.properties.fields['contacts'];
      if (field != null && field.hasListValue()) {
        for (final v in field.listValue.values) {
          if (!v.hasStructValue()) continue;
          final m = <String, dynamic>{};
          for (final entry in v.structValue.fields.entries) {
            if (entry.value.hasStringValue()) m[entry.key] = entry.value.stringValue;
          }
          final contact = OrganizationContact.fromMap(m);
          if (contact != null) _contacts.add(contact);
        }
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _descriptionCtrl.dispose();
    _contactValueCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _countryCtrl.dispose();
    _postalCodeCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (!_formKeys[_currentStep].currentState!.validate()) return;
    if (_currentStep < _stepCount - 1) {
      setState(() => _currentStep++);
    } else {
      _submit();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  void _submit() {
    if (!_formKeys[_currentStep].currentState!.validate()) return;
    if (_selectedGeoId.isEmpty) {
      setState(() => _geoErrorText = 'Coverage area is required');
      return;
    }

    // Build properties with extra metadata
    final existingFields = widget.orgUnit?.hasProperties() == true
        ? Map<String, Value>.from(widget.orgUnit!.properties.fields)
        : <String, Value>{};

    final desc = _descriptionCtrl.text.trim();
    if (desc.isNotEmpty) {
      existingFields['description'] = Value(stringValue: desc);
    }
    final street = _streetCtrl.text.trim();
    if (street.isNotEmpty) {
      existingFields['address_street'] = Value(stringValue: street);
    }
    final city = _cityCtrl.text.trim();
    if (city.isNotEmpty) {
      existingFields['address_city'] = Value(stringValue: city);
    }
    final country = _countryCtrl.text.trim();
    if (country.isNotEmpty) {
      existingFields['address_country'] = Value(stringValue: country);
    }
    final postal = _postalCodeCtrl.text.trim();
    if (postal.isNotEmpty) {
      existingFields['address_postal_code'] = Value(stringValue: postal);
    }
    final phone = _phoneCtrl.text.trim();
    if (phone.isNotEmpty) {
      existingFields['phone'] = Value(stringValue: phone);
    }
    final email = _emailCtrl.text.trim();
    if (email.isNotEmpty) {
      existingFields['email'] = Value(stringValue: email);
    }
    if (_contacts.isNotEmpty) {
      existingFields['contacts'] = Value(
        listValue: ListValue(
          values: _contacts
              .map((c) => Value(
                    structValue: Struct(fields: {
                      'purpose': Value(stringValue: c.purpose.name),
                      'type': Value(stringValue: c.type.name),
                      'value': Value(stringValue: c.value),
                    }),
                  ))
              .toList(),
        ),
      );
    }

    final orgUnit = OrgUnitObject(
      id: widget.orgUnit?.id,
      organizationId: _selectedOrganizationId,
      parentId: _selectedParentId,
      partitionId: widget.orgUnit?.partitionId ?? '',
      name: _nameCtrl.text.trim(),
      code: _codeCtrl.text.trim(),
      geoId: _selectedGeoId,
      state: _selectedState,
      type: _selectedType,
      clientId: widget.orgUnit?.clientId ?? '',
      properties: existingFields.isNotEmpty ? Struct(fields: existingFields) : null,
    );

    Navigator.of(context).pop(orgUnit);
  }

  void _addContact() {
    final value = _contactValueCtrl.text.trim();
    if (value.isEmpty) return;
    setState(() {
      _contacts.add(OrganizationContact(
        purpose: _contactPurpose,
        type: _contactType,
        value: value,
      ));
      _contactValueCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parentUnitsAsync = _selectedOrganizationId.isEmpty
        ? null
        : ref.watch(
            orgUnitListProvider(
              organizationId: _selectedOrganizationId,
              query: '',
            ),
          );

    return Dialog(
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 680),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outlineVariant.withAlpha(60),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.account_tree_outlined,
                          color: theme.colorScheme.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _isEditing ? 'Edit Org Unit' : 'New Org Unit',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Step indicator
                  Row(
                    children: List.generate(_stepCount, (i) {
                      final isActive = i == _currentStep;
                      final isDone = i < _currentStep;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: i < _stepCount - 1 ? 8 : 0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: isDone
                                          ? theme.colorScheme.primary
                                          : isActive
                                              ? theme.colorScheme
                                                  .primaryContainer
                                              : theme.colorScheme
                                                  .surfaceContainerHighest,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: isDone
                                          ? Icon(Icons.check,
                                              size: 14,
                                              color: theme
                                                  .colorScheme.onPrimary)
                                          : Text(
                                              '${i + 1}',
                                              style: theme
                                                  .textTheme.labelSmall
                                                  ?.copyWith(
                                                color: isActive
                                                    ? theme
                                                        .colorScheme.primary
                                                    : theme.colorScheme
                                                        .onSurfaceVariant,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _stepLabels[i],
                                    style:
                                        theme.textTheme.labelSmall?.copyWith(
                                      color: isActive
                                          ? theme.colorScheme.primary
                                          : theme
                                              .colorScheme.onSurfaceVariant,
                                      fontWeight: isActive
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: isDone
                                    ? 1.0
                                    : (isActive ? 0.5 : 0.0),
                                backgroundColor: theme
                                    .colorScheme.surfaceContainerHighest,
                                color: theme.colorScheme.primary,
                                minHeight: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Body
            Flexible(
              child: IndexedStack(
                index: _currentStep,
                children: [
                  _buildStep1(theme, parentUnitsAsync),
                  _buildStep2Contacts(theme),
                  _buildStep3Location(theme),
                ],
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outlineVariant.withAlpha(60),
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    TextButton.icon(
                      onPressed: _prevStep,
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Back'),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _nextStep,
                    icon: Icon(
                      _currentStep < _stepCount - 1
                          ? Icons.arrow_forward
                          : (_isEditing ? Icons.save : Icons.add),
                      size: 18,
                    ),
                    label: Text(
                      _currentStep < _stepCount - 1
                          ? 'Next'
                          : (_isEditing ? 'Save Changes' : 'Create'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 1: Details
  Widget _buildStep1(ThemeData theme, AsyncValue<List<OrgUnitObject>>? parentUnitsAsync) {
    return Form(
      key: _formKeys[0],
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Column(
          children: [
            if (widget.fixedOrganizationId == null)
              FormFieldCard(
                label: 'Organization',
                description: 'The organization this org unit belongs to.',
                isRequired: true,
                child: DropdownButtonFormField<String>(
                  value: _selectedOrganizationId.isNotEmpty
                      ? _selectedOrganizationId
                      : null,
                  items: widget.organizations
                      .map((org) => DropdownMenuItem(
                            value: org.id,
                            child: Text(org.name),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() {
                    _selectedOrganizationId = value ?? '';
                    _selectedParentId = '';
                  }),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Select an organization'
                      : null,
                ),
              ),
            FormFieldCard(
              label: 'Type',
              description: 'Hierarchy level this org unit represents.',
              isRequired: true,
              child: DropdownButtonFormField<OrgUnitType>(
                value: _selectedType,
                items: editableOrgUnitTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(orgUnitTypeLabel(type)),
                        ))
                    .toList(),
                onChanged: (value) => setState(() {
                  _selectedType = value ?? OrgUnitType.ORG_UNIT_TYPE_BRANCH;
                }),
              ),
            ),
            FormFieldCard(
              label: 'Parent Unit',
              description: 'Leave empty for top-level org unit.',
              child: parentUnitsAsync == null
                  ? const SizedBox.shrink()
                  : parentUnitsAsync.when(
                      data: (units) {
                        final selectable = units
                            .where((unit) => unit.id != widget.orgUnit?.id)
                            .toList();
                        final hasSelected = _selectedParentId.isEmpty ||
                            selectable.any((u) => u.id == _selectedParentId);
                        final value =
                            hasSelected && _selectedParentId.isNotEmpty
                                ? _selectedParentId
                                : null;
                        return DropdownButtonFormField<String>(
                          value: value,
                          items: [
                            const DropdownMenuItem<String>(
                              value: '',
                              child: Text('No Parent'),
                            ),
                            ...selectable.map(
                              (unit) => DropdownMenuItem(
                                value: unit.id,
                                child: Text(
                                  '${orgUnitTypeLabel(unit.type)} - ${unit.name}',
                                ),
                              ),
                            ),
                          ],
                          onChanged: widget.fixedParentId != null
                              ? null
                              : (value) => setState(
                                  () => _selectedParentId = value ?? ''),
                        );
                      },
                      loading: () => const LinearProgressIndicator(),
                      error: (error, _) => Text('Failed: $error'),
                    ),
            ),
            FormFieldCard(
              label: 'Name',
              description: 'Display name for this org unit.',
              isRequired: true,
              child: TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  hintText: 'e.g. Central Region',
                  prefixIcon: Icon(Icons.label_outlined),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Enter a name'
                    : null,
              ),
            ),
            FormFieldCard(
              label: 'Code',
              description: 'Short unique code for reports and integrations.',
              isRequired: true,
              child: TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(
                  hintText: 'e.g. central-region',
                  prefixIcon: Icon(Icons.tag),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Enter a code'
                    : null,
              ),
            ),
            FormFieldCard(
              label: 'Description',
              description: 'Brief description of this unit.',
              child: TextFormField(
                controller: _descriptionCtrl,
                decoration: const InputDecoration(
                  hintText: 'What does this org unit cover?',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                maxLines: 2,
              ),
            ),
            FormFieldCard(
              label: 'State',
              description: 'Lifecycle state of this org unit.',
              child: DropdownButtonFormField<STATE>(
                value: _selectedState,
                items: const [
                  DropdownMenuItem(value: STATE.CREATED, child: Text('Created')),
                  DropdownMenuItem(value: STATE.ACTIVE, child: Text('Active')),
                  DropdownMenuItem(
                      value: STATE.INACTIVE, child: Text('Inactive')),
                ],
                onChanged: (value) =>
                    setState(() => _selectedState = value ?? STATE.CREATED),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 2: Contacts
  Widget _buildStep2Contacts(ThemeData theme) {
    return Form(
      key: _formKeys[1],
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add primary contact details and department-specific contacts.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            FormFieldCard(
              label: 'Primary Phone',
              child: TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(
                  hintText: '+254 700 000 000',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
            FormFieldCard(
              label: 'Primary Email',
              child: TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  hintText: 'branch@org.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const Divider(height: 24),
            Text(
              'Additional Contacts',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<ContactPurpose>(
                    value: _contactPurpose,
                    decoration: const InputDecoration(
                      labelText: 'Purpose',
                      isDense: true,
                    ),
                    items: ContactPurpose.values
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(contactPurposeLabel(p)),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _contactPurpose = v);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<ContactType>(
                    value: _contactType,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: ContactType.email, child: Text('Email')),
                      DropdownMenuItem(
                          value: ContactType.phone, child: Text('Phone')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _contactType = v);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _contactValueCtrl,
                    decoration: InputDecoration(
                      labelText: _contactType == ContactType.email
                          ? 'Email'
                          : 'Phone',
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _addContact,
                  icon: const Icon(Icons.add, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_contacts.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No additional contacts',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _contacts.asMap().entries.map((entry) {
                  final i = entry.key;
                  final c = entry.value;
                  return Chip(
                    avatar: Icon(
                      c.type == ContactType.email
                          ? Icons.email
                          : Icons.phone,
                      size: 16,
                    ),
                    label: Text(
                      '${contactPurposeLabel(c.purpose)}: ${c.value}',
                    ),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => setState(() => _contacts.removeAt(i)),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  // Step 3: Location
  Widget _buildStep3Location(ThemeData theme) {
    return Form(
      key: _formKeys[2],
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Physical Address & Coverage',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            FormFieldCard(
              label: 'Street Address',
              child: TextFormField(
                controller: _streetCtrl,
                decoration: const InputDecoration(
                  hintText: 'e.g. 123 Kenyatta Avenue',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: FormFieldCard(
                    label: 'City',
                    child: TextFormField(
                      controller: _cityCtrl,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Nairobi',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FormFieldCard(
                    label: 'Country',
                    child: TextFormField(
                      controller: _countryCtrl,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Kenya',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            FormFieldCard(
              label: 'Postal Code',
              child: TextFormField(
                controller: _postalCodeCtrl,
                decoration: const InputDecoration(
                  hintText: 'e.g. 00100',
                ),
              ),
            ),
            const Divider(height: 32),
            CoverageAreaField(
              selectedAreaId: _selectedGeoId,
              selectedAreaName: _selectedGeoName,
              errorText: _geoErrorText,
              onSelected: (area) => setState(() {
                _selectedGeoId = area?.id ?? '';
                _selectedGeoName = area?.name;
                _geoErrorText = null;
              }),
            ),
          ],
        ),
      ),
    );
  }
}
