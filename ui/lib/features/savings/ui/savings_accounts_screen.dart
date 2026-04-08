import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_chip.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/form_field_card.dart';
import '../../../sdk/src/savings/v1/savings.pb.dart';
import '../../auth/data/auth_repository.dart';
import '../../organization/data/organization_providers.dart';
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
    showDialog<void>(
      context: context,
      builder: (ctx) => _SavingsAccountCreateDialog(
        onSave: (account) async {
          try {
            await ref
                .read(savingsAccountProvider.notifier)
                .create(account);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Savings account created')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed: $e')),
              );
            }
            rethrow;
          }
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Savings Account create dialog
// ---------------------------------------------------------------------------

class _SavingsAccountCreateDialog extends ConsumerStatefulWidget {
  const _SavingsAccountCreateDialog({required this.onSave});

  final Future<void> Function(SavingsAccountObject account) onSave;

  @override
  ConsumerState<_SavingsAccountCreateDialog> createState() =>
      _SavingsAccountCreateDialogState();
}

class _SavingsAccountCreateDialogState
    extends ConsumerState<_SavingsAccountCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _clientIdCtrl;
  late final TextEditingController _productIdCtrl;
  late final TextEditingController _currencyCodeCtrl;
  String? _selectedOrganizationId;
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

    final tenantId = ref.read(currentTenantIdProvider).value;

    final account = SavingsAccountObject(
      ownerId: _clientIdCtrl.text.trim(),
      productId: _productIdCtrl.text.trim(),
      ownerType: _ownerType,
      currencyCode: _currencyCodeCtrl.text.trim().toUpperCase(),
    );

    if (_selectedOrganizationId != null &&
        _selectedOrganizationId!.isNotEmpty) {
      account.organizationId = _selectedOrganizationId!;
    } else if (tenantId != null && tenantId.isNotEmpty) {
      account.organizationId = tenantId;
    }

    try {
      await widget.onSave(account);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final organizationsAsync = ref.watch(organizationListProvider(''));

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
                  label: 'Organization',
                  description:
                      'The organization this savings account belongs to',
                  isRequired: true,
                  child: organizationsAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) =>
                        Text('Failed to load organizations: $e'),
                    data: (organizations) =>
                        DropdownButtonFormField<String>(
                      initialValue: _selectedOrganizationId != null &&
                              organizations.any(
                                  (o) => o.id == _selectedOrganizationId)
                          ? _selectedOrganizationId
                          : null,
                      decoration: const InputDecoration(
                        hintText: 'Select an organization',
                      ),
                      items: [
                        for (final org in organizations)
                          DropdownMenuItem(
                            value: org.id,
                            child: Text(
                                org.name.isNotEmpty ? org.name : org.id),
                          ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Organization is required';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(
                            () => _selectedOrganizationId = value);
                      },
                    ),
                  ),
                ),
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
                        .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(_ownerTypeLabel(t)),
                            ))
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
                  description:
                      'ISO 4217 currency code for this account',
                  isRequired: true,
                  child: TextFormField(
                    controller: _currencyCodeCtrl,
                    decoration: const InputDecoration(
                      hintText: 'e.g. KES',
                    ),
                    textInputAction: TextInputAction.done,
                    validator: (v) =>
                        (v == null || v.trim().length != 3)
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
