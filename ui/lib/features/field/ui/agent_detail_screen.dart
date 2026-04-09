import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/profile_badge.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/field/v1/field.pb.dart';
import '../data/agent_providers.dart';
import '../data/client_providers.dart';

class AgentDetailScreen extends ConsumerWidget {
  const AgentDetailScreen({super.key, required this.agentId});

  final String agentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canManage = ref.watch(canManageAgentsProvider).value ?? false;

    return FutureBuilder<AgentObject>(
      future: _loadAgent(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final agent = snapshot.data;
        if (agent == null) {
          return const Center(child: Text('Agent not found'));
        }
        return _AgentDetailContent(agent: agent, canManage: canManage);
      },
    );
  }

  Future<AgentObject> _loadAgent(WidgetRef ref) async {
    final client = ref.read(fieldServiceClientProvider);
    final response = await client.agentGet(AgentGetRequest(id: agentId));
    return response.data;
  }
}

class _AgentDetailContent extends ConsumerStatefulWidget {
  const _AgentDetailContent({required this.agent, required this.canManage});

  final AgentObject agent;
  final bool canManage;

  @override
  ConsumerState<_AgentDetailContent> createState() =>
      _AgentDetailContentState();
}

class _AgentDetailContentState extends ConsumerState<_AgentDetailContent> {
  late AgentObject _agent;

  @override
  void initState() {
    super.initState();
    _agent = widget.agent;
  }

  String _agentTypeLabel(AgentType type) {
    return switch (type) {
      AgentType.AGENT_TYPE_INDIVIDUAL => 'Individual',
      AgentType.AGENT_TYPE_ORGANIZATION => 'Organization',
      _ => 'Unknown',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clientsAsync = ref.watch(
      clientListProvider(query: '', agentId: _agent.id),
    );
    final subAgentsAsync = ref.watch(
      agentListProvider(query: '', branchId: ''),
    );

    return CustomScrollView(
      slivers: [
        // Back + title
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/organization/agents'),
                  tooltip: 'Back to Agents',
                ),
                const SizedBox(width: 8),
                ProfileBadge(
                  profileId: _agent.profileId,
                  name: _agent.name,
                  description: _agentTypeLabel(_agent.agentType),
                  avatarSize: 48,
                  trailing: const SizedBox.shrink(),
                ),
                const Spacer(),
                StateBadge(state: _agent.state),
                if (widget.canManage) ...[
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Edit Agent',
                    onPressed: () => _editAgent(context),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Agent info card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Agent Details',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(label: 'Agent ID', value: _agent.id),
                    _InfoRow(label: 'Profile ID', value: _agent.profileId),
                    _InfoRow(label: 'Organization ID', value: _agent.organizationId),
                    _InfoRow(
                      label: 'Agent Type',
                      value: _agentTypeLabel(_agent.agentType),
                    ),
                    _InfoRow(label: 'Depth', value: _agent.depth.toString()),
                    if (_agent.geoId.isNotEmpty)
                      _InfoRow(label: 'Geo ID', value: _agent.geoId),
                    if (_agent.parentAgentId.isNotEmpty)
                      _InfoRow(
                        label: 'Parent Agent',
                        value: _agent.parentAgentId,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Sub-agents section (filter agents in same branch that have this agent as parent)
        subAgentsAsync.when(
          loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
          error: (_, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          data: (allAgents) {
            final subAgents = allAgents
                .where((a) => a.parentAgentId == _agent.id)
                .toList();
            if (subAgents.isEmpty) {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }
            return SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.supervisor_account_outlined,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Sub-Agents',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 4,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final sub = subAgents[index];
                      return _SubAgentCard(agent: sub);
                    }, childCount: subAgents.length),
                  ),
                ),
              ],
            );
          },
        ),

