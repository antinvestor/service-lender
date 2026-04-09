//
//  Generated code. Do not modify.
//  source: identity/v1/identity.proto
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
import '../../google/type/money.pbjson.dart' as $9;

@$core.Deprecated('Use organizationTypeDescriptor instead')
const OrganizationType$json = {
  '1': 'OrganizationType',
  '2': [
    {'1': 'ORGANIZATION_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'ORGANIZATION_TYPE_BANK', '2': 1},
    {'1': 'ORGANIZATION_TYPE_MICROFINANCE', '2': 2},
    {'1': 'ORGANIZATION_TYPE_SACCO', '2': 3},
    {'1': 'ORGANIZATION_TYPE_FINTECH', '2': 4},
    {'1': 'ORGANIZATION_TYPE_COOPERATIVE', '2': 5},
    {'1': 'ORGANIZATION_TYPE_NGO', '2': 6},
    {'1': 'ORGANIZATION_TYPE_GOVERNMENT', '2': 7},
    {'1': 'ORGANIZATION_TYPE_OTHER', '2': 8},
  ],
};

/// Descriptor for `OrganizationType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List organizationTypeDescriptor = $convert.base64Decode(
    'ChBPcmdhbml6YXRpb25UeXBlEiEKHU9SR0FOSVpBVElPTl9UWVBFX1VOU1BFQ0lGSUVEEAASGg'
    'oWT1JHQU5JWkFUSU9OX1RZUEVfQkFOSxABEiIKHk9SR0FOSVpBVElPTl9UWVBFX01JQ1JPRklO'
    'QU5DRRACEhsKF09SR0FOSVpBVElPTl9UWVBFX1NBQ0NPEAMSHQoZT1JHQU5JWkFUSU9OX1RZUE'
    'VfRklOVEVDSBAEEiEKHU9SR0FOSVpBVElPTl9UWVBFX0NPT1BFUkFUSVZFEAUSGQoVT1JHQU5J'
    'WkFUSU9OX1RZUEVfTkdPEAYSIAocT1JHQU5JWkFUSU9OX1RZUEVfR09WRVJOTUVOVBAHEhsKF0'
    '9SR0FOSVpBVElPTl9UWVBFX09USEVSEAg=');

@$core.Deprecated('Use systemUserRoleDescriptor instead')
const SystemUserRole$json = {
  '1': 'SystemUserRole',
  '2': [
    {'1': 'SYSTEM_USER_ROLE_UNSPECIFIED', '2': 0},
    {'1': 'SYSTEM_USER_ROLE_VERIFIER', '2': 1},
    {'1': 'SYSTEM_USER_ROLE_APPROVER', '2': 2},
    {'1': 'SYSTEM_USER_ROLE_ADMINISTRATOR', '2': 3},
    {'1': 'SYSTEM_USER_ROLE_AUDITOR', '2': 4},
  ],
};

/// Descriptor for `SystemUserRole`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List systemUserRoleDescriptor = $convert.base64Decode(
    'Cg5TeXN0ZW1Vc2VyUm9sZRIgChxTWVNURU1fVVNFUl9ST0xFX1VOU1BFQ0lGSUVEEAASHQoZU1'
    'lTVEVNX1VTRVJfUk9MRV9WRVJJRklFUhABEh0KGVNZU1RFTV9VU0VSX1JPTEVfQVBQUk9WRVIQ'
    'AhIiCh5TWVNURU1fVVNFUl9ST0xFX0FETUlOSVNUUkFUT1IQAxIcChhTWVNURU1fVVNFUl9ST0'
    'xFX0FVRElUT1IQBA==');

@$core.Deprecated('Use organizationObjectDescriptor instead')
const OrganizationObject$json = {
  '1': 'OrganizationObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'partition_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'partitionId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'code', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'code'},
    {'1': 'profile_id', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'profileId'},
    {'1': 'state', '3': 6, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'organization_type', '3': 7, '4': 1, '5': 14, '6': '.identity.v1.OrganizationType', '10': 'organizationType'},
    {'1': 'properties', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
    {'1': 'client_id', '3': 9, '4': 1, '5': 9, '8': {}, '10': 'clientId'},
  ],
};

/// Descriptor for `OrganizationObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List organizationObjectDescriptor = $convert.base64Decode(
    'ChJPcmdhbml6YXRpb25PYmplY3QSLgoCaWQYASABKAlCHrpIG9gBAXIWEAMYKDIQWzAtOWEtel'
    '8tXXszLDQwfVICaWQSLAoMcGFydGl0aW9uX2lkGAIgASgJQgm6SAZyBBADGChSC3BhcnRpdGlv'
    'bklkEhsKBG5hbWUYAyABKAlCB7pIBHICEAFSBG5hbWUSGwoEY29kZRgEIAEoCUIHukgEcgIQAV'
    'IEY29kZRIrCgpwcm9maWxlX2lkGAUgASgJQgy6SAnYAQFyBBADGChSCXByb2ZpbGVJZBImCgVz'
    'dGF0ZRgGIAEoDjIQLmNvbW1vbi52MS5TVEFURVIFc3RhdGUSSgoRb3JnYW5pemF0aW9uX3R5cG'
    'UYByABKA4yHS5pZGVudGl0eS52MS5Pcmdhbml6YXRpb25UeXBlUhBvcmdhbml6YXRpb25UeXBl'
    'EjcKCnByb3BlcnRpZXMYCCABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0Ugpwcm9wZXJ0aW'
    'VzEicKCWNsaWVudF9pZBgJIAEoCUIKukgH2AEBcgIYKFIIY2xpZW50SWQ=');

@$core.Deprecated('Use branchObjectDescriptor instead')
const BranchObject$json = {
  '1': 'BranchObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'organization_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'organizationId'},
    {'1': 'partition_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'partitionId'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'code', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'code'},
    {'1': 'geo_id', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'geoId'},
    {'1': 'state', '3': 7, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'properties', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
    {'1': 'client_id', '3': 9, '4': 1, '5': 9, '8': {}, '10': 'clientId'},
  ],
};

/// Descriptor for `BranchObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List branchObjectDescriptor = $convert.base64Decode(
    'CgxCcmFuY2hPYmplY3QSLgoCaWQYASABKAlCHrpIG9gBAXIWEAMYKDIQWzAtOWEtel8tXXszLD'
    'QwfVICaWQSMgoPb3JnYW5pemF0aW9uX2lkGAIgASgJQgm6SAZyBBADGChSDm9yZ2FuaXphdGlv'
    'bklkEi8KDHBhcnRpdGlvbl9pZBgDIAEoCUIMukgJ2AEBcgQQAxgoUgtwYXJ0aXRpb25JZBIbCg'
    'RuYW1lGAQgASgJQge6SARyAhABUgRuYW1lEhsKBGNvZGUYBSABKAlCB7pIBHICEAFSBGNvZGUS'
    'IQoGZ2VvX2lkGAYgASgJQgq6SAfYAQFyAhgoUgVnZW9JZBImCgVzdGF0ZRgHIAEoDjIQLmNvbW'
    '1vbi52MS5TVEFURVIFc3RhdGUSNwoKcHJvcGVydGllcxgIIAEoCzIXLmdvb2dsZS5wcm90b2J1'
    'Zi5TdHJ1Y3RSCnByb3BlcnRpZXMSJwoJY2xpZW50X2lkGAkgASgJQgq6SAfYAQFyAhgoUghjbG'
    'llbnRJZA==');

@$core.Deprecated('Use investorObjectDescriptor instead')
const InvestorObject$json = {
  '1': 'InvestorObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'profile_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'profileId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'state', '3': 4, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'properties', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `InvestorObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List investorObjectDescriptor = $convert.base64Decode(
    'Cg5JbnZlc3Rvck9iamVjdBIuCgJpZBgBIAEoCUIeukgb2AEBchYQAxgoMhBbMC05YS16Xy1dez'
    'MsNDB9UgJpZBIoCgpwcm9maWxlX2lkGAIgASgJQgm6SAZyBBADGChSCXByb2ZpbGVJZBIbCgRu'
    'YW1lGAMgASgJQge6SARyAhABUgRuYW1lEiYKBXN0YXRlGAQgASgOMhAuY29tbW9uLnYxLlNUQV'
    'RFUgVzdGF0ZRI3Cgpwcm9wZXJ0aWVzGAUgASgLMhcuZ29vZ2xlLnByb3RvYnVmLlN0cnVjdFIK'
    'cHJvcGVydGllcw==');

@$core.Deprecated('Use systemUserObjectDescriptor instead')
const SystemUserObject$json = {
  '1': 'SystemUserObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'profile_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'profileId'},
    {'1': 'branch_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'branchId'},
    {'1': 'role', '3': 4, '4': 1, '5': 14, '6': '.identity.v1.SystemUserRole', '10': 'role'},
    {'1': 'service_account_id', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'serviceAccountId'},
    {'1': 'state', '3': 6, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'properties', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `SystemUserObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List systemUserObjectDescriptor = $convert.base64Decode(
    'ChBTeXN0ZW1Vc2VyT2JqZWN0Ei4KAmlkGAEgASgJQh66SBvYAQFyFhADGCgyEFswLTlhLXpfLV'
    '17Myw0MH1SAmlkEigKCnByb2ZpbGVfaWQYAiABKAlCCbpIBnIEEAMYKFIJcHJvZmlsZUlkEiYK'
    'CWJyYW5jaF9pZBgDIAEoCUIJukgGcgQQAxgoUghicmFuY2hJZBIvCgRyb2xlGAQgASgOMhsuaW'
    'RlbnRpdHkudjEuU3lzdGVtVXNlclJvbGVSBHJvbGUSOAoSc2VydmljZV9hY2NvdW50X2lkGAUg'
    'ASgJQgq6SAfYAQFyAhgoUhBzZXJ2aWNlQWNjb3VudElkEiYKBXN0YXRlGAYgASgOMhAuY29tbW'
    '9uLnYxLlNUQVRFUgVzdGF0ZRI3Cgpwcm9wZXJ0aWVzGAcgASgLMhcuZ29vZ2xlLnByb3RvYnVm'
    'LlN0cnVjdFIKcHJvcGVydGllcw==');

@$core.Deprecated('Use organizationSaveRequestDescriptor instead')
const OrganizationSaveRequest$json = {
  '1': 'OrganizationSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.OrganizationObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `OrganizationSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List organizationSaveRequestDescriptor = $convert.base64Decode(
    'ChdPcmdhbml6YXRpb25TYXZlUmVxdWVzdBI7CgRkYXRhGAEgASgLMh8uaWRlbnRpdHkudjEuT3'
    'JnYW5pemF0aW9uT2JqZWN0Qga6SAPIAQFSBGRhdGE=');

@$core.Deprecated('Use organizationSaveResponseDescriptor instead')
const OrganizationSaveResponse$json = {
  '1': 'OrganizationSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.OrganizationObject', '10': 'data'},
  ],
};

