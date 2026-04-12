import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/origination/v1/origination.pb.dart';

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

    return collectStream(
      client.loanProductSearch(request),
      extract: (response) => response.data,
    );
  }
}

@riverpod
Future<LoanProductObject> loanProductDetail(Ref ref, String productId) async {
  final client = ref.watch(originationServiceClientProvider);
  final response = await client.loanProductGet(
    LoanProductGetRequest(id: productId),
  );
  return response.data;
}

@riverpod
class LoanProductNotifier extends _$LoanProductNotifier {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<LoanProductObject> save(LoanProductObject product) async {
    final client = ref.read(originationServiceClientProvider);
    final response = await client.loanProductSave(
      LoanProductSaveRequest(data: product),
    );
    ref.invalidate(loanProductListProvider);
    return response.data;
  }
}
