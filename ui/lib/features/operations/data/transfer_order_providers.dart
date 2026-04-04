import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
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

  return collectStream(
    client.transferOrderSearch(request),
    extract: (response) => response.data,
  );
}
