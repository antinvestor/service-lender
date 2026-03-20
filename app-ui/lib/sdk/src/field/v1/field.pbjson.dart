//
//  Generated code. Do not modify.
//  source: field/v1/field.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../common/v1/common.pbjson.dart' as $7;
import '../../google/protobuf/struct.pbjson.dart' as $6;

@$core.Deprecated('Use agentTypeDescriptor instead')
const AgentType$json = {
  '1': 'AgentType',
  '2': [
    {'1': 'AGENT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'AGENT_TYPE_INDIVIDUAL', '2': 1},
    {'1': 'AGENT_TYPE_ORGANIZATION', '2': 2},
  ],
};

/// Descriptor for `AgentType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List agentTypeDescriptor = $convert.base64Decode(
    'CglBZ2VudFR5cGUSGgoWQUdFTlRfVFlQRV9VTlNQRUNJRklFRBAAEhkKFUFHRU5UX1RZUEVfSU'
    '5ESVZJRFVBTBABEhsKF0FHRU5UX1RZUEVfT1JHQU5JWkFUSU9OEAI=');

@$core.Deprecated('Use agentObjectDescriptor instead')
const AgentObject$json = {
  '1': 'AgentObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'branch_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'branchId'},
    {'1': 'parent_agent_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'parentAgentId'},
    {'1': 'profile_id', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'profileId'},
    {'1': 'agent_type', '3': 5, '4': 1, '5': 14, '6': '.field.v1.AgentType', '10': 'agentType'},
    {'1': 'name', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'geo_id', '3': 7, '4': 1, '5': 9, '8': {}, '10': 'geoId'},
    {'1': 'depth', '3': 8, '4': 1, '5': 5, '10': 'depth'},
    {'1': 'state', '3': 9, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'properties', '3': 10, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `AgentObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentObjectDescriptor = $convert.base64Decode(
    'CgtBZ2VudE9iamVjdBIuCgJpZBgBIAEoCUIeukgb2AEBchYQAxgoMhBbMC05YS16Xy1dezMsND'
    'B9UgJpZBImCglicmFuY2hfaWQYAiABKAlCCbpIBnIEEAMYKFIIYnJhbmNoSWQSNAoPcGFyZW50'
    'X2FnZW50X2lkGAMgASgJQgy6SAnYAQFyBBADGChSDXBhcmVudEFnZW50SWQSKAoKcHJvZmlsZV'
    '9pZBgEIAEoCUIJukgGcgQQAxgoUglwcm9maWxlSWQSMgoKYWdlbnRfdHlwZRgFIAEoDjITLmZp'
    'ZWxkLnYxLkFnZW50VHlwZVIJYWdlbnRUeXBlEhsKBG5hbWUYBiABKAlCB7pIBHICEAFSBG5hbW'
    'USIQoGZ2VvX2lkGAcgASgJQgq6SAfYAQFyAhgoUgVnZW9JZBIUCgVkZXB0aBgIIAEoBVIFZGVw'
    'dGgSJgoFc3RhdGUYCSABKA4yEC5jb21tb24udjEuU1RBVEVSBXN0YXRlEjcKCnByb3BlcnRpZX'
    'MYCiABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0Ugpwcm9wZXJ0aWVz');

@$core.Deprecated('Use borrowerObjectDescriptor instead')
const BorrowerObject$json = {
  '1': 'BorrowerObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'agent_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'agentId'},
    {'1': 'profile_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'profileId'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'state', '3': 5, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'properties', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `BorrowerObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List borrowerObjectDescriptor = $convert.base64Decode(
    'Cg5Cb3Jyb3dlck9iamVjdBIuCgJpZBgBIAEoCUIeukgb2AEBchYQAxgoMhBbMC05YS16Xy1dez'
    'MsNDB9UgJpZBIkCghhZ2VudF9pZBgCIAEoCUIJukgGcgQQAxgoUgdhZ2VudElkEigKCnByb2Zp'
    'bGVfaWQYAyABKAlCCbpIBnIEEAMYKFIJcHJvZmlsZUlkEhsKBG5hbWUYBCABKAlCB7pIBHICEA'
    'FSBG5hbWUSJgoFc3RhdGUYBSABKA4yEC5jb21tb24udjEuU1RBVEVSBXN0YXRlEjcKCnByb3Bl'
    'cnRpZXMYBiABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0Ugpwcm9wZXJ0aWVz');

@$core.Deprecated('Use agentSaveRequestDescriptor instead')
const AgentSaveRequest$json = {
  '1': 'AgentSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.field.v1.AgentObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `AgentSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentSaveRequestDescriptor = $convert.base64Decode(
    'ChBBZ2VudFNhdmVSZXF1ZXN0EjEKBGRhdGEYASABKAsyFS5maWVsZC52MS5BZ2VudE9iamVjdE'
    'IGukgDyAEBUgRkYXRh');

@$core.Deprecated('Use agentSaveResponseDescriptor instead')
const AgentSaveResponse$json = {
  '1': 'AgentSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.field.v1.AgentObject', '10': 'data'},
  ],
};

