import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../data/organization_providers.dart';

class OrganizationsScreen extends ConsumerStatefulWidget {
  const OrganizationsScreen({super.key});

  @override
  ConsumerState<OrganizationsScreen> createState() =>
      _OrganizationsScreenState();
}

class _OrganizationsScreenState extends ConsumerState<OrganizationsScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _query = value.trim();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final organizationsAsync = ref.watch(organizationListProvider(_query));
    final canManage =
        ref.watch(canManageOrganizationsProvider).value ?? false;

    return EntityListPage<OrganizationObject>(
      title: 'Organizations',
      icon: Icons.account_balance_outlined,
      items: organizationsAsync.value ?? [],
      isLoading: organizationsAsync.isLoading,
      error: organizationsAsync.hasError
          ? organizationsAsync.error.toString()
          : null,
      onRetry: () => ref.invalidate(organizationListProvider(_query)),
      searchHint: 'Search organizations...',
      onSearchChanged: _onSearchChanged,
      actionLabel: 'Add Organization',
      canAction: canManage,
      onAction: () => _showOrganizationDialog(context),
      itemBuilder: (context, organization) => _OrganizationCard(
        organization: organization,
        onTap: () =>
            context.go('/organization/organizations/${organization.id}'),
      ),
    );
  }

  void _showOrganizationDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => OrganizationFormDialog(
        onSave: (updated) async {
          try {
            await ref
                .read(organizationProvider.notifier)
                .save(updated);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Organization created successfully')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to save organization: $e'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          }
        },
      ),
    );
  }
}

class _OrganizationCard extends StatelessWidget {
  const _OrganizationCard(
      {required this.organization, required this.onTap});

  final OrganizationObject organization;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.account_balance,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          organization.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Code: ${organization.code}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(160),
          ),
        ),
        trailing: StateBadge(state: organization.state),
        onTap: onTap,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Organization create / edit dialog (public so detail screen can reuse)
// ---------------------------------------------------------------------------

class OrganizationFormDialog extends StatefulWidget {
  const OrganizationFormDialog(
      {super.key, this.organization, required this.onSave});

  final OrganizationObject? organization;
  final Future<void> Function(OrganizationObject organization) onSave;

  @override
  State<OrganizationFormDialog> createState() =>
      _OrganizationFormDialogState();
}

class _OrganizationFormDialogState extends State<OrganizationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _codeCtrl;
  late STATE _selectedState;
  bool _saving = false;

  bool get _isEditing => widget.organization != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl =
        TextEditingController(text: widget.organization?.name ?? '');
    _codeCtrl =
        TextEditingController(text: widget.organization?.code ?? '');
    _selectedState = widget.organization?.state ?? STATE.CREATED;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final organization = OrganizationObject(
      id: widget.organization?.id,
      name: _nameCtrl.text.trim(),
      code: _codeCtrl.text.trim(),
      state: _selectedState,
    );

    // Preserve backend-managed fields when editing.
    if (widget.organization != null) {
      if (widget.organization!.hasPartitionId()) {
        organization.partitionId = widget.organization!.partitionId;
      }
      if (widget.organization!.hasProfileId()) {
        organization.profileId = widget.organization!.profileId;
      }
      if (widget.organization!.hasProperties()) {
        organization.properties = widget.organization!.properties;
      }
    }

    try {
      await widget.onSave(organization);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  static const _editableStates = [
    STATE.CREATED,
    STATE.CHECKED,
    STATE.ACTIVE,
    STATE.INACTIVE,
    STATE.DELETED,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit Organization' : 'Add Organization'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.trim().isEmpty)
                        ? 'Name is required'
                        : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(labelText: 'Code'),
                textInputAction: TextInputAction.done,
                validator: (v) =>
                    (v == null || v.trim().isEmpty)
                        ? 'Code is required'
                        : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<STATE>(
                initialValue: _selectedState,
                decoration: const InputDecoration(labelText: 'State'),
                items: _editableStates
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(stateLabel(s)),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _selectedState = v);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }
}
