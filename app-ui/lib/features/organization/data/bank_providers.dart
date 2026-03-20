import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';

part 'bank_providers.g.dart';

@riverpod
class BankList extends _$BankList {
  @override
  Future<List<BankObject>> build(String query) async {
    final client = ref.watch(identityServiceClientProvider);
    final request = SearchRequest(
      query: query,
      cursor: PageCursor(limit: 50),
    );

    final results = <BankObject>[];
    await for (final response in client.bankSearch(request)) {
      results.addAll(response.data);
    }
    return results;
  }
}

@riverpod
class BankNotifier extends _$BankNotifier {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<BankObject> save(BankObject bank) async {
    final client = ref.read(identityServiceClientProvider);
    final response = await client.bankSave(BankSaveRequest(data: bank));

    // Invalidate all bank list queries so they re-fetch.
    ref.invalidate(bankListProvider);

    return response.data;
  }
}
