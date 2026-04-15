import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/api/file_upload_helper.dart';
import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/error_helpers.dart';
import '../../../core/widgets/form_field_card.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/google/protobuf/struct.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../geography/ui/coverage_area_field.dart';
import '../data/organization_providers.dart';
import 'organization_detail_screen.dart';

// ---------------------------------------------------------------------------
// Public helpers
// ---------------------------------------------------------------------------

String orgTypeLabel(OrganizationType type) => switch (type) {
      OrganizationType.ORGANIZATION_TYPE_UNSPECIFIED => 'Not specified',
      OrganizationType.ORGANIZATION_TYPE_BANK => 'Bank',
      OrganizationType.ORGANIZATION_TYPE_MICROFINANCE => 'Microfinance',
      OrganizationType.ORGANIZATION_TYPE_SACCO => 'SACCO',
      OrganizationType.ORGANIZATION_TYPE_FINTECH => 'Fintech',
      OrganizationType.ORGANIZATION_TYPE_COOPERATIVE => 'Cooperative',
      _ => type.name,
    };

// ---------------------------------------------------------------------------
// Contact model
// ---------------------------------------------------------------------------

enum ContactPurpose { general, support, billing, admin, hr, technical }

enum ContactType { email, phone }

class OrganizationContact {
  const OrganizationContact({
    required this.purpose,
    required this.type,
    required this.value,
  });

  final ContactPurpose purpose;
  final ContactType type;
  final String value;

  Map<String, String> toMap() => {
        'purpose': purpose.name,
        'type': type.name,
        'value': value,
      };

  static OrganizationContact? fromMap(Map<String, dynamic> map) {
    final purposeStr = map['purpose'] as String?;
    final typeStr = map['type'] as String?;
    final value = map['value'] as String?;
    if (purposeStr == null || typeStr == null || value == null) return null;
    final purpose = ContactPurpose.values.where((e) => e.name == purposeStr);
    final type = ContactType.values.where((e) => e.name == typeStr);
    if (purpose.isEmpty || type.isEmpty) return null;
    return OrganizationContact(
      purpose: purpose.first,
      type: type.first,
      value: value,
    );
  }
}

String contactPurposeLabel(ContactPurpose p) => switch (p) {
      ContactPurpose.general => 'General',
      ContactPurpose.support => 'Support',
      ContactPurpose.billing => 'Billing',
      ContactPurpose.admin => 'Admin',
      ContactPurpose.hr => 'HR',
      ContactPurpose.technical => 'Technical',
    };

// ---------------------------------------------------------------------------
// Organizations list screen
// ---------------------------------------------------------------------------

class OrganizationsScreen extends ConsumerStatefulWidget {
  const OrganizationsScreen({super.key});

  @override
  ConsumerState<OrganizationsScreen> createState() =>
      _OrganizationsScreenState();
}

class _OrganizationsScreenState extends ConsumerState<OrganizationsScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final organizationsAsync = ref.watch(organizationListProvider(_query));
    final canManage = ref.watch(canManageOrganizationsProvider).value ?? false;

    return EntityListPage<OrganizationObject>(
      title: 'Organizations',
      icon: Icons.account_balance_outlined,
      items: organizationsAsync.value ?? [],
      isLoading: organizationsAsync.isLoading,
      error: organizationsAsync.hasError
          ? organizationsAsync.error.toString()
          : null,
      onRetry: () => ref.invalidate(organizationListProvider(_query)),
      searchHint: 'Search organizations...',
      onSearchChanged: _onSearchChanged,
      actionLabel: 'Add Organization',
      canAction: canManage,
      onAction: () => _showOrganizationDialog(context),
      idOf: (org) => org.id,
      detailBuilder: (id) => OrganizationDetailScreen(organizationId: id),
      onNavigate: (id) => context.go('/organization/organizations/$id'),
      emptyDetailMessage: 'Select an organization to view details',
      itemBuilder: (context, organization) =>
          _OrganizationCard(organization: organization),
    );
  }

  void _showOrganizationDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => OrganizationFormDialog(
        onSave: (org, {logoBytes, logoFileName, contacts, description, domainName, street, city, country, postalCode}) async {
          try {
            // Upload logo if provided
            String? logoContentUri;
            if (logoBytes != null && logoFileName != null) {
              logoContentUri = await uploadPublicImage(
                ref,
                logoBytes,
                logoFileName,
              );
            }

            // Merge metadata into properties
            final existingFields = org.hasProperties()
                ? Map<String, Value>.from(org.properties.fields)
                : <String, Value>{};
            if (description != null && description.isNotEmpty) {
              existingFields['description'] =
                  Value(stringValue: description);
            }
            if (domainName != null && domainName.isNotEmpty) {
              existingFields['domain_name'] =
                  Value(stringValue: domainName);
            }
            if (street != null && street.isNotEmpty) {
              existingFields['address_street'] =
                  Value(stringValue: street);
            }
            if (city != null && city.isNotEmpty) {
              existingFields['address_city'] =
                  Value(stringValue: city);
            }
            if (country != null && country.isNotEmpty) {
              existingFields['address_country'] =
                  Value(stringValue: country);
            }
            if (postalCode != null && postalCode.isNotEmpty) {
              existingFields['address_postal_code'] =
                  Value(stringValue: postalCode);
            }
            if (contacts != null && contacts.isNotEmpty) {
              existingFields['contacts'] = Value(
                listValue: ListValue(
                  values: contacts
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
            if (logoContentUri != null) {
              existingFields['logo_content_uri'] =
                  Value(stringValue: logoContentUri);
            }
            if (existingFields.isNotEmpty) {
              org.properties = Struct(fields: existingFields);
            }

            await ref.read(organizationProvider.notifier).save(org);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Organization created successfully'),
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(friendlyError(e)),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
            rethrow;
          }
        },
      ),
    );
  }
}

