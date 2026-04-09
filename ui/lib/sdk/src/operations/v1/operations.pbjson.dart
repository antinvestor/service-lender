//
//  Generated code. Do not modify.
//  source: operations/v1/operations.proto
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

@$core.Deprecated('Use transferOrderObjectDescriptor instead')
const TransferOrderObject$json = {
  '1': 'TransferOrderObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'debit_account_ref', '3': 2, '4': 1, '5': 9, '10': 'debitAccountRef'},
    {
      '1': 'credit_account_ref',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'creditAccountRef'
    },
    {
      '1': 'amount',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.type.Money',
      '10': 'amount'
    },
    {'1': 'order_type', '3': 6, '4': 1, '5': 5, '10': 'orderType'},
    {'1': 'reference', '3': 7, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'description', '3': 8, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'extra_data',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '10': 'extraData'
    },
    {
      '1': 'state',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.common.v1.STATE',
      '10': 'state'
    },
  ],
  '9': [
    {'1': 5, '2': 6},
  ],
};

/// Descriptor for `TransferOrderObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferOrderObjectDescriptor = $convert.base64Decode(
    'ChNUcmFuc2Zlck9yZGVyT2JqZWN0Eg4KAmlkGAEgASgJUgJpZBIqChFkZWJpdF9hY2NvdW50X3'
    'JlZhgCIAEoCVIPZGViaXRBY2NvdW50UmVmEiwKEmNyZWRpdF9hY2NvdW50X3JlZhgDIAEoCVIQ'
    'Y3JlZGl0QWNjb3VudFJlZhIqCgZhbW91bnQYBCABKAsyEi5nb29nbGUudHlwZS5Nb25leVIGYW'
    '1vdW50Eh0KCm9yZGVyX3R5cGUYBiABKAVSCW9yZGVyVHlwZRIcCglyZWZlcmVuY2UYByABKAlS'
    'CXJlZmVyZW5jZRIgCgtkZXNjcmlwdGlvbhgIIAEoCVILZGVzY3JpcHRpb24SNgoKZXh0cmFfZG'
    'F0YRgJIAEoCzIXLmdvb2dsZS5wcm90b2J1Zi5TdHJ1Y3RSCWV4dHJhRGF0YRImCgVzdGF0ZRgK'
    'IAEoDjIQLmNvbW1vbi52MS5TVEFURVIFc3RhdGVKBAgFEAY=');

@$core.Deprecated('Use transferOrderExecuteRequestDescriptor instead')
const TransferOrderExecuteRequest$json = {
  '1': 'TransferOrderExecuteRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `TransferOrderExecuteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferOrderExecuteRequestDescriptor =
    $convert.base64Decode(
        'ChtUcmFuc2Zlck9yZGVyRXhlY3V0ZVJlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use transferOrderExecuteResponseDescriptor instead')
const TransferOrderExecuteResponse$json = {
  '1': 'TransferOrderExecuteResponse',
  '2': [
    {
      '1': 'data',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.operations.v1.TransferOrderObject',
      '10': 'data'
    },
  ],
};

/// Descriptor for `TransferOrderExecuteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferOrderExecuteResponseDescriptor =
    $convert.base64Decode(
        'ChxUcmFuc2Zlck9yZGVyRXhlY3V0ZVJlc3BvbnNlEjYKBGRhdGEYASABKAsyIi5vcGVyYXRpb2'
        '5zLnYxLlRyYW5zZmVyT3JkZXJPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use transferOrderSearchRequestDescriptor instead')
const TransferOrderSearchRequest$json = {
  '1': 'TransferOrderSearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'order_type', '3': 2, '4': 1, '5': 5, '10': 'orderType'},
    {
      '1': 'cursor',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.common.v1.PageCursor',
      '10': 'cursor'
    },
  ],
};

/// Descriptor for `TransferOrderSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferOrderSearchRequestDescriptor =
    $convert.base64Decode(
        'ChpUcmFuc2Zlck9yZGVyU2VhcmNoUmVxdWVzdBIUCgVxdWVyeRgBIAEoCVIFcXVlcnkSHQoKb3'
        'JkZXJfdHlwZRgCIAEoBVIJb3JkZXJUeXBlEi0KBmN1cnNvchgDIAEoCzIVLmNvbW1vbi52MS5Q'
        'YWdlQ3Vyc29yUgZjdXJzb3I=');

