//
//  Generated code. Do not modify.
//  source: funding/v1/funding.proto
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

import 'funding.pb.dart' as $10;
import 'funding.pbjson.dart';

export 'funding.pb.dart';

abstract class FundingServiceBase extends $pb.GeneratedService {
  $async.Future<$10.InvestorAccountSaveResponse> investorAccountSave($pb.ServerContext ctx, $10.InvestorAccountSaveRequest request);
  $async.Future<$10.InvestorAccountGetResponse> investorAccountGet($pb.ServerContext ctx, $10.InvestorAccountGetRequest request);
  $async.Future<$10.InvestorAccountSearchResponse> investorAccountSearch($pb.ServerContext ctx, $10.InvestorAccountSearchRequest request);
  $async.Future<$10.InvestorDepositResponse> investorDeposit($pb.ServerContext ctx, $10.InvestorDepositRequest request);
  $async.Future<$10.InvestorWithdrawResponse> investorWithdraw($pb.ServerContext ctx, $10.InvestorWithdrawRequest request);
  $async.Future<$10.FundLoanResponse> fundLoan($pb.ServerContext ctx, $10.FundLoanRequest request);
  $async.Future<$10.AbsorbLossResponse> absorbLoss($pb.ServerContext ctx, $10.AbsorbLossRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'InvestorAccountSave': return $10.InvestorAccountSaveRequest();
      case 'InvestorAccountGet': return $10.InvestorAccountGetRequest();
      case 'InvestorAccountSearch': return $10.InvestorAccountSearchRequest();
      case 'InvestorDeposit': return $10.InvestorDepositRequest();
      case 'InvestorWithdraw': return $10.InvestorWithdrawRequest();
      case 'FundLoan': return $10.FundLoanRequest();
      case 'AbsorbLoss': return $10.AbsorbLossRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'InvestorAccountSave': return this.investorAccountSave(ctx, request as $10.InvestorAccountSaveRequest);
      case 'InvestorAccountGet': return this.investorAccountGet(ctx, request as $10.InvestorAccountGetRequest);
      case 'InvestorAccountSearch': return this.investorAccountSearch(ctx, request as $10.InvestorAccountSearchRequest);
      case 'InvestorDeposit': return this.investorDeposit(ctx, request as $10.InvestorDepositRequest);
      case 'InvestorWithdraw': return this.investorWithdraw(ctx, request as $10.InvestorWithdrawRequest);
      case 'FundLoan': return this.fundLoan(ctx, request as $10.FundLoanRequest);
      case 'AbsorbLoss': return this.absorbLoss(ctx, request as $10.AbsorbLossRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => FundingServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => FundingServiceBase$messageJson;
}

