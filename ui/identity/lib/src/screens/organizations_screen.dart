import 'dart:typed_data';

import 'package:antinvestor_api_identity/antinvestor_api_identity.dart';
import 'package:antinvestor_ui_core/auth/tenancy_context.dart';
import 'package:image_picker/image_picker.dart';
import 'package:antinvestor_ui_core/widgets/admin_entity_list_page.dart';
import 'package:antinvestor_ui_core/widgets/error_helpers.dart';
import 'package:antinvestor_ui_core/widgets/form_field_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/organization_providers.dart';

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

class OrganizationsScreen extends ConsumerStatefulWidget {
  const OrganizationsScreen({
    super.key,
    this.canManage = true,
    this.onNavigate,
  });

  final bool canManage;
  final void Function(String id)? onNavigate;

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
      exportRow: (org) =>
          [org.name, orgTypeLabel(org.organizationType), org.state.name, org.id],
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

            // Pack wizard data into properties Struct so the backend
            // can create the profile, address, and contacts.
            final props = <String, Value>{};
            if (formData.description.isNotEmpty) {
              props['description'] =
                  Value(stringValue: formData.description);
            }
            if (formData.street.isNotEmpty) {
              props['address_street'] =
                  Value(stringValue: formData.street);
            }
            if (formData.city.isNotEmpty) {
              props['address_city'] =
                  Value(stringValue: formData.city);
            }
            if (formData.country.isNotEmpty) {
              props['address_country'] =
                  Value(stringValue: formData.country);
            }
            if (formData.postalCode.isNotEmpty) {
              props['address_postal_code'] =
                  Value(stringValue: formData.postalCode);
            }
            if (formData.emails.isNotEmpty) {
              props['contacts_email'] = Value(
                listValue: ListValue(
                  values: formData.emails
                      .map((e) => Value(stringValue: e))
                      .toList(),
                ),
              );
            }
            if (formData.phones.isNotEmpty) {
              props['contacts_phone'] = Value(
                listValue: ListValue(
                  values: formData.phones
                      .map((p) => Value(stringValue: p))
                      .toList(),
                ),
              );
            }
            if (formData.parentOrganizationId != null) {
              props['parent_organization_id'] =
                  Value(stringValue: formData.parentOrganizationId!);
            }
            if (formData.logoContentUri != null) {
              props['logo_content_uri'] =
                  Value(stringValue: formData.logoContentUri!);
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

class _StatePill extends StatelessWidget {
  const _StatePill(this.state);
  final dynamic state; // STATE enum from identity SDK

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

/// All data collected by the multi-step organization creation wizard.
class OrganizationFormData {
  OrganizationFormData({
    required this.organization,
    this.description = '',
    this.street = '',
    this.city = '',
    this.country = '',
    this.postalCode = '',
    this.emails = const [],
    this.phones = const [],
    this.parentOrganizationId,
    this.logoContentUri,
    this.logoBytes,
    this.geoId = '',
    this.geoDescription = '',
  });

  final OrganizationObject organization;
  final String description;
  final String street;
  final String city;
  final String country;
  final String postalCode;
  final List<String> emails;
  final List<String> phones;
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

/// Coverage scope levels for the cascading area selector.
enum _CoverageScope {
  global('Global'),
  continent('Continent'),
  country('Country'),
  region('Region'),
  city('City');

  const _CoverageScope(this.label);
  final String label;
}

/// Two-step wizard dialog for creating an organization.
///
/// Step 1 collects basic info and profile (name, code, type, parent,
/// description, logo, contacts). Step 2 collects address and coverage area.
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

  /// Callback to pick and upload a logo. Returns (fileName, contentUri).
  /// The host app wires this to a file picker + files service upload.
  final Future<({String fileName, String contentUri})> Function()? onPickLogo;

  final Future<void> Function(OrganizationFormData formData) onSave;

  @override
  State<OrganizationFormDialog> createState() => _OrganizationFormDialogState();
}

class _OrganizationFormDialogState extends State<OrganizationFormDialog> {
  static const _stepCount = 2;

  static const _stepLabels = ['Details', 'Location'];

  final _formKeys = List.generate(_stepCount, (_) => GlobalKey<FormState>());

  int _currentStep = 0;
  bool _saving = false;
  bool _isPickingLogo = false;

  bool get _isEditing => widget.organization != null;

  // -- Step 1: Basic Info + Profile ------------------------------------------
  late final TextEditingController _nameCtrl;
  late final TextEditingController _codeCtrl;
  late OrganizationType _orgType;
  String? _parentOrgId;
  late final TextEditingController _descriptionCtrl;
  String? _logoFileName;
  String? _logoContentUri;
  Uint8List? _logoBytes;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  final List<String> _emails = [];
  final List<String> _phones = [];

  // -- Step 2: Address + Coverage Area ---------------------------------------
  late final TextEditingController _streetCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _countryCtrl;
  late final TextEditingController _postalCodeCtrl;
  _CoverageScope _coverageScope = _CoverageScope.global;
  String? _selectedContinent;
  late final TextEditingController _coverageCountryCtrl;
  late final TextEditingController _coverageRegionCtrl;
  late final TextEditingController _coverageCityCtrl;

  // -- Org type dropdown values ----------------------------------------------
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

  static const _continents = [
    'Africa',
    'Asia',
    'Europe',
    'Americas',
    'Oceania',
  ];

  static String _orgTypeLabel(OrganizationType type) => orgTypeLabel(type);

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.organization?.name ?? '');
    _codeCtrl = TextEditingController(text: widget.organization?.code ?? '');
    _orgType = widget.organization?.organizationType ??
        OrganizationType.ORGANIZATION_TYPE_UNSPECIFIED;
    // Pre-populate from properties when editing.
    final props = widget.organization?.properties;
    _descriptionCtrl = TextEditingController(
        text: _propStr(props, 'description'));
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _streetCtrl = TextEditingController(
        text: _propStr(props, 'address_street'));
    _cityCtrl = TextEditingController(
        text: _propStr(props, 'address_city'));
    _countryCtrl = TextEditingController(
        text: _propStr(props, 'address_country'));
    _postalCodeCtrl = TextEditingController(
        text: _propStr(props, 'address_postal_code'));
    _coverageCountryCtrl = TextEditingController();
    _coverageRegionCtrl = TextEditingController();
    _coverageCityCtrl = TextEditingController();

    // Pre-populate contact lists from properties.
    _emails.addAll(_propListStr(props, 'contacts_email'));
    _phones.addAll(_propListStr(props, 'contacts_phone'));

    // Pre-populate logo from properties.
    final logoUri = _propStr(props, 'logo_content_uri');
    if (logoUri.isNotEmpty) _logoContentUri = logoUri;
  }

  static String _propStr(Struct? props, String key) {
    if (props == null) return '';
    final field = props.fields[key];
    if (field == null || !field.hasStringValue()) return '';
    return field.stringValue;
  }

  static List<String> _propListStr(Struct? props, String key) {
    if (props == null) return [];
    final field = props.fields[key];
    if (field == null || !field.hasListValue()) return [];
    return field.listValue.values
        .where((v) => v.hasStringValue())
        .map((v) => v.stringValue)
        .toList();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _descriptionCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _countryCtrl.dispose();
    _postalCodeCtrl.dispose();
    _coverageCountryCtrl.dispose();
    _coverageRegionCtrl.dispose();
    _coverageCityCtrl.dispose();
    super.dispose();
  }

  // -- Navigation ------------------------------------------------------------

  void _next() {
    // Auto-add any typed but un-added contacts before advancing.
    _flushPendingContacts();
    if (!_formKeys[_currentStep].currentState!.validate()) return;
    setState(() => _currentStep++);
  }

  /// Add any text left in the email/phone fields to the chip lists.
  void _flushPendingContacts() {
    final email = _emailCtrl.text.trim();
    if (email.isNotEmpty && email.contains('@') && !_emails.contains(email)) {
      _emails.add(email);
      _emailCtrl.clear();
    }
    final phone = _phoneCtrl.text.trim();
    if (phone.isNotEmpty && !_phones.contains(phone)) {
      _phones.add(phone);
      _phoneCtrl.clear();
    }
  }

  void _back() {
    setState(() => _currentStep--);
  }

  // -- Logo picker -----------------------------------------------------------

  Future<void> _pickLogo() async {
    setState(() => _isPickingLogo = true);
    try {
      // Pick image using image_picker (works on web + mobile).
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

      // If host app provides an upload callback, upload and get URL.
      if (widget.onPickLogo != null) {
        final result = await widget.onPickLogo!();
        if (mounted) {
          setState(() {
            _logoFileName = result.fileName;
            _logoContentUri = result.contentUri;
            _logoBytes = bytes;
            _isPickingLogo = false;
          });
        }
        return;
      }

      // No upload callback — store bytes locally. The onSave callback
      // receives logoBytes and can upload during save.
      if (mounted) {
        setState(() {
          _logoFileName = image.name;
          _logoBytes = bytes;
          _isPickingLogo = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isPickingLogo = false);
    }
  }

  // -- Contact helpers -------------------------------------------------------

  void _addEmail() {
    final value = _emailCtrl.text.trim();
    if (value.isEmpty || !value.contains('@')) return;
    setState(() {
      _emails.add(value);
      _emailCtrl.clear();
    });
  }

  void _addPhone() {
    final value = _phoneCtrl.text.trim();
    if (value.isEmpty) return;
    setState(() {
      _phones.add(value);
      _phoneCtrl.clear();
    });
  }

  // -- Coverage area helpers -------------------------------------------------

  /// Builds a geoId from the current coverage scope selection.
  String _buildGeoId() {
    switch (_coverageScope) {
      case _CoverageScope.global:
        return 'global';
      case _CoverageScope.continent:
        if (_selectedContinent == null) return '';
        return 'continent:${_selectedContinent!.toLowerCase()}';
      case _CoverageScope.country:
        final c = _coverageCountryCtrl.text.trim();
        if (c.isEmpty) return '';
        return 'country:${c.toLowerCase().replaceAll(' ', '_')}';
      case _CoverageScope.region:
        final c = _coverageCountryCtrl.text.trim();
        final r = _coverageRegionCtrl.text.trim();
        if (c.isEmpty || r.isEmpty) return '';
        return 'region:${c.toLowerCase().replaceAll(' ', '_')}:'
            '${r.toLowerCase().replaceAll(' ', '_')}';
      case _CoverageScope.city:
        final c = _coverageCountryCtrl.text.trim();
        final ci = _coverageCityCtrl.text.trim();
        if (c.isEmpty || ci.isEmpty) return '';
        return 'city:${c.toLowerCase().replaceAll(' ', '_')}:'
            '${ci.toLowerCase().replaceAll(' ', '_')}';
    }
  }

  /// Builds a human-readable description of the coverage area.
  String _buildGeoDescription() {
    switch (_coverageScope) {
      case _CoverageScope.global:
        return 'Global';
      case _CoverageScope.continent:
        return _selectedContinent ?? '';
      case _CoverageScope.country:
        return _coverageCountryCtrl.text.trim();
      case _CoverageScope.region:
        final c = _coverageCountryCtrl.text.trim();
        final r = _coverageRegionCtrl.text.trim();
        return [r, c].where((s) => s.isNotEmpty).join(', ');
      case _CoverageScope.city:
        final c = _coverageCountryCtrl.text.trim();
        final ci = _coverageCityCtrl.text.trim();
        return [ci, c].where((s) => s.isNotEmpty).join(', ');
    }
  }

  // -- Submit ----------------------------------------------------------------

  Future<void> _submit() async {
    _flushPendingContacts();
    if (!_formKeys[_currentStep].currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final org = (widget.organization ?? OrganizationObject())
        ..name = _nameCtrl.text.trim()
        ..code = _codeCtrl.text.trim()
        ..organizationType = _orgType;

      final formData = OrganizationFormData(
        organization: org,
        description: _descriptionCtrl.text.trim(),
        street: _streetCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        country: _countryCtrl.text.trim(),
        postalCode: _postalCodeCtrl.text.trim(),
        emails: List.unmodifiable(_emails),
        phones: List.unmodifiable(_phones),
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

  // -- Build -----------------------------------------------------------------

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
      1 => _buildLocationStep(),
      _ => const SizedBox.shrink(),
    };
  }

  // -- Step 1: Details (Basic Info + Profile) --------------------------------

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
                      child: Text(_orgTypeLabel(t)),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _orgType = v);
              },
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

          // Email contacts
          FormFieldCard(
            label: 'Email Contacts',
            description:
                'Add one or more email addresses for the organization.',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                          hintText: 'e.g. info@example.com',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _addEmail(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _addEmail,
                      icon: const Icon(Icons.add),
                      tooltip: 'Add email',
                    ),
                  ],
                ),
                if (_emails.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _emails
                          .asMap()
                          .entries
                          .map(
                            (e) => Chip(
                              avatar: Icon(Icons.email,
                                  size: 16,
                                  color: theme.colorScheme.primary),
                              label: Text(e.value),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () =>
                                  setState(() => _emails.removeAt(e.key)),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Phone contacts
          FormFieldCard(
            label: 'Phone Contacts',
            description:
                'Add one or more phone numbers for the organization.',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _phoneCtrl,
                        decoration: const InputDecoration(
                          hintText: 'e.g. +254 700 123 456',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _addPhone(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _addPhone,
                      icon: const Icon(Icons.add),
                      tooltip: 'Add phone',
                    ),
                  ],
                ),
                if (_phones.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _phones
                          .asMap()
                          .entries
                          .map(
                            (e) => Chip(
                              avatar: Icon(Icons.phone,
                                  size: 16,
                                  color: theme.colorScheme.primary),
                              label: Text(e.value),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () =>
                                  setState(() => _phones.removeAt(e.key)),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -- Step 2: Location (Address + Coverage Area) ----------------------------

  Widget _buildLocationStep() {
    return Form(
      key: _formKeys[1],
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

          // Coverage Area - cascading dropdown selector
          FormFieldCard(
            label: 'Coverage Area',
            description:
                'Select the geographic scope this organization operates in.',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<_CoverageScope>(
                  value: _coverageScope,
                  decoration: const InputDecoration(
                    labelText: 'Scope level',
                    prefixIcon: Icon(Icons.public_outlined),
                  ),
                  items: _CoverageScope.values
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.label),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      _coverageScope = v;
                      _selectedContinent = null;
                      _coverageCountryCtrl.clear();
                      _coverageRegionCtrl.clear();
                      _coverageCityCtrl.clear();
                    });
                  },
                ),
                const SizedBox(height: 12),
                ..._buildCoverageFields(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCoverageFields() {
    switch (_coverageScope) {
      case _CoverageScope.global:
        return [
          Text(
            'Organization operates globally. No additional input needed.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ];
      case _CoverageScope.continent:
        return [
          DropdownButtonFormField<String>(
            value: _selectedContinent,
            decoration: const InputDecoration(
              labelText: 'Continent',
              hintText: 'Select a continent',
              prefixIcon: Icon(Icons.map_outlined),
            ),
            items: _continents
                .map(
                  (c) => DropdownMenuItem(value: c, child: Text(c)),
                )
                .toList(),
            onChanged: (v) => setState(() => _selectedContinent = v),
          ),
        ];
      case _CoverageScope.country:
        return [
          TextFormField(
            controller: _coverageCountryCtrl,
            decoration: const InputDecoration(
              labelText: 'Country',
              hintText: 'e.g. Kenya',
              prefixIcon: Icon(Icons.flag_outlined),
            ),
            textInputAction: TextInputAction.done,
          ),
        ];
      case _CoverageScope.region:
        return [
          TextFormField(
            controller: _coverageCountryCtrl,
            decoration: const InputDecoration(
              labelText: 'Country',
              hintText: 'e.g. Kenya',
              prefixIcon: Icon(Icons.flag_outlined),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _coverageRegionCtrl,
            decoration: const InputDecoration(
              labelText: 'Region',
              hintText: 'e.g. Rift Valley',
              prefixIcon: Icon(Icons.terrain_outlined),
            ),
            textInputAction: TextInputAction.done,
          ),
        ];
      case _CoverageScope.city:
        return [
          TextFormField(
            controller: _coverageCountryCtrl,
            decoration: const InputDecoration(
              labelText: 'Country',
              hintText: 'e.g. Kenya',
              prefixIcon: Icon(Icons.flag_outlined),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _coverageCityCtrl,
            decoration: const InputDecoration(
              labelText: 'City',
              hintText: 'e.g. Nairobi',
              prefixIcon: Icon(Icons.location_city_outlined),
            ),
            textInputAction: TextInputAction.done,
          ),
        ];
    }
  }

  // -- Actions ---------------------------------------------------------------

  List<Widget> _buildActions(ThemeData theme) {
    return [
      TextButton(
        onPressed: _saving ? null : () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      const Spacer(),
      if (_currentStep > 0)
        OutlinedButton.icon(
          onPressed: _saving ? null : _back,
          icon: const Icon(Icons.arrow_back, size: 18),
          label: const Text('Back'),
        ),
      const SizedBox(width: 8),
      if (_currentStep < _stepCount - 1)
        FilledButton.icon(
          onPressed: _isPickingLogo ||
                  (!_isEditing &&
                      _currentStep == 0 &&
                      _logoContentUri == null &&
                      _logoBytes == null)
              ? null
              : _next,
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
    ];
  }
}

// -- Step Indicator -----------------------------------------------------------

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
              Expanded(
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

// -- Logo Badge ---------------------------------------------------------------

/// Circular avatar badge for logo upload.
///
/// Empty state: grey background with camera icon.
/// With logo: displays the uploaded logo via [NetworkImage].
/// Tapping triggers [onTap] for logo pick/upload.
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
    final hasLogo = (logoUrl != null && logoUrl!.isNotEmpty) || logoBytes != null;

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
