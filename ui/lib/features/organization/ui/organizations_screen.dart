import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/error_helpers.dart';
import '../../../core/widgets/form_field_card.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../features/auth/data/auth_repository.dart';
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
    final canManage = ref.watch(canManageOrganizationsProvider).value ?? false;

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
      barrierDismissible: false,
      builder: (dialogContext) => OrganizationFormDialog(
        onSave: (updated) async {
          try {
            await ref.read(organizationProvider.notifier).save(updated);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Organization created successfully'),
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(friendlyError(e)),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
            rethrow;
          }
        },
      ),
    );
  }
}

class _OrganizationCard extends StatelessWidget {
  const _OrganizationCard({required this.organization, required this.onTap});

  final OrganizationObject organization;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
// Organization create / edit dialog
// ---------------------------------------------------------------------------

class OrganizationFormDialog extends ConsumerStatefulWidget {
  const OrganizationFormDialog({
    super.key,
    this.organization,
    required this.onSave,
  });

  final OrganizationObject? organization;
  final Future<void> Function(OrganizationObject organization) onSave;

  @override
  ConsumerState<OrganizationFormDialog> createState() =>
      _OrganizationFormDialogState();
}

class _OrganizationFormDialogState
    extends ConsumerState<OrganizationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _codeCtrl;
  late STATE _selectedState;
  late OrganizationType _orgType;
  bool _saving = false;

  bool get _isEditing => widget.organization != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.organization?.name ?? '');
    _codeCtrl = TextEditingController(text: widget.organization?.code ?? '');
    _selectedState = widget.organization?.state ?? STATE.CREATED;
    _orgType =
        widget.organization?.organizationType ??
        OrganizationType.ORGANIZATION_TYPE_UNSPECIFIED;
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

    // Read tenancy context from the authenticated user's JWT.
    final partitionId = await ref.read(currentPartitionIdProvider.future) ?? '';

    final organization = OrganizationObject(
      id: widget.organization?.id,
      name: _nameCtrl.text.trim(),
      code: _codeCtrl.text.trim(),
      state: _selectedState,
      organizationType: _orgType,
      partitionId: widget.organization?.partitionId ?? partitionId,
    );

    // Preserve backend-managed fields when editing.
    if (widget.organization != null) {
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

  static const _orgTypes = [
    OrganizationType.ORGANIZATION_TYPE_UNSPECIFIED,
    OrganizationType.ORGANIZATION_TYPE_BANK,
    OrganizationType.ORGANIZATION_TYPE_MICROFINANCE,
    OrganizationType.ORGANIZATION_TYPE_SACCO,
    OrganizationType.ORGANIZATION_TYPE_COOPERATIVE,
    OrganizationType.ORGANIZATION_TYPE_FINTECH,
  ];

  String _orgTypeLabel(OrganizationType type) {
    switch (type) {
      case OrganizationType.ORGANIZATION_TYPE_UNSPECIFIED:
        return 'Not specified';
      case OrganizationType.ORGANIZATION_TYPE_BANK:
        return 'Bank';
      case OrganizationType.ORGANIZATION_TYPE_MICROFINANCE:
        return 'Microfinance Institution';
      case OrganizationType.ORGANIZATION_TYPE_SACCO:
        return 'SACCO';
      case OrganizationType.ORGANIZATION_TYPE_COOPERATIVE:
        return 'Cooperative';
      case OrganizationType.ORGANIZATION_TYPE_FINTECH:
        return 'Fintech';
      default:
        return type.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              Icons.account_balance,
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
                  _isEditing ? 'Edit Organization' : 'New Organization',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _isEditing
                      ? 'Update the organization details below.'
                      : 'Set up a new lending organization in the system.',
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
        width: 480,
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
                  label: 'Organization Name',
                  description:
                      'The official registered name of the lending organization.',
                  isRequired: true,
                  child: TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Stawi Microfinance Ltd',
                      prefixIcon: Icon(Icons.business),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Organization name is required'
                        : null,
                  ),
                ),
                FormFieldCard(
                  label: 'Short Code',
                  description:
                      'A unique alphanumeric identifier used in reports, '
                      'transaction references, and system integrations.',
                  isRequired: true,
                  child: TextFormField(
                    controller: _codeCtrl,
                    decoration: const InputDecoration(
                      hintText: 'e.g. STAWI',
                      prefixIcon: Icon(Icons.tag),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Code is required'
                        : null,
                  ),
                ),
                FormFieldCard(
                  label: 'Organization Type',
                  description:
                      'The regulatory category of this organization. '
                      'This determines applicable compliance rules and reporting requirements.',
                  child: DropdownButtonFormField<OrganizationType>(
                    initialValue: _orgType,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: _orgTypes
                        .map(
                          (t) => DropdownMenuItem(
                            value: t,
                            child: Text(_orgTypeLabel(t)),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => _orgType = v);
                      }
                    },
                  ),
                ),
                FormFieldCard(
                  label: 'Status',
                  description:
                      'The lifecycle state of the organization. '
                      'New organizations start as "Created" and must be activated before operations can begin.',
                  isRequired: true,
                  child: DropdownButtonFormField<STATE>(
                    initialValue: _selectedState,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.flag_outlined),
                    ),
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
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _saving ? null : _submit,
          icon: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Icon(_isEditing ? Icons.save : Icons.add),
          label: Text(
            _isEditing ? 'Update Organization' : 'Create Organization',
          ),
        ),
      ],
    );
  }
}
