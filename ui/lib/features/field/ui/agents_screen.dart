import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/form_field_card.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/field/v1/field.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../organization/data/branch_providers.dart';
import '../data/agent_providers.dart';

class AgentsScreen extends ConsumerStatefulWidget {
  const AgentsScreen({super.key});

  @override
  ConsumerState<AgentsScreen> createState() => _AgentsScreenState();
}

class _AgentsScreenState extends ConsumerState<AgentsScreen> {
  String _searchQuery = '';
  String _branchFilter = '';

  @override
  Widget build(BuildContext context) {
    final agentsAsync = ref.watch(
      agentListProvider(query: _searchQuery, branchId: _branchFilter),
    );
    final canManage = ref.watch(canManageAgentsProvider);
    final branchesAsync = ref.watch(branchListProvider('', ''));

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
      actionLabel: 'Add Agent',
      canAction: canManage.value ?? false,
      onAction: () => _showAgentDialog(context),
      filterWidget: _buildBranchFilter(branchesAsync),
      itemBuilder: (context, agent) => _AgentCard(
        agent: agent,
        onEdit: (canManage.value ?? false)
            ? () => _showAgentDialog(context, agent: agent)
            : null,
      ),
    );
  }

  Widget _buildBranchFilter(AsyncValue<List<BranchObject>> branchesAsync) {
    final branches = branchesAsync.value ?? [];
    return DropdownButton<String>(
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
    );
  }

  Future<void> _showAgentDialog(
    BuildContext context, {
    AgentObject? agent,
  }) async {
    final result = await showDialog<AgentObject>(
      context: context,
      builder: (context) => _AgentFormDialog(agent: agent),
    );
    if (result == null || !mounted) return;

    try {
      await ref.read(agentProvider.notifier).save(result);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            agent == null
                ? 'Agent created successfully'
                : 'Agent updated successfully',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save agent: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

class _AgentCard extends StatelessWidget {
  const _AgentCard({required this.agent, this.onEdit});

  final AgentObject agent;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withAlpha(80),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  agent.agentType == AgentType.AGENT_TYPE_ORGANIZATION
                      ? Icons.business
                      : Icons.person,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agent.name.isNotEmpty ? agent.name : '(unnamed)',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _InfoChip(
                          label: _agentTypeLabel(agent.agentType),
                          icon: Icons.badge_outlined,
                        ),
                        const SizedBox(width: 8),
                        if (agent.branchId.isNotEmpty) ...[
                          _InfoChip(
                            label: 'Branch: ${agent.branchId}',
                            icon: Icons.store_outlined,
                          ),
                          const SizedBox(width: 8),
                        ],
                        _InfoChip(
                          label: 'Depth: ${agent.depth}',
                          icon: Icons.account_tree_outlined,
                        ),
                      ],
                    ),
                    if (agent.parentAgentId.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Parent: ${agent.parentAgentId}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(140),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              StateBadge(state: agent.state),
            ],
          ),
        ),
      ),
    );
  }

  static String _agentTypeLabel(AgentType type) {
    return switch (type) {
      AgentType.AGENT_TYPE_INDIVIDUAL => 'Individual',
      AgentType.AGENT_TYPE_ORGANIZATION => 'Organization',
      _ => 'Unspecified',
    };
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: theme.colorScheme.onSurface.withAlpha(120)),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(160),
          ),
        ),
      ],
    );
  }
}

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
  late final TextEditingController _parentAgentIdController;
  late final TextEditingController _geoIdController;
  late String _selectedBranchId;
  late AgentType _agentType;
  late STATE _state;

  bool get _isEditing => widget.agent != null;

  @override
  void initState() {
    super.initState();
    final a = widget.agent;
    _nameController = TextEditingController(text: a?.name ?? '');
    _profileIdController = TextEditingController(text: a?.profileId ?? '');
    _parentAgentIdController =
        TextEditingController(text: a?.parentAgentId ?? '');
    _geoIdController = TextEditingController(text: a?.geoId ?? '');
    _selectedBranchId = a?.branchId ?? '';
    _agentType = a?.agentType ?? AgentType.AGENT_TYPE_INDIVIDUAL;
    _state = a?.state ?? STATE.CREATED;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _profileIdController.dispose();
    _parentAgentIdController.dispose();
    _geoIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branchesAsync = ref.watch(branchListProvider('', ''));
    final theme = Theme.of(context);

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
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
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
                FormFieldCard(
                  label: 'Agent Name',
                  description:
                      'The full name of the field agent.',
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
                      hintText: 'e.g. prof-abc123',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Profile ID is required'
                        : null,
                  ),
                ),
                FormFieldCard(
                  label: 'Branch',
                  description:
                      'The branch office this agent operates from.',
                  isRequired: true,
                  child: branchesAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('Failed to load branches: $e'),
                    data: (branches) => DropdownButtonFormField<String>(
                      initialValue: _selectedBranchId.isNotEmpty &&
                              branches.any((b) => b.id == _selectedBranchId)
                          ? _selectedBranchId
                          : null,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.store_outlined),
                      ),
                      items: [
                        for (final branch in branches)
                          DropdownMenuItem(
                            value: branch.id,
                            child: Text(
                              branch.name.isNotEmpty ? branch.name : branch.id,
                            ),
                          ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Branch is required';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() => _selectedBranchId = value ?? '');
                      },
                    ),
                  ),
                ),
                FormFieldCard(
                  label: 'Parent Agent',
                  description:
                      'Optional. The supervising agent in the hierarchy.',
                  child: TextFormField(
                    controller: _parentAgentIdController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. agent-xyz789',
                      prefixIcon: Icon(Icons.supervisor_account_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
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
                      'Optional geographic area identifier for this agent\'s territory.',
                  child: TextFormField(
                    controller: _geoIdController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. KE-NBI-EAST',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                FormFieldCard(
                  label: 'State',
                  description:
                      'The current operational status of this agent.',
                  isRequired: true,
                  child: DropdownButtonFormField<STATE>(
                    initialValue: _state,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.toggle_on_outlined),
                    ),
                    items: STATE.values
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(stateLabel(s)),
                          ),
                        )
                        .toList(),
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
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(_isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final agent = AgentObject(
      id: widget.agent?.id ?? '',
      name: _nameController.text.trim(),
      profileId: _profileIdController.text.trim(),
      branchId: _selectedBranchId,
      parentAgentId: _parentAgentIdController.text.trim(),
      agentType: _agentType,
      geoId: _geoIdController.text.trim(),
      state: _state,
    );

    // Preserve properties when editing.
    if (widget.agent != null && widget.agent!.hasProperties()) {
      agent.properties = widget.agent!.properties;
    }

    Navigator.of(context).pop(agent);
  }
}