/// Descriptor for `AgentSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentSaveResponseDescriptor = $convert.base64Decode(
    'ChFBZ2VudFNhdmVSZXNwb25zZRIpCgRkYXRhGAEgASgLMhUuZmllbGQudjEuQWdlbnRPYmplY3'
    'RSBGRhdGE=');

@$core.Deprecated('Use agentGetRequestDescriptor instead')
const AgentGetRequest$json = {
  '1': 'AgentGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `AgentGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentGetRequestDescriptor = $convert.base64Decode(
    'Cg9BZ2VudEdldFJlcXVlc3QSKwoCaWQYASABKAlCG7pIGHIWEAMYKDIQWzAtOWEtel8tXXszLD'
    'QwfVICaWQ=');

@$core.Deprecated('Use agentGetResponseDescriptor instead')
const AgentGetResponse$json = {
  '1': 'AgentGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.field.v1.AgentObject', '10': 'data'},
  ],
};

/// Descriptor for `AgentGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentGetResponseDescriptor = $convert.base64Decode(
    'ChBBZ2VudEdldFJlc3BvbnNlEikKBGRhdGEYASABKAsyFS5maWVsZC52MS5BZ2VudE9iamVjdF'
    'IEZGF0YQ==');

@$core.Deprecated('Use agentSearchRequestDescriptor instead')
const AgentSearchRequest$json = {
  '1': 'AgentSearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'branch_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'branchId'},
    {'1': 'parent_agent_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'parentAgentId'},
    {'1': 'cursor', '3': 4, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `AgentSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentSearchRequestDescriptor = $convert.base64Decode(
    'ChJBZ2VudFNlYXJjaFJlcXVlc3QSFAoFcXVlcnkYASABKAlSBXF1ZXJ5EikKCWJyYW5jaF9pZB'
    'gCIAEoCUIMukgJ2AEBcgQQAxgoUghicmFuY2hJZBI0Cg9wYXJlbnRfYWdlbnRfaWQYAyABKAlC'
    'DLpICdgBAXIEEAMYKFINcGFyZW50QWdlbnRJZBItCgZjdXJzb3IYBCABKAsyFS5jb21tb24udj'
    'EuUGFnZUN1cnNvclIGY3Vyc29y');

@$core.Deprecated('Use agentSearchResponseDescriptor instead')
const AgentSearchResponse$json = {
  '1': 'AgentSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.field.v1.AgentObject', '10': 'data'},
  ],
};

/// Descriptor for `AgentSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentSearchResponseDescriptor = $convert.base64Decode(
    'ChNBZ2VudFNlYXJjaFJlc3BvbnNlEikKBGRhdGEYASADKAsyFS5maWVsZC52MS5BZ2VudE9iam'
    'VjdFIEZGF0YQ==');

@$core.Deprecated('Use agentHierarchyRequestDescriptor instead')
const AgentHierarchyRequest$json = {
  '1': 'AgentHierarchyRequest',
  '2': [
    {'1': 'agent_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'agentId'},
    {'1': 'max_depth', '3': 2, '4': 1, '5': 5, '10': 'maxDepth'},
  ],
};

/// Descriptor for `AgentHierarchyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentHierarchyRequestDescriptor = $convert.base64Decode(
    'ChVBZ2VudEhpZXJhcmNoeVJlcXVlc3QSNgoIYWdlbnRfaWQYASABKAlCG7pIGHIWEAMYKDIQWz'
    'AtOWEtel8tXXszLDQwfVIHYWdlbnRJZBIbCgltYXhfZGVwdGgYAiABKAVSCG1heERlcHRo');

@$core.Deprecated('Use agentHierarchyResponseDescriptor instead')
const AgentHierarchyResponse$json = {
  '1': 'AgentHierarchyResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.field.v1.AgentObject', '10': 'data'},
  ],
};

