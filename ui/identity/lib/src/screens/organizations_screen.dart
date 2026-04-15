import 'dart:typed_data';

import 'package:antinvestor_api_identity/antinvestor_api_identity.dart';
import 'package:antinvestor_ui_core/auth/tenancy_context.dart';
import 'package:antinvestor_ui_core/widgets/admin_entity_list_page.dart';
import 'package:antinvestor_ui_core/widgets/error_helpers.dart';
import 'package:antinvestor_ui_core/widgets/form_field_card.dart';
import 'package:antinvestor_ui_geolocation/antinvestor_ui_geolocation.dart'
    show AreaPickerField;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/organization_providers.dart';

// ---------------------------------------------------------------------------
// Public helpers
// ---------------------------------------------------------------------------

/// Human-readable label for OrganizationType.
String orgTypeLabel(OrganizationType type) => switch (type) {
      OrganizationType.ORGANIZATION_TYPE_UNSPECIFIED => 'Not specified',
      OrganizationType.ORGANIZATION_TYPE_BANK => 'Bank',
      OrganizationType.ORGANIZATION_TYPE_MICROFINANCE => 'Microfinance',
      OrganizationType.ORGANIZATION_TYPE_SACCO => 'SACCO',
      OrganizationType.ORGANIZATION_TYPE_FINTECH => 'Fintech',
      OrganizationType.ORGANIZATION_TYPE_COOPERATIVE => 'Cooperative',
      OrganizationType.ORGANIZATION_TYPE_NGO => 'NGO',
      OrganizationType.ORGANIZATION_TYPE_GOVERNMENT => 'Government',
      OrganizationType.ORGANIZATION_TYPE_OTHER => 'Other',
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
// Form data
// ---------------------------------------------------------------------------

/// All data collected by the multi-step organization creation wizard.
class OrganizationFormData {
  OrganizationFormData({
    required this.organization,
    this.description = '',
    this.domainName = '',
    this.contacts = const [],
    this.street = '',
    this.city = '',
    this.country = '',
    this.postalCode = '',
    this.parentOrganizationId,
    this.logoContentUri,
    this.logoBytes,
    this.geoId = '',
    this.geoDescription = '',
  });

  final OrganizationObject organization;
  final String description;
  final String domainName;
  final List<OrganizationContact> contacts;
  final String street;
  final String city;
  final String country;
  final String postalCode;
  final String? parentOrganizationId;

  /// Content URI from the files service after logo upload.
  final String? logoContentUri;

  /// Raw image bytes picked locally. The host app's onSave callback
  /// can upload these to the files service and set logoContentUri.
  final Uint8List? logoBytes;

  /// The coverage area identifier (e.g. "global", "continent:africa",
  /// "country:kenya", "region:kenya:rift_valley", "city:kenya:nairobi").
  final String geoId;

  /// Human-readable coverage area description (e.g. "Kenya, East Africa").
  final String geoDescription;
}


// ---------------------------------------------------------------------------
// Organizations list screen
// ---------------------------------------------------------------------------

class OrganizationsScreen extends ConsumerStatefulWidget {
  const OrganizationsScreen({
    super.key,
    this.canManage = true,
    this.onNavigate,
    this.onPickLogo,
    this.filesBaseUrl,
  });

  final bool canManage;
  final void Function(String id)? onNavigate;

  /// Callback to upload logo bytes. Passed through to [OrganizationFormDialog].
  final Future<String> Function(Uint8List bytes, String filename)? onPickLogo;

  /// Base URL for the files service (e.g. https://api.stawi.org/files).
  /// Used to convert mxc:// URIs to HTTP download URLs for storage.
  final String? filesBaseUrl;

  @override
  ConsumerState<OrganizationsScreen> createState() =>
      _OrganizationsScreenState();
}

class _OrganizationsScreenState extends ConsumerState<OrganizationsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final organizationsAsync = ref.watch(organizationListProvider(_query));
    final organizations = organizationsAsync.whenOrNull(data: (d) => d) ?? [];

    return AdminEntityListPage<OrganizationObject>(
      title: 'Organizations',
      breadcrumbs: const ['Identity', 'Organizations'],
      columns: const [
        DataColumn(label: Text('NAME')),
        DataColumn(label: Text('TYPE')),
        DataColumn(label: Text('STATE')),
      ],
      items: organizations,
      onSearch: (value) => setState(() => _query = value.trim()),
      addLabel: widget.canManage ? 'Add Organization' : null,
      onAdd: widget.canManage
          ? () => _showOrganizationDialog(context, ref)
          : null,
      rowBuilder: (org, selected, onSelect) {
        return DataRow(
          selected: selected,
          onSelectChanged: (_) => onSelect(),
          cells: [
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(Icons.account_balance,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(width: 10),
                  Text(org.name),
                ],
              ),
            ),
            DataCell(Text(orgTypeLabel(org.organizationType))),
            DataCell(_StatePill(org.state)),
          ],
        );
      },
      onRowNavigate: (org) {
        if (widget.onNavigate != null) {
          widget.onNavigate!(org.id);
        } else {
          context.go('/organizations/${org.id}');
        }
      },
      detailBuilder: (org) => _OrganizationDetail(organization: org),
      exportRow: (org) => [
        org.name,
        orgTypeLabel(org.organizationType),
        org.state.name,
        org.id,
      ],
    );
  }

  void _showOrganizationDialog(BuildContext context, WidgetRef ref) {
    final existingOrgs =
        ref.read(organizationListProvider('')).whenOrNull(data: (d) => d) ??
            [];

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => OrganizationFormDialog(
        existingOrganizations: existingOrgs,
        onPickLogo: widget.onPickLogo,
        onSave: (formData) async {
          try {
            final tenancy = ref.read(tenancyContextProvider);
            final org = formData.organization;
            if (org.partitionId.isEmpty) {
              org.partitionId = tenancy.partitionId;
            }

            // Set geoId on the organization object if provided.
            if (formData.geoId.isNotEmpty) {
              org.geoId = formData.geoId;
            }

            // Merge wizard data into existing properties (preserve backend-set keys).
            final existingFields = org.hasProperties()
                ? Map<String, Value>.from(org.properties.fields)
                : <String, Value>{};
            final props = existingFields;
            // Always set wizard fields (overwrites previous values).
            props['description'] =
                Value(stringValue: formData.description);
            props['domain_name'] =
                Value(stringValue: formData.domainName);
            props['address_street'] =
                Value(stringValue: formData.street);
            props['address_city'] =
                Value(stringValue: formData.city);
            props['address_country'] =
                Value(stringValue: formData.country);
            props['address_postal_code'] =
                Value(stringValue: formData.postalCode);
            // Contacts — always overwrite with current list.
            props['contacts'] = Value(
              listValue: ListValue(
                values: formData.contacts
                    .map(
                      (c) => Value(
                        structValue: Struct(fields: {
                          'purpose': Value(stringValue: c.purpose.name),
                          'type': Value(stringValue: c.type.name),
                          'value': Value(stringValue: c.value),
                        }),
                      ),
                    )
                    .toList(),
              ),
            );
            if (formData.parentOrganizationId != null) {
              props['parent_organization_id'] =
                  Value(stringValue: formData.parentOrganizationId!);
            }
            if (formData.logoContentUri != null &&
                formData.logoContentUri!.isNotEmpty) {
              // Store the canonical mxc:// URI.
              props['logo_content_uri'] =
                  Value(stringValue: formData.logoContentUri!);
              // Also store the HTTP download URL for direct browser display.
              if (formData.logoContentUri!.startsWith('mxc://')) {
                final parts =
                    formData.logoContentUri!.substring(6).split('/');
                if (parts.length >= 2 && widget.filesBaseUrl != null) {
                  props['logo_http_url'] = Value(
                    stringValue:
                        '${widget.filesBaseUrl}/v1/media/download/${parts[0]}/${parts[1]}',
                  );
                }
              } else {
                // Already an HTTP URL — store as both.
                props['logo_http_url'] =
                    Value(stringValue: formData.logoContentUri!);
              }
            }
            if (formData.geoDescription.isNotEmpty) {
              props['geo_description'] =
                  Value(stringValue: formData.geoDescription);
            }
            if (props.isNotEmpty) {
              org.properties = Struct(fields: props);
            }

            await ref
                .read(organizationNotifierProvider.notifier)
                .save(org);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Organization created successfully')),
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

// ---------------------------------------------------------------------------
// Inline detail (used by AdminEntityListPage)
// ---------------------------------------------------------------------------

class _OrganizationDetail extends StatelessWidget {
  const _OrganizationDetail({required this.organization});
  final OrganizationObject organization;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(Icons.account_balance,
                  color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(organization.name,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  Text(organization.id,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontFamily: 'monospace')),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _DetailRow(
            label: 'Type',
            value: orgTypeLabel(organization.organizationType)),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Text('State',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant)),
              ),
              _StatePill(organization.state),
            ],
          ),
        ),
        if (organization.code.isNotEmpty)
          _DetailRow(label: 'Code', value: organization.code),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Small shared widgets
// ---------------------------------------------------------------------------

class _StatePill extends StatelessWidget {
  const _StatePill(this.state);
  final dynamic state;

  @override
  Widget build(BuildContext context) {
    final label = state.name as String;
    final theme = Theme.of(context);
    final (Color bg, Color fg) = switch (label) {
      'ACTIVE' => (
          theme.colorScheme.tertiary.withAlpha(20),
          theme.colorScheme.tertiary
        ),
      'CREATED' => (
          theme.colorScheme.secondary.withAlpha(20),
          theme.colorScheme.secondary
        ),
      'INACTIVE' || 'DELETED' => (
          theme.colorScheme.error.withAlpha(20),
          theme.colorScheme.error
        ),
      _ => (
          theme.colorScheme.outline.withAlpha(20),
          theme.colorScheme.outline
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ),
          Expanded(
            child: Text(value,
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3-step wizard dialog
// ---------------------------------------------------------------------------

/// Three-step wizard dialog for creating / editing an organization.
///
/// Step 1 — Details (name, code, type, domain, parent, description, logo)
/// Step 2 — Contacts (purpose + type + value, with chip list)
/// Step 3 — Location (address + coverage area)
///
/// Calls [onSave] with the aggregated [OrganizationFormData].
class OrganizationFormDialog extends StatefulWidget {
  const OrganizationFormDialog({
    super.key,
    this.organization,
    this.existingOrganizations = const [],
    this.onPickLogo,
    required this.onSave,
  });

  final OrganizationObject? organization;

  /// Existing organizations available for parent selection.
  final List<OrganizationObject> existingOrganizations;

  /// Callback to upload logo bytes. Receives the image bytes and filename,
  /// returns the content URI from the files service.
  final Future<String> Function(Uint8List bytes, String filename)? onPickLogo;

  final Future<void> Function(OrganizationFormData formData) onSave;

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

  // -- Step 1: Details --------------------------------------------------------
  late final TextEditingController _nameCtrl;
  late final TextEditingController _codeCtrl;
  late OrganizationType _orgType;
  String? _parentOrgId;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _domainCtrl;
  String? _logoFileName;
  String? _logoContentUri;
  Uint8List? _logoBytes;

  // -- Step 2: Contacts -------------------------------------------------------
  ContactPurpose _contactPurpose = ContactPurpose.general;
  ContactType _contactType = ContactType.email;
  late final TextEditingController _contactValueCtrl;
  final List<OrganizationContact> _contacts = [];

  // -- Step 3: Location -------------------------------------------------------
  late final TextEditingController _streetCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _countryCtrl;
  late final TextEditingController _postalCodeCtrl;
  String _selectedGeoId = '';

  // -- Org type dropdown values -----------------------------------------------
  static const _orgTypes = [
    OrganizationType.ORGANIZATION_TYPE_UNSPECIFIED,
    OrganizationType.ORGANIZATION_TYPE_BANK,
    OrganizationType.ORGANIZATION_TYPE_MICROFINANCE,
    OrganizationType.ORGANIZATION_TYPE_SACCO,
    OrganizationType.ORGANIZATION_TYPE_FINTECH,
    OrganizationType.ORGANIZATION_TYPE_COOPERATIVE,
    OrganizationType.ORGANIZATION_TYPE_NGO,
    OrganizationType.ORGANIZATION_TYPE_GOVERNMENT,
    OrganizationType.ORGANIZATION_TYPE_OTHER,
  ];


  // -- Lifecycle --------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.organization?.name ?? '');
    _codeCtrl = TextEditingController(text: widget.organization?.code ?? '');
    _orgType = widget.organization?.organizationType ??
        OrganizationType.ORGANIZATION_TYPE_UNSPECIFIED;

    final props = widget.organization?.properties;
    _descriptionCtrl =
        TextEditingController(text: _propStr(props, 'description'));
    _domainCtrl =
        TextEditingController(text: _propStr(props, 'domain_name'));
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

    // Pre-populate parent org id.
    final parentId = _propStr(props, 'parent_organization_id');
    if (parentId.isNotEmpty) _parentOrgId = parentId;

    // Pre-populate contacts from structured property.
    _contacts.addAll(_readContactsFromProps(props));

    // Pre-populate logo.
    final logoUri = _propStr(props, 'logo_content_uri');
    if (logoUri.isNotEmpty) _logoContentUri = logoUri;
  }

  static String _propStr(Struct? props, String key) {
    if (props == null) return '';
    final field = props.fields[key];
    if (field == null || !field.hasStringValue()) return '';
    return field.stringValue;
  }

  static List<OrganizationContact> _readContactsFromProps(Struct? props) {
    if (props == null) return [];
    final field = props.fields['contacts'];
    if (field == null || !field.hasListValue()) return [];
    final result = <OrganizationContact>[];
    for (final v in field.listValue.values) {
      if (!v.hasStructValue()) continue;
      final m = <String, dynamic>{};
      for (final entry in v.structValue.fields.entries) {
        if (entry.value.hasStringValue()) {
          m[entry.key] = entry.value.stringValue;
        }
      }
      final contact = OrganizationContact.fromMap(m);
      if (contact != null) result.add(contact);
    }
    return result;
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

  // -- Navigation -------------------------------------------------------------

  void _next() {
    _flushPendingContact();
    if (!_formKeys[_currentStep].currentState!.validate()) return;
    if (_currentStep == 1 && _contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one contact is required')),
      );
      return;
    }
    setState(() => _currentStep++);
  }

  void _back() {
    setState(() => _currentStep--);
  }

  /// Auto-add any text left in the contact value field.
  void _flushPendingContact() {
    final value = _contactValueCtrl.text.trim();
    if (value.isEmpty) return;
    if (_contactType == ContactType.email && !value.contains('@')) return;
    final contact = OrganizationContact(
      purpose: _contactPurpose,
      type: _contactType,
      value: value,
    );
    if (!_contacts.any((c) =>
        c.purpose == contact.purpose &&
        c.type == contact.type &&
        c.value == contact.value)) {
      _contacts.add(contact);
      _contactValueCtrl.clear();
    }
  }

  // -- Logo picker ------------------------------------------------------------

  Future<void> _pickLogo() async {
    setState(() => _isPickingLogo = true);
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (image == null || !mounted) {
        if (mounted) setState(() => _isPickingLogo = false);
        return;
      }

      final bytes = await image.readAsBytes();

      if (widget.onPickLogo != null) {
        final contentUri = await widget.onPickLogo!(bytes, image.name);
        if (mounted) {
          setState(() {
            _logoFileName = image.name;
            _logoContentUri = contentUri;
            _logoBytes = bytes;
            _isPickingLogo = false;
          });
        }
        return;
      }

      if (mounted) {
        setState(() {
          _logoFileName = image.name;
          _logoBytes = bytes;
          _isPickingLogo = false;
        });
      }
    } catch (e) {
      debugPrint('[OrganizationWizard] Logo pick/upload error: $e');
      if (mounted) {
        setState(() => _isPickingLogo = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logo upload failed: $e')),
        );
      }
    }
  }

  // -- Contact helpers --------------------------------------------------------

  void _addContact() {
    final value = _contactValueCtrl.text.trim();
    if (value.isEmpty) return;
    if (_contactType == ContactType.email && !value.contains('@')) return;
    final contact = OrganizationContact(
      purpose: _contactPurpose,
      type: _contactType,
      value: value,
    );
    if (_contacts.any((c) =>
        c.purpose == contact.purpose &&
        c.type == contact.type &&
        c.value == contact.value)) {
      return;
    }
    setState(() {
      _contacts.add(contact);
      _contactValueCtrl.clear();
    });
  }

  // -- Coverage area helpers --------------------------------------------------

  String _buildGeoId() => _selectedGeoId;

  String _buildGeoDescription() => ''; // Area name resolved by AreaBadge from geoId

  // -- Submit -----------------------------------------------------------------

  Future<void> _submit() async {
    _flushPendingContact();
    if (!_formKeys[_currentStep].currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final org = (widget.organization ?? OrganizationObject())
        ..name = _nameCtrl.text.trim()
        ..code = _codeCtrl.text.trim()
        ..organizationType = _orgType
        ..parentId = (_parentOrgId != null && _parentOrgId!.isNotEmpty)
            ? _parentOrgId!
            : '';

      final formData = OrganizationFormData(
        organization: org,
        description: _descriptionCtrl.text.trim(),
        domainName: _domainCtrl.text.trim(),
        contacts: List.unmodifiable(_contacts),
        street: _streetCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        country: _countryCtrl.text.trim(),
        postalCode: _postalCodeCtrl.text.trim(),
        parentOrganizationId:
            (_parentOrgId != null && _parentOrgId!.isNotEmpty)
                ? _parentOrgId
                : null,
        logoContentUri: _logoContentUri,
        logoBytes: _logoBytes,
        geoId: _buildGeoId(),
        geoDescription: _buildGeoDescription(),
      );

      await widget.onSave(formData);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
  }

  // -- Build ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      title: Column(
        mainAxisSize: MainAxisSize.min,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isEditing ? 'Edit Organization' : 'New Organization',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      _isEditing
                          ? 'Update the organization details below.'
                          : 'Register a new organization in the system.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _StepIndicator(
            currentStep: _currentStep,
            stepCount: _stepCount,
            labels: _stepLabels,
          ),
        ],
      ),
      content: SizedBox(
        width: 560,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 520),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                _buildCurrentStep(theme),
              ],
            ),
          ),
        ),
      ),
      actions: _buildActions(theme),
    );
  }

  Widget _buildCurrentStep(ThemeData theme) {
    return switch (_currentStep) {
      0 => _buildDetailsStep(theme),
      1 => _buildContactsStep(theme),
      2 => _buildLocationStep(),
      _ => const SizedBox.shrink(),
    };
  }

  // -- Step 1: Details --------------------------------------------------------

  Widget _buildDetailsStep(ThemeData theme) {
    return Form(
      key: _formKeys[0],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo badge at top center
          Center(
            child: _LogoBadge(
              fileName: _logoFileName,
              logoUrl: _logoContentUri,
              logoBytes: _logoBytes,
              isLoading: _isPickingLogo,
              onTap: _isPickingLogo ? null : () => _pickLogo(),
              onRemove: () => setState(() {
                _logoFileName = null;
                _logoContentUri = null;
                _logoBytes = null;
              }),
            ),
          ),
          const SizedBox(height: 16),

          FormFieldCard(
            label: 'Organization Name',
            description: 'The official registered name of the organization.',
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
            label: 'Organization Code',
            description: 'A short unique identifier (e.g. SCL, STAWI).',
            isRequired: true,
            child: TextFormField(
              controller: _codeCtrl,
              decoration: const InputDecoration(
                hintText: 'e.g. SCL',
                prefixIcon: Icon(Icons.tag),
              ),
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Organization code is required'
                  : null,
            ),
          ),
          FormFieldCard(
            label: 'Organization Type',
            description:
                'The regulatory category that determines applicable '
                'compliance rules and reporting requirements.',
            isRequired: true,
            child: DropdownButtonFormField<OrganizationType>(
              value: _orgType,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: _orgTypes
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text(orgTypeLabel(t)),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _orgType = v);
              },
            ),
          ),
          FormFieldCard(
            label: 'Domain Name',
            description:
                'The organization\'s internet domain (e.g. "stawi.org").',
            child: TextFormField(
              controller: _domainCtrl,
              decoration: const InputDecoration(
                hintText: 'e.g. stawi.org',
                prefixIcon: Icon(Icons.language),
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.next,
            ),
          ),
          if (widget.existingOrganizations.isNotEmpty)
            FormFieldCard(
              label: 'Parent Organization',
              description:
                  'Optional. Select an existing organization as the '
                  'parent for ownership hierarchy.',
              child: DropdownButtonFormField<String>(
                value: _parentOrgId,
                decoration: const InputDecoration(
                  hintText: 'None (top-level)',
                  prefixIcon: Icon(Icons.account_tree_outlined),
                ),
                items: [
                  const DropdownMenuItem(
                    value: '',
                    child: Text('None (top-level)'),
                  ),
                  ...widget.existingOrganizations.map(
                    (org) => DropdownMenuItem(
                      value: org.id,
                      child: Text(org.name),
                    ),
                  ),
                ],
                onChanged: (v) => setState(() => _parentOrgId = v),
              ),
            ),
          FormFieldCard(
            label: 'Description',
            description:
                'A brief overview of the organization and its mission.',
            child: TextFormField(
              controller: _descriptionCtrl,
              decoration: const InputDecoration(
                hintText: 'Describe the organization...',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textInputAction: TextInputAction.newline,
            ),
          ),
        ],
      ),
    );
  }

  // -- Step 2: Contacts -------------------------------------------------------

  Widget _buildContactsStep(ThemeData theme) {
    return Form(
      key: _formKeys[1],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormFieldCard(
            label: 'Add Contact',
            description: 'Each contact has a purpose, type, and value.',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Purpose dropdown
                DropdownButtonFormField<ContactPurpose>(
                  value: _contactPurpose,
                  decoration: const InputDecoration(
                    labelText: 'Purpose',
                    prefixIcon: Icon(Icons.label_outlined),
                  ),
                  items: ContactPurpose.values
                      .map(
                        (p) => DropdownMenuItem(
                          value: p,
                          child: Text(contactPurposeLabel(p)),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _contactPurpose = v);
                  },
                ),
                const SizedBox(height: 12),

                // Type segmented button
                Row(
                  children: [
                    Text('Type:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        )),
                    const SizedBox(width: 12),
                    SegmentedButton<ContactType>(
                      segments: const [
                        ButtonSegment(
                          value: ContactType.email,
                          label: Text('Email'),
                          icon: Icon(Icons.email_outlined),
                        ),
                        ButtonSegment(
                          value: ContactType.phone,
                          label: Text('Phone'),
                          icon: Icon(Icons.phone_outlined),
                        ),
                      ],
                      selected: {_contactType},
                      onSelectionChanged: (v) {
                        setState(() => _contactType = v.first);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Value field + add button
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _contactValueCtrl,
                        decoration: InputDecoration(
                          hintText: _contactType == ContactType.email
                              ? 'e.g. info@example.com'
                              : 'e.g. +254 700 123 456',
                          prefixIcon: Icon(
                            _contactType == ContactType.email
                                ? Icons.email_outlined
                                : Icons.phone_outlined,
                          ),
                        ),
                        keyboardType: _contactType == ContactType.email
                            ? TextInputType.emailAddress
                            : TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _addContact(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _addContact,
                      icon: const Icon(Icons.add),
                      tooltip: 'Add contact',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Contact chips
          if (_contacts.isNotEmpty)
            FormFieldCard(
              label: 'Contacts (${_contacts.length})',
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _contacts.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final c = entry.value;
                  return Chip(
                    avatar: Icon(
                      c.type == ContactType.email
                          ? Icons.email
                          : Icons.phone,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    label: Text(
                      '${contactPurposeLabel(c.purpose)}: ${c.value}',
                    ),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () =>
                        setState(() => _contacts.removeAt(idx)),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  // -- Step 3: Location -------------------------------------------------------

  Widget _buildLocationStep() {
    return Form(
      key: _formKeys[2],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormFieldCard(
            label: 'Street Address',
            description: 'The primary street address of the organization.',
            child: TextFormField(
              controller: _streetCtrl,
              decoration: const InputDecoration(
                hintText: 'e.g. 123 Kenyatta Avenue',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              textInputAction: TextInputAction.next,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FormFieldCard(
                  label: 'City',
                  child: TextFormField(
                    controller: _cityCtrl,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Nairobi',
                      prefixIcon: Icon(Icons.location_city_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FormFieldCard(
                  label: 'Postal Code',
                  child: TextFormField(
                    controller: _postalCodeCtrl,
                    decoration: const InputDecoration(
                      hintText: 'e.g. 00100',
                      prefixIcon: Icon(Icons.markunread_mailbox_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
            ],
          ),
          FormFieldCard(
            label: 'Country',
            child: TextFormField(
              controller: _countryCtrl,
              decoration: const InputDecoration(
                hintText: 'e.g. Kenya',
                prefixIcon: Icon(Icons.public),
              ),
              textInputAction: TextInputAction.done,
            ),
          ),

          const SizedBox(height: 8),

          // Coverage Area - area picker from geolocation service
          AreaPickerField(
            selectedAreaId: _selectedGeoId,
            label: 'Coverage Area',
            description:
                'Search and select the geographic area this organization operates in.',
            isRequired: true,
            onSelected: (area) => setState(() {
              _selectedGeoId = area?.id ?? '';
            }),
          ),
        ],
      ),
    );
  }


  // -- Actions ----------------------------------------------------------------

  List<Widget> _buildActions(ThemeData theme) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _saving ? null : () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          if (_currentStep > 0) ...[
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: _saving ? null : _back,
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back'),
            ),
          ],
          const SizedBox(width: 8),
          if (_currentStep < _stepCount - 1)
            FilledButton.icon(
              onPressed: _next,
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: const Text('Next'),
            )
          else
            FilledButton.icon(
              onPressed: _saving ? null : _submit,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(_isEditing ? Icons.save : Icons.add),
              label: Text(
                _isEditing ? 'Update Organization' : 'Create Organization',
              ),
            ),
        ],
      ),
    ];
  }
}

// ---------------------------------------------------------------------------
// Step Indicator
// ---------------------------------------------------------------------------

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.currentStep,
    required this.stepCount,
    required this.labels,
  });

  final int currentStep;
  final int stepCount;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < stepCount; i++) ...[
            if (i > 0)
              SizedBox(
                width: 48,
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color: i <= currentStep
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant,
                ),
              ),
            _StepDot(
              index: i,
              label: labels[i],
              isActive: i == currentStep,
              isCompleted: i < currentStep,
            ),
          ],
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.index,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  final int index;
  final String label;
  final bool isActive;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color bgColor;
    final Widget child;

    if (isCompleted) {
      bgColor = theme.colorScheme.primary;
      child = const Icon(Icons.check, size: 14, color: Colors.white);
    } else if (isActive) {
      bgColor = theme.colorScheme.primary;
      child = Text(
        '${index + 1}',
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      );
    } else {
      bgColor = theme.colorScheme.outlineVariant;
      child = Text(
        '${index + 1}',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: child,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Logo Badge
// ---------------------------------------------------------------------------

class _LogoBadge extends StatelessWidget {
  const _LogoBadge({
    this.fileName,
    this.logoUrl,
    this.logoBytes,
    this.isLoading = false,
    required this.onTap,
    this.onRemove,
  });

  final String? fileName;
  final String? logoUrl;
  final Uint8List? logoBytes;
  final bool isLoading;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasLogo =
        (logoUrl != null && logoUrl!.isNotEmpty) || logoBytes != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: hasLogo
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerHighest,
                backgroundImage: logoUrl != null && logoUrl!.isNotEmpty
                    ? NetworkImage(logoUrl!)
                    : logoBytes != null
                        ? MemoryImage(logoBytes!)
                        : null,
                child: isLoading || hasLogo
                    ? null
                    : Icon(
                        Icons.camera_alt_outlined,
                        size: 32,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
              ),
              if (isLoading)
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withAlpha(180),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (isLoading)
          Text(
            'Uploading...',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else if (hasLogo)
          TextButton.icon(
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 14),
            label: const Text('Change logo'),
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              textStyle: const TextStyle(fontSize: 12),
            ),
          )
        else
          GestureDetector(
            onTap: onTap,
            child: Text(
              'Upload logo',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
