import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/auth/role_provider.dart';
import '../../../core/auth/tenancy_context.dart';
import '../../../core/widgets/approval_case_panel.dart';
import '../../../core/widgets/audit_trail_widget.dart';
import '../../../core/widgets/dynamic_form.dart' show mapToStruct, structToMap;
import '../../../core/widgets/profile_badge.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../auth/data/auth_repository.dart';
import '../../geography/ui/coverage_area_field.dart';
import '../../workforce/data/workforce_member_providers.dart';
import '../data/org_unit_providers.dart';
import '../data/organization_providers.dart';
import 'org_unit_form_dialog.dart';
import 'organizations_screen.dart';

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

  String _prop(String key) {
    if (!_orgUnit.hasProperties()) return '';
    final field = _orgUnit.properties.fields[key];
    if (field == null || !field.hasStringValue()) return '';
    return field.stringValue;
  }

  List<OrganizationContact> _readContacts() {
    if (!_orgUnit.hasProperties()) return const [];
    final field = _orgUnit.properties.fields['contacts'];
    if (field == null || !field.hasListValue()) return const [];
    final result = <OrganizationContact>[];
    for (final v in field.listValue.values) {
      if (!v.hasStructValue()) continue;
      final m = <String, dynamic>{};
      for (final entry in v.structValue.fields.entries) {
        if (entry.value.hasStringValue()) {
          m[entry.key] = entry.value.stringValue;
        }
      }
      final contact = OrganizationContact.fromMap(m);
      if (contact != null) result.add(contact);
    }
    return result;
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
    final membersAsync = ref.watch(
      workforceMemberListProvider(
        query: '',
        homeOrgUnitId: _orgUnit.id,
      ),
    );
    final tenancy = ref.watch(tenancyContextProvider);
    final isActive = tenancy.branchId == _orgUnit.id ||
        tenancy.organizationId == _orgUnit.organizationId;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: CustomScrollView(
          slivers: [
            // -- Header
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
                            '${orgUnitTypeLabel(_orgUnit.type)}${_orgUnit.code.isNotEmpty ? ' \u2022 ${_orgUnit.code}' : ''}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(140),
                            ),
                          ),
                        ],
                      ),
                    ),
                    StateBadge(state: _orgUnit.state),
                    const SizedBox(width: 8),
                    if (_orgUnit.state == STATE.ACTIVE)
                      OutlinedButton.icon(
                        onPressed: () => _setAsActiveContext(context),
                        icon: Icon(
                          isActive
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          size: 18,
                        ),
                        label: Text(isActive ? 'Active' : 'Set Active'),
                        style: isActive
                            ? OutlinedButton.styleFrom(
                                foregroundColor: theme.colorScheme.tertiary,
                                side: BorderSide(
                                    color: theme.colorScheme.tertiary),
                              )
                            : null,
                      ),
                    if (widget.canManage) ...[
                      const SizedBox(width: 8),
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

            // -- Info card (details, location, contacts)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: _buildInfoCard(theme),
              ),
            ),

            // -- Login URL
            if (_orgUnit.clientId.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: theme.colorScheme.outlineVariant.withAlpha(38),
                      ),
                    ),
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
                      trailing: IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                            text: '${Uri.base.origin}/login/${_orgUnit.clientId}',
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login URL copied')),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

            // -- Coverage area
            if (_orgUnit.geoId.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: CoverageAreaSummary(areaId: _orgUnit.geoId),
                ),
              ),

            // -- Approval panel
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

            // -- Child org units
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
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant.withAlpha(38),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: DataTable(
                        showCheckboxColumn: false,
                        columns: const [
                          DataColumn(label: Text('NAME')),
                          DataColumn(label: Text('TYPE')),
                          DataColumn(label: Text('CODE')),
                          DataColumn(label: Text('STATE')),
                        ],
                        rows: children.map((child) {
                          return DataRow(
                            onSelectChanged: (_) => context.go(
                              '/organization/organizations/${_orgUnit.organizationId}/org-units/${child.id}',
                            ),
                            cells: [
                              DataCell(Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    child.type ==
                                            OrgUnitType.ORG_UNIT_TYPE_BRANCH
                                        ? Icons.store_outlined
                                        : Icons.account_tree_outlined,
                                    size: 18,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(child.name),
                                ],
                              )),
                              DataCell(Text(orgUnitTypeLabel(child.type))),
                              DataCell(Text(child.code)),
                              DataCell(StateBadge(state: child.state)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),

            // -- Workforce members
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                child: Row(
                  children: [
                    Icon(Icons.badge_outlined,
                        size: 20, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Workforce Members',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
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
              data: (members) {
                if (members.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.badge_outlined,
                                size: 40,
                                color: theme.colorScheme.onSurface
                                    .withAlpha(60)),
                            const SizedBox(height: 8),
                            Text('No members assigned to this unit',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant.withAlpha(38),
                        ),
                      ),
                      child: Column(
                        children: members.map((member) {
                          final name = member.hasProperties() &&
                                  member.properties.fields.containsKey('name')
                              ? member.properties.fields['name']!.stringValue
                              : member.profileId;
                          return ListTile(
                            leading: ProfileAvatar(
                              profileId: member.profileId,
                              name: name,
                              size: 36,
                            ),
                            title: Text(name),
                            trailing: StateBadge(state: member.state),
                            onTap: () => context.go(
                              '/workforce/members/${member.id}',
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),

            // -- Audit trail
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: _buildAuditTrail(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -- Info card with details, location, contacts
  Widget _buildInfoCard(ThemeData theme) {
    final description = _prop('description');
    final contacts = _readContacts();
    final addressParts = [
      _prop('address_street'),
      _prop('address_city'),
      _prop('address_country'),
      _prop('address_postal_code'),
    ].where((s) => s.isNotEmpty);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withAlpha(38),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Core info
            LayoutBuilder(
              builder: (context, constraints) {
                final items = <Widget>[];
                items.add(_InfoTile(
                  label: 'Type',
                  value: orgUnitTypeLabel(_orgUnit.type),
                ));
                if (_orgUnit.code.isNotEmpty) {
                  items.add(_InfoTile(label: 'Code', value: _orgUnit.code));
                }
                if (_orgUnit.organizationId.isNotEmpty) {
                  items.add(_InfoTile(
                    label: 'Organization',
                    value: _orgUnit.organizationId,
                  ));
                }
                if (_orgUnit.partitionId.isNotEmpty) {
                  items.add(_InfoTile(
                    label: 'Partition',
                    value: _orgUnit.partitionId,
                  ));
                }
                if (description.isNotEmpty) {
                  items.add(_InfoTile(
                    label: 'Description',
                    value: description,
                  ));
                }
                if (addressParts.isNotEmpty) {
                  items.add(_InfoTile(
                    label: 'Address',
                    value: addressParts.join(', '),
                  ));
                }

                if (constraints.maxWidth >= 480) {
                  final mid = (items.length / 2).ceil();
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: items.sublist(0, mid),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              items.length > mid ? items.sublist(mid) : [],
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items,
                );
              },
            ),

            // Contacts section
            if (contacts.isNotEmpty) ...[
              const Divider(height: 32),
              Text(
                'Contacts',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: contacts.map((c) {
                  return Chip(
                    avatar: Icon(
                      c.type == ContactType.email
                          ? Icons.email
                          : Icons.phone,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    label: Text(
                      '${contactPurposeLabel(c.purpose)}: ${c.value}',
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // -- Audit trail
  Widget _buildAuditTrail(ThemeData theme) {
    final entries = <AuditTrailEntry>[];
    if (_orgUnit.hasProperties()) {
      final caseAction = _prop('case_action');
      final caseActorId = _prop('case_actor_id');
      if (caseAction.isNotEmpty) {
        entries.add(AuditTrailEntry(
          action: 'Case Action: $caseAction',
          timestamp: 'Recent',
          performedBy: caseActorId.isNotEmpty ? caseActorId : null,
          icon: Icons.gavel,
          color: theme.colorScheme.tertiary,
        ));
      }
    }

    entries.add(AuditTrailEntry(
      action: 'Org unit created',
      timestamp: 'State: ${_orgUnit.state.name}',
      icon: Icons.add_circle_outline,
      color: theme.colorScheme.primary,
    ));

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withAlpha(38),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Activity History',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...entries,
          ],
        ),
      ),
    );
  }

  // -- Actions
  void _setAsActiveContext(BuildContext context) {
    final tenancy = ref.read(tenancyContextProvider);

    // If the org unit is a branch, set it as the active branch context.
    // Its partition becomes the new context for all queries.
    if (_orgUnit.type == OrgUnitType.ORG_UNIT_TYPE_BRANCH) {
      tenancy.selectBranch(
        _orgUnit.id,
        _orgUnit.name,
        partitionId: _orgUnit.partitionId.isNotEmpty
            ? _orgUnit.partitionId
            : null,
      );
    }

    // Always set organization context
    tenancy.selectOrganization(
      _orgUnit.organizationId,
      '', // name will be resolved
      partitionId: _orgUnit.partitionId.isNotEmpty
          ? _orgUnit.partitionId
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_orgUnit.name} set as active context'
          '${_orgUnit.partitionId.isNotEmpty ? ' (partition: ${_orgUnit.partitionId})' : ''}',
        ),
        duration: const Duration(seconds: 3),
      ),
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

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
