import 'package:antinvestor_api_operations/antinvestor_api_operations.dart';
import 'package:antinvestor_ui_core/api/stream_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'operations_transport_provider.dart';

/// List transfer orders, optionally filtered by query and order type.
final transferOrderListProvider = FutureProvider.family<
    List<TransferOrderObject>, ({String query, int? orderType})>(
  (ref, params) async {
    final client = ref.watch(operationsServiceClientProvider);
    final request = TransferOrderSearchRequest(cursor: PageCursor(limit: 100));
    if (params.query.isNotEmpty) {
      request.query = params.query;
    }
    if (params.orderType != null) {
      request.orderType = params.orderType!;
    }

    return collectStream(
      client.transferOrderSearch(request),
      extract: (response) => response.data,
    );
  },
);
