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

import 'loans.pb.dart' as $9;
import 'loans.pbjson.dart';

export 'loans.pb.dart';

abstract class LoanManagementServiceBase extends $pb.GeneratedService {
  $async.Future<$9.LoanProductSaveResponse> loanProductSave($pb.ServerContext ctx, $9.LoanProductSaveRequest request);
  $async.Future<$9.LoanProductGetResponse> loanProductGet($pb.ServerContext ctx, $9.LoanProductGetRequest request);
  $async.Future<$9.LoanProductSearchResponse> loanProductSearch($pb.ServerContext ctx, $9.LoanProductSearchRequest request);
  $async.Future<$9.LoanRequestSaveResponse> loanRequestSave($pb.ServerContext ctx, $9.LoanRequestSaveRequest request);
  $async.Future<$9.LoanRequestGetResponse> loanRequestGet($pb.ServerContext ctx, $9.LoanRequestGetRequest request);
  $async.Future<$9.LoanRequestSearchResponse> loanRequestSearch($pb.ServerContext ctx, $9.LoanRequestSearchRequest request);
  $async.Future<$9.LoanRequestApproveResponse> loanRequestApprove($pb.ServerContext ctx, $9.LoanRequestApproveRequest request);
  $async.Future<$9.LoanRequestRejectResponse> loanRequestReject($pb.ServerContext ctx, $9.LoanRequestRejectRequest request);
  $async.Future<$9.LoanRequestCancelResponse> loanRequestCancel($pb.ServerContext ctx, $9.LoanRequestCancelRequest request);
  $async.Future<$9.ClientProductAccessSaveResponse> clientProductAccessSave($pb.ServerContext ctx, $9.ClientProductAccessSaveRequest request);
  $async.Future<$9.ClientProductAccessGetResponse> clientProductAccessGet($pb.ServerContext ctx, $9.ClientProductAccessGetRequest request);
  $async.Future<$9.ClientProductAccessSearchResponse> clientProductAccessSearch($pb.ServerContext ctx, $9.ClientProductAccessSearchRequest request);
  $async.Future<$9.LoanAccountCreateResponse> loanAccountCreate($pb.ServerContext ctx, $9.LoanAccountCreateRequest request);
  $async.Future<$9.LoanAccountGetResponse> loanAccountGet($pb.ServerContext ctx, $9.LoanAccountGetRequest request);
  $async.Future<$9.LoanAccountSearchResponse> loanAccountSearch($pb.ServerContext ctx, $9.LoanAccountSearchRequest request);
  $async.Future<$9.LoanBalanceGetResponse> loanBalanceGet($pb.ServerContext ctx, $9.LoanBalanceGetRequest request);
  $async.Future<$9.LoanStatementResponse> loanStatement($pb.ServerContext ctx, $9.LoanStatementRequest request);
  $async.Future<$9.DisbursementCreateResponse> disbursementCreate($pb.ServerContext ctx, $9.DisbursementCreateRequest request);
  $async.Future<$9.DisbursementGetResponse> disbursementGet($pb.ServerContext ctx, $9.DisbursementGetRequest request);
  $async.Future<$9.DisbursementSearchResponse> disbursementSearch($pb.ServerContext ctx, $9.DisbursementSearchRequest request);
  $async.Future<$9.RepaymentRecordResponse> repaymentRecord($pb.ServerContext ctx, $9.RepaymentRecordRequest request);
  $async.Future<$9.RepaymentGetResponse> repaymentGet($pb.ServerContext ctx, $9.RepaymentGetRequest request);
  $async.Future<$9.RepaymentSearchResponse> repaymentSearch($pb.ServerContext ctx, $9.RepaymentSearchRequest request);
  $async.Future<$9.RepaymentScheduleGetResponse> repaymentScheduleGet($pb.ServerContext ctx, $9.RepaymentScheduleGetRequest request);
  $async.Future<$9.PenaltySaveResponse> penaltySave($pb.ServerContext ctx, $9.PenaltySaveRequest request);
  $async.Future<$9.PenaltyWaiveResponse> penaltyWaive($pb.ServerContext ctx, $9.PenaltyWaiveRequest request);
  $async.Future<$9.PenaltySearchResponse> penaltySearch($pb.ServerContext ctx, $9.PenaltySearchRequest request);
  $async.Future<$9.LoanRestructureCreateResponse> loanRestructureCreate($pb.ServerContext ctx, $9.LoanRestructureCreateRequest request);
  $async.Future<$9.LoanRestructureApproveResponse> loanRestructureApprove($pb.ServerContext ctx, $9.LoanRestructureApproveRequest request);
  $async.Future<$9.LoanRestructureRejectResponse> loanRestructureReject($pb.ServerContext ctx, $9.LoanRestructureRejectRequest request);
  $async.Future<$9.LoanRestructureSearchResponse> loanRestructureSearch($pb.ServerContext ctx, $9.LoanRestructureSearchRequest request);
  $async.Future<$9.ReconciliationSaveResponse> reconciliationSave($pb.ServerContext ctx, $9.ReconciliationSaveRequest request);
  $async.Future<$9.ReconciliationSearchResponse> reconciliationSearch($pb.ServerContext ctx, $9.ReconciliationSearchRequest request);
  $async.Future<$9.InitiateCollectionResponse> initiateCollection($pb.ServerContext ctx, $9.InitiateCollectionRequest request);
  $async.Future<$9.LoanStatusChangeSearchResponse> loanStatusChangeSearch($pb.ServerContext ctx, $9.LoanStatusChangeSearchRequest request);
  $async.Future<$9.PortfolioSummaryResponse> portfolioSummary($pb.ServerContext ctx, $9.PortfolioSummaryRequest request);
  $async.Future<$9.PortfolioExportResponse> portfolioExport($pb.ServerContext ctx, $9.PortfolioExportRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'LoanProductSave': return $9.LoanProductSaveRequest();
      case 'LoanProductGet': return $9.LoanProductGetRequest();
      case 'LoanProductSearch': return $9.LoanProductSearchRequest();
      case 'LoanRequestSave': return $9.LoanRequestSaveRequest();
      case 'LoanRequestGet': return $9.LoanRequestGetRequest();
      case 'LoanRequestSearch': return $9.LoanRequestSearchRequest();
      case 'LoanRequestApprove': return $9.LoanRequestApproveRequest();
      case 'LoanRequestReject': return $9.LoanRequestRejectRequest();
      case 'LoanRequestCancel': return $9.LoanRequestCancelRequest();
      case 'ClientProductAccessSave': return $9.ClientProductAccessSaveRequest();
      case 'ClientProductAccessGet': return $9.ClientProductAccessGetRequest();
      case 'ClientProductAccessSearch': return $9.ClientProductAccessSearchRequest();
      case 'LoanAccountCreate': return $9.LoanAccountCreateRequest();
      case 'LoanAccountGet': return $9.LoanAccountGetRequest();
      case 'LoanAccountSearch': return $9.LoanAccountSearchRequest();
      case 'LoanBalanceGet': return $9.LoanBalanceGetRequest();
      case 'LoanStatement': return $9.LoanStatementRequest();
      case 'DisbursementCreate': return $9.DisbursementCreateRequest();
      case 'DisbursementGet': return $9.DisbursementGetRequest();
      case 'DisbursementSearch': return $9.DisbursementSearchRequest();
      case 'RepaymentRecord': return $9.RepaymentRecordRequest();
      case 'RepaymentGet': return $9.RepaymentGetRequest();
      case 'RepaymentSearch': return $9.RepaymentSearchRequest();
      case 'RepaymentScheduleGet': return $9.RepaymentScheduleGetRequest();
      case 'PenaltySave': return $9.PenaltySaveRequest();
      case 'PenaltyWaive': return $9.PenaltyWaiveRequest();
      case 'PenaltySearch': return $9.PenaltySearchRequest();
      case 'LoanRestructureCreate': return $9.LoanRestructureCreateRequest();
      case 'LoanRestructureApprove': return $9.LoanRestructureApproveRequest();
      case 'LoanRestructureReject': return $9.LoanRestructureRejectRequest();
      case 'LoanRestructureSearch': return $9.LoanRestructureSearchRequest();
      case 'ReconciliationSave': return $9.ReconciliationSaveRequest();
      case 'ReconciliationSearch': return $9.ReconciliationSearchRequest();
      case 'InitiateCollection': return $9.InitiateCollectionRequest();
      case 'LoanStatusChangeSearch': return $9.LoanStatusChangeSearchRequest();
      case 'PortfolioSummary': return $9.PortfolioSummaryRequest();
      case 'PortfolioExport': return $9.PortfolioExportRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'LoanProductSave': return this.loanProductSave(ctx, request as $9.LoanProductSaveRequest);
      case 'LoanProductGet': return this.loanProductGet(ctx, request as $9.LoanProductGetRequest);
      case 'LoanProductSearch': return this.loanProductSearch(ctx, request as $9.LoanProductSearchRequest);
      case 'LoanRequestSave': return this.loanRequestSave(ctx, request as $9.LoanRequestSaveRequest);
      case 'LoanRequestGet': return this.loanRequestGet(ctx, request as $9.LoanRequestGetRequest);
      case 'LoanRequestSearch': return this.loanRequestSearch(ctx, request as $9.LoanRequestSearchRequest);
      case 'LoanRequestApprove': return this.loanRequestApprove(ctx, request as $9.LoanRequestApproveRequest);
      case 'LoanRequestReject': return this.loanRequestReject(ctx, request as $9.LoanRequestRejectRequest);
      case 'LoanRequestCancel': return this.loanRequestCancel(ctx, request as $9.LoanRequestCancelRequest);
      case 'ClientProductAccessSave': return this.clientProductAccessSave(ctx, request as $9.ClientProductAccessSaveRequest);
      case 'ClientProductAccessGet': return this.clientProductAccessGet(ctx, request as $9.ClientProductAccessGetRequest);
      case 'ClientProductAccessSearch': return this.clientProductAccessSearch(ctx, request as $9.ClientProductAccessSearchRequest);
      case 'LoanAccountCreate': return this.loanAccountCreate(ctx, request as $9.LoanAccountCreateRequest);
      case 'LoanAccountGet': return this.loanAccountGet(ctx, request as $9.LoanAccountGetRequest);
      case 'LoanAccountSearch': return this.loanAccountSearch(ctx, request as $9.LoanAccountSearchRequest);
      case 'LoanBalanceGet': return this.loanBalanceGet(ctx, request as $9.LoanBalanceGetRequest);
      case 'LoanStatement': return this.loanStatement(ctx, request as $9.LoanStatementRequest);
      case 'DisbursementCreate': return this.disbursementCreate(ctx, request as $9.DisbursementCreateRequest);
      case 'DisbursementGet': return this.disbursementGet(ctx, request as $9.DisbursementGetRequest);
      case 'DisbursementSearch': return this.disbursementSearch(ctx, request as $9.DisbursementSearchRequest);
      case 'RepaymentRecord': return this.repaymentRecord(ctx, request as $9.RepaymentRecordRequest);
      case 'RepaymentGet': return this.repaymentGet(ctx, request as $9.RepaymentGetRequest);
      case 'RepaymentSearch': return this.repaymentSearch(ctx, request as $9.RepaymentSearchRequest);
      case 'RepaymentScheduleGet': return this.repaymentScheduleGet(ctx, request as $9.RepaymentScheduleGetRequest);
      case 'PenaltySave': return this.penaltySave(ctx, request as $9.PenaltySaveRequest);
      case 'PenaltyWaive': return this.penaltyWaive(ctx, request as $9.PenaltyWaiveRequest);
      case 'PenaltySearch': return this.penaltySearch(ctx, request as $9.PenaltySearchRequest);
      case 'LoanRestructureCreate': return this.loanRestructureCreate(ctx, request as $9.LoanRestructureCreateRequest);
      case 'LoanRestructureApprove': return this.loanRestructureApprove(ctx, request as $9.LoanRestructureApproveRequest);
      case 'LoanRestructureReject': return this.loanRestructureReject(ctx, request as $9.LoanRestructureRejectRequest);
      case 'LoanRestructureSearch': return this.loanRestructureSearch(ctx, request as $9.LoanRestructureSearchRequest);
      case 'ReconciliationSave': return this.reconciliationSave(ctx, request as $9.ReconciliationSaveRequest);
      case 'ReconciliationSearch': return this.reconciliationSearch(ctx, request as $9.ReconciliationSearchRequest);
      case 'InitiateCollection': return this.initiateCollection(ctx, request as $9.InitiateCollectionRequest);
      case 'LoanStatusChangeSearch': return this.loanStatusChangeSearch(ctx, request as $9.LoanStatusChangeSearchRequest);
      case 'PortfolioSummary': return this.portfolioSummary(ctx, request as $9.PortfolioSummaryRequest);
      case 'PortfolioExport': return this.portfolioExport(ctx, request as $9.PortfolioExportRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => LoanManagementServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => LoanManagementServiceBase$messageJson;
}

