import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/lender/v1/origination.pb.dart';

part 'loan_product_providers.g.dart';

@riverpod
class LoanProductList extends _$LoanProductList {
  @override
  Future<List<LoanProductObject>> build(String query) async {
    final client = ref.watch(originationServiceClientProvider);
    final request = LoanProductSearchRequest(
      query: query,
      cursor: PageCursor(limit: 50),
    );

    final results = <LoanProductObject>[];
    await for (final response in client.loanProductSearch(request)) {
      results.addAll(response.data);
    }
    return results;
  }
}

@riverpod
class LoanProductNotifier extends _$LoanProductNotifier {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<LoanProductObject> save(LoanProductObject product) async {
    final client = ref.read(originationServiceClientProvider);
    final response =
        await client.loanProductSave(LoanProductSaveRequest(data: product));

    // Invalidate all loan product list queries so they re-fetch.
    ref.invalidate(loanProductListProvider);

    return response.data;
  }
}
