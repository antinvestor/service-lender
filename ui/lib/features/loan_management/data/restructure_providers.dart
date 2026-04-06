import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/loans/v1/loans.pb.dart';

part 'restructure_providers.g.dart';

@riverpod
class RestructureList extends _$RestructureList {
  @override
  Future<List<LoanRestructureObject>> build(String loanAccountId) async {
    final client = ref.watch(loanManagementServiceClientProvider);
    final request = LoanRestructureSearchRequest(
      loanAccountId: loanAccountId,
      cursor: PageCursor(limit: 50),
    );
    return collectStream(
      client.loanRestructureSearch(request),
      extract: (response) => response.data,
    );
  }
}

@riverpod
class RestructureNotifier extends _$RestructureNotifier {
  @override
  FutureOr<void> build() {}

  Future<LoanRestructureObject> create(LoanRestructureObject data) async {
    final client = ref.read(loanManagementServiceClientProvider);
    final response = await client.loanRestructureCreate(
      LoanRestructureCreateRequest(data: data),
    );
    ref.invalidate(restructureListProvider);
    return response.data;
  }

  Future<LoanRestructureObject> approve(String id) async {
    final client = ref.read(loanManagementServiceClientProvider);
    final response = await client.loanRestructureApprove(
      LoanRestructureApproveRequest(id: id),
    );
    ref.invalidate(restructureListProvider);
    return response.data;
  }

  Future<LoanRestructureObject> reject(String id, String reason) async {
    final client = ref.read(loanManagementServiceClientProvider);
    final response = await client.loanRestructureReject(
      LoanRestructureRejectRequest(id: id, reason: reason),
    );
    ref.invalidate(restructureListProvider);
    return response.data;
  }
}
