import 'dart:typed_data';

import 'package:antinvestor_api_identity/antinvestor_api_identity.dart';
import 'package:antinvestor_api_profile/antinvestor_api_profile.dart' as profile;
import 'package:antinvestor_ui_core/widgets/form_field_card.dart';
import 'package:antinvestor_ui_core/widgets/profile_badge.dart';
import 'package:antinvestor_ui_geolocation/antinvestor_ui_geolocation.dart'
    show AreaPickerField, AreaBadge;
import 'package:antinvestor_ui_profile/antinvestor_ui_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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
    });
    try {
      final result =
          await ref.read(profileByContactProvider(contact).future);
      if (mounted) {
        setState(() {
          _foundProfile = result;
          _profileSearched = true;
          _profileSearching = false;
          _nameCtrl.text = _extractName(result);
          _descriptionCtrl.text = _extractProp(result, 'description');
        });
      }
    } catch (_) {
      // Profile not found — allow creation
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
  void _next() {
    if (_currentStep == 0) {
      // Must have a profile before proceeding
      if (_foundProfile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Search for or create a profile first')),
        );
        return;
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

    try {
      await widget.onSave(OrganizationWizardResult(
        profileId: _foundProfile!.id,
        organization: org,
      ));
      if (mounted) Navigator.pop(context);
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
              'We will search for an existing profile. If not found, you can create one.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),

            // Contact search field
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _contactCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Email or phone number',
                      prefixIcon: Icon(Icons.contact_mail_outlined),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Enter a contact'
                        : null,
                    onFieldSubmitted: (_) => _searchProfile(),
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

            const SizedBox(height: 20),

            // Results
            if (_profileSearched && _foundProfile != null) ...[
              // Profile found
              Card(
                elevation: 0,
                color: theme.colorScheme.primaryContainer.withAlpha(40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: theme.colorScheme.primary.withAlpha(60)),
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
            ] else if (_profileSearched && _foundProfile == null) ...[
              // Not found — show create form
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
                          Text('No profile found. Create one below.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.secondary)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Avatar picker
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
                        decoration: const InputDecoration(
                          labelText: 'Organization Name',
                          hintText: 'e.g. Stawi Capital Limited',
                          prefixIcon: Icon(Icons.business),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Name is required'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descriptionCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Brief description',
                          prefixIcon: Icon(Icons.description_outlined),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _creatingProfile ? null : _createProfile,
                        icon: _creatingProfile
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.person_add, size: 18),
                        label: const Text('Create Profile'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
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
  // Step 3: Additional contacts (from profile)
  // =========================================================================

  Widget _buildStep3Contacts(ThemeData theme) {
    final contacts = _foundProfile?.contacts ?? [];

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

            // Existing contacts
            if (contacts.isNotEmpty) ...[
              ...contacts.map((c) => ContactListTile(contact: c)),
              const Divider(height: 24),
            ] else
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'No contacts yet. Add one below.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),

            // Add new contact
            Row(
              children: [
                ChoiceChip(
                  label: const Text('Email'),
                  selected: !_newContactIsPhone,
                  onSelected: (_) =>
                      setState(() => _newContactIsPhone = false),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Phone'),
                  selected: _newContactIsPhone,
                  onSelected: (_) =>
                      setState(() => _newContactIsPhone = true),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _newContactCtrl,
                    decoration: InputDecoration(
                      hintText: _newContactIsPhone
                          ? '+254 700 000 000'
                          : 'info@organization.com',
                      prefixIcon: Icon(
                        _newContactIsPhone
                            ? Icons.phone_outlined
                            : Icons.email_outlined,
                      ),
                    ),
                    keyboardType: _newContactIsPhone
                        ? TextInputType.phone
                        : TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: _addContactToProfile,
                  child: const Text('Add'),
                ),
              ],
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
