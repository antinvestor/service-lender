import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/error_helpers.dart';
import '../../../core/widgets/form_field_card.dart';
import '../../../core/widgets/profile_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/field/v1/field.pb.dart';
import '../../organization/data/branch_providers.dart';
import '../../organization/data/organization_providers.dart';
import '../data/agent_providers.dart';

/// Contact-first agent registration flow.
///
/// Step 1: Enter contact (email or phone) → search for existing profile
///         - If found: show profile details, confirm and proceed
///         - If not found: collect name, description to create new profile
/// Step 2: Assign to organization → branch → optional parent agent
///
/// Agent is created in CREATED state. Activation requires T&C acceptance.
class AgentCreateScreen extends ConsumerStatefulWidget {
  const AgentCreateScreen({super.key});

  @override
  ConsumerState<AgentCreateScreen> createState() => _AgentCreateScreenState();
}

class _AgentCreateScreenState extends ConsumerState<AgentCreateScreen> {
  int _step = 0; // 0=contact lookup, 1=placement
  bool _saving = false;

  // Step 0: Contact lookup
  final _contactCtrl = TextEditingController();
  Timer? _searchDebounce;
  _ProfileSearchState _searchState = _ProfileSearchState.idle;
  String _profileId = '';
  String _profileName = '';
  final String _profileDescription = '';

  // New profile fields (when not found)
  final _nameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  // Step 1: Placement
  String _selectedOrgId = '';
  String _selectedBranchId = '';
  String _selectedParentAgentId = '';
  AgentType _agentType = AgentType.AGENT_TYPE_INDIVIDUAL;

