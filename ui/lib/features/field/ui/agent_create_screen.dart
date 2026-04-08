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

/// Multi-step agent creation screen.
///
/// Step 1: Find or create a profile for the agent
/// Step 2: Assign to an organization, branch, and optionally a parent agent
///
/// The agent is created in CREATED state. They must accept Terms & Conditions
/// (via notification/first-login flow) before being activated.
class AgentCreateScreen extends ConsumerStatefulWidget {
  const AgentCreateScreen({super.key});

  @override
  ConsumerState<AgentCreateScreen> createState() => _AgentCreateScreenState();
}

class _AgentCreateScreenState extends ConsumerState<AgentCreateScreen> {
  int _step = 0;
  bool _saving = false;

  // Step 1: Profile
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _profileId = '';

  // Step 2: Placement
  String _selectedOrgId = '';
  String _selectedBranchId = '';
  String _selectedParentAgentId = '';
  AgentType _agentType = AgentType.AGENT_TYPE_INDIVIDUAL;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nameCtrl.text.trim().isEmpty || _selectedBranchId.isEmpty) return;

    setState(() => _saving = true);

    final agent = AgentObject(
      name: _nameCtrl.text.trim(),
      profileId: _profileId.isNotEmpty ? _profileId : '',
      branchId: _selectedBranchId,
      parentAgentId: _selectedParentAgentId,
      agentType: _agentType,
      state: STATE.CREATED, // Always CREATED — activation requires T&C acceptance
    );

    try {
      await ref.read(agentProvider.notifier).save(agent);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Agent created. They must accept Terms & Conditions to become active.',
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
                              'Set up a new agent profile and assign them to a branch.',
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
                  // Step indicator
                  Row(
                    children: [
                      _StepIndicator(
                        label: '1. Profile',
                        isActive: _step == 0,
                        isCompleted: _step > 0,
                      ),
                      const SizedBox(width: 8),
                      Container(width: 24, height: 1, color: theme.dividerColor),
                      const SizedBox(width: 8),
                      _StepIndicator(
                        label: '2. Placement',
                        isActive: _step == 1,
                        isCompleted: false,
                      ),
                    ],
                  ),
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
                child: _step == 0 ? _buildProfileStep() : _buildPlacementStep(),
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
                        onPressed: _saving ? null : () => setState(() => _step--),
                        child: const Text('Back'),
                      ),
                    const SizedBox(width: 12),
                    if (_step == 0)
                      FilledButton(
                        onPressed: _canProceedFromProfile()
                            ? () => setState(() => _step = 1)
                            : null,
                        child: const Text('Next: Placement'),
                      ),
                    if (_step == 1)
                      FilledButton.icon(
                        onPressed:
                            _saving || _selectedBranchId.isEmpty ? null : _submit,
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
                        label: const Text('Create Agent'),
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

  bool _canProceedFromProfile() {
    return _nameCtrl.text.trim().isNotEmpty;
  }

  // ---------------------------------------------------------------------------
  // Step 1: Profile — search existing or enter new details
  // ---------------------------------------------------------------------------

  Widget _buildProfileStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSection(
          title: 'Agent Profile',
          description:
              'Enter the agent\'s details. If they already have a platform account, '
              'enter their profile ID to link the existing profile.',
          children: [
            FormFieldCard(
              label: 'Full Name',
              description: 'The agent\'s legal or display name as it will appear in the system.',
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
              label: 'Email Address',
              description:
                  'Used to send the Terms & Conditions acceptance invitation. '
                  'The agent must accept before they can be activated.',
              child: TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  hintText: 'e.g. jane@example.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            FormFieldCard(
              label: 'Phone Number',
              description: 'The agent\'s primary contact number.',
              child: TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(
                  hintText: 'e.g. +254 700 123456',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
            FormFieldCard(
              label: 'Existing Profile ID',
              description:
                  'If this person already has a platform profile, paste their ID here '
                  'to link the agent to the existing account. Leave blank to create a new profile.',
              child: TextFormField(
                initialValue: _profileId,
                decoration: const InputDecoration(
                  hintText: 'Leave blank for new profile',
                  prefixIcon: Icon(Icons.link_outlined),
                ),
                onChanged: (v) => setState(() => _profileId = v.trim()),
              ),
            ),
          ],
        ),

        if (_nameCtrl.text.trim().isNotEmpty) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ProfileAvatar(
                    profileId: _profileId.isNotEmpty ? _profileId : 'new',
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
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _profileId.isNotEmpty
                              ? 'Linking to existing profile'
                              : 'A new profile will be created',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _profileId.isNotEmpty
                        ? Icons.link
                        : Icons.person_add_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Step 2: Placement — organization, branch, parent agent, type
  // ---------------------------------------------------------------------------

  Widget _buildPlacementStep() {
    final orgsAsync = ref.watch(organizationListProvider(''));
    final branchesAsync = ref.watch(branchListProvider('', _selectedOrgId));
    final branchAgentsAsync = _selectedBranchId.isNotEmpty
        ? ref.watch(agentListProvider(query: '', branchId: _selectedBranchId))
        : const AsyncValue<List<AgentObject>>.data([]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSection(
          title: 'Organizational Placement',
          description:
              'Assign this agent to an organization and branch. '
              'Optionally select a supervising agent to create a sub-agent.',
          children: [
            FormFieldCard(
              label: 'Organization',
              description: 'The organization this agent will represent.',
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
                      .map((o) => DropdownMenuItem(
                            value: o.id,
                            child: Text(o.name.isNotEmpty ? o.name : o.id),
                          ))
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
                    return Text(
                      'Select an organization first',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    );
                  }
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedBranchId.isNotEmpty ? _selectedBranchId : null,
                    decoration: const InputDecoration(
                      hintText: 'Select branch',
                      prefixIcon: Icon(Icons.store_outlined),
                    ),
                    items: branches
                        .map((b) => DropdownMenuItem(
                              value: b.id,
                              child: Text(b.name.isNotEmpty ? b.name : b.id),
                            ))
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
                    return Text(
                      'Select a branch first',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    );
                  }
                  final topLevel = agents.where((a) => a.depth <= 0).toList();
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedParentAgentId.isNotEmpty
                        ? _selectedParentAgentId
                        : null,
                    decoration: const InputDecoration(
                      hintText: 'None (top-level agent)',
                      prefixIcon: Icon(Icons.supervisor_account_outlined),
                    ),
                    items: [
                      const DropdownMenuItem(value: '', child: Text('None (top-level agent)')),
                      ...topLevel.map((a) => DropdownMenuItem(
                            value: a.id,
                            child: Text(a.name.isNotEmpty ? a.name : a.id),
                          )),
                    ],
                    onChanged: (v) =>
                        setState(() => _selectedParentAgentId = v ?? ''),
                  );
                },
              ),
            ),
            FormFieldCard(
              label: 'Agent Type',
              description: 'Whether this agent operates as an individual or on behalf of an organization.',
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
          ],
        ),

        const SizedBox(height: 16),
        // Activation notice
        Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'The agent will be created in "Created" status. '
                    'They must log in and accept the Terms & Conditions '
                    'before their account is activated.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
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

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
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
