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

@$core.Deprecated('Use clientSaveRequestDescriptor instead')
const ClientSaveRequest$json = {
  '1': 'ClientSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.ClientObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `ClientSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientSaveRequestDescriptor = $convert.base64Decode(
    'ChFDbGllbnRTYXZlUmVxdWVzdBIzCgRkYXRhGAEgASgLMhcubGVuZGVyLnYxLkNsaWVudE9iam'
    'VjdEIGukgDyAEBUgRkYXRh');

@$core.Deprecated('Use clientSaveResponseDescriptor instead')
const ClientSaveResponse$json = {
  '1': 'ClientSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.ClientObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientSaveResponseDescriptor = $convert.base64Decode(
    'ChJDbGllbnRTYXZlUmVzcG9uc2USKwoEZGF0YRgBIAEoCzIXLmxlbmRlci52MS5DbGllbnRPYm'
    'plY3RSBGRhdGE=');

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
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.ClientObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientGetResponseDescriptor = $convert.base64Decode(
    'ChFDbGllbnRHZXRSZXNwb25zZRIrCgRkYXRhGAEgASgLMhcubGVuZGVyLnYxLkNsaWVudE9iam'
    'VjdFIEZGF0YQ==');

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
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.lender.v1.ClientObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientSearchResponseDescriptor = $convert.base64Decode(
    'ChRDbGllbnRTZWFyY2hSZXNwb25zZRIrCgRkYXRhGAEgAygLMhcubGVuZGVyLnYxLkNsaWVudE'
    '9iamVjdFIEZGF0YQ==');

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
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.ClientObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientReassignResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientReassignResponseDescriptor = $convert.base64Decode(
    'ChZDbGllbnRSZWFzc2lnblJlc3BvbnNlEisKBGRhdGEYASABKAsyFy5sZW5kZXIudjEuQ2xpZW'
    '50T2JqZWN0UgRkYXRh');

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
    {'1': 'ClientSave', '2': '.lender.v1.ClientSaveRequest', '3': '.lender.v1.ClientSaveResponse', '4': {}},
    {
      '1': 'ClientGet',
      '2': '.lender.v1.ClientGetRequest',
      '3': '.lender.v1.ClientGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'ClientSearch',
      '2': '.lender.v1.ClientSearchRequest',
      '3': '.lender.v1.ClientSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'ClientReassign', '2': '.lender.v1.ClientReassignRequest', '3': '.lender.v1.ClientReassignResponse', '4': {}},
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
  '.lender.v1.ClientSaveRequest': ClientSaveRequest$json,
  '.lender.v1.ClientObject': ClientObject$json,
  '.lender.v1.ClientSaveResponse': ClientSaveResponse$json,
  '.lender.v1.ClientGetRequest': ClientGetRequest$json,
  '.lender.v1.ClientGetResponse': ClientGetResponse$json,
  '.lender.v1.ClientSearchRequest': ClientSearchRequest$json,
  '.lender.v1.ClientSearchResponse': ClientSearchResponse$json,
  '.lender.v1.ClientReassignRequest': ClientReassignRequest$json,
  '.lender.v1.ClientReassignResponse': ClientReassignResponse$json,
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
    'aHkwARKCAgoKQ2xpZW50U2F2ZRIcLmxlbmRlci52MS5DbGllbnRTYXZlUmVxdWVzdBodLmxlbm'
    'Rlci52MS5DbGllbnRTYXZlUmVzcG9uc2UitgG6R7IBCgdDbGllbnRzEhpPbmJvYXJkIG9yIHVw'
    'ZGF0ZSBhIGNsaWVudBp/T25ib2FyZHMgYSBuZXcgY2xpZW50IG9yIHVwZGF0ZXMgYW4gZXhpc3'
    'Rpbmcgb25lLiBFYWNoIGNsaWVudCBtdXN0IGhhdmUgYSB1bmlxdWUgcHJvZmlsZSBJRCBhbmQg'
    'YmUgYXNzaWduZWQgdG8gYW4gYWN0aXZlIGFnZW50LioKY2xpZW50U2F2ZRKtAQoJQ2xpZW50R2'
    'V0EhsubGVuZGVyLnYxLkNsaWVudEdldFJlcXVlc3QaHC5sZW5kZXIudjEuQ2xpZW50R2V0UmVz'
    'cG9uc2UiZZACAbpHXwoHQ2xpZW50cxISR2V0IGEgY2xpZW50IGJ5IElEGjVSZXRyaWV2ZXMgYS'
    'BjbGllbnQgcmVjb3JkIGJ5IHRoZWlyIHVuaXF1ZSBpZGVudGlmaWVyLioJY2xpZW50R2V0Ev8B'
    'CgxDbGllbnRTZWFyY2gSHi5sZW5kZXIudjEuQ2xpZW50U2VhcmNoUmVxdWVzdBofLmxlbmRlci'
    '52MS5DbGllbnRTZWFyY2hSZXNwb25zZSKrAZACAbpHpAEKB0NsaWVudHMSDlNlYXJjaCBjbGll'
    'bnRzGntTZWFyY2hlcyBmb3IgY2xpZW50cyBtYXRjaGluZyBzcGVjaWZpZWQgY3JpdGVyaWEuIF'
    'N1cHBvcnRzIGZpbHRlcmluZyBieSBhZ2VudC4gUmV0dXJucyBhIHN0cmVhbSBvZiBtYXRjaGlu'
    'ZyBjbGllbnQgcmVjb3Jkcy4qDGNsaWVudFNlYXJjaDABEpoCCg5DbGllbnRSZWFzc2lnbhIgLm'
    'xlbmRlci52MS5DbGllbnRSZWFzc2lnblJlcXVlc3QaIS5sZW5kZXIudjEuQ2xpZW50UmVhc3Np'
    'Z25SZXNwb25zZSLCAbpHvgEKB0NsaWVudHMSEVJlYXNzaWduIGEgY2xpZW50Go8BTW92ZXMgYS'
    'BjbGllbnQgZnJvbSB0aGVpciBjdXJyZW50IGFnZW50IHRvIGEgZGlmZmVyZW50IGFnZW50LiBC'
    'b3RoIGFnZW50cyBtdXN0IGJlIGluIHRoZSBzYW1lIGJhbmsuIENyZWF0ZXMgYW4gYXVkaXQgdH'
    'JhaWwgb2YgdGhlIHJlYXNzaWdubWVudC4qDmNsaWVudFJlYXNzaWdu');

