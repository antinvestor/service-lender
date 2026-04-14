import 'package:antinvestor_api_loans/antinvestor_api_loans.dart';
import 'package:antinvestor_ui_core/api/stream_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'loans_transport_provider.dart';

final loanProductListProvider =
    FutureProvider.family<List<LoanProductObject>, String>(
  (ref, query) async {
    final client = ref.watch(loanManagementServiceClientProvider);
    final request = LoanProductSearchRequest(
      query: query,
      cursor: PageCursor(limit: 50),
    );
    return collectStream(
      client.loanProductSearch(request),
      extract: (response) => response.data,
    );
  },
);

final loanProductDetailProvider =
    FutureProvider.family<LoanProductObject, String>(
  (ref, productId) async {
    final client = ref.watch(loanManagementServiceClientProvider);
    final response = await client.loanProductGet(
      LoanProductGetRequest(id: productId),
    );
    return response.data;
  },
);

/// Notifier for loan product mutations. Use via [loanProductNotifierProvider].
class LoanProductNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<LoanProductObject> save(LoanProductObject product) async {
    state = const AsyncLoading();
    try {
      final client = ref.read(loanManagementServiceClientProvider);
      final response = await client.loanProductSave(
        LoanProductSaveRequest(data: product),
      );
      state = const AsyncData(null);
      ref.invalidate(loanProductListProvider);
      return response.data;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final loanProductNotifierProvider =
    NotifierProvider<LoanProductNotifier, AsyncValue<void>>(
  LoanProductNotifier.new,
);
