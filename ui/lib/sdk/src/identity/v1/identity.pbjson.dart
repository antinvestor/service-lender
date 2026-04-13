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
import '../../google/type/money.pbjson.dart' as $8;

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

@$core.Deprecated('Use orgUnitTypeDescriptor instead')
const OrgUnitType$json = {
  '1': 'OrgUnitType',
  '2': [
    {'1': 'ORG_UNIT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'ORG_UNIT_TYPE_REGION', '2': 1},
    {'1': 'ORG_UNIT_TYPE_ZONE', '2': 2},
    {'1': 'ORG_UNIT_TYPE_AREA', '2': 3},
    {'1': 'ORG_UNIT_TYPE_CLUSTER', '2': 4},
    {'1': 'ORG_UNIT_TYPE_BRANCH', '2': 5},
    {'1': 'ORG_UNIT_TYPE_OTHER', '2': 6},
  ],
};

/// Descriptor for `OrgUnitType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List orgUnitTypeDescriptor = $convert.base64Decode(
    'CgtPcmdVbml0VHlwZRIdChlPUkdfVU5JVF9UWVBFX1VOU1BFQ0lGSUVEEAASGAoUT1JHX1VOSV'
    'RfVFlQRV9SRUdJT04QARIWChJPUkdfVU5JVF9UWVBFX1pPTkUQAhIWChJPUkdfVU5JVF9UWVBF'
    'X0FSRUEQAxIZChVPUkdfVU5JVF9UWVBFX0NMVVNURVIQBBIYChRPUkdfVU5JVF9UWVBFX0JSQU'
    '5DSBAFEhcKE09SR19VTklUX1RZUEVfT1RIRVIQBg==');

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

@$core.Deprecated('Use dataVerificationStatusDescriptor instead')
const DataVerificationStatus$json = {
  '1': 'DataVerificationStatus',
  '2': [
    {'1': 'DATA_VERIFICATION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'DATA_VERIFICATION_STATUS_COLLECTED', '2': 1},
    {'1': 'DATA_VERIFICATION_STATUS_UNDER_REVIEW', '2': 2},
    {'1': 'DATA_VERIFICATION_STATUS_VERIFIED', '2': 3},
    {'1': 'DATA_VERIFICATION_STATUS_REJECTED', '2': 4},
    {'1': 'DATA_VERIFICATION_STATUS_MORE_INFO_NEEDED', '2': 5},
    {'1': 'DATA_VERIFICATION_STATUS_EXPIRED', '2': 6},
  ],
};

/// Descriptor for `DataVerificationStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List dataVerificationStatusDescriptor = $convert.base64Decode(
    'ChZEYXRhVmVyaWZpY2F0aW9uU3RhdHVzEigKJERBVEFfVkVSSUZJQ0FUSU9OX1NUQVRVU19VTl'
    'NQRUNJRklFRBAAEiYKIkRBVEFfVkVSSUZJQ0FUSU9OX1NUQVRVU19DT0xMRUNURUQQARIpCiVE'
    'QVRBX1ZFUklGSUNBVElPTl9TVEFUVVNfVU5ERVJfUkVWSUVXEAISJQohREFUQV9WRVJJRklDQV'
    'RJT05fU1RBVFVTX1ZFUklGSUVEEAMSJQohREFUQV9WRVJJRklDQVRJT05fU1RBVFVTX1JFSkVD'
    'VEVEEAQSLQopREFUQV9WRVJJRklDQVRJT05fU1RBVFVTX01PUkVfSU5GT19ORUVERUQQBRIkCi'
    'BEQVRBX1ZFUklGSUNBVElPTl9TVEFUVVNfRVhQSVJFRBAG');

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
    {'1': 'geo_id', '3': 10, '4': 1, '5': 9, '8': {}, '10': 'geoId'},
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
    'VzEicKCWNsaWVudF9pZBgJIAEoCUIKukgH2AEBcgIYKFIIY2xpZW50SWQSIQoGZ2VvX2lkGAog'
    'ASgJQgq6SAfYAQFyAhgoUgVnZW9JZA==');

@$core.Deprecated('Use orgUnitObjectDescriptor instead')
const OrgUnitObject$json = {
  '1': 'OrgUnitObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'organization_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'organizationId'},
    {'1': 'parent_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'parentId'},
    {'1': 'partition_id', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'partitionId'},
    {'1': 'name', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'code', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'code'},
    {'1': 'geo_id', '3': 7, '4': 1, '5': 9, '8': {}, '10': 'geoId'},
    {'1': 'state', '3': 8, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'type', '3': 9, '4': 1, '5': 14, '6': '.identity.v1.OrgUnitType', '10': 'type'},
    {'1': 'properties', '3': 10, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
    {'1': 'client_id', '3': 11, '4': 1, '5': 9, '8': {}, '10': 'clientId'},
    {'1': 'has_children', '3': 12, '4': 1, '5': 8, '10': 'hasChildren'},
  ],
};

/// Descriptor for `OrgUnitObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orgUnitObjectDescriptor = $convert.base64Decode(
    'Cg1PcmdVbml0T2JqZWN0Ei4KAmlkGAEgASgJQh66SBvYAQFyFhADGCgyEFswLTlhLXpfLV17My'
    'w0MH1SAmlkEjIKD29yZ2FuaXphdGlvbl9pZBgCIAEoCUIJukgGcgQQAxgoUg5vcmdhbml6YXRp'
    'b25JZBIpCglwYXJlbnRfaWQYAyABKAlCDLpICdgBAXIEEAMYKFIIcGFyZW50SWQSLwoMcGFydG'
    'l0aW9uX2lkGAQgASgJQgy6SAnYAQFyBBADGChSC3BhcnRpdGlvbklkEhsKBG5hbWUYBSABKAlC'
    'B7pIBHICEAFSBG5hbWUSGwoEY29kZRgGIAEoCUIHukgEcgIQAVIEY29kZRIhCgZnZW9faWQYBy'
    'ABKAlCCrpIB9gBAXICGChSBWdlb0lkEiYKBXN0YXRlGAggASgOMhAuY29tbW9uLnYxLlNUQVRF'
    'UgVzdGF0ZRIsCgR0eXBlGAkgASgOMhguaWRlbnRpdHkudjEuT3JnVW5pdFR5cGVSBHR5cGUSNw'
    'oKcHJvcGVydGllcxgKIAEoCzIXLmdvb2dsZS5wcm90b2J1Zi5TdHJ1Y3RSCnByb3BlcnRpZXMS'
    'JwoJY2xpZW50X2lkGAsgASgJQgq6SAfYAQFyAhgoUghjbGllbnRJZBIhCgxoYXNfY2hpbGRyZW'
    '4YDCABKAhSC2hhc0NoaWxkcmVu');

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

@$core.Deprecated('Use orgUnitSaveRequestDescriptor instead')
const OrgUnitSaveRequest$json = {
  '1': 'OrgUnitSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.OrgUnitObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `OrgUnitSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orgUnitSaveRequestDescriptor = $convert.base64Decode(
    'ChJPcmdVbml0U2F2ZVJlcXVlc3QSNgoEZGF0YRgBIAEoCzIaLmlkZW50aXR5LnYxLk9yZ1VuaX'
    'RPYmplY3RCBrpIA8gBAVIEZGF0YQ==');

@$core.Deprecated('Use orgUnitSaveResponseDescriptor instead')
const OrgUnitSaveResponse$json = {
  '1': 'OrgUnitSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.OrgUnitObject', '10': 'data'},
  ],
};

/// Descriptor for `OrgUnitSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orgUnitSaveResponseDescriptor = $convert.base64Decode(
    'ChNPcmdVbml0U2F2ZVJlc3BvbnNlEi4KBGRhdGEYASABKAsyGi5pZGVudGl0eS52MS5PcmdVbm'
    'l0T2JqZWN0UgRkYXRh');

@$core.Deprecated('Use orgUnitGetRequestDescriptor instead')
const OrgUnitGetRequest$json = {
  '1': 'OrgUnitGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `OrgUnitGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orgUnitGetRequestDescriptor = $convert.base64Decode(
    'ChFPcmdVbml0R2V0UmVxdWVzdBIrCgJpZBgBIAEoCUIbukgYchYQAxgoMhBbMC05YS16Xy1dez'
    'MsNDB9UgJpZA==');