        // Clients section header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Row(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Clients',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (widget.canManage)
                  FilledButton.icon(
                    onPressed: () => context.go('/field/clients/new'),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Onboard Client'),
                  ),
              ],
            ),
          ),
        ),

        // Clients list
        clientsAsync.when(
          loading: () => const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          error: (error, _) => SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Text('Failed to load clients: $error'),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      onPressed: () => ref.invalidate(
                        clientListProvider(query: '', agentId: _agent.id),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          data: (clients) {
            if (clients.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48),
                    child: Column(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 48,
                          color: theme.colorScheme.onSurface.withAlpha(80),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No clients for this agent',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(140),
                          ),
                        ),
                        if (widget.canManage) ...[
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: () => context.go('/field/clients/new'),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Onboard Client'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final client = clients[index];
                  return _ClientCard(client: client);
                }, childCount: clients.length),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _editAgent(BuildContext context) async {
    // Simple edit dialog for agent details
    final result = await showDialog<AgentObject>(
      context: context,
      builder: (context) => _AgentEditDialog(agent: _agent),
    );
    if (result == null || !mounted) return;

    try {
      await ref.read(agentProvider.notifier).save(result);
      if (!mounted) return;
      setState(() => _agent = result);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agent updated successfully')),
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

// ---------------------------------------------------------------------------
// Info row
// ---------------------------------------------------------------------------

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '\u2014',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-agent card
// ---------------------------------------------------------------------------

class _SubAgentCard extends StatelessWidget {
  const _SubAgentCard({required this.agent});
  final AgentObject agent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: () => context.go('/organization/agents/${agent.id}'),
        leading: ProfileAvatar(
          profileId: agent.profileId,
          name: agent.name,
          size: 36,
        ),
        title: Text(
          agent.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Depth: ${agent.depth}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: StateBadge(state: agent.state),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Client card
// ---------------------------------------------------------------------------

class _ClientCard extends StatelessWidget {
  const _ClientCard({required this.client});
  final ClientObject client;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: () => context.go('/field/clients/${client.id}'),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            client.name.isNotEmpty ? client.name[0].toUpperCase() : '?',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text(
          client.name.isNotEmpty ? client.name : 'Unnamed',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'ID: ${client.id}',
          style: theme.textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: StateBadge(state: client.state),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Agent edit dialog (simplified)
// ---------------------------------------------------------------------------

class _AgentEditDialog extends StatefulWidget {
  const _AgentEditDialog({required this.agent});
  final AgentObject agent;

  @override
  State<_AgentEditDialog> createState() => _AgentEditDialogState();
}

class _AgentEditDialogState extends State<_AgentEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _geoIdController;
  late STATE _selectedState;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.agent.name);
    _geoIdController = TextEditingController(text: widget.agent.geoId);
    _selectedState = widget.agent.state;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _geoIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  'Edit Agent',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Update the agent details below.',
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
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person_outlined),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _geoIdController,
                decoration: const InputDecoration(
                  labelText: 'Geographic ID',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<STATE>(
                initialValue: _selectedState,
                decoration: const InputDecoration(
                  labelText: 'State',
                  prefixIcon: Icon(Icons.toggle_on_outlined),
                ),
                items: const [
                  DropdownMenuItem(
                    value: STATE.CREATED,
                    child: Text('Created'),
                  ),
                  DropdownMenuItem(value: STATE.ACTIVE, child: Text('Active')),
                  DropdownMenuItem(
                    value: STATE.INACTIVE,
                    child: Text('Inactive'),
                  ),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _selectedState = v);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _onSave, child: const Text('Update')),
      ],
    );
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final updated = AgentObject(
      id: widget.agent.id,
      organizationId: widget.agent.organizationId,
      parentAgentId: widget.agent.parentAgentId,
      profileId: widget.agent.profileId,
      agentType: widget.agent.agentType,
      name: _nameController.text.trim(),
      geoId: _geoIdController.text.trim(),
      depth: widget.agent.depth,
      state: _selectedState,
    );

    Navigator.pop(context, updated);
  }
}
