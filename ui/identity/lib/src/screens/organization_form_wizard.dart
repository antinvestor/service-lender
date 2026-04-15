import 'dart:typed_data';

import 'package:antinvestor_api_identity/antinvestor_api_identity.dart';
import 'package:antinvestor_api_profile/antinvestor_api_profile.dart' as profile;
import 'package:antinvestor_ui_core/widgets/form_field_card.dart';
import 'package:antinvestor_ui_core/widgets/profile_badge.dart';
import 'package:antinvestor_ui_geolocation/antinvestor_ui_geolocation.dart'
    show AreaPickerField;
import 'package:antinvestor_ui_profile/antinvestor_ui_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/organization_providers.dart';
import 'organizations_screen.dart' show orgTypeLabel;

// ---------------------------------------------------------------------------
// Result passed back to the caller on completion
// ---------------------------------------------------------------------------

class OrganizationWizardResult {
  const OrganizationWizardResult({
    required this.profileId,
    required this.organization,
  });

  final String profileId;
  final OrganizationObject organization;
}

// ---------------------------------------------------------------------------
// 4-step wizard: Contact → Details → Contacts → Location
// ---------------------------------------------------------------------------

class OrganizationFormWizard extends ConsumerStatefulWidget {
  const OrganizationFormWizard({
    super.key,
    this.organization,
    this.onPickLogo,
    required this.onSave,
  });

  /// Existing organization to edit. Null for create mode.
  final OrganizationObject? organization;

  /// Callback to upload logo bytes. Returns content URI (mxc://).
  final Future<String> Function(Uint8List bytes, String filename)? onPickLogo;

  /// Called with the final result. The caller is responsible for saving
  /// the organization via the notifier.
  final Future<void> Function(OrganizationWizardResult result) onSave;

  @override
  ConsumerState<OrganizationFormWizard> createState() =>
      _OrganizationFormWizardState();
}

