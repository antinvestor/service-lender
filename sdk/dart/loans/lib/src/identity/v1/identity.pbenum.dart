//
//  Generated code. Do not modify.
//  source: identity/v1/identity.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// OrganizationType defines the kind of organization.
class OrganizationType extends $pb.ProtobufEnum {
  static const OrganizationType ORGANIZATION_TYPE_UNSPECIFIED = OrganizationType._(0, _omitEnumNames ? '' : 'ORGANIZATION_TYPE_UNSPECIFIED');
  static const OrganizationType ORGANIZATION_TYPE_BANK = OrganizationType._(1, _omitEnumNames ? '' : 'ORGANIZATION_TYPE_BANK');
  static const OrganizationType ORGANIZATION_TYPE_MICROFINANCE = OrganizationType._(2, _omitEnumNames ? '' : 'ORGANIZATION_TYPE_MICROFINANCE');
  static const OrganizationType ORGANIZATION_TYPE_SACCO = OrganizationType._(3, _omitEnumNames ? '' : 'ORGANIZATION_TYPE_SACCO');
  static const OrganizationType ORGANIZATION_TYPE_FINTECH = OrganizationType._(4, _omitEnumNames ? '' : 'ORGANIZATION_TYPE_FINTECH');
  static const OrganizationType ORGANIZATION_TYPE_COOPERATIVE = OrganizationType._(5, _omitEnumNames ? '' : 'ORGANIZATION_TYPE_COOPERATIVE');
  static const OrganizationType ORGANIZATION_TYPE_NGO = OrganizationType._(6, _omitEnumNames ? '' : 'ORGANIZATION_TYPE_NGO');
  static const OrganizationType ORGANIZATION_TYPE_GOVERNMENT = OrganizationType._(7, _omitEnumNames ? '' : 'ORGANIZATION_TYPE_GOVERNMENT');
  static const OrganizationType ORGANIZATION_TYPE_OTHER = OrganizationType._(8, _omitEnumNames ? '' : 'ORGANIZATION_TYPE_OTHER');

  static const $core.List<OrganizationType> values = <OrganizationType> [
    ORGANIZATION_TYPE_UNSPECIFIED,
    ORGANIZATION_TYPE_BANK,
    ORGANIZATION_TYPE_MICROFINANCE,
    ORGANIZATION_TYPE_SACCO,
    ORGANIZATION_TYPE_FINTECH,
    ORGANIZATION_TYPE_COOPERATIVE,
    ORGANIZATION_TYPE_NGO,
    ORGANIZATION_TYPE_GOVERNMENT,
    ORGANIZATION_TYPE_OTHER,
  ];

  static final $core.Map<$core.int, OrganizationType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OrganizationType? valueOf($core.int value) => _byValue[value];

  const OrganizationType._($core.int v, $core.String n) : super(v, n);
}

/// OrgUnitType defines the typed hierarchy under an organization.
class OrgUnitType extends $pb.ProtobufEnum {
  static const OrgUnitType ORG_UNIT_TYPE_UNSPECIFIED = OrgUnitType._(0, _omitEnumNames ? '' : 'ORG_UNIT_TYPE_UNSPECIFIED');
  static const OrgUnitType ORG_UNIT_TYPE_REGION = OrgUnitType._(1, _omitEnumNames ? '' : 'ORG_UNIT_TYPE_REGION');
  static const OrgUnitType ORG_UNIT_TYPE_ZONE = OrgUnitType._(2, _omitEnumNames ? '' : 'ORG_UNIT_TYPE_ZONE');
  static const OrgUnitType ORG_UNIT_TYPE_AREA = OrgUnitType._(3, _omitEnumNames ? '' : 'ORG_UNIT_TYPE_AREA');
  static const OrgUnitType ORG_UNIT_TYPE_CLUSTER = OrgUnitType._(4, _omitEnumNames ? '' : 'ORG_UNIT_TYPE_CLUSTER');
  static const OrgUnitType ORG_UNIT_TYPE_BRANCH = OrgUnitType._(5, _omitEnumNames ? '' : 'ORG_UNIT_TYPE_BRANCH');
  static const OrgUnitType ORG_UNIT_TYPE_OTHER = OrgUnitType._(6, _omitEnumNames ? '' : 'ORG_UNIT_TYPE_OTHER');

  static const $core.List<OrgUnitType> values = <OrgUnitType> [
    ORG_UNIT_TYPE_UNSPECIFIED,
    ORG_UNIT_TYPE_REGION,
    ORG_UNIT_TYPE_ZONE,
    ORG_UNIT_TYPE_AREA,
    ORG_UNIT_TYPE_CLUSTER,
    ORG_UNIT_TYPE_BRANCH,
    ORG_UNIT_TYPE_OTHER,
  ];

