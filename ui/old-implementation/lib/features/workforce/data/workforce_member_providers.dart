import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import 'workforce_member_status_provider.dart';

part 'workforce_member_providers.g.dart';

@riverpod
Future<List<WorkforceMemberObject>> workforceMemberList(
  Ref ref, {
  required String query,
  String organizationId = '',
  String homeOrgUnitId = '',
}) async {
  final client = ref.watch(identityServiceClientProvider);
  final stream = client.workforceMemberSearch(
    WorkforceMemberSearchRequest(
      query: query,
      organizationId: organizationId,
      homeOrgUnitId: homeOrgUnitId,
      cursor: PageCursor(limit: 50),
    ),
  );
  return collectStream(stream, extract: (response) => response.data);
}

@riverpod
class WorkforceMemberNotifier extends _$WorkforceMemberNotifier {
  @override
  FutureOr<void> build() {}

  Future<WorkforceMemberObject> save(WorkforceMemberObject member) async {
    final client = ref.read(identityServiceClientProvider);
    final response = await client.workforceMemberSave(
      WorkforceMemberSaveRequest(data: member),
    );
    ref.invalidate(workforceMemberListProvider);
    return response.data;
  }

  Future<void> activate(String memberId) async {
    final client = ref.read(identityServiceClientProvider);
    final response = await client.workforceMemberGet(
      WorkforceMemberGetRequest(id: memberId),
    );
    final member = response.data;
    member.state = STATE.ACTIVE;
    await client.workforceMemberSave(
      WorkforceMemberSaveRequest(data: member),
    );
    ref.invalidate(workforceMemberStatusProvider);
  }
}
