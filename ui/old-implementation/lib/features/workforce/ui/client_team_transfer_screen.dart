import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/profile_badge.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/field/v1/field.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../field/data/client_providers.dart';
import '../data/team_providers.dart';

/// Screen for transferring clients between internal teams.
///
/// Clients are now owned by teams (`owningTeamId`), not by individual agents.
/// This screen allows managers to select a source team, pick clients, and
/// reassign them to a target team.
class ClientTeamTransferScreen extends ConsumerStatefulWidget {
  const ClientTeamTransferScreen({super.key});

  @override
  ConsumerState<ClientTeamTransferScreen> createState() =>
      _ClientTeamTransferScreenState();
}

class _ClientTeamTransferScreenState
    extends ConsumerState<ClientTeamTransferScreen> {
  String _sourceTeamId = '';
  String _targetTeamId = '';
  final Set<String> _selectedClientIds = {};
  bool _isTransferring = false;
  String _reason = ''; // Stored for future audit trail use

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final teamsAsync = ref.watch(internalTeamListProvider(query: ''));
    final canManage = ref.watch(canManageClientsProvider).value ?? false;

    // Load clients for the selected source team
    final clientsAsync = _sourceTeamId.isNotEmpty
        ? ref.watch(clientListProvider(query: '', memberId: ''))
        : const AsyncValue<List<ClientObject>>.data([]);

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
                  Text(
                    'Transfer Clients Between Teams',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select a source team, pick clients, and assign them to a new team.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Divider(height: 32),
                ],
              ),
            ),
          ),

          // Team selectors
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: teamsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Failed to load teams: $e'),
                data: (teams) => _buildTeamSelectors(theme, teams),
              ),
            ),
          ),

          // Client list from source team
          if (_sourceTeamId.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Clients in Source Team',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    if (_selectedClientIds.isNotEmpty)
                      Chip(
                        label: Text('${_selectedClientIds.length} selected'),
                        avatar: const Icon(Icons.check_circle, size: 18),
                      ),
                  ],
                ),
              ),
            ),

          if (_sourceTeamId.isNotEmpty)
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
                child: Center(child: Text('Failed to load clients: $error')),
              ),
              data: (clients) {
                // Filter to clients in the source team
                final teamClients = clients
                    .where((c) => c.owningTeamId == _sourceTeamId)
                    .toList();

                if (teamClients.isEmpty) {
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
                              'No clients in this team',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withAlpha(140),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final client = teamClients[index];
                      final isSelected =
                          _selectedClientIds.contains(client.id);
                      return Card(
                        elevation: 0,
                        color: isSelected
                            ? theme.colorScheme.primaryContainer.withAlpha(60)
                            : null,
                        child: CheckboxListTile(
                          value: isSelected,
                          onChanged: canManage
                              ? (v) {
                                  setState(() {
                                    if (v == true) {
                                      _selectedClientIds.add(client.id);
                                    } else {
                                      _selectedClientIds.remove(client.id);
                                    }
                                  });
                                }
                              : null,
                          secondary: ProfileAvatar(
                            profileId: client.profileId,
                            name: client.name,
                            size: 36,
                          ),
                          title: Text(
                            client.name.isNotEmpty
                                ? client.name
                                : 'Unnamed Client',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Row(
                            children: [
                              Text('ID: ${client.id}'),
                              const SizedBox(width: 8),
                              StateBadge(state: client.state),
                            ],
                          ),
                        ),
                      );
                    }, childCount: teamClients.length),
                  ),
                );
              },
            ),

          // Reason + Transfer button
          if (_selectedClientIds.isNotEmpty && _targetTeamId.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Transfer Reason',
                        hintText: 'e.g. Team restructuring',
                        prefixIcon: Icon(Icons.notes_outlined),
                      ),
                      onChanged: (v) => _reason = v,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _isTransferring ? null : _executeTransfer,
                      icon: _isTransferring
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.swap_horiz),
                      label: Text(
                        'Transfer ${_selectedClientIds.length} Client(s)',
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTeamSelectors(ThemeData theme, List<InternalTeamObject> teams) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: _sourceTeamId.isNotEmpty ? _sourceTeamId : null,
            decoration: const InputDecoration(
              labelText: 'Source Team',
              prefixIcon: Icon(Icons.group_outlined),
            ),
            items: teams
                .map(
                  (t) => DropdownMenuItem(
                    value: t.id,
                    child: Text(t.name.isNotEmpty ? t.name : t.id),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() {
              _sourceTeamId = v ?? '';
              _selectedClientIds.clear();
              // Don't allow same source and target
              if (_targetTeamId == _sourceTeamId) _targetTeamId = '';
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Icon(
            Icons.arrow_forward,
            color: theme.colorScheme.primary,
          ),
        ),
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: _targetTeamId.isNotEmpty ? _targetTeamId : null,
            decoration: const InputDecoration(
              labelText: 'Target Team',
              prefixIcon: Icon(Icons.group_outlined),
            ),
            items: teams
                .where((t) => t.id != _sourceTeamId)
                .map(
                  (t) => DropdownMenuItem(
                    value: t.id,
                    child: Text(t.name.isNotEmpty ? t.name : t.id),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => _targetTeamId = v ?? ''),
          ),
        ),
      ],
    );
  }

  Future<void> _executeTransfer() async {
    if (_selectedClientIds.isEmpty || _targetTeamId.isEmpty) return;

    setState(() => _isTransferring = true);

    try {
      final fieldClient = ref.read(fieldServiceClientProvider);
      var successCount = 0;

      for (final clientId in _selectedClientIds) {
        try {
          // Fetch the client, update its owningTeamId, save it.
          final getResponse = await fieldClient.clientGet(
            ClientGetRequest(id: clientId),
          );
          final client = getResponse.data;
          client.owningTeamId = _targetTeamId;
          await fieldClient.clientSave(ClientSaveRequest(data: client));
          successCount++;
        } catch (_) {
          // Continue with remaining clients on individual failure.
        }
      }

      ref.invalidate(clientListProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Transferred $successCount of ${_selectedClientIds.length} client(s) to target team.',
            ),
          ),
        );
        setState(() {
          _selectedClientIds.clear();
          _isTransferring = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transfer failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        setState(() => _isTransferring = false);
      }
    }
  }
}
