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

import 'savings.pb.dart' as $14;
import 'savings.pbjson.dart';

export 'savings.pb.dart';

abstract class SavingsServiceBase extends $pb.GeneratedService {
  $async.Future<$14.SavingsProductSaveResponse> savingsProductSave($pb.ServerContext ctx, $14.SavingsProductSaveRequest request);
  $async.Future<$14.SavingsProductGetResponse> savingsProductGet($pb.ServerContext ctx, $14.SavingsProductGetRequest request);
  $async.Future<$14.SavingsProductSearchResponse> savingsProductSearch($pb.ServerContext ctx, $14.SavingsProductSearchRequest request);
  $async.Future<$14.SavingsAccountCreateResponse> savingsAccountCreate($pb.ServerContext ctx, $14.SavingsAccountCreateRequest request);
  $async.Future<$14.SavingsAccountGetResponse> savingsAccountGet($pb.ServerContext ctx, $14.SavingsAccountGetRequest request);
  $async.Future<$14.SavingsAccountSearchResponse> savingsAccountSearch($pb.ServerContext ctx, $14.SavingsAccountSearchRequest request);
  $async.Future<$14.SavingsAccountFreezeResponse> savingsAccountFreeze($pb.ServerContext ctx, $14.SavingsAccountFreezeRequest request);
  $async.Future<$14.SavingsAccountCloseResponse> savingsAccountClose($pb.ServerContext ctx, $14.SavingsAccountCloseRequest request);
  $async.Future<$14.DepositRecordResponse> depositRecord($pb.ServerContext ctx, $14.DepositRecordRequest request);
  $async.Future<$14.DepositGetResponse> depositGet($pb.ServerContext ctx, $14.DepositGetRequest request);
  $async.Future<$14.DepositSearchResponse> depositSearch($pb.ServerContext ctx, $14.DepositSearchRequest request);
  $async.Future<$14.WithdrawalRequestResponse> withdrawalRequest($pb.ServerContext ctx, $14.WithdrawalRequestRequest request);
  $async.Future<$14.WithdrawalApproveResponse> withdrawalApprove($pb.ServerContext ctx, $14.WithdrawalApproveRequest request);
  $async.Future<$14.WithdrawalCancelResponse> withdrawalCancel($pb.ServerContext ctx, $14.WithdrawalCancelRequest request);
  $async.Future<$14.WithdrawalGetResponse> withdrawalGet($pb.ServerContext ctx, $14.WithdrawalGetRequest request);
  $async.Future<$14.WithdrawalSearchResponse> withdrawalSearch($pb.ServerContext ctx, $14.WithdrawalSearchRequest request);
  $async.Future<$14.InterestAccrualGetResponse> interestAccrualGet($pb.ServerContext ctx, $14.InterestAccrualGetRequest request);
  $async.Future<$14.InterestAccrualSearchResponse> interestAccrualSearch($pb.ServerContext ctx, $14.InterestAccrualSearchRequest request);
  $async.Future<$14.SavingsBalanceGetResponse> savingsBalanceGet($pb.ServerContext ctx, $14.SavingsBalanceGetRequest request);
  $async.Future<$14.SavingsStatementResponse> savingsStatement($pb.ServerContext ctx, $14.SavingsStatementRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'SavingsProductSave': return $14.SavingsProductSaveRequest();
      case 'SavingsProductGet': return $14.SavingsProductGetRequest();
      case 'SavingsProductSearch': return $14.SavingsProductSearchRequest();
      case 'SavingsAccountCreate': return $14.SavingsAccountCreateRequest();
      case 'SavingsAccountGet': return $14.SavingsAccountGetRequest();
      case 'SavingsAccountSearch': return $14.SavingsAccountSearchRequest();
      case 'SavingsAccountFreeze': return $14.SavingsAccountFreezeRequest();
      case 'SavingsAccountClose': return $14.SavingsAccountCloseRequest();
      case 'DepositRecord': return $14.DepositRecordRequest();
      case 'DepositGet': return $14.DepositGetRequest();
      case 'DepositSearch': return $14.DepositSearchRequest();
      case 'WithdrawalRequest': return $14.WithdrawalRequestRequest();
      case 'WithdrawalApprove': return $14.WithdrawalApproveRequest();
      case 'WithdrawalCancel': return $14.WithdrawalCancelRequest();
      case 'WithdrawalGet': return $14.WithdrawalGetRequest();
      case 'WithdrawalSearch': return $14.WithdrawalSearchRequest();
      case 'InterestAccrualGet': return $14.InterestAccrualGetRequest();
      case 'InterestAccrualSearch': return $14.InterestAccrualSearchRequest();
      case 'SavingsBalanceGet': return $14.SavingsBalanceGetRequest();
      case 'SavingsStatement': return $14.SavingsStatementRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'SavingsProductSave': return this.savingsProductSave(ctx, request as $14.SavingsProductSaveRequest);
      case 'SavingsProductGet': return this.savingsProductGet(ctx, request as $14.SavingsProductGetRequest);
      case 'SavingsProductSearch': return this.savingsProductSearch(ctx, request as $14.SavingsProductSearchRequest);
      case 'SavingsAccountCreate': return this.savingsAccountCreate(ctx, request as $14.SavingsAccountCreateRequest);
      case 'SavingsAccountGet': return this.savingsAccountGet(ctx, request as $14.SavingsAccountGetRequest);
      case 'SavingsAccountSearch': return this.savingsAccountSearch(ctx, request as $14.SavingsAccountSearchRequest);
      case 'SavingsAccountFreeze': return this.savingsAccountFreeze(ctx, request as $14.SavingsAccountFreezeRequest);
      case 'SavingsAccountClose': return this.savingsAccountClose(ctx, request as $14.SavingsAccountCloseRequest);
      case 'DepositRecord': return this.depositRecord(ctx, request as $14.DepositRecordRequest);
      case 'DepositGet': return this.depositGet(ctx, request as $14.DepositGetRequest);
      case 'DepositSearch': return this.depositSearch(ctx, request as $14.DepositSearchRequest);
      case 'WithdrawalRequest': return this.withdrawalRequest(ctx, request as $14.WithdrawalRequestRequest);
      case 'WithdrawalApprove': return this.withdrawalApprove(ctx, request as $14.WithdrawalApproveRequest);
      case 'WithdrawalCancel': return this.withdrawalCancel(ctx, request as $14.WithdrawalCancelRequest);
      case 'WithdrawalGet': return this.withdrawalGet(ctx, request as $14.WithdrawalGetRequest);
      case 'WithdrawalSearch': return this.withdrawalSearch(ctx, request as $14.WithdrawalSearchRequest);
      case 'InterestAccrualGet': return this.interestAccrualGet(ctx, request as $14.InterestAccrualGetRequest);
      case 'InterestAccrualSearch': return this.interestAccrualSearch(ctx, request as $14.InterestAccrualSearchRequest);
      case 'SavingsBalanceGet': return this.savingsBalanceGet(ctx, request as $14.SavingsBalanceGetRequest);
      case 'SavingsStatement': return this.savingsStatement(ctx, request as $14.SavingsStatementRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => SavingsServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => SavingsServiceBase$messageJson;
}

