import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/field/v1/field.pb.dart';
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

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(
      clientListProvider(query: _searchQuery, agentId: _selectedAgentId),
    );
    final canManage = ref.watch(canManageClientsProvider);
    final agentsAsync = ref.watch(
      agentListProvider(query: '', branchId: ''),
    );
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
          clientListProvider(
            query: _searchQuery,
            agentId: _selectedAgentId,
          ),
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
        itemBuilder: (context, client) => _buildClientCard(
          context,
          client,
          agentsAsync.value ?? [],
        ),
        searchHint: 'Search clients...',
        onSearchChanged: (q) => setState(() => _searchQuery = q),
        actionLabel: 'Onboard Client',
        canAction: canManage.value ?? false,
        onAction: () => _showClientDialog(
          context,
          agentsAsync.value ?? [],
        ),
        filterWidget: _buildFilters(agentsAsync, pendingCount),
      ),
    );
  }

  Future<void> _syncPending() async {
    setState(() => _isSyncing = true);
    try {
      final count =
          await ref.read(clientProvider.notifier).syncPending();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Synced $count client(s) to server')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sync failed: $e')),
        );
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
        const DropdownMenuItem(
          value: '',
          child: Text('All Agents'),
        ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            client.name.isNotEmpty ? client.name[0].toUpperCase() : '?',
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text(
          client.name.isNotEmpty ? client.name : 'Unnamed Client',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              'Profile: ${client.profileId}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(160),
              ),
            ),
            if (agentLabel.isNotEmpty)
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

  void _showClientDialog(
    BuildContext context,
    List<AgentObject> agents, {
    ClientObject? existing,
  }) {
    final isEdit = existing != null;
    final nameController = TextEditingController(text: existing?.name ?? '');
    final profileIdController =
        TextEditingController(text: existing?.profileId ?? '');
    var selectedAgentId = existing?.agentId ?? '';
    var selectedState = existing?.state ?? STATE.CREATED;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              title: Text(isEdit ? 'Edit Client' : 'Onboard Client'),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: profileIdController,
                      decoration: const InputDecoration(
                        labelText: 'Profile ID',
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: selectedAgentId.isNotEmpty
                          ? selectedAgentId
                          : null,
                      decoration: const InputDecoration(
                        labelText: 'Agent',
                      ),
                      items: agents.map((a) {
                        return DropdownMenuItem(
                          value: a.id,
                          child:
                              Text(a.name.isNotEmpty ? a.name : a.id),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(
                          () => selectedAgentId = value ?? '',
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<STATE>(
                      initialValue: selectedState,
                      decoration: const InputDecoration(
                        labelText: 'State',
                      ),
                      items: STATE.values.map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Text(stateLabel(s)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(
                          () => selectedState = value ?? STATE.CREATED,
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => _saveClient(
                    dialogContext,
                    existing: existing,
                    name: nameController.text.trim(),
                    profileId: profileIdController.text.trim(),
                    agentId: selectedAgentId,
                    state: selectedState,
                  ),
                  child: Text(isEdit ? 'Save' : 'Onboard'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      nameController.dispose();
      profileIdController.dispose();
    });
  }

  Future<void> _saveClient(
    BuildContext dialogContext, {
    ClientObject? existing,
    required String name,
    required String profileId,
    required String agentId,
    required STATE state,
  }) async {
    if (name.isEmpty || agentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and Agent are required')),
      );
      return;
    }

    final clientObj = ClientObject(
      id: existing?.id ?? '',
      name: name,
      profileId: profileId,
      agentId: agentId,
      state: state,
    );

    // Preserve properties when editing.
    if (existing != null && existing.hasProperties()) {
      clientObj.properties = existing.properties;
    }

    Navigator.of(dialogContext).pop();

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(clientProvider.notifier).save(clientObj);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            existing != null
                ? 'Client updated successfully'
                : 'Client onboarded successfully',
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