class _OrganizationFormWizardState
    extends ConsumerState<OrganizationFormWizard> {
  static const _stepCount = 4;
  static const _stepLabels = ['Contact', 'Details', 'Contacts', 'Location'];

  final _formKeys = List.generate(_stepCount, (_) => GlobalKey<FormState>());
  int _currentStep = 0;
  bool _saving = false;

  // -- Step 1: Contact search
  final _contactCtrl = TextEditingController();
  profile.ProfileObject? _foundProfile;
  bool _profileSearched = false;
  bool _profileSearching = false;
  bool _creatingProfile = false;

  // New profile fields (if creating)
  final _nameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  Uint8List? _avatarBytes;
  String? _avatarFileName;

  // -- Step 2: Organization details
  final _codeCtrl = TextEditingController();
  final _domainCtrl = TextEditingController();
  String _orgType = '';

  // -- Step 3: Additional contacts
  final _newContactCtrl = TextEditingController();
  bool _newContactIsPhone = false;

  // -- Step 4: Location
  String _geoId = '';
  final _streetCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _postalCodeCtrl = TextEditingController();

  bool get _isEditing => widget.organization != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _prefillFromExisting();
    }
  }

  void _prefillFromExisting() {
    final org = widget.organization!;
    _codeCtrl.text = org.code;
    _domainCtrl.text = org.domain;
    _orgType = orgTypeLabel(org.organizationType);
    _geoId = org.geoId;

    // If editing, skip to step 2 (details) since profile already exists
    if (org.profileId.isNotEmpty) {
      _currentStep = 1;
      // Load the profile
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadExistingProfile(org.profileId);
      });
    }
  }

  Future<void> _loadExistingProfile(String profileId) async {
    try {
      final profile = await ref.read(profileByIdProvider(profileId).future);
      if (mounted) {
        setState(() {
          _foundProfile = profile;
          _profileSearched = true;
          _nameCtrl.text = _extractName(profile);
          _descriptionCtrl.text = _extractProp(profile, 'description');
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _contactCtrl.dispose();
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    _codeCtrl.dispose();
    _domainCtrl.dispose();
    _newContactCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _countryCtrl.dispose();
    _postalCodeCtrl.dispose();
    super.dispose();
  }

  // -- Profile helpers
  String _extractName(profile.ProfileObject p) {
    try {
      if (p.properties.fields.containsKey('name')) {
        return p.properties.fields['name']!.stringValue;
      }
    } catch (_) {}
    if (p.contacts.isNotEmpty) return p.contacts.first.detail;
    return '';
  }

  String _extractProp(profile.ProfileObject p, String key) {
    try {
      if (p.properties.fields.containsKey(key)) {
        return p.properties.fields[key]!.stringValue;
      }
    } catch (_) {}
    return '';
  }

  // -- Step 1: Search profile by contact
  Future<void> _searchProfile() async {
    final contact = _contactCtrl.text.trim();
    if (contact.isEmpty) return;
    setState(() {
      _profileSearching = true;
      _profileSearched = false;
      _foundProfile = null;
    });
    try {
      // Use direct client call to avoid FutureProvider caching stale errors.
      final client = ref.read(profileServiceClientProvider);
      final request = profile.GetByContactRequest()..contact = contact;
      final response = await client.getByContact(request)
          .timeout(const Duration(seconds: 10));
      final result = response.data;
      if (!mounted) return;

      // Profile found — check if an organization already uses this profile
      try {
        final orgs = await ref.read(
          filteredOrganizationListProvider((
            query: '',
            parentId: '', // no parent filter
          )).future,
        );
        final linkedOrg = orgs
            .where((o) => o.profileId == result.id)
            .toList();

        if (linkedOrg.isNotEmpty && mounted) {
          Navigator.pop(context);
          context.go('/organizations/${linkedOrg.first.id}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Organization "${linkedOrg.first.name}" already exists for this profile',
              ),
            ),
          );
          return;
        }
      } catch (_) {
        // If org check fails, still proceed with the found profile
      }

      if (mounted) {
        setState(() {
          _foundProfile = result;
          _profileSearched = true;
          _profileSearching = false;
          _nameCtrl.text = _extractName(result);
          _descriptionCtrl.text = _extractProp(result, 'description');
        });
      }
    } catch (e) {
      // Profile not found or error — show creation form
      if (mounted) {
        setState(() {
          _foundProfile = null;
          _profileSearched = true;
          _profileSearching = false;
        });
      }
    }
  }

  Future<void> _createProfile() async {
    if (!_formKeys[0].currentState!.validate()) return;
    setState(() => _creatingProfile = true);

    try {
      // Upload avatar if provided
      String? avatarUri;
      if (_avatarBytes != null && _avatarFileName != null && widget.onPickLogo != null) {
        avatarUri = await widget.onPickLogo!(_avatarBytes!, _avatarFileName!);
      }

      final props = <String, profile.Value>{};
      props['name'] = profile.Value(stringValue: _nameCtrl.text.trim());
      if (_descriptionCtrl.text.trim().isNotEmpty) {
        props['description'] =
            profile.Value(stringValue: _descriptionCtrl.text.trim());
      }
      if (avatarUri != null) {
        props['avatar'] = profile.Value(stringValue: avatarUri);
      }

      final propsStruct = profile.Struct(fields: props);

      final created = await ref.read(profileNotifierProvider.notifier).create(
            profile.CreateRequest(
              type: profile.ProfileType.INSTITUTION,
              contact: _contactCtrl.text.trim(),
              properties: propsStruct,
            ),
          );

      if (mounted) {
        setState(() {
          _foundProfile = created;
          _creatingProfile = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _creatingProfile = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create profile: $e')),
        );
      }
    }
  }

  Future<void> _pickAvatar() async {
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
      _avatarBytes = bytes;
      _avatarFileName = picked.name;
    });
  }

  // -- Step 3: Add contact to profile
  Future<void> _addContactToProfile() async {
    final value = _newContactCtrl.text.trim();
    if (value.isEmpty || _foundProfile == null) return;

    try {
      final updated = await ref.read(contactNotifierProvider.notifier).addContact(
            profile.AddContactRequest(
              id: _foundProfile!.id,
              contact: value,
            ),
          );
      if (mounted) {
        setState(() {
          _foundProfile = updated;
          _newContactCtrl.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contact added')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      }
    }
  }

  // -- Navigation
  Future<void> _next() async {
    if (_currentStep == 0) {
      if (_foundProfile != null) {
        // Profile already resolved — proceed.
      } else if (!_profileSearched) {
        // Haven't searched yet — search first.
        if (_contactCtrl.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Enter a contact to search')),
          );
          return;
        }
        await _searchProfile();
        // If profile was found, proceed; if not, the creation form is now visible.
        if (_foundProfile == null) return;
      } else {
        // Searched but not found — auto-create if name is filled.
        if (_nameCtrl.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Enter a name to create the profile')),
          );
          return;
        }
        await _createProfile();
        if (_foundProfile == null) return; // creation failed
      }
    }
    if (!_formKeys[_currentStep].currentState!.validate()) return;
    if (_currentStep < _stepCount - 1) {
      setState(() => _currentStep++);
    } else {
      _submit();
    }
  }

  void _back() {
    if (_currentStep > (_isEditing ? 1 : 0)) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _submit() async {
    setState(() => _saving = true);

    try {
      // Save address to profile if any address field is filled
      final street = _streetCtrl.text.trim();
      final city = _cityCtrl.text.trim();
      final country = _countryCtrl.text.trim();
      final postalCode = _postalCodeCtrl.text.trim();
      if (_foundProfile != null &&
          (street.isNotEmpty ||
              city.isNotEmpty ||
              country.isNotEmpty)) {
        await ref.read(addressNotifierProvider.notifier).addAddress(
              profile.AddAddressRequest(
                id: _foundProfile!.id,
                address: profile.AddressObject(
                  name: 'Main Office',
                  street: street,
                  city: city,
                  country: country,
                  postcode: postalCode,
                ),
              ),
            );
      }

      // Build the organization object
      final org = widget.organization ?? OrganizationObject();
      org.name = _nameCtrl.text.trim();
      org.code = _codeCtrl.text.trim();
      org.domain = _domainCtrl.text.trim();
      org.geoId = _geoId;

      // Set org type from text input
      final typeText = _orgType.toLowerCase().replaceAll(' ', '_');
      for (final t in OrganizationType.values) {
        if (t.name.toLowerCase().contains(typeText)) {
          org.organizationType = t;
          break;
        }
      }

      await widget.onSave(OrganizationWizardResult(
        profileId: _foundProfile!.id,
        organization: org,
      ));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 680),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with step indicator
            _buildHeader(theme),

            // Body
            Flexible(
              child: IndexedStack(
                index: _currentStep,
                children: [
                  _buildStep1Contact(theme),
                  _buildStep2Details(theme),
                  _buildStep3Contacts(theme),
                  _buildStep4Location(theme),
                ],
              ),
            ),

            // Footer actions
            _buildFooter(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: theme.colorScheme.outlineVariant.withAlpha(60)),
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
                child: Icon(Icons.account_balance,
                    color: theme.colorScheme.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _isEditing ? 'Edit Organization' : 'New Organization',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
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
                  padding:
                      EdgeInsets.only(right: i < _stepCount - 1 ? 8 : 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: isDone
                                  ? theme.colorScheme.primary
                                  : isActive
                                      ? theme.colorScheme.primaryContainer
                                      : theme
                                          .colorScheme.surfaceContainerHighest,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: isDone
                                  ? Icon(Icons.check,
                                      size: 13,
                                      color: theme.colorScheme.onPrimary)
                                  : Text(
                                      '${i + 1}',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: isActive
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme
                                                .onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              _stepLabels[i],
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: isActive
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: isDone ? 1.0 : (isActive ? 0.5 : 0.0),
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
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
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              color: theme.colorScheme.outlineVariant.withAlpha(60)),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > (_isEditing ? 1 : 0))
            TextButton.icon(
              onPressed: _saving ? null : _back,
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
            onPressed: _saving ? null : _next,
            icon: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
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
    );
  }

  // =========================================================================
  // Step 1: Contact search → find/create profile
  // =========================================================================

  Widget _buildStep1Contact(ThemeData theme) {
    return Form(
      key: _formKeys[0],
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the primary contact for this organization',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'We will search for an existing profile. If not found, fill in the details and click Next to create one.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),

            // Contact search field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _contactCtrl,
                    decoration: InputDecoration(
                      hintText: 'Organization email or phone',
                      prefixIcon: const Icon(Icons.contact_mail_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onSubmitted: (_) => _searchProfile(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _profileSearching ? null : _searchProfile,
                  icon: _profileSearching
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.search, size: 18),
                  label: const Text('Search'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Profile found
            if (_profileSearched && _foundProfile != null)
              Card(
                elevation: 0,
                color: theme.colorScheme.primaryContainer.withAlpha(40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                      color: theme.colorScheme.primary.withAlpha(60)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: theme.colorScheme.primary, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Profile found',
                                style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary)),
                            ProfileBadge(
                              profileId: _foundProfile!.id,
                              name: _extractName(_foundProfile!),
                              avatarSize: 32,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Profile not found — show creation fields
            if (_profileSearched && _foundProfile == null)
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                      color: theme.colorScheme.outlineVariant.withAlpha(60)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: theme.colorScheme.secondary, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'No profile found. Fill in details below and click Next to create.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.secondary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: GestureDetector(
                          onTap: _pickAvatar,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor:
                                theme.colorScheme.primaryContainer,
                            backgroundImage: _avatarBytes != null
                                ? MemoryImage(_avatarBytes!)
                                : null,
                            child: _avatarBytes == null
                                ? Icon(Icons.add_a_photo,
                                    color: theme.colorScheme.primary,
                                    size: 24)
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: InputDecoration(
                          labelText: 'Organization Name',
                          hintText: 'e.g. Stawi Capital Limited',
                          prefixIcon: const Icon(Icons.business),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        validator: (v) => (_profileSearched &&
                                _foundProfile == null &&
                                (v == null || v.trim().isEmpty))
                            ? 'Name is required to create a profile'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _descriptionCtrl,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Brief description',
                          prefixIcon: const Icon(Icons.description_outlined),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        maxLines: 2,
                      ),
                      if (_creatingProfile) ...[
                        const SizedBox(height: 12),
                        const Center(child: CircularProgressIndicator()),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkExistingOrg(String profileId) async {
    try {
      final orgs = await ref.read(
        filteredOrganizationListProvider((
          query: '',
          parentId: '',
        )).future,
      );
      final linked = orgs.where((o) => o.profileId == profileId).toList();
      if (linked.isNotEmpty && mounted) {
        Navigator.pop(context);
        context.go('/organizations/${linked.first.id}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Organization "${linked.first.name}" already exists for this profile',
            ),
          ),
        );
      }
    } catch (_) {
      // If search fails, proceed normally
    }
  }

  // =========================================================================
  // Step 2: Organization details
  // =========================================================================

  Widget _buildStep2Details(ThemeData theme) {
    return Form(
      key: _formKeys[1],
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Column(
          children: [
            // Show profile summary
            if (_foundProfile != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ProfileBadge(
                  profileId: _foundProfile!.id,
                  name: _extractName(_foundProfile!),
                  description: 'Linked profile',
                  avatarSize: 40,
                ),
              ),

            FormFieldCard(
              label: 'Organization Name',
              isRequired: true,
              child: TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  hintText: 'e.g. Stawi Capital Limited',
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Name is required'
                    : null,
              ),
            ),
            FormFieldCard(
              label: 'Code',
              description: 'Unique short identifier for reports.',
              isRequired: true,
              child: TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(
                  hintText: 'e.g. STAWI',
                  prefixIcon: Icon(Icons.tag),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Code is required'
                    : null,
              ),
            ),
            FormFieldCard(
              label: 'Organization Type',
              description: 'e.g. bank, microfinance, sacco, fintech, cooperative',
              child: TextFormField(
                initialValue: _orgType,
                decoration: const InputDecoration(
                  hintText: 'e.g. microfinance',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                onChanged: (v) => _orgType = v.trim(),
              ),
            ),
            FormFieldCard(
              label: 'Domain',
              description: 'Primary web domain.',
              child: TextFormField(
                controller: _domainCtrl,
                decoration: const InputDecoration(
                  hintText: 'e.g. stawi.org',
                  prefixIcon: Icon(Icons.language),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // Step 3: Additional contacts (from profile, using ProfileInlineManager)
  // =========================================================================

  Widget _buildStep3Contacts(ThemeData theme) {
    return Form(
      key: _formKeys[2],
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage contacts for this organization',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'These contacts are stored on the organization\'s profile.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            if (_foundProfile != null)
              ProfileInlineManager(profileId: _foundProfile!.id)
            else
              Text(
                'Profile not yet created. Contacts will be added after profile creation.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // Step 4: Location (address on profile + geoId on org)
  // =========================================================================

  Widget _buildStep4Location(ThemeData theme) {
    return Form(
      key: _formKeys[3],
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Physical address and coverage area',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
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
            const Divider(height: 24),
            AreaPickerField(
              selectedAreaId: _geoId,
              label: 'Coverage Area',
              description: 'The geographic area this organization operates in.',
              isRequired: true,
              onSelected: (area) => setState(() {
                _geoId = area?.id ?? '';
              }),
            ),
          ],
        ),
      ),
    );
  }
}