/// Descriptor for `OrganizationSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List organizationSaveResponseDescriptor = $convert.base64Decode(
    'ChhPcmdhbml6YXRpb25TYXZlUmVzcG9uc2USMwoEZGF0YRgBIAEoCzIfLmlkZW50aXR5LnYxLk'
    '9yZ2FuaXphdGlvbk9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use organizationGetRequestDescriptor instead')
const OrganizationGetRequest$json = {
  '1': 'OrganizationGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `OrganizationGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List organizationGetRequestDescriptor = $convert.base64Decode(
    'ChZPcmdhbml6YXRpb25HZXRSZXF1ZXN0EisKAmlkGAEgASgJQhu6SBhyFhADGCgyEFswLTlhLX'
    'pfLV17Myw0MH1SAmlk');

@$core.Deprecated('Use organizationGetResponseDescriptor instead')
const OrganizationGetResponse$json = {
  '1': 'OrganizationGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.OrganizationObject', '10': 'data'},
  ],
};

/// Descriptor for `OrganizationGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List organizationGetResponseDescriptor = $convert.base64Decode(
    'ChdPcmdhbml6YXRpb25HZXRSZXNwb25zZRIzCgRkYXRhGAEgASgLMh8uaWRlbnRpdHkudjEuT3'
    'JnYW5pemF0aW9uT2JqZWN0UgRkYXRh');

@$core.Deprecated('Use organizationSearchResponseDescriptor instead')
const OrganizationSearchResponse$json = {
  '1': 'OrganizationSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.identity.v1.OrganizationObject', '10': 'data'},
  ],
};

/// Descriptor for `OrganizationSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List organizationSearchResponseDescriptor = $convert.base64Decode(
    'ChpPcmdhbml6YXRpb25TZWFyY2hSZXNwb25zZRIzCgRkYXRhGAEgAygLMh8uaWRlbnRpdHkudj'
    'EuT3JnYW5pemF0aW9uT2JqZWN0UgRkYXRh');

@$core.Deprecated('Use branchSaveRequestDescriptor instead')
const BranchSaveRequest$json = {
  '1': 'BranchSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.BranchObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `BranchSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List branchSaveRequestDescriptor = $convert.base64Decode(
    'ChFCcmFuY2hTYXZlUmVxdWVzdBI1CgRkYXRhGAEgASgLMhkuaWRlbnRpdHkudjEuQnJhbmNoT2'
    'JqZWN0Qga6SAPIAQFSBGRhdGE=');

@$core.Deprecated('Use branchSaveResponseDescriptor instead')
const BranchSaveResponse$json = {
  '1': 'BranchSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.BranchObject', '10': 'data'},
  ],
};

/// Descriptor for `BranchSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List branchSaveResponseDescriptor = $convert.base64Decode(
    'ChJCcmFuY2hTYXZlUmVzcG9uc2USLQoEZGF0YRgBIAEoCzIZLmlkZW50aXR5LnYxLkJyYW5jaE'
    '9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use branchGetRequestDescriptor instead')
const BranchGetRequest$json = {
  '1': 'BranchGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `BranchGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List branchGetRequestDescriptor = $convert.base64Decode(
    'ChBCcmFuY2hHZXRSZXF1ZXN0EisKAmlkGAEgASgJQhu6SBhyFhADGCgyEFswLTlhLXpfLV17My'
    'w0MH1SAmlk');

@$core.Deprecated('Use branchGetResponseDescriptor instead')
const BranchGetResponse$json = {
  '1': 'BranchGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.BranchObject', '10': 'data'},
  ],
};

/// Descriptor for `BranchGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List branchGetResponseDescriptor = $convert.base64Decode(
    'ChFCcmFuY2hHZXRSZXNwb25zZRItCgRkYXRhGAEgASgLMhkuaWRlbnRpdHkudjEuQnJhbmNoT2'
    'JqZWN0UgRkYXRh');

@$core.Deprecated('Use branchSearchRequestDescriptor instead')
const BranchSearchRequest$json = {
  '1': 'BranchSearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'organization_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'organizationId'},
    {'1': 'cursor', '3': 3, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `BranchSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List branchSearchRequestDescriptor = $convert.base64Decode(
    'ChNCcmFuY2hTZWFyY2hSZXF1ZXN0EhQKBXF1ZXJ5GAEgASgJUgVxdWVyeRI1Cg9vcmdhbml6YX'
    'Rpb25faWQYAiABKAlCDLpICdgBAXIEEAMYKFIOb3JnYW5pemF0aW9uSWQSLQoGY3Vyc29yGAMg'
    'ASgLMhUuY29tbW9uLnYxLlBhZ2VDdXJzb3JSBmN1cnNvcg==');

@$core.Deprecated('Use branchSearchResponseDescriptor instead')
const BranchSearchResponse$json = {
  '1': 'BranchSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.identity.v1.BranchObject', '10': 'data'},
  ],
};

/// Descriptor for `BranchSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List branchSearchResponseDescriptor = $convert.base64Decode(
    'ChRCcmFuY2hTZWFyY2hSZXNwb25zZRItCgRkYXRhGAEgAygLMhkuaWRlbnRpdHkudjEuQnJhbm'
    'NoT2JqZWN0UgRkYXRh');

@$core.Deprecated('Use investorSaveRequestDescriptor instead')
const InvestorSaveRequest$json = {
  '1': 'InvestorSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.InvestorObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `InvestorSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List investorSaveRequestDescriptor = $convert.base64Decode(
    'ChNJbnZlc3RvclNhdmVSZXF1ZXN0EjcKBGRhdGEYASABKAsyGy5pZGVudGl0eS52MS5JbnZlc3'
    'Rvck9iamVjdEIGukgDyAEBUgRkYXRh');

@$core.Deprecated('Use investorSaveResponseDescriptor instead')
const InvestorSaveResponse$json = {
  '1': 'InvestorSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.InvestorObject', '10': 'data'},
  ],
};

/// Descriptor for `InvestorSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List investorSaveResponseDescriptor = $convert.base64Decode(
    'ChRJbnZlc3RvclNhdmVSZXNwb25zZRIvCgRkYXRhGAEgASgLMhsuaWRlbnRpdHkudjEuSW52ZX'
    'N0b3JPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use investorGetRequestDescriptor instead')
const InvestorGetRequest$json = {
  '1': 'InvestorGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `InvestorGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List investorGetRequestDescriptor = $convert.base64Decode(
    'ChJJbnZlc3RvckdldFJlcXVlc3QSKwoCaWQYASABKAlCG7pIGHIWEAMYKDIQWzAtOWEtel8tXX'
    'szLDQwfVICaWQ=');

@$core.Deprecated('Use investorGetResponseDescriptor instead')
const InvestorGetResponse$json = {
  '1': 'InvestorGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.InvestorObject', '10': 'data'},
  ],
};

/// Descriptor for `InvestorGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List investorGetResponseDescriptor = $convert.base64Decode(
    'ChNJbnZlc3RvckdldFJlc3BvbnNlEi8KBGRhdGEYASABKAsyGy5pZGVudGl0eS52MS5JbnZlc3'
    'Rvck9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use investorSearchRequestDescriptor instead')
const InvestorSearchRequest$json = {
  '1': 'InvestorSearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'cursor', '3': 2, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `InvestorSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List investorSearchRequestDescriptor = $convert.base64Decode(
    'ChVJbnZlc3RvclNlYXJjaFJlcXVlc3QSFAoFcXVlcnkYASABKAlSBXF1ZXJ5Ei0KBmN1cnNvch'
    'gCIAEoCzIVLmNvbW1vbi52MS5QYWdlQ3Vyc29yUgZjdXJzb3I=');

@$core.Deprecated('Use investorSearchResponseDescriptor instead')
const InvestorSearchResponse$json = {
  '1': 'InvestorSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.identity.v1.InvestorObject', '10': 'data'},
  ],
};

/// Descriptor for `InvestorSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List investorSearchResponseDescriptor = $convert.base64Decode(
    'ChZJbnZlc3RvclNlYXJjaFJlc3BvbnNlEi8KBGRhdGEYASADKAsyGy5pZGVudGl0eS52MS5Jbn'
    'Zlc3Rvck9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use systemUserSaveRequestDescriptor instead')
const SystemUserSaveRequest$json = {
  '1': 'SystemUserSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.SystemUserObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `SystemUserSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List systemUserSaveRequestDescriptor = $convert.base64Decode(
    'ChVTeXN0ZW1Vc2VyU2F2ZVJlcXVlc3QSOQoEZGF0YRgBIAEoCzIdLmlkZW50aXR5LnYxLlN5c3'
    'RlbVVzZXJPYmplY3RCBrpIA8gBAVIEZGF0YQ==');

@$core.Deprecated('Use systemUserSaveResponseDescriptor instead')
const SystemUserSaveResponse$json = {
  '1': 'SystemUserSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.SystemUserObject', '10': 'data'},
  ],
};

/// Descriptor for `SystemUserSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List systemUserSaveResponseDescriptor = $convert.base64Decode(
    'ChZTeXN0ZW1Vc2VyU2F2ZVJlc3BvbnNlEjEKBGRhdGEYASABKAsyHS5pZGVudGl0eS52MS5TeX'
    'N0ZW1Vc2VyT2JqZWN0UgRkYXRh');

