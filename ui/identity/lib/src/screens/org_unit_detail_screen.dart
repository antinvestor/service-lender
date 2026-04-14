import 'package:antinvestor_api_identity/antinvestor_api_identity.dart';
import 'package:antinvestor_ui_core/widgets/profile_badge.dart';
import 'package:antinvestor_ui_core/widgets/state_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/identity_transport_provider.dart';
import '../providers/org_unit_providers.dart';
import '../providers/organization_providers.dart';
import '../providers/workforce_member_providers.dart';
import '../widgets/org_unit_helpers.dart';
import '../widgets/state_helpers.dart';
import 'org_unit_form_dialog.dart';

class OrgUnitDetailScreen extends ConsumerWidget {
  const OrgUnitDetailScreen({
    super.key,
    required this.orgUnitId,
    this.organizationId = '',
    this.canManage = true,
  });

  final String orgUnitId;
  final String organizationId;
  final bool canManage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<OrgUnitObject>(
      future: _loadOrgUnit(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final orgUnit = snapshot.data;
        if (orgUnit == null) {
          return const Center(child: Text('Org unit not found'));
        }
        return _OrgUnitDetailContent(
          orgUnit: orgUnit,
          organizationId: organizationId,
          canManage: canManage,
        );
      },
    );
  }

  Future<OrgUnitObject> _loadOrgUnit(WidgetRef ref) async {
    final client = ref.read(identityServiceClientProvider);
    final response =
        await client.orgUnitGet(OrgUnitGetRequest(id: orgUnitId));
    return response.data;
  }
}

class _OrgUnitDetailContent extends ConsumerStatefulWidget {
  const _OrgUnitDetailContent({
    required this.orgUnit,
    required this.organizationId,
    required this.canManage,
  });

  final OrgUnitObject orgUnit;
  final String organizationId;
  final bool canManage;

  @override
  ConsumerState<_OrgUnitDetailContent> createState() =>
      _OrgUnitDetailContentState();
}

class _OrgUnitDetailContentState
    extends ConsumerState<_OrgUnitDetailContent> {
  late OrgUnitObject _orgUnit;

  @override
  void initState() {
    super.initState();
    _orgUnit = widget.orgUnit;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final childrenAsync = ref.watch(
      orgUnitListProvider((
        parentId: _orgUnit.id,
        organizationId: _orgUnit.organizationId,
        query: '',
        rootOnly: false,
        type: OrgUnitType.ORG_UNIT_TYPE_UNSPECIFIED,
      )),
    );
    final organizationsAsync = ref.watch(organizationListProvider(''));
    final membersAsync =
        _orgUnit.type == OrgUnitType.ORG_UNIT_TYPE_BRANCH
            ? ref.watch(workforceMemberListProvider((
                query: '',
                homeOrgUnitId: _orgUnit.id,
                organizationId: '',
              )))
            : null;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go(
                    widget.organizationId.isNotEmpty
                        ? '/organization/organizations/${widget.organizationId}'
                        : '/organization/org-units',
                  ),
                  tooltip: 'Back',
                ),
                const SizedBox(width: 8),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color:
                        theme.colorScheme.primaryContainer.withAlpha(80),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _orgUnit.type == OrgUnitType.ORG_UNIT_TYPE_BRANCH
                        ? Icons.store_outlined
                        : Icons.account_tree_outlined,
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
                        _orgUnit.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        '${orgUnitTypeLabel(_orgUnit.type)}${_orgUnit.code.isNotEmpty ? ' \u2022 ${_orgUnit.code}' : ''}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color:
                              theme.colorScheme.onSurface.withAlpha(140),
                        ),
                      ),
                    ],
                  ),
                ),
                StateBadge(state: toCommonState(_orgUnit.state)),
                if (widget.canManage) ...[
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Edit Org Unit',
                    onPressed: () => _editOrgUnit(context),
                  ),
                ],
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Row(
              children: [
                Icon(
                  Icons.account_tree_outlined,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Child Org Units',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (widget.canManage)
                  FilledButton.icon(
                    onPressed: () => _showChildDialog(
                      context,
                      organizationsAsync.value ?? const [],
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Child'),
                  ),
              ],
            ),
          ),
        ),
        childrenAsync.when(
          loading: () => const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (error, _) => SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Failed to load child org units: $error'),
            ),
          ),
          data: (children) {
            if (children.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Text('No child org units yet'),
                ),
              );
            }
            return SliverList.builder(
              itemCount: children.length,
              itemBuilder: (context, index) {
                final child = children[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        child.type == OrgUnitType.ORG_UNIT_TYPE_BRANCH
                            ? Icons.store_outlined
                            : Icons.account_tree_outlined,
                      ),
                      title: Text(child.name),
                      subtitle: Text(orgUnitTypeLabel(child.type)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go(
                        '/organization/organizations/${_orgUnit.organizationId}/org-units/${child.id}',
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        if (membersAsync != null) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Text(
                'Workforce Members',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          membersAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (error, _) => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Failed to load members: $error'),
              ),
            ),
            data: (members) => SliverList.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                final name = member.hasProperties() &&
                        member.properties.fields.containsKey('name')
                    ? member.properties.fields['name']!.stringValue
                    : member.profileId;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.badge_outlined),
                      title: Text(name),
                      subtitle: ProfileBadge(
                        profileId: member.profileId,
                        name: name,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _editOrgUnit(BuildContext context) async {
    final organizations =
        ref.read(organizationListProvider('')).value ??
            const <OrganizationObject>[];
    final result = await showDialog<OrgUnitObject>(
      context: context,
      builder: (context) => OrgUnitFormDialog(
          orgUnit: _orgUnit, organizations: organizations),
    );
    if (result == null || !context.mounted) return;
    await _saveOrgUnit(
      context,
      result,
      successMessage: 'Org unit updated successfully',
    );
  }

  Future<void> _showChildDialog(
    BuildContext context,
    List<OrganizationObject> organizations,
  ) async {
    final result = await showDialog<OrgUnitObject>(
      context: context,
      builder: (context) => OrgUnitFormDialog(
        organizations: organizations,
        fixedOrganizationId: _orgUnit.organizationId,
        fixedParentId: _orgUnit.id,
      ),
    );
    if (result == null || !context.mounted) return;
    await _saveOrgUnit(
      context,
      result,
      successMessage: 'Child org unit created successfully',
    );
  }

  Future<void> _saveOrgUnit(
    BuildContext context,
    OrgUnitObject orgUnit, {
    required String successMessage,
  }) async {
    try {
      await ref.read(orgUnitNotifierProvider.notifier).save(orgUnit);
      ref.invalidate(
        orgUnitListProvider((
          parentId: _orgUnit.id,
          organizationId: _orgUnit.organizationId,
          query: '',
          rootOnly: false,
          type: OrgUnitType.ORG_UNIT_TYPE_UNSPECIFIED,
        )),
      );
      final client = ref.read(identityServiceClientProvider);
      final response = await client.orgUnitGet(
        OrgUnitGetRequest(id: _orgUnit.id),
      );
      if (mounted) {
        setState(() => _orgUnit = response.data);
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save org unit: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
