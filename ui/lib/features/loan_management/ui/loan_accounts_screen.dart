import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/loan_status_badge.dart';
import '../../../core/widgets/money_helpers.dart';
import '../../../core/widgets/resolved_name.dart';
import '../../../sdk/src/loans/v1/loans.pb.dart';
import '../../auth/data/auth_repository.dart';
import '../data/loan_account_providers.dart';
import 'loan_account_detail_screen.dart';

class LoanAccountsScreen extends ConsumerStatefulWidget {
  const LoanAccountsScreen({super.key});

  @override
  ConsumerState<LoanAccountsScreen> createState() => _LoanAccountsScreenState();
}

class _LoanAccountsScreenState extends ConsumerState<LoanAccountsScreen> {
  Timer? _debounce;
  String _query = '';
  LoanStatus? _statusFilter;
  String _agentScope = '';
  bool _scopeInitialized = false;
  String? _selectedLoanId;

  void _initAgentScope() {
    if (_scopeInitialized) return;
    _scopeInitialized = true;
    final roles = ref.read(currentUserRolesProvider).value ?? <LenderRole>{};
    final isAgentOnly =
        roles.contains(LenderRole.agent) &&
        !roles.any(
          (r) =>
              r == LenderRole.owner ||
              r == LenderRole.admin ||
              r == LenderRole.manager,
        );
    if (isAgentOnly) {
      _agentScope = ref.read(currentProfileIdProvider).value ?? '';
    }
  }

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

  void _selectLoan(String loanId) {
    // On desktop: show inline detail. On mobile: navigate.
    final width = MediaQuery.of(context).size.width;
    if (AppBreakpoints.isDesktop(width)) {
      setState(() => _selectedLoanId = loanId);
    } else {
      context.go('/loans/$loanId');
    }
  }

  @override
  Widget build(BuildContext context) {
    _initAgentScope();

    final loansAsync = ref.watch(
      loanAccountListProvider(
        query: _query,
        status: _statusFilter,
        agentId: _agentScope,
      ),
    );
    final canManage = ref.watch(canManageLoansProvider).value ?? false;

    final items = loansAsync.value ?? [];
    return EntityListPage<LoanAccountObject>(
      title: 'Loan Accounts',
      icon: Icons.account_balance_wallet_outlined,
      items: items,
      isLoading: loansAsync.isLoading,
      hasMore: items.length >= kDefaultPagedResultLimit,
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
            (s) => DropdownMenuItem(value: s, child: Text(loanStatusLabel(s))),
          ),
        ],
        onChanged: (value) {
          setState(() => _statusFilter = value);
        },
      ),
      selectedId: _selectedLoanId,
      detailBuilder: (id) => LoanAccountDetailScreen(loanId: id),
      emptyDetailMessage: 'Select a loan to view details',
      itemBuilder: (context, loan) => _LoanAccountCard(
        loan: loan,
        isSelected: loan.id == _selectedLoanId,
        onTap: () => _selectLoan(loan.id),
      ),
    );
  }
}

class _LoanAccountCard extends ConsumerWidget {
  const _LoanAccountCard({
    required this.loan,
    required this.onTap,
    this.isSelected = false,
  });

  final LoanAccountObject loan;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: isSelected
          ? theme.colorScheme.primaryContainer.withAlpha(40)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isSelected
            ? BorderSide(color: theme.colorScheme.primary, width: 1.5)
            : BorderSide.none,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
