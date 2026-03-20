import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/lender/v1/loan_management.pb.dart';

part 'disbursement_providers.g.dart';

@riverpod
Future<List<DisbursementObject>> disbursementList(
  Ref ref, {
  required String loanAccountId,
}) async {
  final client = ref.watch(loanManagementServiceClientProvider);
  final request = DisbursementSearchRequest(
    loanAccountId: loanAccountId,
    cursor: PageCursor(limit: 50),
  );
  final results = <DisbursementObject>[];
  await for (final response in client.disbursementSearch(request)) {
    results.addAll(response.data);
  }
  return results;
}

@riverpod
class DisbursementNotifier extends _$DisbursementNotifier {
  @override
  FutureOr<void> build() {}

  Future<DisbursementObject> create({
    required String loanAccountId,
    required String channel,
    required String recipientReference,
    required String idempotencyKey,
  }) async {
    final client = ref.read(loanManagementServiceClientProvider);
    final response = await client.disbursementCreate(
      DisbursementCreateRequest(
        loanAccountId: loanAccountId,
        channel: channel,
        recipientReference: recipientReference,
        idempotencyKey: idempotencyKey,
      ),
    );
    ref.invalidate(disbursementListProvider);
    return response.data;
  }
}