  @override
  void dispose() {
    _contactCtrl.dispose();
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Contact search
  // ─────────────────────────────────────────────────────────────────────────

  void _onContactChanged(String value) {
    _searchDebounce?.cancel();
    final trimmed = value.trim();

    if (trimmed.length < 3) {
      setState(() {
        _searchState = _ProfileSearchState.idle;
        _profileId = '';
        _profileName = '';
      });
      return;
    }

    setState(() => _searchState = _ProfileSearchState.searching);

    _searchDebounce = Timer(const Duration(milliseconds: 800), () {
      _searchProfile(trimmed);
    });
  }

  Future<void> _searchProfile(String contact) async {
    // TODO: Call profile service to search by contact (email/phone).
    // For now, simulate: if the contact looks like an existing profile ID,
    // treat it as found. In production, this calls:
    //   profileClient.Search(SearchRequest(query: contact))
    // and returns matching profiles.

    // Simulate search delay
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    // For now, always treat as "not found" — new profile will be created.
    // When profile service SDK is available, this will do a real lookup.
    setState(() {
      _searchState = _ProfileSearchState.notFound;
      _profileId = '';
      _profileName = '';
    });
  }

  void _confirmExistingProfile() {
    setState(() {
      _searchState = _ProfileSearchState.confirmed;
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Submit
  // ─────────────────────────────────────────────────────────────────────────

  bool _canProceedFromContact() {
    if (_searchState == _ProfileSearchState.confirmed) return true;
    if (_searchState == _ProfileSearchState.notFound) {
      return _nameCtrl.text.trim().isNotEmpty;
    }
    return false;
  }

  String get _agentName {
    if (_profileName.isNotEmpty) return _profileName;
    return _nameCtrl.text.trim();
  }

  Future<void> _submit() async {
    if (_selectedBranchId.isEmpty || _agentName.isEmpty) return;

    setState(() => _saving = true);

    final agent = AgentObject(
      name: _agentName,
      profileId: _profileId,
      branchId: _selectedBranchId,
      parentAgentId: _selectedParentAgentId,
      agentType: _agentType,
      state: STATE.CREATED,
    );

    // Store contact detail in properties for backend profile creation
    if (_profileId.isEmpty && _contactCtrl.text.trim().isNotEmpty) {
      agent.properties = _buildProperties();
    }

    try {
      await ref.read(agentProvider.notifier).save(agent);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Agent registered. They will receive a T&C acceptance invitation.',
            ),
          ),
        );
        context.go('/field/agents');
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

  dynamic _buildProperties() {
    // Build a Struct with contact and new profile info for backend processing
    // The backend AgentNotifier.CreateOrLinkProfile reads these
    final map = <String, dynamic>{
      'contact_detail': _contactCtrl.text.trim(),
    };
    if (_nameCtrl.text.trim().isNotEmpty) {
      map['display_name'] = _nameCtrl.text.trim();
    }
    if (_descriptionCtrl.text.trim().isNotEmpty) {
      map['description'] = _descriptionCtrl.text.trim();
    }
    return map;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
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
                        onPressed: () => context.go('/field/agents'),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.person_add_outlined,
                          color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Register New Agent',
                              style: theme.textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Find an existing user or create a new profile for the agent.',
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

          // Form content
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

          // Actions
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
                        onPressed: _saving || _selectedBranchId.isEmpty
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
                        label: const Text('Register Agent'),
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
        _StepDot(label: '1. Find Profile', isActive: _step == 0, isCompleted: _step > 0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(width: 32, height: 1, color: theme.dividerColor),
        ),
        _StepDot(label: '2. Placement', isActive: _step == 1, isCompleted: false),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Step 0: Contact lookup
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildContactStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldCard(
          label: 'Email or Phone Number',
          description:
              'Enter the agent\'s email address or phone number. '
              'We\'ll check if they already have a profile on the platform.',
          isRequired: true,
          child: TextFormField(
            controller: _contactCtrl,
            decoration: InputDecoration(
              hintText: 'e.g. jane@example.com or +254 700 123456',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchState == _ProfileSearchState.searching
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : _searchState == _ProfileSearchState.found ||
                          _searchState == _ProfileSearchState.confirmed
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: _onContactChanged,
          ),
        ),

        // Search result
        if (_searchState == _ProfileSearchState.found) ...[
          _buildFoundProfile(theme),
        ],

        if (_searchState == _ProfileSearchState.confirmed) ...[
          _buildConfirmedProfile(theme),
        ],

        if (_searchState == _ProfileSearchState.notFound) ...[
          _buildNewProfileForm(theme),
        ],
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
                Icon(Icons.person_search,
                    color: theme.colorScheme.primary, size: 20),
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
              description: _profileDescription.isNotEmpty
                  ? _profileDescription
                  : _contactCtrl.text.trim(),
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
            ProfileAvatar(
              profileId: _profileId,
              name: _profileName,
              size: 48,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _profileName,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
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
                Icon(Icons.info_outline,
                    size: 20, color: theme.colorScheme.onTertiaryContainer),
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
          description:
              'The agent\'s legal or display name as it will appear in the system.',
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
          description:
              'A short bio or role description. This is shown on the agent\'s profile.',
          child: TextFormField(
            controller: _descriptionCtrl,
            decoration: const InputDecoration(
              hintText: 'e.g. Senior Field Agent, Nairobi Region',
              prefixIcon: Icon(Icons.notes_outlined),
            ),
            maxLines: 2,
          ),
        ),

        // Preview card
        if (_nameCtrl.text.trim().isNotEmpty) ...[
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
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
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
                  Icon(Icons.person_add_outlined,
                      color: theme.colorScheme.primary),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Step 1: Placement (org → branch → parent agent → type)
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildPlacementStep() {
    final orgsAsync = ref.watch(organizationListProvider(''));
    final branchesAsync = ref.watch(branchListProvider('', _selectedOrgId));
    final branchAgentsAsync = _selectedBranchId.isNotEmpty
        ? ref.watch(agentListProvider(query: '', branchId: _selectedBranchId))
        : const AsyncValue<List<AgentObject>>.data([]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Agent preview
        Card(
          margin: const EdgeInsets.only(bottom: 20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ProfileAvatar(
                  profileId: _profileId.isNotEmpty ? _profileId : 'new',
                  name: _agentName,
                  size: 44,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _agentName,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        _contactCtrl.text.trim(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
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
          description: 'The organization this agent will represent.',
          isRequired: true,
          child: orgsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Failed to load: $e'),
            data: (orgs) => DropdownButtonFormField<String>(
              initialValue:
                  _selectedOrgId.isNotEmpty ? _selectedOrgId : null,
              decoration: const InputDecoration(
                hintText: 'Select organization',
                prefixIcon: Icon(Icons.business_outlined),
              ),
              items: orgs
                  .map((o) => DropdownMenuItem(
                      value: o.id,
                      child:
                          Text(o.name.isNotEmpty ? o.name : o.id)))
                  .toList(),
              onChanged: (v) => setState(() {
                _selectedOrgId = v ?? '';
                _selectedBranchId = '';
                _selectedParentAgentId = '';
              }),
            ),
          ),
        ),
        FormFieldCard(
          label: 'Branch',
          description: 'The branch office where this agent will operate.',
          isRequired: true,
          child: branchesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Failed to load: $e'),
            data: (branches) {
              if (_selectedOrgId.isEmpty) {
                return Text('Select an organization first',
                    style: TextStyle(
                        color: Theme.of(context).hintColor));
              }
              return DropdownButtonFormField<String>(
                initialValue: _selectedBranchId.isNotEmpty
                    ? _selectedBranchId
                    : null,
                decoration: const InputDecoration(
                  hintText: 'Select branch',
                  prefixIcon: Icon(Icons.store_outlined),
                ),
                items: branches
                    .map((b) => DropdownMenuItem(
                        value: b.id,
                        child: Text(
                            b.name.isNotEmpty ? b.name : b.id)))
                    .toList(),
                onChanged: (v) => setState(() {
                  _selectedBranchId = v ?? '';
                  _selectedParentAgentId = '';
                }),
              );
            },
          ),
        ),
        FormFieldCard(
          label: 'Supervising Agent',
          description:
              'Optional. Select a parent agent to create a sub-agent. '
              'Sub-agents are limited to one level deep.',
          child: branchAgentsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Failed to load: $e'),
            data: (agents) {
              if (_selectedBranchId.isEmpty) {
                return Text('Select a branch first',
                    style: TextStyle(
                        color: Theme.of(context).hintColor));
              }
              final topLevel =
                  agents.where((a) => a.depth <= 0).toList();
              return DropdownButtonFormField<String>(
                initialValue: _selectedParentAgentId.isNotEmpty
                    ? _selectedParentAgentId
                    : null,
                decoration: const InputDecoration(
                  hintText: 'None (top-level agent)',
                  prefixIcon: Icon(Icons.supervisor_account_outlined),
                ),
                items: [
                  const DropdownMenuItem(
                      value: '', child: Text('None (top-level agent)')),
                  ...topLevel.map((a) => DropdownMenuItem(
                      value: a.id,
                      child:
                          Text(a.name.isNotEmpty ? a.name : a.id))),
                ],
                onChanged: (v) => setState(
                    () => _selectedParentAgentId = v ?? ''),
              );
            },
          ),
        ),
        FormFieldCard(
          label: 'Agent Type',
          description:
              'Whether this agent operates individually or on behalf of an organization.',
          isRequired: true,
          child: DropdownButtonFormField<AgentType>(
            initialValue: _agentType,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: const [
              DropdownMenuItem(
                value: AgentType.AGENT_TYPE_INDIVIDUAL,
                child: Text('Individual Agent'),
              ),
              DropdownMenuItem(
                value: AgentType.AGENT_TYPE_ORGANIZATION,
                child: Text('Organizational Agent'),
              ),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _agentType = v);
            },
          ),
        ),

        // Activation notice
        const SizedBox(height: 8),
        Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'The agent will receive a notification at ${_contactCtrl.text.trim()} '
                    'to accept Terms & Conditions. Their account activates after acceptance.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
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

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

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