@$core.Deprecated('Use systemUserGetRequestDescriptor instead')
const SystemUserGetRequest$json = {
  '1': 'SystemUserGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `SystemUserGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List systemUserGetRequestDescriptor = $convert.base64Decode(
    'ChRTeXN0ZW1Vc2VyR2V0UmVxdWVzdBIrCgJpZBgBIAEoCUIbukgYchYQAxgoMhBbMC05YS16Xy'
    '1dezMsNDB9UgJpZA==');

@$core.Deprecated('Use systemUserGetResponseDescriptor instead')
const SystemUserGetResponse$json = {
  '1': 'SystemUserGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.SystemUserObject', '10': 'data'},
  ],
};

/// Descriptor for `SystemUserGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List systemUserGetResponseDescriptor = $convert.base64Decode(
    'ChVTeXN0ZW1Vc2VyR2V0UmVzcG9uc2USMQoEZGF0YRgBIAEoCzIdLmlkZW50aXR5LnYxLlN5c3'
    'RlbVVzZXJPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use systemUserSearchRequestDescriptor instead')
const SystemUserSearchRequest$json = {
  '1': 'SystemUserSearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'role', '3': 2, '4': 1, '5': 14, '6': '.identity.v1.SystemUserRole', '10': 'role'},
    {'1': 'branch_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'branchId'},
    {'1': 'cursor', '3': 4, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `SystemUserSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List systemUserSearchRequestDescriptor = $convert.base64Decode(
    'ChdTeXN0ZW1Vc2VyU2VhcmNoUmVxdWVzdBIUCgVxdWVyeRgBIAEoCVIFcXVlcnkSLwoEcm9sZR'
    'gCIAEoDjIbLmlkZW50aXR5LnYxLlN5c3RlbVVzZXJSb2xlUgRyb2xlEikKCWJyYW5jaF9pZBgD'
    'IAEoCUIMukgJ2AEBcgQQAxgoUghicmFuY2hJZBItCgZjdXJzb3IYBCABKAsyFS5jb21tb24udj'
    'EuUGFnZUN1cnNvclIGY3Vyc29y');

@$core.Deprecated('Use systemUserSearchResponseDescriptor instead')
const SystemUserSearchResponse$json = {
  '1': 'SystemUserSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.identity.v1.SystemUserObject', '10': 'data'},
  ],
};

/// Descriptor for `SystemUserSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List systemUserSearchResponseDescriptor = $convert.base64Decode(
    'ChhTeXN0ZW1Vc2VyU2VhcmNoUmVzcG9uc2USMQoEZGF0YRgBIAMoCzIdLmlkZW50aXR5LnYxLl'
    'N5c3RlbVVzZXJPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use clientGroupObjectDescriptor instead')
const ClientGroupObject$json = {
  '1': 'ClientGroupObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'productId'},
    {'1': 'parent_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'parentId'},
    {'1': 'agent_id', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'agentId'},
    {'1': 'branch_id', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'branchId'},
    {'1': 'profile_id', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'profileId'},
    {'1': 'name', '3': 7, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'group_type', '3': 8, '4': 1, '5': 5, '10': 'groupType'},
    {'1': 'currency_code', '3': 9, '4': 1, '5': 9, '10': 'currencyCode'},
    {'1': 'saving_amount', '3': 10, '4': 1, '5': 3, '10': 'savingAmount'},
    {'1': 'time_zone', '3': 11, '4': 1, '5': 9, '10': 'timeZone'},
    {'1': 'min_members', '3': 12, '4': 1, '5': 5, '10': 'minMembers'},
    {'1': 'max_members', '3': 13, '4': 1, '5': 5, '10': 'maxMembers'},
    {'1': 'state', '3': 14, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'properties', '3': 15, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `ClientGroupObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientGroupObjectDescriptor = $convert.base64Decode(
    'ChFDbGllbnRHcm91cE9iamVjdBIuCgJpZBgBIAEoCUIeukgb2AEBchYQAxgoMhBbMC05YS16Xy'
    '1dezMsNDB9UgJpZBIpCgpwcm9kdWN0X2lkGAIgASgJQgq6SAfYAQFyAhgoUglwcm9kdWN0SWQS'
    'JwoJcGFyZW50X2lkGAMgASgJQgq6SAfYAQFyAhgoUghwYXJlbnRJZBIlCghhZ2VudF9pZBgEIA'
    'EoCUIKukgH2AEBcgIYKFIHYWdlbnRJZBInCglicmFuY2hfaWQYBSABKAlCCrpIB9gBAXICGChS'
    'CGJyYW5jaElkEikKCnByb2ZpbGVfaWQYBiABKAlCCrpIB9gBAXICGChSCXByb2ZpbGVJZBIbCg'
    'RuYW1lGAcgASgJQge6SARyAhABUgRuYW1lEh0KCmdyb3VwX3R5cGUYCCABKAVSCWdyb3VwVHlw'
    'ZRIjCg1jdXJyZW5jeV9jb2RlGAkgASgJUgxjdXJyZW5jeUNvZGUSIwoNc2F2aW5nX2Ftb3VudB'
    'gKIAEoA1IMc2F2aW5nQW1vdW50EhsKCXRpbWVfem9uZRgLIAEoCVIIdGltZVpvbmUSHwoLbWlu'
    'X21lbWJlcnMYDCABKAVSCm1pbk1lbWJlcnMSHwoLbWF4X21lbWJlcnMYDSABKAVSCm1heE1lbW'
    'JlcnMSJgoFc3RhdGUYDiABKA4yEC5jb21tb24udjEuU1RBVEVSBXN0YXRlEjcKCnByb3BlcnRp'
    'ZXMYDyABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0Ugpwcm9wZXJ0aWVz');

@$core.Deprecated('Use clientGroupSaveRequestDescriptor instead')
const ClientGroupSaveRequest$json = {
  '1': 'ClientGroupSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.ClientGroupObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `ClientGroupSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientGroupSaveRequestDescriptor = $convert.base64Decode(
    'ChZDbGllbnRHcm91cFNhdmVSZXF1ZXN0EjoKBGRhdGEYASABKAsyHi5pZGVudGl0eS52MS5DbG'
    'llbnRHcm91cE9iamVjdEIGukgDyAEBUgRkYXRh');

@$core.Deprecated('Use clientGroupSaveResponseDescriptor instead')
const ClientGroupSaveResponse$json = {
  '1': 'ClientGroupSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.ClientGroupObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientGroupSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientGroupSaveResponseDescriptor = $convert.base64Decode(
    'ChdDbGllbnRHcm91cFNhdmVSZXNwb25zZRIyCgRkYXRhGAEgASgLMh4uaWRlbnRpdHkudjEuQ2'
    'xpZW50R3JvdXBPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use clientGroupGetRequestDescriptor instead')
const ClientGroupGetRequest$json = {
  '1': 'ClientGroupGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `ClientGroupGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientGroupGetRequestDescriptor = $convert.base64Decode(
    'ChVDbGllbnRHcm91cEdldFJlcXVlc3QSKwoCaWQYASABKAlCG7pIGHIWEAMYKDIQWzAtOWEtel'
    '8tXXszLDQwfVICaWQ=');

@$core.Deprecated('Use clientGroupGetResponseDescriptor instead')
const ClientGroupGetResponse$json = {
  '1': 'ClientGroupGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.ClientGroupObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientGroupGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientGroupGetResponseDescriptor = $convert.base64Decode(
    'ChZDbGllbnRHcm91cEdldFJlc3BvbnNlEjIKBGRhdGEYASABKAsyHi5pZGVudGl0eS52MS5DbG'
    'llbnRHcm91cE9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use clientGroupSearchRequestDescriptor instead')
const ClientGroupSearchRequest$json = {
  '1': 'ClientGroupSearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'agent_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'agentId'},
    {'1': 'branch_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'branchId'},
    {'1': 'cursor', '3': 4, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `ClientGroupSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientGroupSearchRequestDescriptor = $convert.base64Decode(
    'ChhDbGllbnRHcm91cFNlYXJjaFJlcXVlc3QSFAoFcXVlcnkYASABKAlSBXF1ZXJ5EiUKCGFnZW'
    '50X2lkGAIgASgJQgq6SAfYAQFyAhgoUgdhZ2VudElkEicKCWJyYW5jaF9pZBgDIAEoCUIKukgH'
    '2AEBcgIYKFIIYnJhbmNoSWQSLQoGY3Vyc29yGAQgASgLMhUuY29tbW9uLnYxLlBhZ2VDdXJzb3'
    'JSBmN1cnNvcg==');

@$core.Deprecated('Use clientGroupSearchResponseDescriptor instead')
const ClientGroupSearchResponse$json = {
  '1': 'ClientGroupSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.identity.v1.ClientGroupObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientGroupSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientGroupSearchResponseDescriptor = $convert.base64Decode(
    'ChlDbGllbnRHcm91cFNlYXJjaFJlc3BvbnNlEjIKBGRhdGEYASADKAsyHi5pZGVudGl0eS52MS'
    '5DbGllbnRHcm91cE9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use membershipObjectDescriptor instead')
const MembershipObject$json = {
  '1': 'MembershipObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'group_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'groupId'},
    {'1': 'profile_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'profileId'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'contact_id', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'contactId'},
    {'1': 'role', '3': 6, '4': 1, '5': 5, '10': 'role'},
    {'1': 'membership_type', '3': 7, '4': 1, '5': 5, '10': 'membershipType'},
    {'1': 'order_no', '3': 8, '4': 1, '5': 5, '10': 'orderNo'},
    {'1': 'state', '3': 9, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'properties', '3': 10, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `MembershipObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipObjectDescriptor = $convert.base64Decode(
    'ChBNZW1iZXJzaGlwT2JqZWN0Ei4KAmlkGAEgASgJQh66SBvYAQFyFhADGCgyEFswLTlhLXpfLV'
    '17Myw0MH1SAmlkEiQKCGdyb3VwX2lkGAIgASgJQgm6SAZyBBADGChSB2dyb3VwSWQSKQoKcHJv'
    'ZmlsZV9pZBgDIAEoCUIKukgH2AEBcgIYKFIJcHJvZmlsZUlkEhsKBG5hbWUYBCABKAlCB7pIBH'
    'ICEAFSBG5hbWUSKQoKY29udGFjdF9pZBgFIAEoCUIKukgH2AEBcgIYKFIJY29udGFjdElkEhIK'
    'BHJvbGUYBiABKAVSBHJvbGUSJwoPbWVtYmVyc2hpcF90eXBlGAcgASgFUg5tZW1iZXJzaGlwVH'
    'lwZRIZCghvcmRlcl9ubxgIIAEoBVIHb3JkZXJObxImCgVzdGF0ZRgJIAEoDjIQLmNvbW1vbi52'
    'MS5TVEFURVIFc3RhdGUSNwoKcHJvcGVydGllcxgKIAEoCzIXLmdvb2dsZS5wcm90b2J1Zi5TdH'
    'J1Y3RSCnByb3BlcnRpZXM=');

@$core.Deprecated('Use membershipSaveRequestDescriptor instead')
const MembershipSaveRequest$json = {
  '1': 'MembershipSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.MembershipObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `MembershipSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipSaveRequestDescriptor = $convert.base64Decode(
    'ChVNZW1iZXJzaGlwU2F2ZVJlcXVlc3QSOQoEZGF0YRgBIAEoCzIdLmlkZW50aXR5LnYxLk1lbW'
    'JlcnNoaXBPYmplY3RCBrpIA8gBAVIEZGF0YQ==');

@$core.Deprecated('Use membershipSaveResponseDescriptor instead')
const MembershipSaveResponse$json = {
  '1': 'MembershipSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.MembershipObject', '10': 'data'},
  ],
};

/// Descriptor for `MembershipSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipSaveResponseDescriptor = $convert.base64Decode(
    'ChZNZW1iZXJzaGlwU2F2ZVJlc3BvbnNlEjEKBGRhdGEYASABKAsyHS5pZGVudGl0eS52MS5NZW'
    '1iZXJzaGlwT2JqZWN0UgRkYXRh');

@$core.Deprecated('Use membershipGetRequestDescriptor instead')
const MembershipGetRequest$json = {
  '1': 'MembershipGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `MembershipGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipGetRequestDescriptor = $convert.base64Decode(
    'ChRNZW1iZXJzaGlwR2V0UmVxdWVzdBIrCgJpZBgBIAEoCUIbukgYchYQAxgoMhBbMC05YS16Xy'
    '1dezMsNDB9UgJpZA==');

@$core.Deprecated('Use membershipGetResponseDescriptor instead')
const MembershipGetResponse$json = {
  '1': 'MembershipGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.MembershipObject', '10': 'data'},
  ],
};

/// Descriptor for `MembershipGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipGetResponseDescriptor = $convert.base64Decode(
    'ChVNZW1iZXJzaGlwR2V0UmVzcG9uc2USMQoEZGF0YRgBIAEoCzIdLmlkZW50aXR5LnYxLk1lbW'
    'JlcnNoaXBPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use membershipSearchRequestDescriptor instead')
const MembershipSearchRequest$json = {
  '1': 'MembershipSearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'group_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'groupId'},
    {'1': 'profile_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'profileId'},
    {'1': 'cursor', '3': 4, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `MembershipSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipSearchRequestDescriptor = $convert.base64Decode(
    'ChdNZW1iZXJzaGlwU2VhcmNoUmVxdWVzdBIUCgVxdWVyeRgBIAEoCVIFcXVlcnkSJQoIZ3JvdX'
    'BfaWQYAiABKAlCCrpIB9gBAXICGChSB2dyb3VwSWQSKQoKcHJvZmlsZV9pZBgDIAEoCUIKukgH'
    '2AEBcgIYKFIJcHJvZmlsZUlkEi0KBmN1cnNvchgEIAEoCzIVLmNvbW1vbi52MS5QYWdlQ3Vyc2'
    '9yUgZjdXJzb3I=');

@$core.Deprecated('Use membershipSearchResponseDescriptor instead')
const MembershipSearchResponse$json = {
  '1': 'MembershipSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.identity.v1.MembershipObject', '10': 'data'},
  ],
};

/// Descriptor for `MembershipSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipSearchResponseDescriptor = $convert.base64Decode(
    'ChhNZW1iZXJzaGlwU2VhcmNoUmVzcG9uc2USMQoEZGF0YRgBIAMoCzIdLmlkZW50aXR5LnYxLk'
    '1lbWJlcnNoaXBPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use investorAccountObjectDescriptor instead')
const InvestorAccountObject$json = {
  '1': 'InvestorAccountObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'investor_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'investorId'},
    {'1': 'account_name', '3': 3, '4': 1, '5': 9, '10': 'accountName'},
    {'1': 'available_balance', '3': 5, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'availableBalance'},
    {'1': 'reserved_balance', '3': 6, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'reservedBalance'},
    {'1': 'total_deployed', '3': 7, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'totalDeployed'},
    {'1': 'total_returned', '3': 8, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'totalReturned'},
    {'1': 'max_exposure', '3': 9, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'maxExposure'},
    {'1': 'min_interest_rate', '3': 10, '4': 1, '5': 9, '10': 'minInterestRate'},
    {'1': 'allowed_products', '3': 11, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'allowedProducts'},
    {'1': 'allowed_regions', '3': 12, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'allowedRegions'},
    {'1': 'group_affiliations', '3': 13, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'groupAffiliations'},
    {'1': 'state', '3': 14, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'properties', '3': 15, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
  '9': [
    {'1': 4, '2': 5},
  ],
};

/// Descriptor for `InvestorAccountObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List investorAccountObjectDescriptor = $convert.base64Decode(
    'ChVJbnZlc3RvckFjY291bnRPYmplY3QSLgoCaWQYASABKAlCHrpIG9gBAXIWEAMYKDIQWzAtOW'
    'Etel8tXXszLDQwfVICaWQSKgoLaW52ZXN0b3JfaWQYAiABKAlCCbpIBnIEEAMYKFIKaW52ZXN0'
    'b3JJZBIhCgxhY2NvdW50X25hbWUYAyABKAlSC2FjY291bnROYW1lEj8KEWF2YWlsYWJsZV9iYW'
    'xhbmNlGAUgASgLMhIuZ29vZ2xlLnR5cGUuTW9uZXlSEGF2YWlsYWJsZUJhbGFuY2USPQoQcmVz'
    'ZXJ2ZWRfYmFsYW5jZRgGIAEoCzISLmdvb2dsZS50eXBlLk1vbmV5Ug9yZXNlcnZlZEJhbGFuY2'
    'USOQoOdG90YWxfZGVwbG95ZWQYByABKAsyEi5nb29nbGUudHlwZS5Nb25leVINdG90YWxEZXBs'
    'b3llZBI5Cg50b3RhbF9yZXR1cm5lZBgIIAEoCzISLmdvb2dsZS50eXBlLk1vbmV5Ug10b3RhbF'
    'JldHVybmVkEjUKDG1heF9leHBvc3VyZRgJIAEoCzISLmdvb2dsZS50eXBlLk1vbmV5UgttYXhF'
    'eHBvc3VyZRIqChFtaW5faW50ZXJlc3RfcmF0ZRgKIAEoCVIPbWluSW50ZXJlc3RSYXRlEkIKEG'
    'FsbG93ZWRfcHJvZHVjdHMYCyABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0Ug9hbGxvd2Vk'
    'UHJvZHVjdHMSQAoPYWxsb3dlZF9yZWdpb25zGAwgASgLMhcuZ29vZ2xlLnByb3RvYnVmLlN0cn'
    'VjdFIOYWxsb3dlZFJlZ2lvbnMSRgoSZ3JvdXBfYWZmaWxpYXRpb25zGA0gASgLMhcuZ29vZ2xl'
    'LnByb3RvYnVmLlN0cnVjdFIRZ3JvdXBBZmZpbGlhdGlvbnMSJgoFc3RhdGUYDiABKA4yEC5jb2'
    '1tb24udjEuU1RBVEVSBXN0YXRlEjcKCnByb3BlcnRpZXMYDyABKAsyFy5nb29nbGUucHJvdG9i'
    'dWYuU3RydWN0Ugpwcm9wZXJ0aWVzSgQIBBAF');

@$core.Deprecated('Use investorAccountSaveRequestDescriptor instead')
const InvestorAccountSaveRequest$json = {
  '1': 'InvestorAccountSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.InvestorAccountObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `InvestorAccountSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List investorAccountSaveRequestDescriptor = $convert.base64Decode(
    'ChpJbnZlc3RvckFjY291bnRTYXZlUmVxdWVzdBI+CgRkYXRhGAEgASgLMiIuaWRlbnRpdHkudj'
    'EuSW52ZXN0b3JBY2NvdW50T2JqZWN0Qga6SAPIAQFSBGRhdGE=');

@$core.Deprecated('Use investorAccountSaveResponseDescriptor instead')
const InvestorAccountSaveResponse$json = {
  '1': 'InvestorAccountSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.InvestorAccountObject', '10': 'data'},
  ],
};

/// Descriptor for `InvestorAccountSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List investorAccountSaveResponseDescriptor = $convert.base64Decode(
    'ChtJbnZlc3RvckFjY291bnRTYXZlUmVzcG9uc2USNgoEZGF0YRgBIAEoCzIiLmlkZW50aXR5Ln'
    'YxLkludmVzdG9yQWNjb3VudE9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use investorAccountGetRequestDescriptor instead')