class _OrganizationCard extends StatelessWidget {
  const _OrganizationCard({required this.organization});

  final OrganizationObject organization;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoUri = _getLogoUrl();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          backgroundImage: logoUri.isNotEmpty ? NetworkImage(logoUri) : null,
          child: logoUri.isNotEmpty
              ? null
              : Icon(
                  Icons.account_balance,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
        ),
        title: Text(
          organization.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${orgTypeLabel(organization.organizationType)} \u00b7 ${organization.code}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(160),
          ),
        ),
        trailing: StateBadge(state: organization.state),
      ),
    );
  }

  String _getLogoUrl() {
    if (!organization.hasProperties()) return '';
    final field = organization.properties.fields['logo_content_uri'];
    if (field == null || !field.hasStringValue()) return '';
    final uri = field.stringValue;
    if (uri.isEmpty) return '';
    return mxcToHttpUrl(uri);
  }
}

// ---------------------------------------------------------------------------
// 3-step organization wizard dialog
// ---------------------------------------------------------------------------

class OrganizationFormDialog extends StatefulWidget {
  const OrganizationFormDialog({
    super.key,
    this.organization,
    required this.onSave,
  });

  final OrganizationObject? organization;
  final Future<void> Function(
    OrganizationObject organization, {
    Uint8List? logoBytes,
    String? logoFileName,
    List<OrganizationContact>? contacts,
    String? description,
    String? domainName,
    String? street,
    String? city,
    String? country,
    String? postalCode,
  }) onSave;

  @override
  State<OrganizationFormDialog> createState() => _OrganizationFormDialogState();
}

class _OrganizationFormDialogState extends State<OrganizationFormDialog> {
  static const _stepCount = 3;
  static const _stepLabels = ['Details', 'Contacts', 'Location'];

  final _formKeys = List.generate(_stepCount, (_) => GlobalKey<FormState>());

  int _currentStep = 0;
  bool _saving = false;
  bool _isPickingLogo = false;

  bool get _isEditing => widget.organization != null;

  // -- Step 1: Details
  late final TextEditingController _nameCtrl;
  late final TextEditingController _codeCtrl;
  late OrganizationType _orgType;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _domainCtrl;
  String? _logoContentUri;
  Uint8List? _logoBytes;
  String? _logoFileName;
  late STATE _selectedState;

  // -- Step 2: Contacts
  ContactPurpose _contactPurpose = ContactPurpose.general;
  ContactType _contactType = ContactType.email;
  late final TextEditingController _contactValueCtrl;
  final List<OrganizationContact> _contacts = [];

  // -- Step 3: Location
  late final TextEditingController _streetCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _countryCtrl;
  late final TextEditingController _postalCodeCtrl;
  late String _selectedGeoId;
  String? _selectedGeoName;
  String? _geoErrorText;

  static const _orgTypes = [
    OrganizationType.ORGANIZATION_TYPE_UNSPECIFIED,
    OrganizationType.ORGANIZATION_TYPE_BANK,
    OrganizationType.ORGANIZATION_TYPE_MICROFINANCE,
    OrganizationType.ORGANIZATION_TYPE_SACCO,
    OrganizationType.ORGANIZATION_TYPE_COOPERATIVE,
    OrganizationType.ORGANIZATION_TYPE_FINTECH,
  ];

