import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/lender/v1/identity.pb.dart';
import '../data/bank_providers.dart';
import '../data/branch_providers.dart';
import 'banks_screen.dart';

class BankDetailScreen extends ConsumerWidget {
  const BankDetailScreen({super.key, required this.bankId});

  final String bankId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canManage = ref.watch(canManageBanksProvider).value ?? false;

    return FutureBuilder<BankObject>(
      future: _loadBank(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final bank = snapshot.data;
        if (bank == null) {
          return const Center(child: Text('Bank not found'));
        }
        return _BankDetailContent(
          bank: bank,
          canManage: canManage,
        );
      },
    );
  }

  Future<BankObject> _loadBank(WidgetRef ref) async {
    final client = ref.read(identityServiceClientProvider);
    final response = await client.bankGet(BankGetRequest(id: bankId));
    return response.data;
  }
}

class _BankDetailContent extends ConsumerStatefulWidget {
  const _BankDetailContent({
    required this.bank,
    required this.canManage,
  });

  final BankObject bank;
  final bool canManage;

  @override
  ConsumerState<_BankDetailContent> createState() =>
      _BankDetailContentState();
}

class _BankDetailContentState extends ConsumerState<_BankDetailContent> {
  late BankObject _bank;

  @override
  void initState() {
    super.initState();
    _bank = widget.bank;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final branchesAsync =
        ref.watch(branchListProvider('', _bank.id));

    return CustomScrollView(
      slivers: [
        // Back + title
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/organization/banks'),
                  tooltip: 'Back to Banks',
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _bank.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Code: ${_bank.code}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(140),
                        ),
                      ),
                    ],
                  ),
                ),
                StateBadge(state: _bank.state),
                if (widget.canManage) ...[
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Edit Bank',
                    onPressed: () => _editBank(context),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Branches section header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Row(
              children: [
                Icon(Icons.store_outlined,
                    size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Branches',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (widget.canManage)
                  FilledButton.icon(
                    onPressed: () => _showBranchDialog(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Branch'),
                  ),
              ],
            ),
          ),
        ),

        // Branches list
        branchesAsync.when(
          loading: () => const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          error: (error, _) => SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Text('Failed to load branches: $error'),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      onPressed: () => ref.invalidate(
                          branchListProvider('', _bank.id)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          data: (branches) {
            if (branches.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48),
                    child: Column(
                      children: [
                        Icon(
                          Icons.store_outlined,
                          size: 48,
                          color: theme.colorScheme.onSurface.withAlpha(80),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No branches yet',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(140),
                          ),
                        ),
                        if (widget.canManage) ...[
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: () => _showBranchDialog(context),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Add Branch'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }

            return SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final branch = branches[index];
                    return _BranchCard(
                      branch: branch,
                      onTap: widget.canManage
                          ? () =>
                              _showBranchDialog(context, branch: branch)
                          : null,
                    );
                  },
                  childCount: branches.length,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _editBank(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => BankFormDialog(
        bank: _bank,
        onSave: (updated) async {
          final saved = await ref.read(bankProvider.notifier).save(updated);
          if (!mounted) return;
          setState(() => _bank = saved);
          ScaffoldMessenger.of(this.context).showSnackBar(
            const SnackBar(content: Text('Bank updated successfully')),
          );
        },
      ),
    );
  }

  Future<void> _showBranchDialog(
    BuildContext context, {
    BranchObject? branch,
  }) async {
    final result = await showDialog<BranchObject>(
      context: context,
      builder: (context) =>
          _BranchFormDialog(branch: branch, bankId: _bank.id),
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

// ---------------------------------------------------------------------------
// Branch card
// ---------------------------------------------------------------------------

class _BranchCard extends StatelessWidget {
  const _BranchCard({required this.branch, this.onTap});

  final BranchObject branch;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 2),
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
                        if (branch.code.isNotEmpty)
                          Text(
                            branch.code,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withAlpha(160),
                            ),
                          ),
                        if (branch.geoId.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.location_on_outlined,
                              size: 12,
                              color: theme.colorScheme.onSurface
                                  .withAlpha(120)),
                          const SizedBox(width: 4),
                          Text(
                            branch.geoId,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withAlpha(140),
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

// ---------------------------------------------------------------------------
// Branch create / edit dialog (bank is pre-set, not selectable)
// ---------------------------------------------------------------------------

class _BranchFormDialog extends StatefulWidget {
  const _BranchFormDialog({this.branch, required this.bankId});

  final BranchObject? branch;
  final String bankId;

  @override
  State<_BranchFormDialog> createState() => _BranchFormDialogState();
}

class _BranchFormDialogState extends State<_BranchFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _geoIdController;
  late STATE _selectedState;

  @override
  void initState() {
    super.initState();
    final branch = widget.branch;
    _nameController = TextEditingController(text: branch?.name ?? '');
    _codeController = TextEditingController(text: branch?.code ?? '');
    _geoIdController = TextEditingController(text: branch?.geoId ?? '');
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
    return AlertDialog(
      title: Text(isEditing ? 'Edit Branch' : 'Add Branch'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
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
              TextFormField(
                controller: _geoIdController,
                decoration:
                    const InputDecoration(labelText: 'Geo ID (optional)'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<STATE>(
                initialValue: _selectedState,
                decoration: const InputDecoration(labelText: 'State'),
                items: const [
                  STATE.CREATED,
                  STATE.CHECKED,
                  STATE.ACTIVE,
                  STATE.INACTIVE,
                  STATE.DELETED,
                ]
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(stateLabel(s)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedState = value);
                  }
                },
              ),
            ],
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
      bankId: widget.bankId,
      name: _nameController.text.trim(),
      code: _codeController.text.trim(),
      geoId: _geoIdController.text.trim(),
      state: _selectedState,
    );

    // Preserve backend-managed fields when editing.
    if (widget.branch != null) {
      if (widget.branch!.hasPartitionId()) {
        branch.partitionId = widget.branch!.partitionId;
      }
      if (widget.branch!.hasProperties()) {
        branch.properties = widget.branch!.properties;
      }
    }

    Navigator.of(context).pop(branch);
  }
}