const InvestorAccountGetRequest$json = {
  '1': 'InvestorAccountGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `InvestorAccountGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List investorAccountGetRequestDescriptor = $convert.base64Decode(
    'ChlJbnZlc3RvckFjY291bnRHZXRSZXF1ZXN0EisKAmlkGAEgASgJQhu6SBhyFhADGCgyEFswLT'
    'lhLXpfLV17Myw0MH1SAmlk');

@$core.Deprecated('Use investorAccountGetResponseDescriptor instead')
const InvestorAccountGetResponse$json = {
  '1': 'InvestorAccountGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.InvestorAccountObject', '10': 'data'},
  ],
};

/// Descriptor for `InvestorAccountGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List investorAccountGetResponseDescriptor = $convert.base64Decode(
    'ChpJbnZlc3RvckFjY291bnRHZXRSZXNwb25zZRI2CgRkYXRhGAEgASgLMiIuaWRlbnRpdHkudj'
    'EuSW52ZXN0b3JBY2NvdW50T2JqZWN0UgRkYXRh');

@$core.Deprecated('Use investorAccountSearchRequestDescriptor instead')
const InvestorAccountSearchRequest$json = {
  '1': 'InvestorAccountSearchRequest',
  '2': [
    {'1': 'investor_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'investorId'},
    {'1': 'currency_code', '3': 2, '4': 1, '5': 9, '10': 'currencyCode'},
    {'1': 'cursor', '3': 3, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `InvestorAccountSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List investorAccountSearchRequestDescriptor = $convert.base64Decode(
    'ChxJbnZlc3RvckFjY291bnRTZWFyY2hSZXF1ZXN0Ei0KC2ludmVzdG9yX2lkGAEgASgJQgy6SA'
    'nYAQFyBBADGChSCmludmVzdG9ySWQSIwoNY3VycmVuY3lfY29kZRgCIAEoCVIMY3VycmVuY3lD'
    'b2RlEi0KBmN1cnNvchgDIAEoCzIVLmNvbW1vbi52MS5QYWdlQ3Vyc29yUgZjdXJzb3I=');

@$core.Deprecated('Use investorAccountSearchResponseDescriptor instead')
const InvestorAccountSearchResponse$json = {
  '1': 'InvestorAccountSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.identity.v1.InvestorAccountObject', '10': 'data'},
  ],
};

/// Descriptor for `InvestorAccountSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List investorAccountSearchResponseDescriptor = $convert.base64Decode(
    'Ch1JbnZlc3RvckFjY291bnRTZWFyY2hSZXNwb25zZRI2CgRkYXRhGAEgAygLMiIuaWRlbnRpdH'
    'kudjEuSW52ZXN0b3JBY2NvdW50T2JqZWN0UgRkYXRh');

@$core.Deprecated('Use investorDepositRequestDescriptor instead')
const InvestorDepositRequest$json = {
  '1': 'InvestorDepositRequest',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'accountId'},
    {'1': 'amount', '3': 2, '4': 1, '5': 11, '6': '.google.type.Money', '8': {}, '10': 'amount'},
  ],
  '9': [
    {'1': 3, '2': 4},
  ],
};

/// Descriptor for `InvestorDepositRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List investorDepositRequestDescriptor = $convert.base64Decode(
    'ChZJbnZlc3RvckRlcG9zaXRSZXF1ZXN0EigKCmFjY291bnRfaWQYASABKAlCCbpIBnIEEAMYKF'
    'IJYWNjb3VudElkEjIKBmFtb3VudBgCIAEoCzISLmdvb2dsZS50eXBlLk1vbmV5Qga6SAPIAQFS'
    'BmFtb3VudEoECAMQBA==');

@$core.Deprecated('Use investorDepositResponseDescriptor instead')
const InvestorDepositResponse$json = {
  '1': 'InvestorDepositResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.InvestorAccountObject', '10': 'data'},
  ],
};

