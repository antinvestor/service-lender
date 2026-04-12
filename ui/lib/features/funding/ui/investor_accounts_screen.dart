import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/form_field_card.dart';
import '../../../core/widgets/money_helpers.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/funding/v1/funding.pb.dart';
import '../data/funding_providers.dart';

class InvestorAccountsScreen extends ConsumerStatefulWidget {
  const InvestorAccountsScreen({super.key});

  @override
  ConsumerState<InvestorAccountsScreen> createState() =>
      _InvestorAccountsScreenState();
}

class _InvestorAccountsScreenState
    extends ConsumerState<InvestorAccountsScreen> {
  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(investorAccountListProvider());
    final items = accountsAsync.value ?? [];

    return EntityListPage<InvestorAccountObject>(
      title: 'Investor Accounts',
      icon: Icons.account_balance_wallet_outlined,
      items: items,
      isLoading: accountsAsync.isLoading,
      error: accountsAsync.hasError ? accountsAsync.error.toString() : null,
      onRetry: () => ref.invalidate(investorAccountListProvider()),
      searchHint: 'Search investor accounts...',
      onSearchChanged: (_) {},
      actionLabel: 'New Account',
      canAction: true,
      onAction: () => _showCreateDialog(context),
      itemBuilder: (context, account) => _InvestorAccountCard(
        account: account,
        onTap: () => context.go('/funding/accounts/${account.id}'),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _InvestorAccountCreateDialog(
        onSave: (account) async {
          await ref
              .read(investorAccountProvider.notifier)
              .save(account);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Investor account created')),
            );
          }
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Account Card
// ---------------------------------------------------------------------------

class _InvestorAccountCard extends StatelessWidget {
  const _InvestorAccountCard({required this.account, required this.onTap});

  final InvestorAccountObject account;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.account_balance_wallet,
            color: theme.colorScheme.primary,
          ),
        ),
        title: Text(
          account.accountName.isNotEmpty
              ? account.accountName
              : 'Account ${account.id.length > 8 ? account.id.substring(0, 8) : account.id}',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (account.hasAvailableBalance())
              Text(
                'Available: ${formatMoney(account.availableBalance)}',
                style: theme.textTheme.bodySmall,
              ),
            if (account.hasTotalDeployed())
              Text(
                'Deployed: ${formatMoney(account.totalDeployed)}',
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
        trailing: StateBadge(state: account.state),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Create Dialog
// ---------------------------------------------------------------------------

class _InvestorAccountCreateDialog extends ConsumerStatefulWidget {
  const _InvestorAccountCreateDialog({required this.onSave});

  final Future<void> Function(InvestorAccountObject account) onSave;

  @override
  ConsumerState<_InvestorAccountCreateDialog> createState() =>
      _InvestorAccountCreateDialogState();
}

class _InvestorAccountCreateDialogState
    extends ConsumerState<_InvestorAccountCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _investorIdCtrl = TextEditingController();
  final _minRateCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _investorIdCtrl.dispose();
    _minRateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Investor Account'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormFieldCard(
                label: 'Account Name',
                child: TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Enter account name',
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
              ),
              const SizedBox(height: 12),
              FormFieldCard(
                label: 'Investor ID',
                child: TextFormField(
                  controller: _investorIdCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Enter investor ID',
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
              ),
              const SizedBox(height: 12),
              FormFieldCard(
                label: 'Minimum Interest Rate (%)',
                child: TextFormField(
                  controller: _minRateCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'e.g. 5.0'),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final account = InvestorAccountObject(
        accountName: _nameCtrl.text.trim(),
        investorId: _investorIdCtrl.text.trim(),
        minInterestRate: _minRateCtrl.text.trim(),
      );
      await widget.onSave(account);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
