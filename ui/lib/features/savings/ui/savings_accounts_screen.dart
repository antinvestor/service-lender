import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_chip.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../sdk/src/savings/v1/savings.pb.dart';
import '../data/savings_providers.dart';

class SavingsAccountsScreen extends ConsumerStatefulWidget {
  const SavingsAccountsScreen({super.key});

  @override
  ConsumerState<SavingsAccountsScreen> createState() =>
      _SavingsAccountsScreenState();
}

class _SavingsAccountsScreenState
    extends ConsumerState<SavingsAccountsScreen> {
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync =
        ref.watch(savingsAccountListProvider(query: _query));
    final canManage = ref.watch(canManageLoansProvider).value ?? false;

    final items = accountsAsync.value ?? [];
    return EntityListPage<SavingsAccountObject>(
      title: 'Savings Accounts',
      icon: Icons.savings_outlined,
      items: items,
      isLoading: accountsAsync.isLoading,
      error: accountsAsync.hasError ? accountsAsync.error.toString() : null,
      onRetry: () =>
          ref.invalidate(savingsAccountListProvider(query: _query)),
      searchHint: 'Search savings accounts...',
      onSearchChanged: _onSearchChanged,
      actionLabel: 'New Account',
      canAction: canManage,
      onAction: () => _showCreateDialog(context),
      itemBuilder: (context, account) => _SavingsAccountCard(
        account: account,
        onTap: () => context.go('/savings/${account.id}'),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final clientIdCtrl = TextEditingController();
    final productIdCtrl = TextEditingController();
    var saving = false;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Create Savings Account'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: clientIdCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Client ID'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: productIdCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Savings Product ID'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      setDialogState(() => saving = true);
                      try {
                        await ref
                            .read(savingsAccountProvider.notifier)
                            .create(SavingsAccountObject(
                              ownerId: clientIdCtrl.text.trim(),
                              productId: productIdCtrl.text.trim(),
                            ));
                        if (ctx.mounted) Navigator.of(ctx).pop();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Savings account created')),
                          );
                        }
                      } catch (e) {
                        setDialogState(() => saving = false);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed: $e')),
                          );
                        }
                      }
                    },
              child: saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child:
                          CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavingsAccountCard extends StatelessWidget {
  const _SavingsAccountCard({
    required this.account,
    required this.onTap,
  });

  final SavingsAccountObject account;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (statusLabel, statusColor) = switch (account.status) {
      SavingsAccountStatus.SAVINGS_ACCOUNT_STATUS_ACTIVE =>
        ('Active', Colors.green),
      SavingsAccountStatus.SAVINGS_ACCOUNT_STATUS_FROZEN =>
        ('Frozen', Colors.blue),
      SavingsAccountStatus.SAVINGS_ACCOUNT_STATUS_CLOSED =>
        ('Closed', Colors.grey),
      _ => ('Unknown', Colors.grey),
    };

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        leading: CircleAvatar(
          backgroundColor: statusColor.withAlpha(20),
          child: Icon(Icons.savings, color: statusColor, size: 20),
        ),
        title: Text(
          account.id.length > 16
              ? '${account.id.substring(0, 16)}...'
              : account.id,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            fontFamily: 'monospace',
          ),
        ),
        subtitle: Row(
          children: [
            EntityChip(
                type: EntityType.client, id: account.ownerId),
            const SizedBox(width: 8),
            Text(
              account.currencyCode,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: statusColor.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            statusLabel,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
