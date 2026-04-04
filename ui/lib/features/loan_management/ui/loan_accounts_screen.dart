import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/loan_status_badge.dart';
import '../../../core/widgets/money_helpers.dart';
import '../../../core/widgets/resolved_name.dart';
import '../../../sdk/src/loans/v1/loans.pb.dart';
import '../../../sdk/src/loans/v1/loans.pbenum.dart';
import '../data/loan_account_providers.dart';

class LoanAccountsScreen extends ConsumerStatefulWidget {
  const LoanAccountsScreen({super.key});

  @override
  ConsumerState<LoanAccountsScreen> createState() =>
      _LoanAccountsScreenState();
}

class _LoanAccountsScreenState extends ConsumerState<LoanAccountsScreen> {
  Timer? _debounce;
  String _query = '';
  LoanStatus? _statusFilter;

  static const _filterableStatuses = [
    LoanStatus.LOAN_STATUS_PENDING_DISBURSEMENT,
    LoanStatus.LOAN_STATUS_ACTIVE,
    LoanStatus.LOAN_STATUS_DELINQUENT,
    LoanStatus.LOAN_STATUS_DEFAULT,
    LoanStatus.LOAN_STATUS_PAID_OFF,
    LoanStatus.LOAN_STATUS_RESTRUCTURED,
    LoanStatus.LOAN_STATUS_WRITTEN_OFF,
    LoanStatus.LOAN_STATUS_CLOSED,
  ];

  @override
  void dispose() {
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
    final loansAsync = ref.watch(
      loanAccountListProvider(query: _query, status: _statusFilter),
    );
    final canManage = ref.watch(canManageLoansProvider).value ?? false;

    return EntityListPage<LoanAccountObject>(
      title: 'Loan Accounts',
      icon: Icons.account_balance_wallet_outlined,
      items: loansAsync.value ?? [],
      isLoading: loansAsync.isLoading,
      error: loansAsync.hasError ? loansAsync.error.toString() : null,
      onRetry: () => ref.invalidate(
        loanAccountListProvider(query: _query, status: _statusFilter),
      ),
      searchHint: 'Search loans...',
      onSearchChanged: _onSearchChanged,
      canAction: canManage,
      filterWidget: DropdownButton<LoanStatus?>(
        value: _statusFilter,
        hint: const Text('All Statuses'),
        underline: const SizedBox.shrink(),
        items: [
          const DropdownMenuItem<LoanStatus?>(
            value: null,
            child: Text('All Statuses'),
          ),
          ..._filterableStatuses.map(
            (s) => DropdownMenuItem(
              value: s,
              child: Text(loanStatusLabel(s)),
            ),
          ),
        ],
        onChanged: (value) {
          setState(() => _statusFilter = value);
        },
      ),
      itemBuilder: (context, loan) => _LoanAccountCard(
        loan: loan,
        onTap: () => context.go('/loans/${loan.id}'),
      ),
    );
  }
}

class _LoanAccountCard extends ConsumerWidget {
  const _LoanAccountCard({
    required this.loan,
    required this.onTap,
  });

  final LoanAccountObject loan;
  final VoidCallback onTap;

  String _truncateId(String id) {
    if (id.length <= 12) return id;
    return '${id.substring(0, 8)}...${id.substring(id.length - 4)}';
  }

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
            Icons.account_balance_wallet_outlined,
            color: theme.colorScheme.onPrimaryContainer,
            size: 20,
          ),
        ),
        title: ClientNameText(
          clientId: loan.clientId,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatMoney(loan.principalAmount),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (loan.daysPastDue > 0)
              Text(
                '${loan.daysPastDue} days past due',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        trailing: LoanStatusBadge(status: loan.status),
        onTap: onTap,
      ),
    );
  }
}
