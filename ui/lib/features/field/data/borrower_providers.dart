import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/field/v1/field.pb.dart';

part 'borrower_providers.g.dart';

@riverpod
Future<List<BorrowerObject>> borrowerList(
  Ref ref, {
  required String query,
  required String agentId,
}) async {
  final client = ref.watch(fieldServiceClientProvider);
  final stream = client.borrowerSearch(
    BorrowerSearchRequest(
      query: query,
      agentId: agentId,
      cursor: PageCursor(limit: 50),
    ),
  );
  final borrowers = <BorrowerObject>[];
  await for (final response in stream) {
    borrowers.addAll(response.data);
  }
  return borrowers;
}

@riverpod
class BorrowerNotifier extends _$BorrowerNotifier {
  @override
  FutureOr<void> build() {}

  Future<BorrowerObject> save(BorrowerObject borrower) async {
    final apiClient = ref.read(fieldServiceClientProvider);
    final response = await apiClient.borrowerSave(
      BorrowerSaveRequest(data: borrower),
    );
    ref.invalidate(borrowerListProvider);
    return response.data;
  }
}
