//
//  Generated code. Do not modify.
//  source: operations/v1/operations.proto
//

import "package:connectrpc/connect.dart" as connect;
import "operations.pb.dart" as operationsv1operations;

abstract final class OperationsService {
  /// Fully-qualified name of the OperationsService service.
  static const name = 'operations.v1.OperationsService';

  static const transferOrderExecute = connect.Spec(
    '/$name/TransferOrderExecute',
    connect.StreamType.unary,
    operationsv1operations.TransferOrderExecuteRequest.new,
    operationsv1operations.TransferOrderExecuteResponse.new,
  );

  static const transferOrderSearch = connect.Spec(
    '/$name/TransferOrderSearch',
    connect.StreamType.server,
    operationsv1operations.TransferOrderSearchRequest.new,
    operationsv1operations.TransferOrderSearchResponse.new,
  );
}
