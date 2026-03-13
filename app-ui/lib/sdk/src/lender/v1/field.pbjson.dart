//
//  Generated code. Do not modify.
//  source: lender/v1/field.proto
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
    {'1': 'agent_type', '3': 5, '4': 1, '5': 14, '6': '.lender.v1.AgentType', '10': 'agentType'},
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
    '9pZBgEIAEoCUIJukgGcgQQAxgoUglwcm9maWxlSWQSMwoKYWdlbnRfdHlwZRgFIAEoDjIULmxl'
    'bmRlci52MS5BZ2VudFR5cGVSCWFnZW50VHlwZRIbCgRuYW1lGAYgASgJQge6SARyAhABUgRuYW'
    '1lEiEKBmdlb19pZBgHIAEoCUIKukgH2AEBcgIYKFIFZ2VvSWQSFAoFZGVwdGgYCCABKAVSBWRl'
    'cHRoEiYKBXN0YXRlGAkgASgOMhAuY29tbW9uLnYxLlNUQVRFUgVzdGF0ZRI3Cgpwcm9wZXJ0aW'
    'VzGAogASgLMhcuZ29vZ2xlLnByb3RvYnVmLlN0cnVjdFIKcHJvcGVydGllcw==');

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
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.AgentObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `AgentSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentSaveRequestDescriptor = $convert.base64Decode(
    'ChBBZ2VudFNhdmVSZXF1ZXN0EjIKBGRhdGEYASABKAsyFi5sZW5kZXIudjEuQWdlbnRPYmplY3'
    'RCBrpIA8gBAVIEZGF0YQ==');

@$core.Deprecated('Use agentSaveResponseDescriptor instead')
const AgentSaveResponse$json = {
  '1': 'AgentSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.AgentObject', '10': 'data'},
  ],
};

/// Descriptor for `AgentSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentSaveResponseDescriptor = $convert.base64Decode(
    'ChFBZ2VudFNhdmVSZXNwb25zZRIqCgRkYXRhGAEgASgLMhYubGVuZGVyLnYxLkFnZW50T2JqZW'
    'N0UgRkYXRh');

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
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.AgentObject', '10': 'data'},
  ],
};

/// Descriptor for `AgentGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentGetResponseDescriptor = $convert.base64Decode(
    'ChBBZ2VudEdldFJlc3BvbnNlEioKBGRhdGEYASABKAsyFi5sZW5kZXIudjEuQWdlbnRPYmplY3'
    'RSBGRhdGE=');

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
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.lender.v1.AgentObject', '10': 'data'},
  ],
};

/// Descriptor for `AgentSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentSearchResponseDescriptor = $convert.base64Decode(
    'ChNBZ2VudFNlYXJjaFJlc3BvbnNlEioKBGRhdGEYASADKAsyFi5sZW5kZXIudjEuQWdlbnRPYm'
    'plY3RSBGRhdGE=');

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
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.lender.v1.AgentObject', '10': 'data'},
  ],
};

/// Descriptor for `AgentHierarchyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentHierarchyResponseDescriptor = $convert.base64Decode(
    'ChZBZ2VudEhpZXJhcmNoeVJlc3BvbnNlEioKBGRhdGEYASADKAsyFi5sZW5kZXIudjEuQWdlbn'
    'RPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use borrowerSaveRequestDescriptor instead')
const BorrowerSaveRequest$json = {
  '1': 'BorrowerSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.BorrowerObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `BorrowerSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List borrowerSaveRequestDescriptor = $convert.base64Decode(
    'ChNCb3Jyb3dlclNhdmVSZXF1ZXN0EjUKBGRhdGEYASABKAsyGS5sZW5kZXIudjEuQm9ycm93ZX'
    'JPYmplY3RCBrpIA8gBAVIEZGF0YQ==');

@$core.Deprecated('Use borrowerSaveResponseDescriptor instead')
const BorrowerSaveResponse$json = {
  '1': 'BorrowerSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.BorrowerObject', '10': 'data'},
  ],
};

