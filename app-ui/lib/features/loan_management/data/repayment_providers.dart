import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/lender/v1/loan_management.pb.dart';

part 'repayment_providers.g.dart';

@riverpod
Future<List<RepaymentObject>> repaymentList(
  Ref ref, {
  required String loanAccountId,
}) async {
  final client = ref.watch(loanManagementServiceClientProvider);
  final request = RepaymentSearchRequest(
    loanAccountId: loanAccountId,
    cursor: PageCursor(limit: 50),
  );
  final results = <RepaymentObject>[];
  await for (final response in client.repaymentSearch(request)) {
    results.addAll(response.data);
  }
  return results;
}

@riverpod
class RepaymentNotifier extends _$RepaymentNotifier {
  @override
  FutureOr<void> build() {}

  Future<RepaymentObject> record({
    required String loanAccountId,
    required String amount,
    required String paymentReference,
    required String channel,
    required String payerReference,
    required String idempotencyKey,
  }) async {
    final client = ref.read(loanManagementServiceClientProvider);
    final response = await client.repaymentRecord(
      RepaymentRecordRequest(
        loanAccountId: loanAccountId,
        amount: amount,
        paymentReference: paymentReference,
        channel: channel,
        payerReference: payerReference,
        idempotencyKey: idempotencyKey,
      ),
    );
    ref.invalidate(repaymentListProvider);
    return response.data;
  }
}
