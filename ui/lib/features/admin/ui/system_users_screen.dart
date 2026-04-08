import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/form_field_card.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../organization/data/branch_providers.dart';
import '../data/system_user_providers.dart';

/// Converts a [SystemUserRole] to a human-readable display string.
String systemUserRoleLabel(SystemUserRole role) {
  return switch (role) {
    SystemUserRole.SYSTEM_USER_ROLE_VERIFIER => 'Verifier',
    SystemUserRole.SYSTEM_USER_ROLE_APPROVER => 'Approver',
    SystemUserRole.SYSTEM_USER_ROLE_ADMINISTRATOR => 'Administrator',
    SystemUserRole.SYSTEM_USER_ROLE_AUDITOR => 'Auditor',
    _ => 'Unspecified',
  };
}

/// The selectable roles for filtering and form dropdowns (excludes UNSPECIFIED).
const _selectableRoles = [
  SystemUserRole.SYSTEM_USER_ROLE_VERIFIER,
  SystemUserRole.SYSTEM_USER_ROLE_APPROVER,
  SystemUserRole.SYSTEM_USER_ROLE_ADMINISTRATOR,
  SystemUserRole.SYSTEM_USER_ROLE_AUDITOR,
];

/// The selectable states for the form dropdown.
const _selectableStates = [
  STATE.CREATED,
  STATE.CHECKED,
  STATE.ACTIVE,
  STATE.INACTIVE,
  STATE.DELETED,
];

class SystemUsersScreen extends ConsumerStatefulWidget {
  const SystemUsersScreen({super.key});

  @override
  ConsumerState<SystemUsersScreen> createState() => _SystemUsersScreenState();
}

class _SystemUsersScreenState extends ConsumerState<SystemUsersScreen> {
  String _searchQuery = '';
  String _branchFilter = '';
  SystemUserRole _roleFilter = SystemUserRole.SYSTEM_USER_ROLE_UNSPECIFIED;

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(
      systemUserListProvider(
        query: _searchQuery,
        branchId: _branchFilter,
        role: _roleFilter,
      ),
    );
    final canManage = ref.watch(canManageSystemUsersProvider);

    final isAdmin = canManage.when(
      data: (value) => value,
      loading: () => false,
      error: (_, _) => false,
    );

    return usersAsync.when(
      loading: () => EntityListPage<SystemUserObject>(
        title: 'System Users',
        icon: Icons.manage_accounts_outlined,
        items: const [],
        isLoading: true,
        itemBuilder: (_, _) => const SizedBox.shrink(),
        searchHint: 'Search system users...',
        onSearchChanged: _onSearchChanged,
        filterWidget: _buildFilters(),
        actionLabel: 'Add System User',
        canAction: isAdmin,
        onAction: () => _showUserDialog(context),
      ),
      error: (error, _) => EntityListPage<SystemUserObject>(
        title: 'System Users',
        icon: Icons.manage_accounts_outlined,
        items: const [],
        error: error.toString(),
        onRetry: () => ref.invalidate(
          systemUserListProvider(
            query: _searchQuery,
            branchId: _branchFilter,
            role: _roleFilter,
          ),
        ),
        itemBuilder: (_, _) => const SizedBox.shrink(),
        searchHint: 'Search system users...',
        onSearchChanged: _onSearchChanged,
        filterWidget: _buildFilters(),
        actionLabel: 'Add System User',
        canAction: isAdmin,
        onAction: () => _showUserDialog(context),
      ),
      data: (users) => EntityListPage<SystemUserObject>(
        title: 'System Users',
        icon: Icons.manage_accounts_outlined,
        items: users,
        itemBuilder: (context, user) => _UserCard(
          user: user,
          onTap: isAdmin ? () => _showUserDialog(context, user: user) : null,
        ),
        searchHint: 'Search system users...',
        onSearchChanged: _onSearchChanged,
        filterWidget: _buildFilters(),
        actionLabel: 'Add System User',
        canAction: isAdmin,
        onAction: () => _showUserDialog(context),
      ),
    );
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
  }

  Widget _buildFilters() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Role filter
        DropdownButton<SystemUserRole>(
          value: _roleFilter,
          underline: const SizedBox.shrink(),
          icon: const Icon(Icons.filter_list, size: 20),
          items: [
            const DropdownMenuItem(
              value: SystemUserRole.SYSTEM_USER_ROLE_UNSPECIFIED,
              child: Text('All Roles'),
            ),
            for (final role in _selectableRoles)
              DropdownMenuItem(
                value: role,
                child: Text(systemUserRoleLabel(role)),
              ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _roleFilter = value);
            }
          },
        ),
        const SizedBox(width: 8),
        // Branch filter
        _BranchFilterDropdown(
          selectedBranchId: _branchFilter,
          onChanged: (value) {
            setState(() => _branchFilter = value);
          },
        ),
      ],
    );
  }

  Future<void> _showUserDialog(
    BuildContext context, {
    SystemUserObject? user,
  }) async {
    final result = await showDialog<SystemUserObject>(
      context: context,
      builder: (context) => _SystemUserDialog(user: user),
    );

    if (result == null || !mounted) return;

    try {
      await ref.read(systemUserProvider.notifier).save(result);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            user == null
                ? 'System user created successfully'
                : 'System user updated successfully',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save system user: $e')),
      );
    }
  }
}

