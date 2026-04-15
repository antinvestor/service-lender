import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/loans/v1/loans.pb.dart';

part 'dashboard_providers.g.dart';

/// Fetches count of loan requests in a given status.
@riverpod
Future<int> loanRequestCountByStatus(
  Ref ref,
  LoanRequestStatus status,
) async {
  final client = ref.watch(loanManagementServiceClientProvider);
  final request = LoanRequestSearchRequest(cursor: PageCursor(limit: 1));
  request.status = status;

  return countStream(
    client.loanRequestSearch(request),
    count: (response) => response.data.length,
    maxPages: 1,
  );
}

/// Fetches count of loan accounts in a given status.
@riverpod
Future<int> loanCountByStatus(Ref ref, LoanStatus status) async {
  final client = ref.watch(loanManagementServiceClientProvider);
  final request = LoanAccountSearchRequest(cursor: PageCursor(limit: 1));
  request.status = status;

  return countStream(
    client.loanAccountSearch(request),
    count: (response) => response.data.length,
    maxPages: 1,
  );
}

/// Convenience providers for specific dashboard metrics.
@riverpod
Future<int> pendingApprovalCount(Ref ref) => ref.watch(
      loanRequestCountByStatusProvider(
        LoanRequestStatus.LOAN_REQUEST_STATUS_SUBMITTED,
      ).future,
    );

@riverpod
Future<int> approvedRequestsCount(Ref ref) => ref.watch(
      loanRequestCountByStatusProvider(
        LoanRequestStatus.LOAN_REQUEST_STATUS_APPROVED,
      ).future,
    );

@riverpod
Future<int> activeLoansCount(Ref ref) =>
    ref.watch(loanCountByStatusProvider(LoanStatus.LOAN_STATUS_ACTIVE).future);

@riverpod
Future<int> pendingDisbursementCount(Ref ref) => ref.watch(
      loanCountByStatusProvider(
        LoanStatus.LOAN_STATUS_PENDING_DISBURSEMENT,
      ).future,
    );

@riverpod
Future<int> delinquentLoansCount(Ref ref) => ref.watch(
      loanCountByStatusProvider(LoanStatus.LOAN_STATUS_DELINQUENT).future,
    );
