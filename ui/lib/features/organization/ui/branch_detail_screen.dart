import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/profile_badge.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../../sdk/src/field/v1/field.pb.dart';
import '../../field/data/agent_providers.dart';
import '../data/branch_providers.dart';
import 'organization_detail_screen.dart';

class BranchDetailScreen extends ConsumerWidget {
  const BranchDetailScreen({
    super.key,
    required this.branchId,
    required this.organizationId,
  });

  final String branchId;
  final String organizationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canManage = ref.watch(canManageOrganizationsProvider).value ?? false;

    return FutureBuilder<BranchObject>(
      future: _loadBranch(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final branch = snapshot.data;
        if (branch == null) {
          return const Center(child: Text('Branch not found'));
        }
        return _BranchDetailContent(
          branch: branch,
          organizationId: organizationId,
          canManage: canManage,
        );
      },
    );
  }

  Future<BranchObject> _loadBranch(WidgetRef ref) async {
    final client = ref.read(identityServiceClientProvider);
    final response = await client.branchGet(BranchGetRequest(id: branchId));
    return response.data;
  }
}

class _BranchDetailContent extends ConsumerStatefulWidget {
  const _BranchDetailContent({
    required this.branch,
    required this.organizationId,
    required this.canManage,
  });

  final BranchObject branch;
  final String organizationId;
  final bool canManage;

  @override
  ConsumerState<_BranchDetailContent> createState() =>
      _BranchDetailContentState();
}

class _BranchDetailContentState extends ConsumerState<_BranchDetailContent> {
  late BranchObject _branch;

  @override
  void initState() {
    super.initState();
    _branch = widget.branch;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final agentsAsync = ref.watch(
      agentListProvider(query: '', branchId: _branch.id),
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
                  onPressed: () => context.go(
                    '/organization/organizations/${widget.organizationId}',
                  ),
                  tooltip: 'Back to Organization',
                ),
                const SizedBox(width: 8),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withAlpha(80),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.store_outlined,
                    size: 24,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _branch.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Code: ${_branch.code}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(140),
                            ),
                          ),
                          if (_branch.geoId.isNotEmpty) ...[
                            const SizedBox(width: 12),
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: theme.colorScheme.onSurface.withAlpha(120),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _branch.geoId,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withAlpha(
                                  140,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                StateBadge(state: _branch.state),
                if (widget.canManage) ...[
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Edit Branch',
                    onPressed: () => _editBranch(context),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Agents section header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Row(
              children: [
                Icon(
                  Icons.person_pin_outlined,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Agents',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (widget.canManage)
                  FilledButton.icon(
                    onPressed: () => context.go('/field/agents/new'),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Register Agent'),
                  ),
              ],
            ),
          ),
        ),

        // Agents list
        agentsAsync.when(
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
                    Text('Failed to load agents: $error'),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      onPressed: () => ref.invalidate(
                        agentListProvider(query: '', branchId: _branch.id),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          data: (agents) {
            if (agents.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48),
                    child: Column(
                      children: [
                        Icon(
                          Icons.person_pin_outlined,
                          size: 48,
                          color: theme.colorScheme.onSurface.withAlpha(80),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No agents in this branch',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(140),
                          ),
                        ),
                        if (widget.canManage) ...[
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: () => context.go('/field/agents/new'),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Register Agent'),
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
                  final agent = agents[index];
                  return _AgentCard(agent: agent);
                }, childCount: agents.length),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _editBranch(BuildContext context) async {
    final result = await showDialog<BranchObject>(
      context: context,
      builder: (context) => BranchFormDialog(
        branch: _branch,
        organizationId: widget.organizationId,
      ),
    );
    if (result == null || !mounted) return;

    try {
      await ref.read(branchProvider.notifier).save(result);
      if (!mounted) return;
      setState(() {
        _branch = result;
      });
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Branch updated successfully')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save branch: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

class _AgentCard extends StatelessWidget {
  const _AgentCard({required this.agent});
  final AgentObject agent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = [
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
        trailing: StateBadge(state: agent.state),
      ),
    );
  }
}
