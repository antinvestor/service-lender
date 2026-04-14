import 'dart:async';

import 'package:antinvestor_api_savings/antinvestor_api_savings.dart'
    hide PageCursor, STATE;
import 'package:antinvestor_ui_core/antinvestor_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/savings_providers.dart';

class SavingsAccountsScreen extends ConsumerStatefulWidget {
  const SavingsAccountsScreen({super.key});

  @override
  ConsumerState<SavingsAccountsScreen> createState() =>
      _SavingsAccountsScreenState();
}

class _SavingsAccountsScreenState extends ConsumerState<SavingsAccountsScreen> {
  String _query = '';

  void _onSearch(String value) {
    setState(() => _query = value.trim());
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(
      savingsAccountListProvider((query: _query, ownerId: '')),
    );
    final accounts = accountsAsync.whenOrNull(data: (d) => d) ?? [];

    return AdminEntityListPage<SavingsAccountObject>(
      title: 'Savings Accounts',
      breadcrumbs: const ['Savings', 'Accounts'],
      columns: const [
        DataColumn(label: Text('ACCOUNT ID')),
        DataColumn(label: Text('OWNER')),
        DataColumn(label: Text('CURRENCY')),
        DataColumn(label: Text('STATUS')),
      ],
      items: accounts,
      onSearch: _onSearch,
      addLabel: 'New Account',
      onAdd: () => _showCreateDialog(context),
      rowBuilder: (account, selected, onSelect) {
        final (statusLabel, _) = _statusInfo(account.status);
        return DataRow(
          selected: selected,
          onSelectChanged: (_) => onSelect(),
          cells: [
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    child: Icon(Icons.savings,
                        size: 14,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    account.id.length > 16
                        ? '${account.id.substring(0, 16)}...'
                        : account.id,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
            DataCell(Text(account.ownerId)),
            DataCell(Text(account.currencyCode)),
            DataCell(Text(statusLabel)),
          ],
        );
      },
      onRowNavigate: (account) {
        context.go('/savings/${account.id}');
      },
      detailBuilder: (account) => _SavingsAccountDetail(account: account),
      exportRow: (account) => [
        account.id,
        account.ownerId,
        account.currencyCode,
        _statusInfo(account.status).$1,
      ],
    );
  }

  static (String, Color) _statusInfo(SavingsAccountStatus status) {
    return switch (status) {
      SavingsAccountStatus.SAVINGS_ACCOUNT_STATUS_ACTIVE => (
        'Active',
        Colors.green,
      ),
      SavingsAccountStatus.SAVINGS_ACCOUNT_STATUS_FROZEN => (
        'Frozen',
        Colors.blue,
      ),
      SavingsAccountStatus.SAVINGS_ACCOUNT_STATUS_CLOSED => (
        'Closed',
        Colors.grey,
      ),
      _ => ('Unknown', Colors.grey),
    };
  }

  void _showCreateDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _SavingsAccountCreateDialog(
        onSave: (account) async {
          try {
            await ref
                .read(savingsAccountNotifierProvider.notifier)
                .create(account);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Savings account created')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Failed: $e')));
            }
            rethrow;
          }
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Savings Account Detail
// ---------------------------------------------------------------------------

class _SavingsAccountDetail extends StatelessWidget {
  const _SavingsAccountDetail({required this.account});
  final SavingsAccountObject account;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: theme.colorScheme.secondaryContainer,
              child:
                  Icon(Icons.savings, color: theme.colorScheme.secondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Account',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  Text(account.id,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontFamily: 'monospace')),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _DetailRow(label: 'Owner', value: account.ownerId),
        _DetailRow(label: 'Currency', value: account.currencyCode),
        _DetailRow(
            label: 'Status',
            value: _SavingsAccountsScreenState._statusInfo(account.status).$1),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ),
          Expanded(
            child: Text(value,
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Savings Account create dialog
// ---------------------------------------------------------------------------

class _SavingsAccountCreateDialog extends StatefulWidget {
  const _SavingsAccountCreateDialog({required this.onSave});

  final Future<void> Function(SavingsAccountObject account) onSave;

  @override
  State<_SavingsAccountCreateDialog> createState() =>
      _SavingsAccountCreateDialogState();
}

class _SavingsAccountCreateDialogState
    extends State<_SavingsAccountCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _clientIdCtrl;
  late final TextEditingController _productIdCtrl;
  late final TextEditingController _currencyCodeCtrl;
  SavingsAccountOwnerType _ownerType =
      SavingsAccountOwnerType.SAVINGS_ACCOUNT_OWNER_TYPE_INDIVIDUAL;
  bool _saving = false;

  static const _ownerTypes = [
    SavingsAccountOwnerType.SAVINGS_ACCOUNT_OWNER_TYPE_INDIVIDUAL,
    SavingsAccountOwnerType.SAVINGS_ACCOUNT_OWNER_TYPE_GROUP,
  ];

  static String _ownerTypeLabel(SavingsAccountOwnerType type) {
    return switch (type) {
      SavingsAccountOwnerType.SAVINGS_ACCOUNT_OWNER_TYPE_INDIVIDUAL =>
        'Individual',
      SavingsAccountOwnerType.SAVINGS_ACCOUNT_OWNER_TYPE_GROUP => 'Group',
      _ => 'Unspecified',
    };
  }

  @override
  void initState() {
    super.initState();
    _clientIdCtrl = TextEditingController();
    _productIdCtrl = TextEditingController();
    _currencyCodeCtrl = TextEditingController(text: 'KES');
  }

  @override
  void dispose() {
    _clientIdCtrl.dispose();
    _productIdCtrl.dispose();
    _currencyCodeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final account = SavingsAccountObject(
      ownerId: _clientIdCtrl.text.trim(),
      productId: _productIdCtrl.text.trim(),
      ownerType: _ownerType,
      currencyCode: _currencyCodeCtrl.text.trim().toUpperCase(),
    );

    try {
      await widget.onSave(account);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Savings Account'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormFieldCard(
                  label: 'Client ID',
                  description:
                      'The unique identifier of the account owner (client or group)',
                  isRequired: true,
                  child: TextFormField(
                    controller: _clientIdCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Enter the client ID',
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Client ID is required'
                        : null,
                  ),
                ),
                FormFieldCard(
                  label: 'Owner Type',
                  description:
                      'Whether the account is owned by an individual or a group',
                  isRequired: true,
                  child: DropdownButtonFormField<SavingsAccountOwnerType>(
                    initialValue: _ownerType,
                    items: _ownerTypes
                        .map(
                          (t) => DropdownMenuItem(
                            value: t,
                            child: Text(_ownerTypeLabel(t)),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _ownerType = v);
                    },
                  ),
                ),
                FormFieldCard(
                  label: 'Savings Product ID',
                  description:
                      'The savings product that defines the terms for this account',
                  isRequired: true,
                  child: TextFormField(
                    controller: _productIdCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Enter the savings product ID',
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Savings Product ID is required'
                        : null,
                  ),
                ),
                FormFieldCard(
                  label: 'Currency Code',
                  description: 'ISO 4217 currency code for this account',
                  isRequired: true,
                  child: TextFormField(
                    controller: _currencyCodeCtrl,
                    decoration: const InputDecoration(hintText: 'e.g. KES'),
                    textInputAction: TextInputAction.done,
                    validator: (v) => (v == null || v.trim().length != 3)
                        ? 'Enter a 3-letter currency code'
                        : null,
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
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}
