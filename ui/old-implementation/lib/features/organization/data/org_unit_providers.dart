import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';

part 'org_unit_providers.g.dart';

@riverpod
Future<List<OrgUnitObject>> orgUnitList(
  Ref ref, {
  String query = '',
  String organizationId = '',
  String parentId = '',
  bool rootOnly = false,
  OrgUnitType type = OrgUnitType.ORG_UNIT_TYPE_UNSPECIFIED,
}) async {
  final client = ref.watch(identityServiceClientProvider);
  final stream = client.orgUnitSearch(
    OrgUnitSearchRequest(
      query: query,
      organizationId: organizationId,
      parentId: parentId,
      rootOnly: rootOnly,
      type: type,
      cursor: PageCursor(limit: 50),
    ),
  );
  return collectStream(stream, extract: (response) => response.data);
}

@riverpod
class OrgUnitNotifier extends _$OrgUnitNotifier {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<void> save(OrgUnitObject orgUnit) async {
    final client = ref.read(identityServiceClientProvider);
    await client.orgUnitSave(OrgUnitSaveRequest(data: orgUnit));
    ref.invalidate(orgUnitListProvider);
  }
}
