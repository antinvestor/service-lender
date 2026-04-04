import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/application_status_badge.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/money_helpers.dart';
import '../../../core/widgets/resolved_name.dart';
import '../../../sdk/src/origination/v1/origination.pb.dart';
import '../data/application_providers.dart';

class ApplicationsScreen extends ConsumerStatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  ConsumerState<ApplicationsScreen> createState() =>
      _ApplicationsScreenState();
}

class _ApplicationsScreenState extends ConsumerState<ApplicationsScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';
  String _statusFilter = '';

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

  Widget _buildStatusFilter() {
    return DropdownButton<String>(
      value: _statusFilter,
      hint: const Text('All Statuses'),
      underline: const SizedBox.shrink(),
      items: [
        const DropdownMenuItem(value: '', child: Text('All Statuses')),
        ...ApplicationStatus.values
            .where((s) =>
                s != ApplicationStatus.APPLICATION_STATUS_UNSPECIFIED)
            .map(
              (s) => DropdownMenuItem(
                value: s.name,
                child: Text(applicationStatusLabel(s)),
              ),
            ),
      ],
      onChanged: (value) {
        setState(() {
          _statusFilter = value ?? '';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appsAsync = ref.watch(
        applicationListProvider(_query, statusFilter: _statusFilter));
    final canCreate = ref.watch(canManageAgentsProvider).value ?? false;

    final items = appsAsync.value ?? [];
    return EntityListPage<ApplicationObject>(
      title: 'Loan Applications',
      icon: Icons.description_outlined,
      items: items,
      isLoading: appsAsync.isLoading,
      hasMore: items.length >= kDefaultPagedResultLimit,
      error: appsAsync.hasError ? appsAsync.error.toString() : null,
      onRetry: () => ref.invalidate(
          applicationListProvider(_query, statusFilter: _statusFilter)),
      searchHint: 'Search applications...',
      onSearchChanged: _onSearchChanged,
      actionLabel: 'New Application',
      canAction: canCreate,
      onAction: () => _showCreateDialog(context),
      filterWidget: _buildStatusFilter(),
      itemBuilder: (context, app) => _ApplicationCard(
        app: app,
        onTap: () => context.go('/origination/applications/${app.id}'),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => ApplicationCreateDialog(
        onSave: (app) async {
          try {
            await ref.read(applicationProvider.notifier).save(app);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Application created successfully')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to create application: $e'),
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

class _ApplicationCard extends ConsumerWidget {
  const _ApplicationCard({required this.app, required this.onTap});

  final ApplicationObject app;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

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
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.description,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        title: ClientNameText(
          clientId: app.clientId,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Row(
          children: [
            ProductNameText(
              productId: app.productId,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              ' \u2022 ${formatMoney(app.requestedAmount)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        trailing: ApplicationStatusBadge(status: app.status),
        onTap: onTap,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Application create dialog
// ---------------------------------------------------------------------------

class ApplicationCreateDialog extends StatefulWidget {
  const ApplicationCreateDialog({super.key, required this.onSave});

  final Future<void> Function(ApplicationObject app) onSave;

  @override
  State<ApplicationCreateDialog> createState() =>
      _ApplicationCreateDialogState();
}

class _ApplicationCreateDialogState extends State<ApplicationCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _productIdCtrl;
  late final TextEditingController _clientIdCtrl;
  late final TextEditingController _agentIdCtrl;
  late final TextEditingController _branchIdCtrl;
  late final TextEditingController _bankIdCtrl;
  late final TextEditingController _amountCtrl;
  late final TextEditingController _termCtrl;
  late final TextEditingController _currencyCtrl;
  late final TextEditingController _purposeCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _productIdCtrl = TextEditingController();
    _clientIdCtrl = TextEditingController();
    _agentIdCtrl = TextEditingController();
    _branchIdCtrl = TextEditingController();
    _bankIdCtrl = TextEditingController();
    _amountCtrl = TextEditingController();
    _termCtrl = TextEditingController();
    _currencyCtrl = TextEditingController();
    _purposeCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _productIdCtrl.dispose();
    _clientIdCtrl.dispose();
    _agentIdCtrl.dispose();
    _branchIdCtrl.dispose();
    _bankIdCtrl.dispose();
    _amountCtrl.dispose();
    _termCtrl.dispose();
    _currencyCtrl.dispose();
    _purposeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final app = ApplicationObject(
      productId: _productIdCtrl.text.trim(),
      clientId: _clientIdCtrl.text.trim(),
      agentId: _agentIdCtrl.text.trim(),
      branchId: _branchIdCtrl.text.trim(),
      bankId: _bankIdCtrl.text.trim(),
      requestedAmount: moneyFromString(
          _amountCtrl.text.trim(), _currencyCtrl.text.trim().toUpperCase()),
      requestedTermDays: int.tryParse(_termCtrl.text.trim()) ?? 0,
      purpose: _purposeCtrl.text.trim(),
      status: ApplicationStatus.APPLICATION_STATUS_DRAFT,
    );

    try {
      await widget.onSave(app);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Application'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _productIdCtrl,
                  decoration: const InputDecoration(labelText: 'Product ID'),
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Product ID is required'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _clientIdCtrl,
                  decoration: const InputDecoration(labelText: 'Client ID'),
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Client ID is required'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _agentIdCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Agent ID (optional)'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _branchIdCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Branch ID (optional)'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bankIdCtrl,
                  decoration: const InputDecoration(labelText: 'Bank ID'),
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Bank ID is required'
                      : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _amountCtrl,
                        decoration: const InputDecoration(
                            labelText: 'Requested Amount'),
                        textInputAction: TextInputAction.next,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: validateAmount,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _currencyCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Currency Code'),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.characters,
                        validator: validateCurrency,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _termCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Requested Term (days)'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v != null && v.trim().isNotEmpty) {
                      final days = int.tryParse(v.trim());
                      if (days == null || days <= 0) {
                        return 'Enter a positive number of days';
                      }
                      if (days > 36500) return 'Term exceeds 100 years';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _purposeCtrl,
                  decoration: const InputDecoration(labelText: 'Purpose'),
                  textInputAction: TextInputAction.done,
                  maxLines: 2,
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
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}
