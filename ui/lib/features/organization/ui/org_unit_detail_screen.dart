import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/approval_case_panel.dart';
import '../../../core/widgets/dynamic_form.dart' show mapToStruct, structToMap;
import '../../../core/widgets/profile_badge.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../auth/data/auth_repository.dart';
import '../../field/data/agent_providers.dart';
import '../../geography/ui/coverage_area_field.dart';
import '../data/org_unit_providers.dart';
import '../data/organization_providers.dart';
import 'org_unit_form_dialog.dart';

class OrgUnitDetailScreen extends ConsumerWidget {
  const OrgUnitDetailScreen({
    super.key,
    required this.orgUnitId,
    this.organizationId = '',
  });

  final String orgUnitId;
  final String organizationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canManage = ref.watch(canManageOrganizationsProvider).value ?? false;

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
    final response = await client.orgUnitGet(OrgUnitGetRequest(id: orgUnitId));
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

class _OrgUnitDetailContentState extends ConsumerState<_OrgUnitDetailContent> {
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
      orgUnitListProvider(
        parentId: _orgUnit.id,
        organizationId: _orgUnit.organizationId,
      ),
    );
    final organizationsAsync = ref.watch(organizationListProvider(''));
    final canVerify = ref.watch(canManageVerificationProvider).value ?? false;
    final canApprove = ref.watch(canManageUnderwritingProvider).value ?? false;
    final props = _orgUnit.hasProperties() ? _orgUnit.properties.fields : null;
    final agentsAsync = _orgUnit.type == OrgUnitType.ORG_UNIT_TYPE_BRANCH
        ? ref.watch(agentListProvider(query: '', branchId: _orgUnit.id))
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
                    color: theme.colorScheme.primaryContainer.withAlpha(80),
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
                        '${orgUnitTypeLabel(_orgUnit.type)}${_orgUnit.code.isNotEmpty ? ' • ${_orgUnit.code}' : ''}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(140),
                        ),
                      ),
                    ],
                  ),
                ),
                StateBadge(state: _orgUnit.state),
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
        if (_orgUnit.clientId.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Card(
                color: theme.colorScheme.primaryContainer.withAlpha(40),
                child: ListTile(
                  leading: Icon(Icons.link, color: theme.colorScheme.primary),
                  title: const Text('Login URL'),
                  subtitle: SelectableText(
                    '${Uri.base.origin}/login/${_orgUnit.clientId}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (_orgUnit.geoId.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: CoverageAreaSummary(areaId: _orgUnit.geoId),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: ApprovalCasePanel(
              properties: props,
              title: 'Org unit approval',
              onVerify: canVerify ? () => _performCaseAction('verify') : null,
              onApprove: canApprove
                  ? () => _performCaseAction('approve')
                  : null,
              onReject: (canVerify || canApprove)
                  ? () => _performCaseAction('reject')
                  : null,
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
        if (agentsAsync != null) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Text(
                'Agents',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          agentsAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (error, _) => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Failed to load agents: $error'),
              ),
            ),
            data: (agents) => SliverList.builder(
              itemCount: agents.length,
              itemBuilder: (context, index) {
                final agent = agents[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.person_pin_outlined),
                      title: Text(agent.name),
                      subtitle: ProfileBadge(
                        profileId: agent.profileId,
                        name: agent.name,
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
      builder: (context) =>
          OrgUnitFormDialog(orgUnit: _orgUnit, organizations: organizations),
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

  Future<void> _performCaseAction(String action) async {
    final profileId = await ref.read(currentProfileIdProvider.future) ?? '';
    if (!mounted) return;
    final updated = OrgUnitObject()..mergeFromMessage(_orgUnit);
    final props = updated.hasProperties()
        ? structToMap(updated.properties)
        : <String, dynamic>{};
    props['case_action'] = action;
    props['case_actor_id'] = profileId;
    updated.properties = mapToStruct(props);
    await _saveOrgUnit(
      context,
      updated,
      successMessage: 'Org unit case ${action}d successfully',
    );
  }

  Future<void> _saveOrgUnit(
    BuildContext context,
    OrgUnitObject orgUnit, {
    required String successMessage,
  }) async {
    try {
      final profileId = await ref.read(currentProfileIdProvider.future) ?? '';
      final props = orgUnit.hasProperties()
          ? structToMap(orgUnit.properties)
          : <String, dynamic>{};
      props['case_actor_id'] = profileId;
      orgUnit.properties = mapToStruct(props);
      await ref.read(orgUnitProvider.notifier).save(orgUnit);
      ref.invalidate(
        orgUnitListProvider(
          parentId: _orgUnit.id,
          organizationId: _orgUnit.organizationId,
        ),
      );
      final client = ref.read(identityServiceClientProvider);
      final response = await client.orgUnitGet(
        OrgUnitGetRequest(id: _orgUnit.id),
      );
      if (mounted) {
        setState(() => _orgUnit = response.data);
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(successMessage)));
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
