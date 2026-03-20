import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/field/v1/field.pb.dart';

part 'agent_providers.g.dart';

@riverpod
Future<List<AgentObject>> agentList(
  Ref ref, {
  required String query,
  required String branchId,
}) async {
  final client = ref.watch(fieldServiceClientProvider);
  final stream = client.agentSearch(
    AgentSearchRequest(
      query: query,
      branchId: branchId,
      cursor: PageCursor(limit: 50),
    ),
  );
  final agents = <AgentObject>[];
  await for (final response in stream) {
    agents.addAll(response.data);
  }
  return agents;
}

@riverpod
class AgentNotifier extends _$AgentNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> save(AgentObject agent) async {
    final client = ref.read(fieldServiceClientProvider);
    await client.agentSave(AgentSaveRequest(data: agent));
    ref.invalidate(agentListProvider);
  }
}
