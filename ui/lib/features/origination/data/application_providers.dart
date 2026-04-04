import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/origination/v1/origination.pb.dart';
import '../../../sdk/src/origination/v1/origination.pbenum.dart';

part 'application_providers.g.dart';

@riverpod
class ApplicationList extends _$ApplicationList {
  @override
  Future<List<ApplicationObject>> build(
    String query, {
    String statusFilter = '',
  }) async {
    final client = ref.watch(originationServiceClientProvider);
    final request = ApplicationSearchRequest(
      query: query,
      cursor: PageCursor(limit: 50),
    );

    if (statusFilter.isNotEmpty) {
      final status = ApplicationStatus.values.firstWhere(
        (s) => s.name == statusFilter,
        orElse: () => ApplicationStatus.APPLICATION_STATUS_UNSPECIFIED,
      );
      if (status != ApplicationStatus.APPLICATION_STATUS_UNSPECIFIED) {
        request.status = status;
      }
    }

    return collectStream(
      client.applicationSearch(request),
      extract: (response) => response.data,
    );
  }
}

@riverpod
class ApplicationDetail extends _$ApplicationDetail {
  @override
  Future<ApplicationObject> build(String id) async {
    final client = ref.watch(originationServiceClientProvider);
    final response =
        await client.applicationGet(ApplicationGetRequest(id: id));
    return response.data;
  }
}

@riverpod
class ApplicationNotifier extends _$ApplicationNotifier {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<ApplicationObject> save(ApplicationObject app) async {
    final client = ref.read(originationServiceClientProvider);
    final response =
        await client.applicationSave(ApplicationSaveRequest(data: app));

    ref.invalidate(applicationListProvider);
    ref.invalidate(applicationDetailProvider);

    return response.data;
  }

  Future<ApplicationObject> submit(String id) async {
    final client = ref.read(originationServiceClientProvider);
    final response =
        await client.applicationSubmit(ApplicationSubmitRequest(id: id));

    ref.invalidate(applicationListProvider);
    ref.invalidate(applicationDetailProvider);

    return response.data;
  }

  Future<ApplicationObject> cancel(String id, String reason) async {
    final client = ref.read(originationServiceClientProvider);
    final response = await client
        .applicationCancel(ApplicationCancelRequest(id: id, reason: reason));

    ref.invalidate(applicationListProvider);
    ref.invalidate(applicationDetailProvider);

    return response.data;
  }

  Future<ApplicationObject> acceptOffer(String id) async {
    final client = ref.read(originationServiceClientProvider);
    final response = await client
        .applicationAcceptOffer(ApplicationAcceptOfferRequest(id: id));

    ref.invalidate(applicationListProvider);
    ref.invalidate(applicationDetailProvider);

    return response.data;
  }

  Future<ApplicationObject> declineOffer(String id, String reason) async {
    final client = ref.read(originationServiceClientProvider);
    final response = await client.applicationDeclineOffer(
        ApplicationDeclineOfferRequest(id: id, reason: reason));

    ref.invalidate(applicationListProvider);
    ref.invalidate(applicationDetailProvider);

    return response.data;
  }
}
