import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/dynamic_form.dart' show mapToStruct, structToMap;
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/form_field_card.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../auth/data/auth_repository.dart';
import '../data/organization_providers.dart';
import '../data/branch_providers.dart';

class BranchesScreen extends ConsumerStatefulWidget {
  const BranchesScreen({super.key});

  @override
  ConsumerState<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends ConsumerState<BranchesScreen> {
  String _searchQuery = '';
  String _selectedOrganizationId = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _searchQuery = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final branchesAsync = ref.watch(
      branchListProvider(_searchQuery, _selectedOrganizationId),
    );
    final canManage = ref.watch(canManageOrganizationsProvider);
    final organizationsAsync = ref.watch(organizationListProvider(''));

    final organizations = organizationsAsync.value ?? <OrganizationObject>[];
    final organizationMap = {for (final b in organizations) b.id: b};

    return EntityListPage<BranchObject>(
      title: 'Branches',
      icon: Icons.store_outlined,
      items: branchesAsync.value ?? [],
      isLoading: branchesAsync.isLoading,
      error: branchesAsync.hasError ? branchesAsync.error.toString() : null,
      onRetry: () => ref.invalidate(
        branchListProvider(_searchQuery, _selectedOrganizationId),
      ),
      searchHint: 'Search branches...',
      onSearchChanged: _onSearchChanged,
      actionLabel: 'Add Branch',
      canAction: canManage.value ?? false,
      onAction: () => _showBranchDialog(context, organizations: organizations),
      filterWidget: _buildOrganizationFilter(organizations),
      itemBuilder: (context, branch) {
        final organization = organizationMap[branch.organizationId];
        return _BranchCard(
          branch: branch,
          organizationName: organization?.name,
          onTap: (canManage.value ?? false)
              ? () => _showBranchDialog(
                  context,
                  branch: branch,
                  organizations: organizations,
                )
              : null,
        );
      },
    );
  }

