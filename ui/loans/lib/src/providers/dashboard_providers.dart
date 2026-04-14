import 'package:antinvestor_api_loans/antinvestor_api_loans.dart';
import 'package:antinvestor_ui_core/api/stream_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'loans_transport_provider.dart';

/// Fetches count of loan requests in a given status.
final loanRequestCountByStatusProvider =
    FutureProvider.family<int, LoanRequestStatus>(
  (ref, status) async {
    final client = ref.watch(loanManagementServiceClientProvider);
    final request = LoanRequestSearchRequest(cursor: PageCursor(limit: 1));
    request.status = status;

    return countStream(
      client.loanRequestSearch(request),
      count: (response) => response.data.length,
      maxPages: 1,
    );
  },
);

/// Fetches count of loan accounts in a given status.
final loanCountByStatusProvider = FutureProvider.family<int, LoanStatus>(
  (ref, status) async {
    final client = ref.watch(loanManagementServiceClientProvider);
    final request = LoanAccountSearchRequest(cursor: PageCursor(limit: 1));
    request.status = status;

    return countStream(
      client.loanAccountSearch(request),
      count: (response) => response.data.length,
      maxPages: 1,
    );
  },
);

/// Convenience providers for specific dashboard metrics.
final pendingApprovalCountProvider = FutureProvider<int>(
  (ref) async {
    final client = ref.watch(loanManagementServiceClientProvider);
    final request = LoanRequestSearchRequest(cursor: PageCursor(limit: 1));
    request.status = LoanRequestStatus.LOAN_REQUEST_STATUS_SUBMITTED;
    return countStream(
      client.loanRequestSearch(request),
      count: (response) => response.data.length,
      maxPages: 1,
    );
  },
);

final approvedRequestsCountProvider = FutureProvider<int>(
  (ref) async {
    final client = ref.watch(loanManagementServiceClientProvider);
    final request = LoanRequestSearchRequest(cursor: PageCursor(limit: 1));
    request.status = LoanRequestStatus.LOAN_REQUEST_STATUS_APPROVED;
    return countStream(
      client.loanRequestSearch(request),
      count: (response) => response.data.length,
      maxPages: 1,
    );
  },
);

final activeLoansCountProvider = FutureProvider<int>(
  (ref) async {
    final client = ref.watch(loanManagementServiceClientProvider);
    final request = LoanAccountSearchRequest(cursor: PageCursor(limit: 1));
    request.status = LoanStatus.LOAN_STATUS_ACTIVE;
    return countStream(
      client.loanAccountSearch(request),
      count: (response) => response.data.length,
      maxPages: 1,
    );
  },
);

final pendingDisbursementCountProvider = FutureProvider<int>(
  (ref) async {
    final client = ref.watch(loanManagementServiceClientProvider);
    final request = LoanAccountSearchRequest(cursor: PageCursor(limit: 1));
    request.status = LoanStatus.LOAN_STATUS_PENDING_DISBURSEMENT;
    return countStream(
      client.loanAccountSearch(request),
      count: (response) => response.data.length,
      maxPages: 1,
    );
  },
);

final delinquentLoansCountProvider = FutureProvider<int>(
  (ref) async {
    final client = ref.watch(loanManagementServiceClientProvider);
    final request = LoanAccountSearchRequest(cursor: PageCursor(limit: 1));
    request.status = LoanStatus.LOAN_STATUS_DELINQUENT;
    return countStream(
      client.loanAccountSearch(request),
      count: (response) => response.data.length,
      maxPages: 1,
    );
  },
);