@$core.Deprecated('Use orgUnitGetResponseDescriptor instead')
const OrgUnitGetResponse$json = {
  '1': 'OrgUnitGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.OrgUnitObject', '10': 'data'},
  ],
};

/// Descriptor for `OrgUnitGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orgUnitGetResponseDescriptor = $convert.base64Decode(
    'ChJPcmdVbml0R2V0UmVzcG9uc2USLgoEZGF0YRgBIAEoCzIaLmlkZW50aXR5LnYxLk9yZ1VuaX'
    'RPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use orgUnitSearchRequestDescriptor instead')
const OrgUnitSearchRequest$json = {
  '1': 'OrgUnitSearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'organization_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'organizationId'},
    {'1': 'parent_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'parentId'},
    {'1': 'root_only', '3': 4, '4': 1, '5': 8, '10': 'rootOnly'},
    {'1': 'type', '3': 5, '4': 1, '5': 14, '6': '.identity.v1.OrgUnitType', '10': 'type'},
    {'1': 'cursor', '3': 6, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `OrgUnitSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orgUnitSearchRequestDescriptor = $convert.base64Decode(
    'ChRPcmdVbml0U2VhcmNoUmVxdWVzdBIUCgVxdWVyeRgBIAEoCVIFcXVlcnkSNQoPb3JnYW5pem'
    'F0aW9uX2lkGAIgASgJQgy6SAnYAQFyBBADGChSDm9yZ2FuaXphdGlvbklkEikKCXBhcmVudF9p'
    'ZBgDIAEoCUIMukgJ2AEBcgQQAxgoUghwYXJlbnRJZBIbCglyb290X29ubHkYBCABKAhSCHJvb3'
    'RPbmx5EiwKBHR5cGUYBSABKA4yGC5pZGVudGl0eS52MS5PcmdVbml0VHlwZVIEdHlwZRItCgZj'
    'dXJzb3IYBiABKAsyFS5jb21tb24udjEuUGFnZUN1cnNvclIGY3Vyc29y');

@$core.Deprecated('Use orgUnitSearchResponseDescriptor instead')
const OrgUnitSearchResponse$json = {
  '1': 'OrgUnitSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.identity.v1.OrgUnitObject', '10': 'data'},
  ],
};

/// Descriptor for `OrgUnitSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orgUnitSearchResponseDescriptor = $convert.base64Decode(
    'ChVPcmdVbml0U2VhcmNoUmVzcG9uc2USLgoEZGF0YRgBIAMoCzIaLmlkZW50aXR5LnYxLk9yZ1'
    'VuaXRPYmplY3RSBGRhdGE=');

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

@$core.Deprecated('Use clientDataEntryObjectDescriptor instead')
const ClientDataEntryObject$json = {
  '1': 'ClientDataEntryObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'client_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'clientId'},
    {'1': 'field_key', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'fieldKey'},
    {'1': 'value', '3': 4, '4': 1, '5': 9, '10': 'value'},
    {'1': 'value_type', '3': 5, '4': 1, '5': 9, '10': 'valueType'},
    {'1': 'verification_status', '3': 6, '4': 1, '5': 14, '6': '.identity.v1.DataVerificationStatus', '10': 'verificationStatus'},
    {'1': 'reviewer_id', '3': 7, '4': 1, '5': 9, '8': {}, '10': 'reviewerId'},
    {'1': 'reviewer_comment', '3': 8, '4': 1, '5': 9, '10': 'reviewerComment'},
    {'1': 'source_application_id', '3': 9, '4': 1, '5': 9, '8': {}, '10': 'sourceApplicationId'},
    {'1': 'revision', '3': 10, '4': 1, '5': 5, '10': 'revision'},
    {'1': 'verified_at', '3': 11, '4': 1, '5': 9, '10': 'verifiedAt'},
    {'1': 'expires_at', '3': 12, '4': 1, '5': 9, '10': 'expiresAt'},
    {'1': 'properties', '3': 13, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `ClientDataEntryObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDataEntryObjectDescriptor = $convert.base64Decode(
    'ChVDbGllbnREYXRhRW50cnlPYmplY3QSLgoCaWQYASABKAlCHrpIG9gBAXIWEAMYKDIQWzAtOW'
    'Etel8tXXszLDQwfVICaWQSJgoJY2xpZW50X2lkGAIgASgJQgm6SAZyBBADGChSCGNsaWVudElk'
    'EiQKCWZpZWxkX2tleRgDIAEoCUIHukgEcgIQAVIIZmllbGRLZXkSFAoFdmFsdWUYBCABKAlSBX'
    'ZhbHVlEh0KCnZhbHVlX3R5cGUYBSABKAlSCXZhbHVlVHlwZRJUChN2ZXJpZmljYXRpb25fc3Rh'
    'dHVzGAYgASgOMiMuaWRlbnRpdHkudjEuRGF0YVZlcmlmaWNhdGlvblN0YXR1c1ISdmVyaWZpY2'
    'F0aW9uU3RhdHVzEisKC3Jldmlld2VyX2lkGAcgASgJQgq6SAfYAQFyAhgoUgpyZXZpZXdlcklk'
    'EikKEHJldmlld2VyX2NvbW1lbnQYCCABKAlSD3Jldmlld2VyQ29tbWVudBI+ChVzb3VyY2VfYX'
    'BwbGljYXRpb25faWQYCSABKAlCCrpIB9gBAXICGChSE3NvdXJjZUFwcGxpY2F0aW9uSWQSGgoI'
    'cmV2aXNpb24YCiABKAVSCHJldmlzaW9uEh8KC3ZlcmlmaWVkX2F0GAsgASgJUgp2ZXJpZmllZE'
    'F0Eh0KCmV4cGlyZXNfYXQYDCABKAlSCWV4cGlyZXNBdBI3Cgpwcm9wZXJ0aWVzGA0gASgLMhcu'
    'Z29vZ2xlLnByb3RvYnVmLlN0cnVjdFIKcHJvcGVydGllcw==');

@$core.Deprecated('Use clientDataEntryHistoryObjectDescriptor instead')
const ClientDataEntryHistoryObject$json = {
  '1': 'ClientDataEntryHistoryObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'entry_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'entryId'},
    {'1': 'revision', '3': 3, '4': 1, '5': 5, '10': 'revision'},
    {'1': 'value', '3': 4, '4': 1, '5': 9, '10': 'value'},
    {'1': 'action', '3': 5, '4': 1, '5': 9, '10': 'action'},
    {'1': 'actor_id', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'actorId'},
    {'1': 'comment', '3': 7, '4': 1, '5': 9, '10': 'comment'},
    {'1': 'created_at', '3': 8, '4': 1, '5': 9, '10': 'createdAt'},
  ],
};

/// Descriptor for `ClientDataEntryHistoryObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDataEntryHistoryObjectDescriptor = $convert.base64Decode(
    'ChxDbGllbnREYXRhRW50cnlIaXN0b3J5T2JqZWN0Ei4KAmlkGAEgASgJQh66SBvYAQFyFhADGC'
    'gyEFswLTlhLXpfLV17Myw0MH1SAmlkEiQKCGVudHJ5X2lkGAIgASgJQgm6SAZyBBADGChSB2Vu'
    'dHJ5SWQSGgoIcmV2aXNpb24YAyABKAVSCHJldmlzaW9uEhQKBXZhbHVlGAQgASgJUgV2YWx1ZR'
    'IWCgZhY3Rpb24YBSABKAlSBmFjdGlvbhIlCghhY3Rvcl9pZBgGIAEoCUIKukgH2AEBcgIYKFIH'
    'YWN0b3JJZBIYCgdjb21tZW50GAcgASgJUgdjb21tZW50Eh0KCmNyZWF0ZWRfYXQYCCABKAlSCW'
    'NyZWF0ZWRBdA==');

@$core.Deprecated('Use clientDataSaveRequestDescriptor instead')
const ClientDataSaveRequest$json = {
  '1': 'ClientDataSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.ClientDataEntryObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `ClientDataSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDataSaveRequestDescriptor = $convert.base64Decode(
    'ChVDbGllbnREYXRhU2F2ZVJlcXVlc3QSPgoEZGF0YRgBIAEoCzIiLmlkZW50aXR5LnYxLkNsaW'
    'VudERhdGFFbnRyeU9iamVjdEIGukgDyAEBUgRkYXRh');

@$core.Deprecated('Use clientDataSaveResponseDescriptor instead')
const ClientDataSaveResponse$json = {
  '1': 'ClientDataSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.ClientDataEntryObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientDataSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDataSaveResponseDescriptor = $convert.base64Decode(
    'ChZDbGllbnREYXRhU2F2ZVJlc3BvbnNlEjYKBGRhdGEYASABKAsyIi5pZGVudGl0eS52MS5DbG'
    'llbnREYXRhRW50cnlPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use clientDataGetRequestDescriptor instead')
const ClientDataGetRequest$json = {
  '1': 'ClientDataGetRequest',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'clientId'},
    {'1': 'field_key', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'fieldKey'},
  ],
};

/// Descriptor for `ClientDataGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDataGetRequestDescriptor = $convert.base64Decode(
    'ChRDbGllbnREYXRhR2V0UmVxdWVzdBImCgljbGllbnRfaWQYASABKAlCCbpIBnIEEAMYKFIIY2'
    'xpZW50SWQSJAoJZmllbGRfa2V5GAIgASgJQge6SARyAhABUghmaWVsZEtleQ==');

