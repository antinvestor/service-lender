import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/form_field_card.dart';
import '../../../core/widgets/money_helpers.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/loans/v1/loans.pb.dart';
import '../../organization/data/organization_providers.dart';
import '../data/loan_product_providers.dart';

class LoanProductsScreen extends ConsumerStatefulWidget {
  const LoanProductsScreen({super.key});

  @override
  ConsumerState<LoanProductsScreen> createState() => _LoanProductsScreenState();
}

class _LoanProductsScreenState extends ConsumerState<LoanProductsScreen> {
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
    final productsAsync = ref.watch(loanProductListProvider(_query));
    final canManage = ref.watch(canManageLoanProductsProvider).value ?? false;

    return EntityListPage<LoanProductObject>(
      title: 'Loan Products',
      icon: Icons.inventory_2_outlined,
      items: productsAsync.value ?? [],
      isLoading: productsAsync.isLoading,
      error: productsAsync.hasError ? productsAsync.error.toString() : null,
      onRetry: () => ref.invalidate(loanProductListProvider(_query)),
      searchHint: 'Search loan products...',
      onSearchChanged: _onSearchChanged,
      actionLabel: 'Add Product',
      canAction: canManage,
      onAction: () => _showProductDialog(context),
      itemBuilder: (context, product) => _LoanProductCard(
        product: product,
        onTap: () => context.go('/loans/products/${product.id}'),
      ),
    );
  }

  void _showProductDialog(BuildContext context, {LoanProductObject? product}) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => LoanProductFormDialog(
        product: product,
        onSave: (updated) async {
          try {
            await ref.read(loanProductProvider.notifier).save(updated);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    product == null
                        ? 'Loan product created successfully'
                        : 'Loan product updated successfully',
                  ),
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to save loan product: $e'),
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

class _LoanProductCard extends StatelessWidget {
  const _LoanProductCard({required this.product, required this.onTap});

  final LoanProductObject product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.inventory_2,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          product.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${product.code} \u2022 ${_productTypeLabel(product.productType)} \u2022 ${product.currencyCode} \u2022 ${product.annualInterestRate}%',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(160),
          ),
        ),
        trailing: StateBadge(state: product.state),
        onTap: onTap,
      ),
    );
  }

  static String _productTypeLabel(LoanProductType type) {
    return switch (type) {
      LoanProductType.LOAN_PRODUCT_TYPE_TERM => 'Term',
      LoanProductType.LOAN_PRODUCT_TYPE_REVOLVING => 'Revolving',
      LoanProductType.LOAN_PRODUCT_TYPE_BULLET => 'Bullet',
      LoanProductType.LOAN_PRODUCT_TYPE_GRADUATED => 'Graduated',
      _ => 'Unknown',
    };
  }
}

// ---------------------------------------------------------------------------
// Loan Product create / edit dialog
// ---------------------------------------------------------------------------

class LoanProductFormDialog extends ConsumerStatefulWidget {
  const LoanProductFormDialog({super.key, this.product, required this.onSave});

  final LoanProductObject? product;
  final Future<void> Function(LoanProductObject product) onSave;

  @override
  ConsumerState<LoanProductFormDialog> createState() =>
      _LoanProductFormDialogState();
}

