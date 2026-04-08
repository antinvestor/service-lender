import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/field/v1/field.pb.dart';
import '../../auth/data/agent_status_provider.dart';

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
  return collectStream(
    stream,
    extract: (response) => response.data,
  );
}

@riverpod
class AgentNotifier extends _$AgentNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> save(AgentObject agent) async {
    final client = ref.read(fieldServiceClientProvider);
    await client.agentSave(AgentSaveRequest(data: agent));
    Future.delayed(const Duration(milliseconds: 500), () {
      ref.invalidate(agentListProvider);
    });
  }

  /// Accept Terms & Conditions: fetch the agent, set state to ACTIVE, save.
  Future<void> acceptTerms(String agentId) async {
    final client = ref.read(fieldServiceClientProvider);
    final response = await client.agentGet(AgentGetRequest(id: agentId));
    final agent = response.data;
    agent.state = STATE.ACTIVE;
    await client.agentSave(AgentSaveRequest(data: agent));

    // Invalidate so the router picks up the status change.
    ref.invalidate(agentOnboardingStatusProvider);
  }
}
