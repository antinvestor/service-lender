import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/lender/v1/identity.pb.dart';

part 'branch_providers.g.dart';

@riverpod
Future<List<BranchObject>> branchList(
  Ref ref,
  String query,
  String bankId,
) async {
  final client = ref.watch(identityServiceClientProvider);
  final stream = client.branchSearch(
    BranchSearchRequest(
      query: query,
      bankId: bankId,
      cursor: PageCursor(limit: 50),
    ),
  );
  final results = <BranchObject>[];
  await for (final response in stream) {
    results.addAll(response.data);
  }
  return results;
}

@riverpod
class BranchNotifier extends _$BranchNotifier {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<void> save(BranchObject branch) async {
    final client = ref.read(identityServiceClientProvider);
    await client.branchSave(BranchSaveRequest(data: branch));
    ref.invalidate(branchListProvider);
  }
}
