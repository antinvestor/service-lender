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

@$core.Deprecated('Use bankSaveRequestDescriptor instead')
const BankSaveRequest$json = {
  '1': 'BankSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.BankObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `BankSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bankSaveRequestDescriptor = $convert.base64Decode(
    'Cg9CYW5rU2F2ZVJlcXVlc3QSMwoEZGF0YRgBIAEoCzIXLmlkZW50aXR5LnYxLkJhbmtPYmplY3'
    'RCBrpIA8gBAVIEZGF0YQ==');

@$core.Deprecated('Use bankSaveResponseDescriptor instead')
const BankSaveResponse$json = {
  '1': 'BankSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.BankObject', '10': 'data'},
  ],
};

/// Descriptor for `BankSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bankSaveResponseDescriptor = $convert.base64Decode(
    'ChBCYW5rU2F2ZVJlc3BvbnNlEisKBGRhdGEYASABKAsyFy5pZGVudGl0eS52MS5CYW5rT2JqZW'
    'N0UgRkYXRh');

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
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.BankObject', '10': 'data'},
  ],
};

/// Descriptor for `BankGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bankGetResponseDescriptor = $convert.base64Decode(
    'Cg9CYW5rR2V0UmVzcG9uc2USKwoEZGF0YRgBIAEoCzIXLmlkZW50aXR5LnYxLkJhbmtPYmplY3'
    'RSBGRhdGE=');

@$core.Deprecated('Use bankSearchResponseDescriptor instead')
const BankSearchResponse$json = {
  '1': 'BankSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.identity.v1.BankObject', '10': 'data'},
  ],
};

/// Descriptor for `BankSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bankSearchResponseDescriptor = $convert.base64Decode(
    'ChJCYW5rU2VhcmNoUmVzcG9uc2USKwoEZGF0YRgBIAMoCzIXLmlkZW50aXR5LnYxLkJhbmtPYm'
    'plY3RSBGRhdGE=');

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

