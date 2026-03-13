//
//  Generated code. Do not modify.
//  source: lender/v1/identity.proto
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

@$core.Deprecated('Use bankObjectDescriptor instead')
const BankObject$json = {
  '1': 'BankObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'partition_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'partitionId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'code', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'code'},
    {'1': 'profile_id', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'profileId'},
    {'1': 'state', '3': 6, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'properties', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `BankObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bankObjectDescriptor = $convert.base64Decode(
    'CgpCYW5rT2JqZWN0Ei4KAmlkGAEgASgJQh66SBvYAQFyFhADGCgyEFswLTlhLXpfLV17Myw0MH'
    '1SAmlkEiwKDHBhcnRpdGlvbl9pZBgCIAEoCUIJukgGcgQQAxgoUgtwYXJ0aXRpb25JZBIbCgRu'
    'YW1lGAMgASgJQge6SARyAhABUgRuYW1lEhsKBGNvZGUYBCABKAlCB7pIBHICEAFSBGNvZGUSKw'
    'oKcHJvZmlsZV9pZBgFIAEoCUIMukgJ2AEBcgQQAxgoUglwcm9maWxlSWQSJgoFc3RhdGUYBiAB'
    'KA4yEC5jb21tb24udjEuU1RBVEVSBXN0YXRlEjcKCnByb3BlcnRpZXMYByABKAsyFy5nb29nbG'
    'UucHJvdG9idWYuU3RydWN0Ugpwcm9wZXJ0aWVz');

@$core.Deprecated('Use branchObjectDescriptor instead')
const BranchObject$json = {
  '1': 'BranchObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'bank_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'bankId'},
    {'1': 'partition_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'partitionId'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'code', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'code'},
    {'1': 'geo_id', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'geoId'},
    {'1': 'state', '3': 7, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'properties', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `BranchObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List branchObjectDescriptor = $convert.base64Decode(
    'CgxCcmFuY2hPYmplY3QSLgoCaWQYASABKAlCHrpIG9gBAXIWEAMYKDIQWzAtOWEtel8tXXszLD'
    'QwfVICaWQSIgoHYmFua19pZBgCIAEoCUIJukgGcgQQAxgoUgZiYW5rSWQSLwoMcGFydGl0aW9u'
    'X2lkGAMgASgJQgy6SAnYAQFyBBADGChSC3BhcnRpdGlvbklkEhsKBG5hbWUYBCABKAlCB7pIBH'
    'ICEAFSBG5hbWUSGwoEY29kZRgFIAEoCUIHukgEcgIQAVIEY29kZRIhCgZnZW9faWQYBiABKAlC'
    'CrpIB9gBAXICGChSBWdlb0lkEiYKBXN0YXRlGAcgASgOMhAuY29tbW9uLnYxLlNUQVRFUgVzdG'
    'F0ZRI3Cgpwcm9wZXJ0aWVzGAggASgLMhcuZ29vZ2xlLnByb3RvYnVmLlN0cnVjdFIKcHJvcGVy'
    'dGllcw==');

@$core.Deprecated('Use systemUserObjectDescriptor instead')
const SystemUserObject$json = {
  '1': 'SystemUserObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'profile_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'profileId'},
    {'1': 'branch_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'branchId'},
    {'1': 'role', '3': 4, '4': 1, '5': 14, '6': '.lender.v1.SystemUserRole', '10': 'role'},
    {'1': 'service_account_id', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'serviceAccountId'},
    {'1': 'state', '3': 6, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'properties', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `SystemUserObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List systemUserObjectDescriptor = $convert.base64Decode(
    'ChBTeXN0ZW1Vc2VyT2JqZWN0Ei4KAmlkGAEgASgJQh66SBvYAQFyFhADGCgyEFswLTlhLXpfLV'
    '17Myw0MH1SAmlkEigKCnByb2ZpbGVfaWQYAiABKAlCCbpIBnIEEAMYKFIJcHJvZmlsZUlkEiYK'
    'CWJyYW5jaF9pZBgDIAEoCUIJukgGcgQQAxgoUghicmFuY2hJZBItCgRyb2xlGAQgASgOMhkubG'
    'VuZGVyLnYxLlN5c3RlbVVzZXJSb2xlUgRyb2xlEjgKEnNlcnZpY2VfYWNjb3VudF9pZBgFIAEo'
    'CUIKukgH2AEBcgIYKFIQc2VydmljZUFjY291bnRJZBImCgVzdGF0ZRgGIAEoDjIQLmNvbW1vbi'
    '52MS5TVEFURVIFc3RhdGUSNwoKcHJvcGVydGllcxgHIAEoCzIXLmdvb2dsZS5wcm90b2J1Zi5T'
    'dHJ1Y3RSCnByb3BlcnRpZXM=');

@$core.Deprecated('Use bankSaveRequestDescriptor instead')
const BankSaveRequest$json = {
  '1': 'BankSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.BankObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `BankSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bankSaveRequestDescriptor = $convert.base64Decode(
    'Cg9CYW5rU2F2ZVJlcXVlc3QSMQoEZGF0YRgBIAEoCzIVLmxlbmRlci52MS5CYW5rT2JqZWN0Qg'
    'a6SAPIAQFSBGRhdGE=');

@$core.Deprecated('Use bankSaveResponseDescriptor instead')
const BankSaveResponse$json = {
  '1': 'BankSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.BankObject', '10': 'data'},
  ],
};

/// Descriptor for `BankSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bankSaveResponseDescriptor = $convert.base64Decode(
    'ChBCYW5rU2F2ZVJlc3BvbnNlEikKBGRhdGEYASABKAsyFS5sZW5kZXIudjEuQmFua09iamVjdF'
    'IEZGF0YQ==');

@$core.Deprecated('Use bankGetRequestDescriptor instead')
const BankGetRequest$json = {
  '1': 'BankGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `BankGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bankGetRequestDescriptor = $convert.base64Decode(
    'Cg5CYW5rR2V0UmVxdWVzdBIrCgJpZBgBIAEoCUIbukgYchYQAxgoMhBbMC05YS16Xy1dezMsND'
    'B9UgJpZA==');

@$core.Deprecated('Use bankGetResponseDescriptor instead')
const BankGetResponse$json = {
  '1': 'BankGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.BankObject', '10': 'data'},
  ],
};