  static final $core.Map<$core.int, OrgUnitType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OrgUnitType? valueOf($core.int value) => _byValue[value];

  const OrgUnitType._($core.int v, $core.String n) : super(v, n);
}

/// SystemUserRole defines the role a system user plays in the lending workflow.
/// Deprecated: use AccessRoleAssignmentObject for all authorization decisions.
class SystemUserRole extends $pb.ProtobufEnum {
  static const SystemUserRole SYSTEM_USER_ROLE_UNSPECIFIED = SystemUserRole._(0, _omitEnumNames ? '' : 'SYSTEM_USER_ROLE_UNSPECIFIED');
  static const SystemUserRole SYSTEM_USER_ROLE_VERIFIER = SystemUserRole._(1, _omitEnumNames ? '' : 'SYSTEM_USER_ROLE_VERIFIER');
  static const SystemUserRole SYSTEM_USER_ROLE_APPROVER = SystemUserRole._(2, _omitEnumNames ? '' : 'SYSTEM_USER_ROLE_APPROVER');
  static const SystemUserRole SYSTEM_USER_ROLE_ADMINISTRATOR = SystemUserRole._(3, _omitEnumNames ? '' : 'SYSTEM_USER_ROLE_ADMINISTRATOR');
  static const SystemUserRole SYSTEM_USER_ROLE_AUDITOR = SystemUserRole._(4, _omitEnumNames ? '' : 'SYSTEM_USER_ROLE_AUDITOR');

  static const $core.List<SystemUserRole> values = <SystemUserRole> [
    SYSTEM_USER_ROLE_UNSPECIFIED,
    SYSTEM_USER_ROLE_VERIFIER,
    SYSTEM_USER_ROLE_APPROVER,
    SYSTEM_USER_ROLE_ADMINISTRATOR,
    SYSTEM_USER_ROLE_AUDITOR,
  ];

  static final $core.Map<$core.int, SystemUserRole> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SystemUserRole? valueOf($core.int value) => _byValue[value];

  const SystemUserRole._($core.int v, $core.String n) : super(v, n);
}

/// WorkforceEngagementType defines how a workforce member is engaged.
class WorkforceEngagementType extends $pb.ProtobufEnum {
  static const WorkforceEngagementType WORKFORCE_ENGAGEMENT_TYPE_UNSPECIFIED = WorkforceEngagementType._(0, _omitEnumNames ? '' : 'WORKFORCE_ENGAGEMENT_TYPE_UNSPECIFIED');
  static const WorkforceEngagementType WORKFORCE_ENGAGEMENT_TYPE_EMPLOYEE = WorkforceEngagementType._(1, _omitEnumNames ? '' : 'WORKFORCE_ENGAGEMENT_TYPE_EMPLOYEE');
  static const WorkforceEngagementType WORKFORCE_ENGAGEMENT_TYPE_CONTRACTOR = WorkforceEngagementType._(2, _omitEnumNames ? '' : 'WORKFORCE_ENGAGEMENT_TYPE_CONTRACTOR');
  static const WorkforceEngagementType WORKFORCE_ENGAGEMENT_TYPE_SERVICE_ACCOUNT = WorkforceEngagementType._(3, _omitEnumNames ? '' : 'WORKFORCE_ENGAGEMENT_TYPE_SERVICE_ACCOUNT');

  static const $core.List<WorkforceEngagementType> values = <WorkforceEngagementType> [
    WORKFORCE_ENGAGEMENT_TYPE_UNSPECIFIED,
    WORKFORCE_ENGAGEMENT_TYPE_EMPLOYEE,
    WORKFORCE_ENGAGEMENT_TYPE_CONTRACTOR,
    WORKFORCE_ENGAGEMENT_TYPE_SERVICE_ACCOUNT,
  ];

  static final $core.Map<$core.int, WorkforceEngagementType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static WorkforceEngagementType? valueOf($core.int value) => _byValue[value];

  const WorkforceEngagementType._($core.int v, $core.String n) : super(v, n);
}