  @override
  void initState() {
    super.initState();
    final props = widget.organization?.properties;
    _nameCtrl = TextEditingController(text: widget.organization?.name ?? '');
    _codeCtrl = TextEditingController(text: widget.organization?.code ?? '');
    _orgType = widget.organization?.organizationType ??
        OrganizationType.ORGANIZATION_TYPE_UNSPECIFIED;
    _selectedState = widget.organization?.state ?? STATE.CREATED;
    _descriptionCtrl =
        TextEditingController(text: _propStr(props, 'description'));
    _domainCtrl =
        TextEditingController(text: _propStr(props, 'domain_name'));
    _logoContentUri = _propStr(props, 'logo_content_uri');
    _contactValueCtrl = TextEditingController();
    _streetCtrl =
        TextEditingController(text: _propStr(props, 'address_street'));
    _cityCtrl =
        TextEditingController(text: _propStr(props, 'address_city'));
    _countryCtrl =
        TextEditingController(text: _propStr(props, 'address_country'));
    _postalCodeCtrl =
        TextEditingController(text: _propStr(props, 'address_postal_code'));
    _selectedGeoId = widget.organization?.geoId ?? '';

    // Load existing contacts
    if (props != null) {
      final field = props.fields['contacts'];
      if (field != null && field.hasListValue()) {
        for (final v in field.listValue.values) {
          if (!v.hasStructValue()) continue;
          final m = <String, dynamic>{};
          for (final entry in v.structValue.fields.entries) {
            if (entry.value.hasStringValue()) {
              m[entry.key] = entry.value.stringValue;
            }
          }
          final contact = OrganizationContact.fromMap(m);
          if (contact != null) _contacts.add(contact);
        }
      }
    }
  }

  String _propStr(Struct? props, String key) {
    if (props == null) return '';
    final field = props.fields[key];
    if (field == null || !field.hasStringValue()) return '';
    return field.stringValue;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _descriptionCtrl.dispose();
    _domainCtrl.dispose();
    _contactValueCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _countryCtrl.dispose();
    _postalCodeCtrl.dispose();
    super.dispose();
  }

