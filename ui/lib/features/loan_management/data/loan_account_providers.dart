import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/loans/v1/loans.pb.dart';
import '../../../sdk/src/loans/v1/loans.pbenum.dart';

part 'loan_account_providers.g.dart';

@riverpod
Future<List<LoanAccountObject>> loanAccountList(
  Ref ref, {
  required String query,
  LoanStatus? status,
}) async {
  final client = ref.watch(loanManagementServiceClientProvider);
  final request = LoanAccountSearchRequest(
    query: query,
    cursor: PageCursor(limit: 50),
  );
  if (status != null) {
    request.status = status;
  }
  final results = <LoanAccountObject>[];
  await for (final response in client.loanAccountSearch(request)) {
    results.addAll(response.data);
  }
  return results;
}

@riverpod
Future<LoanAccountObject> loanAccountDetail(
  Ref ref, {
  required String id,
}) async {
  final client = ref.watch(loanManagementServiceClientProvider);
  final response = await client.loanAccountGet(
    LoanAccountGetRequest(id: id),
  );
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

  Future<LoanAccountObject> createFromApplication(
      String applicationId) async {
    final client = ref.read(loanManagementServiceClientProvider);
    final response = await client.loanAccountCreate(
      LoanAccountCreateRequest(applicationId: applicationId),
    );
    ref.invalidate(loanAccountListProvider);
    return response.data;
  }
}