/// DepartmentKind separates top-level functions from nested departments.
class DepartmentKind extends $pb.ProtobufEnum {
  static const DepartmentKind DEPARTMENT_KIND_UNSPECIFIED = DepartmentKind._(0, _omitEnumNames ? '' : 'DEPARTMENT_KIND_UNSPECIFIED');
  static const DepartmentKind DEPARTMENT_KIND_FUNCTION = DepartmentKind._(1, _omitEnumNames ? '' : 'DEPARTMENT_KIND_FUNCTION');
  static const DepartmentKind DEPARTMENT_KIND_DEPARTMENT = DepartmentKind._(2, _omitEnumNames ? '' : 'DEPARTMENT_KIND_DEPARTMENT');

  static const $core.List<DepartmentKind> values = <DepartmentKind> [
    DEPARTMENT_KIND_UNSPECIFIED,
    DEPARTMENT_KIND_FUNCTION,
    DEPARTMENT_KIND_DEPARTMENT,
  ];

  static final $core.Map<$core.int, DepartmentKind> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DepartmentKind? valueOf($core.int value) => _byValue[value];

  const DepartmentKind._($core.int v, $core.String n) : super(v, n);
}

/// TeamType defines the operational purpose of an internal team.
class TeamType extends $pb.ProtobufEnum {
  static const TeamType TEAM_TYPE_UNSPECIFIED = TeamType._(0, _omitEnumNames ? '' : 'TEAM_TYPE_UNSPECIFIED');
  static const TeamType TEAM_TYPE_PORTFOLIO = TeamType._(1, _omitEnumNames ? '' : 'TEAM_TYPE_PORTFOLIO');
  static const TeamType TEAM_TYPE_SERVICING = TeamType._(2, _omitEnumNames ? '' : 'TEAM_TYPE_SERVICING');
  static const TeamType TEAM_TYPE_COLLECTIONS = TeamType._(3, _omitEnumNames ? '' : 'TEAM_TYPE_COLLECTIONS');
  static const TeamType TEAM_TYPE_SALES = TeamType._(4, _omitEnumNames ? '' : 'TEAM_TYPE_SALES');
  static const TeamType TEAM_TYPE_PILOT = TeamType._(5, _omitEnumNames ? '' : 'TEAM_TYPE_PILOT');
  static const TeamType TEAM_TYPE_SHARED_SERVICE = TeamType._(6, _omitEnumNames ? '' : 'TEAM_TYPE_SHARED_SERVICE');

  static const $core.List<TeamType> values = <TeamType> [
    TEAM_TYPE_UNSPECIFIED,
    TEAM_TYPE_PORTFOLIO,
    TEAM_TYPE_SERVICING,
    TEAM_TYPE_COLLECTIONS,
    TEAM_TYPE_SALES,
    TEAM_TYPE_PILOT,
    TEAM_TYPE_SHARED_SERVICE,
  ];

  static final $core.Map<$core.int, TeamType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TeamType? valueOf($core.int value) => _byValue[value];

  const TeamType._($core.int v, $core.String n) : super(v, n);
}

/// TeamMembershipRole defines a member's role inside a team.
class TeamMembershipRole extends $pb.ProtobufEnum {
  static const TeamMembershipRole TEAM_MEMBERSHIP_ROLE_UNSPECIFIED = TeamMembershipRole._(0, _omitEnumNames ? '' : 'TEAM_MEMBERSHIP_ROLE_UNSPECIFIED');
  static const TeamMembershipRole TEAM_MEMBERSHIP_ROLE_LEAD = TeamMembershipRole._(1, _omitEnumNames ? '' : 'TEAM_MEMBERSHIP_ROLE_LEAD');
  static const TeamMembershipRole TEAM_MEMBERSHIP_ROLE_DEPUTY = TeamMembershipRole._(2, _omitEnumNames ? '' : 'TEAM_MEMBERSHIP_ROLE_DEPUTY');
  static const TeamMembershipRole TEAM_MEMBERSHIP_ROLE_MEMBER = TeamMembershipRole._(3, _omitEnumNames ? '' : 'TEAM_MEMBERSHIP_ROLE_MEMBER');
  static const TeamMembershipRole TEAM_MEMBERSHIP_ROLE_SPECIALIST = TeamMembershipRole._(4, _omitEnumNames ? '' : 'TEAM_MEMBERSHIP_ROLE_SPECIALIST');

  static const $core.List<TeamMembershipRole> values = <TeamMembershipRole> [
    TEAM_MEMBERSHIP_ROLE_UNSPECIFIED,
    TEAM_MEMBERSHIP_ROLE_LEAD,
    TEAM_MEMBERSHIP_ROLE_DEPUTY,
    TEAM_MEMBERSHIP_ROLE_MEMBER,
    TEAM_MEMBERSHIP_ROLE_SPECIALIST,
  ];