/// Descriptor for `AgentHierarchyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentHierarchyResponseDescriptor = $convert.base64Decode(
    'ChZBZ2VudEhpZXJhcmNoeVJlc3BvbnNlEikKBGRhdGEYASADKAsyFS5maWVsZC52MS5BZ2VudE'
    '9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use borrowerSaveRequestDescriptor instead')
const BorrowerSaveRequest$json = {
  '1': 'BorrowerSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.field.v1.BorrowerObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `BorrowerSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List borrowerSaveRequestDescriptor = $convert.base64Decode(
    'ChNCb3Jyb3dlclNhdmVSZXF1ZXN0EjQKBGRhdGEYASABKAsyGC5maWVsZC52MS5Cb3Jyb3dlck'
    '9iamVjdEIGukgDyAEBUgRkYXRh');

@$core.Deprecated('Use borrowerSaveResponseDescriptor instead')
const BorrowerSaveResponse$json = {
  '1': 'BorrowerSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.field.v1.BorrowerObject', '10': 'data'},
  ],
};

/// Descriptor for `BorrowerSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List borrowerSaveResponseDescriptor = $convert.base64Decode(
    'ChRCb3Jyb3dlclNhdmVSZXNwb25zZRIsCgRkYXRhGAEgASgLMhguZmllbGQudjEuQm9ycm93ZX'
    'JPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use borrowerGetRequestDescriptor instead')
const BorrowerGetRequest$json = {
  '1': 'BorrowerGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `BorrowerGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List borrowerGetRequestDescriptor = $convert.base64Decode(
    'ChJCb3Jyb3dlckdldFJlcXVlc3QSKwoCaWQYASABKAlCG7pIGHIWEAMYKDIQWzAtOWEtel8tXX'
    'szLDQwfVICaWQ=');

@$core.Deprecated('Use borrowerGetResponseDescriptor instead')
const BorrowerGetResponse$json = {
  '1': 'BorrowerGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.field.v1.BorrowerObject', '10': 'data'},
  ],
};

/// Descriptor for `BorrowerGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List borrowerGetResponseDescriptor = $convert.base64Decode(
    'ChNCb3Jyb3dlckdldFJlc3BvbnNlEiwKBGRhdGEYASABKAsyGC5maWVsZC52MS5Cb3Jyb3dlck'
    '9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use borrowerSearchRequestDescriptor instead')
