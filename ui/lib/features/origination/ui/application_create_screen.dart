import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/widgets/dynamic_form.dart';
import '../../../core/widgets/money_helpers.dart';
import '../../../sdk/src/origination/v1/origination.pb.dart';
import '../../auth/data/auth_repository.dart';
import '../../loan_management/data/loan_product_providers.dart';
import '../data/application_providers.dart';

/// Multi-step application creation wizard.
///
/// Steps:
/// 1. Select Product
/// 2. Enter Loan Details (amount, term, purpose)
/// 3. KYC Data (product-driven if kyc_schema exists)
/// 4. Review & Submit
class ApplicationCreateScreen extends ConsumerStatefulWidget {
  const ApplicationCreateScreen({super.key, this.clientId});
  final String? clientId;

  @override
  ConsumerState<ApplicationCreateScreen> createState() =>
      _ApplicationCreateScreenState();
}

class _ApplicationCreateScreenState
    extends ConsumerState<ApplicationCreateScreen> {
  int _currentStep = 0;
  bool _saving = false;

  // Step 1: Product selection
  LoanProductObject? _selectedProduct;

  // Step 2: Loan details
  final _clientIdCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _termCtrl = TextEditingController();
  final _currencyCtrl = TextEditingController(text: 'KES');
  final _purposeCtrl = TextEditingController();
  final _step2Key = GlobalKey<FormState>();

  // Step 3: KYC data
  final _kycFormKey = GlobalKey<DynamicFormState>();
  Map<String, dynamic> _kycValues = {};

  @override
  void initState() {
    super.initState();
    if (widget.clientId != null) {
      _clientIdCtrl.text = widget.clientId!;
    }
  }

  @override
  void dispose() {
    _clientIdCtrl.dispose();
    _amountCtrl.dispose();
    _termCtrl.dispose();
    _currencyCtrl.dispose();
    _purposeCtrl.dispose();
    super.dispose();
  }

  bool get _hasKycSchema =>
      _selectedProduct != null &&
      _selectedProduct!.hasKycSchema() &&
      _selectedProduct!.kycSchema.fields.isNotEmpty;

  int get _totalSteps => _hasKycSchema ? 4 : 3;

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      return _selectedProduct != null;
    }
    if (_currentStep == 1) {
      return _step2Key.currentState?.validate() ?? false;
    }
    if (_currentStep == 2 && _hasKycSchema) {
      return _kycFormKey.currentState?.validate() ?? true;
    }
    return true;
  }

  void _next() {
    if (!_validateCurrentStep()) {
      if (_currentStep == 0 && _selectedProduct == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a product')),
        );
      }
      return;
    }
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _submitDraft() async => _submit(asDraft: true);
  Future<void> _submitApplication() async => _submit(asDraft: false);

  Future<void> _submit({required bool asDraft}) async {
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;

    try {
      final profileId = ref.read(currentProfileIdProvider).value ?? '';

      final app = ApplicationObject(
        productId: _selectedProduct!.id,
        clientId: _clientIdCtrl.text.trim(),
        agentId: profileId,
        organizationId: _selectedProduct!.organizationId,
        // branchId is optional; omit to let the backend resolve it.
        requestedAmount: moneyFromString(
          _amountCtrl.text.trim(),
          _currencyCtrl.text.trim().toUpperCase(),
        ),
        requestedTermDays: int.tryParse(_termCtrl.text.trim()) ?? 0,
        purpose: _purposeCtrl.text.trim(),
        status: ApplicationStatus.APPLICATION_STATUS_DRAFT,
      );

      // Attach KYC data if collected
      if (_kycValues.isNotEmpty) {
        app.kycData = mapToStruct(_kycValues);
      }

      final saved = await ref.read(applicationProvider.notifier).save(app);

      if (!asDraft) {
        await ref.read(applicationProvider.notifier).submit(saved.id);
        messenger.showSnackBar(
          const SnackBar(content: Text('Application submitted successfully')),
        );
      } else {
        messenger.showSnackBar(
          const SnackBar(content: Text('Application saved as draft')),
        );
      }

      if (mounted) context.go('/origination/applications');
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Failed: $e'), backgroundColor: errorColor),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/origination/applications'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'New Application',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                'Step ${_currentStep + 1} of $_totalSteps',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Step indicator
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              for (var i = 0; i < _totalSteps; i++) ...[
                if (i > 0) const SizedBox(width: 4),
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: i <= _currentStep
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Step label
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _stepLabel(_currentStep),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildStep(),
          ),
        ),

        // Navigation
        Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outlineVariant.withAlpha(60),
              ),
            ),
          ),
          child: Row(
            children: [
              if (_currentStep > 0)
                OutlinedButton(
                  onPressed: _saving ? null : _back,
                  child: const Text('Back'),
                ),
              const Spacer(),
              if (_currentStep < _totalSteps - 1)
                FilledButton(
                  onPressed: _saving ? null : _next,
                  child: const Text('Continue'),
                )
              else ...[
                OutlinedButton(
                  onPressed: _saving ? null : _submitDraft,
                  child: const Text('Save as Draft'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _saving ? null : _submitApplication,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send, size: 18),
                  label: const Text('Submit'),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _stepLabel(int step) {
    if (_hasKycSchema) {
      return switch (step) {
        0 => 'Select Loan Product',
        1 => 'Loan Details',
        2 => 'KYC Information',
        3 => 'Review & Submit',
        _ => '',
      };
    }
    return switch (step) {
      0 => 'Select Loan Product',
      1 => 'Loan Details',
      2 => 'Review & Submit',
      _ => '',
    };
  }

  Widget _buildStep() {
    // Determine actual step, accounting for optional KYC step
    if (_hasKycSchema) {
      return switch (_currentStep) {
        0 => _buildProductSelection(),
        1 => _buildLoanDetails(),
        2 => _buildKycStep(),
        3 => _buildReview(),
        _ => const SizedBox.shrink(),
      };
    }
    return switch (_currentStep) {
      0 => _buildProductSelection(),
      1 => _buildLoanDetails(),
      2 => _buildReview(),
      _ => const SizedBox.shrink(),
    };
  }

  // ── Step 1: Product Selection ──────────────────────────────────────────────

  Widget _buildProductSelection() {
    final productsAsync = ref.watch(loanProductListProvider(''));

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading products: $e')),
      data: (products) {
        if (products.isEmpty) {
          return const Center(child: Text('No loan products available'));
        }
        return Column(
          children: [
            for (final product in products)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ProductCard(
                  product: product,
                  isSelected: _selectedProduct?.id == product.id,
                  onTap: () => setState(() => _selectedProduct = product),
                ),
              ),
          ],
        );
      },
    );
  }

  // ── Step 2: Loan Details ───────────────────────────────────────────────────

  Widget _buildLoanDetails() {
    return Form(
      key: _step2Key,
      child: Column(
        children: [
          TextFormField(
            controller: _clientIdCtrl,
            decoration: const InputDecoration(
              labelText: 'Client ID *',
              hintText: 'Enter the client ID',
            ),
            textInputAction: TextInputAction.next,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Client ID is required'
                : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _amountCtrl,
                  decoration: InputDecoration(
                    labelText: 'Requested Amount *',
                    hintText: _selectedProduct != null
                        ? '${moneyToAmountString(_selectedProduct!.minAmount)} - ${moneyToAmountString(_selectedProduct!.maxAmount)}'
                        : null,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  validator: validateAmount,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _currencyCtrl,
                  decoration: const InputDecoration(labelText: 'Currency'),
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  validator: validateCurrency,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _termCtrl,
            decoration: InputDecoration(
              labelText: 'Term (days) *',
              hintText: _selectedProduct != null
                  ? '${_selectedProduct!.minTermDays} - ${_selectedProduct!.maxTermDays} days'
                  : null,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.next,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Term is required';
              }
              final days = int.tryParse(v.trim());
              if (days == null || days <= 0) {
                return 'Enter a positive number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _purposeCtrl,
            decoration: const InputDecoration(
              labelText: 'Purpose',
              hintText: 'What will the loan be used for?',
            ),
            maxLines: 2,
            textInputAction: TextInputAction.done,
          ),

          // Simple loan preview
          if (_selectedProduct != null &&
              _amountCtrl.text.isNotEmpty &&
              _termCtrl.text.isNotEmpty) ...[
            const SizedBox(height: 24),
            _LoanPreviewCard(
              product: _selectedProduct!,
              amount: _amountCtrl.text.trim(),
              termDays: _termCtrl.text.trim(),
              currency: _currencyCtrl.text.trim(),
            ),
          ],
        ],
      ),
    );
  }

  // ── Step 3: KYC Data ───────────────────────────────────────────────────────

  Widget _buildKycStep() {
    if (_selectedProduct == null || !_hasKycSchema) {
      return const Center(child: Text('No KYC schema configured'));
    }

    final fields = parseKycSchema(_selectedProduct!.kycSchema);
    if (fields.isEmpty) {
      return const Center(
        child: Text('No KYC fields defined for this product'),
      );
    }

    return DynamicForm(
      key: _kycFormKey,
      fields: fields,
      initialValues: _kycValues,
      onChanged: (values) => _kycValues = values,
    );
  }

  // ── Review ─────────────────────────────────────────────────────────────────

  Widget _buildReview() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(_selectedProduct?.name ?? 'None selected'),
                if (_selectedProduct?.code.isNotEmpty ?? false)
                  Text(
                    'Code: ${_selectedProduct!.code}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loan Details',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _ReviewLine('Client', _clientIdCtrl.text),
                _ReviewLine(
                  'Amount',
                  '${_currencyCtrl.text} ${_amountCtrl.text}',
                ),
                _ReviewLine('Term', '${_termCtrl.text} days'),
                _ReviewLine('Purpose', _purposeCtrl.text),
              ],
            ),
          ),
        ),
        if (_kycValues.isNotEmpty) ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KYC Data',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final entry in _kycValues.entries)
                    if (entry.value != null &&
                        entry.value.toString().isNotEmpty)
                      _ReviewLine(entry.key, entry.value.toString()),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Product selection card
// ---------------------------------------------------------------------------

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.isSelected,
    required this.onTap,
  });

  final LoanProductObject product;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary,
                  ),
                  child: const Icon(Icons.check, size: 16, color: Colors.white),
                )
              else
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.currencyCode} ${moneyToAmountString(product.minAmount)} - ${moneyToAmountString(product.maxAmount)}'
                      ' \u2022 ${product.minTermDays}-${product.maxTermDays} days'
                      ' \u2022 ${product.annualInterestRate}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loan preview card
