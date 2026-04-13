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

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.security_outlined,
                  color: theme.colorScheme.onPrimaryContainer,
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
                    const SizedBox(height: 4),
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
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.shield_outlined,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_scopeLabel(assignment.scopeType)}'
                          '${assignment.scopeId.isNotEmpty ? ': ${assignment.scopeId}' : ''}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              StateBadge(state: assignment.state),
            ],
          ),
        ),
      ),
    );
  }
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
    return AlertDialog(
      title: Text(
        _isEditing ? 'Edit Role Assignment' : 'Add Role Assignment',
      ),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                      'The access role to assign to this member.',
                  isRequired: true,
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedRoleKey,
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
                FormFieldCard(
                  label: 'Scope Type',
                  description:
                      'The scope at which this role applies.',
                  isRequired: true,
                  child: DropdownButtonFormField<AccessScopeType>(
                    initialValue: _selectedScopeType,
                    items: const [
                      DropdownMenuItem(
                        value: AccessScopeType.ACCESS_SCOPE_TYPE_GLOBAL,
                        child: Text('Global'),
                      ),
                      DropdownMenuItem(
                        value: AccessScopeType.ACCESS_SCOPE_TYPE_ORGANIZATION,
                        child: Text('Organization'),
                      ),
                      DropdownMenuItem(
                        value: AccessScopeType.ACCESS_SCOPE_TYPE_ORG_UNIT,
                        child: Text('Org Unit'),
                      ),
                      DropdownMenuItem(
                        value: AccessScopeType.ACCESS_SCOPE_TYPE_TEAM,
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
                FormFieldCard(
                  label: 'Scope ID',
                  description:
                      'The ID of the org, org unit, or team this role is scoped to. '
                      'Leave empty for global scope.',
                  child: TextFormField(
                    controller: _scopeIdController,
                    decoration: const InputDecoration(
                      hintText: 'Enter scope ID (optional for global)',
                    ),
                  ),
                ),
                FormFieldCard(
                  label: 'State',
                  description: 'The current lifecycle state.',
                  isRequired: true,
                  child: DropdownButtonFormField<STATE>(
                    initialValue: _selectedState,
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
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _onSave,
          child: Text(_isEditing ? 'Update' : 'Create'),
        ),
      ],
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