const $core.Map<$core.String, $core.dynamic> IdentityServiceBase$json = {
  '1': 'IdentityService',
  '2': [
    {'1': 'BankSave', '2': '.identity.v1.BankSaveRequest', '3': '.identity.v1.BankSaveResponse', '4': {}},
    {
      '1': 'BankGet',
      '2': '.identity.v1.BankGetRequest',
      '3': '.identity.v1.BankGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'BankSearch',
      '2': '.common.v1.SearchRequest',
      '3': '.identity.v1.BankSearchResponse',
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
  ],
};

@$core.Deprecated('Use identityServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> IdentityServiceBase$messageJson = {
  '.identity.v1.BankSaveRequest': BankSaveRequest$json,
  '.identity.v1.BankObject': BankObject$json,
  '.google.protobuf.Struct': $6.Struct$json,
  '.google.protobuf.Struct.FieldsEntry': $6.Struct_FieldsEntry$json,
  '.google.protobuf.Value': $6.Value$json,
  '.google.protobuf.ListValue': $6.ListValue$json,
  '.identity.v1.BankSaveResponse': BankSaveResponse$json,
  '.identity.v1.BankGetRequest': BankGetRequest$json,
  '.identity.v1.BankGetResponse': BankGetResponse$json,
  '.common.v1.SearchRequest': $7.SearchRequest$json,
  '.common.v1.PageCursor': $7.PageCursor$json,
  '.identity.v1.BankSearchResponse': BankSearchResponse$json,
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
};

/// Descriptor for `IdentityService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List identityServiceDescriptor = $convert.base64Decode(
    'Cg9JZGVudGl0eVNlcnZpY2US7QEKCEJhbmtTYXZlEhwuaWRlbnRpdHkudjEuQmFua1NhdmVSZX'
    'F1ZXN0Gh0uaWRlbnRpdHkudjEuQmFua1NhdmVSZXNwb25zZSKjAbpHnwEKBUJhbmtzEhdDcmVh'
    'dGUgb3IgdXBkYXRlIGEgYmFuaxpzQ3JlYXRlcyBhIG5ldyBiYW5rIG9yIHVwZGF0ZXMgYW4gZX'
    'hpc3Rpbmcgb25lLiBCYW5rcyByZXByZXNlbnQgdG9wLWxldmVsIGxlbmRpbmcgaW5zdGl0dXRp'
    'b25zIG1hcHBlZCB0byBwYXJ0aXRpb25zLioIYmFua1NhdmUSoQEKB0JhbmtHZXQSGy5pZGVudG'
    'l0eS52MS5CYW5rR2V0UmVxdWVzdBocLmlkZW50aXR5LnYxLkJhbmtHZXRSZXNwb25zZSJbkAIB'
    'ukdVCgVCYW5rcxIQR2V0IGEgYmFuayBieSBJRBoxUmV0cmlldmVzIGEgYmFuayByZWNvcmQgYn'
    'kgaXRzIHVuaXF1ZSBpZGVudGlmaWVyLioHYmFua0dldBLPAQoKQmFua1NlYXJjaBIYLmNvbW1v'
    'bi52MS5TZWFyY2hSZXF1ZXN0Gh8uaWRlbnRpdHkudjEuQmFua1NlYXJjaFJlc3BvbnNlIoMBkA'
    'IBukd9CgVCYW5rcxIMU2VhcmNoIGJhbmtzGlpTZWFyY2hlcyBmb3IgYmFua3MgbWF0Y2hpbmcg'
    'c3BlY2lmaWVkIGNyaXRlcmlhLiBSZXR1cm5zIGEgc3RyZWFtIG9mIG1hdGNoaW5nIGJhbmsgcm'
    'Vjb3Jkcy4qCmJhbmtTZWFyY2gwARL4AQoKQnJhbmNoU2F2ZRIeLmlkZW50aXR5LnYxLkJyYW5j'
    'aFNhdmVSZXF1ZXN0Gh8uaWRlbnRpdHkudjEuQnJhbmNoU2F2ZVJlc3BvbnNlIqgBukekAQoIQn'
    'JhbmNoZXMSGUNyZWF0ZSBvciB1cGRhdGUgYSBicmFuY2gacUNyZWF0ZXMgYSBuZXcgYnJhbmNo'
    'IG9yIHVwZGF0ZXMgYW4gZXhpc3Rpbmcgb25lLiBCcmFuY2hlcyByZXByZXNlbnQgc3ViLWRpdm'
    'lzaW9ucyBvZiBiYW5rcyB3aXRoIGdlb2dyYXBoaWMgYXJlYXMuKgpicmFuY2hTYXZlErABCglC'
    'cmFuY2hHZXQSHS5pZGVudGl0eS52MS5CcmFuY2hHZXRSZXF1ZXN0Gh4uaWRlbnRpdHkudjEuQn'
    'JhbmNoR2V0UmVzcG9uc2UiZJACAbpHXgoIQnJhbmNoZXMSEkdldCBhIGJyYW5jaCBieSBJRBoz'
    'UmV0cmlldmVzIGEgYnJhbmNoIHJlY29yZCBieSBpdHMgdW5pcXVlIGlkZW50aWZpZXIuKglicm'
    'FuY2hHZXQSiAIKDEJyYW5jaFNlYXJjaBIgLmlkZW50aXR5LnYxLkJyYW5jaFNlYXJjaFJlcXVl'
    'c3QaIS5pZGVudGl0eS52MS5CcmFuY2hTZWFyY2hSZXNwb25zZSKwAZACAbpHqQEKCEJyYW5jaG'
    'VzEg9TZWFyY2ggYnJhbmNoZXMaflNlYXJjaGVzIGZvciBicmFuY2hlcyBtYXRjaGluZyBzcGVj'
    'aWZpZWQgY3JpdGVyaWEuIFN1cHBvcnRzIGZpbHRlcmluZyBieSBiYW5rIElELiBSZXR1cm5zIG'
    'Egc3RyZWFtIG9mIG1hdGNoaW5nIGJyYW5jaCByZWNvcmRzLioMYnJhbmNoU2VhcmNoMAES/QEK'
    'DEludmVzdG9yU2F2ZRIgLmlkZW50aXR5LnYxLkludmVzdG9yU2F2ZVJlcXVlc3QaIS5pZGVudG'
    'l0eS52MS5JbnZlc3RvclNhdmVSZXNwb25zZSKnAbpHowEKCUludmVzdG9ycxIcQ3JlYXRlIG9y'
    'IHVwZGF0ZSBhbiBpbnZlc3RvchpqQ3JlYXRlcyBhIG5ldyBpbnZlc3RvciBvciB1cGRhdGVzIG'
    'FuIGV4aXN0aW5nIG9uZS4gSW52ZXN0b3JzIGFyZSBpbmRlcGVuZGVudCBlbnRpdGllcyBsaW5r'
    'ZWQgdG8gYSBwcm9maWxlLioMaW52ZXN0b3JTYXZlEsEBCgtJbnZlc3RvckdldBIfLmlkZW50aX'
    'R5LnYxLkludmVzdG9yR2V0UmVxdWVzdBogLmlkZW50aXR5LnYxLkludmVzdG9yR2V0UmVzcG9u'
    'c2Uib5ACAbpHaQoJSW52ZXN0b3JzEhVHZXQgYW4gaW52ZXN0b3IgYnkgSUQaOFJldHJpZXZlcy'
    'BhbiBpbnZlc3RvciByZWNvcmQgYnkgdGhlaXIgdW5pcXVlIGlkZW50aWZpZXIuKgtpbnZlc3Rv'
    'ckdldBL2AQoOSW52ZXN0b3JTZWFyY2gSIi5pZGVudGl0eS52MS5JbnZlc3RvclNlYXJjaFJlcX'
    'Vlc3QaIy5pZGVudGl0eS52MS5JbnZlc3RvclNlYXJjaFJlc3BvbnNlIpgBkAIBukeRAQoJSW52'
    'ZXN0b3JzEhBTZWFyY2ggaW52ZXN0b3JzGmJTZWFyY2hlcyBmb3IgaW52ZXN0b3JzIG1hdGNoaW'
    '5nIHNwZWNpZmllZCBjcml0ZXJpYS4gUmV0dXJucyBhIHN0cmVhbSBvZiBtYXRjaGluZyBpbnZl'
    'c3RvciByZWNvcmRzLioOaW52ZXN0b3JTZWFyY2gwARLBAgoOU3lzdGVtVXNlclNhdmUSIi5pZG'
    'VudGl0eS52MS5TeXN0ZW1Vc2VyU2F2ZVJlcXVlc3QaIy5pZGVudGl0eS52MS5TeXN0ZW1Vc2Vy'
    'U2F2ZVJlc3BvbnNlIuUBukfhAQoLU3lzdGVtVXNlcnMSHkNyZWF0ZSBvciB1cGRhdGUgYSBzeX'
    'N0ZW0gdXNlchqhAUNyZWF0ZXMgYSBuZXcgc3lzdGVtIHVzZXIgb3IgdXBkYXRlcyBhbiBleGlz'
    'dGluZyBvbmUuIFN5c3RlbSB1c2VycyBhcmUgYXNzaWduZWQgcm9sZXMgKHZlcmlmaWVyLCBhcH'
    'Byb3ZlciwgYWRtaW5pc3RyYXRvciwgYXVkaXRvcikgZm9yIGxvYW4gcHJvY2Vzc2luZyB3b3Jr'
    'Zmxvd3MuKg5zeXN0ZW1Vc2VyU2F2ZRLPAQoNU3lzdGVtVXNlckdldBIhLmlkZW50aXR5LnYxLl'
    'N5c3RlbVVzZXJHZXRSZXF1ZXN0GiIuaWRlbnRpdHkudjEuU3lzdGVtVXNlckdldFJlc3BvbnNl'
    'IneQAgG6R3EKC1N5c3RlbVVzZXJzEhdHZXQgYSBzeXN0ZW0gdXNlciBieSBJRBo6UmV0cmlldm'
    'VzIGEgc3lzdGVtIHVzZXIgcmVjb3JkIGJ5IHRoZWlyIHVuaXF1ZSBpZGVudGlmaWVyLioNc3lz'
    'dGVtVXNlckdldBKxAgoQU3lzdGVtVXNlclNlYXJjaBIkLmlkZW50aXR5LnYxLlN5c3RlbVVzZX'
    'JTZWFyY2hSZXF1ZXN0GiUuaWRlbnRpdHkudjEuU3lzdGVtVXNlclNlYXJjaFJlc3BvbnNlIs0B'
    'kAIBukfGAQoLU3lzdGVtVXNlcnMSE1NlYXJjaCBzeXN0ZW0gdXNlcnMajwFTZWFyY2hlcyBmb3'
    'Igc3lzdGVtIHVzZXJzIG1hdGNoaW5nIHNwZWNpZmllZCBjcml0ZXJpYS4gU3VwcG9ydHMgZmls'
    'dGVyaW5nIGJ5IHJvbGUgYW5kIGJyYW5jaC4gUmV0dXJucyBhIHN0cmVhbSBvZiBtYXRjaGluZy'
    'BzeXN0ZW0gdXNlciByZWNvcmRzLioQc3lzdGVtVXNlclNlYXJjaDAB');