const BorrowerSearchRequest$json = {
  '1': 'BorrowerSearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'agent_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'agentId'},
    {'1': 'cursor', '3': 3, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `BorrowerSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List borrowerSearchRequestDescriptor = $convert.base64Decode(
    'ChVCb3Jyb3dlclNlYXJjaFJlcXVlc3QSFAoFcXVlcnkYASABKAlSBXF1ZXJ5EicKCGFnZW50X2'
    'lkGAIgASgJQgy6SAnYAQFyBBADGChSB2FnZW50SWQSLQoGY3Vyc29yGAMgASgLMhUuY29tbW9u'
    'LnYxLlBhZ2VDdXJzb3JSBmN1cnNvcg==');

@$core.Deprecated('Use borrowerSearchResponseDescriptor instead')
const BorrowerSearchResponse$json = {
  '1': 'BorrowerSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.field.v1.BorrowerObject', '10': 'data'},
  ],
};

/// Descriptor for `BorrowerSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List borrowerSearchResponseDescriptor = $convert.base64Decode(
    'ChZCb3Jyb3dlclNlYXJjaFJlc3BvbnNlEiwKBGRhdGEYASADKAsyGC5maWVsZC52MS5Cb3Jyb3'
    'dlck9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use borrowerReassignRequestDescriptor instead')
const BorrowerReassignRequest$json = {
  '1': 'BorrowerReassignRequest',
  '2': [
    {'1': 'borrower_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'borrowerId'},
    {'1': 'new_agent_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'newAgentId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `BorrowerReassignRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List borrowerReassignRequestDescriptor = $convert.base64Decode(
    'ChdCb3Jyb3dlclJlYXNzaWduUmVxdWVzdBI8Cgtib3Jyb3dlcl9pZBgBIAEoCUIbukgYchYQAx'
    'goMhBbMC05YS16Xy1dezMsNDB9Ugpib3Jyb3dlcklkEj0KDG5ld19hZ2VudF9pZBgCIAEoCUIb'
    'ukgYchYQAxgoMhBbMC05YS16Xy1dezMsNDB9UgpuZXdBZ2VudElkEhYKBnJlYXNvbhgDIAEoCV'
    'IGcmVhc29u');

@$core.Deprecated('Use borrowerReassignResponseDescriptor instead')
const BorrowerReassignResponse$json = {
  '1': 'BorrowerReassignResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.field.v1.BorrowerObject', '10': 'data'},
  ],
};

/// Descriptor for `BorrowerReassignResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List borrowerReassignResponseDescriptor = $convert.base64Decode(
    'ChhCb3Jyb3dlclJlYXNzaWduUmVzcG9uc2USLAoEZGF0YRgBIAEoCzIYLmZpZWxkLnYxLkJvcn'
    'Jvd2VyT2JqZWN0UgRkYXRh');

const $core.Map<$core.String, $core.dynamic> FieldServiceBase$json = {
  '1': 'FieldService',
  '2': [
    {'1': 'AgentSave', '2': '.field.v1.AgentSaveRequest', '3': '.field.v1.AgentSaveResponse', '4': {}},
    {
      '1': 'AgentGet',
      '2': '.field.v1.AgentGetRequest',
      '3': '.field.v1.AgentGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'AgentSearch',
      '2': '.field.v1.AgentSearchRequest',
      '3': '.field.v1.AgentSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {
      '1': 'AgentHierarchy',
      '2': '.field.v1.AgentHierarchyRequest',
      '3': '.field.v1.AgentHierarchyResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'BorrowerSave', '2': '.field.v1.BorrowerSaveRequest', '3': '.field.v1.BorrowerSaveResponse', '4': {}},
    {
      '1': 'BorrowerGet',
      '2': '.field.v1.BorrowerGetRequest',
      '3': '.field.v1.BorrowerGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'BorrowerSearch',
      '2': '.field.v1.BorrowerSearchRequest',
      '3': '.field.v1.BorrowerSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'BorrowerReassign', '2': '.field.v1.BorrowerReassignRequest', '3': '.field.v1.BorrowerReassignResponse', '4': {}},
  ],
};

@$core.Deprecated('Use fieldServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> FieldServiceBase$messageJson = {
  '.field.v1.AgentSaveRequest': AgentSaveRequest$json,
  '.field.v1.AgentObject': AgentObject$json,
  '.google.protobuf.Struct': $6.Struct$json,
  '.google.protobuf.Struct.FieldsEntry': $6.Struct_FieldsEntry$json,
  '.google.protobuf.Value': $6.Value$json,
  '.google.protobuf.ListValue': $6.ListValue$json,
  '.field.v1.AgentSaveResponse': AgentSaveResponse$json,
  '.field.v1.AgentGetRequest': AgentGetRequest$json,
  '.field.v1.AgentGetResponse': AgentGetResponse$json,
  '.field.v1.AgentSearchRequest': AgentSearchRequest$json,
  '.common.v1.PageCursor': $7.PageCursor$json,
  '.field.v1.AgentSearchResponse': AgentSearchResponse$json,
  '.field.v1.AgentHierarchyRequest': AgentHierarchyRequest$json,
  '.field.v1.AgentHierarchyResponse': AgentHierarchyResponse$json,
  '.field.v1.BorrowerSaveRequest': BorrowerSaveRequest$json,
  '.field.v1.BorrowerObject': BorrowerObject$json,
  '.field.v1.BorrowerSaveResponse': BorrowerSaveResponse$json,
  '.field.v1.BorrowerGetRequest': BorrowerGetRequest$json,
  '.field.v1.BorrowerGetResponse': BorrowerGetResponse$json,
  '.field.v1.BorrowerSearchRequest': BorrowerSearchRequest$json,
  '.field.v1.BorrowerSearchResponse': BorrowerSearchResponse$json,
  '.field.v1.BorrowerReassignRequest': BorrowerReassignRequest$json,
  '.field.v1.BorrowerReassignResponse': BorrowerReassignResponse$json,
};

/// Descriptor for `FieldService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List fieldServiceDescriptor = $convert.base64Decode(
    'CgxGaWVsZFNlcnZpY2USnwIKCUFnZW50U2F2ZRIaLmZpZWxkLnYxLkFnZW50U2F2ZVJlcXVlc3'
    'QaGy5maWVsZC52MS5BZ2VudFNhdmVSZXNwb25zZSLYAbpH1AEKBkFnZW50cxIZQ3JlYXRlIG9y'
    'IHVwZGF0ZSBhbiBhZ2VudBqjAUNyZWF0ZXMgYSBuZXcgYWdlbnQgb3IgdXBkYXRlcyBhbiBleG'
    'lzdGluZyBvbmUuIFdoZW4gYSBwYXJlbnRfYWdlbnRfaWQgaXMgc2V0LCB0aGUgYWdlbnQgaW5o'
    'ZXJpdHMgdGhlIGJyYW5jaCBmcm9tIHRoZSBwYXJlbnQgYW5kIGRlcHRoIGlzIGNhbGN1bGF0ZW'
    'QgYXV0b21hdGljYWxseS4qCWFnZW50U2F2ZRKmAQoIQWdlbnRHZXQSGS5maWVsZC52MS5BZ2Vu'
    'dEdldFJlcXVlc3QaGi5maWVsZC52MS5BZ2VudEdldFJlc3BvbnNlImOQAgG6R10KBkFnZW50cx'
    'ISR2V0IGFuIGFnZW50IGJ5IElEGjVSZXRyaWV2ZXMgYW4gYWdlbnQgcmVjb3JkIGJ5IHRoZWly'
    'IHVuaXF1ZSBpZGVudGlmaWVyLioIYWdlbnRHZXQSiAIKC0FnZW50U2VhcmNoEhwuZmllbGQudj'
    'EuQWdlbnRTZWFyY2hSZXF1ZXN0Gh0uZmllbGQudjEuQWdlbnRTZWFyY2hSZXNwb25zZSK5AZAC'
    'AbpHsgEKBkFnZW50cxINU2VhcmNoIGFnZW50cxqLAVNlYXJjaGVzIGZvciBhZ2VudHMgbWF0Y2'
    'hpbmcgc3BlY2lmaWVkIGNyaXRlcmlhLiBTdXBwb3J0cyBmaWx0ZXJpbmcgYnkgYnJhbmNoIGFu'
    'ZCBwYXJlbnQgYWdlbnQuIFJldHVybnMgYSBzdHJlYW0gb2YgbWF0Y2hpbmcgYWdlbnQgcmVjb3'
    'Jkcy4qC2FnZW50U2VhcmNoMAES/AEKDkFnZW50SGllcmFyY2h5Eh8uZmllbGQudjEuQWdlbnRI'
    'aWVyYXJjaHlSZXF1ZXN0GiAuZmllbGQudjEuQWdlbnRIaWVyYXJjaHlSZXNwb25zZSKkAZACAb'
    'pHnQEKBkFnZW50cxITR2V0IGFnZW50IGhpZXJhcmNoeRpuUmV0cmlldmVzIGFsbCBkZXNjZW5k'
    'YW50cyBvZiB0aGUgc3BlY2lmaWVkIGFnZW50IGluIHRoZSBoaWVyYXJjaHkgdHJlZS4gU3VwcG'
    '9ydHMgbGltaXRpbmcgdGhlIHRyYXZlcnNhbCBkZXB0aC4qDmFnZW50SGllcmFyY2h5MAESkQIK'
    'DEJvcnJvd2VyU2F2ZRIdLmZpZWxkLnYxLkJvcnJvd2VyU2F2ZVJlcXVlc3QaHi5maWVsZC52MS'
    '5Cb3Jyb3dlclNhdmVSZXNwb25zZSLBAbpHvQEKCUJvcnJvd2VycxIcT25ib2FyZCBvciB1cGRh'
    'dGUgYSBib3Jyb3dlchqDAU9uYm9hcmRzIGEgbmV3IGJvcnJvd2VyIG9yIHVwZGF0ZXMgYW4gZX'
    'hpc3Rpbmcgb25lLiBFYWNoIGJvcnJvd2VyIG11c3QgaGF2ZSBhIHVuaXF1ZSBwcm9maWxlIElE'
    'IGFuZCBiZSBhc3NpZ25lZCB0byBhbiBhY3RpdmUgYWdlbnQuKgxib3Jyb3dlclNhdmUSuQEKC0'
    'JvcnJvd2VyR2V0EhwuZmllbGQudjEuQm9ycm93ZXJHZXRSZXF1ZXN0Gh0uZmllbGQudjEuQm9y'
    'cm93ZXJHZXRSZXNwb25zZSJtkAIBukdnCglCb3Jyb3dlcnMSFEdldCBhIGJvcnJvd2VyIGJ5IE'
    'lEGjdSZXRyaWV2ZXMgYSBib3Jyb3dlciByZWNvcmQgYnkgdGhlaXIgdW5pcXVlIGlkZW50aWZp'
    'ZXIuKgtib3Jyb3dlckdldBKNAgoOQm9ycm93ZXJTZWFyY2gSHy5maWVsZC52MS5Cb3Jyb3dlcl'
    'NlYXJjaFJlcXVlc3QaIC5maWVsZC52MS5Cb3Jyb3dlclNlYXJjaFJlc3BvbnNlIrUBkAIBukeu'
    'AQoJQm9ycm93ZXJzEhBTZWFyY2ggYm9ycm93ZXJzGn9TZWFyY2hlcyBmb3IgYm9ycm93ZXJzIG'
    '1hdGNoaW5nIHNwZWNpZmllZCBjcml0ZXJpYS4gU3VwcG9ydHMgZmlsdGVyaW5nIGJ5IGFnZW50'
    'LiBSZXR1cm5zIGEgc3RyZWFtIG9mIG1hdGNoaW5nIGJvcnJvd2VyIHJlY29yZHMuKg5ib3Jyb3'
    'dlclNlYXJjaDABEqYCChBCb3Jyb3dlclJlYXNzaWduEiEuZmllbGQudjEuQm9ycm93ZXJSZWFz'
    'c2lnblJlcXVlc3QaIi5maWVsZC52MS5Cb3Jyb3dlclJlYXNzaWduUmVzcG9uc2UiygG6R8YBCg'
    'lCb3Jyb3dlcnMSE1JlYXNzaWduIGEgYm9ycm93ZXIakQFNb3ZlcyBhIGJvcnJvd2VyIGZyb20g'
    'dGhlaXIgY3VycmVudCBhZ2VudCB0byBhIGRpZmZlcmVudCBhZ2VudC4gQm90aCBhZ2VudHMgbX'
    'VzdCBiZSBpbiB0aGUgc2FtZSBiYW5rLiBDcmVhdGVzIGFuIGF1ZGl0IHRyYWlsIG9mIHRoZSBy'
    'ZWFzc2lnbm1lbnQuKhBib3Jyb3dlclJlYXNzaWdu');