/// Descriptor for `BorrowerSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List borrowerSaveResponseDescriptor = $convert.base64Decode(
    'ChRCb3Jyb3dlclNhdmVSZXNwb25zZRItCgRkYXRhGAEgASgLMhkubGVuZGVyLnYxLkJvcnJvd2'
    'VyT2JqZWN0UgRkYXRh');

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
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.BorrowerObject', '10': 'data'},
  ],
};

/// Descriptor for `BorrowerGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List borrowerGetResponseDescriptor = $convert.base64Decode(
    'ChNCb3Jyb3dlckdldFJlc3BvbnNlEi0KBGRhdGEYASABKAsyGS5sZW5kZXIudjEuQm9ycm93ZX'
    'JPYmplY3RSBGRhdGE=');

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
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.lender.v1.BorrowerObject', '10': 'data'},
  ],
};

/// Descriptor for `BorrowerSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List borrowerSearchResponseDescriptor = $convert.base64Decode(
    'ChZCb3Jyb3dlclNlYXJjaFJlc3BvbnNlEi0KBGRhdGEYASADKAsyGS5sZW5kZXIudjEuQm9ycm'
    '93ZXJPYmplY3RSBGRhdGE=');

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
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.BorrowerObject', '10': 'data'},
  ],
};

/// Descriptor for `BorrowerReassignResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List borrowerReassignResponseDescriptor = $convert.base64Decode(
    'ChhCb3Jyb3dlclJlYXNzaWduUmVzcG9uc2USLQoEZGF0YRgBIAEoCzIZLmxlbmRlci52MS5Cb3'
    'Jyb3dlck9iamVjdFIEZGF0YQ==');

