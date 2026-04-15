import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../core/widgets/money_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/loans/v1/loans.pb.dart';

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
  return collectStream(
    client.repaymentSearch(request),
    extract: (response) => response.data,
  );
}

@riverpod
class RepaymentNotifier extends _$RepaymentNotifier {
  @override
  FutureOr<void> build() {}

  Future<RepaymentObject> record({
    required String loanAccountId,
    required String amount,
    required String currencyCode,
    required String paymentReference,
    required String channel,
    required String payerReference,
    required String idempotencyKey,
  }) async {
    final client = ref.read(loanManagementServiceClientProvider);
    final response = await client.repaymentRecord(
      RepaymentRecordRequest(
        loanAccountId: loanAccountId,
        amount: moneyFromString(amount, currencyCode),
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