@$core.Deprecated('Use clientDataGetResponseDescriptor instead')
const ClientDataGetResponse$json = {
  '1': 'ClientDataGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.ClientDataEntryObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientDataGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDataGetResponseDescriptor = $convert.base64Decode(
    'ChVDbGllbnREYXRhR2V0UmVzcG9uc2USNgoEZGF0YRgBIAEoCzIiLmlkZW50aXR5LnYxLkNsaW'
    'VudERhdGFFbnRyeU9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use clientDataListRequestDescriptor instead')
const ClientDataListRequest$json = {
  '1': 'ClientDataListRequest',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'clientId'},
    {'1': 'verification_status', '3': 2, '4': 1, '5': 14, '6': '.identity.v1.DataVerificationStatus', '10': 'verificationStatus'},
    {'1': 'cursor', '3': 3, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `ClientDataListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDataListRequestDescriptor = $convert.base64Decode(
    'ChVDbGllbnREYXRhTGlzdFJlcXVlc3QSJgoJY2xpZW50X2lkGAEgASgJQgm6SAZyBBADGChSCG'
    'NsaWVudElkElQKE3ZlcmlmaWNhdGlvbl9zdGF0dXMYAiABKA4yIy5pZGVudGl0eS52MS5EYXRh'
    'VmVyaWZpY2F0aW9uU3RhdHVzUhJ2ZXJpZmljYXRpb25TdGF0dXMSLQoGY3Vyc29yGAMgASgLMh'
    'UuY29tbW9uLnYxLlBhZ2VDdXJzb3JSBmN1cnNvcg==');

@$core.Deprecated('Use clientDataListResponseDescriptor instead')
const ClientDataListResponse$json = {
  '1': 'ClientDataListResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.identity.v1.ClientDataEntryObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientDataListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDataListResponseDescriptor = $convert.base64Decode(
    'ChZDbGllbnREYXRhTGlzdFJlc3BvbnNlEjYKBGRhdGEYASADKAsyIi5pZGVudGl0eS52MS5DbG'
    'llbnREYXRhRW50cnlPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use clientDataVerifyRequestDescriptor instead')
const ClientDataVerifyRequest$json = {
  '1': 'ClientDataVerifyRequest',
  '2': [
    {'1': 'entry_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'entryId'},
    {'1': 'reviewer_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'reviewerId'},
    {'1': 'comment', '3': 3, '4': 1, '5': 9, '10': 'comment'},
  ],
};

/// Descriptor for `ClientDataVerifyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDataVerifyRequestDescriptor = $convert.base64Decode(
    'ChdDbGllbnREYXRhVmVyaWZ5UmVxdWVzdBIkCghlbnRyeV9pZBgBIAEoCUIJukgGcgQQAxgoUg'
    'dlbnRyeUlkEioKC3Jldmlld2VyX2lkGAIgASgJQgm6SAZyBBADGChSCnJldmlld2VySWQSGAoH'
    'Y29tbWVudBgDIAEoCVIHY29tbWVudA==');

@$core.Deprecated('Use clientDataVerifyResponseDescriptor instead')
const ClientDataVerifyResponse$json = {
  '1': 'ClientDataVerifyResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.ClientDataEntryObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientDataVerifyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDataVerifyResponseDescriptor = $convert.base64Decode(
    'ChhDbGllbnREYXRhVmVyaWZ5UmVzcG9uc2USNgoEZGF0YRgBIAEoCzIiLmlkZW50aXR5LnYxLk'
    'NsaWVudERhdGFFbnRyeU9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use clientDataRejectRequestDescriptor instead')
const ClientDataRejectRequest$json = {
  '1': 'ClientDataRejectRequest',
  '2': [
    {'1': 'entry_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'entryId'},
    {'1': 'reviewer_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'reviewerId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'reason'},
  ],
};

/// Descriptor for `ClientDataRejectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDataRejectRequestDescriptor = $convert.base64Decode(
    'ChdDbGllbnREYXRhUmVqZWN0UmVxdWVzdBIkCghlbnRyeV9pZBgBIAEoCUIJukgGcgQQAxgoUg'
    'dlbnRyeUlkEioKC3Jldmlld2VyX2lkGAIgASgJQgm6SAZyBBADGChSCnJldmlld2VySWQSHwoG'
    'cmVhc29uGAMgASgJQge6SARyAhABUgZyZWFzb24=');

@$core.Deprecated('Use clientDataRejectResponseDescriptor instead')
const ClientDataRejectResponse$json = {
  '1': 'ClientDataRejectResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.ClientDataEntryObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientDataRejectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDataRejectResponseDescriptor = $convert.base64Decode(
    'ChhDbGllbnREYXRhUmVqZWN0UmVzcG9uc2USNgoEZGF0YRgBIAEoCzIiLmlkZW50aXR5LnYxLk'
    'NsaWVudERhdGFFbnRyeU9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use clientDataRequestInfoRequestDescriptor instead')
const ClientDataRequestInfoRequest$json = {
  '1': 'ClientDataRequestInfoRequest',
  '2': [
    {'1': 'entry_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'entryId'},
    {'1': 'reviewer_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'reviewerId'},
    {'1': 'comment', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'comment'},
  ],
};

/// Descriptor for `ClientDataRequestInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDataRequestInfoRequestDescriptor = $convert.base64Decode(
    'ChxDbGllbnREYXRhUmVxdWVzdEluZm9SZXF1ZXN0EiQKCGVudHJ5X2lkGAEgASgJQgm6SAZyBB'
    'ADGChSB2VudHJ5SWQSKgoLcmV2aWV3ZXJfaWQYAiABKAlCCbpIBnIEEAMYKFIKcmV2aWV3ZXJJ'
    'ZBIhCgdjb21tZW50GAMgASgJQge6SARyAhABUgdjb21tZW50');

@$core.Deprecated('Use clientDataRequestInfoResponseDescriptor instead')
const ClientDataRequestInfoResponse$json = {
  '1': 'ClientDataRequestInfoResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.identity.v1.ClientDataEntryObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientDataRequestInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDataRequestInfoResponseDescriptor = $convert.base64Decode(
    'Ch1DbGllbnREYXRhUmVxdWVzdEluZm9SZXNwb25zZRI2CgRkYXRhGAEgASgLMiIuaWRlbnRpdH'
    'kudjEuQ2xpZW50RGF0YUVudHJ5T2JqZWN0UgRkYXRh');

@$core.Deprecated('Use clientDataHistoryRequestDescriptor instead')
const ClientDataHistoryRequest$json = {
  '1': 'ClientDataHistoryRequest',
  '2': [
    {'1': 'entry_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'entryId'},
  ],
};

/// Descriptor for `ClientDataHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDataHistoryRequestDescriptor = $convert.base64Decode(
    'ChhDbGllbnREYXRhSGlzdG9yeVJlcXVlc3QSJAoIZW50cnlfaWQYASABKAlCCbpIBnIEEAMYKF'
    'IHZW50cnlJZA==');

@$core.Deprecated('Use clientDataHistoryResponseDescriptor instead')
const ClientDataHistoryResponse$json = {
  '1': 'ClientDataHistoryResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.identity.v1.ClientDataEntryHistoryObject', '10': 'data'},
  ],
};

