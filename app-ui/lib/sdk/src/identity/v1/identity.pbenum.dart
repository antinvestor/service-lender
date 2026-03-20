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


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
