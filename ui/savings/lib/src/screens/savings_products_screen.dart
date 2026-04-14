import 'dart:async';

import 'package:antinvestor_api_savings/antinvestor_api_savings.dart'
    hide PageCursor, STATE;
import 'package:antinvestor_ui_core/antinvestor_ui_core.dart';

import '../utils/money_bridge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/savings_providers.dart';

class SavingsProductsScreen extends ConsumerStatefulWidget {
  const SavingsProductsScreen({super.key});

  @override
  ConsumerState<SavingsProductsScreen> createState() =>
      _SavingsProductsScreenState();
}

class _SavingsProductsScreenState
    extends ConsumerState<SavingsProductsScreen> {
  String _query = '';

  void _onSearch(String value) {
    setState(() => _query = value.trim());
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(savingsProductListProvider(_query));
    final products = productsAsync.whenOrNull(data: (d) => d) ?? [];

    return AdminEntityListPage<SavingsProductObject>(
      title: 'Savings Products',
      breadcrumbs: const ['Savings', 'Products'],
      columns: const [
        DataColumn(label: Text('NAME')),
        DataColumn(label: Text('DESCRIPTION')),
        DataColumn(label: Text('STATE')),
      ],
      items: products,
      onSearch: _onSearch,
      addLabel: 'New Product',
      onAdd: () => _showCreateDialog(context),
      rowBuilder: (product, selected, onSelect) {
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
                  Text(product.name.isNotEmpty
                      ? product.name
                      : 'Product ${product.id}'),
                ],
              ),
            ),
            DataCell(Text(
              product.description.isNotEmpty
                  ? product.description
                  : 'No description',
              overflow: TextOverflow.ellipsis,
            )),
            DataCell(Text(bridgeState(product.state).name)),
          ],
        );
      },
      detailBuilder: (product) => _SavingsProductDetail(product: product),
      exportRow: (product) => [
        product.name,
        product.description,
        bridgeState(product.state).name,
        product.id,
      ],
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _SavingsProductCreateDialog(
        onSave: (product) async {
          await ref.read(savingsProductNotifierProvider.notifier).save(product);
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
// Product Detail
// ---------------------------------------------------------------------------

class _SavingsProductDetail extends StatelessWidget {
  const _SavingsProductDetail({required this.product});
  final SavingsProductObject product;

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
                  Text(
                    product.name.isNotEmpty
                        ? product.name
                        : 'Product ${product.id}',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(product.id,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontFamily: 'monospace')),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _DetailRow(
            label: 'Description',
            value: product.description.isNotEmpty
                ? product.description
                : 'No description'),
        _DetailRow(label: 'State', value: bridgeState(product.state).name),
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
