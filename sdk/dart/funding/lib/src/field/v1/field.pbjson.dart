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
    {'1': 'owning_team_id', '3': 7, '4': 1, '5': 9, '8': {}, '10': 'owningTeamId'},
    {'1': 'primary_relationship_member_id', '3': 8, '4': 1, '5': 9, '8': {}, '10': 'primaryRelationshipMemberId'},
  ],
};

/// Descriptor for `ClientObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientObjectDescriptor = $convert.base64Decode(
    'CgxDbGllbnRPYmplY3QSLgoCaWQYASABKAlCHrpIG9gBAXIWEAMYKDIQWzAtOWEtel8tXXszLD'
    'QwfVICaWQSJAoIYWdlbnRfaWQYAiABKAlCCbpIBnIEEAMYKFIHYWdlbnRJZBIoCgpwcm9maWxl'
    'X2lkGAMgASgJQgm6SAZyBBADGChSCXByb2ZpbGVJZBIbCgRuYW1lGAQgASgJQge6SARyAhABUg'
    'RuYW1lEiYKBXN0YXRlGAUgASgOMhAuY29tbW9uLnYxLlNUQVRFUgVzdGF0ZRI3Cgpwcm9wZXJ0'
    'aWVzGAYgASgLMhcuZ29vZ2xlLnByb3RvYnVmLlN0cnVjdFIKcHJvcGVydGllcxIwCg5vd25pbm'
    'dfdGVhbV9pZBgHIAEoCUIKukgH2AEBcgIYKFIMb3duaW5nVGVhbUlkEk8KHnByaW1hcnlfcmVs'
    'YXRpb25zaGlwX21lbWJlcl9pZBgIIAEoCUIKukgH2AEBcgIYKFIbcHJpbWFyeVJlbGF0aW9uc2'
    'hpcE1lbWJlcklk');

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
    {'1': 'owning_team_id', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'owningTeamId'},
    {'1': 'primary_relationship_member_id', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'primaryRelationshipMemberId'},
  ],
};

/// Descriptor for `ClientSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientSearchRequestDescriptor = $convert.base64Decode(
    'ChNDbGllbnRTZWFyY2hSZXF1ZXN0EhQKBXF1ZXJ5GAEgASgJUgVxdWVyeRInCghhZ2VudF9pZB'
    'gCIAEoCUIMukgJ2AEBcgQQAxgoUgdhZ2VudElkEi0KBmN1cnNvchgDIAEoCzIVLmNvbW1vbi52'
    'MS5QYWdlQ3Vyc29yUgZjdXJzb3ISMAoOb3duaW5nX3RlYW1faWQYBCABKAlCCrpIB9gBAXICGC'
    'hSDG93bmluZ1RlYW1JZBJPCh5wcmltYXJ5X3JlbGF0aW9uc2hpcF9tZW1iZXJfaWQYBSABKAlC'
    'CrpIB9gBAXICGChSG3ByaW1hcnlSZWxhdGlvbnNoaXBNZW1iZXJJZA==');

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

