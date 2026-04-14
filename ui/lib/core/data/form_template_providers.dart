import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/api_provider.dart';
import '../api/stream_helpers.dart';
import '../../sdk/src/common/v1/common.pb.dart';
import '../../sdk/src/identity/v1/identity.pb.dart';

part 'form_template_providers.g.dart';

@riverpod
class FormTemplateList extends _$FormTemplateList {
  @override
  Future<List<FormTemplateObject>> build(
    String query, {
    String organizationId = '',
  }) async {
    final client = ref.watch(identityServiceClientProvider);
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
    final client = ref.watch(identityServiceClientProvider);
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
    final client = ref.read(identityServiceClientProvider);
    final response = await client.formTemplateSave(
      FormTemplateSaveRequest(data: template),
    );
    ref.invalidate(formTemplateListProvider);
    ref.invalidate(formTemplateDetailProvider(response.data.id));
    return response.data;
  }

  Future<FormTemplateObject> publish(String id) async {
    final client = ref.read(identityServiceClientProvider);
    final response = await client.formTemplatePublish(
      FormTemplatePublishRequest(id: id),
    );
    ref.invalidate(formTemplateListProvider);
    ref.invalidate(formTemplateDetailProvider(id));
    return response.data;
  }
}

/// Entity types that can have form requirements.
///
/// Maps directly to `FormTemplateObject.entity_type` in the proto.
enum FormEntityType {
  client,
  agent,
  investor,
  group,
  application,
}

/// Loads published form templates for a given entity type.
///
/// Uses the `entity_type` field on `FormTemplateSearchRequest` to filter
/// templates explicitly tagged for the requested domain. Admins set the
/// entity type when creating templates in the form template designer.
@riverpod
Future<List<FormTemplateObject>> entityFormTemplates(
  Ref ref, {
  required FormEntityType entityType,
  String organizationId = '',
}) async {
  final client = ref.watch(identityServiceClientProvider);
  final request = FormTemplateSearchRequest(
    entityType: entityType.name,
    status: FormTemplateStatus.FORM_TEMPLATE_STATUS_PUBLISHED,
    cursor: PageCursor(limit: 20),
  );
  if (organizationId.isNotEmpty) {
    request.organizationId = organizationId;
  }
  return collectStream(
    client.formTemplateSearch(request),
    extract: (response) => response.data,
  );
}

@riverpod
class FormSubmissionList extends _$FormSubmissionList {
  @override
  Future<List<FormSubmissionObject>> build({
    required String entityId,
  }) async {
    final client = ref.watch(identityServiceClientProvider);
    final request = FormSubmissionSearchRequest(
      entityId: entityId,
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
    final client = ref.read(identityServiceClientProvider);
    final response = await client.formSubmissionSave(
      FormSubmissionSaveRequest(data: submission),
    );
    // Invalidate only the specific entity's submission list.
    final entityId = response.data.entityId;
    if (entityId.isNotEmpty) {
      ref.invalidate(
        formSubmissionListProvider(entityId: entityId),
      );
    }
    return response.data;
  }
}
