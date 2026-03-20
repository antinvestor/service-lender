//
//  Generated code. Do not modify.
//  source: loans/v1/loans.proto
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

import 'loans.pb.dart' as $12;
import 'loans.pbjson.dart';

export 'loans.pb.dart';

abstract class LoanManagementServiceBase extends $pb.GeneratedService {
  $async.Future<$12.LoanAccountCreateResponse> loanAccountCreate($pb.ServerContext ctx, $12.LoanAccountCreateRequest request);
  $async.Future<$12.LoanAccountGetResponse> loanAccountGet($pb.ServerContext ctx, $12.LoanAccountGetRequest request);
  $async.Future<$12.LoanAccountSearchResponse> loanAccountSearch($pb.ServerContext ctx, $12.LoanAccountSearchRequest request);
  $async.Future<$12.LoanBalanceGetResponse> loanBalanceGet($pb.ServerContext ctx, $12.LoanBalanceGetRequest request);
  $async.Future<$12.LoanStatementResponse> loanStatement($pb.ServerContext ctx, $12.LoanStatementRequest request);
  $async.Future<$12.DisbursementCreateResponse> disbursementCreate($pb.ServerContext ctx, $12.DisbursementCreateRequest request);
  $async.Future<$12.DisbursementGetResponse> disbursementGet($pb.ServerContext ctx, $12.DisbursementGetRequest request);
  $async.Future<$12.DisbursementSearchResponse> disbursementSearch($pb.ServerContext ctx, $12.DisbursementSearchRequest request);
  $async.Future<$12.RepaymentRecordResponse> repaymentRecord($pb.ServerContext ctx, $12.RepaymentRecordRequest request);
  $async.Future<$12.RepaymentGetResponse> repaymentGet($pb.ServerContext ctx, $12.RepaymentGetRequest request);
  $async.Future<$12.RepaymentSearchResponse> repaymentSearch($pb.ServerContext ctx, $12.RepaymentSearchRequest request);
  $async.Future<$12.RepaymentScheduleGetResponse> repaymentScheduleGet($pb.ServerContext ctx, $12.RepaymentScheduleGetRequest request);
  $async.Future<$12.PenaltySaveResponse> penaltySave($pb.ServerContext ctx, $12.PenaltySaveRequest request);
  $async.Future<$12.PenaltyWaiveResponse> penaltyWaive($pb.ServerContext ctx, $12.PenaltyWaiveRequest request);
  $async.Future<$12.PenaltySearchResponse> penaltySearch($pb.ServerContext ctx, $12.PenaltySearchRequest request);
  $async.Future<$12.LoanRestructureCreateResponse> loanRestructureCreate($pb.ServerContext ctx, $12.LoanRestructureCreateRequest request);
  $async.Future<$12.LoanRestructureApproveResponse> loanRestructureApprove($pb.ServerContext ctx, $12.LoanRestructureApproveRequest request);
  $async.Future<$12.LoanRestructureRejectResponse> loanRestructureReject($pb.ServerContext ctx, $12.LoanRestructureRejectRequest request);
  $async.Future<$12.LoanRestructureSearchResponse> loanRestructureSearch($pb.ServerContext ctx, $12.LoanRestructureSearchRequest request);
  $async.Future<$12.ReconciliationSaveResponse> reconciliationSave($pb.ServerContext ctx, $12.ReconciliationSaveRequest request);
  $async.Future<$12.ReconciliationSearchResponse> reconciliationSearch($pb.ServerContext ctx, $12.ReconciliationSearchRequest request);
  $async.Future<$12.InitiateCollectionResponse> initiateCollection($pb.ServerContext ctx, $12.InitiateCollectionRequest request);
  $async.Future<$12.LoanStatusChangeSearchResponse> loanStatusChangeSearch($pb.ServerContext ctx, $12.LoanStatusChangeSearchRequest request);
  $async.Future<$12.LoanRequestResponse> loanRequest($pb.ServerContext ctx, $12.LoanRequestRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'LoanAccountCreate': return $12.LoanAccountCreateRequest();
      case 'LoanAccountGet': return $12.LoanAccountGetRequest();
      case 'LoanAccountSearch': return $12.LoanAccountSearchRequest();
      case 'LoanBalanceGet': return $12.LoanBalanceGetRequest();
      case 'LoanStatement': return $12.LoanStatementRequest();
      case 'DisbursementCreate': return $12.DisbursementCreateRequest();
      case 'DisbursementGet': return $12.DisbursementGetRequest();
      case 'DisbursementSearch': return $12.DisbursementSearchRequest();
      case 'RepaymentRecord': return $12.RepaymentRecordRequest();
      case 'RepaymentGet': return $12.RepaymentGetRequest();
      case 'RepaymentSearch': return $12.RepaymentSearchRequest();
      case 'RepaymentScheduleGet': return $12.RepaymentScheduleGetRequest();
      case 'PenaltySave': return $12.PenaltySaveRequest();
      case 'PenaltyWaive': return $12.PenaltyWaiveRequest();
      case 'PenaltySearch': return $12.PenaltySearchRequest();
      case 'LoanRestructureCreate': return $12.LoanRestructureCreateRequest();
      case 'LoanRestructureApprove': return $12.LoanRestructureApproveRequest();
      case 'LoanRestructureReject': return $12.LoanRestructureRejectRequest();
      case 'LoanRestructureSearch': return $12.LoanRestructureSearchRequest();
      case 'ReconciliationSave': return $12.ReconciliationSaveRequest();
      case 'ReconciliationSearch': return $12.ReconciliationSearchRequest();
      case 'InitiateCollection': return $12.InitiateCollectionRequest();
      case 'LoanStatusChangeSearch': return $12.LoanStatusChangeSearchRequest();
      case 'LoanRequest': return $12.LoanRequestRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'LoanAccountCreate': return this.loanAccountCreate(ctx, request as $12.LoanAccountCreateRequest);
      case 'LoanAccountGet': return this.loanAccountGet(ctx, request as $12.LoanAccountGetRequest);
      case 'LoanAccountSearch': return this.loanAccountSearch(ctx, request as $12.LoanAccountSearchRequest);
      case 'LoanBalanceGet': return this.loanBalanceGet(ctx, request as $12.LoanBalanceGetRequest);
      case 'LoanStatement': return this.loanStatement(ctx, request as $12.LoanStatementRequest);
      case 'DisbursementCreate': return this.disbursementCreate(ctx, request as $12.DisbursementCreateRequest);
      case 'DisbursementGet': return this.disbursementGet(ctx, request as $12.DisbursementGetRequest);
      case 'DisbursementSearch': return this.disbursementSearch(ctx, request as $12.DisbursementSearchRequest);
      case 'RepaymentRecord': return this.repaymentRecord(ctx, request as $12.RepaymentRecordRequest);
      case 'RepaymentGet': return this.repaymentGet(ctx, request as $12.RepaymentGetRequest);
      case 'RepaymentSearch': return this.repaymentSearch(ctx, request as $12.RepaymentSearchRequest);
      case 'RepaymentScheduleGet': return this.repaymentScheduleGet(ctx, request as $12.RepaymentScheduleGetRequest);
      case 'PenaltySave': return this.penaltySave(ctx, request as $12.PenaltySaveRequest);
      case 'PenaltyWaive': return this.penaltyWaive(ctx, request as $12.PenaltyWaiveRequest);
      case 'PenaltySearch': return this.penaltySearch(ctx, request as $12.PenaltySearchRequest);
      case 'LoanRestructureCreate': return this.loanRestructureCreate(ctx, request as $12.LoanRestructureCreateRequest);
      case 'LoanRestructureApprove': return this.loanRestructureApprove(ctx, request as $12.LoanRestructureApproveRequest);
      case 'LoanRestructureReject': return this.loanRestructureReject(ctx, request as $12.LoanRestructureRejectRequest);
      case 'LoanRestructureSearch': return this.loanRestructureSearch(ctx, request as $12.LoanRestructureSearchRequest);
      case 'ReconciliationSave': return this.reconciliationSave(ctx, request as $12.ReconciliationSaveRequest);
      case 'ReconciliationSearch': return this.reconciliationSearch(ctx, request as $12.ReconciliationSearchRequest);
      case 'InitiateCollection': return this.initiateCollection(ctx, request as $12.InitiateCollectionRequest);
      case 'LoanStatusChangeSearch': return this.loanStatusChangeSearch(ctx, request as $12.LoanStatusChangeSearchRequest);
      case 'LoanRequest': return this.loanRequest(ctx, request as $12.LoanRequestRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => LoanManagementServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => LoanManagementServiceBase$messageJson;
}