const $core.Map<$core.String, $core.dynamic> FieldServiceBase$json = {
  '1': 'FieldService',
  '2': [
    {'1': 'AgentSave', '2': '.lender.v1.AgentSaveRequest', '3': '.lender.v1.AgentSaveResponse', '4': {}},
    {
      '1': 'AgentGet',
      '2': '.lender.v1.AgentGetRequest',
      '3': '.lender.v1.AgentGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'AgentSearch',
      '2': '.lender.v1.AgentSearchRequest',
      '3': '.lender.v1.AgentSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {
      '1': 'AgentHierarchy',
      '2': '.lender.v1.AgentHierarchyRequest',
      '3': '.lender.v1.AgentHierarchyResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'BorrowerSave', '2': '.lender.v1.BorrowerSaveRequest', '3': '.lender.v1.BorrowerSaveResponse', '4': {}},
    {
      '1': 'BorrowerGet',
      '2': '.lender.v1.BorrowerGetRequest',
      '3': '.lender.v1.BorrowerGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'BorrowerSearch',
      '2': '.lender.v1.BorrowerSearchRequest',
      '3': '.lender.v1.BorrowerSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'BorrowerReassign', '2': '.lender.v1.BorrowerReassignRequest', '3': '.lender.v1.BorrowerReassignResponse', '4': {}},
  ],
};

@$core.Deprecated('Use fieldServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> FieldServiceBase$messageJson = {
  '.lender.v1.AgentSaveRequest': AgentSaveRequest$json,
  '.lender.v1.AgentObject': AgentObject$json,
  '.google.protobuf.Struct': $6.Struct$json,
  '.google.protobuf.Struct.FieldsEntry': $6.Struct_FieldsEntry$json,
  '.google.protobuf.Value': $6.Value$json,
  '.google.protobuf.ListValue': $6.ListValue$json,
  '.lender.v1.AgentSaveResponse': AgentSaveResponse$json,
  '.lender.v1.AgentGetRequest': AgentGetRequest$json,
  '.lender.v1.AgentGetResponse': AgentGetResponse$json,
  '.lender.v1.AgentSearchRequest': AgentSearchRequest$json,
  '.common.v1.PageCursor': $7.PageCursor$json,
  '.lender.v1.AgentSearchResponse': AgentSearchResponse$json,
  '.lender.v1.AgentHierarchyRequest': AgentHierarchyRequest$json,
  '.lender.v1.AgentHierarchyResponse': AgentHierarchyResponse$json,
  '.lender.v1.BorrowerSaveRequest': BorrowerSaveRequest$json,
  '.lender.v1.BorrowerObject': BorrowerObject$json,
  '.lender.v1.BorrowerSaveResponse': BorrowerSaveResponse$json,
  '.lender.v1.BorrowerGetRequest': BorrowerGetRequest$json,
  '.lender.v1.BorrowerGetResponse': BorrowerGetResponse$json,
  '.lender.v1.BorrowerSearchRequest': BorrowerSearchRequest$json,
  '.lender.v1.BorrowerSearchResponse': BorrowerSearchResponse$json,
  '.lender.v1.BorrowerReassignRequest': BorrowerReassignRequest$json,
  '.lender.v1.BorrowerReassignResponse': BorrowerReassignResponse$json,
};

/// Descriptor for `FieldService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List fieldServiceDescriptor = $convert.base64Decode(
    'CgxGaWVsZFNlcnZpY2USoQIKCUFnZW50U2F2ZRIbLmxlbmRlci52MS5BZ2VudFNhdmVSZXF1ZX'
    'N0GhwubGVuZGVyLnYxLkFnZW50U2F2ZVJlc3BvbnNlItgBukfUAQoGQWdlbnRzEhlDcmVhdGUg'
    'b3IgdXBkYXRlIGFuIGFnZW50GqMBQ3JlYXRlcyBhIG5ldyBhZ2VudCBvciB1cGRhdGVzIGFuIG'
    'V4aXN0aW5nIG9uZS4gV2hlbiBhIHBhcmVudF9hZ2VudF9pZCBpcyBzZXQsIHRoZSBhZ2VudCBp'
    'bmhlcml0cyB0aGUgYnJhbmNoIGZyb20gdGhlIHBhcmVudCBhbmQgZGVwdGggaXMgY2FsY3VsYX'
    'RlZCBhdXRvbWF0aWNhbGx5LioJYWdlbnRTYXZlEqgBCghBZ2VudEdldBIaLmxlbmRlci52MS5B'
    'Z2VudEdldFJlcXVlc3QaGy5sZW5kZXIudjEuQWdlbnRHZXRSZXNwb25zZSJjkAIBukddCgZBZ2'
    'VudHMSEkdldCBhbiBhZ2VudCBieSBJRBo1UmV0cmlldmVzIGFuIGFnZW50IHJlY29yZCBieSB0'
    'aGVpciB1bmlxdWUgaWRlbnRpZmllci4qCGFnZW50R2V0EooCCgtBZ2VudFNlYXJjaBIdLmxlbm'
    'Rlci52MS5BZ2VudFNlYXJjaFJlcXVlc3QaHi5sZW5kZXIudjEuQWdlbnRTZWFyY2hSZXNwb25z'
    'ZSK5AZACAbpHsgEKBkFnZW50cxINU2VhcmNoIGFnZW50cxqLAVNlYXJjaGVzIGZvciBhZ2VudH'
    'MgbWF0Y2hpbmcgc3BlY2lmaWVkIGNyaXRlcmlhLiBTdXBwb3J0cyBmaWx0ZXJpbmcgYnkgYnJh'
    'bmNoIGFuZCBwYXJlbnQgYWdlbnQuIFJldHVybnMgYSBzdHJlYW0gb2YgbWF0Y2hpbmcgYWdlbn'
    'QgcmVjb3Jkcy4qC2FnZW50U2VhcmNoMAES/gEKDkFnZW50SGllcmFyY2h5EiAubGVuZGVyLnYx'
    'LkFnZW50SGllcmFyY2h5UmVxdWVzdBohLmxlbmRlci52MS5BZ2VudEhpZXJhcmNoeVJlc3Bvbn'
    'NlIqQBkAIBukedAQoGQWdlbnRzEhNHZXQgYWdlbnQgaGllcmFyY2h5Gm5SZXRyaWV2ZXMgYWxs'
    'IGRlc2NlbmRhbnRzIG9mIHRoZSBzcGVjaWZpZWQgYWdlbnQgaW4gdGhlIGhpZXJhcmNoeSB0cm'
    'VlLiBTdXBwb3J0cyBsaW1pdGluZyB0aGUgdHJhdmVyc2FsIGRlcHRoLioOYWdlbnRIaWVyYXJj'
    'aHkwARKTAgoMQm9ycm93ZXJTYXZlEh4ubGVuZGVyLnYxLkJvcnJvd2VyU2F2ZVJlcXVlc3QaHy'
    '5sZW5kZXIudjEuQm9ycm93ZXJTYXZlUmVzcG9uc2UiwQG6R70BCglCb3Jyb3dlcnMSHE9uYm9h'
    'cmQgb3IgdXBkYXRlIGEgYm9ycm93ZXIagwFPbmJvYXJkcyBhIG5ldyBib3Jyb3dlciBvciB1cG'
    'RhdGVzIGFuIGV4aXN0aW5nIG9uZS4gRWFjaCBib3Jyb3dlciBtdXN0IGhhdmUgYSB1bmlxdWUg'
    'cHJvZmlsZSBJRCBhbmQgYmUgYXNzaWduZWQgdG8gYW4gYWN0aXZlIGFnZW50LioMYm9ycm93ZX'
    'JTYXZlErsBCgtCb3Jyb3dlckdldBIdLmxlbmRlci52MS5Cb3Jyb3dlckdldFJlcXVlc3QaHi5s'
    'ZW5kZXIudjEuQm9ycm93ZXJHZXRSZXNwb25zZSJtkAIBukdnCglCb3Jyb3dlcnMSFEdldCBhIG'
    'JvcnJvd2VyIGJ5IElEGjdSZXRyaWV2ZXMgYSBib3Jyb3dlciByZWNvcmQgYnkgdGhlaXIgdW5p'
    'cXVlIGlkZW50aWZpZXIuKgtib3Jyb3dlckdldBKPAgoOQm9ycm93ZXJTZWFyY2gSIC5sZW5kZX'
    'IudjEuQm9ycm93ZXJTZWFyY2hSZXF1ZXN0GiEubGVuZGVyLnYxLkJvcnJvd2VyU2VhcmNoUmVz'
    'cG9uc2UitQGQAgG6R64BCglCb3Jyb3dlcnMSEFNlYXJjaCBib3Jyb3dlcnMaf1NlYXJjaGVzIG'
    'ZvciBib3Jyb3dlcnMgbWF0Y2hpbmcgc3BlY2lmaWVkIGNyaXRlcmlhLiBTdXBwb3J0cyBmaWx0'
    'ZXJpbmcgYnkgYWdlbnQuIFJldHVybnMgYSBzdHJlYW0gb2YgbWF0Y2hpbmcgYm9ycm93ZXIgcm'
    'Vjb3Jkcy4qDmJvcnJvd2VyU2VhcmNoMAESqAIKEEJvcnJvd2VyUmVhc3NpZ24SIi5sZW5kZXIu'
    'djEuQm9ycm93ZXJSZWFzc2lnblJlcXVlc3QaIy5sZW5kZXIudjEuQm9ycm93ZXJSZWFzc2lnbl'
    'Jlc3BvbnNlIsoBukfGAQoJQm9ycm93ZXJzEhNSZWFzc2lnbiBhIGJvcnJvd2VyGpEBTW92ZXMg'
    'YSBib3Jyb3dlciBmcm9tIHRoZWlyIGN1cnJlbnQgYWdlbnQgdG8gYSBkaWZmZXJlbnQgYWdlbn'
    'QuIEJvdGggYWdlbnRzIG11c3QgYmUgaW4gdGhlIHNhbWUgYmFuay4gQ3JlYXRlcyBhbiBhdWRp'
    'dCB0cmFpbCBvZiB0aGUgcmVhc3NpZ25tZW50LioQYm9ycm93ZXJSZWFzc2lnbg==');

