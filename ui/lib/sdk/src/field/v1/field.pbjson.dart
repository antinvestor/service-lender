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
    {'1': 'organization_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'organizationId'},
    {'1': 'parent_agent_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'parentAgentId'},
    {'1': 'profile_id', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'profileId'},
    {'1': 'agent_type', '3': 5, '4': 1, '5': 14, '6': '.field.v1.AgentType', '10': 'agentType'},
    {'1': 'name', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'geo_id', '3': 7, '4': 1, '5': 9, '8': {}, '10': 'geoId'},
    {'1': 'depth', '3': 8, '4': 1, '5': 5, '10': 'depth'},
    {'1': 'state', '3': 9, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'properties', '3': 10, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
    {'1': 'branch_ids', '3': 11, '4': 3, '5': 9, '10': 'branchIds'},
  ],
};

/// Descriptor for `AgentObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentObjectDescriptor = $convert.base64Decode(
    'CgtBZ2VudE9iamVjdBIuCgJpZBgBIAEoCUIeukgb2AEBchYQAxgoMhBbMC05YS16Xy1dezMsND'
    'B9UgJpZBIyCg9vcmdhbml6YXRpb25faWQYAiABKAlCCbpIBnIEEAMYKFIOb3JnYW5pemF0aW9u'
    'SWQSNAoPcGFyZW50X2FnZW50X2lkGAMgASgJQgy6SAnYAQFyBBADGChSDXBhcmVudEFnZW50SW'
    'QSKAoKcHJvZmlsZV9pZBgEIAEoCUIJukgGcgQQAxgoUglwcm9maWxlSWQSMgoKYWdlbnRfdHlw'
    'ZRgFIAEoDjITLmZpZWxkLnYxLkFnZW50VHlwZVIJYWdlbnRUeXBlEhsKBG5hbWUYBiABKAlCB7'
    'pIBHICEAFSBG5hbWUSIQoGZ2VvX2lkGAcgASgJQgq6SAfYAQFyAhgoUgVnZW9JZBIUCgVkZXB0'
    'aBgIIAEoBVIFZGVwdGgSJgoFc3RhdGUYCSABKA4yEC5jb21tb24udjEuU1RBVEVSBXN0YXRlEj'
    'cKCnByb3BlcnRpZXMYCiABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0Ugpwcm9wZXJ0aWVz'
    'Eh0KCmJyYW5jaF9pZHMYCyADKAlSCWJyYW5jaElkcw==');

@$core.Deprecated('Use agentBranchObjectDescriptor instead')
const AgentBranchObject$json = {
  '1': 'AgentBranchObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'agent_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'agentId'},
    {'1': 'branch_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'branchId'},
    {'1': 'state', '3': 4, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'properties', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `AgentBranchObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentBranchObjectDescriptor = $convert.base64Decode(
    'ChFBZ2VudEJyYW5jaE9iamVjdBIuCgJpZBgBIAEoCUIeukgb2AEBchYQAxgoMhBbMC05YS16Xy'
    '1dezMsNDB9UgJpZBIkCghhZ2VudF9pZBgCIAEoCUIJukgGcgQQAxgoUgdhZ2VudElkEiYKCWJy'
    'YW5jaF9pZBgDIAEoCUIJukgGcgQQAxgoUghicmFuY2hJZBImCgVzdGF0ZRgEIAEoDjIQLmNvbW'
    '1vbi52MS5TVEFURVIFc3RhdGUSNwoKcHJvcGVydGllcxgFIAEoCzIXLmdvb2dsZS5wcm90b2J1'
    'Zi5TdHJ1Y3RSCnByb3BlcnRpZXM=');

@$core.Deprecated('Use clientObjectDescriptor instead')
const ClientObject$json = {
  '1': 'ClientObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'agent_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'agentId'},
    {'1': 'profile_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'profileId'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'state', '3': 5, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'properties', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `ClientObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientObjectDescriptor = $convert.base64Decode(
    'CgxDbGllbnRPYmplY3QSLgoCaWQYASABKAlCHrpIG9gBAXIWEAMYKDIQWzAtOWEtel8tXXszLD'
    'QwfVICaWQSJAoIYWdlbnRfaWQYAiABKAlCCbpIBnIEEAMYKFIHYWdlbnRJZBIoCgpwcm9maWxl'
    'X2lkGAMgASgJQgm6SAZyBBADGChSCXByb2ZpbGVJZBIbCgRuYW1lGAQgASgJQge6SARyAhABUg'
    'RuYW1lEiYKBXN0YXRlGAUgASgOMhAuY29tbW9uLnYxLlNUQVRFUgVzdGF0ZRI3Cgpwcm9wZXJ0'
    'aWVzGAYgASgLMhcuZ29vZ2xlLnByb3RvYnVmLlN0cnVjdFIKcHJvcGVydGllcw==');

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
    {'1': 'organization_id', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'organizationId'},
  ],
};

