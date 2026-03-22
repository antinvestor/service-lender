import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/operations/v1/operations.pb.dart';

part 'transfer_order_providers.g.dart';

@riverpod
Future<List<TransferOrderObject>> transferOrderList(
  Ref ref, {
  String query = '',
  int? orderType,
}) async {
  final client = ref.watch(operationsServiceClientProvider);
  final request = TransferOrderSearchRequest(
    cursor: PageCursor(limit: 100),
  );
  if (query.isNotEmpty) {
    request.query = query;
  }
  if (orderType != null) {
    request.orderType = orderType;
  }

  final results = <TransferOrderObject>[];
  await for (final response in client.transferOrderSearch(request)) {
    results.addAll(response.data);
  }
  return results;
}
