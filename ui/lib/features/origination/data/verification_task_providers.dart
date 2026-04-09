import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/google/protobuf/struct.pb.dart' as struct_pb;
import '../../../sdk/src/origination/v1/origination.pb.dart';

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

    return collectStream(
      client.verificationTaskSearch(request),
      extract: (response) => response.data,
    );
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
    final response = await client.verificationTaskSave(
      VerificationTaskSaveRequest(data: task),
    );

    ref.invalidate(verificationTaskListProvider);

    return response.data;
  }

  Future<VerificationTaskObject> complete(
    String id,
    VerificationStatus status,
    String notes, {
    struct_pb.Struct? results,
  }) async {
    final client = ref.read(originationServiceClientProvider);
    final request = VerificationTaskCompleteRequest(
      id: id,
      status: status,
      notes: notes,
    );
    if (results != null) {
      request.results = results;
    }
    final response = await client.verificationTaskComplete(request);

    ref.invalidate(verificationTaskListProvider);

    return response.data;
  }
}
