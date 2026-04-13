import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/form_field_card.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../geography/ui/coverage_area_field.dart';
import '../data/org_unit_providers.dart';

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
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _codeCtrl;
  late STATE _selectedState;
  late OrgUnitType _selectedType;
  late String _selectedOrganizationId;
  late String _selectedParentId;
  late String _selectedGeoId;
  String? _selectedGeoName;
  String? _geoErrorText;

  bool get _isEditing => widget.orgUnit != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.orgUnit?.name ?? '');
    _codeCtrl = TextEditingController(text: widget.orgUnit?.code ?? '');
    _selectedState = widget.orgUnit?.state ?? STATE.CREATED;
    _selectedType = widget.orgUnit?.type ?? OrgUnitType.ORG_UNIT_TYPE_BRANCH;
    _selectedOrganizationId =
        widget.fixedOrganizationId ??
        widget.orgUnit?.organizationId ??
        (widget.organizations.isNotEmpty ? widget.organizations.first.id : '');
    _selectedParentId = widget.fixedParentId ?? widget.orgUnit?.parentId ?? '';
    _selectedGeoId = widget.orgUnit?.geoId ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
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
        constraints: const BoxConstraints(maxWidth: 680),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                child: Text(
                  _isEditing ? 'Edit Org Unit' : 'New Org Unit',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                  child: Column(
                    children: [
                      if (widget.fixedOrganizationId == null)
                        FormFieldCard(
                          label: 'Organization',
                          description:
                              'The organization this org unit belongs to.',
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedOrganizationId.isNotEmpty
                                ? _selectedOrganizationId
                                : null,
                            items: widget.organizations
                                .map(
                                  (org) => DropdownMenuItem(
                                    value: org.id,
                                    child: Text(org.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) => setState(() {
                              _selectedOrganizationId = value ?? '';
                              _selectedParentId = '';
                            }),
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? 'Select an organization'
                                : null,
                          ),
                        ),
                      FormFieldCard(
                        label: 'Type',
                        description:
                            'Choose the hierarchy level this org unit represents.',
                        child: DropdownButtonFormField<OrgUnitType>(
                          initialValue: _selectedType,
                          items: editableOrgUnitTypes
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(orgUnitTypeLabel(type)),
                                ),
                              )
                              .toList(),
                          onChanged: (value) => setState(() {
                            _selectedType =
                                value ?? OrgUnitType.ORG_UNIT_TYPE_BRANCH;
                          }),
                        ),
                      ),
                      FormFieldCard(
                        label: 'Parent Unit',
                        description:
                            'Optional. Leave empty to create a top-level org unit directly under the organization.',
                        child: parentUnitsAsync == null
                            ? const SizedBox.shrink()
                            : parentUnitsAsync.when(
                                data: (units) {
                                  final selectable = units
                                      .where(
                                        (unit) => unit.id != widget.orgUnit?.id,
                                      )
                                      .toList();
                                  final hasSelected =
                                      _selectedParentId.isEmpty ||
                                      selectable.any(
                                        (u) => u.id == _selectedParentId,
                                      );
                                  final value =
                                      hasSelected &&
                                          _selectedParentId.isNotEmpty
                                      ? _selectedParentId
                                      : null;
                                  return DropdownButtonFormField<String>(
                                    initialValue: value,
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
                                            () =>
                                                _selectedParentId = value ?? '',
                                          ),
                                  );
                                },
                                loading: () => const LinearProgressIndicator(),
                                error: (error, _) => Text(
                                  'Failed to load parent units: $error',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ),
                      ),
                      FormFieldCard(
                        label: 'Name',
                        description: 'User-facing display name.',
                        child: TextFormField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(
                            hintText: 'e.g. Central Region',
                          ),
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                              ? 'Enter a name'
                              : null,
                        ),
                      ),
                      FormFieldCard(
                        label: 'Code',
                        description:
                            'Short unique code used across the platform.',
                        child: TextFormField(
                          controller: _codeCtrl,
                          decoration: const InputDecoration(
                            hintText: 'e.g. central-region',
                          ),
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                              ? 'Enter a code'
                              : null,
                        ),
                      ),
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
                      FormFieldCard(
                        label: 'State',
                        description:
                            'Initial lifecycle state for this org unit.',
                        child: DropdownButtonFormField<STATE>(
                          initialValue: _selectedState,
                          items: const [
                            DropdownMenuItem(
                              value: STATE.CREATED,
                              child: Text('Created'),
                            ),
                            DropdownMenuItem(
                              value: STATE.ACTIVE,
                              child: Text('Active'),
                            ),
                            DropdownMenuItem(
                              value: STATE.INACTIVE,
                              child: Text('Inactive'),
                            ),
                          ],
                          onChanged: (value) => setState(
                            () => _selectedState = value ?? STATE.CREATED,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _submit,
                      child: Text(
                        _isEditing ? 'Save Changes' : 'Create Org Unit',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGeoId.isEmpty) {
      setState(() => _geoErrorText = 'Coverage area is required');
      return;
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
      properties: widget.orgUnit?.properties,
    );

    Navigator.of(context).pop(orgUnit);
  }
}
