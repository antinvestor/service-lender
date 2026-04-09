import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/dynamic_form.dart';
import '../../../core/widgets/money_helpers.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/origination/v1/origination.pb.dart';
import '../data/loan_product_providers.dart';

class LoanProductDetailScreen extends ConsumerWidget {
  const LoanProductDetailScreen({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(loanProductDetailProvider(productId));

    return productAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text('Failed to load product: $error'),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () =>
                  ref.invalidate(loanProductDetailProvider(productId)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (product) => _ProductDetailContent(product: product),
    );
  }
}

class _ProductDetailContent extends StatelessWidget {
  const _ProductDetailContent({required this.product});
  final LoanProductObject product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/loans/products'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (product.code.isNotEmpty)
                        Text(
                          'Code: ${product.code}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                StateBadge(state: product.state),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tabs
          const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Terms'),
              Tab(text: 'KYC Schema'),
              Tab(text: 'Documents'),
              Tab(text: 'Eligibility'),
            ],
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              children: [
                _TermsTab(product: product),
                _KycSchemaTab(product: product),
                _DocumentsTab(product: product),
                _EligibilityTab(product: product),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Terms Tab
// ---------------------------------------------------------------------------

class _TermsTab extends StatelessWidget {
  const _TermsTab({required this.product});
  final LoanProductObject product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Information',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _DetailRow('Name', product.name),
                _DetailRow('Code', product.code),
                _DetailRow('Description', product.description),
                _DetailRow(
                  'Product Type',
                  _productTypeLabel(product.productType),
                ),
                _DetailRow('Currency', product.currencyCode),
                _DetailRow('State', product.state.name),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loan Limits',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _DetailRow('Min Amount', formatMoney(product.minAmount)),
                _DetailRow('Max Amount', formatMoney(product.maxAmount)),
                _DetailRow('Min Term', '${product.minTermDays} days'),
                _DetailRow('Max Term', '${product.maxTermDays} days'),
                _DetailRow('Grace Period', '${product.gracePeriodDays} days'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rates & Fees',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  'Annual Interest Rate',
                  '${product.annualInterestRate}%',
                ),
                _DetailRow(
                  'Interest Method',
                  _interestMethodLabel(product.interestMethod),
                ),
                _DetailRow(
                  'Repayment Frequency',
                  _frequencyLabel(product.repaymentFrequency),
                ),
                _DetailRow(
                  'Processing Fee',
                  '${product.processingFeePercent}%',
                ),
                _DetailRow('Insurance Fee', '${product.insuranceFeePercent}%'),
                _DetailRow('Late Penalty Rate', '${product.latePenaltyRate}%'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String _productTypeLabel(LoanProductType t) {
    return switch (t) {
      LoanProductType.LOAN_PRODUCT_TYPE_TERM => 'Term',
      LoanProductType.LOAN_PRODUCT_TYPE_REVOLVING => 'Revolving',
      LoanProductType.LOAN_PRODUCT_TYPE_BULLET => 'Bullet',
      LoanProductType.LOAN_PRODUCT_TYPE_GRADUATED => 'Graduated',
      _ => 'Unspecified',
    };
  }

  static String _interestMethodLabel(InterestMethod m) {
    return switch (m) {
      InterestMethod.INTEREST_METHOD_FLAT => 'Flat',
      InterestMethod.INTEREST_METHOD_REDUCING_BALANCE => 'Reducing Balance',
      InterestMethod.INTEREST_METHOD_COMPOUND => 'Compound',
      _ => 'Unspecified',
    };
  }

  static String _frequencyLabel(RepaymentFrequency f) {
    return switch (f) {
      RepaymentFrequency.REPAYMENT_FREQUENCY_DAILY => 'Daily',
      RepaymentFrequency.REPAYMENT_FREQUENCY_WEEKLY => 'Weekly',
      RepaymentFrequency.REPAYMENT_FREQUENCY_BIWEEKLY => 'Biweekly',
      RepaymentFrequency.REPAYMENT_FREQUENCY_MONTHLY => 'Monthly',
      RepaymentFrequency.REPAYMENT_FREQUENCY_QUARTERLY => 'Quarterly',
      _ => 'Unspecified',
    };
  }
}

// ---------------------------------------------------------------------------
// KYC Schema Tab
// ---------------------------------------------------------------------------

class _KycSchemaTab extends StatelessWidget {
  const _KycSchemaTab({required this.product});
  final LoanProductObject product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fields = product.hasKycSchema()
        ? parseKycSchema(product.kycSchema)
        : <DynamicFieldDef>[];

    if (fields.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.list_alt_outlined,
              size: 48,
              color: theme.colorScheme.onSurface.withAlpha(100),
            ),
            const SizedBox(height: 16),
            Text(
              'No KYC schema configured',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    // Group and display fields
    final grouped = groupFields(fields);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          '${fields.length} fields in ${grouped.length} group${grouped.length > 1 ? 's' : ''}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        for (final entry in grouped.entries) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _humanize(entry.key),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingTextStyle: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      dataTextStyle: theme.textTheme.bodySmall,
                      columnSpacing: 20,
                      columns: const [
                        DataColumn(label: Text('Key')),
                        DataColumn(label: Text('Label')),
                        DataColumn(label: Text('Type')),
                        DataColumn(label: Text('Required')),
                      ],
                      rows: entry.value
                          .map(
                            (f) => DataRow(
                              cells: [
                                DataCell(Text(f.key)),
                                DataCell(Text(f.label)),
                                DataCell(_TypeChip(type: f.type)),
                                DataCell(
                                  Icon(
                                    f.required
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    size: 16,
                                    color: f.required
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Live preview
        Card(
          color: theme.colorScheme.primaryContainer.withAlpha(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.preview,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Form Preview',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DynamicForm(fields: fields, readOnly: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _humanize(String s) {
    return s
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '',
        )
        .join(' ');
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.type});
  final String type;

  @override
  Widget build(BuildContext context) {
    final color = switch (type) {
      'text' => Colors.blue,
      'number' => Colors.green,
      'date' => Colors.purple,
      'select' => Colors.orange,
      'phone' => Colors.teal,
      'boolean' => Colors.indigo,
      'photo' => Colors.brown,
      'location' => Colors.red,
      _ => Colors.grey,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Documents Tab
// ---------------------------------------------------------------------------

class _DocumentsTab extends StatelessWidget {
  const _DocumentsTab({required this.product});
  final LoanProductObject product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final docs = product.requiredDocuments;

    if (docs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_off_outlined,
              size: 48,
              color: theme.colorScheme.onSurface.withAlpha(100),
            ),
            const SizedBox(height: 16),
            Text(
              'No required documents configured',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          '${docs.length} required document${docs.length > 1 ? 's' : ''}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (var i = 0; i < docs.length; i++)
                  ListTile(
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    title: Text(
                      _humanizeDocType(docs[i]),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.check_circle,
                      size: 18,
                      color: Colors.green.withAlpha(160),
                    ),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _humanizeDocType(String type) {
    return type
        .replaceAll('_', ' ')
        .replaceAll('DOCUMENT TYPE ', '')
        .split(' ')
        .map(
          (w) => w.isNotEmpty
              ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');
  }
}

// ---------------------------------------------------------------------------
// Eligibility Tab
// ---------------------------------------------------------------------------

class _EligibilityTab extends StatelessWidget {
  const _EligibilityTab({required this.product});
  final LoanProductObject product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!product.hasEligibilityCriteria() ||
        product.eligibilityCriteria.fields.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.rule_outlined,
              size: 48,
              color: theme.colorScheme.onSurface.withAlpha(100),
            ),
            const SizedBox(height: 16),
            Text(
              'No eligibility criteria configured',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    // Parse criteria from Struct
    final criteria = _parseCriteria(product.eligibilityCriteria);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          '${criteria.length} eligibility rule${criteria.length > 1 ? 's' : ''}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingTextStyle: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                dataTextStyle: theme.textTheme.bodySmall,
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text('Field')),
                  DataColumn(label: Text('Operator')),
                  DataColumn(label: Text('Value')),
                  DataColumn(label: Text('Blocking')),
                ],
                rows: criteria
                    .map(
                      (rule) => DataRow(
                        cells: [
                          DataCell(Text(rule['field'] ?? '')),
                          DataCell(Text(rule['op'] ?? '')),
                          DataCell(Text('${rule['value'] ?? ''}')),
                          DataCell(
                            Icon(
                              rule['blocking'] == true
                                  ? Icons.block
                                  : Icons.warning_amber,
                              size: 16,
                              color: rule['blocking'] == true
                                  ? Colors.red
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _parseCriteria(dynamic eligibilityCriteria) {
    try {
      final struct = eligibilityCriteria;
      // Look for a list in common keys
      for (final key in ['criteria', 'rules', 'eligibility_criteria']) {
        final val = struct.fields[key];
        if (val != null && val.hasListValue()) {
          return val.listValue.values
              .where((v) => v.hasStructValue())
              .map((v) => structToMap(v.structValue))
              .toList();
        }
      }
      // Try first list value found
      for (final entry in struct.fields.entries) {
        if (entry.value.hasListValue()) {
          return entry.value.listValue.values
              .where((v) => v.hasStructValue())
              .map((v) => structToMap(v.structValue))
              .toList();
        }
      }
    } catch (_) {}
    return [];
  }
}

// ---------------------------------------------------------------------------
// Shared detail row
// ---------------------------------------------------------------------------

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '\u2014',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
