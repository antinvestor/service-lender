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
  $async.Future<$9.WorkforceMemberSaveResponse> workforceMemberSave($pb.ServerContext ctx, $9.WorkforceMemberSaveRequest request);
  $async.Future<$9.WorkforceMemberGetResponse> workforceMemberGet($pb.ServerContext ctx, $9.WorkforceMemberGetRequest request);
  $async.Future<$9.WorkforceMemberSearchResponse> workforceMemberSearch($pb.ServerContext ctx, $9.WorkforceMemberSearchRequest request);
  $async.Future<$9.DepartmentSaveResponse> departmentSave($pb.ServerContext ctx, $9.DepartmentSaveRequest request);
  $async.Future<$9.DepartmentGetResponse> departmentGet($pb.ServerContext ctx, $9.DepartmentGetRequest request);
  $async.Future<$9.DepartmentSearchResponse> departmentSearch($pb.ServerContext ctx, $9.DepartmentSearchRequest request);
  $async.Future<$9.PositionSaveResponse> positionSave($pb.ServerContext ctx, $9.PositionSaveRequest request);
  $async.Future<$9.PositionGetResponse> positionGet($pb.ServerContext ctx, $9.PositionGetRequest request);
  $async.Future<$9.PositionSearchResponse> positionSearch($pb.ServerContext ctx, $9.PositionSearchRequest request);
  $async.Future<$9.PositionAssignmentSaveResponse> positionAssignmentSave($pb.ServerContext ctx, $9.PositionAssignmentSaveRequest request);
  $async.Future<$9.PositionAssignmentGetResponse> positionAssignmentGet($pb.ServerContext ctx, $9.PositionAssignmentGetRequest request);
  $async.Future<$9.PositionAssignmentSearchResponse> positionAssignmentSearch($pb.ServerContext ctx, $9.PositionAssignmentSearchRequest request);
  $async.Future<$9.InternalTeamSaveResponse> internalTeamSave($pb.ServerContext ctx, $9.InternalTeamSaveRequest request);
  $async.Future<$9.InternalTeamGetResponse> internalTeamGet($pb.ServerContext ctx, $9.InternalTeamGetRequest request);
  $async.Future<$9.InternalTeamSearchResponse> internalTeamSearch($pb.ServerContext ctx, $9.InternalTeamSearchRequest request);
  $async.Future<$9.TeamMembershipSaveResponse> teamMembershipSave($pb.ServerContext ctx, $9.TeamMembershipSaveRequest request);
  $async.Future<$9.TeamMembershipGetResponse> teamMembershipGet($pb.ServerContext ctx, $9.TeamMembershipGetRequest request);
  $async.Future<$9.TeamMembershipSearchResponse> teamMembershipSearch($pb.ServerContext ctx, $9.TeamMembershipSearchRequest request);
  $async.Future<$9.AccessRoleAssignmentSaveResponse> accessRoleAssignmentSave($pb.ServerContext ctx, $9.AccessRoleAssignmentSaveRequest request);
  $async.Future<$9.AccessRoleAssignmentGetResponse> accessRoleAssignmentGet($pb.ServerContext ctx, $9.AccessRoleAssignmentGetRequest request);
  $async.Future<$9.AccessRoleAssignmentSearchResponse> accessRoleAssignmentSearch($pb.ServerContext ctx, $9.AccessRoleAssignmentSearchRequest request);
  $async.Future<$9.InvestorSaveResponse> investorSave($pb.ServerContext ctx, $9.InvestorSaveRequest request);
  $async.Future<$9.InvestorGetResponse> investorGet($pb.ServerContext ctx, $9.InvestorGetRequest request);
  $async.Future<$9.InvestorSearchResponse> investorSearch($pb.ServerContext ctx, $9.InvestorSearchRequest request);
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
  $async.Future<$9.FormTemplateSaveResponse> formTemplateSave($pb.ServerContext ctx, $9.FormTemplateSaveRequest request);
  $async.Future<$9.FormTemplateGetResponse> formTemplateGet($pb.ServerContext ctx, $9.FormTemplateGetRequest request);
  $async.Future<$9.FormTemplateSearchResponse> formTemplateSearch($pb.ServerContext ctx, $9.FormTemplateSearchRequest request);
  $async.Future<$9.FormTemplatePublishResponse> formTemplatePublish($pb.ServerContext ctx, $9.FormTemplatePublishRequest request);
  $async.Future<$9.FormSubmissionSaveResponse> formSubmissionSave($pb.ServerContext ctx, $9.FormSubmissionSaveRequest request);
  $async.Future<$9.FormSubmissionGetResponse> formSubmissionGet($pb.ServerContext ctx, $9.FormSubmissionGetRequest request);
  $async.Future<$9.FormSubmissionSearchResponse> formSubmissionSearch($pb.ServerContext ctx, $9.FormSubmissionSearchRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'OrganizationSave': return $9.OrganizationSaveRequest();
      case 'OrganizationGet': return $9.OrganizationGetRequest();
      case 'OrganizationSearch': return $7.SearchRequest();
      case 'OrgUnitSave': return $9.OrgUnitSaveRequest();
      case 'OrgUnitGet': return $9.OrgUnitGetRequest();
      case 'OrgUnitSearch': return $9.OrgUnitSearchRequest();
      case 'WorkforceMemberSave': return $9.WorkforceMemberSaveRequest();
      case 'WorkforceMemberGet': return $9.WorkforceMemberGetRequest();
      case 'WorkforceMemberSearch': return $9.WorkforceMemberSearchRequest();
      case 'DepartmentSave': return $9.DepartmentSaveRequest();
      case 'DepartmentGet': return $9.DepartmentGetRequest();
      case 'DepartmentSearch': return $9.DepartmentSearchRequest();
      case 'PositionSave': return $9.PositionSaveRequest();
      case 'PositionGet': return $9.PositionGetRequest();
      case 'PositionSearch': return $9.PositionSearchRequest();
      case 'PositionAssignmentSave': return $9.PositionAssignmentSaveRequest();
      case 'PositionAssignmentGet': return $9.PositionAssignmentGetRequest();
      case 'PositionAssignmentSearch': return $9.PositionAssignmentSearchRequest();
      case 'InternalTeamSave': return $9.InternalTeamSaveRequest();
      case 'InternalTeamGet': return $9.InternalTeamGetRequest();
      case 'InternalTeamSearch': return $9.InternalTeamSearchRequest();
      case 'TeamMembershipSave': return $9.TeamMembershipSaveRequest();
      case 'TeamMembershipGet': return $9.TeamMembershipGetRequest();
      case 'TeamMembershipSearch': return $9.TeamMembershipSearchRequest();
      case 'AccessRoleAssignmentSave': return $9.AccessRoleAssignmentSaveRequest();
      case 'AccessRoleAssignmentGet': return $9.AccessRoleAssignmentGetRequest();
      case 'AccessRoleAssignmentSearch': return $9.AccessRoleAssignmentSearchRequest();
      case 'InvestorSave': return $9.InvestorSaveRequest();
      case 'InvestorGet': return $9.InvestorGetRequest();
      case 'InvestorSearch': return $9.InvestorSearchRequest();
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
      case 'FormTemplateSave': return $9.FormTemplateSaveRequest();
      case 'FormTemplateGet': return $9.FormTemplateGetRequest();
      case 'FormTemplateSearch': return $9.FormTemplateSearchRequest();
      case 'FormTemplatePublish': return $9.FormTemplatePublishRequest();
      case 'FormSubmissionSave': return $9.FormSubmissionSaveRequest();
      case 'FormSubmissionGet': return $9.FormSubmissionGetRequest();
      case 'FormSubmissionSearch': return $9.FormSubmissionSearchRequest();
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
      case 'WorkforceMemberSave': return this.workforceMemberSave(ctx, request as $9.WorkforceMemberSaveRequest);
      case 'WorkforceMemberGet': return this.workforceMemberGet(ctx, request as $9.WorkforceMemberGetRequest);
      case 'WorkforceMemberSearch': return this.workforceMemberSearch(ctx, request as $9.WorkforceMemberSearchRequest);
      case 'DepartmentSave': return this.departmentSave(ctx, request as $9.DepartmentSaveRequest);
      case 'DepartmentGet': return this.departmentGet(ctx, request as $9.DepartmentGetRequest);
      case 'DepartmentSearch': return this.departmentSearch(ctx, request as $9.DepartmentSearchRequest);
      case 'PositionSave': return this.positionSave(ctx, request as $9.PositionSaveRequest);
      case 'PositionGet': return this.positionGet(ctx, request as $9.PositionGetRequest);
      case 'PositionSearch': return this.positionSearch(ctx, request as $9.PositionSearchRequest);
      case 'PositionAssignmentSave': return this.positionAssignmentSave(ctx, request as $9.PositionAssignmentSaveRequest);
      case 'PositionAssignmentGet': return this.positionAssignmentGet(ctx, request as $9.PositionAssignmentGetRequest);
      case 'PositionAssignmentSearch': return this.positionAssignmentSearch(ctx, request as $9.PositionAssignmentSearchRequest);
      case 'InternalTeamSave': return this.internalTeamSave(ctx, request as $9.InternalTeamSaveRequest);
      case 'InternalTeamGet': return this.internalTeamGet(ctx, request as $9.InternalTeamGetRequest);
      case 'InternalTeamSearch': return this.internalTeamSearch(ctx, request as $9.InternalTeamSearchRequest);
      case 'TeamMembershipSave': return this.teamMembershipSave(ctx, request as $9.TeamMembershipSaveRequest);
      case 'TeamMembershipGet': return this.teamMembershipGet(ctx, request as $9.TeamMembershipGetRequest);
      case 'TeamMembershipSearch': return this.teamMembershipSearch(ctx, request as $9.TeamMembershipSearchRequest);
      case 'AccessRoleAssignmentSave': return this.accessRoleAssignmentSave(ctx, request as $9.AccessRoleAssignmentSaveRequest);
      case 'AccessRoleAssignmentGet': return this.accessRoleAssignmentGet(ctx, request as $9.AccessRoleAssignmentGetRequest);
      case 'AccessRoleAssignmentSearch': return this.accessRoleAssignmentSearch(ctx, request as $9.AccessRoleAssignmentSearchRequest);
      case 'InvestorSave': return this.investorSave(ctx, request as $9.InvestorSaveRequest);
      case 'InvestorGet': return this.investorGet(ctx, request as $9.InvestorGetRequest);
      case 'InvestorSearch': return this.investorSearch(ctx, request as $9.InvestorSearchRequest);
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
      case 'FormTemplateSave': return this.formTemplateSave(ctx, request as $9.FormTemplateSaveRequest);
      case 'FormTemplateGet': return this.formTemplateGet(ctx, request as $9.FormTemplateGetRequest);
      case 'FormTemplateSearch': return this.formTemplateSearch(ctx, request as $9.FormTemplateSearchRequest);
      case 'FormTemplatePublish': return this.formTemplatePublish(ctx, request as $9.FormTemplatePublishRequest);
      case 'FormSubmissionSave': return this.formSubmissionSave(ctx, request as $9.FormSubmissionSaveRequest);
      case 'FormSubmissionGet': return this.formSubmissionGet(ctx, request as $9.FormSubmissionGetRequest);
      case 'FormSubmissionSearch': return this.formSubmissionSearch(ctx, request as $9.FormSubmissionSearchRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => IdentityServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => IdentityServiceBase$messageJson;
}

