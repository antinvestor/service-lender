import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
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
      error: branchesAsync.hasError
          ? branchesAsync.error.toString()
          : null,
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
      builder: (context) => _BranchFormDialog(
        branch: branch,
        organizations: organizations,
      ),
    );
    if (result == null || !mounted) return;

    try {
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
  const _BranchCard({
    required this.branch,
    this.organizationName,
    this.onTap,
  });

  final BranchObject branch;
  final String? organizationName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                        if (organizationName != null && organizationName!.isNotEmpty) ...[
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

class _BranchFormDialog extends StatefulWidget {
  const _BranchFormDialog({
    this.branch,
    required this.organizations,
  });

  final BranchObject? branch;
  final List<OrganizationObject> organizations;

  @override
  State<_BranchFormDialog> createState() => _BranchFormDialogState();
}

class _BranchFormDialogState extends State<_BranchFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _partitionIdController;
  late final TextEditingController _geoIdController;
  late String _selectedOrganizationId;
  late STATE _selectedState;

  @override
  void initState() {
    super.initState();
    final branch = widget.branch;
    _nameController = TextEditingController(text: branch?.name ?? '');
    _codeController = TextEditingController(text: branch?.code ?? '');
    _partitionIdController = TextEditingController(
      text: branch?.partitionId ?? '',
    );
    _geoIdController = TextEditingController(text: branch?.geoId ?? '');
    _selectedOrganizationId = branch?.organizationId ?? '';
    _selectedState = branch?.state ?? STATE.CREATED;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _partitionIdController.dispose();
    _geoIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.branch != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit Branch' : 'Add Branch'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(labelText: 'Code'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Code is required' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedOrganizationId.isEmpty ? null : _selectedOrganizationId,
                  decoration: const InputDecoration(labelText: 'Organization'),
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
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Organization is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _partitionIdController,
                  decoration: const InputDecoration(labelText: 'Partition ID'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _geoIdController,
                  decoration: const InputDecoration(labelText: 'Geo ID'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<STATE>(
                  initialValue: _selectedState,
                  decoration: const InputDecoration(labelText: 'State'),
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
      partitionId: _partitionIdController.text.trim(),
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
