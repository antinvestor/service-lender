//
//  Generated code. Do not modify.
//  source: identity/v1/identity.proto
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

import '../../common/v1/common.pb.dart' as $7;
import 'identity.pb.dart' as $11;
import 'identity.pbjson.dart';

export 'identity.pb.dart';

abstract class IdentityServiceBase extends $pb.GeneratedService {
  $async.Future<$11.OrganizationSaveResponse> organizationSave($pb.ServerContext ctx, $11.OrganizationSaveRequest request);
  $async.Future<$11.OrganizationGetResponse> organizationGet($pb.ServerContext ctx, $11.OrganizationGetRequest request);
  $async.Future<$11.OrganizationSearchResponse> organizationSearch($pb.ServerContext ctx, $7.SearchRequest request);
  $async.Future<$11.BranchSaveResponse> branchSave($pb.ServerContext ctx, $11.BranchSaveRequest request);
  $async.Future<$11.BranchGetResponse> branchGet($pb.ServerContext ctx, $11.BranchGetRequest request);
  $async.Future<$11.BranchSearchResponse> branchSearch($pb.ServerContext ctx, $11.BranchSearchRequest request);
  $async.Future<$11.InvestorSaveResponse> investorSave($pb.ServerContext ctx, $11.InvestorSaveRequest request);
  $async.Future<$11.InvestorGetResponse> investorGet($pb.ServerContext ctx, $11.InvestorGetRequest request);
  $async.Future<$11.InvestorSearchResponse> investorSearch($pb.ServerContext ctx, $11.InvestorSearchRequest request);
  $async.Future<$11.SystemUserSaveResponse> systemUserSave($pb.ServerContext ctx, $11.SystemUserSaveRequest request);
  $async.Future<$11.SystemUserGetResponse> systemUserGet($pb.ServerContext ctx, $11.SystemUserGetRequest request);
  $async.Future<$11.SystemUserSearchResponse> systemUserSearch($pb.ServerContext ctx, $11.SystemUserSearchRequest request);
  $async.Future<$11.ClientGroupSaveResponse> clientGroupSave($pb.ServerContext ctx, $11.ClientGroupSaveRequest request);
  $async.Future<$11.ClientGroupGetResponse> clientGroupGet($pb.ServerContext ctx, $11.ClientGroupGetRequest request);
  $async.Future<$11.ClientGroupSearchResponse> clientGroupSearch($pb.ServerContext ctx, $11.ClientGroupSearchRequest request);
  $async.Future<$11.MembershipSaveResponse> membershipSave($pb.ServerContext ctx, $11.MembershipSaveRequest request);
  $async.Future<$11.MembershipGetResponse> membershipGet($pb.ServerContext ctx, $11.MembershipGetRequest request);
  $async.Future<$11.MembershipSearchResponse> membershipSearch($pb.ServerContext ctx, $11.MembershipSearchRequest request);
  $async.Future<$11.InvestorAccountSaveResponse> investorAccountSave($pb.ServerContext ctx, $11.InvestorAccountSaveRequest request);
  $async.Future<$11.InvestorAccountGetResponse> investorAccountGet($pb.ServerContext ctx, $11.InvestorAccountGetRequest request);
  $async.Future<$11.InvestorAccountSearchResponse> investorAccountSearch($pb.ServerContext ctx, $11.InvestorAccountSearchRequest request);
  $async.Future<$11.InvestorDepositResponse> investorDeposit($pb.ServerContext ctx, $11.InvestorDepositRequest request);
  $async.Future<$11.InvestorWithdrawResponse> investorWithdraw($pb.ServerContext ctx, $11.InvestorWithdrawRequest request);
  $async.Future<$11.ClientDataSaveResponse> clientDataSave($pb.ServerContext ctx, $11.ClientDataSaveRequest request);
  $async.Future<$11.ClientDataGetResponse> clientDataGet($pb.ServerContext ctx, $11.ClientDataGetRequest request);
  $async.Future<$11.ClientDataListResponse> clientDataList($pb.ServerContext ctx, $11.ClientDataListRequest request);
  $async.Future<$11.ClientDataVerifyResponse> clientDataVerify($pb.ServerContext ctx, $11.ClientDataVerifyRequest request);
  $async.Future<$11.ClientDataRejectResponse> clientDataReject($pb.ServerContext ctx, $11.ClientDataRejectRequest request);
  $async.Future<$11.ClientDataRequestInfoResponse> clientDataRequestInfo($pb.ServerContext ctx, $11.ClientDataRequestInfoRequest request);
  $async.Future<$11.ClientDataHistoryResponse> clientDataHistory($pb.ServerContext ctx, $11.ClientDataHistoryRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'OrganizationSave': return $11.OrganizationSaveRequest();
      case 'OrganizationGet': return $11.OrganizationGetRequest();
      case 'OrganizationSearch': return $7.SearchRequest();
      case 'BranchSave': return $11.BranchSaveRequest();
      case 'BranchGet': return $11.BranchGetRequest();
      case 'BranchSearch': return $11.BranchSearchRequest();
      case 'InvestorSave': return $11.InvestorSaveRequest();
      case 'InvestorGet': return $11.InvestorGetRequest();
      case 'InvestorSearch': return $11.InvestorSearchRequest();
      case 'SystemUserSave': return $11.SystemUserSaveRequest();
      case 'SystemUserGet': return $11.SystemUserGetRequest();
      case 'SystemUserSearch': return $11.SystemUserSearchRequest();
      case 'ClientGroupSave': return $11.ClientGroupSaveRequest();
      case 'ClientGroupGet': return $11.ClientGroupGetRequest();
      case 'ClientGroupSearch': return $11.ClientGroupSearchRequest();
      case 'MembershipSave': return $11.MembershipSaveRequest();
      case 'MembershipGet': return $11.MembershipGetRequest();
      case 'MembershipSearch': return $11.MembershipSearchRequest();
      case 'InvestorAccountSave': return $11.InvestorAccountSaveRequest();
      case 'InvestorAccountGet': return $11.InvestorAccountGetRequest();
      case 'InvestorAccountSearch': return $11.InvestorAccountSearchRequest();
      case 'InvestorDeposit': return $11.InvestorDepositRequest();
      case 'InvestorWithdraw': return $11.InvestorWithdrawRequest();
      case 'ClientDataSave': return $11.ClientDataSaveRequest();
      case 'ClientDataGet': return $11.ClientDataGetRequest();
      case 'ClientDataList': return $11.ClientDataListRequest();
      case 'ClientDataVerify': return $11.ClientDataVerifyRequest();
      case 'ClientDataReject': return $11.ClientDataRejectRequest();
      case 'ClientDataRequestInfo': return $11.ClientDataRequestInfoRequest();
      case 'ClientDataHistory': return $11.ClientDataHistoryRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'OrganizationSave': return this.organizationSave(ctx, request as $11.OrganizationSaveRequest);
      case 'OrganizationGet': return this.organizationGet(ctx, request as $11.OrganizationGetRequest);
      case 'OrganizationSearch': return this.organizationSearch(ctx, request as $7.SearchRequest);
      case 'BranchSave': return this.branchSave(ctx, request as $11.BranchSaveRequest);
      case 'BranchGet': return this.branchGet(ctx, request as $11.BranchGetRequest);
      case 'BranchSearch': return this.branchSearch(ctx, request as $11.BranchSearchRequest);
      case 'InvestorSave': return this.investorSave(ctx, request as $11.InvestorSaveRequest);
      case 'InvestorGet': return this.investorGet(ctx, request as $11.InvestorGetRequest);
      case 'InvestorSearch': return this.investorSearch(ctx, request as $11.InvestorSearchRequest);
      case 'SystemUserSave': return this.systemUserSave(ctx, request as $11.SystemUserSaveRequest);
      case 'SystemUserGet': return this.systemUserGet(ctx, request as $11.SystemUserGetRequest);
      case 'SystemUserSearch': return this.systemUserSearch(ctx, request as $11.SystemUserSearchRequest);
      case 'ClientGroupSave': return this.clientGroupSave(ctx, request as $11.ClientGroupSaveRequest);
      case 'ClientGroupGet': return this.clientGroupGet(ctx, request as $11.ClientGroupGetRequest);
      case 'ClientGroupSearch': return this.clientGroupSearch(ctx, request as $11.ClientGroupSearchRequest);
      case 'MembershipSave': return this.membershipSave(ctx, request as $11.MembershipSaveRequest);
      case 'MembershipGet': return this.membershipGet(ctx, request as $11.MembershipGetRequest);
      case 'MembershipSearch': return this.membershipSearch(ctx, request as $11.MembershipSearchRequest);
      case 'InvestorAccountSave': return this.investorAccountSave(ctx, request as $11.InvestorAccountSaveRequest);
      case 'InvestorAccountGet': return this.investorAccountGet(ctx, request as $11.InvestorAccountGetRequest);
      case 'InvestorAccountSearch': return this.investorAccountSearch(ctx, request as $11.InvestorAccountSearchRequest);
      case 'InvestorDeposit': return this.investorDeposit(ctx, request as $11.InvestorDepositRequest);
      case 'InvestorWithdraw': return this.investorWithdraw(ctx, request as $11.InvestorWithdrawRequest);
      case 'ClientDataSave': return this.clientDataSave(ctx, request as $11.ClientDataSaveRequest);
      case 'ClientDataGet': return this.clientDataGet(ctx, request as $11.ClientDataGetRequest);
      case 'ClientDataList': return this.clientDataList(ctx, request as $11.ClientDataListRequest);
      case 'ClientDataVerify': return this.clientDataVerify(ctx, request as $11.ClientDataVerifyRequest);
      case 'ClientDataReject': return this.clientDataReject(ctx, request as $11.ClientDataRejectRequest);
      case 'ClientDataRequestInfo': return this.clientDataRequestInfo(ctx, request as $11.ClientDataRequestInfoRequest);
      case 'ClientDataHistory': return this.clientDataHistory(ctx, request as $11.ClientDataHistoryRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => IdentityServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => IdentityServiceBase$messageJson;
}