/// Descriptor for `AgentSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentSearchRequestDescriptor = $convert.base64Decode(
    'ChJBZ2VudFNlYXJjaFJlcXVlc3QSFAoFcXVlcnkYASABKAlSBXF1ZXJ5EikKCWJyYW5jaF9pZB'
    'gCIAEoCUIMukgJ2AEBcgQQAxgoUghicmFuY2hJZBI0Cg9wYXJlbnRfYWdlbnRfaWQYAyABKAlC'
    'DLpICdgBAXIEEAMYKFINcGFyZW50QWdlbnRJZBItCgZjdXJzb3IYBCABKAsyFS5jb21tb24udj'
    'EuUGFnZUN1cnNvclIGY3Vyc29yEjUKD29yZ2FuaXphdGlvbl9pZBgFIAEoCUIMukgJ2AEBcgQQ'
    'AxgoUg5vcmdhbml6YXRpb25JZA==');

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

@$core.Deprecated('Use agentBranchSaveRequestDescriptor instead')
const AgentBranchSaveRequest$json = {
  '1': 'AgentBranchSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.field.v1.AgentBranchObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `AgentBranchSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentBranchSaveRequestDescriptor = $convert.base64Decode(
    'ChZBZ2VudEJyYW5jaFNhdmVSZXF1ZXN0EjcKBGRhdGEYASABKAsyGy5maWVsZC52MS5BZ2VudE'
    'JyYW5jaE9iamVjdEIGukgDyAEBUgRkYXRh');

@$core.Deprecated('Use agentBranchSaveResponseDescriptor instead')
const AgentBranchSaveResponse$json = {
  '1': 'AgentBranchSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.field.v1.AgentBranchObject', '10': 'data'},
  ],
};

/// Descriptor for `AgentBranchSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentBranchSaveResponseDescriptor = $convert.base64Decode(
    'ChdBZ2VudEJyYW5jaFNhdmVSZXNwb25zZRIvCgRkYXRhGAEgASgLMhsuZmllbGQudjEuQWdlbn'
    'RCcmFuY2hPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use agentBranchDeleteRequestDescriptor instead')
const AgentBranchDeleteRequest$json = {
  '1': 'AgentBranchDeleteRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `AgentBranchDeleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentBranchDeleteRequestDescriptor = $convert.base64Decode(
    'ChhBZ2VudEJyYW5jaERlbGV0ZVJlcXVlc3QSKwoCaWQYASABKAlCG7pIGHIWEAMYKDIQWzAtOW'
    'Etel8tXXszLDQwfVICaWQ=');

@$core.Deprecated('Use agentBranchDeleteResponseDescriptor instead')
const AgentBranchDeleteResponse$json = {
  '1': 'AgentBranchDeleteResponse',
};

/// Descriptor for `AgentBranchDeleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentBranchDeleteResponseDescriptor = $convert.base64Decode(
    'ChlBZ2VudEJyYW5jaERlbGV0ZVJlc3BvbnNl');

