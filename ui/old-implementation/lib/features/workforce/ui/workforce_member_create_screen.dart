import 'dart:async';

import 'package:antinvestor_api_profile/antinvestor_api_profile.dart'
    as profile_api;
import 'package:connectrpc/connect.dart' show Code, ConnectException;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/api/api_provider.dart';
import '../../../core/widgets/dynamic_form.dart' show mapToStruct;
import '../../../sdk/src/google/protobuf/struct.pb.dart' as struct_pb;
import '../../../core/widgets/error_helpers.dart';
import '../../../core/widgets/form_field_card.dart';
import '../../../core/widgets/profile_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../../core/auth/tenancy_context.dart';
import '../../organization/data/org_unit_providers.dart';
import '../../organization/data/organization_providers.dart';
import '../data/workforce_member_providers.dart';

/// Contact-first workforce member registration flow.
///
/// Step 1: Enter contact (email or phone) -> search for existing profile
///         - If found: show profile details, confirm and proceed
///         - If not found: collect name, description to create new profile
/// Step 2: Assign to organization -> org unit -> engagement type
///
/// Member is created in CREATED state. Activation requires T&C acceptance.
class WorkforceMemberCreateScreen extends ConsumerStatefulWidget {
  const WorkforceMemberCreateScreen({super.key});

  @override
  ConsumerState<WorkforceMemberCreateScreen> createState() =>
      _WorkforceMemberCreateScreenState();
}

