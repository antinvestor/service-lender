import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/loans/v1/loans.pb.dart';

part 'loan_request_providers.g.dart';

@riverpod
class LoanRequestList extends _$LoanRequestList {
  @override
  Future<List<LoanRequestObject>> build({
    String query = '',
    int? statusFilter,
    String? sourceService,
  }) async {
    final client = ref.watch(loanManagementServiceClientProvider);
    final request = LoanRequestSearchRequest(
      query: query,
      cursor: PageCursor(limit: 50),
    );
    if (statusFilter != null && statusFilter > 0) {
      request.status = LoanRequestStatus.valueOf(statusFilter)!;
    }
    if (sourceService != null && sourceService.isNotEmpty) {
      request.sourceService = sourceService;
    }

    return collectStream(
      client.loanRequestSearch(request),
      extract: (response) => response.data,
    );
  }
}

@riverpod
Future<LoanRequestObject> loanRequestDetail(
  Ref ref,
  String requestId,
) async {
  final client = ref.watch(loanManagementServiceClientProvider);
  final response = await client.loanRequestGet(
    LoanRequestGetRequest(id: requestId),
  );
  return response.data;
}

@riverpod
class LoanRequestNotifier extends _$LoanRequestNotifier {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<LoanRequestObject> save(LoanRequestObject request) async {
    final client = ref.read(loanManagementServiceClientProvider);
    final response = await client.loanRequestSave(
      LoanRequestSaveRequest(data: request),
    );
    ref.invalidate(loanRequestListProvider);
    return response.data;
  }

  Future<LoanRequestObject> approve(String id) async {
    final client = ref.read(loanManagementServiceClientProvider);
    final response = await client.loanRequestApprove(
      LoanRequestApproveRequest(id: id),
    );
    ref.invalidate(loanRequestListProvider);
    return response.data;
  }

  Future<LoanRequestObject> reject(String id, String reason) async {
    final client = ref.read(loanManagementServiceClientProvider);
    final response = await client.loanRequestReject(
      LoanRequestRejectRequest(id: id, reason: reason),
    );
    ref.invalidate(loanRequestListProvider);
    return response.data;
  }

  Future<LoanRequestObject> cancel(String id, String reason) async {
    final client = ref.read(loanManagementServiceClientProvider);
    final response = await client.loanRequestCancel(
      LoanRequestCancelRequest(id: id, reason: reason),
    );
    ref.invalidate(loanRequestListProvider);
    return response.data;
  }
}