/// Descriptor for `BankGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bankGetResponseDescriptor = $convert.base64Decode(
    'Cg9CYW5rR2V0UmVzcG9uc2USKQoEZGF0YRgBIAEoCzIVLmxlbmRlci52MS5CYW5rT2JqZWN0Ug'
    'RkYXRh');

@$core.Deprecated('Use bankSearchResponseDescriptor instead')
const BankSearchResponse$json = {
  '1': 'BankSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.lender.v1.BankObject', '10': 'data'},
  ],
};

/// Descriptor for `BankSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bankSearchResponseDescriptor = $convert.base64Decode(
    'ChJCYW5rU2VhcmNoUmVzcG9uc2USKQoEZGF0YRgBIAMoCzIVLmxlbmRlci52MS5CYW5rT2JqZW'
    'N0UgRkYXRh');

@$core.Deprecated('Use branchSaveRequestDescriptor instead')
const BranchSaveRequest$json = {
  '1': 'BranchSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.BranchObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `BranchSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List branchSaveRequestDescriptor = $convert.base64Decode(
    'ChFCcmFuY2hTYXZlUmVxdWVzdBIzCgRkYXRhGAEgASgLMhcubGVuZGVyLnYxLkJyYW5jaE9iam'
    'VjdEIGukgDyAEBUgRkYXRh');

@$core.Deprecated('Use branchSaveResponseDescriptor instead')
const BranchSaveResponse$json = {
  '1': 'BranchSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.BranchObject', '10': 'data'},
  ],
};