class _LoanProductFormDialogState extends ConsumerState<LoanProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _currencyCtrl;
  late final TextEditingController _minAmountCtrl;
  late final TextEditingController _maxAmountCtrl;
  late final TextEditingController _minTermCtrl;
  late final TextEditingController _maxTermCtrl;
  late final TextEditingController _annualRateCtrl;
  late final TextEditingController _processingFeeCtrl;
  late final TextEditingController _insuranceFeeCtrl;
  late final TextEditingController _latePenaltyCtrl;
  late final TextEditingController _gracePeriodCtrl;
  late LoanProductType _productType;
  late InterestMethod _interestMethod;
  late RepaymentFrequency _repaymentFrequency;
  late STATE _selectedState;
  String? _selectedOrganizationId;
  bool _saving = false;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _codeCtrl = TextEditingController(text: p?.code ?? '');
    _descriptionCtrl = TextEditingController(text: p?.description ?? '');
    _currencyCtrl = TextEditingController(text: p?.currencyCode ?? '');
    _minAmountCtrl = TextEditingController(
      text: p != null ? moneyToAmountString(p.minAmount) : '',
    );
    _maxAmountCtrl = TextEditingController(
      text: p != null ? moneyToAmountString(p.maxAmount) : '',
    );
    _minTermCtrl = TextEditingController(
      text: p != null ? '${p.minTermDays}' : '',
    );
    _maxTermCtrl = TextEditingController(
      text: p != null ? '${p.maxTermDays}' : '',
    );
    _annualRateCtrl = TextEditingController(text: p?.annualInterestRate ?? '');
    _processingFeeCtrl = TextEditingController(
      text: p?.processingFeePercent ?? '',
    );
    _insuranceFeeCtrl = TextEditingController(
      text: p?.insuranceFeePercent ?? '',
    );
    _latePenaltyCtrl = TextEditingController(text: p?.latePenaltyRate ?? '');
    _gracePeriodCtrl = TextEditingController(
      text: p != null ? '${p.gracePeriodDays}' : '',
    );
    _productType = p?.productType ?? LoanProductType.LOAN_PRODUCT_TYPE_TERM;
    _interestMethod = p?.interestMethod ?? InterestMethod.INTEREST_METHOD_FLAT;
    _repaymentFrequency =
        p?.repaymentFrequency ?? RepaymentFrequency.REPAYMENT_FREQUENCY_MONTHLY;
    _selectedState = p?.state ?? STATE.CREATED;
    _selectedOrganizationId = (p != null && p.hasOrganizationId())
        ? p.organizationId
        : null;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _descriptionCtrl.dispose();
    _currencyCtrl.dispose();
    _minAmountCtrl.dispose();
    _maxAmountCtrl.dispose();
    _minTermCtrl.dispose();
    _maxTermCtrl.dispose();
    _annualRateCtrl.dispose();
    _processingFeeCtrl.dispose();
    _insuranceFeeCtrl.dispose();
    _latePenaltyCtrl.dispose();
    _gracePeriodCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final product = LoanProductObject(
      id: widget.product?.id,
      name: _nameCtrl.text.trim(),
      code: _codeCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      productType: _productType,
      currencyCode: _currencyCtrl.text.trim().toUpperCase(),
      interestMethod: _interestMethod,
      repaymentFrequency: _repaymentFrequency,
      minAmount: moneyFromString(
        _minAmountCtrl.text.trim(),
        _currencyCtrl.text.trim().toUpperCase(),
      ),
      maxAmount: moneyFromString(
        _maxAmountCtrl.text.trim(),
        _currencyCtrl.text.trim().toUpperCase(),
      ),
      minTermDays: int.tryParse(_minTermCtrl.text.trim()) ?? 0,
      maxTermDays: int.tryParse(_maxTermCtrl.text.trim()) ?? 0,
      annualInterestRate: _annualRateCtrl.text.trim(),
      processingFeePercent: _processingFeeCtrl.text.trim(),
      insuranceFeePercent: _insuranceFeeCtrl.text.trim(),
      latePenaltyRate: _latePenaltyCtrl.text.trim(),
      gracePeriodDays: int.tryParse(_gracePeriodCtrl.text.trim()) ?? 0,
      state: _selectedState,
    );

    // Set organization ID from selection or preserve from existing product.
    if (_selectedOrganizationId != null &&
        _selectedOrganizationId!.isNotEmpty) {
      product.organizationId = _selectedOrganizationId!;
    } else if (widget.product != null && widget.product!.hasOrganizationId()) {
      product.organizationId = widget.product!.organizationId;
    }

    // Preserve backend-managed fields when editing.
    if (widget.product != null) {
      if (widget.product!.hasProperties()) {
        product.properties = widget.product!.properties;
      }
    }

    try {
      await widget.onSave(product);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  static const _productTypes = [
    LoanProductType.LOAN_PRODUCT_TYPE_TERM,
    LoanProductType.LOAN_PRODUCT_TYPE_REVOLVING,
    LoanProductType.LOAN_PRODUCT_TYPE_BULLET,
    LoanProductType.LOAN_PRODUCT_TYPE_GRADUATED,
  ];

  static const _interestMethods = [
    InterestMethod.INTEREST_METHOD_FLAT,
    InterestMethod.INTEREST_METHOD_REDUCING_BALANCE,
    InterestMethod.INTEREST_METHOD_COMPOUND,
  ];

  static const _repaymentFrequencies = [
    RepaymentFrequency.REPAYMENT_FREQUENCY_DAILY,
    RepaymentFrequency.REPAYMENT_FREQUENCY_WEEKLY,
    RepaymentFrequency.REPAYMENT_FREQUENCY_BIWEEKLY,
    RepaymentFrequency.REPAYMENT_FREQUENCY_MONTHLY,
    RepaymentFrequency.REPAYMENT_FREQUENCY_QUARTERLY,
  ];

  static const _editableStates = [
    STATE.CREATED,
    STATE.CHECKED,
    STATE.ACTIVE,
    STATE.INACTIVE,
    STATE.DELETED,
  ];

  static String _productTypeLabel(LoanProductType type) {
    return switch (type) {
      LoanProductType.LOAN_PRODUCT_TYPE_TERM => 'Term',
      LoanProductType.LOAN_PRODUCT_TYPE_REVOLVING => 'Revolving',
      LoanProductType.LOAN_PRODUCT_TYPE_BULLET => 'Bullet',
      LoanProductType.LOAN_PRODUCT_TYPE_GRADUATED => 'Graduated',
      _ => 'Unknown',
    };
  }

  static String _interestMethodLabel(InterestMethod method) {
    return switch (method) {
      InterestMethod.INTEREST_METHOD_FLAT => 'Flat',
      InterestMethod.INTEREST_METHOD_REDUCING_BALANCE => 'Reducing Balance',
      InterestMethod.INTEREST_METHOD_COMPOUND => 'Compound',
      _ => 'Unknown',
    };
  }

  static String _repaymentFrequencyLabel(RepaymentFrequency freq) {
    return switch (freq) {
      RepaymentFrequency.REPAYMENT_FREQUENCY_DAILY => 'Daily',
      RepaymentFrequency.REPAYMENT_FREQUENCY_WEEKLY => 'Weekly',
      RepaymentFrequency.REPAYMENT_FREQUENCY_BIWEEKLY => 'Biweekly',
      RepaymentFrequency.REPAYMENT_FREQUENCY_MONTHLY => 'Monthly',
      RepaymentFrequency.REPAYMENT_FREQUENCY_QUARTERLY => 'Quarterly',
      _ => 'Unknown',
    };
  }

  @override
  Widget build(BuildContext context) {
    final organizationsAsync = ref.watch(organizationListProvider(''));

    return AlertDialog(
      title: Text(_isEditing ? 'Edit Loan Product' : 'Add Loan Product'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormSection(
                  title: 'Basic Information',
                  description: 'Core product identity and classification',
                  children: [
                    FormFieldCard(
                      label: 'Organization',
                      description:
                          'The organization that owns this loan product',
                      isRequired: true,
                      child: organizationsAsync.when(
                        loading: () => const LinearProgressIndicator(),
                        error: (e, _) =>
                            Text('Failed to load organizations: $e'),
                        data: (organizations) =>
                            DropdownButtonFormField<String>(
                              initialValue:
                                  _selectedOrganizationId != null &&
                                      organizations.any(
                                        (o) => o.id == _selectedOrganizationId,
                                      )
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
                                      org.name.isNotEmpty ? org.name : org.id,
                                    ),
                                  ),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Organization is required';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() => _selectedOrganizationId = value);
                              },
                            ),
                      ),
                    ),
                    FormFieldCard(
                      label: 'Name',
                      description: 'The display name for this loan product',
                      isRequired: true,
                      child: TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Personal Loan',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Name is required'
                            : null,
                      ),
                    ),
                    FormFieldCard(
                      label: 'Code',
                      description:
                          'Unique product identifier for reports and integrations',
                      isRequired: true,
                      child: TextFormField(
                        controller: _codeCtrl,
                        decoration: const InputDecoration(
                          hintText: 'e.g. PL-001',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Code is required'
                            : null,
                      ),
                    ),
                    FormFieldCard(
                      label: 'Description',
                      description:
                          'A brief summary of what this loan product offers',
                      child: TextFormField(
                        controller: _descriptionCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Describe the loan product',
                        ),
                        textInputAction: TextInputAction.next,
                        maxLines: 2,
                      ),
                    ),
                    FormFieldCard(
                      label: 'Product Type',
                      description:
                          'Determines the repayment structure of the loan',
                      isRequired: true,
                      child: DropdownButtonFormField<LoanProductType>(
                        initialValue: _productType,
                        items: _productTypes
                            .map(
                              (t) => DropdownMenuItem(
                                value: t,
                                child: Text(_productTypeLabel(t)),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _productType = v);
                        },
                      ),
                    ),
                  ],
                ),
                FormSection(
                  title: 'Interest & Repayment',
                  description: 'How interest is calculated and repaid',
                  children: [
                    FormFieldCard(
                      label: 'Currency',
                      description: 'ISO 4217 currency code for this product',
                      isRequired: true,
                      child: TextFormField(
                        controller: _currencyCtrl,
                        decoration: const InputDecoration(hintText: 'e.g. KES'),
                        textInputAction: TextInputAction.next,
                        validator: (v) => (v == null || v.trim().length != 3)
                            ? 'Enter a 3-letter currency code'
                            : null,
                      ),
                    ),
                    FormFieldCard(
                      label: 'Interest Method',
                      description:
                          'How interest is computed over the loan term',
                      isRequired: true,
                      child: DropdownButtonFormField<InterestMethod>(
                        initialValue: _interestMethod,
                        items: _interestMethods
                            .map(
                              (m) => DropdownMenuItem(
                                value: m,
                                child: Text(_interestMethodLabel(m)),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => _interestMethod = v);
                          }
                        },
                      ),
                    ),
                    FormFieldCard(
                      label: 'Repayment Frequency',
                      description: 'How often the borrower makes repayments',
                      isRequired: true,
                      child: DropdownButtonFormField<RepaymentFrequency>(
                        initialValue: _repaymentFrequency,
                        items: _repaymentFrequencies
                            .map(
                              (f) => DropdownMenuItem(
                                value: f,
                                child: Text(_repaymentFrequencyLabel(f)),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => _repaymentFrequency = v);
                          }
                        },
                      ),
                    ),
                    FormFieldCard(
                      label: 'Annual Interest Rate (%)',
                      description:
                          'The yearly interest rate applied to the loan',
                      child: TextFormField(
                        controller: _annualRateCtrl,
                        decoration: const InputDecoration(
                          hintText: 'e.g. 12.5',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                FormSection(
                  title: 'Loan Limits',
                  description: 'Minimum and maximum amounts and terms',
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: FormFieldCard(
                            label: 'Min Amount',
                            description: 'Smallest loan that can be issued',
                            child: TextFormField(
                              controller: _minAmountCtrl,
                              decoration: const InputDecoration(
                                hintText: 'e.g. 1000',
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FormFieldCard(
                            label: 'Max Amount',
                            description: 'Largest loan that can be issued',
                            child: TextFormField(
                              controller: _maxAmountCtrl,
                              decoration: const InputDecoration(
                                hintText: 'e.g. 500000',
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FormFieldCard(
                            label: 'Min Term (days)',
                            description: 'Shortest allowed loan duration',
                            child: TextFormField(
                              controller: _minTermCtrl,
                              decoration: const InputDecoration(
                                hintText: 'e.g. 30',
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FormFieldCard(
                            label: 'Max Term (days)',
                            description: 'Longest allowed loan duration',
                            child: TextFormField(
                              controller: _maxTermCtrl,
                              decoration: const InputDecoration(
                                hintText: 'e.g. 365',
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                FormSection(
                  title: 'Fees & Penalties',
                  description: 'Additional charges and grace period settings',
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: FormFieldCard(
                            label: 'Processing Fee (%)',
                            description: 'One-time fee charged at disbursement',
                            child: TextFormField(
                              controller: _processingFeeCtrl,
                              decoration: const InputDecoration(
                                hintText: 'e.g. 2.0',
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FormFieldCard(
                            label: 'Insurance Fee (%)',
                            description: 'Credit insurance premium percentage',
                            child: TextFormField(
                              controller: _insuranceFeeCtrl,
                              decoration: const InputDecoration(
                                hintText: 'e.g. 1.0',
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FormFieldCard(
                            label: 'Late Penalty Rate',
                            description: 'Rate charged on overdue payments',
                            child: TextFormField(
                              controller: _latePenaltyCtrl,
                              decoration: const InputDecoration(
                                hintText: 'e.g. 5.0',
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FormFieldCard(
                            label: 'Grace Period (days)',
                            description:
                                'Days after due date before penalty applies',
                            child: TextFormField(
                              controller: _gracePeriodCtrl,
                              decoration: const InputDecoration(
                                hintText: 'e.g. 7',
                              ),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                FormFieldCard(
                  label: 'State',
                  description: 'The lifecycle state of this loan product',
                  isRequired: true,
                  child: DropdownButtonFormField<STATE>(
                    initialValue: _selectedState,
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
              : Text(_isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }
}
