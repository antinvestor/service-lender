import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../data/bank_providers.dart';

class BanksScreen extends ConsumerStatefulWidget {
  const BanksScreen({super.key});

  @override
  ConsumerState<BanksScreen> createState() => _BanksScreenState();
}

class _BanksScreenState extends ConsumerState<BanksScreen> {
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
    final banksAsync = ref.watch(bankListProvider(_query));
    final canManage = ref.watch(canManageBanksProvider).value ?? false;

    return EntityListPage<BankObject>(
      title: 'Banks',
      icon: Icons.account_balance_outlined,
      items: banksAsync.value ?? [],
      isLoading: banksAsync.isLoading,
      error: banksAsync.hasError ? banksAsync.error.toString() : null,
      onRetry: () => ref.invalidate(bankListProvider(_query)),
      searchHint: 'Search banks...',
      onSearchChanged: _onSearchChanged,
      actionLabel: 'Add Bank',
      canAction: canManage,
      onAction: () => _showBankDialog(context),
      itemBuilder: (context, bank) => _BankCard(
        bank: bank,
        onTap: () => context.go('/organization/banks/${bank.id}'),
      ),
    );
  }

  void _showBankDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => BankFormDialog(
        onSave: (updated) async {
          try {
            await ref.read(bankProvider.notifier).save(updated);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bank created successfully')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to save bank: $e'),
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

class _BankCard extends StatelessWidget {
  const _BankCard({required this.bank, required this.onTap});

  final BankObject bank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
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
          bank.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Code: ${bank.code}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(160),
          ),
        ),
        trailing: StateBadge(state: bank.state),
        onTap: onTap,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bank create / edit dialog (public so bank detail can reuse for editing)
// ---------------------------------------------------------------------------

class BankFormDialog extends StatefulWidget {
  const BankFormDialog({super.key, this.bank, required this.onSave});

  final BankObject? bank;
  final Future<void> Function(BankObject bank) onSave;

  @override
  State<BankFormDialog> createState() => _BankFormDialogState();
}

class _BankFormDialogState extends State<BankFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _codeCtrl;
  late STATE _selectedState;
  bool _saving = false;

  bool get _isEditing => widget.bank != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.bank?.name ?? '');
    _codeCtrl = TextEditingController(text: widget.bank?.code ?? '');
    _selectedState = widget.bank?.state ?? STATE.CREATED;
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

    final bank = BankObject(
      id: widget.bank?.id,
      name: _nameCtrl.text.trim(),
      code: _codeCtrl.text.trim(),
      state: _selectedState,
    );

    // Preserve backend-managed fields when editing.
    if (widget.bank != null) {
      if (widget.bank!.hasPartitionId()) {
        bank.partitionId = widget.bank!.partitionId;
      }
      if (widget.bank!.hasProfileId()) {
        bank.profileId = widget.bank!.profileId;
      }
      if (widget.bank!.hasProperties()) {
        bank.properties = widget.bank!.properties;
      }
    }

    try {
      await widget.onSave(bank);
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
      title: Text(_isEditing ? 'Edit Bank' : 'Add Bank'),
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
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(labelText: 'Code'),
                textInputAction: TextInputAction.done,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Code is required' : null,
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
