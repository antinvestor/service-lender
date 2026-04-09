//
//  Generated code. Do not modify.
//  source: field/v1/field.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// AgentType defines whether an agent is an individual or an organization.
class AgentType extends $pb.ProtobufEnum {
  static const AgentType AGENT_TYPE_UNSPECIFIED = AgentType._(0, _omitEnumNames ? '' : 'AGENT_TYPE_UNSPECIFIED');
  static const AgentType AGENT_TYPE_INDIVIDUAL = AgentType._(1, _omitEnumNames ? '' : 'AGENT_TYPE_INDIVIDUAL');
  static const AgentType AGENT_TYPE_ORGANIZATION = AgentType._(2, _omitEnumNames ? '' : 'AGENT_TYPE_ORGANIZATION');

  static const $core.List<AgentType> values = <AgentType> [
    AGENT_TYPE_UNSPECIFIED,
    AGENT_TYPE_INDIVIDUAL,
    AGENT_TYPE_ORGANIZATION,
  ];

  static final $core.Map<$core.int, AgentType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AgentType? valueOf($core.int value) => _byValue[value];

  const AgentType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