/// Descriptor for `BranchSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List branchSaveResponseDescriptor = $convert.base64Decode(
    'ChJCcmFuY2hTYXZlUmVzcG9uc2USKwoEZGF0YRgBIAEoCzIXLmxlbmRlci52MS5CcmFuY2hPYm'
    'plY3RSBGRhdGE=');

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
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.BranchObject', '10': 'data'},
  ],
};

/// Descriptor for `BranchGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List branchGetResponseDescriptor = $convert.base64Decode(
    'ChFCcmFuY2hHZXRSZXNwb25zZRIrCgRkYXRhGAEgASgLMhcubGVuZGVyLnYxLkJyYW5jaE9iam'
    'VjdFIEZGF0YQ==');

@$core.Deprecated('Use branchSearchRequestDescriptor instead')
const BranchSearchRequest$json = {
  '1': 'BranchSearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'bank_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'bankId'},
    {'1': 'cursor', '3': 3, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `BranchSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List branchSearchRequestDescriptor = $convert.base64Decode(
    'ChNCcmFuY2hTZWFyY2hSZXF1ZXN0EhQKBXF1ZXJ5GAEgASgJUgVxdWVyeRIlCgdiYW5rX2lkGA'
    'IgASgJQgy6SAnYAQFyBBADGChSBmJhbmtJZBItCgZjdXJzb3IYAyABKAsyFS5jb21tb24udjEu'
    'UGFnZUN1cnNvclIGY3Vyc29y');

@$core.Deprecated('Use branchSearchResponseDescriptor instead')
const BranchSearchResponse$json = {
  '1': 'BranchSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.lender.v1.BranchObject', '10': 'data'},
  ],
};

/// Descriptor for `BranchSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List branchSearchResponseDescriptor = $convert.base64Decode(
    'ChRCcmFuY2hTZWFyY2hSZXNwb25zZRIrCgRkYXRhGAEgAygLMhcubGVuZGVyLnYxLkJyYW5jaE'
    '9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use systemUserSaveRequestDescriptor instead')
const SystemUserSaveRequest$json = {
  '1': 'SystemUserSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.SystemUserObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `SystemUserSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List systemUserSaveRequestDescriptor = $convert.base64Decode(
    'ChVTeXN0ZW1Vc2VyU2F2ZVJlcXVlc3QSNwoEZGF0YRgBIAEoCzIbLmxlbmRlci52MS5TeXN0ZW'
    '1Vc2VyT2JqZWN0Qga6SAPIAQFSBGRhdGE=');

@$core.Deprecated('Use systemUserSaveResponseDescriptor instead')
const SystemUserSaveResponse$json = {
  '1': 'SystemUserSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.SystemUserObject', '10': 'data'},
  ],
};

/// Descriptor for `SystemUserSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List systemUserSaveResponseDescriptor = $convert.base64Decode(
    'ChZTeXN0ZW1Vc2VyU2F2ZVJlc3BvbnNlEi8KBGRhdGEYASABKAsyGy5sZW5kZXIudjEuU3lzdG'
    'VtVXNlck9iamVjdFIEZGF0YQ==');

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
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.lender.v1.SystemUserObject', '10': 'data'},
  ],
};

/// Descriptor for `SystemUserGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List systemUserGetResponseDescriptor = $convert.base64Decode(
    'ChVTeXN0ZW1Vc2VyR2V0UmVzcG9uc2USLwoEZGF0YRgBIAEoCzIbLmxlbmRlci52MS5TeXN0ZW'
    '1Vc2VyT2JqZWN0UgRkYXRh');

