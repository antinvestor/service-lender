import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/lender/v1/field.pb.dart';
import '../data/agent_providers.dart';
import '../data/borrower_providers.dart';

class BorrowersScreen extends ConsumerStatefulWidget {
  const BorrowersScreen({super.key});

  @override
  ConsumerState<BorrowersScreen> createState() => _BorrowersScreenState();
}

class _BorrowersScreenState extends ConsumerState<BorrowersScreen> {
  String _searchQuery = '';
  String _selectedAgentId = '';

  @override
  Widget build(BuildContext context) {
    final borrowersAsync = ref.watch(
      borrowerListProvider(query: _searchQuery, agentId: _selectedAgentId),
    );
    final canManage = ref.watch(canManageBorrowersProvider);
    final agentsAsync = ref.watch(
      agentListProvider(query: '', branchId: ''),
    );

    return borrowersAsync.when(
      loading: () => EntityListPage<BorrowerObject>(
        title: 'Borrowers',
        icon: Icons.people_outline,
        items: const [],
        isLoading: true,
        itemBuilder: (_, _) => const SizedBox.shrink(),
        searchHint: 'Search borrowers...',
        onSearchChanged: (q) => setState(() => _searchQuery = q),
        filterWidget: _buildAgentFilter(agentsAsync),
      ),
      error: (error, _) => EntityListPage<BorrowerObject>(
        title: 'Borrowers',
        icon: Icons.people_outline,
        items: const [],
        error: error.toString(),
        onRetry: () => ref.invalidate(
          borrowerListProvider(
            query: _searchQuery,
            agentId: _selectedAgentId,
          ),
        ),
        itemBuilder: (_, _) => const SizedBox.shrink(),
        searchHint: 'Search borrowers...',
        onSearchChanged: (q) => setState(() => _searchQuery = q),
        filterWidget: _buildAgentFilter(agentsAsync),
      ),
      data: (borrowers) => EntityListPage<BorrowerObject>(
        title: 'Borrowers',
        icon: Icons.people_outline,
        items: borrowers,
        itemBuilder: (context, borrower) => _buildBorrowerCard(
          context,
          borrower,
          agentsAsync.value ?? [],
        ),
        searchHint: 'Search borrowers...',
        onSearchChanged: (q) => setState(() => _searchQuery = q),
        actionLabel: 'Onboard Borrower',
        canAction: canManage.value ?? false,
        onAction: () => _showBorrowerDialog(
          context,
          agentsAsync.value ?? [],
        ),
        filterWidget: _buildAgentFilter(agentsAsync),
      ),
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

  Widget _buildBorrowerCard(
    BuildContext context,
    BorrowerObject borrower,
    List<AgentObject> agents,
  ) {
    final theme = Theme.of(context);
    final agent = agents.where((a) => a.id == borrower.agentId).firstOrNull;
    final agentLabel = agent != null
        ? (agent.name.isNotEmpty ? agent.name : agent.id)
        : borrower.agentId;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            borrower.name.isNotEmpty ? borrower.name[0].toUpperCase() : '?',
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text(
          borrower.name.isNotEmpty ? borrower.name : 'Unnamed Borrower',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              'Profile: ${borrower.profileId}',
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
        trailing: StateBadge(state: borrower.state),
        isThreeLine: true,
        onTap: () => _showBorrowerDialog(
          context,
          ref.read(agentListProvider(query: '', branchId: '')).value ?? [],
          existing: borrower,
        ),
      ),
    );
  }

  void _showBorrowerDialog(
    BuildContext context,
    List<AgentObject> agents, {
    BorrowerObject? existing,
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
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEdit ? 'Edit Borrower' : 'Onboard Borrower'),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: profileIdController,
                      decoration: const InputDecoration(
                        labelText: 'Profile ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: selectedAgentId.isNotEmpty
                          ? selectedAgentId
                          : null,
                      decoration: const InputDecoration(
                        labelText: 'Agent',
                        border: OutlineInputBorder(),
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
                        border: OutlineInputBorder(),
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
                  onPressed: () => _saveBorrower(
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
    );
  }

  Future<void> _saveBorrower(
    BuildContext dialogContext, {
    BorrowerObject? existing,
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

    final borrower = BorrowerObject(
      id: existing?.id ?? '',
      name: name,
      profileId: profileId,
      agentId: agentId,
      state: state,
    );

    // Preserve properties when editing.
    if (existing != null && existing.hasProperties()) {
      borrower.properties = existing.properties;
    }

    Navigator.of(dialogContext).pop();

    try {
      await ref.read(borrowerProvider.notifier).save(borrower);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              existing != null
                  ? 'Borrower updated successfully'
                  : 'Borrower onboarded successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