  Widget _buildOrganizationFilter(List<OrganizationObject> organizations) {
    return DropdownButton<String>(
      value: _selectedOrganizationId,
      hint: const Text('All Organizations'),
      underline: const SizedBox.shrink(),
      items: [
        const DropdownMenuItem(value: '', child: Text('All Organizations')),
        ...organizations.map(
          (b) => DropdownMenuItem(value: b.id, child: Text(b.name)),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _selectedOrganizationId = value ?? '';
        });
      },
    );
  }

  Future<void> _showBranchDialog(
    BuildContext context, {
    BranchObject? branch,
    required List<OrganizationObject> organizations,
  }) async {
    final result = await showDialog<BranchObject>(
      context: context,
      builder: (context) =>
          _BranchFormDialog(branch: branch, organizations: organizations),
    );
    if (result == null || !mounted) return;

    try {
      final profileId = await ref.read(currentProfileIdProvider.future) ?? '';
      final props = result.hasProperties() ? structToMap(result.properties) : <String, dynamic>{};
      props['case_actor_id'] = profileId;
      result.properties = mapToStruct(props);
      await ref.read(branchProvider.notifier).save(result);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            branch == null
                ? 'Branch created successfully'
                : 'Branch updated successfully',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save branch: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

class _BranchCard extends StatelessWidget {
  const _BranchCard({required this.branch, this.organizationName, this.onTap});

  final BranchObject branch;
  final String? organizationName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final caseFields = branch.hasProperties() ? branch.properties.fields : null;
    final caseStatus = _stringValue(caseFields, 'approval_case_status');
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withAlpha(80),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.store_outlined,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (branch.code.isNotEmpty) ...[
                          Text(
                            branch.code,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(160),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (organizationName != null &&
                            organizationName!.isNotEmpty) ...[
                          Icon(
                            Icons.account_balance_outlined,
                            size: 12,
                            color: theme.colorScheme.onSurface.withAlpha(120),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            organizationName!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(140),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (branch.geoId.isNotEmpty) ...[
                          Icon(
                            Icons.location_on_outlined,
                            size: 12,
                            color: theme.colorScheme.onSurface.withAlpha(120),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            branch.geoId,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(140),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (caseStatus.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withAlpha(
                            90,
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Case: ${caseStatus.replaceAll('_', ' ')}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              StateBadge(state: branch.state),
            ],
          ),
        ),
      ),
    );
  }
}

String _stringValue(Map<String, dynamic>? props, String key) {
  final value = props?[key];
  if (value == null) return '';
  if (value.hasStringValue()) return value.stringValue;
  if (value.hasNumberValue()) return value.numberValue.toString();
  if (value.hasBoolValue()) return value.boolValue.toString();
  return '';
}

class _BranchFormDialog extends StatefulWidget {
  const _BranchFormDialog({this.branch, required this.organizations});

  final BranchObject? branch;
  final List<OrganizationObject> organizations;

  @override
  State<_BranchFormDialog> createState() => _BranchFormDialogState();
}

class _BranchFormDialogState extends State<_BranchFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _geoIdController;
  late String _selectedOrganizationId;
  late STATE _selectedState;

  @override
  void initState() {
    super.initState();
    final branch = widget.branch;
    _nameController = TextEditingController(text: branch?.name ?? '');
    _codeController = TextEditingController(text: branch?.code ?? '');
    _geoIdController = TextEditingController(text: branch?.geoId ?? '');
    _selectedOrganizationId = branch?.organizationId ?? '';
    _selectedState = branch?.state ?? STATE.CREATED;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _geoIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.branch != null;
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
              Icons.store_outlined,
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
                  isEditing ? 'Edit Branch' : 'New Branch',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  isEditing
                      ? 'Update the branch details below.'
                      : 'Add a new branch office or location.',
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
                  label: 'Branch Name',
                  description:
                      'The display name for this branch office or location.',
                  isRequired: true,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Westlands Branch',
                      prefixIcon: Icon(Icons.business),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Name is required' : null,
                  ),
                ),
                FormFieldCard(
                  label: 'Code',
                  description:
                      'A unique short identifier for reports and system references.',
                  isRequired: true,
                  child: TextFormField(
                    controller: _codeController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. WL001',
                      prefixIcon: Icon(Icons.tag),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Code is required' : null,
                  ),
                ),
                FormFieldCard(
                  label: 'Organization',
                  description:
                      'The parent organization this branch belongs to.',
                  isRequired: true,
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedOrganizationId.isEmpty
                        ? null
                        : _selectedOrganizationId,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.account_balance_outlined),
                    ),
                    items: widget.organizations
                        .map(
                          (b) => DropdownMenuItem(
                            value: b.id,
                            child: Text(b.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedOrganizationId = value ?? '';
                      });
                    },
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Organization is required'
                        : null,
                  ),
                ),
                FormFieldCard(
                  label: 'Geographic ID',
                  description:
                      'Optional geographic identifier for mapping and location services.',
                  child: TextFormField(
                    controller: _geoIdController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. KE-NBI-WEST',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                FormFieldCard(
                  label: 'State',
                  description: 'The operational status of this branch.',
                  isRequired: true,
                  child: DropdownButtonFormField<STATE>(
                    initialValue: _selectedState,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.toggle_on_outlined),
                    ),
                    items: STATE.values
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(stateLabel(s)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedState = value;
                        });
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
          child: Text(isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final branch = BranchObject(
      id: widget.branch?.id ?? '',
      organizationId: _selectedOrganizationId,
      name: _nameController.text.trim(),
      code: _codeController.text.trim(),
      geoId: _geoIdController.text.trim(),
      state: _selectedState,
    );

    // Preserve properties when editing.
    if (widget.branch != null && widget.branch!.hasProperties()) {
      branch.properties = widget.branch!.properties;
    }

    Navigator.of(context).pop(branch);
  }
}
