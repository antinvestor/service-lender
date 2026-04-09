//
//  Generated code. Do not modify.
//  source: origination/v1/origination.proto
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

import 'origination.pb.dart' as $14;
import 'origination.pbjson.dart';

export 'origination.pb.dart';

abstract class OriginationServiceBase extends $pb.GeneratedService {
  $async.Future<$14.LoanProductSaveResponse> loanProductSave($pb.ServerContext ctx, $14.LoanProductSaveRequest request);
  $async.Future<$14.LoanProductGetResponse> loanProductGet($pb.ServerContext ctx, $14.LoanProductGetRequest request);
  $async.Future<$14.LoanProductSearchResponse> loanProductSearch($pb.ServerContext ctx, $14.LoanProductSearchRequest request);
  $async.Future<$14.ApplicationSaveResponse> applicationSave($pb.ServerContext ctx, $14.ApplicationSaveRequest request);
  $async.Future<$14.ApplicationGetResponse> applicationGet($pb.ServerContext ctx, $14.ApplicationGetRequest request);
  $async.Future<$14.ApplicationSearchResponse> applicationSearch($pb.ServerContext ctx, $14.ApplicationSearchRequest request);
  $async.Future<$14.ApplicationSubmitResponse> applicationSubmit($pb.ServerContext ctx, $14.ApplicationSubmitRequest request);
  $async.Future<$14.ApplicationCancelResponse> applicationCancel($pb.ServerContext ctx, $14.ApplicationCancelRequest request);
  $async.Future<$14.ApplicationAcceptOfferResponse> applicationAcceptOffer($pb.ServerContext ctx, $14.ApplicationAcceptOfferRequest request);
  $async.Future<$14.ApplicationDeclineOfferResponse> applicationDeclineOffer($pb.ServerContext ctx, $14.ApplicationDeclineOfferRequest request);
  $async.Future<$14.ApplicationDocumentSaveResponse> applicationDocumentSave($pb.ServerContext ctx, $14.ApplicationDocumentSaveRequest request);
  $async.Future<$14.ApplicationDocumentGetResponse> applicationDocumentGet($pb.ServerContext ctx, $14.ApplicationDocumentGetRequest request);
  $async.Future<$14.ApplicationDocumentSearchResponse> applicationDocumentSearch($pb.ServerContext ctx, $14.ApplicationDocumentSearchRequest request);
  $async.Future<$14.VerificationTaskSaveResponse> verificationTaskSave($pb.ServerContext ctx, $14.VerificationTaskSaveRequest request);
  $async.Future<$14.VerificationTaskGetResponse> verificationTaskGet($pb.ServerContext ctx, $14.VerificationTaskGetRequest request);
  $async.Future<$14.VerificationTaskSearchResponse> verificationTaskSearch($pb.ServerContext ctx, $14.VerificationTaskSearchRequest request);
  $async.Future<$14.VerificationTaskCompleteResponse> verificationTaskComplete($pb.ServerContext ctx, $14.VerificationTaskCompleteRequest request);
  $async.Future<$14.UnderwritingDecisionSaveResponse> underwritingDecisionSave($pb.ServerContext ctx, $14.UnderwritingDecisionSaveRequest request);
  $async.Future<$14.UnderwritingDecisionGetResponse> underwritingDecisionGet($pb.ServerContext ctx, $14.UnderwritingDecisionGetRequest request);
  $async.Future<$14.UnderwritingDecisionSearchResponse> underwritingDecisionSearch($pb.ServerContext ctx, $14.UnderwritingDecisionSearchRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'LoanProductSave': return $14.LoanProductSaveRequest();
      case 'LoanProductGet': return $14.LoanProductGetRequest();
      case 'LoanProductSearch': return $14.LoanProductSearchRequest();
      case 'ApplicationSave': return $14.ApplicationSaveRequest();
      case 'ApplicationGet': return $14.ApplicationGetRequest();
      case 'ApplicationSearch': return $14.ApplicationSearchRequest();
      case 'ApplicationSubmit': return $14.ApplicationSubmitRequest();
      case 'ApplicationCancel': return $14.ApplicationCancelRequest();
      case 'ApplicationAcceptOffer': return $14.ApplicationAcceptOfferRequest();
      case 'ApplicationDeclineOffer': return $14.ApplicationDeclineOfferRequest();
      case 'ApplicationDocumentSave': return $14.ApplicationDocumentSaveRequest();
      case 'ApplicationDocumentGet': return $14.ApplicationDocumentGetRequest();
      case 'ApplicationDocumentSearch': return $14.ApplicationDocumentSearchRequest();
      case 'VerificationTaskSave': return $14.VerificationTaskSaveRequest();
      case 'VerificationTaskGet': return $14.VerificationTaskGetRequest();
      case 'VerificationTaskSearch': return $14.VerificationTaskSearchRequest();
      case 'VerificationTaskComplete': return $14.VerificationTaskCompleteRequest();
      case 'UnderwritingDecisionSave': return $14.UnderwritingDecisionSaveRequest();
      case 'UnderwritingDecisionGet': return $14.UnderwritingDecisionGetRequest();
      case 'UnderwritingDecisionSearch': return $14.UnderwritingDecisionSearchRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'LoanProductSave': return this.loanProductSave(ctx, request as $14.LoanProductSaveRequest);
      case 'LoanProductGet': return this.loanProductGet(ctx, request as $14.LoanProductGetRequest);
      case 'LoanProductSearch': return this.loanProductSearch(ctx, request as $14.LoanProductSearchRequest);
      case 'ApplicationSave': return this.applicationSave(ctx, request as $14.ApplicationSaveRequest);
      case 'ApplicationGet': return this.applicationGet(ctx, request as $14.ApplicationGetRequest);
      case 'ApplicationSearch': return this.applicationSearch(ctx, request as $14.ApplicationSearchRequest);
      case 'ApplicationSubmit': return this.applicationSubmit(ctx, request as $14.ApplicationSubmitRequest);
      case 'ApplicationCancel': return this.applicationCancel(ctx, request as $14.ApplicationCancelRequest);
      case 'ApplicationAcceptOffer': return this.applicationAcceptOffer(ctx, request as $14.ApplicationAcceptOfferRequest);
      case 'ApplicationDeclineOffer': return this.applicationDeclineOffer(ctx, request as $14.ApplicationDeclineOfferRequest);
      case 'ApplicationDocumentSave': return this.applicationDocumentSave(ctx, request as $14.ApplicationDocumentSaveRequest);
      case 'ApplicationDocumentGet': return this.applicationDocumentGet(ctx, request as $14.ApplicationDocumentGetRequest);
      case 'ApplicationDocumentSearch': return this.applicationDocumentSearch(ctx, request as $14.ApplicationDocumentSearchRequest);
      case 'VerificationTaskSave': return this.verificationTaskSave(ctx, request as $14.VerificationTaskSaveRequest);
      case 'VerificationTaskGet': return this.verificationTaskGet(ctx, request as $14.VerificationTaskGetRequest);
      case 'VerificationTaskSearch': return this.verificationTaskSearch(ctx, request as $14.VerificationTaskSearchRequest);
      case 'VerificationTaskComplete': return this.verificationTaskComplete(ctx, request as $14.VerificationTaskCompleteRequest);
      case 'UnderwritingDecisionSave': return this.underwritingDecisionSave(ctx, request as $14.UnderwritingDecisionSaveRequest);
      case 'UnderwritingDecisionGet': return this.underwritingDecisionGet(ctx, request as $14.UnderwritingDecisionGetRequest);
      case 'UnderwritingDecisionSearch': return this.underwritingDecisionSearch(ctx, request as $14.UnderwritingDecisionSearchRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => OriginationServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => OriginationServiceBase$messageJson;
}

