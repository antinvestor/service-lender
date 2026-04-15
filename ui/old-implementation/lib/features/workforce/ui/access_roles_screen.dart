import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/form_field_card.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../data/access_role_providers.dart';

/// Human-readable label for scope types.
String _scopeLabel(AccessScopeType scope) => switch (scope) {
  AccessScopeType.ACCESS_SCOPE_TYPE_GLOBAL => 'Global',
  AccessScopeType.ACCESS_SCOPE_TYPE_ORGANIZATION => 'Organization',
  AccessScopeType.ACCESS_SCOPE_TYPE_ORG_UNIT => 'Org Unit',
  AccessScopeType.ACCESS_SCOPE_TYPE_TEAM => 'Team',
  _ => 'Unspecified',
};

const _selectableStates = [
  STATE.CREATED,
  STATE.CHECKED,
  STATE.ACTIVE,
  STATE.INACTIVE,
  STATE.DELETED,
];

class AccessRolesScreen extends ConsumerStatefulWidget {
  const AccessRolesScreen({super.key});

  @override
  ConsumerState<AccessRolesScreen> createState() => _AccessRolesScreenState();
}

class _AccessRolesScreenState extends ConsumerState<AccessRolesScreen> {
  String _searchQuery = '';
  String _roleKeyFilter = '';

  @override
  Widget build(BuildContext context) {
    final assignmentsAsync = ref.watch(
      accessRoleAssignmentListProvider(
        query: _searchQuery,
        roleKey: _roleKeyFilter,
      ),
    );
    final canManage = ref.watch(canManageAccessRolesProvider);

    final isAdmin = canManage.when(
      data: (value) => value,
      loading: () => false,
      error: (_, _) => false,
    );

    return assignmentsAsync.when(
      loading: () => EntityListPage<AccessRoleAssignmentObject>(
        title: 'Access Roles',
        icon: Icons.admin_panel_settings_outlined,
        items: const [],
        isLoading: true,
        itemBuilder: (_, _) => const SizedBox.shrink(),
        searchHint: 'Search role assignments...',
        onSearchChanged: _onSearchChanged,
        filterWidget: _buildFilters(),
        actionLabel: 'Add Role Assignment',
        canAction: isAdmin,
        onAction: () => _showAssignmentDialog(context),
      ),
      error: (error, _) => EntityListPage<AccessRoleAssignmentObject>(
        title: 'Access Roles',
        icon: Icons.admin_panel_settings_outlined,
        items: const [],
        error: error.toString(),
        onRetry: () => ref.invalidate(
          accessRoleAssignmentListProvider(
            query: _searchQuery,
            roleKey: _roleKeyFilter,
          ),
        ),
        itemBuilder: (_, _) => const SizedBox.shrink(),
        searchHint: 'Search role assignments...',
        onSearchChanged: _onSearchChanged,
        filterWidget: _buildFilters(),
        actionLabel: 'Add Role Assignment',
        canAction: isAdmin,
        onAction: () => _showAssignmentDialog(context),
      ),
      data: (assignments) => EntityListPage<AccessRoleAssignmentObject>(
        title: 'Access Roles',
        icon: Icons.admin_panel_settings_outlined,
        items: assignments,
        itemBuilder: (context, assignment) => _AssignmentCard(
          assignment: assignment,
          onTap: isAdmin
              ? () => _showAssignmentDialog(context, assignment: assignment)
              : null,
        ),
        searchHint: 'Search role assignments...',
        onSearchChanged: _onSearchChanged,
        filterWidget: _buildFilters(),
        actionLabel: 'Add Role Assignment',
        canAction: isAdmin,
        onAction: () => _showAssignmentDialog(context),
      ),
    );
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
  }

  Widget _buildFilters() {
    return DropdownButton<String>(
      value: _roleKeyFilter,
      underline: const SizedBox.shrink(),
      icon: const Icon(Icons.filter_list, size: 20),
      items: [
        const DropdownMenuItem(value: '', child: Text('All Roles')),
        for (final key in selectableRoleKeys)
          DropdownMenuItem(value: key, child: Text(accessRoleLabel(key))),
      ],
      onChanged: (value) {
        if (value != null) setState(() => _roleKeyFilter = value);
      },
    );
  }

