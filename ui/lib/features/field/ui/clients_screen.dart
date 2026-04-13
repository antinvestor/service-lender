import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/profile_badge.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/field/v1/field.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../auth/data/auth_repository.dart';
import '../../workforce/data/workforce_member_providers.dart';
import '../data/client_providers.dart';

class ClientsScreen extends ConsumerStatefulWidget {
  const ClientsScreen({super.key});

  @override
  ConsumerState<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends ConsumerState<ClientsScreen> {
  String _searchQuery = '';
  String _selectedMemberId = '';
  bool _isSyncing = false;
  bool _memberScopeInitialized = false;

  /// Auto-scope to current user's workforce member ID when user is a field worker.
  void _initMemberScope(WidgetRef ref) {
    if (_memberScopeInitialized) return;
    _memberScopeInitialized = true;

    final roles = ref.read(currentUserRolesProvider).value ?? <LenderRole>{};
    final isFieldWorkerOnly =
        roles.contains(LenderRole.fieldWorker) &&
        !roles.any(
          (r) =>
              r == LenderRole.owner ||
              r == LenderRole.admin ||
              r == LenderRole.manager,
        );

    if (isFieldWorkerOnly) {
      final profileId = ref.read(currentProfileIdProvider).value;
      if (profileId != null && profileId.isNotEmpty) {
        _selectedMemberId = profileId;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _initMemberScope(ref);

    final clientsAsync = ref.watch(
      clientListProvider(query: _searchQuery, memberId: _selectedMemberId),
    );
    final canManage = ref.watch(canManageClientsProvider);
    final membersAsync = ref.watch(
      workforceMemberListProvider(query: ''),
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
        filterWidget: _buildFilters(membersAsync, pendingCount),
      ),
      error: (error, _) => EntityListPage<ClientObject>(
        title: 'Clients',
        icon: Icons.people_outline,
        items: const [],
        error: error.toString(),
        onRetry: () => ref.invalidate(
          clientListProvider(query: _searchQuery, memberId: _selectedMemberId),
        ),
        itemBuilder: (_, _) => const SizedBox.shrink(),
        searchHint: 'Search clients...',
        onSearchChanged: (q) => setState(() => _searchQuery = q),
        filterWidget: _buildFilters(membersAsync, pendingCount),
      ),
      data: (clients) => EntityListPage<ClientObject>(
        title: 'Clients',
        icon: Icons.people_outline,
        items: clients,
        hasMore: clients.length >= 500,
        itemBuilder: (context, client) =>
            _buildClientCard(context, client, membersAsync.value ?? []),
        searchHint: 'Search clients...',
        onSearchChanged: (q) => setState(() => _searchQuery = q),
        actionLabel: 'Onboard Client',
        canAction: canManage.value ?? false,
        onAction: () => context.go('/field/clients/new'),
        filterWidget: _buildFilters(membersAsync, pendingCount),
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
    AsyncValue<List<WorkforceMemberObject>> membersAsync,
    int pendingCount,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMemberFilter(membersAsync),
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

  Widget _buildMemberFilter(
    AsyncValue<List<WorkforceMemberObject>> membersAsync,
  ) {
    final members = membersAsync.value ?? [];
    return DropdownButton<String>(
      value: _selectedMemberId,
      hint: const Text('All Members'),
      underline: const SizedBox.shrink(),
      borderRadius: BorderRadius.circular(10),
      items: [
        const DropdownMenuItem(value: '', child: Text('All Members')),
        ...members.map(
          (m) {
            final name = m.hasProperties() &&
                    m.properties.fields.containsKey('name')
                ? m.properties.fields['name']!.stringValue
                : m.profileId;
            return DropdownMenuItem(
              value: m.id,
              child: Text(name),
            );
          },
        ),
      ],
      onChanged: (value) => setState(() => _selectedMemberId = value ?? ''),
    );
  }

  Widget _buildClientCard(
    BuildContext context,
    ClientObject client,
    List<WorkforceMemberObject> members,
  ) {
    final theme = Theme.of(context);
    final memberId = client.primaryRelationshipMemberId;
    final member = members.where((m) => m.id == memberId).firstOrNull;
    final memberLabel = member != null
        ? (member.hasProperties() &&
                member.properties.fields.containsKey('name')
            ? member.properties.fields['name']!.stringValue
            : member.profileId)
        : memberId;
    final caseStatus = client.hasProperties()
        ? _fieldString(client.properties.fields, 'approval_case_status')
        : '';

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
            if (member != null)
              Row(
                children: [
                  ProfileAvatar(
                    profileId: member.profileId,
                    name: memberLabel,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Member: $memberLabel',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(160),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            else if (memberLabel.isNotEmpty)
              Text(
                'Member: $memberLabel',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(160),
                ),
              ),
            if (caseStatus.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withAlpha(90),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Case: ${caseStatus.replaceAll('_', ' ')}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: StateBadge(state: client.state),
        isThreeLine: true,
        onTap: () => context.go('/field/clients/${client.id}'),
      ),
    );
  }

  String _fieldString(Map<String, dynamic> properties, String key) {
    final value = properties[key];
    if (value == null) return '';
    if (value.hasStringValue()) return value.stringValue;
    if (value.hasNumberValue()) return value.numberValue.toString();
    if (value.hasBoolValue()) return value.boolValue.toString();
    return '';
  }
}
