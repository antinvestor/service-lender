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
import 'identity.pb.dart' as $9;
import 'identity.pbjson.dart';

export 'identity.pb.dart';

abstract class IdentityServiceBase extends $pb.GeneratedService {
  $async.Future<$9.OrganizationSaveResponse> organizationSave($pb.ServerContext ctx, $9.OrganizationSaveRequest request);
  $async.Future<$9.OrganizationGetResponse> organizationGet($pb.ServerContext ctx, $9.OrganizationGetRequest request);
  $async.Future<$9.OrganizationSearchResponse> organizationSearch($pb.ServerContext ctx, $7.SearchRequest request);
  $async.Future<$9.OrgUnitSaveResponse> orgUnitSave($pb.ServerContext ctx, $9.OrgUnitSaveRequest request);
  $async.Future<$9.OrgUnitGetResponse> orgUnitGet($pb.ServerContext ctx, $9.OrgUnitGetRequest request);
  $async.Future<$9.OrgUnitSearchResponse> orgUnitSearch($pb.ServerContext ctx, $9.OrgUnitSearchRequest request);
  $async.Future<$9.BranchSaveResponse> branchSave($pb.ServerContext ctx, $9.BranchSaveRequest request);
  $async.Future<$9.BranchGetResponse> branchGet($pb.ServerContext ctx, $9.BranchGetRequest request);
  $async.Future<$9.BranchSearchResponse> branchSearch($pb.ServerContext ctx, $9.BranchSearchRequest request);
  $async.Future<$9.InvestorSaveResponse> investorSave($pb.ServerContext ctx, $9.InvestorSaveRequest request);
  $async.Future<$9.InvestorGetResponse> investorGet($pb.ServerContext ctx, $9.InvestorGetRequest request);
  $async.Future<$9.InvestorSearchResponse> investorSearch($pb.ServerContext ctx, $9.InvestorSearchRequest request);
  $async.Future<$9.SystemUserSaveResponse> systemUserSave($pb.ServerContext ctx, $9.SystemUserSaveRequest request);
  $async.Future<$9.SystemUserGetResponse> systemUserGet($pb.ServerContext ctx, $9.SystemUserGetRequest request);
  $async.Future<$9.SystemUserSearchResponse> systemUserSearch($pb.ServerContext ctx, $9.SystemUserSearchRequest request);
  $async.Future<$9.ClientGroupSaveResponse> clientGroupSave($pb.ServerContext ctx, $9.ClientGroupSaveRequest request);
  $async.Future<$9.ClientGroupGetResponse> clientGroupGet($pb.ServerContext ctx, $9.ClientGroupGetRequest request);
  $async.Future<$9.ClientGroupSearchResponse> clientGroupSearch($pb.ServerContext ctx, $9.ClientGroupSearchRequest request);
  $async.Future<$9.MembershipSaveResponse> membershipSave($pb.ServerContext ctx, $9.MembershipSaveRequest request);
  $async.Future<$9.MembershipGetResponse> membershipGet($pb.ServerContext ctx, $9.MembershipGetRequest request);
  $async.Future<$9.MembershipSearchResponse> membershipSearch($pb.ServerContext ctx, $9.MembershipSearchRequest request);
  $async.Future<$9.InvestorAccountSaveResponse> investorAccountSave($pb.ServerContext ctx, $9.InvestorAccountSaveRequest request);
  $async.Future<$9.InvestorAccountGetResponse> investorAccountGet($pb.ServerContext ctx, $9.InvestorAccountGetRequest request);
  $async.Future<$9.InvestorAccountSearchResponse> investorAccountSearch($pb.ServerContext ctx, $9.InvestorAccountSearchRequest request);
  $async.Future<$9.InvestorDepositResponse> investorDeposit($pb.ServerContext ctx, $9.InvestorDepositRequest request);
  $async.Future<$9.InvestorWithdrawResponse> investorWithdraw($pb.ServerContext ctx, $9.InvestorWithdrawRequest request);
  $async.Future<$9.ClientDataSaveResponse> clientDataSave($pb.ServerContext ctx, $9.ClientDataSaveRequest request);
  $async.Future<$9.ClientDataGetResponse> clientDataGet($pb.ServerContext ctx, $9.ClientDataGetRequest request);
  $async.Future<$9.ClientDataListResponse> clientDataList($pb.ServerContext ctx, $9.ClientDataListRequest request);
  $async.Future<$9.ClientDataVerifyResponse> clientDataVerify($pb.ServerContext ctx, $9.ClientDataVerifyRequest request);
  $async.Future<$9.ClientDataRejectResponse> clientDataReject($pb.ServerContext ctx, $9.ClientDataRejectRequest request);
  $async.Future<$9.ClientDataRequestInfoResponse> clientDataRequestInfo($pb.ServerContext ctx, $9.ClientDataRequestInfoRequest request);
  $async.Future<$9.ClientDataHistoryResponse> clientDataHistory($pb.ServerContext ctx, $9.ClientDataHistoryRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'OrganizationSave': return $9.OrganizationSaveRequest();
      case 'OrganizationGet': return $9.OrganizationGetRequest();
      case 'OrganizationSearch': return $7.SearchRequest();
      case 'OrgUnitSave': return $9.OrgUnitSaveRequest();
      case 'OrgUnitGet': return $9.OrgUnitGetRequest();
      case 'OrgUnitSearch': return $9.OrgUnitSearchRequest();
      case 'BranchSave': return $9.BranchSaveRequest();
      case 'BranchGet': return $9.BranchGetRequest();
      case 'BranchSearch': return $9.BranchSearchRequest();
      case 'InvestorSave': return $9.InvestorSaveRequest();
      case 'InvestorGet': return $9.InvestorGetRequest();
      case 'InvestorSearch': return $9.InvestorSearchRequest();
      case 'SystemUserSave': return $9.SystemUserSaveRequest();
      case 'SystemUserGet': return $9.SystemUserGetRequest();
      case 'SystemUserSearch': return $9.SystemUserSearchRequest();
      case 'ClientGroupSave': return $9.ClientGroupSaveRequest();
      case 'ClientGroupGet': return $9.ClientGroupGetRequest();
      case 'ClientGroupSearch': return $9.ClientGroupSearchRequest();
      case 'MembershipSave': return $9.MembershipSaveRequest();
      case 'MembershipGet': return $9.MembershipGetRequest();
      case 'MembershipSearch': return $9.MembershipSearchRequest();
      case 'InvestorAccountSave': return $9.InvestorAccountSaveRequest();
      case 'InvestorAccountGet': return $9.InvestorAccountGetRequest();
      case 'InvestorAccountSearch': return $9.InvestorAccountSearchRequest();
      case 'InvestorDeposit': return $9.InvestorDepositRequest();
      case 'InvestorWithdraw': return $9.InvestorWithdrawRequest();
      case 'ClientDataSave': return $9.ClientDataSaveRequest();
      case 'ClientDataGet': return $9.ClientDataGetRequest();
      case 'ClientDataList': return $9.ClientDataListRequest();
      case 'ClientDataVerify': return $9.ClientDataVerifyRequest();
      case 'ClientDataReject': return $9.ClientDataRejectRequest();
      case 'ClientDataRequestInfo': return $9.ClientDataRequestInfoRequest();
      case 'ClientDataHistory': return $9.ClientDataHistoryRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'OrganizationSave': return this.organizationSave(ctx, request as $9.OrganizationSaveRequest);
      case 'OrganizationGet': return this.organizationGet(ctx, request as $9.OrganizationGetRequest);
      case 'OrganizationSearch': return this.organizationSearch(ctx, request as $7.SearchRequest);
      case 'OrgUnitSave': return this.orgUnitSave(ctx, request as $9.OrgUnitSaveRequest);
      case 'OrgUnitGet': return this.orgUnitGet(ctx, request as $9.OrgUnitGetRequest);
      case 'OrgUnitSearch': return this.orgUnitSearch(ctx, request as $9.OrgUnitSearchRequest);
      case 'BranchSave': return this.branchSave(ctx, request as $9.BranchSaveRequest);
      case 'BranchGet': return this.branchGet(ctx, request as $9.BranchGetRequest);
      case 'BranchSearch': return this.branchSearch(ctx, request as $9.BranchSearchRequest);
      case 'InvestorSave': return this.investorSave(ctx, request as $9.InvestorSaveRequest);
      case 'InvestorGet': return this.investorGet(ctx, request as $9.InvestorGetRequest);
      case 'InvestorSearch': return this.investorSearch(ctx, request as $9.InvestorSearchRequest);
      case 'SystemUserSave': return this.systemUserSave(ctx, request as $9.SystemUserSaveRequest);
      case 'SystemUserGet': return this.systemUserGet(ctx, request as $9.SystemUserGetRequest);
      case 'SystemUserSearch': return this.systemUserSearch(ctx, request as $9.SystemUserSearchRequest);
      case 'ClientGroupSave': return this.clientGroupSave(ctx, request as $9.ClientGroupSaveRequest);
      case 'ClientGroupGet': return this.clientGroupGet(ctx, request as $9.ClientGroupGetRequest);
      case 'ClientGroupSearch': return this.clientGroupSearch(ctx, request as $9.ClientGroupSearchRequest);
      case 'MembershipSave': return this.membershipSave(ctx, request as $9.MembershipSaveRequest);
      case 'MembershipGet': return this.membershipGet(ctx, request as $9.MembershipGetRequest);
      case 'MembershipSearch': return this.membershipSearch(ctx, request as $9.MembershipSearchRequest);
      case 'InvestorAccountSave': return this.investorAccountSave(ctx, request as $9.InvestorAccountSaveRequest);
      case 'InvestorAccountGet': return this.investorAccountGet(ctx, request as $9.InvestorAccountGetRequest);
      case 'InvestorAccountSearch': return this.investorAccountSearch(ctx, request as $9.InvestorAccountSearchRequest);
      case 'InvestorDeposit': return this.investorDeposit(ctx, request as $9.InvestorDepositRequest);
      case 'InvestorWithdraw': return this.investorWithdraw(ctx, request as $9.InvestorWithdrawRequest);
      case 'ClientDataSave': return this.clientDataSave(ctx, request as $9.ClientDataSaveRequest);
      case 'ClientDataGet': return this.clientDataGet(ctx, request as $9.ClientDataGetRequest);
      case 'ClientDataList': return this.clientDataList(ctx, request as $9.ClientDataListRequest);
      case 'ClientDataVerify': return this.clientDataVerify(ctx, request as $9.ClientDataVerifyRequest);
      case 'ClientDataReject': return this.clientDataReject(ctx, request as $9.ClientDataRejectRequest);
      case 'ClientDataRequestInfo': return this.clientDataRequestInfo(ctx, request as $9.ClientDataRequestInfoRequest);
      case 'ClientDataHistory': return this.clientDataHistory(ctx, request as $9.ClientDataHistoryRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => IdentityServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => IdentityServiceBase$messageJson;
}

