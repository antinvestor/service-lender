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

import 'savings.pb.dart' as $9;
import 'savings.pbjson.dart';

export 'savings.pb.dart';

abstract class SavingsServiceBase extends $pb.GeneratedService {
  $async.Future<$9.SavingsProductSaveResponse> savingsProductSave($pb.ServerContext ctx, $9.SavingsProductSaveRequest request);
  $async.Future<$9.SavingsProductGetResponse> savingsProductGet($pb.ServerContext ctx, $9.SavingsProductGetRequest request);
  $async.Future<$9.SavingsProductSearchResponse> savingsProductSearch($pb.ServerContext ctx, $9.SavingsProductSearchRequest request);
  $async.Future<$9.SavingsAccountCreateResponse> savingsAccountCreate($pb.ServerContext ctx, $9.SavingsAccountCreateRequest request);
  $async.Future<$9.SavingsAccountGetResponse> savingsAccountGet($pb.ServerContext ctx, $9.SavingsAccountGetRequest request);
  $async.Future<$9.SavingsAccountSearchResponse> savingsAccountSearch($pb.ServerContext ctx, $9.SavingsAccountSearchRequest request);
  $async.Future<$9.SavingsAccountFreezeResponse> savingsAccountFreeze($pb.ServerContext ctx, $9.SavingsAccountFreezeRequest request);
  $async.Future<$9.SavingsAccountCloseResponse> savingsAccountClose($pb.ServerContext ctx, $9.SavingsAccountCloseRequest request);
  $async.Future<$9.DepositRecordResponse> depositRecord($pb.ServerContext ctx, $9.DepositRecordRequest request);
  $async.Future<$9.DepositGetResponse> depositGet($pb.ServerContext ctx, $9.DepositGetRequest request);
  $async.Future<$9.DepositSearchResponse> depositSearch($pb.ServerContext ctx, $9.DepositSearchRequest request);
  $async.Future<$9.WithdrawalRequestResponse> withdrawalRequest($pb.ServerContext ctx, $9.WithdrawalRequestRequest request);
  $async.Future<$9.WithdrawalApproveResponse> withdrawalApprove($pb.ServerContext ctx, $9.WithdrawalApproveRequest request);
  $async.Future<$9.WithdrawalCancelResponse> withdrawalCancel($pb.ServerContext ctx, $9.WithdrawalCancelRequest request);
  $async.Future<$9.WithdrawalGetResponse> withdrawalGet($pb.ServerContext ctx, $9.WithdrawalGetRequest request);
  $async.Future<$9.WithdrawalSearchResponse> withdrawalSearch($pb.ServerContext ctx, $9.WithdrawalSearchRequest request);
  $async.Future<$9.InterestAccrualGetResponse> interestAccrualGet($pb.ServerContext ctx, $9.InterestAccrualGetRequest request);
  $async.Future<$9.InterestAccrualSearchResponse> interestAccrualSearch($pb.ServerContext ctx, $9.InterestAccrualSearchRequest request);
  $async.Future<$9.SavingsBalanceGetResponse> savingsBalanceGet($pb.ServerContext ctx, $9.SavingsBalanceGetRequest request);
  $async.Future<$9.SavingsStatementResponse> savingsStatement($pb.ServerContext ctx, $9.SavingsStatementRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'SavingsProductSave': return $9.SavingsProductSaveRequest();
      case 'SavingsProductGet': return $9.SavingsProductGetRequest();
      case 'SavingsProductSearch': return $9.SavingsProductSearchRequest();
      case 'SavingsAccountCreate': return $9.SavingsAccountCreateRequest();
      case 'SavingsAccountGet': return $9.SavingsAccountGetRequest();
      case 'SavingsAccountSearch': return $9.SavingsAccountSearchRequest();
      case 'SavingsAccountFreeze': return $9.SavingsAccountFreezeRequest();
      case 'SavingsAccountClose': return $9.SavingsAccountCloseRequest();
      case 'DepositRecord': return $9.DepositRecordRequest();
      case 'DepositGet': return $9.DepositGetRequest();
      case 'DepositSearch': return $9.DepositSearchRequest();
      case 'WithdrawalRequest': return $9.WithdrawalRequestRequest();
      case 'WithdrawalApprove': return $9.WithdrawalApproveRequest();
      case 'WithdrawalCancel': return $9.WithdrawalCancelRequest();
      case 'WithdrawalGet': return $9.WithdrawalGetRequest();
      case 'WithdrawalSearch': return $9.WithdrawalSearchRequest();
      case 'InterestAccrualGet': return $9.InterestAccrualGetRequest();
      case 'InterestAccrualSearch': return $9.InterestAccrualSearchRequest();
      case 'SavingsBalanceGet': return $9.SavingsBalanceGetRequest();
      case 'SavingsStatement': return $9.SavingsStatementRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'SavingsProductSave': return this.savingsProductSave(ctx, request as $9.SavingsProductSaveRequest);
      case 'SavingsProductGet': return this.savingsProductGet(ctx, request as $9.SavingsProductGetRequest);
      case 'SavingsProductSearch': return this.savingsProductSearch(ctx, request as $9.SavingsProductSearchRequest);
      case 'SavingsAccountCreate': return this.savingsAccountCreate(ctx, request as $9.SavingsAccountCreateRequest);
      case 'SavingsAccountGet': return this.savingsAccountGet(ctx, request as $9.SavingsAccountGetRequest);
      case 'SavingsAccountSearch': return this.savingsAccountSearch(ctx, request as $9.SavingsAccountSearchRequest);
      case 'SavingsAccountFreeze': return this.savingsAccountFreeze(ctx, request as $9.SavingsAccountFreezeRequest);
      case 'SavingsAccountClose': return this.savingsAccountClose(ctx, request as $9.SavingsAccountCloseRequest);
      case 'DepositRecord': return this.depositRecord(ctx, request as $9.DepositRecordRequest);
      case 'DepositGet': return this.depositGet(ctx, request as $9.DepositGetRequest);
      case 'DepositSearch': return this.depositSearch(ctx, request as $9.DepositSearchRequest);
      case 'WithdrawalRequest': return this.withdrawalRequest(ctx, request as $9.WithdrawalRequestRequest);
      case 'WithdrawalApprove': return this.withdrawalApprove(ctx, request as $9.WithdrawalApproveRequest);
      case 'WithdrawalCancel': return this.withdrawalCancel(ctx, request as $9.WithdrawalCancelRequest);
      case 'WithdrawalGet': return this.withdrawalGet(ctx, request as $9.WithdrawalGetRequest);
      case 'WithdrawalSearch': return this.withdrawalSearch(ctx, request as $9.WithdrawalSearchRequest);
      case 'InterestAccrualGet': return this.interestAccrualGet(ctx, request as $9.InterestAccrualGetRequest);
      case 'InterestAccrualSearch': return this.interestAccrualSearch(ctx, request as $9.InterestAccrualSearchRequest);
      case 'SavingsBalanceGet': return this.savingsBalanceGet(ctx, request as $9.SavingsBalanceGetRequest);
      case 'SavingsStatement': return this.savingsStatement(ctx, request as $9.SavingsStatementRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => SavingsServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => SavingsServiceBase$messageJson;
}

