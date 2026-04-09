import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/form_field_card.dart';
import '../../../core/widgets/profile_badge.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/field/v1/field.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../organization/data/branch_providers.dart';
import '../../organization/data/organization_providers.dart';
import '../data/agent_providers.dart';

class AgentsScreen extends ConsumerStatefulWidget {
  const AgentsScreen({super.key});

  @override
  ConsumerState<AgentsScreen> createState() => _AgentsScreenState();
}

class _AgentsScreenState extends ConsumerState<AgentsScreen> {
  String _searchQuery = '';
  String _orgFilter = '';
  String _branchFilter = '';

  @override
  Widget build(BuildContext context) {
    final agentsAsync = ref.watch(
      agentListProvider(query: _searchQuery, branchId: _branchFilter),
    );
    final canManage = ref.watch(canManageAgentsProvider);
    final orgsAsync = ref.watch(organizationListProvider(''));
    final branchesAsync = ref.watch(branchListProvider('', _orgFilter));

    return EntityListPage<AgentObject>(
      title: 'Agents',
      icon: Icons.person_pin_outlined,
      items: agentsAsync.value ?? [],
      isLoading: agentsAsync.isLoading,
      error: agentsAsync.hasError ? agentsAsync.error.toString() : null,
      onRetry: () => ref.invalidate(
        agentListProvider(query: _searchQuery, branchId: _branchFilter),
      ),
      searchHint: 'Search agents...',
      onSearchChanged: (value) => setState(() => _searchQuery = value),
      actionLabel: 'Register Agent',
      canAction: canManage.value ?? false,
      onAction: () => context.go('/field/agents/new'),
      filterWidget: _buildFilters(orgsAsync, branchesAsync),
      itemBuilder: (context, agent) => _AgentCard(
        agent: agent,
        onEdit: (canManage.value ?? false)
            ? () => _showAgentDialog(context, agent: agent)
            : null,
      ),
    );
  }

