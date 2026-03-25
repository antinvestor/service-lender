import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';

part 'investor_providers.g.dart';

@riverpod
Future<List<InvestorObject>> investorList(
  Ref ref, {
  required String query,
}) async {
  final client = ref.watch(identityServiceClientProvider);
  final stream = client.investorSearch(
    InvestorSearchRequest(
      query: query,
      cursor: PageCursor(limit: 50),
    ),
  );
  final investors = <InvestorObject>[];
  await for (final response in stream) {
    investors.addAll(response.data);
  }
  return investors;
}

@riverpod
class InvestorNotifier extends _$InvestorNotifier {
  @override
  FutureOr<void> build() {}

  Future<InvestorObject> save(InvestorObject investor) async {
    final apiClient = ref.read(identityServiceClientProvider);
    final response = await apiClient.investorSave(
      InvestorSaveRequest(data: investor),
    );
    ref.invalidate(investorListProvider);
    return response.data;
  }
}
