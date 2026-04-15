import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/form_field_card.dart';
import '../../../core/widgets/profile_badge.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../organization/data/organization_providers.dart';
import '../../organization/data/org_unit_providers.dart';
import '../data/workforce_member_providers.dart';

String _engagementLabel(WorkforceEngagementType type) => switch (type) {
  WorkforceEngagementType.WORKFORCE_ENGAGEMENT_TYPE_EMPLOYEE => 'Employee',
  WorkforceEngagementType.WORKFORCE_ENGAGEMENT_TYPE_CONTRACTOR => 'Contractor',
  WorkforceEngagementType.WORKFORCE_ENGAGEMENT_TYPE_SERVICE_ACCOUNT =>
    'Service Account',
  _ => 'Unspecified',
};

class WorkforceMembersScreen extends ConsumerStatefulWidget {
  const WorkforceMembersScreen({super.key});

  @override
  ConsumerState<WorkforceMembersScreen> createState() =>
      _WorkforceMembersScreenState();
}

class _WorkforceMembersScreenState
    extends ConsumerState<WorkforceMembersScreen> {
  String _searchQuery = '';
  String _orgFilter = '';

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(
      workforceMemberListProvider(
        query: _searchQuery,
        organizationId: _orgFilter,
      ),
    );
    final canManage = ref.watch(canManageWorkforceProvider);
    final orgsAsync = ref.watch(organizationListProvider(''));

    return EntityListPage<WorkforceMemberObject>(
      title: 'Workforce Members',
      icon: Icons.badge_outlined,
      items: membersAsync.value ?? [],
      isLoading: membersAsync.isLoading,
      error: membersAsync.hasError ? membersAsync.error.toString() : null,
      onRetry: () => ref.invalidate(
        workforceMemberListProvider(
          query: _searchQuery,
          organizationId: _orgFilter,
        ),
      ),
      searchHint: 'Search members...',
      onSearchChanged: (value) => setState(() => _searchQuery = value),
      actionLabel: 'Register Member',
      canAction: canManage.value ?? false,
      onAction: () => context.go('/workforce/members/new'),
      filterWidget: _buildFilters(orgsAsync),
      itemBuilder: (context, member) => _MemberCard(
        member: member,
        onEdit: (canManage.value ?? false)
            ? () => _showMemberDialog(context, member: member)
            : null,
      ),
    );
  }

  Widget _buildFilters(AsyncValue<List<OrganizationObject>> orgsAsync) {
    final orgs = orgsAsync.value ?? [];
    return DropdownButton<String>(
      value: _orgFilter,
      hint: const Text('All Orgs'),
      underline: const SizedBox.shrink(),
      items: [
        const DropdownMenuItem(value: '', child: Text('All Organizations')),
        ...orgs.map(
          (o) => DropdownMenuItem(
            value: o.id,
            child: Text(o.name.isNotEmpty ? o.name : o.id),
          ),
        ),
      ],
      onChanged: (value) => setState(() => _orgFilter = value ?? ''),
    );
  }

  Future<void> _showMemberDialog(
    BuildContext context, {
    WorkforceMemberObject? member,
  }) async {
    final result = await showDialog<WorkforceMemberObject>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _MemberFormDialog(member: member),
    );

    if (result != null && context.mounted) {
      try {
        await ref.read(workforceMemberProvider.notifier).save(result);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                member == null
                    ? 'Member registered successfully'
                    : 'Member updated successfully',
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({required this.member, this.onEdit});
  final WorkforceMemberObject member;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = [
      _engagementLabel(member.engagementType),
      if (member.organizationId.isNotEmpty) 'Org: ${member.organizationId}',
      if (member.homeOrgUnitId.isNotEmpty) 'Unit: ${member.homeOrgUnitId}',
    ].join(' \u00b7 ');

    // Extract name from properties if available.
    final name = member.hasProperties() &&
            member.properties.fields.containsKey('name')
        ? member.properties.fields['name']!.stringValue
        : member.profileId;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: () => context.go('/workforce/members/${member.id}'),
        leading: ProfileAvatar(
          profileId: member.profileId,
          name: name,
          size: 40,
        ),
        title: Text(
          name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(subtitle, style: theme.textTheme.bodySmall)
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StateBadge(state: member.state),
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                onPressed: onEdit,
                tooltip: 'Edit',
              ),
          ],
        ),
      ),
    );
  }
}

class _MemberFormDialog extends ConsumerStatefulWidget {
  const _MemberFormDialog({this.member});
  final WorkforceMemberObject? member;

  @override
  ConsumerState<_MemberFormDialog> createState() => _MemberFormDialogState();
}

