import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/application_status_badge.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/money_helpers.dart';
import '../../../sdk/src/loans/v1/loans.pb.dart';
import '../data/loan_request_providers.dart';

class LoanRequestsScreen extends ConsumerStatefulWidget {
  const LoanRequestsScreen({super.key, this.pendingOnly = false});

  final bool pendingOnly;

  @override
  ConsumerState<LoanRequestsScreen> createState() =>
      _LoanRequestsScreenState();
}

class _LoanRequestsScreenState extends ConsumerState<LoanRequestsScreen> {
  Timer? _debounce;
  String _query = '';
  LoanRequestStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    if (widget.pendingOnly) {
      _statusFilter = LoanRequestStatus.LOAN_REQUEST_STATUS_SUBMITTED;
    }
  }

  static const _filterableStatuses = [
    LoanRequestStatus.LOAN_REQUEST_STATUS_DRAFT,
    LoanRequestStatus.LOAN_REQUEST_STATUS_SUBMITTED,
    LoanRequestStatus.LOAN_REQUEST_STATUS_APPROVED,
    LoanRequestStatus.LOAN_REQUEST_STATUS_REJECTED,
    LoanRequestStatus.LOAN_REQUEST_STATUS_CANCELLED,
    LoanRequestStatus.LOAN_REQUEST_STATUS_LOAN_CREATED,
  ];

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(
      loanRequestListProvider(
        query: _query,
        statusFilter: _statusFilter?.value,
      ),
    );

    return EntityListPage<LoanRequestObject>(
      title: widget.pendingOnly ? 'Pending Loan Requests' : 'Loan Requests',
      icon: Icons.description_outlined,
      items: requestsAsync.value ?? [],
      isLoading: requestsAsync.isLoading,
      error: requestsAsync.error?.toString(),
      onRetry: () => ref.invalidate(loanRequestListProvider),
      searchHint: 'Search loan requests...',
      onSearchChanged: (query) {
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 400), () {
          setState(() => _query = query);
        });
      },
      filterWidget: DropdownButton<LoanRequestStatus?>(
        value: _statusFilter,
        hint: const Text('All statuses'),
        underline: const SizedBox.shrink(),
        items: [
          const DropdownMenuItem(value: null, child: Text('All')),
          for (final s in _filterableStatuses)
            DropdownMenuItem(
              value: s,
              child: Text(loanRequestStatusLabel(s)),
            ),
        ],
        onChanged: (v) => setState(() => _statusFilter = v),
      ),
      idOf: (r) => r.id,
      onNavigate: (r) => context.go('/loans/requests/$r'),
      itemBuilder: (context, request) => ListTile(
        title: Row(
          children: [
            Expanded(child: Text(request.clientId)),
            LoanRequestStatusBadge(status: request.status),
          ],
        ),
        subtitle: Row(
          children: [
            Text(formatMoney(request.requestedAmount)),
            const SizedBox(width: 8),
            Text('${request.requestedTermDays} days'),
            if (request.sourceService.isNotEmpty) ...[
              const SizedBox(width: 8),
              Chip(
                label: Text(request.sourceService),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.go('/loans/requests/${request.id}'),
      ),
    );
  }
}
