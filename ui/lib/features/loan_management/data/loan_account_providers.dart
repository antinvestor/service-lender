import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/loans/v1/loans.pb.dart';

part 'loan_account_providers.g.dart';

@riverpod
Future<List<LoanAccountObject>> loanAccountList(
  Ref ref, {
  required String query,
  LoanStatus? status,
  String agentId = '',
  String clientId = '',
}) async {
  final client = ref.watch(loanManagementServiceClientProvider);
  final request = LoanAccountSearchRequest(
    query: query,
    cursor: PageCursor(limit: 50),
  );
  if (status != null) {
    request.status = status;
  }
  if (agentId.isNotEmpty) {
    request.agentId = agentId;
  }
  if (clientId.isNotEmpty) {
    request.clientId = clientId;
  }
  return collectStream(
    client.loanAccountSearch(request),
    extract: (response) => response.data,
  );
}

@riverpod
Future<LoanAccountObject> loanAccountDetail(
  Ref ref, {
  required String id,
}) async {
  final client = ref.watch(loanManagementServiceClientProvider);
  final response = await client.loanAccountGet(LoanAccountGetRequest(id: id));
  return response.data;
}

@riverpod
Future<LoanBalanceObject> loanBalanceDetail(
  Ref ref, {
  required String loanAccountId,
}) async {
  final client = ref.watch(loanManagementServiceClientProvider);
  final response = await client.loanBalanceGet(
    LoanBalanceGetRequest(loanAccountId: loanAccountId),
  );
  return response.data;
}

@riverpod
class LoanAccountNotifier extends _$LoanAccountNotifier {
  @override
  FutureOr<void> build() {}

  Future<LoanAccountObject> createFromApplication(String applicationId) async {
    final client = ref.read(loanManagementServiceClientProvider);
    final response = await client.loanAccountCreate(
      LoanAccountCreateRequest(applicationId: applicationId),
    );
    ref.invalidate(loanAccountListProvider);
    return response.data;
  }
}
