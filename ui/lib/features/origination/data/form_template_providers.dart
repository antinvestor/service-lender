import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/origination/v1/origination.pb.dart';

part 'form_template_providers.g.dart';

@riverpod
class FormTemplateList extends _$FormTemplateList {
  @override
  Future<List<FormTemplateObject>> build(
    String query, {
    String organizationId = '',
  }) async {
    final client = ref.watch(originationServiceClientProvider);
    final request = FormTemplateSearchRequest(
      query: query,
      cursor: PageCursor(limit: 50),
    );

    if (organizationId.isNotEmpty) {
      request.organizationId = organizationId;
    }

    return collectStream(
      client.formTemplateSearch(request),
      extract: (response) => response.data,
    );
  }
}

@riverpod
class FormTemplateDetail extends _$FormTemplateDetail {
  @override
  Future<FormTemplateObject> build(String id) async {
    final client = ref.watch(originationServiceClientProvider);
    final response = await client.formTemplateGet(FormTemplateGetRequest(id: id));
    return response.data;
  }
}

@riverpod
class FormTemplateNotifier extends _$FormTemplateNotifier {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<FormTemplateObject> save(FormTemplateObject template) async {
    final client = ref.read(originationServiceClientProvider);
    final response = await client.formTemplateSave(
      FormTemplateSaveRequest(data: template),
    );
    ref.invalidate(formTemplateListProvider);
    ref.invalidate(formTemplateDetailProvider(response.data.id));
    return response.data;
  }

  Future<FormTemplateObject> publish(String id) async {
    final client = ref.read(originationServiceClientProvider);
    final response = await client.formTemplatePublish(
      FormTemplatePublishRequest(id: id),
    );
    ref.invalidate(formTemplateListProvider);
    ref.invalidate(formTemplateDetailProvider(id));
    return response.data;
  }
}

@riverpod
class FormSubmissionList extends _$FormSubmissionList {
  @override
  Future<List<FormSubmissionObject>> build({
    required String applicationId,
  }) async {
    final client = ref.watch(originationServiceClientProvider);
    final request = FormSubmissionSearchRequest(
      applicationId: applicationId,
      cursor: PageCursor(limit: 50),
    );

    return collectStream(
      client.formSubmissionSearch(request),
      extract: (response) => response.data,
    );
  }
}

@riverpod
class FormSubmissionNotifier extends _$FormSubmissionNotifier {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<FormSubmissionObject> save(FormSubmissionObject submission) async {
    final client = ref.read(originationServiceClientProvider);
    final response = await client.formSubmissionSave(
      FormSubmissionSaveRequest(data: submission),
    );
    ref.invalidate(formSubmissionListProvider);
    return response.data;
  }
}