  // -- Logo picker
  Future<void> _pickLogo() async {
    setState(() => _isPickingLogo = true);
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      setState(() {
        _logoBytes = bytes;
        _logoFileName = picked.name;
      });
    } finally {
      if (mounted) setState(() => _isPickingLogo = false);
    }
  }

  // -- Navigation
  void _nextStep() {
    if (!_formKeys[_currentStep].currentState!.validate()) return;
    if (_currentStep == 2) {
      // Validate geo
      if (_selectedGeoId.isEmpty) {
        setState(() => _geoErrorText = 'Coverage area is required');
        return;
      }
    }
    if (_currentStep < _stepCount - 1) {
      setState(() => _currentStep++);
    } else {
      _submit();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  Future<void> _submit() async {
    setState(() => _saving = true);

    final organization = OrganizationObject(
      id: widget.organization?.id,
      name: _nameCtrl.text.trim(),
      code: _codeCtrl.text.trim(),
      state: _selectedState,
      organizationType: _orgType,
      partitionId: widget.organization?.partitionId ?? '',
      geoId: _selectedGeoId,
    );

    // Preserve backend-managed fields when editing.
    if (widget.organization != null) {
      if (widget.organization!.hasProfileId()) {
        organization.profileId = widget.organization!.profileId;
      }
      if (widget.organization!.hasProperties()) {
        organization.properties = widget.organization!.properties;
      }
    }

    try {
      await widget.onSave(
        organization,
        logoBytes: _logoBytes,
        logoFileName: _logoFileName,
        contacts: _contacts,
        description: _descriptionCtrl.text.trim(),
        domainName: _domainCtrl.text.trim(),
        street: _streetCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        country: _countryCtrl.text.trim(),
        postalCode: _postalCodeCtrl.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 680),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // -- Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
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
                          Icons.account_balance,
                          color: theme.colorScheme.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _isEditing ? 'Edit Organization' : 'New Organization',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _saving ? null : () => Navigator.pop(context),
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
                          padding: EdgeInsets.only(right: i < _stepCount - 1 ? 8 : 0),
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
                                              ? theme.colorScheme.primaryContainer
                                              : theme.colorScheme.surfaceContainerHighest,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: isDone
                                          ? Icon(Icons.check,
                                              size: 14, color: theme.colorScheme.onPrimary)
                                          : Text(
                                              '${i + 1}',
                                              style: theme.textTheme.labelSmall?.copyWith(
                                                color: isActive
                                                    ? theme.colorScheme.primary
                                                    : theme.colorScheme.onSurfaceVariant,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _stepLabels[i],
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: isActive
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.onSurfaceVariant,
                                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: isDone ? 1.0 : (isActive ? 0.5 : 0.0),
                                backgroundColor: theme.colorScheme.surfaceContainerHighest,
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
            // -- Body
            Flexible(
              child: IndexedStack(
                index: _currentStep,
                children: [
                  _buildStep1Details(theme),
                  _buildStep2Contacts(theme),
                  _buildStep3Location(theme),
                ],
              ),
            ),
            // -- Actions
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
                      onPressed: _saving ? null : _prevStep,
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Back'),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: _saving ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _saving ? null : _nextStep,
                    icon: _saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            _currentStep < _stepCount - 1
                                ? Icons.arrow_forward
                                : (_isEditing ? Icons.save : Icons.add),
                            size: 18,
                          ),
                    label: Text(
                      _currentStep < _stepCount - 1
                          ? 'Next'
                          : (_isEditing ? 'Update' : 'Create'),
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

  // -- Step 1: Details
  Widget _buildStep1Details(ThemeData theme) {
    return Form(
      key: _formKeys[0],
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Column(
          children: [
            // Logo picker
            Center(
              child: GestureDetector(
                onTap: _isPickingLogo ? null : _pickLogo,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      backgroundImage: _logoBytes != null
                          ? MemoryImage(_logoBytes!)
                          : (_logoContentUri != null && _logoContentUri!.isNotEmpty
                              ? NetworkImage(mxcToHttpUrl(_logoContentUri!))
                              : null),
                      child: _logoBytes == null &&
                              (_logoContentUri == null || _logoContentUri!.isEmpty)
                          ? Icon(Icons.add_a_photo,
                              size: 28, color: theme.colorScheme.primary)
                          : null,
                    ),
                    if (_isPickingLogo)
                      const Positioned.fill(
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.camera_alt,
                          size: 14, color: theme.colorScheme.onPrimary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to upload organization logo',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            FormFieldCard(
              label: 'Organization Name',
              description: 'The official registered name.',
              isRequired: true,
              child: TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  hintText: 'e.g. Stawi Microfinance Ltd',
                  prefixIcon: Icon(Icons.business),
                ),
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Organization name is required'
                    : null,
              ),
            ),
            FormFieldCard(
              label: 'Short Code',
              description: 'Unique identifier for reports and integrations.',
              isRequired: true,
              child: TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(
                  hintText: 'e.g. STAWI',
                  prefixIcon: Icon(Icons.tag),
                ),
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Code is required'
                    : null,
              ),
            ),
            FormFieldCard(
              label: 'Organization Type',
              description: 'Regulatory category determining compliance rules.',
              child: DropdownButtonFormField<OrganizationType>(
                value: _orgType,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _orgTypes
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(orgTypeLabel(t)),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _orgType = v);
                },
              ),
            ),
            FormFieldCard(
              label: 'Description',
              description: 'Brief description of this organization.',
              child: TextFormField(
                controller: _descriptionCtrl,
                decoration: const InputDecoration(
                  hintText: 'What does this organization do?',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                maxLines: 3,
                minLines: 2,
              ),
            ),
            FormFieldCard(
              label: 'Domain Name',
              description: 'Primary web domain, if any.',
              child: TextFormField(
                controller: _domainCtrl,
                decoration: const InputDecoration(
                  hintText: 'e.g. stawi.org',
                  prefixIcon: Icon(Icons.language),
                ),
              ),
            ),
            FormFieldCard(
              label: 'Status',
              description: 'Lifecycle state of the organization.',
              isRequired: true,
              child: DropdownButtonFormField<STATE>(
                value: _selectedState,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: STATE.CREATED, child: Text('Created')),
                  DropdownMenuItem(value: STATE.CHECKED, child: Text('Checked')),
                  DropdownMenuItem(value: STATE.ACTIVE, child: Text('Active')),
                  DropdownMenuItem(value: STATE.INACTIVE, child: Text('Inactive')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _selectedState = v);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -- Step 2: Contacts
  Widget _buildStep2Contacts(ThemeData theme) {
    return Form(
      key: _formKeys[1],
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add organization contacts',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Add email addresses and phone numbers for different departments.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
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
                      DropdownMenuItem(value: ContactType.email, child: Text('Email')),
                      DropdownMenuItem(value: ContactType.phone, child: Text('Phone')),
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
                          ? 'Email address'
                          : 'Phone number',
                      isDense: true,
                      prefixIcon: Icon(
                        _contactType == ContactType.email
                            ? Icons.email_outlined
                            : Icons.phone_outlined,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _addContact,
                  icon: const Icon(Icons.add, size: 20),
                  tooltip: 'Add contact',
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_contacts.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(Icons.contacts_outlined,
                          size: 40, color: theme.colorScheme.onSurface.withAlpha(60)),
                      const SizedBox(height: 8),
                      Text(
                        'No contacts added yet',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
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
                      c.type == ContactType.email ? Icons.email : Icons.phone,
                      size: 16,
                    ),
                    label: Text('${contactPurposeLabel(c.purpose)}: ${c.value}'),
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

  // -- Step 3: Location
  Widget _buildStep3Location(ThemeData theme) {
    return Form(
      key: _formKeys[2],
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Physical address and coverage area',
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
              enabled: !_saving,
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