// ---------------------------------------------------------------------------

class _LoanPreviewCard extends StatelessWidget {
  const _LoanPreviewCard({
    required this.product,
    required this.amount,
    required this.termDays,
    required this.currency,
  });

  final LoanProductObject product;
  final String amount;
  final String termDays;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final principal = double.tryParse(amount) ?? 0;
    final days = int.tryParse(termDays) ?? 0;
    final rate = double.tryParse(product.annualInterestRate) ?? 0;

    if (principal <= 0 || days <= 0) return const SizedBox.shrink();

    // Simple flat interest calculation for preview
    final totalInterest = principal * (rate / 100) * (days / 365);
    final totalRepayable = principal + totalInterest;
    final monthlyPayment = days > 0 ? totalRepayable / (days / 30) : 0;

    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer.withAlpha(30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.colorScheme.primary.withAlpha(40)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calculate_outlined,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Loan Estimate',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _EstimateItem(
                  'Monthly Payment',
                  '$currency ${monthlyPayment.toStringAsFixed(0)}',
                ),
                _EstimateItem(
                  'Total Interest',
                  '$currency ${totalInterest.toStringAsFixed(0)}',
                ),
                _EstimateItem(
                  'Total Repayable',
                  '$currency ${totalRepayable.toStringAsFixed(0)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EstimateItem extends StatelessWidget {
  const _EstimateItem(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewLine extends StatelessWidget {
  const _ReviewLine(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