/// Descriptor for `InvestorDepositResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List investorDepositResponseDescriptor = $convert.base64Decode(
    'ChdJbnZlc3RvckRlcG9zaXRSZXNwb25zZRI2CgRkYXRhGAEgASgLMiIuaWRlbnRpdHkudjEuSW'
    '52ZXN0b3JBY2NvdW50T2JqZWN0UgRkYXRh');

@$core.Deprecated('Use investorWithdrawRequestDescriptor instead')
const InvestorWithdrawRequest$json = {
  '1': 'InvestorWithdrawRequest',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'accountId'},
    {'1': 'amount', '3': 2, '4': 1, '5': 11, '6': '.google.type.Money', '8': {}, '10': 'amount'},
  ],
};

/// Descriptor for `InvestorWithdrawRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List investorWithdrawRequestDescriptor = $convert.base64Decode(
    'ChdJbnZlc3RvcldpdGhkcmF3UmVxdWVzdBIoCgphY2NvdW50X2lkGAEgASgJQgm6SAZyBBADGC'
    'hSCWFjY291bnRJZBIyCgZhbW91bnQYAiABKAsyEi5nb29nbGUudHlwZS5Nb25leUIGukgDyAEB'
    'UgZhbW91bnQ=');

@$core.Deprecated('Use investorWithdrawResponseDescriptor instead')
const InvestorWithdrawResponse$json = {
  '1': 'InvestorWithdrawResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.InvestorAccountObject', '10': 'data'},
  ],
};

/// Descriptor for `InvestorWithdrawResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List investorWithdrawResponseDescriptor = $convert.base64Decode(
    'ChhJbnZlc3RvcldpdGhkcmF3UmVzcG9uc2USNgoEZGF0YRgBIAEoCzIiLmlkZW50aXR5LnYxLk'
    'ludmVzdG9yQWNjb3VudE9iamVjdFIEZGF0YQ==');

