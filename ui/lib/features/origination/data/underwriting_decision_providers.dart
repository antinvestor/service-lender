import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/origination/v1/origination.pb.dart';

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

    return collectStream(
      client.underwritingDecisionSearch(request),
      extract: (response) => response.data,
    );
  }
}

@riverpod
class UnderwritingDecisionNotifier extends _$UnderwritingDecisionNotifier {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<UnderwritingDecisionObject> save(
    UnderwritingDecisionObject decision,
  ) async {
    final client = ref.read(originationServiceClientProvider);
    final response = await client.underwritingDecisionSave(
      UnderwritingDecisionSaveRequest(data: decision),
    );

    ref.invalidate(underwritingDecisionListProvider);

    return response.data;
  }
}