  Widget _buildFilters(
    AsyncValue<List<OrganizationObject>> orgsAsync,
    AsyncValue<List<BranchObject>> branchesAsync,
  ) {
    final orgs = orgsAsync.value ?? [];
    final branches = branchesAsync.value ?? [];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Organization filter
        DropdownButton<String>(
          value: _orgFilter,
          hint: const Text('All Orgs'),
          underline: const SizedBox.shrink(),
          items: [
            const DropdownMenuItem(value: '', child: Text('All Organizations')),
            ...orgs.map(
              (o) => DropdownMenuItem(
                value: o.id,
                child: Text(o.name.isNotEmpty ? o.name : o.id),
              ),
            ),
          ],
          onChanged: (value) => setState(() {
            _orgFilter = value ?? '';
            _branchFilter = ''; // Reset branch when org changes
          }),
        ),
        const SizedBox(width: 8),
        // Branch filter (filtered by selected org)
        DropdownButton<String>(
          value: _branchFilter,
          hint: const Text('All Branches'),
          underline: const SizedBox.shrink(),
          items: [
            const DropdownMenuItem(value: '', child: Text('All Branches')),
            ...branches.map(
              (b) => DropdownMenuItem(
                value: b.id,
                child: Text(b.name.isNotEmpty ? b.name : b.id),
              ),
            ),
          ],
          onChanged: (value) => setState(() => _branchFilter = value ?? ''),
        ),
      ],
    );
  }

  Future<void> _showAgentDialog(
    BuildContext context, {
    AgentObject? agent,
  }) async {
    final result = await showDialog<AgentObject>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AgentFormDialog(agent: agent),
    );

    if (result != null && context.mounted) {
      try {
        await ref.read(agentProvider.notifier).save(result);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                agent == null
                    ? 'Agent created successfully'
                    : 'Agent updated successfully',
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Agent card
// ---------------------------------------------------------------------------

class _AgentCard extends StatelessWidget {
  const _AgentCard({required this.agent, this.onEdit});
  final AgentObject agent;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = [
      if (agent.branchId.isNotEmpty) 'Branch: ${agent.branchId}',
      if (agent.parentAgentId.isNotEmpty) 'Parent: ${agent.parentAgentId}',
      if (agent.depth > 0) 'Depth: ${agent.depth}',
    ].join(' \u00b7 ');

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: () => context.go('/field/agents/${agent.id}'),
        leading: ProfileAvatar(
          profileId: agent.profileId,
          name: agent.name,
          size: 40,
        ),
        title: Text(
          agent.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(subtitle, style: theme.textTheme.bodySmall)
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StateBadge(state: agent.state),
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                onPressed: onEdit,
                tooltip: 'Edit',
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Agent create / edit dialog
// ---------------------------------------------------------------------------

class _AgentFormDialog extends ConsumerStatefulWidget {
  const _AgentFormDialog({this.agent});
  final AgentObject? agent;

  @override
  ConsumerState<_AgentFormDialog> createState() => _AgentFormDialogState();
}

class _AgentFormDialogState extends ConsumerState<_AgentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _profileIdController;
  late final TextEditingController _geoIdController;
  late String _selectedOrgId;
  late String _selectedBranchId;
  late String _selectedParentAgentId;
  late AgentType _agentType;
  late STATE _state;

  bool get _isEditing => widget.agent != null;

  @override
  void initState() {
    super.initState();
    final a = widget.agent;
    _nameController = TextEditingController(text: a?.name ?? '');
    _profileIdController = TextEditingController(text: a?.profileId ?? '');
    _geoIdController = TextEditingController(text: a?.geoId ?? '');
    _selectedOrgId = '';
    _selectedBranchId = a?.branchId ?? '';
    _selectedParentAgentId = a?.parentAgentId ?? '';
    _agentType = a?.agentType ?? AgentType.AGENT_TYPE_INDIVIDUAL;
    _state = a?.state ?? STATE.CREATED;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _profileIdController.dispose();
    _geoIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orgsAsync = ref.watch(organizationListProvider(''));
    final branchesAsync = ref.watch(branchListProvider('', _selectedOrgId));
    // Load agents in selected branch for parent agent dropdown
    final branchAgentsAsync = _selectedBranchId.isNotEmpty
        ? ref.watch(agentListProvider(query: '', branchId: _selectedBranchId))
        : const AsyncValue<List<AgentObject>>.data([]);

    return AlertDialog(
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.person_pin_outlined,
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
                  _isEditing ? 'Edit Agent' : 'New Agent',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _isEditing
                      ? 'Update the agent details below.'
                      : 'Register a new field agent in the system.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),

                // --- Identity ---
                FormFieldCard(
                  label: 'Agent Name',
                  description: 'The full name of the field agent.',
                  isRequired: true,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Jane Muthoni',
                      prefixIcon: Icon(Icons.person_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Name is required' : null,
                  ),
                ),
                FormFieldCard(
                  label: 'Profile ID',
                  description:
                      'The platform profile identifier linking this agent to their user account.',
                  isRequired: true,
                  child: TextFormField(
                    controller: _profileIdController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. d75qclkpf2t1uum8ij3g',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Profile ID is required'
                        : null,
                  ),
                ),

                // --- Placement (cascading) ---
                FormFieldCard(
                  label: 'Organization',
                  description:
                      'The organization this agent belongs to. Filters the available branches.',
                  isRequired: true,
                  child: orgsAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('Failed to load: $e'),
                    data: (orgs) => DropdownButtonFormField<String>(
                      initialValue:
                          _selectedOrgId.isNotEmpty &&
                              orgs.any((o) => o.id == _selectedOrgId)
                          ? _selectedOrgId
                          : null,
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
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Organization is required'
                          : null,
                      onChanged: (v) => setState(() {
                        _selectedOrgId = v ?? '';
                        _selectedBranchId = ''; // Reset branch
                        _selectedParentAgentId = ''; // Reset parent
                      }),
                    ),
                  ),
                ),
                FormFieldCard(
                  label: 'Branch',
                  description: 'The branch office this agent operates from.',
                  isRequired: true,
                  child: branchesAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('Failed to load: $e'),
                    data: (branches) {
                      if (_selectedOrgId.isEmpty) {
                        return const Text(
                          'Select an organization first',
                          style: TextStyle(color: Colors.grey),
                        );
                      }
                      return DropdownButtonFormField<String>(
                        initialValue:
                            _selectedBranchId.isNotEmpty &&
                                branches.any((b) => b.id == _selectedBranchId)
                            ? _selectedBranchId
                            : null,
                        decoration: const InputDecoration(
                          hintText: 'Select branch',
                          prefixIcon: Icon(Icons.store_outlined),
                        ),
                        items: branches
                            .map(
                              (b) => DropdownMenuItem(
                                value: b.id,
                                child: Text(b.name.isNotEmpty ? b.name : b.id),
                              ),
                            )
                            .toList(),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Branch is required'
                            : null,
                        onChanged: (v) => setState(() {
                          _selectedBranchId = v ?? '';
                          _selectedParentAgentId = ''; // Reset parent
                        }),
                      );
                    },
                  ),
                ),
                FormFieldCard(
                  label: 'Supervising Agent',
                  description:
                      'Optional. Select a parent agent to create a sub-agent. '
                      'Sub-agents can only be one level deep.',
                  child: branchAgentsAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('Failed to load: $e'),
                    data: (agents) {
                      // Filter to only top-level agents (depth 0) — enforces max 1 level of sub-agents
                      final topLevelAgents = agents
                          .where((a) => a.depth <= 0)
                          .toList();
                      if (_selectedBranchId.isEmpty) {
                        return const Text(
                          'Select a branch first',
                          style: TextStyle(color: Colors.grey),
                        );
                      }
                      return DropdownButtonFormField<String>(
                        initialValue:
                            _selectedParentAgentId.isNotEmpty &&
                                topLevelAgents.any(
                                  (a) => a.id == _selectedParentAgentId,
                                )
                            ? _selectedParentAgentId
                            : null,
                        decoration: const InputDecoration(
                          hintText: 'None (top-level agent)',
                          prefixIcon: Icon(Icons.supervisor_account_outlined),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: '',
                            child: Text('None (top-level agent)'),
                          ),
                          ...topLevelAgents.map(
                            (a) => DropdownMenuItem(
                              value: a.id,
                              child: Text(a.name.isNotEmpty ? a.name : a.id),
                            ),
                          ),
                        ],
                        onChanged: (v) => setState(() {
                          _selectedParentAgentId = v ?? '';
                        }),
                      );
                    },
                  ),
                ),

                // --- Classification ---
                FormFieldCard(
                  label: 'Agent Type',
                  description:
                      'The operational role of this agent in the field.',
                  isRequired: true,
                  child: DropdownButtonFormField<AgentType>(
                    initialValue: _agentType,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: AgentType.AGENT_TYPE_INDIVIDUAL,
                        child: Text('Individual'),
                      ),
                      DropdownMenuItem(
                        value: AgentType.AGENT_TYPE_ORGANIZATION,
                        child: Text('Organization'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _agentType = v);
                    },
                  ),
                ),
                FormFieldCard(
                  label: 'Geographic ID',
                  description:
                      "Optional geographic area identifier for this agent's territory.",
                  child: TextFormField(
                    controller: _geoIdController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. KE-NBI-EAST',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                ),
                FormFieldCard(
                  label: 'State',
                  description: 'The current operational status of this agent.',
                  isRequired: true,
                  child: DropdownButtonFormField<STATE>(
                    initialValue: _state,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.toggle_on_outlined),
                    ),
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
                    onChanged: (v) {
                      if (v != null) setState(() => _state = v);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: Icon(_isEditing ? Icons.save : Icons.add),
          label: Text(_isEditing ? 'Update Agent' : 'Create Agent'),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      AgentObject(
        id: widget.agent?.id ?? '',
        name: _nameController.text.trim(),
        profileId: _profileIdController.text.trim(),
        branchId: _selectedBranchId,
        parentAgentId: _selectedParentAgentId,
        agentType: _agentType,
        geoId: _geoIdController.text.trim(),
        state: _state,
      ),
    );
  }
}
