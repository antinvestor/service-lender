import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/lender/v1/origination.pb.dart';

part 'underwriting_decision_providers.g.dart';

@riverpod
class UnderwritingDecisionList extends _$UnderwritingDecisionList {
  @override
  Future<List<UnderwritingDecisionObject>> build(String applicationId) async {
    final client = ref.watch(originationServiceClientProvider);
    final request = UnderwritingDecisionSearchRequest(
      applicationId: applicationId,
      cursor: PageCursor(limit: 50),
    );

    final results = <UnderwritingDecisionObject>[];
    await for (final response in client.underwritingDecisionSearch(request)) {
      results.addAll(response.data);
    }
    return results;
  }
}

@riverpod
class UnderwritingDecisionNotifier extends _$UnderwritingDecisionNotifier {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<UnderwritingDecisionObject> save(
      UnderwritingDecisionObject decision) async {
    final client = ref.read(originationServiceClientProvider);
    final response = await client.underwritingDecisionSave(
        UnderwritingDecisionSaveRequest(data: decision));

    ref.invalidate(underwritingDecisionListProvider);

    return response.data;
  }
}
