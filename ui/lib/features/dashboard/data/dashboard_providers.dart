import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/loans/v1/loans.pb.dart';
import '../../../sdk/src/origination/v1/origination.pb.dart';

part 'dashboard_providers.g.dart';

/// Fetches count of applications in a given status.
/// Uses countStream to avoid loading full records into memory.
@riverpod
Future<int> applicationCountByStatus(
  Ref ref,
  ApplicationStatus status,
) async {
  final client = ref.watch(originationServiceClientProvider);
  final request = ApplicationSearchRequest(
    cursor: PageCursor(limit: 200),
  );
  request.status = status;

  return countStream(
    client.applicationSearch(request),
    count: (response) => response.data.length,
    maxPages: 20,
  );
}

/// Fetches count of loan accounts in a given status.
/// Uses countStream to avoid loading full records into memory.
@riverpod
Future<int> loanCountByStatus(
  Ref ref,
  LoanStatus status,
) async {
  final client = ref.watch(loanManagementServiceClientProvider);
  final request = LoanAccountSearchRequest(
    cursor: PageCursor(limit: 200),
  );
  request.status = status;

  return countStream(
    client.loanAccountSearch(request),
    count: (response) => response.data.length,
    maxPages: 20,
  );
}

/// Convenience providers for specific dashboard metrics.
@riverpod
Future<int> pendingVerificationCount(Ref ref) => ref.watch(
      applicationCountByStatusProvider(
        ApplicationStatus.APPLICATION_STATUS_VERIFICATION,
      ).future,
    );

@riverpod
Future<int> pendingUnderwritingCount(Ref ref) => ref.watch(
      applicationCountByStatusProvider(
        ApplicationStatus.APPLICATION_STATUS_UNDERWRITING,
      ).future,
    );

@riverpod
Future<int> offerPendingCount(Ref ref) => ref.watch(
      applicationCountByStatusProvider(
        ApplicationStatus.APPLICATION_STATUS_OFFER_GENERATED,
      ).future,
    );

@riverpod
Future<int> activeLoansCount(Ref ref) => ref.watch(
      loanCountByStatusProvider(LoanStatus.LOAN_STATUS_ACTIVE).future,
    );

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
