import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/api_provider.dart';
import '../api/stream_helpers.dart';
import '../../sdk/src/common/v1/common.pb.dart';
import '../../sdk/src/origination/v1/origination.pb.dart';

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

/// Entity types that can have form requirements.
///
/// Used as a convention to look up form templates by entity type —
/// templates are tagged in their properties or name to associate them
/// with a specific entity type (client, agent, investor, group).
enum FormEntityType {
  client,
  agent,
  investor,
  group,
}

/// Loads form requirements for a given entity type by searching for
/// published templates associated with that type.
///
/// **Naming convention:** Templates are matched by searching with the entity
/// type name (e.g. "client", "agent", "group"). Admins must include the
/// entity type in the template name or description for it to be discovered.
/// For example, a template named "Client KYC Form" will be found for
/// `FormEntityType.client`.
///
/// TODO: Replace with an explicit `entityType` field on `FormTemplateObject`
/// once the proto is updated, rather than relying on text search.
@riverpod
Future<List<FormTemplateObject>> entityFormTemplates(
  Ref ref, {
  required FormEntityType entityType,
  String organizationId = '',
}) async {
  final client = ref.watch(originationServiceClientProvider);
  final request = FormTemplateSearchRequest(
    query: entityType.name,
    cursor: PageCursor(limit: 20),
  );
  if (organizationId.isNotEmpty) {
    request.organizationId = organizationId;
  }
  final all = await collectStream(
    client.formTemplateSearch(request),
    extract: (response) => response.data,
  );
  // Only return published templates.
  return all
      .where(
        (t) => t.status == FormTemplateStatus.FORM_TEMPLATE_STATUS_PUBLISHED,
      )
      .toList();
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
    // Invalidate only the specific entity's submission list.
    final entityId = response.data.applicationId;
    if (entityId.isNotEmpty) {
      ref.invalidate(
        formSubmissionListProvider(applicationId: entityId),
      );
    }
    return response.data;
  }
}