class _WorkforceMemberCreateScreenState
    extends ConsumerState<WorkforceMemberCreateScreen> {
  int _step = 0;
  bool _saving = false;
  bool _tenancyInitialized = false;

  // Step 0: Contact lookup
  final _contactCtrl = TextEditingController();
  _ProfileSearchState _searchState = _ProfileSearchState.idle;
  String _profileId = '';
  String _profileName = '';

  // New profile fields (when not found)
  final _nameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  // Step 1: Placement
  String _selectedOrgId = '';
  String _selectedOrgUnitId = '';
  WorkforceEngagementType _engagementType =
      WorkforceEngagementType.WORKFORCE_ENGAGEMENT_TYPE_EMPLOYEE;

  @override
  void dispose() {
    _contactCtrl.dispose();
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _initFromTenancy() {
    if (_tenancyInitialized) return;
    _tenancyInitialized = true;
    final tenancy = ref.read(tenancyContextProvider);
    if (tenancy.hasOrganization && _selectedOrgId.isEmpty) {
      _selectedOrgId = tenancy.organizationId;
    }
  }

  void _onContactChanged(String value) {
    final trimmed = value.trim();
    if (trimmed.length < 3) {
      setState(() {
        _searchState = _ProfileSearchState.idle;
        _profileId = '';
        _profileName = '';
      });
      return;
    }
    if (_searchState == _ProfileSearchState.found ||
        _searchState == _ProfileSearchState.confirmed ||
        _searchState == _ProfileSearchState.notFound) {
      setState(() => _searchState = _ProfileSearchState.idle);
    }
  }

  void _triggerSearch() {
    final trimmed = _contactCtrl.text.trim();
    if (trimmed.length < 3) return;
    setState(() => _searchState = _ProfileSearchState.searching);
    _searchProfile(trimmed);
  }

  Future<void> _searchProfile(String contact) async {
    final profileClient = ref.read(profileServiceClientProvider);
    try {
      final response = await profileClient.getByContact(
        profile_api.GetByContactRequest(contact: contact),
      );
      if (!mounted) return;
      final profile = response.data;
      final name = profile.properties.fields['name']?.stringValue ?? '';
      setState(() {
        _searchState = _ProfileSearchState.found;
        _profileId = profile.id;
        _profileName = name.isNotEmpty ? name : profile.id;
      });
    } on ConnectException catch (e) {
      if (!mounted) return;
      if (e.code == Code.notFound) {
        setState(() {
          _searchState = _ProfileSearchState.notFound;
          _profileId = '';
          _profileName = '';
        });
      } else {
        setState(() {
          _searchState = _ProfileSearchState.notFound;
          _profileId = '';
          _profileName = '';
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _searchState = _ProfileSearchState.notFound;
        _profileId = '';
        _profileName = '';
      });
    }
  }

  void _confirmExistingProfile() {
    setState(() => _searchState = _ProfileSearchState.confirmed);
  }

  bool _canProceedFromContact() {
    if (_searchState == _ProfileSearchState.confirmed) return true;
    if (_searchState == _ProfileSearchState.notFound) {
      return _nameCtrl.text.trim().isNotEmpty;
    }
    return false;
  }

  String get _memberName {
    if (_profileName.isNotEmpty) return _profileName;
    return _nameCtrl.text.trim();
  }

  Future<void> _submit() async {
    if (_selectedOrgId.isEmpty || _memberName.isEmpty) return;

    setState(() => _saving = true);

    final member = WorkforceMemberObject(
      profileId: _profileId,
      organizationId: _selectedOrgId,
      homeOrgUnitId: _selectedOrgUnitId,
      engagementType: _engagementType,
      state: STATE.CREATED,
    );

    // Store contact detail in properties for backend profile creation
    if (_profileId.isEmpty && _contactCtrl.text.trim().isNotEmpty) {
      member.properties = _buildProperties();
    }

    try {
      await ref
          .read(identityServiceClientProvider)
          .workforceMemberSave(WorkforceMemberSaveRequest(data: member));

      ref.invalidate(workforceMemberListProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Member registered. They will receive an activation invitation.',
            ),
          ),
        );
        context.go('/workforce/members');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(friendlyError(e)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        setState(() => _saving = false);
      }
    }
  }

  struct_pb.Struct _buildProperties() {
    final propsMap = <String, dynamic>{
      'contact_detail': _contactCtrl.text.trim(),
    };
    if (_nameCtrl.text.trim().isNotEmpty) {
      propsMap['display_name'] = _nameCtrl.text.trim();
      propsMap['name'] = _nameCtrl.text.trim();
    }
    if (_descriptionCtrl.text.trim().isNotEmpty) {
      propsMap['description'] = _descriptionCtrl.text.trim();
    }
    return mapToStruct(propsMap);
  }

  @override
  Widget build(BuildContext context) {
    _initFromTenancy();
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => context.go('/workforce/members'),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.person_add_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Register Workforce Member',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Find an existing user or create a new profile.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildStepIndicator(theme),
                  const Divider(height: 32),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: _step == 0
                    ? _buildContactStep(theme)
                    : _buildPlacementStep(),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_step > 0)
                      TextButton(
                        onPressed:
                            _saving ? null : () => setState(() => _step = 0),
                        child: const Text('Back'),
                      ),
                    const SizedBox(width: 12),
                    if (_step == 0)
                      FilledButton(
                        onPressed: _canProceedFromContact()
                            ? () => setState(() => _step = 1)
                            : null,
                        child: const Text('Next: Placement'),
                      ),
                    if (_step == 1)
                      FilledButton.icon(
                        onPressed: _saving || _selectedOrgId.isEmpty
                            ? null
                            : _submit,
                        icon: _saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.person_add),
                        label: const Text('Register Member'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(ThemeData theme) {
    return Row(
      children: [
        _StepDot(
          label: '1. Find Profile',
          isActive: _step == 0,
          isCompleted: _step > 0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(width: 32, height: 1, color: theme.dividerColor),
        ),
        _StepDot(
          label: '2. Placement',
          isActive: _step == 1,
          isCompleted: false,
        ),
      ],
    );
  }

  Widget _buildContactStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldCard(
          label: 'Email or Phone Number',
          description:
              'Enter the member\'s email address or phone number, then press '
              'Search to check if they already have a profile on the platform.',
          isRequired: true,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _contactCtrl,
                  decoration: InputDecoration(
                    hintText: 'e.g. jane@example.com or +254 700 123456',
                    prefixIcon: const Icon(Icons.alternate_email),
                    suffixIcon: _searchState == _ProfileSearchState.found ||
                            _searchState == _ProfileSearchState.confirmed
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: _onContactChanged,
                  onFieldSubmitted: (_) => _triggerSearch(),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: FilledButton.icon(
                  onPressed: _searchState == _ProfileSearchState.searching ||
                          _contactCtrl.text.trim().length < 3
                      ? null
                      : _triggerSearch,
                  icon: _searchState == _ProfileSearchState.searching
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.search, size: 20),
                  label: const Text('Search'),
                ),
              ),
            ],
          ),
        ),
        if (_searchState == _ProfileSearchState.found)
          _buildFoundProfile(theme),
        if (_searchState == _ProfileSearchState.confirmed)
          _buildConfirmedProfile(theme),
        if (_searchState == _ProfileSearchState.notFound)
          _buildNewProfileForm(theme),
      ],
    );
  }

  Widget _buildFoundProfile(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_search,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Profile Found',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ProfileBadge(
              profileId: _profileId,
              name: _profileName,
              description: _contactCtrl.text.trim(),
              avatarSize: 48,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _searchState = _ProfileSearchState.idle;
                      _contactCtrl.clear();
                      _profileId = '';
                    });
                  },
                  child: const Text('Use Different Contact'),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: _confirmExistingProfile,
                  child: const Text('Confirm & Continue'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmedProfile(ThemeData theme) {
    return Card(
      color: theme.colorScheme.primaryContainer.withAlpha(50),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ProfileAvatar(profileId: _profileId, name: _profileName, size: 48),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _profileName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Linked to existing profile',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.verified, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildNewProfileForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: theme.colorScheme.tertiaryContainer.withAlpha(60),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: theme.colorScheme.onTertiaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No existing profile found for this contact. '
                    'Please provide details to create a new profile.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        FormFieldCard(
          label: 'Full Name',
          description: 'The member\'s display name as it will appear.',
          isRequired: true,
          child: TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              hintText: 'e.g. Jane Muthoni Wanjiku',
              prefixIcon: Icon(Icons.person_outlined),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        FormFieldCard(
          label: 'Description',
          description: 'A short bio or role description.',
          child: TextFormField(
            controller: _descriptionCtrl,
            decoration: const InputDecoration(
              hintText: 'e.g. Senior Loan Officer, Nairobi Region',
              prefixIcon: Icon(Icons.notes_outlined),
            ),
            maxLines: 2,
          ),
        ),
        if (_nameCtrl.text.trim().isNotEmpty)
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ProfileAvatar(
                    profileId: 'new',
                    name: _nameCtrl.text.trim(),
                    size: 48,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nameCtrl.text.trim(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_descriptionCtrl.text.trim().isNotEmpty)
                          Text(
                            _descriptionCtrl.text.trim(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        Text(
                          _contactCtrl.text.trim(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.person_add_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlacementStep() {
    final orgsAsync = ref.watch(organizationListProvider(''));
    final orgUnitsAsync = ref.watch(orgUnitListProvider(organizationId: _selectedOrgId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Member preview
        Card(
          margin: const EdgeInsets.only(bottom: 20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ProfileAvatar(
                  profileId: _profileId.isNotEmpty ? _profileId : 'new',
                  name: _memberName,
                  size: 44,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _memberName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _contactCtrl.text.trim(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        FormFieldCard(
          label: 'Organization',
          description: 'The organization this member will belong to.',
          isRequired: true,
          child: orgsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Failed to load: $e'),
            data: (orgs) => DropdownButtonFormField<String>(
              initialValue: _selectedOrgId.isNotEmpty ? _selectedOrgId : null,
              decoration: const InputDecoration(
                hintText: 'Select organization',
                prefixIcon: Icon(Icons.business_outlined),
              ),
              items: orgs
                  .map(
                    (o) => DropdownMenuItem(
                      value: o.id,
                      child: Text(o.name.isNotEmpty ? o.name : o.id),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() {
                _selectedOrgId = v ?? '';
                _selectedOrgUnitId = '';
              }),
            ),
          ),
        ),
        FormFieldCard(
          label: 'Home Org Unit',
          description:
              'Optional. The org unit where this member will be primarily based.',
          child: orgUnitsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Failed to load: $e'),
            data: (units) {
              if (_selectedOrgId.isEmpty) {
                return Text(
                  'Select an organization first',
                  style: TextStyle(color: Theme.of(context).hintColor),
                );
              }
              return DropdownButtonFormField<String>(
                initialValue:
                    _selectedOrgUnitId.isNotEmpty ? _selectedOrgUnitId : null,
                decoration: const InputDecoration(
                  hintText: 'Select org unit',
                  prefixIcon: Icon(Icons.account_tree_outlined),
                ),
                items: [
                  const DropdownMenuItem(value: '', child: Text('None')),
                  ...units.map(
                    (u) => DropdownMenuItem(
                      value: u.id,
                      child: Text(u.name.isNotEmpty ? u.name : u.id),
                    ),
                  ),
                ],
                onChanged: (v) =>
                    setState(() => _selectedOrgUnitId = v ?? ''),
              );
            },
          ),
        ),
        FormFieldCard(
          label: 'Engagement Type',
          description: 'How this member is engaged with the organization.',
          isRequired: true,
          child: DropdownButtonFormField<WorkforceEngagementType>(
            initialValue: _engagementType,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.work_outline),
            ),
            items: const [
              DropdownMenuItem(
                value:
                    WorkforceEngagementType.WORKFORCE_ENGAGEMENT_TYPE_EMPLOYEE,
                child: Text('Employee'),
              ),
              DropdownMenuItem(
                value: WorkforceEngagementType
                    .WORKFORCE_ENGAGEMENT_TYPE_CONTRACTOR,
                child: Text('Contractor'),
              ),
              DropdownMenuItem(
                value: WorkforceEngagementType
                    .WORKFORCE_ENGAGEMENT_TYPE_SERVICE_ACCOUNT,
                child: Text('Service Account'),
              ),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _engagementType = v);
            },
          ),
        ),
        const SizedBox(height: 8),
        Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'The member will receive a notification at ${_contactCtrl.text.trim()} '
                    'to accept Terms & Conditions. Their account activates after acceptance.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum _ProfileSearchState { idle, searching, found, confirmed, notFound }

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  final String label;
  final bool isActive;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive
        ? theme.colorScheme.primary
        : isCompleted
            ? theme.colorScheme.primary.withAlpha(180)
            : theme.colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isCompleted)
          Icon(Icons.check_circle, size: 18, color: color)
        else
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
              color: isActive ? color : null,
            ),
          ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
