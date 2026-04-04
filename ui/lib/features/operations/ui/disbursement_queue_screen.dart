import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/money_helpers.dart';
import '../../../sdk/src/loans/v1/loans.pbenum.dart';
import '../../loan_management/data/loan_account_providers.dart';

class DisbursementQueueScreen extends ConsumerStatefulWidget {
  const DisbursementQueueScreen({super.key});

  @override
  ConsumerState<DisbursementQueueScreen> createState() =>
      _DisbursementQueueScreenState();
}

class _DisbursementQueueScreenState
    extends ConsumerState<DisbursementQueueScreen> {
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
    final theme = Theme.of(context);
    final loansAsync = ref.watch(
      loanAccountListProvider(
        query: _query,
        status: LoanStatus.LOAN_STATUS_PENDING_DISBURSEMENT,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            children: [
              Icon(Icons.send_outlined,
                  size: 28, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Disbursement Queue',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: () => ref.invalidate(
                  loanAccountListProvider(
                    query: _query,
                    status: LoanStatus.LOAN_STATUS_PENDING_DISBURSEMENT,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Search
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: TextField(
            onChanged: _onSearchChanged,
            decoration: const InputDecoration(
              hintText: 'Search by loan ID, client...',
              prefixIcon: Icon(Icons.search, size: 20),
            ),
          ),
        ),

        // Summary
        loansAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (loans) {
            if (loans.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: Card(
                color: theme.colorScheme.surfaceContainerLow,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _SummaryChip(
                        label: 'Pending',
                        value: '${loans.length}',
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 24),
                      _SummaryChip(
                        label: 'Total Amount',
                        value: _totalAmount(loans),
                        color: theme.colorScheme.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // List
        Expanded(
          child: loansAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      size: 48, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Failed to load: $e'),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: () => ref.invalidate(
                      loanAccountListProvider(
                        query: _query,
                        status:
                            LoanStatus.LOAN_STATUS_PENDING_DISBURSEMENT,
                      ),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (loans) {
              if (loans.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.check_circle_outline,
                            size: 28, color: Colors.green),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No pending disbursements',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: loans.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final loan = loans[index];
                  return Card(
                    child: InkWell(
                      onTap: () => context.go('/loans/${loan.id}'),
                      borderRadius: DesignTokens.borderRadiusAll,
                      child: Row(
                        children: [
                          Container(
                            width: DesignTokens.accentBarWidth,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.orange.withAlpha(20),
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                        Icons.payments_outlined,
                                        color: Colors.orange,
                                        size: 22),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          formatMoney(
                                              loan.principalAmount),
                                          style: GoogleFonts.manrope(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Client: ${_shortId(loan.clientId)}',
                                          style: theme
                                              .textTheme.bodySmall
                                              ?.copyWith(
                                            color: theme.colorScheme
                                                .onSurfaceVariant,
                                          ),
                                        ),
                                        Text(
                                          'Loan: ${_shortId(loan.id)}',
                                          style: theme
                                              .textTheme.bodySmall
                                              ?.copyWith(
                                            color: theme.colorScheme
                                                .onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  FilledButton.tonal(
                                    onPressed: () => context
                                        .go('/loans/${loan.id}'),
                                    child: const Text('Process'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  String _shortId(String id) =>
      id.length > 12 ? '${id.substring(0, 12)}...' : id;

  String _totalAmount(List<dynamic> loans) {
    var total = 0;
    String currency = '';
    for (final loan in loans) {
      if (loan.hasPrincipalAmount()) {
        total = (total + loan.principalAmount.units.toInt()) as int;
        if (currency.isEmpty) {
          currency = loan.principalAmount.currencyCode;
        }
      }
    }
    if (total == 0) return '—';
    return '$currency $total';
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                )),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
