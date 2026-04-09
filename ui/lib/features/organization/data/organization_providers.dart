import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';

part 'organization_providers.g.dart';

@riverpod
class OrganizationList extends _$OrganizationList {
  @override
  Future<List<OrganizationObject>> build(String query) async {
    final client = ref.watch(identityServiceClientProvider);
    final request = SearchRequest(query: query, cursor: PageCursor(limit: 50));

    return collectStream(
      client.organizationSearch(request),
      extract: (response) => response.data,
    );
  }
}

@riverpod
class OrganizationNotifier extends _$OrganizationNotifier {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<OrganizationObject> save(OrganizationObject organization) async {
    final client = ref.read(identityServiceClientProvider);
    final response = await client.organizationSave(
      OrganizationSaveRequest(data: organization),
    );

    // Delay the list refresh slightly to allow the async event handler
    // to commit to the database before we query.
    Future.delayed(const Duration(milliseconds: 500), () {
      ref.invalidate(organizationListProvider);
    });

    return response.data;
  }
}
