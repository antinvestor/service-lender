import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/profile_badge.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/field/v1/field.pb.dart';
import '../../auth/data/auth_repository.dart';
import '../data/agent_providers.dart';
import '../data/client_providers.dart';

class ClientsScreen extends ConsumerStatefulWidget {
  const ClientsScreen({super.key});

  @override
  ConsumerState<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends ConsumerState<ClientsScreen> {
  String _searchQuery = '';
  String _selectedAgentId = '';
  bool _isSyncing = false;
  bool _agentScopeInitialized = false;

  /// Auto-scope to current user's agent ID when user is an agent.
  void _initAgentScope(WidgetRef ref) {
    if (_agentScopeInitialized) return;
    _agentScopeInitialized = true;

    final roles = ref.read(currentUserRolesProvider).value ?? <LenderRole>{};
    final isAgentOnly =
        roles.contains(LenderRole.agent) &&
        !roles.any(
          (r) =>
              r == LenderRole.owner ||
              r == LenderRole.admin ||
              r == LenderRole.manager,
        );

    if (isAgentOnly) {
      final profileId = ref.read(currentProfileIdProvider).value;
      if (profileId != null && profileId.isNotEmpty) {
        _selectedAgentId = profileId;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _initAgentScope(ref);

    final clientsAsync = ref.watch(
      clientListProvider(query: _searchQuery, agentId: _selectedAgentId),
    );
    final canManage = ref.watch(canManageClientsProvider);
    final agentsAsync = ref.watch(agentListProvider(query: '', branchId: ''));
    final pendingCount = ref.watch(pendingSyncCountProvider).value ?? 0;

    return clientsAsync.when(
      loading: () => EntityListPage<ClientObject>(
        title: 'Clients',
        icon: Icons.people_outline,
        items: const [],
        isLoading: true,
        itemBuilder: (_, _) => const SizedBox.shrink(),
        searchHint: 'Search clients...',
        onSearchChanged: (q) => setState(() => _searchQuery = q),
        filterWidget: _buildFilters(agentsAsync, pendingCount),
      ),
      error: (error, _) => EntityListPage<ClientObject>(
        title: 'Clients',
        icon: Icons.people_outline,
        items: const [],
        error: error.toString(),
        onRetry: () => ref.invalidate(
          clientListProvider(query: _searchQuery, agentId: _selectedAgentId),
        ),
        itemBuilder: (_, _) => const SizedBox.shrink(),
        searchHint: 'Search clients...',
        onSearchChanged: (q) => setState(() => _searchQuery = q),
        filterWidget: _buildFilters(agentsAsync, pendingCount),
      ),
      data: (clients) => EntityListPage<ClientObject>(
        title: 'Clients',
        icon: Icons.people_outline,
        items: clients,
        hasMore: clients.length >= 500,
        itemBuilder: (context, client) =>
            _buildClientCard(context, client, agentsAsync.value ?? []),
        searchHint: 'Search clients...',
        onSearchChanged: (q) => setState(() => _searchQuery = q),
        actionLabel: 'Onboard Client',
        canAction: canManage.value ?? false,
        onAction: () => context.go('/field/clients/new'),
        filterWidget: _buildFilters(agentsAsync, pendingCount),
      ),
    );
  }

  Future<void> _syncPending() async {
    setState(() => _isSyncing = true);
    try {
      final count = await ref.read(clientProvider.notifier).syncPending();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Synced $count client(s) to server')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sync failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  Widget _buildFilters(
    AsyncValue<List<AgentObject>> agentsAsync,
    int pendingCount,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAgentFilter(agentsAsync),
        if (pendingCount > 0) ...[
          const SizedBox(width: 8),
          Badge(
            label: Text('$pendingCount'),
            child: IconButton(
              icon: _isSyncing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_upload_outlined),
              tooltip: '$pendingCount pending sync',
              onPressed: _isSyncing ? null : _syncPending,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAgentFilter(AsyncValue<List<AgentObject>> agentsAsync) {
    final agents = agentsAsync.value ?? [];
    return DropdownButton<String>(
      value: _selectedAgentId,
      hint: const Text('All Agents'),
      underline: const SizedBox.shrink(),
      borderRadius: BorderRadius.circular(10),
      items: [
        const DropdownMenuItem(value: '', child: Text('All Agents')),
        ...agents.map(
          (a) => DropdownMenuItem(
            value: a.id,
            child: Text(a.name.isNotEmpty ? a.name : a.id),
          ),
        ),
      ],
      onChanged: (value) => setState(() => _selectedAgentId = value ?? ''),
    );
  }

  Widget _buildClientCard(
    BuildContext context,
    ClientObject client,
    List<AgentObject> agents,
  ) {
    final theme = Theme.of(context);
    final agent = agents.where((a) => a.id == client.agentId).firstOrNull;
    final agentLabel = agent != null
        ? (agent.name.isNotEmpty ? agent.name : agent.id)
        : client.agentId;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: ProfileAvatar(
          profileId: client.profileId,
          name: client.name.isNotEmpty ? client.name : 'Unknown',
          size: 40,
        ),
        title: Text(
          client.name.isNotEmpty ? client.name : 'Unnamed Client',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            if (agent != null)
              Row(
                children: [
                  ProfileAvatar(
                    profileId: agent.profileId,
                    name: agent.name.isNotEmpty ? agent.name : 'Agent',
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Agent: $agentLabel',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(160),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            else if (agentLabel.isNotEmpty)
              Text(
                'Agent: $agentLabel',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(160),
                ),
              ),
          ],
        ),
        trailing: StateBadge(state: client.state),
        isThreeLine: true,
        onTap: () => context.go('/field/clients/${client.id}'),
      ),
    );
  }
}
