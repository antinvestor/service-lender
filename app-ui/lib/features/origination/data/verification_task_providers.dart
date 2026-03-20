import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/lender/v1/origination.pb.dart';
import '../../../sdk/src/lender/v1/origination.pbenum.dart';

part 'verification_task_providers.g.dart';

@riverpod
class VerificationTaskList extends _$VerificationTaskList {
  @override
  Future<List<VerificationTaskObject>> build(String applicationId) async {
    final client = ref.watch(originationServiceClientProvider);
    final request = VerificationTaskSearchRequest(
      applicationId: applicationId,
      cursor: PageCursor(limit: 50),
    );

    final results = <VerificationTaskObject>[];
    await for (final response in client.verificationTaskSearch(request)) {
      results.addAll(response.data);
    }
    return results;
  }
}

@riverpod
class VerificationTaskNotifier extends _$VerificationTaskNotifier {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<VerificationTaskObject> save(VerificationTaskObject task) async {
    final client = ref.read(originationServiceClientProvider);
    final response = await client
        .verificationTaskSave(VerificationTaskSaveRequest(data: task));

    ref.invalidate(verificationTaskListProvider);

    return response.data;
  }

  Future<VerificationTaskObject> complete(
    String id,
    VerificationStatus status,
    String notes,
  ) async {
    final client = ref.read(originationServiceClientProvider);
    final response =
        await client.verificationTaskComplete(VerificationTaskCompleteRequest(
      id: id,
      status: status,
      notes: notes,
    ));

    ref.invalidate(verificationTaskListProvider);

    return response.data;
  }
}
