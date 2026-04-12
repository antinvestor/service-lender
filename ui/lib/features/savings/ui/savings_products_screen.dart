import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/form_field_card.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/savings/v1/savings.pb.dart';
import '../data/savings_providers.dart';

class SavingsProductsScreen extends ConsumerStatefulWidget {
  const SavingsProductsScreen({super.key});

  @override
  ConsumerState<SavingsProductsScreen> createState() =>
      _SavingsProductsScreenState();
}

class _SavingsProductsScreenState
    extends ConsumerState<SavingsProductsScreen> {
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
    final productsAsync = ref.watch(savingsProductListProvider(_query));
    final items = productsAsync.value ?? [];

    return EntityListPage<SavingsProductObject>(
      title: 'Savings Products',
      icon: Icons.inventory_2_outlined,
      items: items,
      isLoading: productsAsync.isLoading,
      error: productsAsync.hasError ? productsAsync.error.toString() : null,
      onRetry: () => ref.invalidate(savingsProductListProvider(_query)),
      searchHint: 'Search savings products...',
      onSearchChanged: _onSearchChanged,
      actionLabel: 'New Product',
      canAction: true,
      onAction: () => _showCreateDialog(context),
      itemBuilder: (context, product) => _SavingsProductCard(product: product),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _SavingsProductCreateDialog(
        onSave: (product) async {
          await ref.read(savingsProductProvider.notifier).save(product);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Savings product created')),
            );
          }
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Product Card
// ---------------------------------------------------------------------------

class _SavingsProductCard extends StatelessWidget {
  const _SavingsProductCard({required this.product});
  final SavingsProductObject product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.secondaryContainer,
          child: Icon(Icons.savings, color: theme.colorScheme.secondary),
        ),
        title: Text(
          product.name.isNotEmpty ? product.name : 'Product ${product.id}',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          product.description.isNotEmpty
              ? product.description
              : 'No description',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall,
        ),
        trailing: StateBadge(state: product.state),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Create Dialog
// ---------------------------------------------------------------------------

class _SavingsProductCreateDialog extends StatefulWidget {
  const _SavingsProductCreateDialog({required this.onSave});
  final Future<void> Function(SavingsProductObject product) onSave;

  @override
  State<_SavingsProductCreateDialog> createState() =>
      _SavingsProductCreateDialogState();
}

class _SavingsProductCreateDialogState
    extends State<_SavingsProductCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Savings Product'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormFieldCard(
                label: 'Product Name',
                child: TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Enter product name',
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
              ),
              const SizedBox(height: 12),
              FormFieldCard(
                label: 'Description',
                child: TextFormField(
                  controller: _descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Product description',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FormFieldCard(
                label: 'Interest Rate (%)',
                child: TextFormField(
                  controller: _rateCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'e.g. 3.5'),
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
      final product = SavingsProductObject(
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        interestRate: _rateCtrl.text.trim(),
      );
      await widget.onSave(product);
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