  static final $core.Map<$core.int, TeamMembershipRole> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TeamMembershipRole? valueOf($core.int value) => _byValue[value];

  const TeamMembershipRole._($core.int v, $core.String n) : super(v, n);
}

/// AccessScopeType defines the resource scope of an access role assignment.
class AccessScopeType extends $pb.ProtobufEnum {
  static const AccessScopeType ACCESS_SCOPE_TYPE_UNSPECIFIED = AccessScopeType._(0, _omitEnumNames ? '' : 'ACCESS_SCOPE_TYPE_UNSPECIFIED');
  static const AccessScopeType ACCESS_SCOPE_TYPE_GLOBAL = AccessScopeType._(1, _omitEnumNames ? '' : 'ACCESS_SCOPE_TYPE_GLOBAL');
  static const AccessScopeType ACCESS_SCOPE_TYPE_ORGANIZATION = AccessScopeType._(2, _omitEnumNames ? '' : 'ACCESS_SCOPE_TYPE_ORGANIZATION');
  static const AccessScopeType ACCESS_SCOPE_TYPE_ORG_UNIT = AccessScopeType._(3, _omitEnumNames ? '' : 'ACCESS_SCOPE_TYPE_ORG_UNIT');
  static const AccessScopeType ACCESS_SCOPE_TYPE_TEAM = AccessScopeType._(4, _omitEnumNames ? '' : 'ACCESS_SCOPE_TYPE_TEAM');

  static const $core.List<AccessScopeType> values = <AccessScopeType> [
    ACCESS_SCOPE_TYPE_UNSPECIFIED,
    ACCESS_SCOPE_TYPE_GLOBAL,
    ACCESS_SCOPE_TYPE_ORGANIZATION,
    ACCESS_SCOPE_TYPE_ORG_UNIT,
    ACCESS_SCOPE_TYPE_TEAM,
  ];

  static final $core.Map<$core.int, AccessScopeType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AccessScopeType? valueOf($core.int value) => _byValue[value];

  const AccessScopeType._($core.int v, $core.String n) : super(v, n);
}

/// DataVerificationStatus tracks the verification lifecycle of client KYC data.
class DataVerificationStatus extends $pb.ProtobufEnum {
  static const DataVerificationStatus DATA_VERIFICATION_STATUS_UNSPECIFIED = DataVerificationStatus._(0, _omitEnumNames ? '' : 'DATA_VERIFICATION_STATUS_UNSPECIFIED');
  static const DataVerificationStatus DATA_VERIFICATION_STATUS_COLLECTED = DataVerificationStatus._(1, _omitEnumNames ? '' : 'DATA_VERIFICATION_STATUS_COLLECTED');
  static const DataVerificationStatus DATA_VERIFICATION_STATUS_UNDER_REVIEW = DataVerificationStatus._(2, _omitEnumNames ? '' : 'DATA_VERIFICATION_STATUS_UNDER_REVIEW');
  static const DataVerificationStatus DATA_VERIFICATION_STATUS_VERIFIED = DataVerificationStatus._(3, _omitEnumNames ? '' : 'DATA_VERIFICATION_STATUS_VERIFIED');
  static const DataVerificationStatus DATA_VERIFICATION_STATUS_REJECTED = DataVerificationStatus._(4, _omitEnumNames ? '' : 'DATA_VERIFICATION_STATUS_REJECTED');
  static const DataVerificationStatus DATA_VERIFICATION_STATUS_MORE_INFO_NEEDED = DataVerificationStatus._(5, _omitEnumNames ? '' : 'DATA_VERIFICATION_STATUS_MORE_INFO_NEEDED');
  static const DataVerificationStatus DATA_VERIFICATION_STATUS_EXPIRED = DataVerificationStatus._(6, _omitEnumNames ? '' : 'DATA_VERIFICATION_STATUS_EXPIRED');

  static const $core.List<DataVerificationStatus> values = <DataVerificationStatus> [
    DATA_VERIFICATION_STATUS_UNSPECIFIED,
    DATA_VERIFICATION_STATUS_COLLECTED,
    DATA_VERIFICATION_STATUS_UNDER_REVIEW,
    DATA_VERIFICATION_STATUS_VERIFIED,
    DATA_VERIFICATION_STATUS_REJECTED,
    DATA_VERIFICATION_STATUS_MORE_INFO_NEEDED,
    DATA_VERIFICATION_STATUS_EXPIRED,
  ];

  static final $core.Map<$core.int, DataVerificationStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DataVerificationStatus? valueOf($core.int value) => _byValue[value];

  const DataVerificationStatus._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