@$core.Deprecated('Use clientOwnershipTransferRequestDescriptor instead')
const ClientOwnershipTransferRequest$json = {
  '1': 'ClientOwnershipTransferRequest',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'clientId'},
    {'1': 'new_owning_team_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'newOwningTeamId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ClientOwnershipTransferRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientOwnershipTransferRequestDescriptor = $convert.base64Decode(
    'Ch5DbGllbnRPd25lcnNoaXBUcmFuc2ZlclJlcXVlc3QSOAoJY2xpZW50X2lkGAEgASgJQhu6SB'
    'hyFhADGCgyEFswLTlhLXpfLV17Myw0MH1SCGNsaWVudElkEjYKEm5ld19vd25pbmdfdGVhbV9p'
    'ZBgCIAEoCUIJukgGcgQQAxgoUg9uZXdPd25pbmdUZWFtSWQSFgoGcmVhc29uGAMgASgJUgZyZW'
    'Fzb24=');

@$core.Deprecated('Use clientOwnershipTransferResponseDescriptor instead')
const ClientOwnershipTransferResponse$json = {
  '1': 'ClientOwnershipTransferResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.field.v1.ClientObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientOwnershipTransferResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientOwnershipTransferResponseDescriptor = $convert.base64Decode(
    'Ch9DbGllbnRPd25lcnNoaXBUcmFuc2ZlclJlc3BvbnNlEioKBGRhdGEYASABKAsyFi5maWVsZC'
    '52MS5DbGllbnRPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use clientRelationshipAssignRequestDescriptor instead')
const ClientRelationshipAssignRequest$json = {
  '1': 'ClientRelationshipAssignRequest',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'clientId'},
    {'1': 'member_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'memberId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ClientRelationshipAssignRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientRelationshipAssignRequestDescriptor = $convert.base64Decode(
    'Ch9DbGllbnRSZWxhdGlvbnNoaXBBc3NpZ25SZXF1ZXN0EjgKCWNsaWVudF9pZBgBIAEoCUIbuk'
    'gYchYQAxgoMhBbMC05YS16Xy1dezMsNDB9UghjbGllbnRJZBImCgltZW1iZXJfaWQYAiABKAlC'
    'CbpIBnIEEAMYKFIIbWVtYmVySWQSFgoGcmVhc29uGAMgASgJUgZyZWFzb24=');

@$core.Deprecated('Use clientRelationshipAssignResponseDescriptor instead')
const ClientRelationshipAssignResponse$json = {
  '1': 'ClientRelationshipAssignResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.field.v1.ClientObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientRelationshipAssignResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientRelationshipAssignResponseDescriptor = $convert.base64Decode(
    'CiBDbGllbnRSZWxhdGlvbnNoaXBBc3NpZ25SZXNwb25zZRIqCgRkYXRhGAEgASgLMhYuZmllbG'
    'QudjEuQ2xpZW50T2JqZWN0UgRkYXRh');

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
    {'1': 'ClientOwnershipTransfer', '2': '.field.v1.ClientOwnershipTransferRequest', '3': '.field.v1.ClientOwnershipTransferResponse', '4': {}},
    {'1': 'ClientRelationshipAssign', '2': '.field.v1.ClientRelationshipAssignRequest', '3': '.field.v1.ClientRelationshipAssignResponse', '4': {}},
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
  '.field.v1.ClientOwnershipTransferRequest': ClientOwnershipTransferRequest$json,
  '.field.v1.ClientOwnershipTransferResponse': ClientOwnershipTransferResponse$json,
  '.field.v1.ClientRelationshipAssignRequest': ClientRelationshipAssignRequest$json,
  '.field.v1.ClientRelationshipAssignResponse': ClientRelationshipAssignResponse$json,
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
    'CgphZ2VudF92aWV3MAESkQIKCkNsaWVudFNhdmUSGy5maWVsZC52MS5DbGllbnRTYXZlUmVxdW'
    'VzdBocLmZpZWxkLnYxLkNsaWVudFNhdmVSZXNwb25zZSLHAbpHsAEKB0NsaWVudHMSGk9uYm9h'
    'cmQgb3IgdXBkYXRlIGEgY2xpZW50Gn1PbmJvYXJkcyBhIG5ldyBjbGllbnQgb3IgdXBkYXRlcy'
    'BhbiBleGlzdGluZyBvbmUuIEVhY2ggY2xpZW50IG11c3QgaGF2ZSBhIHVuaXF1ZSBwcm9maWxl'
    'IElEIGFuZCBiZSBvd25lZCBieSBhbiBpbnRlcm5hbCB0ZWFtLioKY2xpZW50U2F2ZYK1GA8KDW'
    'NsaWVudF9tYW5hZ2USvAEKCUNsaWVudEdldBIaLmZpZWxkLnYxLkNsaWVudEdldFJlcXVlc3Qa'
    'Gy5maWVsZC52MS5DbGllbnRHZXRSZXNwb25zZSJ2kAIBukdfCgdDbGllbnRzEhJHZXQgYSBjbG'
    'llbnQgYnkgSUQaNVJldHJpZXZlcyBhIGNsaWVudCByZWNvcmQgYnkgdGhlaXIgdW5pcXVlIGlk'
    'ZW50aWZpZXIuKgljbGllbnRHZXSCtRgNCgtjbGllbnRfdmlldxKtAgoMQ2xpZW50U2VhcmNoEh'
    '0uZmllbGQudjEuQ2xpZW50U2VhcmNoUmVxdWVzdBoeLmZpZWxkLnYxLkNsaWVudFNlYXJjaFJl'
    'c3BvbnNlItsBkAIBukfDAQoHQ2xpZW50cxIOU2VhcmNoIGNsaWVudHMamQFTZWFyY2hlcyBmb3'
    'IgY2xpZW50cyBtYXRjaGluZyBzcGVjaWZpZWQgY3JpdGVyaWEuIFN1cHBvcnRzIGZpbHRlcmlu'
    'ZyBieSBvd25pbmcgdGVhbSBhbmQgcmVsYXRpb25zaGlwIG1lbWJlci4gUmV0dXJucyBhIHN0cm'
    'VhbSBvZiBtYXRjaGluZyBjbGllbnQgcmVjb3Jkcy4qDGNsaWVudFNlYXJjaIK1GA0KC2NsaWVu'
    'dF92aWV3MAESlAIKDkNsaWVudFJlYXNzaWduEh8uZmllbGQudjEuQ2xpZW50UmVhc3NpZ25SZX'
    'F1ZXN0GiAuZmllbGQudjEuQ2xpZW50UmVhc3NpZ25SZXNwb25zZSK+AbpHpwEKB0NsaWVudHMS'
    'EVJlYXNzaWduIGEgY2xpZW50GnlEZXByZWNhdGVkLiBDbGllbnQgb3duZXJzaGlwIGlzIHRlYW'
    '0tYmFzZWQgYW5kIHNob3VsZCBiZSBjaGFuZ2VkIHZpYSBDbGllbnRPd25lcnNoaXBUcmFuc2Zl'
    'ciBvciBDbGllbnRSZWxhdGlvbnNoaXBBc3NpZ24uKg5jbGllbnRSZWFzc2lnboK1GA8KDWNsaW'
    'VudF9tYW5hZ2USgwEKF0NsaWVudE93bmVyc2hpcFRyYW5zZmVyEiguZmllbGQudjEuQ2xpZW50'
    'T3duZXJzaGlwVHJhbnNmZXJSZXF1ZXN0GikuZmllbGQudjEuQ2xpZW50T3duZXJzaGlwVHJhbn'
    'NmZXJSZXNwb25zZSITgrUYDwoNY2xpZW50X21hbmFnZRKGAQoYQ2xpZW50UmVsYXRpb25zaGlw'
    'QXNzaWduEikuZmllbGQudjEuQ2xpZW50UmVsYXRpb25zaGlwQXNzaWduUmVxdWVzdBoqLmZpZW'
    'xkLnYxLkNsaWVudFJlbGF0aW9uc2hpcEFzc2lnblJlc3BvbnNlIhOCtRgPCg1jbGllbnRfbWFu'
    'YWdlGvYDgrUY8QMKDXNlcnZpY2VfZmllbGQSCmFnZW50X3ZpZXcSDGFnZW50X21hbmFnZRIVYW'
    'dlbnRfc3ViYWdlbnRfbWFuYWdlEgtjbGllbnRfdmlldxINY2xpZW50X21hbmFnZRpPCAESCmFn'
    'ZW50X3ZpZXcSDGFnZW50X21hbmFnZRIVYWdlbnRfc3ViYWdlbnRfbWFuYWdlEgtjbGllbnRfdm'
    'lldxINY2xpZW50X21hbmFnZRpPCAISCmFnZW50X3ZpZXcSDGFnZW50X21hbmFnZRIVYWdlbnRf'
    'c3ViYWdlbnRfbWFuYWdlEgtjbGllbnRfdmlldxINY2xpZW50X21hbmFnZRpPCAMSCmFnZW50X3'
    'ZpZXcSDGFnZW50X21hbmFnZRIVYWdlbnRfc3ViYWdlbnRfbWFuYWdlEgtjbGllbnRfdmlldxIN'
    'Y2xpZW50X21hbmFnZRobCAQSCmFnZW50X3ZpZXcSC2NsaWVudF92aWV3GjIIBRIKYWdlbnRfdm'
    'lldxIVYWdlbnRfc3ViYWdlbnRfbWFuYWdlEgtjbGllbnRfdmlldxpPCAYSCmFnZW50X3ZpZXcS'
    'DGFnZW50X21hbmFnZRIVYWdlbnRfc3ViYWdlbnRfbWFuYWdlEgtjbGllbnRfdmlldxINY2xpZW'
    '50X21hbmFnZQ==');