class _MemberFormDialogState extends ConsumerState<_MemberFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _profileIdController;
  late final TextEditingController _geoIdController;
  late String _selectedOrgId;
  late String _selectedOrgUnitId;
  late WorkforceEngagementType _engagementType;
  late STATE _state;

  bool get _isEditing => widget.member != null;

  @override
  void initState() {
    super.initState();
    final m = widget.member;
    _profileIdController = TextEditingController(text: m?.profileId ?? '');
    _geoIdController = TextEditingController(text: m?.geoId ?? '');
    _selectedOrgId = m?.organizationId ?? '';
    _selectedOrgUnitId = m?.homeOrgUnitId ?? '';
    _engagementType = m?.engagementType ??
        WorkforceEngagementType.WORKFORCE_ENGAGEMENT_TYPE_EMPLOYEE;
    _state = m?.state ?? STATE.CREATED;
  }

  @override
  void dispose() {
    _profileIdController.dispose();
    _geoIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orgsAsync = ref.watch(organizationListProvider(''));
    final orgUnitsAsync = ref.watch(orgUnitListProvider(organizationId: _selectedOrgId));

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
              Icons.badge_outlined,
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
                  _isEditing ? 'Edit Member' : 'New Workforce Member',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _isEditing
                      ? 'Update the member details below.'
                      : 'Register a new employee, contractor, or service account.',
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
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                FormFieldCard(
                  label: 'Profile ID',
                  description:
                      'The platform profile identifier linking this member to their user account.',
                  isRequired: true,
                  child: TextFormField(
                    controller: _profileIdController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. d75qclkpf2t1uum8ij3g',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Profile ID is required'
                        : null,
                  ),
                ),
                FormFieldCard(
                  label: 'Engagement Type',
                  description:
                      'How this member is engaged with the organization.',
                  isRequired: true,
                  child: DropdownButtonFormField<WorkforceEngagementType>(
                    initialValue: _engagementType,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.work_outline),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: WorkforceEngagementType
                            .WORKFORCE_ENGAGEMENT_TYPE_EMPLOYEE,
                        child: Text('Employee'),
                      ),
                      DropdownMenuItem(
                        value: WorkforceEngagementType
                            .WORKFORCE_ENGAGEMENT_TYPE_CONTRACTOR,
                        child: Text('Contractor'),
                      ),
                      DropdownMenuItem(
                        value: WorkforceEngagementType
                            .WORKFORCE_ENGAGEMENT_TYPE_SERVICE_ACCOUNT,
                        child: Text('Service Account'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _engagementType = v);
                    },
                  ),
                ),
                FormFieldCard(
                  label: 'Organization',
                  description: 'The organization this member belongs to.',
                  isRequired: true,
                  child: orgsAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('Failed to load: $e'),
                    data: (orgs) => DropdownButtonFormField<String>(
                      initialValue: _selectedOrgId.isNotEmpty &&
                              orgs.any((o) => o.id == _selectedOrgId)
                          ? _selectedOrgId
                          : null,
                      decoration: const InputDecoration(
                        hintText: 'Select organization',
                        prefixIcon: Icon(Icons.business_outlined),
                      ),
                      items: orgs
                          .map(
                            (o) => DropdownMenuItem(
                              value: o.id,
                              child: Text(o.name.isNotEmpty ? o.name : o.id),
                            ),
                          )
                          .toList(),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Organization is required'
                          : null,
                      onChanged: (v) => setState(() {
                        _selectedOrgId = v ?? '';
                        _selectedOrgUnitId = '';
                      }),
                    ),
                  ),
                ),
                FormFieldCard(
                  label: 'Home Org Unit',
                  description:
                      'Optional. The org unit where this member is primarily based.',
                  child: orgUnitsAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('Failed to load: $e'),
                    data: (units) {
                      if (_selectedOrgId.isEmpty) {
                        return const Text(
                          'Select an organization first',
                          style: TextStyle(color: Colors.grey),
                        );
                      }
                      return DropdownButtonFormField<String>(
                        initialValue: _selectedOrgUnitId.isNotEmpty &&
                                units.any((u) => u.id == _selectedOrgUnitId)
                            ? _selectedOrgUnitId
                            : null,
                        decoration: const InputDecoration(
                          hintText: 'Select org unit',
                          prefixIcon: Icon(Icons.account_tree_outlined),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: '',
                            child: Text('None'),
                          ),
                          ...units.map(
                            (u) => DropdownMenuItem(
                              value: u.id,
                              child: Text(u.name.isNotEmpty ? u.name : u.id),
                            ),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _selectedOrgUnitId = v ?? ''),
                      );
                    },
                  ),
                ),
                FormFieldCard(
                  label: 'Geographic ID',
                  description:
                      "Optional geographic area identifier for this member's territory.",
                  child: TextFormField(
                    controller: _geoIdController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. KE-NBI-EAST',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                ),
                FormFieldCard(
                  label: 'State',
                  description: 'The current status of this member.',
                  isRequired: true,
                  child: DropdownButtonFormField<STATE>(
                    initialValue: _state,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.toggle_on_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: STATE.CREATED,
                        child: Text('Created'),
                      ),
                      DropdownMenuItem(
                        value: STATE.ACTIVE,
                        child: Text('Active'),
                      ),
                      DropdownMenuItem(
                        value: STATE.INACTIVE,
                        child: Text('Inactive'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _state = v);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: Icon(_isEditing ? Icons.save : Icons.add),
          label: Text(_isEditing ? 'Update' : 'Register Member'),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      WorkforceMemberObject(
        id: widget.member?.id ?? '',
        profileId: _profileIdController.text.trim(),
        organizationId: _selectedOrgId,
        homeOrgUnitId: _selectedOrgUnitId,
        engagementType: _engagementType,
        geoId: _geoIdController.text.trim(),
        state: _state,
      ),
    );
  }
}