const $core.Map<$core.String, $core.dynamic> IdentityServiceBase$json = {
  '1': 'IdentityService',
  '2': [
    {'1': 'OrganizationSave', '2': '.identity.v1.OrganizationSaveRequest', '3': '.identity.v1.OrganizationSaveResponse', '4': {}},
    {
      '1': 'OrganizationGet',
      '2': '.identity.v1.OrganizationGetRequest',
      '3': '.identity.v1.OrganizationGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'OrganizationSearch',
      '2': '.common.v1.SearchRequest',
      '3': '.identity.v1.OrganizationSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'BranchSave', '2': '.identity.v1.BranchSaveRequest', '3': '.identity.v1.BranchSaveResponse', '4': {}},
    {
      '1': 'BranchGet',
      '2': '.identity.v1.BranchGetRequest',
      '3': '.identity.v1.BranchGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'BranchSearch',
      '2': '.identity.v1.BranchSearchRequest',
      '3': '.identity.v1.BranchSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'InvestorSave', '2': '.identity.v1.InvestorSaveRequest', '3': '.identity.v1.InvestorSaveResponse', '4': {}},
    {
      '1': 'InvestorGet',
      '2': '.identity.v1.InvestorGetRequest',
      '3': '.identity.v1.InvestorGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'InvestorSearch',
      '2': '.identity.v1.InvestorSearchRequest',
      '3': '.identity.v1.InvestorSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'SystemUserSave', '2': '.identity.v1.SystemUserSaveRequest', '3': '.identity.v1.SystemUserSaveResponse', '4': {}},
    {
      '1': 'SystemUserGet',
      '2': '.identity.v1.SystemUserGetRequest',
      '3': '.identity.v1.SystemUserGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'SystemUserSearch',
      '2': '.identity.v1.SystemUserSearchRequest',
      '3': '.identity.v1.SystemUserSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'ClientGroupSave', '2': '.identity.v1.ClientGroupSaveRequest', '3': '.identity.v1.ClientGroupSaveResponse', '4': {}},
    {
      '1': 'ClientGroupGet',
      '2': '.identity.v1.ClientGroupGetRequest',
      '3': '.identity.v1.ClientGroupGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'ClientGroupSearch',
      '2': '.identity.v1.ClientGroupSearchRequest',
      '3': '.identity.v1.ClientGroupSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'MembershipSave', '2': '.identity.v1.MembershipSaveRequest', '3': '.identity.v1.MembershipSaveResponse', '4': {}},
    {
      '1': 'MembershipGet',
      '2': '.identity.v1.MembershipGetRequest',
      '3': '.identity.v1.MembershipGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'MembershipSearch',
      '2': '.identity.v1.MembershipSearchRequest',
      '3': '.identity.v1.MembershipSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'InvestorAccountSave', '2': '.identity.v1.InvestorAccountSaveRequest', '3': '.identity.v1.InvestorAccountSaveResponse', '4': {}},
    {
      '1': 'InvestorAccountGet',
      '2': '.identity.v1.InvestorAccountGetRequest',
      '3': '.identity.v1.InvestorAccountGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'InvestorAccountSearch',
      '2': '.identity.v1.InvestorAccountSearchRequest',
      '3': '.identity.v1.InvestorAccountSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'InvestorDeposit', '2': '.identity.v1.InvestorDepositRequest', '3': '.identity.v1.InvestorDepositResponse', '4': {}},
    {'1': 'InvestorWithdraw', '2': '.identity.v1.InvestorWithdrawRequest', '3': '.identity.v1.InvestorWithdrawResponse', '4': {}},
  ],
  '3': {},
};

@$core.Deprecated('Use identityServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> IdentityServiceBase$messageJson = {
  '.identity.v1.OrganizationSaveRequest': OrganizationSaveRequest$json,
  '.identity.v1.OrganizationObject': OrganizationObject$json,
  '.google.protobuf.Struct': $6.Struct$json,
  '.google.protobuf.Struct.FieldsEntry': $6.Struct_FieldsEntry$json,
  '.google.protobuf.Value': $6.Value$json,
  '.google.protobuf.ListValue': $6.ListValue$json,
  '.identity.v1.OrganizationSaveResponse': OrganizationSaveResponse$json,
  '.identity.v1.OrganizationGetRequest': OrganizationGetRequest$json,
  '.identity.v1.OrganizationGetResponse': OrganizationGetResponse$json,
  '.common.v1.SearchRequest': $7.SearchRequest$json,
  '.common.v1.PageCursor': $7.PageCursor$json,
  '.identity.v1.OrganizationSearchResponse': OrganizationSearchResponse$json,
  '.identity.v1.BranchSaveRequest': BranchSaveRequest$json,
  '.identity.v1.BranchObject': BranchObject$json,
  '.identity.v1.BranchSaveResponse': BranchSaveResponse$json,
  '.identity.v1.BranchGetRequest': BranchGetRequest$json,
  '.identity.v1.BranchGetResponse': BranchGetResponse$json,
  '.identity.v1.BranchSearchRequest': BranchSearchRequest$json,
  '.identity.v1.BranchSearchResponse': BranchSearchResponse$json,
  '.identity.v1.InvestorSaveRequest': InvestorSaveRequest$json,
  '.identity.v1.InvestorObject': InvestorObject$json,
  '.identity.v1.InvestorSaveResponse': InvestorSaveResponse$json,
  '.identity.v1.InvestorGetRequest': InvestorGetRequest$json,
  '.identity.v1.InvestorGetResponse': InvestorGetResponse$json,
  '.identity.v1.InvestorSearchRequest': InvestorSearchRequest$json,
  '.identity.v1.InvestorSearchResponse': InvestorSearchResponse$json,
  '.identity.v1.SystemUserSaveRequest': SystemUserSaveRequest$json,
  '.identity.v1.SystemUserObject': SystemUserObject$json,
  '.identity.v1.SystemUserSaveResponse': SystemUserSaveResponse$json,
  '.identity.v1.SystemUserGetRequest': SystemUserGetRequest$json,
  '.identity.v1.SystemUserGetResponse': SystemUserGetResponse$json,
  '.identity.v1.SystemUserSearchRequest': SystemUserSearchRequest$json,
  '.identity.v1.SystemUserSearchResponse': SystemUserSearchResponse$json,
  '.identity.v1.ClientGroupSaveRequest': ClientGroupSaveRequest$json,
  '.identity.v1.ClientGroupObject': ClientGroupObject$json,
  '.identity.v1.ClientGroupSaveResponse': ClientGroupSaveResponse$json,
  '.identity.v1.ClientGroupGetRequest': ClientGroupGetRequest$json,
  '.identity.v1.ClientGroupGetResponse': ClientGroupGetResponse$json,
  '.identity.v1.ClientGroupSearchRequest': ClientGroupSearchRequest$json,
  '.identity.v1.ClientGroupSearchResponse': ClientGroupSearchResponse$json,
  '.identity.v1.MembershipSaveRequest': MembershipSaveRequest$json,
  '.identity.v1.MembershipObject': MembershipObject$json,
  '.identity.v1.MembershipSaveResponse': MembershipSaveResponse$json,
  '.identity.v1.MembershipGetRequest': MembershipGetRequest$json,
  '.identity.v1.MembershipGetResponse': MembershipGetResponse$json,
  '.identity.v1.MembershipSearchRequest': MembershipSearchRequest$json,
  '.identity.v1.MembershipSearchResponse': MembershipSearchResponse$json,
  '.identity.v1.InvestorAccountSaveRequest': InvestorAccountSaveRequest$json,
  '.identity.v1.InvestorAccountObject': InvestorAccountObject$json,
  '.google.type.Money': $9.Money$json,
  '.identity.v1.InvestorAccountSaveResponse': InvestorAccountSaveResponse$json,
  '.identity.v1.InvestorAccountGetRequest': InvestorAccountGetRequest$json,
  '.identity.v1.InvestorAccountGetResponse': InvestorAccountGetResponse$json,
  '.identity.v1.InvestorAccountSearchRequest': InvestorAccountSearchRequest$json,
  '.identity.v1.InvestorAccountSearchResponse': InvestorAccountSearchResponse$json,
  '.identity.v1.InvestorDepositRequest': InvestorDepositRequest$json,
  '.identity.v1.InvestorDepositResponse': InvestorDepositResponse$json,
  '.identity.v1.InvestorWithdrawRequest': InvestorWithdrawRequest$json,
  '.identity.v1.InvestorWithdrawResponse': InvestorWithdrawResponse$json,
};

/// Descriptor for `IdentityService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List identityServiceDescriptor = $convert.base64Decode(
    'Cg9JZGVudGl0eVNlcnZpY2USvwIKEE9yZ2FuaXphdGlvblNhdmUSJC5pZGVudGl0eS52MS5Pcm'
    'dhbml6YXRpb25TYXZlUmVxdWVzdBolLmlkZW50aXR5LnYxLk9yZ2FuaXphdGlvblNhdmVSZXNw'
    'b25zZSLdAbpHwAEKDU9yZ2FuaXphdGlvbnMSIENyZWF0ZSBvciB1cGRhdGUgYW4gb3JnYW5pem'
    'F0aW9uGntDcmVhdGVzIGEgbmV3IG9yZ2FuaXphdGlvbiBvciB1cGRhdGVzIGFuIGV4aXN0aW5n'
    'IG9uZS4gT3JnYW5pemF0aW9ucyByZXByZXNlbnQgdG9wLWxldmVsIGluc3RpdHV0aW9ucyBtYX'
    'BwZWQgdG8gcGFydGl0aW9ucy4qEG9yZ2FuaXphdGlvblNhdmWCtRgVChNvcmdhbml6YXRpb25f'
    'bWFuYWdlEvMBCg9Pcmdhbml6YXRpb25HZXQSIy5pZGVudGl0eS52MS5Pcmdhbml6YXRpb25HZX'
    'RSZXF1ZXN0GiQuaWRlbnRpdHkudjEuT3JnYW5pemF0aW9uR2V0UmVzcG9uc2UilAGQAgG6R3cK'
    'DU9yZ2FuaXphdGlvbnMSGUdldCBhbiBvcmdhbml6YXRpb24gYnkgSUQaOlJldHJpZXZlcyBhbi'
    'Bvcmdhbml6YXRpb24gcmVjb3JkIGJ5IGl0cyB1bmlxdWUgaWRlbnRpZmllci4qD29yZ2FuaXph'
    'dGlvbkdldIK1GBMKEW9yZ2FuaXphdGlvbl92aWV3Ep8CChJPcmdhbml6YXRpb25TZWFyY2gSGC'
    '5jb21tb24udjEuU2VhcmNoUmVxdWVzdBonLmlkZW50aXR5LnYxLk9yZ2FuaXphdGlvblNlYXJj'
    'aFJlc3BvbnNlIsMBkAIBukelAQoNT3JnYW5pemF0aW9ucxIUU2VhcmNoIG9yZ2FuaXphdGlvbn'
    'MaalNlYXJjaGVzIGZvciBvcmdhbml6YXRpb25zIG1hdGNoaW5nIHNwZWNpZmllZCBjcml0ZXJp'
    'YS4gUmV0dXJucyBhIHN0cmVhbSBvZiBtYXRjaGluZyBvcmdhbml6YXRpb24gcmVjb3Jkcy4qEm'
    '9yZ2FuaXphdGlvblNlYXJjaIK1GBMKEW9yZ2FuaXphdGlvbl92aWV3MAESkwIKCkJyYW5jaFNh'
    'dmUSHi5pZGVudGl0eS52MS5CcmFuY2hTYXZlUmVxdWVzdBofLmlkZW50aXR5LnYxLkJyYW5jaF'
    'NhdmVSZXNwb25zZSLDAbpHrAEKCEJyYW5jaGVzEhlDcmVhdGUgb3IgdXBkYXRlIGEgYnJhbmNo'
    'GnlDcmVhdGVzIGEgbmV3IGJyYW5jaCBvciB1cGRhdGVzIGFuIGV4aXN0aW5nIG9uZS4gQnJhbm'
    'NoZXMgcmVwcmVzZW50IHN1Yi1kaXZpc2lvbnMgb2Ygb3JnYW5pemF0aW9ucyB3aXRoIGdlb2dy'
    'YXBoaWMgYXJlYXMuKgpicmFuY2hTYXZlgrUYDwoNYnJhbmNoX21hbmFnZRLBAQoJQnJhbmNoR2'
    'V0Eh0uaWRlbnRpdHkudjEuQnJhbmNoR2V0UmVxdWVzdBoeLmlkZW50aXR5LnYxLkJyYW5jaEdl'
    'dFJlc3BvbnNlInWQAgG6R14KCEJyYW5jaGVzEhJHZXQgYSBicmFuY2ggYnkgSUQaM1JldHJpZX'
    'ZlcyBhIGJyYW5jaCByZWNvcmQgYnkgaXRzIHVuaXF1ZSBpZGVudGlmaWVyLioJYnJhbmNoR2V0'
    'grUYDQoLYnJhbmNoX3ZpZXcSogIKDEJyYW5jaFNlYXJjaBIgLmlkZW50aXR5LnYxLkJyYW5jaF'
    'NlYXJjaFJlcXVlc3QaIS5pZGVudGl0eS52MS5CcmFuY2hTZWFyY2hSZXNwb25zZSLKAZACAbpH'
    'sgEKCEJyYW5jaGVzEg9TZWFyY2ggYnJhbmNoZXMahgFTZWFyY2hlcyBmb3IgYnJhbmNoZXMgbW'
    'F0Y2hpbmcgc3BlY2lmaWVkIGNyaXRlcmlhLiBTdXBwb3J0cyBmaWx0ZXJpbmcgYnkgb3JnYW5p'
    'emF0aW9uIElELiBSZXR1cm5zIGEgc3RyZWFtIG9mIG1hdGNoaW5nIGJyYW5jaCByZWNvcmRzLi'
    'oMYnJhbmNoU2VhcmNogrUYDQoLYnJhbmNoX3ZpZXcwARKSAgoMSW52ZXN0b3JTYXZlEiAuaWRl'
    'bnRpdHkudjEuSW52ZXN0b3JTYXZlUmVxdWVzdBohLmlkZW50aXR5LnYxLkludmVzdG9yU2F2ZV'
    'Jlc3BvbnNlIrwBukejAQoJSW52ZXN0b3JzEhxDcmVhdGUgb3IgdXBkYXRlIGFuIGludmVzdG9y'
    'GmpDcmVhdGVzIGEgbmV3IGludmVzdG9yIG9yIHVwZGF0ZXMgYW4gZXhpc3Rpbmcgb25lLiBJbn'
    'Zlc3RvcnMgYXJlIGluZGVwZW5kZW50IGVudGl0aWVzIGxpbmtlZCB0byBhIHByb2ZpbGUuKgxp'
    'bnZlc3RvclNhdmWCtRgRCg9pbnZlc3Rvcl9tYW5hZ2US1QEKC0ludmVzdG9yR2V0Eh8uaWRlbn'
    'RpdHkudjEuSW52ZXN0b3JHZXRSZXF1ZXN0GiAuaWRlbnRpdHkudjEuSW52ZXN0b3JHZXRSZXNw'
    'b25zZSKCAZACAbpHaQoJSW52ZXN0b3JzEhVHZXQgYW4gaW52ZXN0b3IgYnkgSUQaOFJldHJpZX'
    'ZlcyBhbiBpbnZlc3RvciByZWNvcmQgYnkgdGhlaXIgdW5pcXVlIGlkZW50aWZpZXIuKgtpbnZl'
    'c3RvckdldIK1GA8KDWludmVzdG9yX3ZpZXcSiQIKDkludmVzdG9yU2VhcmNoEiIuaWRlbnRpdH'
    'kudjEuSW52ZXN0b3JTZWFyY2hSZXF1ZXN0GiMuaWRlbnRpdHkudjEuSW52ZXN0b3JTZWFyY2hS'
    'ZXNwb25zZSKrAZACAbpHkQEKCUludmVzdG9ycxIQU2VhcmNoIGludmVzdG9ycxpiU2VhcmNoZX'
    'MgZm9yIGludmVzdG9ycyBtYXRjaGluZyBzcGVjaWZpZWQgY3JpdGVyaWEuIFJldHVybnMgYSBz'
    'dHJlYW0gb2YgbWF0Y2hpbmcgaW52ZXN0b3IgcmVjb3Jkcy4qDmludmVzdG9yU2VhcmNogrUYDw'
    'oNaW52ZXN0b3JfdmlldzABEtQCCg5TeXN0ZW1Vc2VyU2F2ZRIiLmlkZW50aXR5LnYxLlN5c3Rl'
    'bVVzZXJTYXZlUmVxdWVzdBojLmlkZW50aXR5LnYxLlN5c3RlbVVzZXJTYXZlUmVzcG9uc2Ui+A'
    'G6R9wBCgtTeXN0ZW1Vc2VycxIeQ3JlYXRlIG9yIHVwZGF0ZSBhIHN5c3RlbSB1c2VyGpwBQ3Jl'
    'YXRlcyBhIG5ldyBzeXN0ZW0gdXNlciBvciB1cGRhdGVzIGFuIGV4aXN0aW5nIG9uZS4gU3lzdG'
    'VtIHVzZXJzIGFyZSBhc3NpZ25lZCByb2xlcyAodmVyaWZpZXIsIGFwcHJvdmVyLCBhZG1pbmlz'
    'dHJhdG9yLCBhdWRpdG9yKSBmb3IgcHJvY2Vzc2luZyB3b3JrZmxvd3MuKg5zeXN0ZW1Vc2VyU2'
    'F2ZYK1GBQKEnN5c3RlbV91c2VyX21hbmFnZRLmAQoNU3lzdGVtVXNlckdldBIhLmlkZW50aXR5'
    'LnYxLlN5c3RlbVVzZXJHZXRSZXF1ZXN0GiIuaWRlbnRpdHkudjEuU3lzdGVtVXNlckdldFJlc3'
    'BvbnNlIo0BkAIBukdxCgtTeXN0ZW1Vc2VycxIXR2V0IGEgc3lzdGVtIHVzZXIgYnkgSUQaOlJl'
    'dHJpZXZlcyBhIHN5c3RlbSB1c2VyIHJlY29yZCBieSB0aGVpciB1bmlxdWUgaWRlbnRpZmllci'
    '4qDXN5c3RlbVVzZXJHZXSCtRgSChBzeXN0ZW1fdXNlcl92aWV3EscCChBTeXN0ZW1Vc2VyU2Vh'
    'cmNoEiQuaWRlbnRpdHkudjEuU3lzdGVtVXNlclNlYXJjaFJlcXVlc3QaJS5pZGVudGl0eS52MS'
    '5TeXN0ZW1Vc2VyU2VhcmNoUmVzcG9uc2Ui4wGQAgG6R8YBCgtTeXN0ZW1Vc2VycxITU2VhcmNo'
    'IHN5c3RlbSB1c2VycxqPAVNlYXJjaGVzIGZvciBzeXN0ZW0gdXNlcnMgbWF0Y2hpbmcgc3BlY2'
    'lmaWVkIGNyaXRlcmlhLiBTdXBwb3J0cyBmaWx0ZXJpbmcgYnkgcm9sZSBhbmQgYnJhbmNoLiBS'
    'ZXR1cm5zIGEgc3RyZWFtIG9mIG1hdGNoaW5nIHN5c3RlbSB1c2VyIHJlY29yZHMuKhBzeXN0ZW'
    '1Vc2VyU2VhcmNogrUYEgoQc3lzdGVtX3VzZXJfdmlldzABEtACCg9DbGllbnRHcm91cFNhdmUS'
    'Iy5pZGVudGl0eS52MS5DbGllbnRHcm91cFNhdmVSZXF1ZXN0GiQuaWRlbnRpdHkudjEuQ2xpZW'
    '50R3JvdXBTYXZlUmVzcG9uc2Ui8QG6R9QBCgxDbGllbnRHcm91cHMSH0NyZWF0ZSBvciB1cGRh'
    'dGUgYSBjbGllbnQgZ3JvdXAakQFDcmVhdGVzIGEgbmV3IGNsaWVudCBncm91cCBvciB1cGRhdG'
    'VzIGFuIGV4aXN0aW5nIG9uZS4gQ2xpZW50IGdyb3VwcyByZXByZXNlbnQgY29sbGVjdGl2ZSBl'
    'bnRpdGllcyBzdWNoIGFzIFNBQ0NPIGdyb3VwcyBpbiB0aGUgbGVuZGluZyBoaWVyYXJjaHkuKg'
    '9jbGllbnRHcm91cFNhdmWCtRgVChNjbGllbnRfZ3JvdXBfbWFuYWdlEuwBCg5DbGllbnRHcm91'
    'cEdldBIiLmlkZW50aXR5LnYxLkNsaWVudEdyb3VwR2V0UmVxdWVzdBojLmlkZW50aXR5LnYxLk'
    'NsaWVudEdyb3VwR2V0UmVzcG9uc2UikAGQAgG6R3MKDENsaWVudEdyb3VwcxIYR2V0IGEgY2xp'
    'ZW50IGdyb3VwIGJ5IElEGjlSZXRyaWV2ZXMgYSBjbGllbnQgZ3JvdXAgcmVjb3JkIGJ5IGl0cy'
    'B1bmlxdWUgaWRlbnRpZmllci4qDmNsaWVudEdyb3VwR2V0grUYEwoRY2xpZW50X2dyb3VwX3Zp'
    'ZXcS0QIKEUNsaWVudEdyb3VwU2VhcmNoEiUuaWRlbnRpdHkudjEuQ2xpZW50R3JvdXBTZWFyY2'
    'hSZXF1ZXN0GiYuaWRlbnRpdHkudjEuQ2xpZW50R3JvdXBTZWFyY2hSZXNwb25zZSLqAZACAbpH'
    'zAEKDENsaWVudEdyb3VwcxIUU2VhcmNoIGNsaWVudCBncm91cHMakgFTZWFyY2hlcyBmb3IgY2'
    'xpZW50IGdyb3VwcyBtYXRjaGluZyBzcGVjaWZpZWQgY3JpdGVyaWEuIFN1cHBvcnRzIGZpbHRl'
    'cmluZyBieSBhZ2VudCBhbmQgYnJhbmNoLiBSZXR1cm5zIGEgc3RyZWFtIG9mIG1hdGNoaW5nIG'
    'NsaWVudCBncm91cCByZWNvcmRzLioRY2xpZW50R3JvdXBTZWFyY2iCtRgTChFjbGllbnRfZ3Jv'
    'dXBfdmlldzABEqgCCg5NZW1iZXJzaGlwU2F2ZRIiLmlkZW50aXR5LnYxLk1lbWJlcnNoaXBTYX'
    'ZlUmVxdWVzdBojLmlkZW50aXR5LnYxLk1lbWJlcnNoaXBTYXZlUmVzcG9uc2UizAG6R7EBCgtN'
    'ZW1iZXJzaGlwcxIdQ3JlYXRlIG9yIHVwZGF0ZSBhIG1lbWJlcnNoaXAac0NyZWF0ZXMgYSBuZX'
    'cgbWVtYmVyc2hpcCBvciB1cGRhdGVzIGFuIGV4aXN0aW5nIG9uZS4gTWVtYmVyc2hpcHMgdHJh'
    'Y2sgYSBwcm9maWxlJ3MgYWZmaWxpYXRpb24gd2l0aCBhIGNsaWVudCBncm91cC4qDm1lbWJlcn'
    'NoaXBTYXZlgrUYEwoRbWVtYmVyc2hpcF9tYW5hZ2US4QEKDU1lbWJlcnNoaXBHZXQSIS5pZGVu'
    'dGl0eS52MS5NZW1iZXJzaGlwR2V0UmVxdWVzdBoiLmlkZW50aXR5LnYxLk1lbWJlcnNoaXBHZX'
    'RSZXNwb25zZSKIAZACAbpHbQoLTWVtYmVyc2hpcHMSFkdldCBhIG1lbWJlcnNoaXAgYnkgSUQa'
    'N1JldHJpZXZlcyBhIG1lbWJlcnNoaXAgcmVjb3JkIGJ5IGl0cyB1bmlxdWUgaWRlbnRpZmllci'
    '4qDW1lbWJlcnNoaXBHZXSCtRgRCg9tZW1iZXJzaGlwX3ZpZXcSxQIKEE1lbWJlcnNoaXBTZWFy'
    'Y2gSJC5pZGVudGl0eS52MS5NZW1iZXJzaGlwU2VhcmNoUmVxdWVzdBolLmlkZW50aXR5LnYxLk'
    '1lbWJlcnNoaXBTZWFyY2hSZXNwb25zZSLhAZACAbpHxQEKC01lbWJlcnNoaXBzEhJTZWFyY2gg'
    'bWVtYmVyc2hpcHMajwFTZWFyY2hlcyBmb3IgbWVtYmVyc2hpcHMgbWF0Y2hpbmcgc3BlY2lmaW'
    'VkIGNyaXRlcmlhLiBTdXBwb3J0cyBmaWx0ZXJpbmcgYnkgZ3JvdXAgYW5kIHByb2ZpbGUuIFJl'
    'dHVybnMgYSBzdHJlYW0gb2YgbWF0Y2hpbmcgbWVtYmVyc2hpcCByZWNvcmRzLioQbWVtYmVyc2'
    'hpcFNlYXJjaIK1GBEKD21lbWJlcnNoaXBfdmlldzABEugCChNJbnZlc3RvckFjY291bnRTYXZl'
    'EicuaWRlbnRpdHkudjEuSW52ZXN0b3JBY2NvdW50U2F2ZVJlcXVlc3QaKC5pZGVudGl0eS52MS'
    '5JbnZlc3RvckFjY291bnRTYXZlUmVzcG9uc2Ui/QG6R9wBChBJbnZlc3RvckFjY291bnRzEiRD'
    'cmVhdGUgb3IgdXBkYXRlIGFuIGludmVzdG9yIGFjY291bnQajAFDcmVhdGVzIGEgbmV3IGludm'
    'VzdG9yIGNhcGl0YWwgYWNjb3VudCBvciB1cGRhdGVzIGFuIGV4aXN0aW5nIG9uZS4gSW52ZXN0'
    'b3IgYWNjb3VudHMgdHJhY2sgcHJlLWZ1bmRlZCBjYXBpdGFsIGF2YWlsYWJsZSBmb3IgbG9hbi'
    'BkZXBsb3ltZW50LioTaW52ZXN0b3JBY2NvdW50U2F2ZYK1GBkKF2ludmVzdG9yX2FjY291bnRf'
    'bWFuYWdlEpACChJJbnZlc3RvckFjY291bnRHZXQSJi5pZGVudGl0eS52MS5JbnZlc3RvckFjY2'
    '91bnRHZXRSZXF1ZXN0GicuaWRlbnRpdHkudjEuSW52ZXN0b3JBY2NvdW50R2V0UmVzcG9uc2Ui'
    'qAGQAgG6R4YBChBJbnZlc3RvckFjY291bnRzEh1HZXQgYW4gaW52ZXN0b3IgYWNjb3VudCBieS'
    'BJRBo/UmV0cmlldmVzIGFuIGludmVzdG9yIGNhcGl0YWwgYWNjb3VudCBieSBpdHMgdW5pcXVl'
    'IGlkZW50aWZpZXIuKhJpbnZlc3RvckFjY291bnRHZXSCtRgXChVpbnZlc3Rvcl9hY2NvdW50X3'
    'ZpZXcSygIKFUludmVzdG9yQWNjb3VudFNlYXJjaBIpLmlkZW50aXR5LnYxLkludmVzdG9yQWNj'
    'b3VudFNlYXJjaFJlcXVlc3QaKi5pZGVudGl0eS52MS5JbnZlc3RvckFjY291bnRTZWFyY2hSZX'
    'Nwb25zZSLXAZACAbpHtQEKEEludmVzdG9yQWNjb3VudHMSGFNlYXJjaCBpbnZlc3RvciBhY2Nv'
    'dW50cxpwU2VhcmNoZXMgZm9yIGludmVzdG9yIGFjY291bnRzIG1hdGNoaW5nIHNwZWNpZmllZC'
    'Bjcml0ZXJpYS4gU3VwcG9ydHMgZmlsdGVyaW5nIGJ5IGludmVzdG9yIElEIGFuZCBjdXJyZW5j'
    'eSBjb2RlLioVaW52ZXN0b3JBY2NvdW50U2VhcmNogrUYFwoVaW52ZXN0b3JfYWNjb3VudF92aW'
    'V3MAESpwIKD0ludmVzdG9yRGVwb3NpdBIjLmlkZW50aXR5LnYxLkludmVzdG9yRGVwb3NpdFJl'
    'cXVlc3QaJC5pZGVudGl0eS52MS5JbnZlc3RvckRlcG9zaXRSZXNwb25zZSLIAbpHpwEKEEludm'
    'VzdG9yQWNjb3VudHMSJkRlcG9zaXQgZnVuZHMgaW50byBhbiBpbnZlc3RvciBhY2NvdW50GlpB'
    'ZGRzIGNhcGl0YWwgdG8gYW4gaW52ZXN0b3IgYWNjb3VudCwgaW5jcmVhc2luZyB0aGUgYXZhaW'
    'xhYmxlIGJhbGFuY2UgZm9yIGxvYW4gZGVwbG95bWVudC4qD2ludmVzdG9yRGVwb3NpdIK1GBkK'
    'F2ludmVzdG9yX2FjY291bnRfbWFuYWdlEqkCChBJbnZlc3RvcldpdGhkcmF3EiQuaWRlbnRpdH'
    'kudjEuSW52ZXN0b3JXaXRoZHJhd1JlcXVlc3QaJS5pZGVudGl0eS52MS5JbnZlc3RvcldpdGhk'
    'cmF3UmVzcG9uc2UixwG6R6YBChBJbnZlc3RvckFjY291bnRzEidXaXRoZHJhdyBmdW5kcyBmcm'
    '9tIGFuIGludmVzdG9yIGFjY291bnQaV1JlbW92ZXMgY2FwaXRhbCBmcm9tIGFuIGludmVzdG9y'
    'IGFjY291bnQgaWYgc3VmZmljaWVudCB1bnJlc2VydmVkIGJhbGFuY2UgaXMgYXZhaWxhYmxlLi'
    'oQaW52ZXN0b3JXaXRoZHJhd4K1GBkKF2ludmVzdG9yX2FjY291bnRfbWFuYWdlGosMgrUYhgwK'
    'EHNlcnZpY2VfaWRlbnRpdHkSEW9yZ2FuaXphdGlvbl92aWV3EhNvcmdhbml6YXRpb25fbWFuYW'
    'dlEgticmFuY2hfdmlldxINYnJhbmNoX21hbmFnZRINaW52ZXN0b3JfdmlldxIPaW52ZXN0b3Jf'
    'bWFuYWdlEhBzeXN0ZW1fdXNlcl92aWV3EhJzeXN0ZW1fdXNlcl9tYW5hZ2USEWNsaWVudF9ncm'
    '91cF92aWV3EhNjbGllbnRfZ3JvdXBfbWFuYWdlEg9tZW1iZXJzaGlwX3ZpZXcSEW1lbWJlcnNo'
    'aXBfbWFuYWdlEhVpbnZlc3Rvcl9hY2NvdW50X3ZpZXcSF2ludmVzdG9yX2FjY291bnRfbWFuYW'
    'dlGogCCAESEW9yZ2FuaXphdGlvbl92aWV3EhNvcmdhbml6YXRpb25fbWFuYWdlEgticmFuY2hf'
    'dmlldxINYnJhbmNoX21hbmFnZRINaW52ZXN0b3JfdmlldxIPaW52ZXN0b3JfbWFuYWdlEhBzeX'
    'N0ZW1fdXNlcl92aWV3EhJzeXN0ZW1fdXNlcl9tYW5hZ2USEWNsaWVudF9ncm91cF92aWV3EhNj'
    'bGllbnRfZ3JvdXBfbWFuYWdlEg9tZW1iZXJzaGlwX3ZpZXcSEW1lbWJlcnNoaXBfbWFuYWdlEh'
    'VpbnZlc3Rvcl9hY2NvdW50X3ZpZXcSF2ludmVzdG9yX2FjY291bnRfbWFuYWdlGogCCAISEW9y'
    'Z2FuaXphdGlvbl92aWV3EhNvcmdhbml6YXRpb25fbWFuYWdlEgticmFuY2hfdmlldxINYnJhbm'
    'NoX21hbmFnZRINaW52ZXN0b3JfdmlldxIPaW52ZXN0b3JfbWFuYWdlEhBzeXN0ZW1fdXNlcl92'
    'aWV3EhJzeXN0ZW1fdXNlcl9tYW5hZ2USEWNsaWVudF9ncm91cF92aWV3EhNjbGllbnRfZ3JvdX'
    'BfbWFuYWdlEg9tZW1iZXJzaGlwX3ZpZXcSEW1lbWJlcnNoaXBfbWFuYWdlEhVpbnZlc3Rvcl9h'
    'Y2NvdW50X3ZpZXcSF2ludmVzdG9yX2FjY291bnRfbWFuYWdlGsoBCAMSEW9yZ2FuaXphdGlvbl'
    '92aWV3EhNvcmdhbml6YXRpb25fbWFuYWdlEgticmFuY2hfdmlldxINYnJhbmNoX21hbmFnZRIN'
    'aW52ZXN0b3JfdmlldxIVaW52ZXN0b3JfYWNjb3VudF92aWV3EhBzeXN0ZW1fdXNlcl92aWV3Eh'
    'FjbGllbnRfZ3JvdXBfdmlldxITY2xpZW50X2dyb3VwX21hbmFnZRIPbWVtYmVyc2hpcF92aWV3'
    'EhFtZW1iZXJzaGlwX21hbmFnZRp+CAQSEW9yZ2FuaXphdGlvbl92aWV3EgticmFuY2hfdmlldx'
    'INaW52ZXN0b3JfdmlldxIVaW52ZXN0b3JfYWNjb3VudF92aWV3EhBzeXN0ZW1fdXNlcl92aWV3'
    'EhFjbGllbnRfZ3JvdXBfdmlldxIPbWVtYmVyc2hpcF92aWV3Gn4IBRIRb3JnYW5pemF0aW9uX3'
    'ZpZXcSC2JyYW5jaF92aWV3Eg1pbnZlc3Rvcl92aWV3EhVpbnZlc3Rvcl9hY2NvdW50X3ZpZXcS'
    'EHN5c3RlbV91c2VyX3ZpZXcSEWNsaWVudF9ncm91cF92aWV3Eg9tZW1iZXJzaGlwX3ZpZXcaiA'
    'IIBhIRb3JnYW5pemF0aW9uX3ZpZXcSE29yZ2FuaXphdGlvbl9tYW5hZ2USC2JyYW5jaF92aWV3'
    'Eg1icmFuY2hfbWFuYWdlEg1pbnZlc3Rvcl92aWV3Eg9pbnZlc3Rvcl9tYW5hZ2USEHN5c3RlbV'
    '91c2VyX3ZpZXcSEnN5c3RlbV91c2VyX21hbmFnZRIRY2xpZW50X2dyb3VwX3ZpZXcSE2NsaWVu'
    'dF9ncm91cF9tYW5hZ2USD21lbWJlcnNoaXBfdmlldxIRbWVtYmVyc2hpcF9tYW5hZ2USFWludm'
    'VzdG9yX2FjY291bnRfdmlldxIXaW52ZXN0b3JfYWNjb3VudF9tYW5hZ2U=');