@$core.Deprecated('Use transferOrderSearchResponseDescriptor instead')
const TransferOrderSearchResponse$json = {
  '1': 'TransferOrderSearchResponse',
  '2': [
    {
      '1': 'data',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.operations.v1.TransferOrderObject',
      '10': 'data'
    },
  ],
};

/// Descriptor for `TransferOrderSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferOrderSearchResponseDescriptor =
    $convert.base64Decode(
        'ChtUcmFuc2Zlck9yZGVyU2VhcmNoUmVzcG9uc2USNgoEZGF0YRgBIAMoCzIiLm9wZXJhdGlvbn'
        'MudjEuVHJhbnNmZXJPcmRlck9iamVjdFIEZGF0YQ==');

const $core.Map<$core.String, $core.dynamic> OperationsServiceBase$json = {
  '1': 'OperationsService',
  '2': [
    {
      '1': 'TransferOrderExecute',
      '2': '.operations.v1.TransferOrderExecuteRequest',
      '3': '.operations.v1.TransferOrderExecuteResponse',
      '4': {}
    },
    {
      '1': 'TransferOrderSearch',
      '2': '.operations.v1.TransferOrderSearchRequest',
      '3': '.operations.v1.TransferOrderSearchResponse',
      '4': {},
      '6': true
    },
  ],
  '3': {},
};

@$core.Deprecated('Use operationsServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    OperationsServiceBase$messageJson = {
  '.operations.v1.TransferOrderExecuteRequest':
      TransferOrderExecuteRequest$json,
  '.operations.v1.TransferOrderExecuteResponse':
      TransferOrderExecuteResponse$json,
  '.operations.v1.TransferOrderObject': TransferOrderObject$json,
  '.google.type.Money': $9.Money$json,
  '.google.protobuf.Struct': $6.Struct$json,
  '.google.protobuf.Struct.FieldsEntry': $6.Struct_FieldsEntry$json,
  '.google.protobuf.Value': $6.Value$json,
  '.google.protobuf.ListValue': $6.ListValue$json,
  '.operations.v1.TransferOrderSearchRequest': TransferOrderSearchRequest$json,
  '.common.v1.PageCursor': $7.PageCursor$json,
  '.operations.v1.TransferOrderSearchResponse':
      TransferOrderSearchResponse$json,
};

/// Descriptor for `OperationsService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List operationsServiceDescriptor = $convert.base64Decode(
    'ChFPcGVyYXRpb25zU2VydmljZRKHAQoUVHJhbnNmZXJPcmRlckV4ZWN1dGUSKi5vcGVyYXRpb2'
    '5zLnYxLlRyYW5zZmVyT3JkZXJFeGVjdXRlUmVxdWVzdBorLm9wZXJhdGlvbnMudjEuVHJhbnNm'
    'ZXJPcmRlckV4ZWN1dGVSZXNwb25zZSIWgrUYEgoQdHJhbnNmZXJfZXhlY3V0ZRKDAQoTVHJhbn'
    'NmZXJPcmRlclNlYXJjaBIpLm9wZXJhdGlvbnMudjEuVHJhbnNmZXJPcmRlclNlYXJjaFJlcXVl'
    'c3QaKi5vcGVyYXRpb25zLnYxLlRyYW5zZmVyT3JkZXJTZWFyY2hSZXNwb25zZSITgrUYDwoNdH'
    'JhbnNmZXJfdmlldzABGvQBgrUY7wEKEnNlcnZpY2Vfb3BlcmF0aW9ucxIQdHJhbnNmZXJfZXhl'
    'Y3V0ZRINdHJhbnNmZXJfdmlldxojCAESEHRyYW5zZmVyX2V4ZWN1dGUSDXRyYW5zZmVyX3ZpZX'
    'caIwgCEhB0cmFuc2Zlcl9leGVjdXRlEg10cmFuc2Zlcl92aWV3GiMIAxIQdHJhbnNmZXJfZXhl'
    'Y3V0ZRINdHJhbnNmZXJfdmlldxoRCAQSDXRyYW5zZmVyX3ZpZXcaEQgFEg10cmFuc2Zlcl92aW'
    'V3GiMIBhIQdHJhbnNmZXJfZXhlY3V0ZRINdHJhbnNmZXJfdmlldw==');