  Future<void> _showAssignmentDialog(
    BuildContext context, {
    AccessRoleAssignmentObject? assignment,
  }) async {
    final result = await showDialog<AccessRoleAssignmentObject>(
      context: context,
      builder: (context) => _AssignmentDialog(assignment: assignment),
    );

    if (result == null || !mounted) return;

    try {
      await ref
          .read(accessRoleAssignmentProvider.notifier)
          .save(result);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            assignment == null
                ? 'Role assignment created successfully'
                : 'Role assignment updated successfully',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    }
  }
}

class _AssignmentCard extends StatelessWidget {
  const _AssignmentCard({required this.assignment, this.onTap});

  final AccessRoleAssignmentObject assignment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roleDesc = accessRoleDescription(assignment.roleKey);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withAlpha(38),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _roleIcon(assignment.roleKey),
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      accessRoleLabel(assignment.roleKey),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (roleDesc.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        roleDesc,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outlined,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            assignment.memberId.isNotEmpty
                                ? assignment.memberId
                                : 'No Member',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontFamily: 'monospace',
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer
                                .withAlpha(100),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_scopeLabel(assignment.scopeType)}'
                            '${assignment.scopeId.isNotEmpty ? ': ${_shortId(assignment.scopeId)}' : ''}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              StateBadge(state: assignment.state),
              if (onTap != null) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String _shortId(String id) =>
      id.length > 12 ? '${id.substring(0, 12)}...' : id;

  static IconData _roleIcon(String roleKey) => switch (roleKey) {
        AccessRoleKeys.organizationOwner => Icons.star,
        AccessRoleKeys.organizationAdmin => Icons.admin_panel_settings,
        AccessRoleKeys.identityAdministrator => Icons.manage_accounts,
        AccessRoleKeys.branchManager => Icons.store,
        AccessRoleKeys.loanManager => Icons.account_balance,
        AccessRoleKeys.approvalVerifier => Icons.verified_user,
        AccessRoleKeys.approvalApprover => Icons.check_circle,
        AccessRoleKeys.fieldWorker => Icons.directions_walk,
        AccessRoleKeys.disbursementOfficer => Icons.payments,
        AccessRoleKeys.repaymentOfficer => Icons.receipt_long,
        AccessRoleKeys.treasuryManager => Icons.savings,
        AccessRoleKeys.auditor => Icons.policy,
        AccessRoleKeys.viewer => Icons.visibility,
        AccessRoleKeys.serviceAccount => Icons.smart_toy,
        _ => Icons.security_outlined,
      };
}

class _AssignmentDialog extends ConsumerStatefulWidget {
  const _AssignmentDialog({this.assignment});

  final AccessRoleAssignmentObject? assignment;

  @override
  ConsumerState<_AssignmentDialog> createState() => _AssignmentDialogState();
}

