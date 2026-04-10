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

/// SystemUserRole defines the role a system user plays in the lending workflow.
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
