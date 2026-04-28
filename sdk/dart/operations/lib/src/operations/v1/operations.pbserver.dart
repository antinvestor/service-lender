//
//  Generated code. Do not modify.
//  source: operations/v1/operations.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'operations.pb.dart' as $9;
import 'operations.pbjson.dart';

export 'operations.pb.dart';

abstract class OperationsServiceBase extends $pb.GeneratedService {
  $async.Future<$9.TransferOrderExecuteResponse> transferOrderExecute($pb.ServerContext ctx, $9.TransferOrderExecuteRequest request);
  $async.Future<$9.TransferOrderSearchResponse> transferOrderSearch($pb.ServerContext ctx, $9.TransferOrderSearchRequest request);
  $async.Future<$9.IncomingPaymentNotifyResponse> incomingPaymentNotify($pb.ServerContext ctx, $9.IncomingPaymentNotifyRequest request);
  $async.Future<$9.PaymentAllocateResponse> paymentAllocate($pb.ServerContext ctx, $9.PaymentAllocateRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'TransferOrderExecute': return $9.TransferOrderExecuteRequest();
      case 'TransferOrderSearch': return $9.TransferOrderSearchRequest();
      case 'IncomingPaymentNotify': return $9.IncomingPaymentNotifyRequest();
      case 'PaymentAllocate': return $9.PaymentAllocateRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'TransferOrderExecute': return this.transferOrderExecute(ctx, request as $9.TransferOrderExecuteRequest);
      case 'TransferOrderSearch': return this.transferOrderSearch(ctx, request as $9.TransferOrderSearchRequest);
      case 'IncomingPaymentNotify': return this.incomingPaymentNotify(ctx, request as $9.IncomingPaymentNotifyRequest);
      case 'PaymentAllocate': return this.paymentAllocate(ctx, request as $9.PaymentAllocateRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => OperationsServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => OperationsServiceBase$messageJson;
}