/// Descriptor for `ClientDataHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDataHistoryResponseDescriptor = $convert.base64Decode(
    'ChlDbGllbnREYXRhSGlzdG9yeVJlc3BvbnNlEj0KBGRhdGEYASADKAsyKS5pZGVudGl0eS52MS'
    '5DbGllbnREYXRhRW50cnlIaXN0b3J5T2JqZWN0UgRkYXRh');

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
    {'1': 'OrgUnitSave', '2': '.identity.v1.OrgUnitSaveRequest', '3': '.identity.v1.OrgUnitSaveResponse', '4': {}},
    {
      '1': 'OrgUnitGet',
      '2': '.identity.v1.OrgUnitGetRequest',
      '3': '.identity.v1.OrgUnitGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'OrgUnitSearch',
      '2': '.identity.v1.OrgUnitSearchRequest',
      '3': '.identity.v1.OrgUnitSearchResponse',
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
    {'1': 'ClientDataSave', '2': '.identity.v1.ClientDataSaveRequest', '3': '.identity.v1.ClientDataSaveResponse', '4': {}},
    {
      '1': 'ClientDataGet',
      '2': '.identity.v1.ClientDataGetRequest',
      '3': '.identity.v1.ClientDataGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'ClientDataList',
      '2': '.identity.v1.ClientDataListRequest',
      '3': '.identity.v1.ClientDataListResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'ClientDataVerify', '2': '.identity.v1.ClientDataVerifyRequest', '3': '.identity.v1.ClientDataVerifyResponse', '4': {}},
    {'1': 'ClientDataReject', '2': '.identity.v1.ClientDataRejectRequest', '3': '.identity.v1.ClientDataRejectResponse', '4': {}},
    {'1': 'ClientDataRequestInfo', '2': '.identity.v1.ClientDataRequestInfoRequest', '3': '.identity.v1.ClientDataRequestInfoResponse', '4': {}},
    {
      '1': 'ClientDataHistory',
      '2': '.identity.v1.ClientDataHistoryRequest',
      '3': '.identity.v1.ClientDataHistoryResponse',
      '4': {'34': 1},
    },
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
  '.identity.v1.OrgUnitSaveRequest': OrgUnitSaveRequest$json,
  '.identity.v1.OrgUnitObject': OrgUnitObject$json,
  '.identity.v1.OrgUnitSaveResponse': OrgUnitSaveResponse$json,
  '.identity.v1.OrgUnitGetRequest': OrgUnitGetRequest$json,
  '.identity.v1.OrgUnitGetResponse': OrgUnitGetResponse$json,
  '.identity.v1.OrgUnitSearchRequest': OrgUnitSearchRequest$json,
  '.identity.v1.OrgUnitSearchResponse': OrgUnitSearchResponse$json,
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
  '.google.type.Money': $8.Money$json,
  '.identity.v1.InvestorAccountSaveResponse': InvestorAccountSaveResponse$json,
  '.identity.v1.InvestorAccountGetRequest': InvestorAccountGetRequest$json,
  '.identity.v1.InvestorAccountGetResponse': InvestorAccountGetResponse$json,
  '.identity.v1.InvestorAccountSearchRequest': InvestorAccountSearchRequest$json,
  '.identity.v1.InvestorAccountSearchResponse': InvestorAccountSearchResponse$json,
  '.identity.v1.InvestorDepositRequest': InvestorDepositRequest$json,
  '.identity.v1.InvestorDepositResponse': InvestorDepositResponse$json,
  '.identity.v1.InvestorWithdrawRequest': InvestorWithdrawRequest$json,
  '.identity.v1.InvestorWithdrawResponse': InvestorWithdrawResponse$json,
  '.identity.v1.ClientDataSaveRequest': ClientDataSaveRequest$json,
  '.identity.v1.ClientDataEntryObject': ClientDataEntryObject$json,
  '.identity.v1.ClientDataSaveResponse': ClientDataSaveResponse$json,
  '.identity.v1.ClientDataGetRequest': ClientDataGetRequest$json,
  '.identity.v1.ClientDataGetResponse': ClientDataGetResponse$json,
  '.identity.v1.ClientDataListRequest': ClientDataListRequest$json,
  '.identity.v1.ClientDataListResponse': ClientDataListResponse$json,
  '.identity.v1.ClientDataVerifyRequest': ClientDataVerifyRequest$json,
  '.identity.v1.ClientDataVerifyResponse': ClientDataVerifyResponse$json,
  '.identity.v1.ClientDataRejectRequest': ClientDataRejectRequest$json,
  '.identity.v1.ClientDataRejectResponse': ClientDataRejectResponse$json,
  '.identity.v1.ClientDataRequestInfoRequest': ClientDataRequestInfoRequest$json,
  '.identity.v1.ClientDataRequestInfoResponse': ClientDataRequestInfoResponse$json,
  '.identity.v1.ClientDataHistoryRequest': ClientDataHistoryRequest$json,
  '.identity.v1.ClientDataHistoryResponse': ClientDataHistoryResponse$json,
  '.identity.v1.ClientDataEntryHistoryObject': ClientDataEntryHistoryObject$json,
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
    '9yZ2FuaXphdGlvblNlYXJjaIK1GBMKEW9yZ2FuaXphdGlvbl92aWV3MAESlQIKC09yZ1VuaXRT'
    'YXZlEh8uaWRlbnRpdHkudjEuT3JnVW5pdFNhdmVSZXF1ZXN0GiAuaWRlbnRpdHkudjEuT3JnVW'
    '5pdFNhdmVSZXNwb25zZSLCAbpHqwEKCU9yZyBVbml0cxIcQ3JlYXRlIG9yIHVwZGF0ZSBhbiBv'
    'cmcgdW5pdBpzQ3JlYXRlcyBhIG5ldyBvcmcgdW5pdCBvciB1cGRhdGVzIGFuIGV4aXN0aW5nIG'
    '9uZS4gT3JnIHVuaXRzIGFyZSB0eXBlZCBoaWVyYXJjaGljYWwgc3ViLWRpdmlzaW9ucyBvZiBv'
    'cmdhbml6YXRpb25zLioLb3JnVW5pdFNhdmWCtRgPCg1icmFuY2hfbWFuYWdlEswBCgpPcmdVbm'
    'l0R2V0Eh4uaWRlbnRpdHkudjEuT3JnVW5pdEdldFJlcXVlc3QaHy5pZGVudGl0eS52MS5PcmdV'
    'bml0R2V0UmVzcG9uc2UifZACAbpHZgoJT3JnIFVuaXRzEhVHZXQgYW4gb3JnIHVuaXQgYnkgSU'
    'QaNlJldHJpZXZlcyBhbiBvcmcgdW5pdCByZWNvcmQgYnkgaXRzIHVuaXF1ZSBpZGVudGlmaWVy'
    'LioKb3JnVW5pdEdldIK1GA0KC2JyYW5jaF92aWV3EpsCCg1PcmdVbml0U2VhcmNoEiEuaWRlbn'
    'RpdHkudjEuT3JnVW5pdFNlYXJjaFJlcXVlc3QaIi5pZGVudGl0eS52MS5PcmdVbml0U2VhcmNo'
    'UmVzcG9uc2UiwAGQAgG6R6gBCglPcmcgVW5pdHMSEFNlYXJjaCBvcmcgdW5pdHMaelNlYXJjaG'
    'VzIGZvciBvcmcgdW5pdHMgbWF0Y2hpbmcgc3BlY2lmaWVkIGNyaXRlcmlhLiBTdXBwb3J0cyBm'
    'aWx0ZXJpbmcgYnkgb3JnYW5pemF0aW9uLCBwYXJlbnQgdW5pdCwgcm9vdCB1bml0cywgYW5kIH'
    'R5cGUuKg1vcmdVbml0U2VhcmNogrUYDQoLYnJhbmNoX3ZpZXcwARKTAgoKQnJhbmNoU2F2ZRIe'
    'LmlkZW50aXR5LnYxLkJyYW5jaFNhdmVSZXF1ZXN0Gh8uaWRlbnRpdHkudjEuQnJhbmNoU2F2ZV'
    'Jlc3BvbnNlIsMBukesAQoIQnJhbmNoZXMSGUNyZWF0ZSBvciB1cGRhdGUgYSBicmFuY2gaeUNy'
    'ZWF0ZXMgYSBuZXcgYnJhbmNoIG9yIHVwZGF0ZXMgYW4gZXhpc3Rpbmcgb25lLiBCcmFuY2hlcy'
    'ByZXByZXNlbnQgc3ViLWRpdmlzaW9ucyBvZiBvcmdhbml6YXRpb25zIHdpdGggZ2VvZ3JhcGhp'
    'YyBhcmVhcy4qCmJyYW5jaFNhdmWCtRgPCg1icmFuY2hfbWFuYWdlEsEBCglCcmFuY2hHZXQSHS'
    '5pZGVudGl0eS52MS5CcmFuY2hHZXRSZXF1ZXN0Gh4uaWRlbnRpdHkudjEuQnJhbmNoR2V0UmVz'
    'cG9uc2UidZACAbpHXgoIQnJhbmNoZXMSEkdldCBhIGJyYW5jaCBieSBJRBozUmV0cmlldmVzIG'
    'EgYnJhbmNoIHJlY29yZCBieSBpdHMgdW5pcXVlIGlkZW50aWZpZXIuKglicmFuY2hHZXSCtRgN'
    'CgticmFuY2hfdmlldxKiAgoMQnJhbmNoU2VhcmNoEiAuaWRlbnRpdHkudjEuQnJhbmNoU2Vhcm'
    'NoUmVxdWVzdBohLmlkZW50aXR5LnYxLkJyYW5jaFNlYXJjaFJlc3BvbnNlIsoBkAIBukeyAQoI'
    'QnJhbmNoZXMSD1NlYXJjaCBicmFuY2hlcxqGAVNlYXJjaGVzIGZvciBicmFuY2hlcyBtYXRjaG'
    'luZyBzcGVjaWZpZWQgY3JpdGVyaWEuIFN1cHBvcnRzIGZpbHRlcmluZyBieSBvcmdhbml6YXRp'
    'b24gSUQuIFJldHVybnMgYSBzdHJlYW0gb2YgbWF0Y2hpbmcgYnJhbmNoIHJlY29yZHMuKgxicm'
    'FuY2hTZWFyY2iCtRgNCgticmFuY2hfdmlldzABEpICCgxJbnZlc3RvclNhdmUSIC5pZGVudGl0'
    'eS52MS5JbnZlc3RvclNhdmVSZXF1ZXN0GiEuaWRlbnRpdHkudjEuSW52ZXN0b3JTYXZlUmVzcG'
    '9uc2UivAG6R6MBCglJbnZlc3RvcnMSHENyZWF0ZSBvciB1cGRhdGUgYW4gaW52ZXN0b3IaakNy'
    'ZWF0ZXMgYSBuZXcgaW52ZXN0b3Igb3IgdXBkYXRlcyBhbiBleGlzdGluZyBvbmUuIEludmVzdG'
    '9ycyBhcmUgaW5kZXBlbmRlbnQgZW50aXRpZXMgbGlua2VkIHRvIGEgcHJvZmlsZS4qDGludmVz'
    'dG9yU2F2ZYK1GBEKD2ludmVzdG9yX21hbmFnZRLVAQoLSW52ZXN0b3JHZXQSHy5pZGVudGl0eS'
    '52MS5JbnZlc3RvckdldFJlcXVlc3QaIC5pZGVudGl0eS52MS5JbnZlc3RvckdldFJlc3BvbnNl'
    'IoIBkAIBukdpCglJbnZlc3RvcnMSFUdldCBhbiBpbnZlc3RvciBieSBJRBo4UmV0cmlldmVzIG'
    'FuIGludmVzdG9yIHJlY29yZCBieSB0aGVpciB1bmlxdWUgaWRlbnRpZmllci4qC2ludmVzdG9y'
    'R2V0grUYDwoNaW52ZXN0b3JfdmlldxKJAgoOSW52ZXN0b3JTZWFyY2gSIi5pZGVudGl0eS52MS'
    '5JbnZlc3RvclNlYXJjaFJlcXVlc3QaIy5pZGVudGl0eS52MS5JbnZlc3RvclNlYXJjaFJlc3Bv'
    'bnNlIqsBkAIBukeRAQoJSW52ZXN0b3JzEhBTZWFyY2ggaW52ZXN0b3JzGmJTZWFyY2hlcyBmb3'
    'IgaW52ZXN0b3JzIG1hdGNoaW5nIHNwZWNpZmllZCBjcml0ZXJpYS4gUmV0dXJucyBhIHN0cmVh'
    'bSBvZiBtYXRjaGluZyBpbnZlc3RvciByZWNvcmRzLioOaW52ZXN0b3JTZWFyY2iCtRgPCg1pbn'
    'Zlc3Rvcl92aWV3MAES1AIKDlN5c3RlbVVzZXJTYXZlEiIuaWRlbnRpdHkudjEuU3lzdGVtVXNl'
    'clNhdmVSZXF1ZXN0GiMuaWRlbnRpdHkudjEuU3lzdGVtVXNlclNhdmVSZXNwb25zZSL4AbpH3A'
    'EKC1N5c3RlbVVzZXJzEh5DcmVhdGUgb3IgdXBkYXRlIGEgc3lzdGVtIHVzZXIanAFDcmVhdGVz'
    'IGEgbmV3IHN5c3RlbSB1c2VyIG9yIHVwZGF0ZXMgYW4gZXhpc3Rpbmcgb25lLiBTeXN0ZW0gdX'
    'NlcnMgYXJlIGFzc2lnbmVkIHJvbGVzICh2ZXJpZmllciwgYXBwcm92ZXIsIGFkbWluaXN0cmF0'
    'b3IsIGF1ZGl0b3IpIGZvciBwcm9jZXNzaW5nIHdvcmtmbG93cy4qDnN5c3RlbVVzZXJTYXZlgr'
    'UYFAoSc3lzdGVtX3VzZXJfbWFuYWdlEuYBCg1TeXN0ZW1Vc2VyR2V0EiEuaWRlbnRpdHkudjEu'
    'U3lzdGVtVXNlckdldFJlcXVlc3QaIi5pZGVudGl0eS52MS5TeXN0ZW1Vc2VyR2V0UmVzcG9uc2'
    'UijQGQAgG6R3EKC1N5c3RlbVVzZXJzEhdHZXQgYSBzeXN0ZW0gdXNlciBieSBJRBo6UmV0cmll'
    'dmVzIGEgc3lzdGVtIHVzZXIgcmVjb3JkIGJ5IHRoZWlyIHVuaXF1ZSBpZGVudGlmaWVyLioNc3'
    'lzdGVtVXNlckdldIK1GBIKEHN5c3RlbV91c2VyX3ZpZXcSxwIKEFN5c3RlbVVzZXJTZWFyY2gS'
    'JC5pZGVudGl0eS52MS5TeXN0ZW1Vc2VyU2VhcmNoUmVxdWVzdBolLmlkZW50aXR5LnYxLlN5c3'
    'RlbVVzZXJTZWFyY2hSZXNwb25zZSLjAZACAbpHxgEKC1N5c3RlbVVzZXJzEhNTZWFyY2ggc3lz'
    'dGVtIHVzZXJzGo8BU2VhcmNoZXMgZm9yIHN5c3RlbSB1c2VycyBtYXRjaGluZyBzcGVjaWZpZW'
    'QgY3JpdGVyaWEuIFN1cHBvcnRzIGZpbHRlcmluZyBieSByb2xlIGFuZCBicmFuY2guIFJldHVy'
    'bnMgYSBzdHJlYW0gb2YgbWF0Y2hpbmcgc3lzdGVtIHVzZXIgcmVjb3Jkcy4qEHN5c3RlbVVzZX'
    'JTZWFyY2iCtRgSChBzeXN0ZW1fdXNlcl92aWV3MAES0AIKD0NsaWVudEdyb3VwU2F2ZRIjLmlk'
    'ZW50aXR5LnYxLkNsaWVudEdyb3VwU2F2ZVJlcXVlc3QaJC5pZGVudGl0eS52MS5DbGllbnRHcm'
    '91cFNhdmVSZXNwb25zZSLxAbpH1AEKDENsaWVudEdyb3VwcxIfQ3JlYXRlIG9yIHVwZGF0ZSBh'
    'IGNsaWVudCBncm91cBqRAUNyZWF0ZXMgYSBuZXcgY2xpZW50IGdyb3VwIG9yIHVwZGF0ZXMgYW'
    '4gZXhpc3Rpbmcgb25lLiBDbGllbnQgZ3JvdXBzIHJlcHJlc2VudCBjb2xsZWN0aXZlIGVudGl0'
    'aWVzIHN1Y2ggYXMgU0FDQ08gZ3JvdXBzIGluIHRoZSBsZW5kaW5nIGhpZXJhcmNoeS4qD2NsaW'
    'VudEdyb3VwU2F2ZYK1GBUKE2NsaWVudF9ncm91cF9tYW5hZ2US7AEKDkNsaWVudEdyb3VwR2V0'
    'EiIuaWRlbnRpdHkudjEuQ2xpZW50R3JvdXBHZXRSZXF1ZXN0GiMuaWRlbnRpdHkudjEuQ2xpZW'
    '50R3JvdXBHZXRSZXNwb25zZSKQAZACAbpHcwoMQ2xpZW50R3JvdXBzEhhHZXQgYSBjbGllbnQg'
    'Z3JvdXAgYnkgSUQaOVJldHJpZXZlcyBhIGNsaWVudCBncm91cCByZWNvcmQgYnkgaXRzIHVuaX'
    'F1ZSBpZGVudGlmaWVyLioOY2xpZW50R3JvdXBHZXSCtRgTChFjbGllbnRfZ3JvdXBfdmlldxLR'
    'AgoRQ2xpZW50R3JvdXBTZWFyY2gSJS5pZGVudGl0eS52MS5DbGllbnRHcm91cFNlYXJjaFJlcX'
    'Vlc3QaJi5pZGVudGl0eS52MS5DbGllbnRHcm91cFNlYXJjaFJlc3BvbnNlIuoBkAIBukfMAQoM'
    'Q2xpZW50R3JvdXBzEhRTZWFyY2ggY2xpZW50IGdyb3VwcxqSAVNlYXJjaGVzIGZvciBjbGllbn'
    'QgZ3JvdXBzIG1hdGNoaW5nIHNwZWNpZmllZCBjcml0ZXJpYS4gU3VwcG9ydHMgZmlsdGVyaW5n'
    'IGJ5IGFnZW50IGFuZCBicmFuY2guIFJldHVybnMgYSBzdHJlYW0gb2YgbWF0Y2hpbmcgY2xpZW'
    '50IGdyb3VwIHJlY29yZHMuKhFjbGllbnRHcm91cFNlYXJjaIK1GBMKEWNsaWVudF9ncm91cF92'
    'aWV3MAESqAIKDk1lbWJlcnNoaXBTYXZlEiIuaWRlbnRpdHkudjEuTWVtYmVyc2hpcFNhdmVSZX'
    'F1ZXN0GiMuaWRlbnRpdHkudjEuTWVtYmVyc2hpcFNhdmVSZXNwb25zZSLMAbpHsQEKC01lbWJl'
    'cnNoaXBzEh1DcmVhdGUgb3IgdXBkYXRlIGEgbWVtYmVyc2hpcBpzQ3JlYXRlcyBhIG5ldyBtZW'
    '1iZXJzaGlwIG9yIHVwZGF0ZXMgYW4gZXhpc3Rpbmcgb25lLiBNZW1iZXJzaGlwcyB0cmFjayBh'
    'IHByb2ZpbGUncyBhZmZpbGlhdGlvbiB3aXRoIGEgY2xpZW50IGdyb3VwLioObWVtYmVyc2hpcF'
    'NhdmWCtRgTChFtZW1iZXJzaGlwX21hbmFnZRLhAQoNTWVtYmVyc2hpcEdldBIhLmlkZW50aXR5'
    'LnYxLk1lbWJlcnNoaXBHZXRSZXF1ZXN0GiIuaWRlbnRpdHkudjEuTWVtYmVyc2hpcEdldFJlc3'
    'BvbnNlIogBkAIBukdtCgtNZW1iZXJzaGlwcxIWR2V0IGEgbWVtYmVyc2hpcCBieSBJRBo3UmV0'
    'cmlldmVzIGEgbWVtYmVyc2hpcCByZWNvcmQgYnkgaXRzIHVuaXF1ZSBpZGVudGlmaWVyLioNbW'
    'VtYmVyc2hpcEdldIK1GBEKD21lbWJlcnNoaXBfdmlldxLFAgoQTWVtYmVyc2hpcFNlYXJjaBIk'
    'LmlkZW50aXR5LnYxLk1lbWJlcnNoaXBTZWFyY2hSZXF1ZXN0GiUuaWRlbnRpdHkudjEuTWVtYm'
    'Vyc2hpcFNlYXJjaFJlc3BvbnNlIuEBkAIBukfFAQoLTWVtYmVyc2hpcHMSElNlYXJjaCBtZW1i'
    'ZXJzaGlwcxqPAVNlYXJjaGVzIGZvciBtZW1iZXJzaGlwcyBtYXRjaGluZyBzcGVjaWZpZWQgY3'
    'JpdGVyaWEuIFN1cHBvcnRzIGZpbHRlcmluZyBieSBncm91cCBhbmQgcHJvZmlsZS4gUmV0dXJu'
    'cyBhIHN0cmVhbSBvZiBtYXRjaGluZyBtZW1iZXJzaGlwIHJlY29yZHMuKhBtZW1iZXJzaGlwU2'
    'VhcmNogrUYEQoPbWVtYmVyc2hpcF92aWV3MAES6AIKE0ludmVzdG9yQWNjb3VudFNhdmUSJy5p'
    'ZGVudGl0eS52MS5JbnZlc3RvckFjY291bnRTYXZlUmVxdWVzdBooLmlkZW50aXR5LnYxLkludm'
    'VzdG9yQWNjb3VudFNhdmVSZXNwb25zZSL9AbpH3AEKEEludmVzdG9yQWNjb3VudHMSJENyZWF0'
    'ZSBvciB1cGRhdGUgYW4gaW52ZXN0b3IgYWNjb3VudBqMAUNyZWF0ZXMgYSBuZXcgaW52ZXN0b3'
    'IgY2FwaXRhbCBhY2NvdW50IG9yIHVwZGF0ZXMgYW4gZXhpc3Rpbmcgb25lLiBJbnZlc3RvciBh'
    'Y2NvdW50cyB0cmFjayBwcmUtZnVuZGVkIGNhcGl0YWwgYXZhaWxhYmxlIGZvciBsb2FuIGRlcG'
    'xveW1lbnQuKhNpbnZlc3RvckFjY291bnRTYXZlgrUYGQoXaW52ZXN0b3JfYWNjb3VudF9tYW5h'
    'Z2USkAIKEkludmVzdG9yQWNjb3VudEdldBImLmlkZW50aXR5LnYxLkludmVzdG9yQWNjb3VudE'
    'dldFJlcXVlc3QaJy5pZGVudGl0eS52MS5JbnZlc3RvckFjY291bnRHZXRSZXNwb25zZSKoAZAC'
    'AbpHhgEKEEludmVzdG9yQWNjb3VudHMSHUdldCBhbiBpbnZlc3RvciBhY2NvdW50IGJ5IElEGj'
    '9SZXRyaWV2ZXMgYW4gaW52ZXN0b3IgY2FwaXRhbCBhY2NvdW50IGJ5IGl0cyB1bmlxdWUgaWRl'
    'bnRpZmllci4qEmludmVzdG9yQWNjb3VudEdldIK1GBcKFWludmVzdG9yX2FjY291bnRfdmlldx'
    'LKAgoVSW52ZXN0b3JBY2NvdW50U2VhcmNoEikuaWRlbnRpdHkudjEuSW52ZXN0b3JBY2NvdW50'
    'U2VhcmNoUmVxdWVzdBoqLmlkZW50aXR5LnYxLkludmVzdG9yQWNjb3VudFNlYXJjaFJlc3Bvbn'
    'NlItcBkAIBuke1AQoQSW52ZXN0b3JBY2NvdW50cxIYU2VhcmNoIGludmVzdG9yIGFjY291bnRz'
    'GnBTZWFyY2hlcyBmb3IgaW52ZXN0b3IgYWNjb3VudHMgbWF0Y2hpbmcgc3BlY2lmaWVkIGNyaX'
    'RlcmlhLiBTdXBwb3J0cyBmaWx0ZXJpbmcgYnkgaW52ZXN0b3IgSUQgYW5kIGN1cnJlbmN5IGNv'
    'ZGUuKhVpbnZlc3RvckFjY291bnRTZWFyY2iCtRgXChVpbnZlc3Rvcl9hY2NvdW50X3ZpZXcwAR'
    'KnAgoPSW52ZXN0b3JEZXBvc2l0EiMuaWRlbnRpdHkudjEuSW52ZXN0b3JEZXBvc2l0UmVxdWVz'
    'dBokLmlkZW50aXR5LnYxLkludmVzdG9yRGVwb3NpdFJlc3BvbnNlIsgBukenAQoQSW52ZXN0b3'
    'JBY2NvdW50cxImRGVwb3NpdCBmdW5kcyBpbnRvIGFuIGludmVzdG9yIGFjY291bnQaWkFkZHMg'
    'Y2FwaXRhbCB0byBhbiBpbnZlc3RvciBhY2NvdW50LCBpbmNyZWFzaW5nIHRoZSBhdmFpbGFibG'
    'UgYmFsYW5jZSBmb3IgbG9hbiBkZXBsb3ltZW50LioPaW52ZXN0b3JEZXBvc2l0grUYGQoXaW52'
    'ZXN0b3JfYWNjb3VudF9tYW5hZ2USqQIKEEludmVzdG9yV2l0aGRyYXcSJC5pZGVudGl0eS52MS'
    '5JbnZlc3RvcldpdGhkcmF3UmVxdWVzdBolLmlkZW50aXR5LnYxLkludmVzdG9yV2l0aGRyYXdS'
    'ZXNwb25zZSLHAbpHpgEKEEludmVzdG9yQWNjb3VudHMSJ1dpdGhkcmF3IGZ1bmRzIGZyb20gYW'
    '4gaW52ZXN0b3IgYWNjb3VudBpXUmVtb3ZlcyBjYXBpdGFsIGZyb20gYW4gaW52ZXN0b3IgYWNj'
    'b3VudCBpZiBzdWZmaWNpZW50IHVucmVzZXJ2ZWQgYmFsYW5jZSBpcyBhdmFpbGFibGUuKhBpbn'
    'Zlc3RvcldpdGhkcmF3grUYGQoXaW52ZXN0b3JfYWNjb3VudF9tYW5hZ2US0AIKDkNsaWVudERh'
    'dGFTYXZlEiIuaWRlbnRpdHkudjEuQ2xpZW50RGF0YVNhdmVSZXF1ZXN0GiMuaWRlbnRpdHkudj'
    'EuQ2xpZW50RGF0YVNhdmVSZXNwb25zZSL0AbpH2AEKCkNsaWVudERhdGESFFNhdmUgY2xpZW50'
    'IEtZQyBkYXRhGqMBQ3JlYXRlcyBvciB1cGRhdGVzIGEgc2luZ2xlIGNsaWVudCBkYXRhIGVudH'
    'J5LiBJZiBhbiBlbnRyeSBhbHJlYWR5IGV4aXN0cyBmb3IgdGhlIHNhbWUgY2xpZW50X2lkICsg'
    'ZmllbGRfa2V5LCB0aGUgcmV2aXNpb24gaXMgaW5jcmVtZW50ZWQgYW5kIHRoZSB2YWx1ZSBpcy'
    'B1cGRhdGVkLioOY2xpZW50RGF0YVNhdmWCtRgUChJjbGllbnRfZGF0YV9tYW5hZ2US6wEKDUNs'
    'aWVudERhdGFHZXQSIS5pZGVudGl0eS52MS5DbGllbnREYXRhR2V0UmVxdWVzdBoiLmlkZW50aX'
    'R5LnYxLkNsaWVudERhdGFHZXRSZXNwb25zZSKSAZACAbpHdgoKQ2xpZW50RGF0YRIXR2V0IGEg'
    'Y2xpZW50IGRhdGEgZW50cnkaQFJldHJpZXZlcyBhIHNpbmdsZSBjbGllbnQgZGF0YSBlbnRyeS'
    'BieSBjbGllbnQgSUQgYW5kIGZpZWxkIGtleS4qDWNsaWVudERhdGFHZXSCtRgSChBjbGllbnRf'
    'ZGF0YV92aWV3EoMCCg5DbGllbnREYXRhTGlzdBIiLmlkZW50aXR5LnYxLkNsaWVudERhdGFMaX'
    'N0UmVxdWVzdBojLmlkZW50aXR5LnYxLkNsaWVudERhdGFMaXN0UmVzcG9uc2UipQGQAgG6R4gB'
    'CgpDbGllbnREYXRhEhhMaXN0IGNsaWVudCBkYXRhIGVudHJpZXMaUExpc3RzIGFsbCBkYXRhIG'
    'VudHJpZXMgZm9yIGEgY2xpZW50LCBvcHRpb25hbGx5IGZpbHRlcmVkIGJ5IHZlcmlmaWNhdGlv'
    'biBzdGF0dXMuKg5jbGllbnREYXRhTGlzdIK1GBIKEGNsaWVudF9kYXRhX3ZpZXcwARLtAQoQQ2'
    'xpZW50RGF0YVZlcmlmeRIkLmlkZW50aXR5LnYxLkNsaWVudERhdGFWZXJpZnlSZXF1ZXN0GiUu'
    'aWRlbnRpdHkudjEuQ2xpZW50RGF0YVZlcmlmeVJlc3BvbnNlIosBukdwCgpDbGllbnREYXRhEh'
    'pWZXJpZnkgYSBjbGllbnQgZGF0YSBlbnRyeRo0TWFya3MgYSBjbGllbnQgZGF0YSBlbnRyeSBh'
    'cyB2ZXJpZmllZCBieSBhIHJldmlld2VyLioQY2xpZW50RGF0YVZlcmlmeYK1GBQKEmNsaWVudF'
    '9kYXRhX3ZlcmlmeRKFAgoQQ2xpZW50RGF0YVJlamVjdBIkLmlkZW50aXR5LnYxLkNsaWVudERh'
    'dGFSZWplY3RSZXF1ZXN0GiUuaWRlbnRpdHkudjEuQ2xpZW50RGF0YVJlamVjdFJlc3BvbnNlIq'
    'MBukeHAQoKQ2xpZW50RGF0YRIaUmVqZWN0IGEgY2xpZW50IGRhdGEgZW50cnkaS01hcmtzIGEg'
    'Y2xpZW50IGRhdGEgZW50cnkgYXMgcmVqZWN0ZWQgYnkgYSByZXZpZXdlciB3aXRoIGEgcmVxdW'
    'lyZWQgcmVhc29uLioQY2xpZW50RGF0YVJlamVjdIK1GBQKEmNsaWVudF9kYXRhX3ZlcmlmeRKr'
    'AgoVQ2xpZW50RGF0YVJlcXVlc3RJbmZvEikuaWRlbnRpdHkudjEuQ2xpZW50RGF0YVJlcXVlc3'
    'RJbmZvUmVxdWVzdBoqLmlkZW50aXR5LnYxLkNsaWVudERhdGFSZXF1ZXN0SW5mb1Jlc3BvbnNl'
    'IroBukeeAQoKQ2xpZW50RGF0YRIpUmVxdWVzdCBtb3JlIGluZm8gZm9yIGEgY2xpZW50IGRhdG'
    'EgZW50cnkaTk1hcmtzIGEgY2xpZW50IGRhdGEgZW50cnkgYXMgbmVlZGluZyBtb3JlIGluZm9y'
    'bWF0aW9uIHdpdGggYSByZXF1aXJlZCBjb21tZW50LioVY2xpZW50RGF0YVJlcXVlc3RJbmZvgr'
    'UYFAoSY2xpZW50X2RhdGFfdmVyaWZ5Ev8BChFDbGllbnREYXRhSGlzdG9yeRIlLmlkZW50aXR5'
    'LnYxLkNsaWVudERhdGFIaXN0b3J5UmVxdWVzdBomLmlkZW50aXR5LnYxLkNsaWVudERhdGFIaX'
    'N0b3J5UmVzcG9uc2UimgGQAgG6R34KCkNsaWVudERhdGESH0dldCBkYXRhIGVudHJ5IHJldmlz'
    'aW9uIGhpc3RvcnkaPFJldHJpZXZlcyB0aGUgZnVsbCByZXZpc2lvbiBoaXN0b3J5IGZvciBhIG'
    'NsaWVudCBkYXRhIGVudHJ5LioRY2xpZW50RGF0YUhpc3RvcnmCtRgSChBjbGllbnRfZGF0YV92'
    'aWV3GtMOgrUYzg4KEHNlcnZpY2VfaWRlbnRpdHkSEW9yZ2FuaXphdGlvbl92aWV3EhNvcmdhbm'
    'l6YXRpb25fbWFuYWdlEgticmFuY2hfdmlldxINYnJhbmNoX21hbmFnZRINaW52ZXN0b3Jfdmll'
    'dxIPaW52ZXN0b3JfbWFuYWdlEhBzeXN0ZW1fdXNlcl92aWV3EhJzeXN0ZW1fdXNlcl9tYW5hZ2'
    'USEWNsaWVudF9ncm91cF92aWV3EhNjbGllbnRfZ3JvdXBfbWFuYWdlEg9tZW1iZXJzaGlwX3Zp'
    'ZXcSEW1lbWJlcnNoaXBfbWFuYWdlEhVpbnZlc3Rvcl9hY2NvdW50X3ZpZXcSF2ludmVzdG9yX2'
    'FjY291bnRfbWFuYWdlEhBjbGllbnRfZGF0YV92aWV3EhJjbGllbnRfZGF0YV9tYW5hZ2USEmNs'
    'aWVudF9kYXRhX3ZlcmlmeRrCAggBEhFvcmdhbml6YXRpb25fdmlldxITb3JnYW5pemF0aW9uX2'
    '1hbmFnZRILYnJhbmNoX3ZpZXcSDWJyYW5jaF9tYW5hZ2USDWludmVzdG9yX3ZpZXcSD2ludmVz'
    'dG9yX21hbmFnZRIQc3lzdGVtX3VzZXJfdmlldxISc3lzdGVtX3VzZXJfbWFuYWdlEhFjbGllbn'
    'RfZ3JvdXBfdmlldxITY2xpZW50X2dyb3VwX21hbmFnZRIPbWVtYmVyc2hpcF92aWV3EhFtZW1i'
    'ZXJzaGlwX21hbmFnZRIVaW52ZXN0b3JfYWNjb3VudF92aWV3EhdpbnZlc3Rvcl9hY2NvdW50X2'
    '1hbmFnZRIQY2xpZW50X2RhdGFfdmlldxISY2xpZW50X2RhdGFfbWFuYWdlEhJjbGllbnRfZGF0'
    'YV92ZXJpZnkawgIIAhIRb3JnYW5pemF0aW9uX3ZpZXcSE29yZ2FuaXphdGlvbl9tYW5hZ2USC2'
    'JyYW5jaF92aWV3Eg1icmFuY2hfbWFuYWdlEg1pbnZlc3Rvcl92aWV3Eg9pbnZlc3Rvcl9tYW5h'
    'Z2USEHN5c3RlbV91c2VyX3ZpZXcSEnN5c3RlbV91c2VyX21hbmFnZRIRY2xpZW50X2dyb3VwX3'
    'ZpZXcSE2NsaWVudF9ncm91cF9tYW5hZ2USD21lbWJlcnNoaXBfdmlldxIRbWVtYmVyc2hpcF9t'
    'YW5hZ2USFWludmVzdG9yX2FjY291bnRfdmlldxIXaW52ZXN0b3JfYWNjb3VudF9tYW5hZ2USEG'
    'NsaWVudF9kYXRhX3ZpZXcSEmNsaWVudF9kYXRhX21hbmFnZRISY2xpZW50X2RhdGFfdmVyaWZ5'
    'GoQCCAMSEW9yZ2FuaXphdGlvbl92aWV3EhNvcmdhbml6YXRpb25fbWFuYWdlEgticmFuY2hfdm'
    'lldxINYnJhbmNoX21hbmFnZRINaW52ZXN0b3JfdmlldxIVaW52ZXN0b3JfYWNjb3VudF92aWV3'
    'EhBzeXN0ZW1fdXNlcl92aWV3EhFjbGllbnRfZ3JvdXBfdmlldxITY2xpZW50X2dyb3VwX21hbm'
    'FnZRIPbWVtYmVyc2hpcF92aWV3EhFtZW1iZXJzaGlwX21hbmFnZRIQY2xpZW50X2RhdGFfdmll'
    'dxISY2xpZW50X2RhdGFfbWFuYWdlEhJjbGllbnRfZGF0YV92ZXJpZnkakAEIBBIRb3JnYW5pem'
    'F0aW9uX3ZpZXcSC2JyYW5jaF92aWV3Eg1pbnZlc3Rvcl92aWV3EhVpbnZlc3Rvcl9hY2NvdW50'
    'X3ZpZXcSEHN5c3RlbV91c2VyX3ZpZXcSEWNsaWVudF9ncm91cF92aWV3Eg9tZW1iZXJzaGlwX3'
    'ZpZXcSEGNsaWVudF9kYXRhX3ZpZXcakAEIBRIRb3JnYW5pemF0aW9uX3ZpZXcSC2JyYW5jaF92'
    'aWV3Eg1pbnZlc3Rvcl92aWV3EhVpbnZlc3Rvcl9hY2NvdW50X3ZpZXcSEHN5c3RlbV91c2VyX3'
    'ZpZXcSEWNsaWVudF9ncm91cF92aWV3Eg9tZW1iZXJzaGlwX3ZpZXcSEGNsaWVudF9kYXRhX3Zp'
    'ZXcawgIIBhIRb3JnYW5pemF0aW9uX3ZpZXcSE29yZ2FuaXphdGlvbl9tYW5hZ2USC2JyYW5jaF'
    '92aWV3Eg1icmFuY2hfbWFuYWdlEg1pbnZlc3Rvcl92aWV3Eg9pbnZlc3Rvcl9tYW5hZ2USEHN5'
    'c3RlbV91c2VyX3ZpZXcSEnN5c3RlbV91c2VyX21hbmFnZRIRY2xpZW50X2dyb3VwX3ZpZXcSE2'
    'NsaWVudF9ncm91cF9tYW5hZ2USD21lbWJlcnNoaXBfdmlldxIRbWVtYmVyc2hpcF9tYW5hZ2US'
    'FWludmVzdG9yX2FjY291bnRfdmlldxIXaW52ZXN0b3JfYWNjb3VudF9tYW5hZ2USEGNsaWVudF'
    '9kYXRhX3ZpZXcSEmNsaWVudF9kYXRhX21hbmFnZRISY2xpZW50X2RhdGFfdmVyaWZ5');

