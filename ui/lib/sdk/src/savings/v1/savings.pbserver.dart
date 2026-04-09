//
//  Generated code. Do not modify.
//  source: savings/v1/savings.proto
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

import 'savings.pb.dart' as $15;
import 'savings.pbjson.dart';

export 'savings.pb.dart';

abstract class SavingsServiceBase extends $pb.GeneratedService {
  $async.Future<$15.SavingsProductSaveResponse> savingsProductSave(
      $pb.ServerContext ctx, $15.SavingsProductSaveRequest request);
  $async.Future<$15.SavingsProductGetResponse> savingsProductGet(
      $pb.ServerContext ctx, $15.SavingsProductGetRequest request);
  $async.Future<$15.SavingsProductSearchResponse> savingsProductSearch(
      $pb.ServerContext ctx, $15.SavingsProductSearchRequest request);
  $async.Future<$15.SavingsAccountCreateResponse> savingsAccountCreate(
      $pb.ServerContext ctx, $15.SavingsAccountCreateRequest request);
  $async.Future<$15.SavingsAccountGetResponse> savingsAccountGet(
      $pb.ServerContext ctx, $15.SavingsAccountGetRequest request);
  $async.Future<$15.SavingsAccountSearchResponse> savingsAccountSearch(
      $pb.ServerContext ctx, $15.SavingsAccountSearchRequest request);
  $async.Future<$15.SavingsAccountFreezeResponse> savingsAccountFreeze(
      $pb.ServerContext ctx, $15.SavingsAccountFreezeRequest request);
  $async.Future<$15.SavingsAccountCloseResponse> savingsAccountClose(
      $pb.ServerContext ctx, $15.SavingsAccountCloseRequest request);
  $async.Future<$15.DepositRecordResponse> depositRecord(
      $pb.ServerContext ctx, $15.DepositRecordRequest request);
  $async.Future<$15.DepositGetResponse> depositGet(
      $pb.ServerContext ctx, $15.DepositGetRequest request);
  $async.Future<$15.DepositSearchResponse> depositSearch(
      $pb.ServerContext ctx, $15.DepositSearchRequest request);
  $async.Future<$15.WithdrawalRequestResponse> withdrawalRequest(
      $pb.ServerContext ctx, $15.WithdrawalRequestRequest request);
  $async.Future<$15.WithdrawalApproveResponse> withdrawalApprove(
      $pb.ServerContext ctx, $15.WithdrawalApproveRequest request);
  $async.Future<$15.WithdrawalGetResponse> withdrawalGet(
      $pb.ServerContext ctx, $15.WithdrawalGetRequest request);
  $async.Future<$15.WithdrawalSearchResponse> withdrawalSearch(
      $pb.ServerContext ctx, $15.WithdrawalSearchRequest request);
  $async.Future<$15.InterestAccrualGetResponse> interestAccrualGet(
      $pb.ServerContext ctx, $15.InterestAccrualGetRequest request);
  $async.Future<$15.InterestAccrualSearchResponse> interestAccrualSearch(
      $pb.ServerContext ctx, $15.InterestAccrualSearchRequest request);
  $async.Future<$15.SavingsBalanceGetResponse> savingsBalanceGet(
      $pb.ServerContext ctx, $15.SavingsBalanceGetRequest request);
  $async.Future<$15.SavingsStatementResponse> savingsStatement(
      $pb.ServerContext ctx, $15.SavingsStatementRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'SavingsProductSave':
        return $15.SavingsProductSaveRequest();
      case 'SavingsProductGet':
        return $15.SavingsProductGetRequest();
      case 'SavingsProductSearch':
        return $15.SavingsProductSearchRequest();
      case 'SavingsAccountCreate':
        return $15.SavingsAccountCreateRequest();
      case 'SavingsAccountGet':
        return $15.SavingsAccountGetRequest();
      case 'SavingsAccountSearch':
        return $15.SavingsAccountSearchRequest();
      case 'SavingsAccountFreeze':
        return $15.SavingsAccountFreezeRequest();
      case 'SavingsAccountClose':
        return $15.SavingsAccountCloseRequest();
      case 'DepositRecord':
        return $15.DepositRecordRequest();
      case 'DepositGet':
        return $15.DepositGetRequest();
      case 'DepositSearch':
        return $15.DepositSearchRequest();
      case 'WithdrawalRequest':
        return $15.WithdrawalRequestRequest();
      case 'WithdrawalApprove':
        return $15.WithdrawalApproveRequest();
      case 'WithdrawalGet':
        return $15.WithdrawalGetRequest();
      case 'WithdrawalSearch':
        return $15.WithdrawalSearchRequest();
      case 'InterestAccrualGet':
        return $15.InterestAccrualGetRequest();
      case 'InterestAccrualSearch':
        return $15.InterestAccrualSearchRequest();
      case 'SavingsBalanceGet':
        return $15.SavingsBalanceGetRequest();
      case 'SavingsStatement':
        return $15.SavingsStatementRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'SavingsProductSave':
        return this
            .savingsProductSave(ctx, request as $15.SavingsProductSaveRequest);
      case 'SavingsProductGet':
        return this
            .savingsProductGet(ctx, request as $15.SavingsProductGetRequest);
      case 'SavingsProductSearch':
        return this.savingsProductSearch(
            ctx, request as $15.SavingsProductSearchRequest);
      case 'SavingsAccountCreate':
        return this.savingsAccountCreate(
            ctx, request as $15.SavingsAccountCreateRequest);
      case 'SavingsAccountGet':
        return this
            .savingsAccountGet(ctx, request as $15.SavingsAccountGetRequest);
      case 'SavingsAccountSearch':
        return this.savingsAccountSearch(
            ctx, request as $15.SavingsAccountSearchRequest);
      case 'SavingsAccountFreeze':
        return this.savingsAccountFreeze(
            ctx, request as $15.SavingsAccountFreezeRequest);
      case 'SavingsAccountClose':
        return this.savingsAccountClose(
            ctx, request as $15.SavingsAccountCloseRequest);
      case 'DepositRecord':
        return this.depositRecord(ctx, request as $15.DepositRecordRequest);
      case 'DepositGet':
        return this.depositGet(ctx, request as $15.DepositGetRequest);
      case 'DepositSearch':
        return this.depositSearch(ctx, request as $15.DepositSearchRequest);
      case 'WithdrawalRequest':
        return this
            .withdrawalRequest(ctx, request as $15.WithdrawalRequestRequest);
      case 'WithdrawalApprove':
        return this
            .withdrawalApprove(ctx, request as $15.WithdrawalApproveRequest);
      case 'WithdrawalGet':
        return this.withdrawalGet(ctx, request as $15.WithdrawalGetRequest);
      case 'WithdrawalSearch':
        return this
            .withdrawalSearch(ctx, request as $15.WithdrawalSearchRequest);
      case 'InterestAccrualGet':
        return this
            .interestAccrualGet(ctx, request as $15.InterestAccrualGetRequest);
      case 'InterestAccrualSearch':
        return this.interestAccrualSearch(
            ctx, request as $15.InterestAccrualSearchRequest);
      case 'SavingsBalanceGet':
        return this
            .savingsBalanceGet(ctx, request as $15.SavingsBalanceGetRequest);
      case 'SavingsStatement':
        return this
            .savingsStatement(ctx, request as $15.SavingsStatementRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => SavingsServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => SavingsServiceBase$messageJson;
}