@$core.Deprecated('Use systemUserSearchRequestDescriptor instead')
const SystemUserSearchRequest$json = {
  '1': 'SystemUserSearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'role', '3': 2, '4': 1, '5': 14, '6': '.lender.v1.SystemUserRole', '10': 'role'},
    {'1': 'branch_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'branchId'},
    {'1': 'cursor', '3': 4, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `SystemUserSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List systemUserSearchRequestDescriptor = $convert.base64Decode(
    'ChdTeXN0ZW1Vc2VyU2VhcmNoUmVxdWVzdBIUCgVxdWVyeRgBIAEoCVIFcXVlcnkSLQoEcm9sZR'
    'gCIAEoDjIZLmxlbmRlci52MS5TeXN0ZW1Vc2VyUm9sZVIEcm9sZRIpCglicmFuY2hfaWQYAyAB'
    'KAlCDLpICdgBAXIEEAMYKFIIYnJhbmNoSWQSLQoGY3Vyc29yGAQgASgLMhUuY29tbW9uLnYxLl'
    'BhZ2VDdXJzb3JSBmN1cnNvcg==');

@$core.Deprecated('Use systemUserSearchResponseDescriptor instead')
const SystemUserSearchResponse$json = {
  '1': 'SystemUserSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.lender.v1.SystemUserObject', '10': 'data'},
  ],
};

/// Descriptor for `SystemUserSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List systemUserSearchResponseDescriptor = $convert.base64Decode(
    'ChhTeXN0ZW1Vc2VyU2VhcmNoUmVzcG9uc2USLwoEZGF0YRgBIAMoCzIbLmxlbmRlci52MS5TeX'
    'N0ZW1Vc2VyT2JqZWN0UgRkYXRh');

const $core.Map<$core.String, $core.dynamic> IdentityServiceBase$json = {
  '1': 'IdentityService',
  '2': [
    {'1': 'BankSave', '2': '.lender.v1.BankSaveRequest', '3': '.lender.v1.BankSaveResponse', '4': {}},
    {
      '1': 'BankGet',
      '2': '.lender.v1.BankGetRequest',
      '3': '.lender.v1.BankGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'BankSearch',
      '2': '.common.v1.SearchRequest',
      '3': '.lender.v1.BankSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'BranchSave', '2': '.lender.v1.BranchSaveRequest', '3': '.lender.v1.BranchSaveResponse', '4': {}},
    {
      '1': 'BranchGet',
      '2': '.lender.v1.BranchGetRequest',
      '3': '.lender.v1.BranchGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'BranchSearch',
      '2': '.lender.v1.BranchSearchRequest',
      '3': '.lender.v1.BranchSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'SystemUserSave', '2': '.lender.v1.SystemUserSaveRequest', '3': '.lender.v1.SystemUserSaveResponse', '4': {}},
    {
      '1': 'SystemUserGet',
      '2': '.lender.v1.SystemUserGetRequest',
      '3': '.lender.v1.SystemUserGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'SystemUserSearch',
      '2': '.lender.v1.SystemUserSearchRequest',
      '3': '.lender.v1.SystemUserSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
  ],
};

@$core.Deprecated('Use identityServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> IdentityServiceBase$messageJson = {
  '.lender.v1.BankSaveRequest': BankSaveRequest$json,
  '.lender.v1.BankObject': BankObject$json,
  '.google.protobuf.Struct': $6.Struct$json,
  '.google.protobuf.Struct.FieldsEntry': $6.Struct_FieldsEntry$json,
  '.google.protobuf.Value': $6.Value$json,
  '.google.protobuf.ListValue': $6.ListValue$json,
  '.lender.v1.BankSaveResponse': BankSaveResponse$json,
  '.lender.v1.BankGetRequest': BankGetRequest$json,
  '.lender.v1.BankGetResponse': BankGetResponse$json,
  '.common.v1.SearchRequest': $7.SearchRequest$json,
  '.common.v1.PageCursor': $7.PageCursor$json,
  '.lender.v1.BankSearchResponse': BankSearchResponse$json,
  '.lender.v1.BranchSaveRequest': BranchSaveRequest$json,
  '.lender.v1.BranchObject': BranchObject$json,
  '.lender.v1.BranchSaveResponse': BranchSaveResponse$json,
  '.lender.v1.BranchGetRequest': BranchGetRequest$json,
  '.lender.v1.BranchGetResponse': BranchGetResponse$json,
  '.lender.v1.BranchSearchRequest': BranchSearchRequest$json,
  '.lender.v1.BranchSearchResponse': BranchSearchResponse$json,
  '.lender.v1.SystemUserSaveRequest': SystemUserSaveRequest$json,
  '.lender.v1.SystemUserObject': SystemUserObject$json,
  '.lender.v1.SystemUserSaveResponse': SystemUserSaveResponse$json,
  '.lender.v1.SystemUserGetRequest': SystemUserGetRequest$json,
  '.lender.v1.SystemUserGetResponse': SystemUserGetResponse$json,
  '.lender.v1.SystemUserSearchRequest': SystemUserSearchRequest$json,
  '.lender.v1.SystemUserSearchResponse': SystemUserSearchResponse$json,
};

/// Descriptor for `IdentityService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List identityServiceDescriptor = $convert.base64Decode(
    'Cg9JZGVudGl0eVNlcnZpY2US6QEKCEJhbmtTYXZlEhoubGVuZGVyLnYxLkJhbmtTYXZlUmVxdW'
    'VzdBobLmxlbmRlci52MS5CYW5rU2F2ZVJlc3BvbnNlIqMBukefAQoFQmFua3MSF0NyZWF0ZSBv'
    'ciB1cGRhdGUgYSBiYW5rGnNDcmVhdGVzIGEgbmV3IGJhbmsgb3IgdXBkYXRlcyBhbiBleGlzdG'
    'luZyBvbmUuIEJhbmtzIHJlcHJlc2VudCB0b3AtbGV2ZWwgbGVuZGluZyBpbnN0aXR1dGlvbnMg'
    'bWFwcGVkIHRvIHBhcnRpdGlvbnMuKghiYW5rU2F2ZRKdAQoHQmFua0dldBIZLmxlbmRlci52MS'
    '5CYW5rR2V0UmVxdWVzdBoaLmxlbmRlci52MS5CYW5rR2V0UmVzcG9uc2UiW5ACAbpHVQoFQmFu'
    'a3MSEEdldCBhIGJhbmsgYnkgSUQaMVJldHJpZXZlcyBhIGJhbmsgcmVjb3JkIGJ5IGl0cyB1bm'
    'lxdWUgaWRlbnRpZmllci4qB2JhbmtHZXQSzQEKCkJhbmtTZWFyY2gSGC5jb21tb24udjEuU2Vh'
    'cmNoUmVxdWVzdBodLmxlbmRlci52MS5CYW5rU2VhcmNoUmVzcG9uc2UigwGQAgG6R30KBUJhbm'
    'tzEgxTZWFyY2ggYmFua3MaWlNlYXJjaGVzIGZvciBiYW5rcyBtYXRjaGluZyBzcGVjaWZpZWQg'
    'Y3JpdGVyaWEuIFJldHVybnMgYSBzdHJlYW0gb2YgbWF0Y2hpbmcgYmFuayByZWNvcmRzLioKYm'
    'Fua1NlYXJjaDABEvQBCgpCcmFuY2hTYXZlEhwubGVuZGVyLnYxLkJyYW5jaFNhdmVSZXF1ZXN0'
    'Gh0ubGVuZGVyLnYxLkJyYW5jaFNhdmVSZXNwb25zZSKoAbpHpAEKCEJyYW5jaGVzEhlDcmVhdG'
    'Ugb3IgdXBkYXRlIGEgYnJhbmNoGnFDcmVhdGVzIGEgbmV3IGJyYW5jaCBvciB1cGRhdGVzIGFu'
    'IGV4aXN0aW5nIG9uZS4gQnJhbmNoZXMgcmVwcmVzZW50IHN1Yi1kaXZpc2lvbnMgb2YgYmFua3'
    'Mgd2l0aCBnZW9ncmFwaGljIGFyZWFzLioKYnJhbmNoU2F2ZRKsAQoJQnJhbmNoR2V0EhsubGVu'
    'ZGVyLnYxLkJyYW5jaEdldFJlcXVlc3QaHC5sZW5kZXIudjEuQnJhbmNoR2V0UmVzcG9uc2UiZJ'
    'ACAbpHXgoIQnJhbmNoZXMSEkdldCBhIGJyYW5jaCBieSBJRBozUmV0cmlldmVzIGEgYnJhbmNo'
    'IHJlY29yZCBieSBpdHMgdW5pcXVlIGlkZW50aWZpZXIuKglicmFuY2hHZXQShAIKDEJyYW5jaF'
    'NlYXJjaBIeLmxlbmRlci52MS5CcmFuY2hTZWFyY2hSZXF1ZXN0Gh8ubGVuZGVyLnYxLkJyYW5j'
    'aFNlYXJjaFJlc3BvbnNlIrABkAIBukepAQoIQnJhbmNoZXMSD1NlYXJjaCBicmFuY2hlcxp+U2'
    'VhcmNoZXMgZm9yIGJyYW5jaGVzIG1hdGNoaW5nIHNwZWNpZmllZCBjcml0ZXJpYS4gU3VwcG9y'
    'dHMgZmlsdGVyaW5nIGJ5IGJhbmsgSUQuIFJldHVybnMgYSBzdHJlYW0gb2YgbWF0Y2hpbmcgYn'
    'JhbmNoIHJlY29yZHMuKgxicmFuY2hTZWFyY2gwARK9AgoOU3lzdGVtVXNlclNhdmUSIC5sZW5k'
    'ZXIudjEuU3lzdGVtVXNlclNhdmVSZXF1ZXN0GiEubGVuZGVyLnYxLlN5c3RlbVVzZXJTYXZlUm'
    'VzcG9uc2Ui5QG6R+EBCgtTeXN0ZW1Vc2VycxIeQ3JlYXRlIG9yIHVwZGF0ZSBhIHN5c3RlbSB1'
    'c2VyGqEBQ3JlYXRlcyBhIG5ldyBzeXN0ZW0gdXNlciBvciB1cGRhdGVzIGFuIGV4aXN0aW5nIG'
    '9uZS4gU3lzdGVtIHVzZXJzIGFyZSBhc3NpZ25lZCByb2xlcyAodmVyaWZpZXIsIGFwcHJvdmVy'
    'LCBhZG1pbmlzdHJhdG9yLCBhdWRpdG9yKSBmb3IgbG9hbiBwcm9jZXNzaW5nIHdvcmtmbG93cy'
    '4qDnN5c3RlbVVzZXJTYXZlEssBCg1TeXN0ZW1Vc2VyR2V0Eh8ubGVuZGVyLnYxLlN5c3RlbVVz'
    'ZXJHZXRSZXF1ZXN0GiAubGVuZGVyLnYxLlN5c3RlbVVzZXJHZXRSZXNwb25zZSJ3kAIBukdxCg'
    'tTeXN0ZW1Vc2VycxIXR2V0IGEgc3lzdGVtIHVzZXIgYnkgSUQaOlJldHJpZXZlcyBhIHN5c3Rl'
    'bSB1c2VyIHJlY29yZCBieSB0aGVpciB1bmlxdWUgaWRlbnRpZmllci4qDXN5c3RlbVVzZXJHZX'
    'QSrQIKEFN5c3RlbVVzZXJTZWFyY2gSIi5sZW5kZXIudjEuU3lzdGVtVXNlclNlYXJjaFJlcXVl'
    'c3QaIy5sZW5kZXIudjEuU3lzdGVtVXNlclNlYXJjaFJlc3BvbnNlIs0BkAIBukfGAQoLU3lzdG'
    'VtVXNlcnMSE1NlYXJjaCBzeXN0ZW0gdXNlcnMajwFTZWFyY2hlcyBmb3Igc3lzdGVtIHVzZXJz'
    'IG1hdGNoaW5nIHNwZWNpZmllZCBjcml0ZXJpYS4gU3VwcG9ydHMgZmlsdGVyaW5nIGJ5IHJvbG'
    'UgYW5kIGJyYW5jaC4gUmV0dXJucyBhIHN0cmVhbSBvZiBtYXRjaGluZyBzeXN0ZW0gdXNlciBy'
    'ZWNvcmRzLioQc3lzdGVtVXNlclNlYXJjaDAB');

