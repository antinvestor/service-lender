import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/lender/v1/field.pb.dart';
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
      filterWidget: SizedBox(
        width: 180,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Branch ID filter',
            prefixIcon: const Icon(Icons.filter_list, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            isDense: true,
          ),
          onChanged: (value) => setState(() => _branchFilter = value),
        ),
      ),
      itemBuilder: (context, agent) => _AgentCard(
        agent: agent,
        onEdit: (canManage.value ?? false)
            ? () => _showAgentDialog(context, agent: agent)
            : null,
      ),
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
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
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

class _AgentFormDialog extends StatefulWidget {
  const _AgentFormDialog({this.agent});

  final AgentObject? agent;

  @override
  State<_AgentFormDialog> createState() => _AgentFormDialogState();
}

class _AgentFormDialogState extends State<_AgentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _profileIdController;
  late final TextEditingController _branchIdController;
  late final TextEditingController _parentAgentIdController;
  late final TextEditingController _geoIdController;
  late AgentType _agentType;
  late STATE _state;

  bool get _isEditing => widget.agent != null;

  @override
  void initState() {
    super.initState();
    final a = widget.agent;
    _nameController = TextEditingController(text: a?.name ?? '');
    _profileIdController = TextEditingController(text: a?.profileId ?? '');
    _branchIdController = TextEditingController(text: a?.branchId ?? '');
    _parentAgentIdController =
        TextEditingController(text: a?.parentAgentId ?? '');
    _geoIdController = TextEditingController(text: a?.geoId ?? '');
    _agentType = a?.agentType ?? AgentType.AGENT_TYPE_INDIVIDUAL;
    _state = a?.state ?? STATE.CREATED;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _profileIdController.dispose();
    _branchIdController.dispose();
    _parentAgentIdController.dispose();
    _geoIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit Agent' : 'Add Agent'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _profileIdController,
                  decoration: const InputDecoration(labelText: 'Profile ID'),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Profile ID is required'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _branchIdController,
                  decoration: const InputDecoration(labelText: 'Branch ID'),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Branch ID is required'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _parentAgentIdController,
                  decoration: const InputDecoration(
                    labelText: 'Parent Agent ID (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<AgentType>(
                  initialValue: _agentType,
                  decoration: const InputDecoration(labelText: 'Agent Type'),
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
                const SizedBox(height: 12),
                TextFormField(
                  controller: _geoIdController,
                  decoration: const InputDecoration(labelText: 'Geo ID'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<STATE>(
                  initialValue: _state,
                  decoration: const InputDecoration(labelText: 'State'),
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
      branchId: _branchIdController.text.trim(),
      parentAgentId: _parentAgentIdController.text.trim(),
      agentType: _agentType,
      geoId: _geoIdController.text.trim(),
      state: _state,
    );
    Navigator.of(context).pop(agent);
  }
}