class _AssignmentDialogState extends ConsumerState<_AssignmentDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _memberIdController;
  late final TextEditingController _scopeIdController;
  late String _selectedRoleKey;
  late AccessScopeType _selectedScopeType;
  late STATE _selectedState;

  bool get _isEditing => widget.assignment != null;

  @override
  void initState() {
    super.initState();
    _memberIdController = TextEditingController(
      text: widget.assignment?.memberId ?? '',
    );
    _scopeIdController = TextEditingController(
      text: widget.assignment?.scopeId ?? '',
    );
    _selectedRoleKey =
        widget.assignment?.roleKey ?? AccessRoleKeys.approvalVerifier;
    _selectedScopeType = widget.assignment?.scopeType ??
        AccessScopeType.ACCESS_SCOPE_TYPE_ORGANIZATION;
    _selectedState = widget.assignment?.state ?? STATE.CREATED;
  }

  @override
  void dispose() {
    _memberIdController.dispose();
    _scopeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roleDesc = accessRoleDescription(_selectedRoleKey);

    return Dialog(
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outlineVariant.withAlpha(60),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.admin_panel_settings_outlined,
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
                          _isEditing
                              ? 'Edit Role Assignment'
                              : 'Assign Role',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Grant access permissions to a workforce member.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Body
            Flexible(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormFieldCard(
                        label: 'Workforce Member ID',
                        description:
                            'The ID of the workforce member to assign this role to.',
                        isRequired: true,
                        child: TextFormField(
                          controller: _memberIdController,
                          decoration: const InputDecoration(
                            hintText: 'Enter member ID',
                            prefixIcon: Icon(Icons.person_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Member ID is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      FormFieldCard(
                        label: 'Role',
                        description:
                            'The access role to assign. Each role grants specific permissions.',
                        isRequired: true,
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedRoleKey,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.security_outlined),
                          ),
                          items: [
                            for (final key in selectableRoleKeys)
                              DropdownMenuItem(
                                value: key,
                                child: Text(accessRoleLabel(key)),
                              ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedRoleKey = value);
                            }
                          },
                        ),
                      ),
                      // Role description
                      if (roleDesc.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer
                                  .withAlpha(40),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    roleDesc,
                                    style:
                                        theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      FormFieldCard(
                        label: 'Scope Type',
                        description:
                            'Determines where this role applies. Global scope gives access across the entire platform.',
                        isRequired: true,
                        child: DropdownButtonFormField<AccessScopeType>(
                          initialValue: _selectedScopeType,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.shield_outlined),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value:
                                  AccessScopeType.ACCESS_SCOPE_TYPE_GLOBAL,
                              child: Text('Global'),
                            ),
                            DropdownMenuItem(
                              value: AccessScopeType
                                  .ACCESS_SCOPE_TYPE_ORGANIZATION,
                              child: Text('Organization'),
                            ),
                            DropdownMenuItem(
                              value: AccessScopeType
                                  .ACCESS_SCOPE_TYPE_ORG_UNIT,
                              child: Text('Org Unit'),
                            ),
                            DropdownMenuItem(
                              value:
                                  AccessScopeType.ACCESS_SCOPE_TYPE_TEAM,
                              child: Text('Team'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedScopeType = value);
                            }
                          },
                        ),
                      ),
                      if (_selectedScopeType !=
                          AccessScopeType.ACCESS_SCOPE_TYPE_GLOBAL)
                        FormFieldCard(
                          label: 'Scope ID',
                          description:
                              'The ID of the ${_scopeLabel(_selectedScopeType).toLowerCase()} '
                              'this role is scoped to.',
                          isRequired: true,
                          child: TextFormField(
                            controller: _scopeIdController,
                            decoration: InputDecoration(
                              hintText:
                                  'Enter ${_scopeLabel(_selectedScopeType).toLowerCase()} ID',
                              prefixIcon:
                                  const Icon(Icons.fingerprint),
                            ),
                            validator: (value) {
                              if (_selectedScopeType !=
                                      AccessScopeType
                                          .ACCESS_SCOPE_TYPE_GLOBAL &&
                                  (value == null ||
                                      value.trim().isEmpty)) {
                                return 'Scope ID is required for non-global scope';
                              }
                              return null;
                            },
                          ),
                        ),
                      FormFieldCard(
                        label: 'State',
                        description:
                            'Active assignments are enforced immediately.',
                        isRequired: true,
                        child: DropdownButtonFormField<STATE>(
                          initialValue: _selectedState,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.flag_outlined),
                          ),
                          items: [
                            for (final state in _selectableStates)
                              DropdownMenuItem(
                                value: state,
                                child: Text(stateLabel(state)),
                              ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedState = value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Actions
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outlineVariant.withAlpha(60),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _onSave,
                    icon: Icon(
                      _isEditing ? Icons.save : Icons.add,
                      size: 18,
                    ),
                    label: Text(_isEditing ? 'Update' : 'Assign Role'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final assignment = AccessRoleAssignmentObject(
      id: widget.assignment?.id,
      memberId: _memberIdController.text.trim(),
      roleKey: _selectedRoleKey,
      scopeType: _selectedScopeType,
      scopeId: _scopeIdController.text.trim(),
      state: _selectedState,
    );

    Navigator.of(context).pop(assignment);
  }
}
