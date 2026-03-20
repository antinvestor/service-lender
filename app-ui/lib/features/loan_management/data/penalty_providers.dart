import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/lender/v1/loan_management.pb.dart';

part 'penalty_providers.g.dart';

@riverpod
Future<List<PenaltyObject>> penaltyList(
  Ref ref, {
  required String loanAccountId,
}) async {
  final client = ref.watch(loanManagementServiceClientProvider);
  final request = PenaltySearchRequest(
    loanAccountId: loanAccountId,
    cursor: PageCursor(limit: 50),
  );
  final results = <PenaltyObject>[];
  await for (final response in client.penaltySearch(request)) {
    results.addAll(response.data);
  }
  return results;
}

@riverpod
class PenaltyNotifier extends _$PenaltyNotifier {
  @override
  FutureOr<void> build() {}

  Future<PenaltyObject> save(PenaltyObject penalty) async {
    final client = ref.read(loanManagementServiceClientProvider);
    final response = await client.penaltySave(
      PenaltySaveRequest(data: penalty),
    );
    ref.invalidate(penaltyListProvider);
    return response.data;
  }

  Future<PenaltyObject> waive({
    required String id,
    required String reason,
  }) async {
    final client = ref.read(loanManagementServiceClientProvider);
    final response = await client.penaltyWaive(
      PenaltyWaiveRequest(id: id, reason: reason),
    );
    ref.invalidate(penaltyListProvider);
    return response.data;
  }
}