// ---------------------------------------------------------------------------
// User card
// ---------------------------------------------------------------------------

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user, this.onTap});

  final SystemUserObject user;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
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
                  Icons.person_outline,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.profileId.isNotEmpty
                          ? user.profileId
                          : 'No Profile ID',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          systemUserRoleLabel(user.role),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.store_outlined,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            user.branchId.isNotEmpty
                                ? user.branchId
                                : 'No Branch',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              StateBadge(state: user.state),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Branch filter dropdown (loads branches from provider)
// ---------------------------------------------------------------------------

class _BranchFilterDropdown extends ConsumerWidget {
  const _BranchFilterDropdown({
    required this.selectedBranchId,
    required this.onChanged,
  });

  final String selectedBranchId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(branchListProvider('', ''));

    return branchesAsync.when(
      loading: () => const SizedBox(
        width: 120,
        child: LinearProgressIndicator(),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (branches) => DropdownButton<String>(
        value: selectedBranchId,
        underline: const SizedBox.shrink(),
        icon: const Icon(Icons.store_outlined, size: 20),
        items: [
          const DropdownMenuItem(value: '', child: Text('All Branches')),
          for (final branch in branches)
            DropdownMenuItem(
              value: branch.id,
              child: Text(branch.name.isNotEmpty ? branch.name : branch.id),
            ),
        ],
        onChanged: (value) => onChanged(value ?? ''),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Add / Edit dialog
// ---------------------------------------------------------------------------

class _SystemUserDialog extends ConsumerStatefulWidget {
  const _SystemUserDialog({this.user});

  final SystemUserObject? user;

  @override
  ConsumerState<_SystemUserDialog> createState() => _SystemUserDialogState();
}

class _SystemUserDialogState extends ConsumerState<_SystemUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _profileIdController;
  late final TextEditingController _serviceAccountIdController;
  late String _selectedBranchId;
  late SystemUserRole _selectedRole;
  late STATE _selectedState;

  bool get _isEditing => widget.user != null;

  @override
  void initState() {
    super.initState();
    _profileIdController = TextEditingController(
      text: widget.user?.profileId ?? '',
    );
    _serviceAccountIdController = TextEditingController(
      text: widget.user?.serviceAccountId ?? '',
    );
    _selectedBranchId = widget.user?.branchId ?? '';
    _selectedRole =
        widget.user?.role ?? SystemUserRole.SYSTEM_USER_ROLE_VERIFIER;
    _selectedState = widget.user?.state ?? STATE.CREATED;
  }

  @override
  void dispose() {
    _profileIdController.dispose();
    _serviceAccountIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branchesAsync = ref.watch(branchListProvider('', ''));

    return AlertDialog(
      title: Text(_isEditing ? 'Edit System User' : 'Add System User'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile ID
                FormFieldCard(
                  label: 'Profile ID',
                  description:
                      'The platform profile ID of the user to grant system access',
                  isRequired: true,
                  child: TextFormField(
                    controller: _profileIdController,
                    decoration: const InputDecoration(
                      hintText: 'Enter profile ID',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Profile ID is required';
                      }
                      return null;
                    },
                  ),
                ),

                // Branch dropdown
                FormFieldCard(
                  label: 'Branch',
                  description:
                      'The branch this user will be assigned to for operations',
                  isRequired: true,
                  child: branchesAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('Failed to load branches: $e'),
                    data: (branches) => DropdownButtonFormField<String>(
                      initialValue: _selectedBranchId.isNotEmpty &&
                              branches.any((b) => b.id == _selectedBranchId)
                          ? _selectedBranchId
                          : null,
                      decoration: const InputDecoration(
                        hintText: 'Select a branch',
                      ),
                      items: [
                        for (final branch in branches)
                          DropdownMenuItem(
                            value: branch.id,
                            child: Text(
                              branch.name.isNotEmpty
                                  ? branch.name
                                  : branch.id,
                            ),
                          ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Branch is required';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() => _selectedBranchId = value ?? '');
                      },
                    ),
                  ),
                ),

                // Role dropdown
                FormFieldCard(
                  label: 'Role',
                  description:
                      'Determines what actions this user can perform in the system',
                  isRequired: true,
                  child: DropdownButtonFormField<SystemUserRole>(
                    initialValue: _selectedRole,
                    items: [
                      for (final role in _selectableRoles)
                        DropdownMenuItem(
                          value: role,
                          child: Text(systemUserRoleLabel(role)),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedRole = value);
                      }
                    },
                  ),
                ),

                // Service Account ID (optional)
                FormFieldCard(
                  label: 'Service Account ID',
                  description:
                      'Optional machine-to-machine account for automated operations',
                  child: TextFormField(
                    controller: _serviceAccountIdController,
                    decoration: const InputDecoration(
                      hintText: 'Enter service account ID',
                    ),
                  ),
                ),

                // State dropdown
                FormFieldCard(
                  label: 'State',
                  description:
                      'The current lifecycle state of this system user record',
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

    final user = SystemUserObject(
      id: widget.user?.id,
      profileId: _profileIdController.text.trim(),
      branchId: _selectedBranchId,
      role: _selectedRole,
      serviceAccountId: _serviceAccountIdController.text.trim(),
      state: _selectedState,
    );

    Navigator.of(context).pop(user);
  }
}