@$core.Deprecated('Use agentBranchListRequestDescriptor instead')
const AgentBranchListRequest$json = {
  '1': 'AgentBranchListRequest',
  '2': [
    {'1': 'agent_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'agentId'},
    {'1': 'branch_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'branchId'},
    {'1': 'cursor', '3': 3, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `AgentBranchListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentBranchListRequestDescriptor = $convert.base64Decode(
    'ChZBZ2VudEJyYW5jaExpc3RSZXF1ZXN0EicKCGFnZW50X2lkGAEgASgJQgy6SAnYAQFyBBADGC'
    'hSB2FnZW50SWQSKQoJYnJhbmNoX2lkGAIgASgJQgy6SAnYAQFyBBADGChSCGJyYW5jaElkEi0K'
    'BmN1cnNvchgDIAEoCzIVLmNvbW1vbi52MS5QYWdlQ3Vyc29yUgZjdXJzb3I=');

@$core.Deprecated('Use agentBranchListResponseDescriptor instead')
const AgentBranchListResponse$json = {
  '1': 'AgentBranchListResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.field.v1.AgentBranchObject', '10': 'data'},
  ],
};

/// Descriptor for `AgentBranchListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentBranchListResponseDescriptor = $convert.base64Decode(
    'ChdBZ2VudEJyYW5jaExpc3RSZXNwb25zZRIvCgRkYXRhGAEgAygLMhsuZmllbGQudjEuQWdlbn'
    'RCcmFuY2hPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use clientSaveRequestDescriptor instead')
const ClientSaveRequest$json = {
  '1': 'ClientSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.field.v1.ClientObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `ClientSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientSaveRequestDescriptor = $convert.base64Decode(
    'ChFDbGllbnRTYXZlUmVxdWVzdBIyCgRkYXRhGAEgASgLMhYuZmllbGQudjEuQ2xpZW50T2JqZW'
    'N0Qga6SAPIAQFSBGRhdGE=');

@$core.Deprecated('Use clientSaveResponseDescriptor instead')
const ClientSaveResponse$json = {
  '1': 'ClientSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.field.v1.ClientObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientSaveResponseDescriptor = $convert.base64Decode(
    'ChJDbGllbnRTYXZlUmVzcG9uc2USKgoEZGF0YRgBIAEoCzIWLmZpZWxkLnYxLkNsaWVudE9iam'
    'VjdFIEZGF0YQ==');

@$core.Deprecated('Use clientGetRequestDescriptor instead')
const ClientGetRequest$json = {
  '1': 'ClientGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `ClientGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientGetRequestDescriptor = $convert.base64Decode(
    'ChBDbGllbnRHZXRSZXF1ZXN0EisKAmlkGAEgASgJQhu6SBhyFhADGCgyEFswLTlhLXpfLV17My'
    'w0MH1SAmlk');

@$core.Deprecated('Use clientGetResponseDescriptor instead')
const ClientGetResponse$json = {
  '1': 'ClientGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.field.v1.ClientObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientGetResponseDescriptor = $convert.base64Decode(
    'ChFDbGllbnRHZXRSZXNwb25zZRIqCgRkYXRhGAEgASgLMhYuZmllbGQudjEuQ2xpZW50T2JqZW'
    'N0UgRkYXRh');

@$core.Deprecated('Use clientSearchRequestDescriptor instead')
const ClientSearchRequest$json = {
  '1': 'ClientSearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'agent_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'agentId'},
    {'1': 'cursor', '3': 3, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `ClientSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientSearchRequestDescriptor = $convert.base64Decode(
    'ChNDbGllbnRTZWFyY2hSZXF1ZXN0EhQKBXF1ZXJ5GAEgASgJUgVxdWVyeRInCghhZ2VudF9pZB'
    'gCIAEoCUIMukgJ2AEBcgQQAxgoUgdhZ2VudElkEi0KBmN1cnNvchgDIAEoCzIVLmNvbW1vbi52'
    'MS5QYWdlQ3Vyc29yUgZjdXJzb3I=');

@$core.Deprecated('Use clientSearchResponseDescriptor instead')
const ClientSearchResponse$json = {
  '1': 'ClientSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.field.v1.ClientObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientSearchResponseDescriptor = $convert.base64Decode(
    'ChRDbGllbnRTZWFyY2hSZXNwb25zZRIqCgRkYXRhGAEgAygLMhYuZmllbGQudjEuQ2xpZW50T2'
    'JqZWN0UgRkYXRh');

@$core.Deprecated('Use clientReassignRequestDescriptor instead')
const ClientReassignRequest$json = {
  '1': 'ClientReassignRequest',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'clientId'},
    {'1': 'new_agent_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'newAgentId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ClientReassignRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientReassignRequestDescriptor = $convert.base64Decode(
    'ChVDbGllbnRSZWFzc2lnblJlcXVlc3QSOAoJY2xpZW50X2lkGAEgASgJQhu6SBhyFhADGCgyEF'
    'swLTlhLXpfLV17Myw0MH1SCGNsaWVudElkEj0KDG5ld19hZ2VudF9pZBgCIAEoCUIbukgYchYQ'
    'AxgoMhBbMC05YS16Xy1dezMsNDB9UgpuZXdBZ2VudElkEhYKBnJlYXNvbhgDIAEoCVIGcmVhc2'
    '9u');

@$core.Deprecated('Use clientReassignResponseDescriptor instead')
const ClientReassignResponse$json = {
  '1': 'ClientReassignResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.field.v1.ClientObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientReassignResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientReassignResponseDescriptor = $convert.base64Decode(
    'ChZDbGllbnRSZWFzc2lnblJlc3BvbnNlEioKBGRhdGEYASABKAsyFi5maWVsZC52MS5DbGllbn'
    'RPYmplY3RSBGRhdGE=');

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
    {'1': 'AgentBranchSave', '2': '.field.v1.AgentBranchSaveRequest', '3': '.field.v1.AgentBranchSaveResponse', '4': {}},
    {'1': 'AgentBranchDelete', '2': '.field.v1.AgentBranchDeleteRequest', '3': '.field.v1.AgentBranchDeleteResponse', '4': {}},
    {
      '1': 'AgentBranchList',
      '2': '.field.v1.AgentBranchListRequest',
      '3': '.field.v1.AgentBranchListResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'ClientSave', '2': '.field.v1.ClientSaveRequest', '3': '.field.v1.ClientSaveResponse', '4': {}},
    {
      '1': 'ClientGet',
      '2': '.field.v1.ClientGetRequest',
      '3': '.field.v1.ClientGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'ClientSearch',
      '2': '.field.v1.ClientSearchRequest',
      '3': '.field.v1.ClientSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'ClientReassign', '2': '.field.v1.ClientReassignRequest', '3': '.field.v1.ClientReassignResponse', '4': {}},
  ],
  '3': {},
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
  '.field.v1.AgentBranchSaveRequest': AgentBranchSaveRequest$json,
  '.field.v1.AgentBranchObject': AgentBranchObject$json,
  '.field.v1.AgentBranchSaveResponse': AgentBranchSaveResponse$json,
  '.field.v1.AgentBranchDeleteRequest': AgentBranchDeleteRequest$json,
  '.field.v1.AgentBranchDeleteResponse': AgentBranchDeleteResponse$json,
  '.field.v1.AgentBranchListRequest': AgentBranchListRequest$json,
  '.field.v1.AgentBranchListResponse': AgentBranchListResponse$json,
  '.field.v1.ClientSaveRequest': ClientSaveRequest$json,
  '.field.v1.ClientObject': ClientObject$json,
  '.field.v1.ClientSaveResponse': ClientSaveResponse$json,
  '.field.v1.ClientGetRequest': ClientGetRequest$json,
  '.field.v1.ClientGetResponse': ClientGetResponse$json,
  '.field.v1.ClientSearchRequest': ClientSearchRequest$json,
  '.field.v1.ClientSearchResponse': ClientSearchResponse$json,
  '.field.v1.ClientReassignRequest': ClientReassignRequest$json,
  '.field.v1.ClientReassignResponse': ClientReassignResponse$json,
};

/// Descriptor for `FieldService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List fieldServiceDescriptor = $convert.base64Decode(
    'CgxGaWVsZFNlcnZpY2USsQIKCUFnZW50U2F2ZRIaLmZpZWxkLnYxLkFnZW50U2F2ZVJlcXVlc3'
    'QaGy5maWVsZC52MS5BZ2VudFNhdmVSZXNwb25zZSLqAbpH1AEKBkFnZW50cxIZQ3JlYXRlIG9y'
    'IHVwZGF0ZSBhbiBhZ2VudBqjAUNyZWF0ZXMgYSBuZXcgYWdlbnQgb3IgdXBkYXRlcyBhbiBleG'
    'lzdGluZyBvbmUuIFdoZW4gYSBwYXJlbnRfYWdlbnRfaWQgaXMgc2V0LCB0aGUgYWdlbnQgaW5o'
    'ZXJpdHMgdGhlIGJyYW5jaCBmcm9tIHRoZSBwYXJlbnQgYW5kIGRlcHRoIGlzIGNhbGN1bGF0ZW'
    'QgYXV0b21hdGljYWxseS4qCWFnZW50U2F2ZYK1GA4KDGFnZW50X21hbmFnZRK2AQoIQWdlbnRH'
    'ZXQSGS5maWVsZC52MS5BZ2VudEdldFJlcXVlc3QaGi5maWVsZC52MS5BZ2VudEdldFJlc3Bvbn'
    'NlInOQAgG6R10KBkFnZW50cxISR2V0IGFuIGFnZW50IGJ5IElEGjVSZXRyaWV2ZXMgYW4gYWdl'
    'bnQgcmVjb3JkIGJ5IHRoZWlyIHVuaXF1ZSBpZGVudGlmaWVyLioIYWdlbnRHZXSCtRgMCgphZ2'
    'VudF92aWV3EpgCCgtBZ2VudFNlYXJjaBIcLmZpZWxkLnYxLkFnZW50U2VhcmNoUmVxdWVzdBod'
    'LmZpZWxkLnYxLkFnZW50U2VhcmNoUmVzcG9uc2UiyQGQAgG6R7IBCgZBZ2VudHMSDVNlYXJjaC'
    'BhZ2VudHMaiwFTZWFyY2hlcyBmb3IgYWdlbnRzIG1hdGNoaW5nIHNwZWNpZmllZCBjcml0ZXJp'
    'YS4gU3VwcG9ydHMgZmlsdGVyaW5nIGJ5IGJyYW5jaCBhbmQgcGFyZW50IGFnZW50LiBSZXR1cm'
    '5zIGEgc3RyZWFtIG9mIG1hdGNoaW5nIGFnZW50IHJlY29yZHMuKgthZ2VudFNlYXJjaIK1GAwK'
    'CmFnZW50X3ZpZXcwARKMAgoOQWdlbnRIaWVyYXJjaHkSHy5maWVsZC52MS5BZ2VudEhpZXJhcm'
    'NoeVJlcXVlc3QaIC5maWVsZC52MS5BZ2VudEhpZXJhcmNoeVJlc3BvbnNlIrQBkAIBukedAQoG'
    'QWdlbnRzEhNHZXQgYWdlbnQgaGllcmFyY2h5Gm5SZXRyaWV2ZXMgYWxsIGRlc2NlbmRhbnRzIG'
    '9mIHRoZSBzcGVjaWZpZWQgYWdlbnQgaW4gdGhlIGhpZXJhcmNoeSB0cmVlLiBTdXBwb3J0cyBs'
    'aW1pdGluZyB0aGUgdHJhdmVyc2FsIGRlcHRoLioOYWdlbnRIaWVyYXJjaHmCtRgMCgphZ2VudF'
    '92aWV3MAESjgIKD0FnZW50QnJhbmNoU2F2ZRIgLmZpZWxkLnYxLkFnZW50QnJhbmNoU2F2ZVJl'
    'cXVlc3QaIS5maWVsZC52MS5BZ2VudEJyYW5jaFNhdmVSZXNwb25zZSK1AbpHnwEKBkFnZW50cx'
    'IWQXNzaWduIGFnZW50IHRvIGJyYW5jaBpsQ3JlYXRlcyBvciB1cGRhdGVzIGFuIGFnZW50LWJy'
    'YW5jaCBhc3NpZ25tZW50LiBTdXBwb3J0cyBwZXItYnJhbmNoIHByb3BlcnRpZXMgc3VjaCBhcy'
    'Bjb21taXNzaW9uIHN0cnVjdHVyZXMuKg9hZ2VudEJyYW5jaFNhdmWCtRgOCgxhZ2VudF9tYW5h'
    'Z2USzQEKEUFnZW50QnJhbmNoRGVsZXRlEiIuZmllbGQudjEuQWdlbnRCcmFuY2hEZWxldGVSZX'
    'F1ZXN0GiMuZmllbGQudjEuQWdlbnRCcmFuY2hEZWxldGVSZXNwb25zZSJvukdaCgZBZ2VudHMS'
    'GFJlbW92ZSBhZ2VudCBmcm9tIGJyYW5jaBojUmVtb3ZlcyBhbiBhZ2VudC1icmFuY2ggYXNzaW'
    'dubWVudC4qEWFnZW50QnJhbmNoRGVsZXRlgrUYDgoMYWdlbnRfbWFuYWdlEvUBCg9BZ2VudEJy'
    'YW5jaExpc3QSIC5maWVsZC52MS5BZ2VudEJyYW5jaExpc3RSZXF1ZXN0GiEuZmllbGQudjEuQW'
    'dlbnRCcmFuY2hMaXN0UmVzcG9uc2UimgGQAgG6R4MBCgZBZ2VudHMSHUxpc3QgYWdlbnQtYnJh'
    'bmNoIGFzc2lnbm1lbnRzGklMaXN0cyBicmFuY2ggYXNzaWdubWVudHMgZm9yIGFuIGFnZW50LC'
    'BvciBhZ2VudCBhc3NpZ25tZW50cyBmb3IgYSBicmFuY2guKg9hZ2VudEJyYW5jaExpc3SCtRgM'
    'CgphZ2VudF92aWV3MAESkwIKCkNsaWVudFNhdmUSGy5maWVsZC52MS5DbGllbnRTYXZlUmVxdW'
    'VzdBocLmZpZWxkLnYxLkNsaWVudFNhdmVSZXNwb25zZSLJAbpHsgEKB0NsaWVudHMSGk9uYm9h'
    'cmQgb3IgdXBkYXRlIGEgY2xpZW50Gn9PbmJvYXJkcyBhIG5ldyBjbGllbnQgb3IgdXBkYXRlcy'
    'BhbiBleGlzdGluZyBvbmUuIEVhY2ggY2xpZW50IG11c3QgaGF2ZSBhIHVuaXF1ZSBwcm9maWxl'
    'IElEIGFuZCBiZSBhc3NpZ25lZCB0byBhbiBhY3RpdmUgYWdlbnQuKgpjbGllbnRTYXZlgrUYDw'
    'oNY2xpZW50X21hbmFnZRK8AQoJQ2xpZW50R2V0EhouZmllbGQudjEuQ2xpZW50R2V0UmVxdWVz'
    'dBobLmZpZWxkLnYxLkNsaWVudEdldFJlc3BvbnNlInaQAgG6R18KB0NsaWVudHMSEkdldCBhIG'
    'NsaWVudCBieSBJRBo1UmV0cmlldmVzIGEgY2xpZW50IHJlY29yZCBieSB0aGVpciB1bmlxdWUg'
    'aWRlbnRpZmllci4qCWNsaWVudEdldIK1GA0KC2NsaWVudF92aWV3Eo4CCgxDbGllbnRTZWFyY2'
    'gSHS5maWVsZC52MS5DbGllbnRTZWFyY2hSZXF1ZXN0Gh4uZmllbGQudjEuQ2xpZW50U2VhcmNo'
    'UmVzcG9uc2UivAGQAgG6R6QBCgdDbGllbnRzEg5TZWFyY2ggY2xpZW50cxp7U2VhcmNoZXMgZm'
    '9yIGNsaWVudHMgbWF0Y2hpbmcgc3BlY2lmaWVkIGNyaXRlcmlhLiBTdXBwb3J0cyBmaWx0ZXJp'
    'bmcgYnkgYWdlbnQuIFJldHVybnMgYSBzdHJlYW0gb2YgbWF0Y2hpbmcgY2xpZW50IHJlY29yZH'
    'MuKgxjbGllbnRTZWFyY2iCtRgNCgtjbGllbnRfdmlldzABEqsCCg5DbGllbnRSZWFzc2lnbhIf'
    'LmZpZWxkLnYxLkNsaWVudFJlYXNzaWduUmVxdWVzdBogLmZpZWxkLnYxLkNsaWVudFJlYXNzaW'
    'duUmVzcG9uc2Ui1QG6R74BCgdDbGllbnRzEhFSZWFzc2lnbiBhIGNsaWVudBqPAU1vdmVzIGEg'
    'Y2xpZW50IGZyb20gdGhlaXIgY3VycmVudCBhZ2VudCB0byBhIGRpZmZlcmVudCBhZ2VudC4gQm'
    '90aCBhZ2VudHMgbXVzdCBiZSBpbiB0aGUgc2FtZSBiYW5rLiBDcmVhdGVzIGFuIGF1ZGl0IHRy'
    'YWlsIG9mIHRoZSByZWFzc2lnbm1lbnQuKg5jbGllbnRSZWFzc2lnboK1GA8KDWNsaWVudF9tYW'
    '5hZ2Ua9gOCtRjxAwoNc2VydmljZV9maWVsZBIKYWdlbnRfdmlldxIMYWdlbnRfbWFuYWdlEhVh'
    'Z2VudF9zdWJhZ2VudF9tYW5hZ2USC2NsaWVudF92aWV3Eg1jbGllbnRfbWFuYWdlGk8IARIKYW'
    'dlbnRfdmlldxIMYWdlbnRfbWFuYWdlEhVhZ2VudF9zdWJhZ2VudF9tYW5hZ2USC2NsaWVudF92'
    'aWV3Eg1jbGllbnRfbWFuYWdlGk8IAhIKYWdlbnRfdmlldxIMYWdlbnRfbWFuYWdlEhVhZ2VudF'
    '9zdWJhZ2VudF9tYW5hZ2USC2NsaWVudF92aWV3Eg1jbGllbnRfbWFuYWdlGk8IAxIKYWdlbnRf'
    'dmlldxIMYWdlbnRfbWFuYWdlEhVhZ2VudF9zdWJhZ2VudF9tYW5hZ2USC2NsaWVudF92aWV3Eg'
    '1jbGllbnRfbWFuYWdlGhsIBBIKYWdlbnRfdmlldxILY2xpZW50X3ZpZXcaMggFEgphZ2VudF92'
    'aWV3EhVhZ2VudF9zdWJhZ2VudF9tYW5hZ2USC2NsaWVudF92aWV3Gk8IBhIKYWdlbnRfdmlldx'
    'IMYWdlbnRfbWFuYWdlEhVhZ2VudF9zdWJhZ2VudF9tYW5hZ2USC2NsaWVudF92aWV3Eg1jbGll'
    'bnRfbWFuYWdl');

