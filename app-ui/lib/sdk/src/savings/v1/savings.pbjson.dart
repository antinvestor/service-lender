//
//  Generated code. Do not modify.
//  source: savings/v1/savings.proto
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

@$core.Deprecated('Use savingsPeriodTypeDescriptor instead')
const SavingsPeriodType$json = {
  '1': 'SavingsPeriodType',
  '2': [
    {'1': 'SAVINGS_PERIOD_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'SAVINGS_PERIOD_TYPE_DAILY', '2': 1},
    {'1': 'SAVINGS_PERIOD_TYPE_WEEKLY', '2': 2},
    {'1': 'SAVINGS_PERIOD_TYPE_BIWEEKLY', '2': 3},
    {'1': 'SAVINGS_PERIOD_TYPE_MONTHLY', '2': 4},
    {'1': 'SAVINGS_PERIOD_TYPE_QUARTERLY', '2': 5},
  ],
};

/// Descriptor for `SavingsPeriodType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List savingsPeriodTypeDescriptor = $convert.base64Decode(
    'ChFTYXZpbmdzUGVyaW9kVHlwZRIjCh9TQVZJTkdTX1BFUklPRF9UWVBFX1VOU1BFQ0lGSUVEEA'
    'ASHQoZU0FWSU5HU19QRVJJT0RfVFlQRV9EQUlMWRABEh4KGlNBVklOR1NfUEVSSU9EX1RZUEVf'
    'V0VFS0xZEAISIAocU0FWSU5HU19QRVJJT0RfVFlQRV9CSVdFRUtMWRADEh8KG1NBVklOR1NfUE'
    'VSSU9EX1RZUEVfTU9OVEhMWRAEEiEKHVNBVklOR1NfUEVSSU9EX1RZUEVfUVVBUlRFUkxZEAU=');

@$core.Deprecated('Use compoundingFrequencyDescriptor instead')
const CompoundingFrequency$json = {
  '1': 'CompoundingFrequency',
  '2': [
    {'1': 'COMPOUNDING_FREQUENCY_UNSPECIFIED', '2': 0},
    {'1': 'COMPOUNDING_FREQUENCY_DAILY', '2': 1},
    {'1': 'COMPOUNDING_FREQUENCY_WEEKLY', '2': 2},
    {'1': 'COMPOUNDING_FREQUENCY_MONTHLY', '2': 3},
    {'1': 'COMPOUNDING_FREQUENCY_QUARTERLY', '2': 4},
    {'1': 'COMPOUNDING_FREQUENCY_ANNUALLY', '2': 5},
  ],
};

/// Descriptor for `CompoundingFrequency`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List compoundingFrequencyDescriptor = $convert.base64Decode(
    'ChRDb21wb3VuZGluZ0ZyZXF1ZW5jeRIlCiFDT01QT1VORElOR19GUkVRVUVOQ1lfVU5TUEVDSU'
    'ZJRUQQABIfChtDT01QT1VORElOR19GUkVRVUVOQ1lfREFJTFkQARIgChxDT01QT1VORElOR19G'
    'UkVRVUVOQ1lfV0VFS0xZEAISIQodQ09NUE9VTkRJTkdfRlJFUVVFTkNZX01PTlRITFkQAxIjCh'
    '9DT01QT1VORElOR19GUkVRVUVOQ1lfUVVBUlRFUkxZEAQSIgoeQ09NUE9VTkRJTkdfRlJFUVVF'
    'TkNZX0FOTlVBTExZEAU=');

@$core.Deprecated('Use savingsAccountOwnerTypeDescriptor instead')
const SavingsAccountOwnerType$json = {
  '1': 'SavingsAccountOwnerType',
  '2': [
    {'1': 'SAVINGS_ACCOUNT_OWNER_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'SAVINGS_ACCOUNT_OWNER_TYPE_INDIVIDUAL', '2': 1},
    {'1': 'SAVINGS_ACCOUNT_OWNER_TYPE_GROUP', '2': 2},
  ],
};

/// Descriptor for `SavingsAccountOwnerType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List savingsAccountOwnerTypeDescriptor = $convert.base64Decode(
    'ChdTYXZpbmdzQWNjb3VudE93bmVyVHlwZRIqCiZTQVZJTkdTX0FDQ09VTlRfT1dORVJfVFlQRV'
    '9VTlNQRUNJRklFRBAAEikKJVNBVklOR1NfQUNDT1VOVF9PV05FUl9UWVBFX0lORElWSURVQUwQ'
    'ARIkCiBTQVZJTkdTX0FDQ09VTlRfT1dORVJfVFlQRV9HUk9VUBAC');

@$core.Deprecated('Use savingsAccountStatusDescriptor instead')
const SavingsAccountStatus$json = {
  '1': 'SavingsAccountStatus',
  '2': [
    {'1': 'SAVINGS_ACCOUNT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'SAVINGS_ACCOUNT_STATUS_ACTIVE', '2': 1},
    {'1': 'SAVINGS_ACCOUNT_STATUS_FROZEN', '2': 2},
    {'1': 'SAVINGS_ACCOUNT_STATUS_CLOSED', '2': 3},
  ],
};

/// Descriptor for `SavingsAccountStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List savingsAccountStatusDescriptor = $convert.base64Decode(
    'ChRTYXZpbmdzQWNjb3VudFN0YXR1cxImCiJTQVZJTkdTX0FDQ09VTlRfU1RBVFVTX1VOU1BFQ0'
    'lGSUVEEAASIQodU0FWSU5HU19BQ0NPVU5UX1NUQVRVU19BQ1RJVkUQARIhCh1TQVZJTkdTX0FD'
    'Q09VTlRfU1RBVFVTX0ZST1pFThACEiEKHVNBVklOR1NfQUNDT1VOVF9TVEFUVVNfQ0xPU0VEEA'
    'M=');

@$core.Deprecated('Use depositStatusDescriptor instead')
const DepositStatus$json = {
  '1': 'DepositStatus',
  '2': [
    {'1': 'DEPOSIT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'DEPOSIT_STATUS_PENDING', '2': 1},
    {'1': 'DEPOSIT_STATUS_COMPLETED', '2': 2},
    {'1': 'DEPOSIT_STATUS_REVERSED', '2': 3},
  ],
};

/// Descriptor for `DepositStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List depositStatusDescriptor = $convert.base64Decode(
    'Cg1EZXBvc2l0U3RhdHVzEh4KGkRFUE9TSVRfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGgoWREVQT1'
    'NJVF9TVEFUVVNfUEVORElORxABEhwKGERFUE9TSVRfU1RBVFVTX0NPTVBMRVRFRBACEhsKF0RF'
    'UE9TSVRfU1RBVFVTX1JFVkVSU0VEEAM=');

@$core.Deprecated('Use withdrawalStatusDescriptor instead')
const WithdrawalStatus$json = {
  '1': 'WithdrawalStatus',
  '2': [
    {'1': 'WITHDRAWAL_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'WITHDRAWAL_STATUS_PENDING', '2': 1},
    {'1': 'WITHDRAWAL_STATUS_APPROVED', '2': 2},
    {'1': 'WITHDRAWAL_STATUS_COMPLETED', '2': 3},
    {'1': 'WITHDRAWAL_STATUS_REJECTED', '2': 4},
    {'1': 'WITHDRAWAL_STATUS_REVERSED', '2': 5},
  ],
};

/// Descriptor for `WithdrawalStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List withdrawalStatusDescriptor = $convert.base64Decode(
    'ChBXaXRoZHJhd2FsU3RhdHVzEiEKHVdJVEhEUkFXQUxfU1RBVFVTX1VOU1BFQ0lGSUVEEAASHQ'
    'oZV0lUSERSQVdBTF9TVEFUVVNfUEVORElORxABEh4KGldJVEhEUkFXQUxfU1RBVFVTX0FQUFJP'
    'VkVEEAISHwobV0lUSERSQVdBTF9TVEFUVVNfQ09NUExFVEVEEAMSHgoaV0lUSERSQVdBTF9TVE'
    'FUVVNfUkVKRUNURUQQBBIeChpXSVRIRFJBV0FMX1NUQVRVU19SRVZFUlNFRBAF');

@$core.Deprecated('Use savingsProductObjectDescriptor instead')
const SavingsProductObject$json = {
  '1': 'SavingsProductObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'bank_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'bankId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'code', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'code'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {'1': 'currency_code', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'currencyCode'},
    {'1': 'interest_rate', '3': 7, '4': 1, '5': 9, '10': 'interestRate'},
    {'1': 'compounding_frequency', '3': 8, '4': 1, '5': 14, '6': '.savings.v1.CompoundingFrequency', '10': 'compoundingFrequency'},
    {'1': 'period_type', '3': 9, '4': 1, '5': 14, '6': '.savings.v1.SavingsPeriodType', '10': 'periodType'},
    {'1': 'min_deposit', '3': 10, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'minDeposit'},
    {'1': 'max_deposit', '3': 11, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'maxDeposit'},
    {'1': 'withdrawal_rules', '3': 12, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'withdrawalRules'},
    {'1': 'state', '3': 13, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'properties', '3': 14, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `SavingsProductObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsProductObjectDescriptor = $convert.base64Decode(
    'ChRTYXZpbmdzUHJvZHVjdE9iamVjdBIuCgJpZBgBIAEoCUIeukgb2AEBchYQAxgoMhBbMC05YS'
    '16Xy1dezMsNDB9UgJpZBIiCgdiYW5rX2lkGAIgASgJQgm6SAZyBBADGChSBmJhbmtJZBIbCgRu'
    'YW1lGAMgASgJQge6SARyAhABUgRuYW1lEhsKBGNvZGUYBCABKAlCB7pIBHICEAFSBGNvZGUSIA'
    'oLZGVzY3JpcHRpb24YBSABKAlSC2Rlc2NyaXB0aW9uEi0KDWN1cnJlbmN5X2NvZGUYBiABKAlC'
    'CLpIBXIDmAEDUgxjdXJyZW5jeUNvZGUSIwoNaW50ZXJlc3RfcmF0ZRgHIAEoCVIMaW50ZXJlc3'
    'RSYXRlElUKFWNvbXBvdW5kaW5nX2ZyZXF1ZW5jeRgIIAEoDjIgLnNhdmluZ3MudjEuQ29tcG91'
    'bmRpbmdGcmVxdWVuY3lSFGNvbXBvdW5kaW5nRnJlcXVlbmN5Ej4KC3BlcmlvZF90eXBlGAkgAS'
    'gOMh0uc2F2aW5ncy52MS5TYXZpbmdzUGVyaW9kVHlwZVIKcGVyaW9kVHlwZRIzCgttaW5fZGVw'
    'b3NpdBgKIAEoCzISLmdvb2dsZS50eXBlLk1vbmV5UgptaW5EZXBvc2l0EjMKC21heF9kZXBvc2'
    'l0GAsgASgLMhIuZ29vZ2xlLnR5cGUuTW9uZXlSCm1heERlcG9zaXQSQgoQd2l0aGRyYXdhbF9y'
    'dWxlcxgMIAEoCzIXLmdvb2dsZS5wcm90b2J1Zi5TdHJ1Y3RSD3dpdGhkcmF3YWxSdWxlcxImCg'
    'VzdGF0ZRgNIAEoDjIQLmNvbW1vbi52MS5TVEFURVIFc3RhdGUSNwoKcHJvcGVydGllcxgOIAEo'
    'CzIXLmdvb2dsZS5wcm90b2J1Zi5TdHJ1Y3RSCnByb3BlcnRpZXM=');

@$core.Deprecated('Use savingsAccountObjectDescriptor instead')
const SavingsAccountObject$json = {
  '1': 'SavingsAccountObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'productId'},
    {'1': 'owner_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'ownerId'},
    {'1': 'owner_type', '3': 4, '4': 1, '5': 14, '6': '.savings.v1.SavingsAccountOwnerType', '10': 'ownerType'},
    {'1': 'bank_id', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'bankId'},
    {'1': 'branch_id', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'branchId'},
    {'1': 'agent_id', '3': 7, '4': 1, '5': 9, '8': {}, '10': 'agentId'},
    {'1': 'currency_code', '3': 8, '4': 1, '5': 9, '8': {}, '10': 'currencyCode'},
    {'1': 'status', '3': 9, '4': 1, '5': 14, '6': '.savings.v1.SavingsAccountStatus', '10': 'status'},
    {'1': 'ledger_account_id', '3': 10, '4': 1, '5': 9, '10': 'ledgerAccountId'},
    {'1': 'payment_account_ref', '3': 11, '4': 1, '5': 9, '10': 'paymentAccountRef'},
    {'1': 'properties', '3': 12, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `SavingsAccountObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsAccountObjectDescriptor = $convert.base64Decode(
    'ChRTYXZpbmdzQWNjb3VudE9iamVjdBIuCgJpZBgBIAEoCUIeukgb2AEBchYQAxgoMhBbMC05YS'
    '16Xy1dezMsNDB9UgJpZBIoCgpwcm9kdWN0X2lkGAIgASgJQgm6SAZyBBADGChSCXByb2R1Y3RJ'
    'ZBIkCghvd25lcl9pZBgDIAEoCUIJukgGcgQQAxgoUgdvd25lcklkEkIKCm93bmVyX3R5cGUYBC'
    'ABKA4yIy5zYXZpbmdzLnYxLlNhdmluZ3NBY2NvdW50T3duZXJUeXBlUglvd25lclR5cGUSIgoH'
    'YmFua19pZBgFIAEoCUIJukgGcgQQAxgoUgZiYW5rSWQSKQoJYnJhbmNoX2lkGAYgASgJQgy6SA'
    'nYAQFyBBADGChSCGJyYW5jaElkEicKCGFnZW50X2lkGAcgASgJQgy6SAnYAQFyBBADGChSB2Fn'
    'ZW50SWQSLQoNY3VycmVuY3lfY29kZRgIIAEoCUIIukgFcgOYAQNSDGN1cnJlbmN5Q29kZRI4Cg'
    'ZzdGF0dXMYCSABKA4yIC5zYXZpbmdzLnYxLlNhdmluZ3NBY2NvdW50U3RhdHVzUgZzdGF0dXMS'
    'KgoRbGVkZ2VyX2FjY291bnRfaWQYCiABKAlSD2xlZGdlckFjY291bnRJZBIuChNwYXltZW50X2'
    'FjY291bnRfcmVmGAsgASgJUhFwYXltZW50QWNjb3VudFJlZhI3Cgpwcm9wZXJ0aWVzGAwgASgL'
    'MhcuZ29vZ2xlLnByb3RvYnVmLlN0cnVjdFIKcHJvcGVydGllcw==');

@$core.Deprecated('Use depositObjectDescriptor instead')
const DepositObject$json = {
  '1': 'DepositObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'savings_account_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'savingsAccountId'},
    {'1': 'amount', '3': 3, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'amount'},
    {'1': 'status', '3': 5, '4': 1, '5': 14, '6': '.savings.v1.DepositStatus', '10': 'status'},
    {'1': 'payment_reference', '3': 6, '4': 1, '5': 9, '10': 'paymentReference'},
    {'1': 'ledger_transaction_id', '3': 7, '4': 1, '5': 9, '10': 'ledgerTransactionId'},
    {'1': 'channel', '3': 8, '4': 1, '5': 9, '10': 'channel'},
    {'1': 'payer_reference', '3': 9, '4': 1, '5': 9, '10': 'payerReference'},
    {'1': 'idempotency_key', '3': 10, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'properties', '3': 11, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
  '9': [
    {'1': 4, '2': 5},
  ],
};

/// Descriptor for `DepositObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List depositObjectDescriptor = $convert.base64Decode(
    'Cg1EZXBvc2l0T2JqZWN0Ei4KAmlkGAEgASgJQh66SBvYAQFyFhADGCgyEFswLTlhLXpfLV17My'
    'w0MH1SAmlkEjcKEnNhdmluZ3NfYWNjb3VudF9pZBgCIAEoCUIJukgGcgQQAxgoUhBzYXZpbmdz'
    'QWNjb3VudElkEioKBmFtb3VudBgDIAEoCzISLmdvb2dsZS50eXBlLk1vbmV5UgZhbW91bnQSMQ'
    'oGc3RhdHVzGAUgASgOMhkuc2F2aW5ncy52MS5EZXBvc2l0U3RhdHVzUgZzdGF0dXMSKwoRcGF5'
    'bWVudF9yZWZlcmVuY2UYBiABKAlSEHBheW1lbnRSZWZlcmVuY2USMgoVbGVkZ2VyX3RyYW5zYW'
    'N0aW9uX2lkGAcgASgJUhNsZWRnZXJUcmFuc2FjdGlvbklkEhgKB2NoYW5uZWwYCCABKAlSB2No'
    'YW5uZWwSJwoPcGF5ZXJfcmVmZXJlbmNlGAkgASgJUg5wYXllclJlZmVyZW5jZRInCg9pZGVtcG'
    '90ZW5jeV9rZXkYCiABKAlSDmlkZW1wb3RlbmN5S2V5EjcKCnByb3BlcnRpZXMYCyABKAsyFy5n'
    'b29nbGUucHJvdG9idWYuU3RydWN0Ugpwcm9wZXJ0aWVzSgQIBBAF');

@$core.Deprecated('Use withdrawalObjectDescriptor instead')
const WithdrawalObject$json = {
  '1': 'WithdrawalObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'savings_account_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'savingsAccountId'},
    {'1': 'amount', '3': 3, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'amount'},
    {'1': 'status', '3': 5, '4': 1, '5': 14, '6': '.savings.v1.WithdrawalStatus', '10': 'status'},
    {'1': 'payment_reference', '3': 6, '4': 1, '5': 9, '10': 'paymentReference'},
    {'1': 'ledger_transaction_id', '3': 7, '4': 1, '5': 9, '10': 'ledgerTransactionId'},
    {'1': 'channel', '3': 8, '4': 1, '5': 9, '10': 'channel'},
    {'1': 'recipient_reference', '3': 9, '4': 1, '5': 9, '10': 'recipientReference'},
    {'1': 'reason', '3': 10, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'idempotency_key', '3': 11, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'properties', '3': 12, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
  '9': [
    {'1': 4, '2': 5},
  ],
};

/// Descriptor for `WithdrawalObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawalObjectDescriptor = $convert.base64Decode(
    'ChBXaXRoZHJhd2FsT2JqZWN0Ei4KAmlkGAEgASgJQh66SBvYAQFyFhADGCgyEFswLTlhLXpfLV'
    '17Myw0MH1SAmlkEjcKEnNhdmluZ3NfYWNjb3VudF9pZBgCIAEoCUIJukgGcgQQAxgoUhBzYXZp'
    'bmdzQWNjb3VudElkEioKBmFtb3VudBgDIAEoCzISLmdvb2dsZS50eXBlLk1vbmV5UgZhbW91bn'
    'QSNAoGc3RhdHVzGAUgASgOMhwuc2F2aW5ncy52MS5XaXRoZHJhd2FsU3RhdHVzUgZzdGF0dXMS'
    'KwoRcGF5bWVudF9yZWZlcmVuY2UYBiABKAlSEHBheW1lbnRSZWZlcmVuY2USMgoVbGVkZ2VyX3'
    'RyYW5zYWN0aW9uX2lkGAcgASgJUhNsZWRnZXJUcmFuc2FjdGlvbklkEhgKB2NoYW5uZWwYCCAB'
    'KAlSB2NoYW5uZWwSLwoTcmVjaXBpZW50X3JlZmVyZW5jZRgJIAEoCVIScmVjaXBpZW50UmVmZX'
    'JlbmNlEhYKBnJlYXNvbhgKIAEoCVIGcmVhc29uEicKD2lkZW1wb3RlbmN5X2tleRgLIAEoCVIO'
    'aWRlbXBvdGVuY3lLZXkSNwoKcHJvcGVydGllcxgMIAEoCzIXLmdvb2dsZS5wcm90b2J1Zi5TdH'
    'J1Y3RSCnByb3BlcnRpZXNKBAgEEAU=');

@$core.Deprecated('Use interestAccrualObjectDescriptor instead')
const InterestAccrualObject$json = {
  '1': 'InterestAccrualObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'savings_account_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'savingsAccountId'},
    {'1': 'amount', '3': 3, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'amount'},
    {'1': 'period_start', '3': 4, '4': 1, '5': 9, '10': 'periodStart'},
    {'1': 'period_end', '3': 5, '4': 1, '5': 9, '10': 'periodEnd'},
    {'1': 'rate_applied', '3': 6, '4': 1, '5': 9, '10': 'rateApplied'},
    {'1': 'balance_used', '3': 7, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'balanceUsed'},
    {'1': 'ledger_transaction_id', '3': 8, '4': 1, '5': 9, '10': 'ledgerTransactionId'},
    {'1': 'properties', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `InterestAccrualObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List interestAccrualObjectDescriptor = $convert.base64Decode(
    'ChVJbnRlcmVzdEFjY3J1YWxPYmplY3QSLgoCaWQYASABKAlCHrpIG9gBAXIWEAMYKDIQWzAtOW'
    'Etel8tXXszLDQwfVICaWQSNwoSc2F2aW5nc19hY2NvdW50X2lkGAIgASgJQgm6SAZyBBADGChS'
    'EHNhdmluZ3NBY2NvdW50SWQSKgoGYW1vdW50GAMgASgLMhIuZ29vZ2xlLnR5cGUuTW9uZXlSBm'
    'Ftb3VudBIhCgxwZXJpb2Rfc3RhcnQYBCABKAlSC3BlcmlvZFN0YXJ0Eh0KCnBlcmlvZF9lbmQY'
    'BSABKAlSCXBlcmlvZEVuZBIhCgxyYXRlX2FwcGxpZWQYBiABKAlSC3JhdGVBcHBsaWVkEjUKDG'
    'JhbGFuY2VfdXNlZBgHIAEoCzISLmdvb2dsZS50eXBlLk1vbmV5UgtiYWxhbmNlVXNlZBIyChVs'
    'ZWRnZXJfdHJhbnNhY3Rpb25faWQYCCABKAlSE2xlZGdlclRyYW5zYWN0aW9uSWQSNwoKcHJvcG'
    'VydGllcxgJIAEoCzIXLmdvb2dsZS5wcm90b2J1Zi5TdHJ1Y3RSCnByb3BlcnRpZXM=');

@$core.Deprecated('Use savingsBalanceObjectDescriptor instead')
const SavingsBalanceObject$json = {
  '1': 'SavingsBalanceObject',
  '2': [
    {'1': 'savings_account_id', '3': 1, '4': 1, '5': 9, '10': 'savingsAccountId'},
    {'1': 'available_balance', '3': 2, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'availableBalance'},
    {'1': 'total_deposits', '3': 3, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'totalDeposits'},
    {'1': 'total_withdrawals', '3': 4, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'totalWithdrawals'},
    {'1': 'total_interest', '3': 5, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'totalInterest'},
    {'1': 'last_calculated_at', '3': 6, '4': 1, '5': 9, '10': 'lastCalculatedAt'},
  ],
};

/// Descriptor for `SavingsBalanceObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsBalanceObjectDescriptor = $convert.base64Decode(
    'ChRTYXZpbmdzQmFsYW5jZU9iamVjdBIsChJzYXZpbmdzX2FjY291bnRfaWQYASABKAlSEHNhdm'
    'luZ3NBY2NvdW50SWQSPwoRYXZhaWxhYmxlX2JhbGFuY2UYAiABKAsyEi5nb29nbGUudHlwZS5N'
    'b25leVIQYXZhaWxhYmxlQmFsYW5jZRI5Cg50b3RhbF9kZXBvc2l0cxgDIAEoCzISLmdvb2dsZS'
    '50eXBlLk1vbmV5Ug10b3RhbERlcG9zaXRzEj8KEXRvdGFsX3dpdGhkcmF3YWxzGAQgASgLMhIu'
    'Z29vZ2xlLnR5cGUuTW9uZXlSEHRvdGFsV2l0aGRyYXdhbHMSOQoOdG90YWxfaW50ZXJlc3QYBS'
    'ABKAsyEi5nb29nbGUudHlwZS5Nb25leVINdG90YWxJbnRlcmVzdBIsChJsYXN0X2NhbGN1bGF0'
    'ZWRfYXQYBiABKAlSEGxhc3RDYWxjdWxhdGVkQXQ=');

@$core.Deprecated('Use savingsStatementEntryDescriptor instead')
const SavingsStatementEntry$json = {
  '1': 'SavingsStatementEntry',
  '2': [
    {'1': 'date', '3': 1, '4': 1, '5': 9, '10': 'date'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'debit', '3': 3, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'debit'},
    {'1': 'credit', '3': 4, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'credit'},
    {'1': 'balance', '3': 5, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'balance'},
    {'1': 'reference', '3': 6, '4': 1, '5': 9, '10': 'reference'},
  ],
};

/// Descriptor for `SavingsStatementEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsStatementEntryDescriptor = $convert.base64Decode(
    'ChVTYXZpbmdzU3RhdGVtZW50RW50cnkSEgoEZGF0ZRgBIAEoCVIEZGF0ZRIgCgtkZXNjcmlwdG'
    'lvbhgCIAEoCVILZGVzY3JpcHRpb24SKAoFZGViaXQYAyABKAsyEi5nb29nbGUudHlwZS5Nb25l'
    'eVIFZGViaXQSKgoGY3JlZGl0GAQgASgLMhIuZ29vZ2xlLnR5cGUuTW9uZXlSBmNyZWRpdBIsCg'
    'diYWxhbmNlGAUgASgLMhIuZ29vZ2xlLnR5cGUuTW9uZXlSB2JhbGFuY2USHAoJcmVmZXJlbmNl'
    'GAYgASgJUglyZWZlcmVuY2U=');

@$core.Deprecated('Use savingsProductSaveRequestDescriptor instead')
const SavingsProductSaveRequest$json = {
  '1': 'SavingsProductSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.savings.v1.SavingsProductObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `SavingsProductSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsProductSaveRequestDescriptor = $convert.base64Decode(
    'ChlTYXZpbmdzUHJvZHVjdFNhdmVSZXF1ZXN0EjwKBGRhdGEYASABKAsyIC5zYXZpbmdzLnYxLl'
    'NhdmluZ3NQcm9kdWN0T2JqZWN0Qga6SAPIAQFSBGRhdGE=');

@$core.Deprecated('Use savingsProductSaveResponseDescriptor instead')
const SavingsProductSaveResponse$json = {
  '1': 'SavingsProductSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.savings.v1.SavingsProductObject', '10': 'data'},
  ],
};

/// Descriptor for `SavingsProductSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsProductSaveResponseDescriptor = $convert.base64Decode(
    'ChpTYXZpbmdzUHJvZHVjdFNhdmVSZXNwb25zZRI0CgRkYXRhGAEgASgLMiAuc2F2aW5ncy52MS'
    '5TYXZpbmdzUHJvZHVjdE9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use savingsProductGetRequestDescriptor instead')
const SavingsProductGetRequest$json = {
  '1': 'SavingsProductGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `SavingsProductGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsProductGetRequestDescriptor = $convert.base64Decode(
    'ChhTYXZpbmdzUHJvZHVjdEdldFJlcXVlc3QSKwoCaWQYASABKAlCG7pIGHIWEAMYKDIQWzAtOW'
    'Etel8tXXszLDQwfVICaWQ=');

@$core.Deprecated('Use savingsProductGetResponseDescriptor instead')
const SavingsProductGetResponse$json = {
  '1': 'SavingsProductGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.savings.v1.SavingsProductObject', '10': 'data'},
  ],
};

/// Descriptor for `SavingsProductGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsProductGetResponseDescriptor = $convert.base64Decode(
    'ChlTYXZpbmdzUHJvZHVjdEdldFJlc3BvbnNlEjQKBGRhdGEYASABKAsyIC5zYXZpbmdzLnYxLl'
    'NhdmluZ3NQcm9kdWN0T2JqZWN0UgRkYXRh');

@$core.Deprecated('Use savingsProductSearchRequestDescriptor instead')
const SavingsProductSearchRequest$json = {
  '1': 'SavingsProductSearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'bank_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'bankId'},
    {'1': 'cursor', '3': 3, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `SavingsProductSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsProductSearchRequestDescriptor = $convert.base64Decode(
    'ChtTYXZpbmdzUHJvZHVjdFNlYXJjaFJlcXVlc3QSFAoFcXVlcnkYASABKAlSBXF1ZXJ5EiUKB2'
    'JhbmtfaWQYAiABKAlCDLpICdgBAXIEEAMYKFIGYmFua0lkEi0KBmN1cnNvchgDIAEoCzIVLmNv'
    'bW1vbi52MS5QYWdlQ3Vyc29yUgZjdXJzb3I=');

@$core.Deprecated('Use savingsProductSearchResponseDescriptor instead')
const SavingsProductSearchResponse$json = {
  '1': 'SavingsProductSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.savings.v1.SavingsProductObject', '10': 'data'},
  ],
};

/// Descriptor for `SavingsProductSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsProductSearchResponseDescriptor = $convert.base64Decode(
    'ChxTYXZpbmdzUHJvZHVjdFNlYXJjaFJlc3BvbnNlEjQKBGRhdGEYASADKAsyIC5zYXZpbmdzLn'
    'YxLlNhdmluZ3NQcm9kdWN0T2JqZWN0UgRkYXRh');

@$core.Deprecated('Use savingsAccountCreateRequestDescriptor instead')
const SavingsAccountCreateRequest$json = {
  '1': 'SavingsAccountCreateRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.savings.v1.SavingsAccountObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `SavingsAccountCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsAccountCreateRequestDescriptor = $convert.base64Decode(
    'ChtTYXZpbmdzQWNjb3VudENyZWF0ZVJlcXVlc3QSPAoEZGF0YRgBIAEoCzIgLnNhdmluZ3Mudj'
    'EuU2F2aW5nc0FjY291bnRPYmplY3RCBrpIA8gBAVIEZGF0YQ==');

@$core.Deprecated('Use savingsAccountCreateResponseDescriptor instead')
const SavingsAccountCreateResponse$json = {
  '1': 'SavingsAccountCreateResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.savings.v1.SavingsAccountObject', '10': 'data'},
  ],
};

/// Descriptor for `SavingsAccountCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsAccountCreateResponseDescriptor = $convert.base64Decode(
    'ChxTYXZpbmdzQWNjb3VudENyZWF0ZVJlc3BvbnNlEjQKBGRhdGEYASABKAsyIC5zYXZpbmdzLn'
    'YxLlNhdmluZ3NBY2NvdW50T2JqZWN0UgRkYXRh');

@$core.Deprecated('Use savingsAccountGetRequestDescriptor instead')
const SavingsAccountGetRequest$json = {
  '1': 'SavingsAccountGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `SavingsAccountGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsAccountGetRequestDescriptor = $convert.base64Decode(
    'ChhTYXZpbmdzQWNjb3VudEdldFJlcXVlc3QSKwoCaWQYASABKAlCG7pIGHIWEAMYKDIQWzAtOW'
    'Etel8tXXszLDQwfVICaWQ=');

@$core.Deprecated('Use savingsAccountGetResponseDescriptor instead')
const SavingsAccountGetResponse$json = {
  '1': 'SavingsAccountGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.savings.v1.SavingsAccountObject', '10': 'data'},
  ],
};

/// Descriptor for `SavingsAccountGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsAccountGetResponseDescriptor = $convert.base64Decode(
    'ChlTYXZpbmdzQWNjb3VudEdldFJlc3BvbnNlEjQKBGRhdGEYASABKAsyIC5zYXZpbmdzLnYxLl'
    'NhdmluZ3NBY2NvdW50T2JqZWN0UgRkYXRh');

@$core.Deprecated('Use savingsAccountSearchRequestDescriptor instead')
const SavingsAccountSearchRequest$json = {
  '1': 'SavingsAccountSearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'owner_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'ownerId'},
    {'1': 'product_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'productId'},
    {'1': 'bank_id', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'bankId'},
    {'1': 'status', '3': 5, '4': 1, '5': 14, '6': '.savings.v1.SavingsAccountStatus', '10': 'status'},
    {'1': 'cursor', '3': 6, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `SavingsAccountSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsAccountSearchRequestDescriptor = $convert.base64Decode(
    'ChtTYXZpbmdzQWNjb3VudFNlYXJjaFJlcXVlc3QSFAoFcXVlcnkYASABKAlSBXF1ZXJ5EicKCG'
    '93bmVyX2lkGAIgASgJQgy6SAnYAQFyBBADGChSB293bmVySWQSKwoKcHJvZHVjdF9pZBgDIAEo'
    'CUIMukgJ2AEBcgQQAxgoUglwcm9kdWN0SWQSJQoHYmFua19pZBgEIAEoCUIMukgJ2AEBcgQQAx'
    'goUgZiYW5rSWQSOAoGc3RhdHVzGAUgASgOMiAuc2F2aW5ncy52MS5TYXZpbmdzQWNjb3VudFN0'
    'YXR1c1IGc3RhdHVzEi0KBmN1cnNvchgGIAEoCzIVLmNvbW1vbi52MS5QYWdlQ3Vyc29yUgZjdX'
    'Jzb3I=');

@$core.Deprecated('Use savingsAccountSearchResponseDescriptor instead')
const SavingsAccountSearchResponse$json = {
  '1': 'SavingsAccountSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.savings.v1.SavingsAccountObject', '10': 'data'},
  ],
};

/// Descriptor for `SavingsAccountSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsAccountSearchResponseDescriptor = $convert.base64Decode(
    'ChxTYXZpbmdzQWNjb3VudFNlYXJjaFJlc3BvbnNlEjQKBGRhdGEYASADKAsyIC5zYXZpbmdzLn'
    'YxLlNhdmluZ3NBY2NvdW50T2JqZWN0UgRkYXRh');

@$core.Deprecated('Use savingsAccountFreezeRequestDescriptor instead')
const SavingsAccountFreezeRequest$json = {
  '1': 'SavingsAccountFreezeRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `SavingsAccountFreezeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsAccountFreezeRequestDescriptor = $convert.base64Decode(
    'ChtTYXZpbmdzQWNjb3VudEZyZWV6ZVJlcXVlc3QSKwoCaWQYASABKAlCG7pIGHIWEAMYKDIQWz'
    'AtOWEtel8tXXszLDQwfVICaWQSFgoGcmVhc29uGAIgASgJUgZyZWFzb24=');

@$core.Deprecated('Use savingsAccountFreezeResponseDescriptor instead')
const SavingsAccountFreezeResponse$json = {
  '1': 'SavingsAccountFreezeResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.savings.v1.SavingsAccountObject', '10': 'data'},
  ],
};

/// Descriptor for `SavingsAccountFreezeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsAccountFreezeResponseDescriptor = $convert.base64Decode(
    'ChxTYXZpbmdzQWNjb3VudEZyZWV6ZVJlc3BvbnNlEjQKBGRhdGEYASABKAsyIC5zYXZpbmdzLn'
    'YxLlNhdmluZ3NBY2NvdW50T2JqZWN0UgRkYXRh');

@$core.Deprecated('Use savingsAccountCloseRequestDescriptor instead')
const SavingsAccountCloseRequest$json = {
  '1': 'SavingsAccountCloseRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `SavingsAccountCloseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsAccountCloseRequestDescriptor = $convert.base64Decode(
    'ChpTYXZpbmdzQWNjb3VudENsb3NlUmVxdWVzdBIrCgJpZBgBIAEoCUIbukgYchYQAxgoMhBbMC'
    '05YS16Xy1dezMsNDB9UgJpZBIWCgZyZWFzb24YAiABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use savingsAccountCloseResponseDescriptor instead')
const SavingsAccountCloseResponse$json = {
  '1': 'SavingsAccountCloseResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.savings.v1.SavingsAccountObject', '10': 'data'},
  ],
};

/// Descriptor for `SavingsAccountCloseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsAccountCloseResponseDescriptor = $convert.base64Decode(
    'ChtTYXZpbmdzQWNjb3VudENsb3NlUmVzcG9uc2USNAoEZGF0YRgBIAEoCzIgLnNhdmluZ3Mudj'
    'EuU2F2aW5nc0FjY291bnRPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use depositRecordRequestDescriptor instead')
const DepositRecordRequest$json = {
  '1': 'DepositRecordRequest',
  '2': [
    {'1': 'savings_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'savingsAccountId'},
    {'1': 'amount', '3': 2, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'amount'},
    {'1': 'payment_reference', '3': 3, '4': 1, '5': 9, '10': 'paymentReference'},
    {'1': 'channel', '3': 4, '4': 1, '5': 9, '10': 'channel'},
    {'1': 'payer_reference', '3': 5, '4': 1, '5': 9, '10': 'payerReference'},
    {'1': 'idempotency_key', '3': 6, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `DepositRecordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List depositRecordRequestDescriptor = $convert.base64Decode(
    'ChREZXBvc2l0UmVjb3JkUmVxdWVzdBI3ChJzYXZpbmdzX2FjY291bnRfaWQYASABKAlCCbpIBn'
    'IEEAMYKFIQc2F2aW5nc0FjY291bnRJZBIqCgZhbW91bnQYAiABKAsyEi5nb29nbGUudHlwZS5N'
    'b25leVIGYW1vdW50EisKEXBheW1lbnRfcmVmZXJlbmNlGAMgASgJUhBwYXltZW50UmVmZXJlbm'
    'NlEhgKB2NoYW5uZWwYBCABKAlSB2NoYW5uZWwSJwoPcGF5ZXJfcmVmZXJlbmNlGAUgASgJUg5w'
    'YXllclJlZmVyZW5jZRInCg9pZGVtcG90ZW5jeV9rZXkYBiABKAlSDmlkZW1wb3RlbmN5S2V5');

@$core.Deprecated('Use depositRecordResponseDescriptor instead')
const DepositRecordResponse$json = {
  '1': 'DepositRecordResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.savings.v1.DepositObject', '10': 'data'},
  ],
};

/// Descriptor for `DepositRecordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List depositRecordResponseDescriptor = $convert.base64Decode(
    'ChVEZXBvc2l0UmVjb3JkUmVzcG9uc2USLQoEZGF0YRgBIAEoCzIZLnNhdmluZ3MudjEuRGVwb3'
    'NpdE9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use depositGetRequestDescriptor instead')
const DepositGetRequest$json = {
  '1': 'DepositGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `DepositGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List depositGetRequestDescriptor = $convert.base64Decode(
    'ChFEZXBvc2l0R2V0UmVxdWVzdBIrCgJpZBgBIAEoCUIbukgYchYQAxgoMhBbMC05YS16Xy1dez'
    'MsNDB9UgJpZA==');

@$core.Deprecated('Use depositGetResponseDescriptor instead')
const DepositGetResponse$json = {
  '1': 'DepositGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.savings.v1.DepositObject', '10': 'data'},
  ],
};

/// Descriptor for `DepositGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List depositGetResponseDescriptor = $convert.base64Decode(
    'ChJEZXBvc2l0R2V0UmVzcG9uc2USLQoEZGF0YRgBIAEoCzIZLnNhdmluZ3MudjEuRGVwb3NpdE'
    '9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use depositSearchRequestDescriptor instead')
const DepositSearchRequest$json = {
  '1': 'DepositSearchRequest',
  '2': [
    {'1': 'savings_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'savingsAccountId'},
    {'1': 'status', '3': 2, '4': 1, '5': 14, '6': '.savings.v1.DepositStatus', '10': 'status'},
    {'1': 'cursor', '3': 3, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `DepositSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List depositSearchRequestDescriptor = $convert.base64Decode(
    'ChREZXBvc2l0U2VhcmNoUmVxdWVzdBI3ChJzYXZpbmdzX2FjY291bnRfaWQYASABKAlCCbpIBn'
    'IEEAMYKFIQc2F2aW5nc0FjY291bnRJZBIxCgZzdGF0dXMYAiABKA4yGS5zYXZpbmdzLnYxLkRl'
    'cG9zaXRTdGF0dXNSBnN0YXR1cxItCgZjdXJzb3IYAyABKAsyFS5jb21tb24udjEuUGFnZUN1cn'
    'NvclIGY3Vyc29y');

@$core.Deprecated('Use depositSearchResponseDescriptor instead')
const DepositSearchResponse$json = {
  '1': 'DepositSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.savings.v1.DepositObject', '10': 'data'},
  ],
};

/// Descriptor for `DepositSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List depositSearchResponseDescriptor = $convert.base64Decode(
    'ChVEZXBvc2l0U2VhcmNoUmVzcG9uc2USLQoEZGF0YRgBIAMoCzIZLnNhdmluZ3MudjEuRGVwb3'
    'NpdE9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use withdrawalRequestRequestDescriptor instead')
const WithdrawalRequestRequest$json = {
  '1': 'WithdrawalRequestRequest',
  '2': [
    {'1': 'savings_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'savingsAccountId'},
    {'1': 'amount', '3': 2, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'amount'},
    {'1': 'channel', '3': 3, '4': 1, '5': 9, '10': 'channel'},
    {'1': 'recipient_reference', '3': 4, '4': 1, '5': 9, '10': 'recipientReference'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'idempotency_key', '3': 6, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `WithdrawalRequestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawalRequestRequestDescriptor = $convert.base64Decode(
    'ChhXaXRoZHJhd2FsUmVxdWVzdFJlcXVlc3QSNwoSc2F2aW5nc19hY2NvdW50X2lkGAEgASgJQg'
    'm6SAZyBBADGChSEHNhdmluZ3NBY2NvdW50SWQSKgoGYW1vdW50GAIgASgLMhIuZ29vZ2xlLnR5'
    'cGUuTW9uZXlSBmFtb3VudBIYCgdjaGFubmVsGAMgASgJUgdjaGFubmVsEi8KE3JlY2lwaWVudF'
    '9yZWZlcmVuY2UYBCABKAlSEnJlY2lwaWVudFJlZmVyZW5jZRIWCgZyZWFzb24YBSABKAlSBnJl'
    'YXNvbhInCg9pZGVtcG90ZW5jeV9rZXkYBiABKAlSDmlkZW1wb3RlbmN5S2V5');

@$core.Deprecated('Use withdrawalRequestResponseDescriptor instead')
const WithdrawalRequestResponse$json = {
  '1': 'WithdrawalRequestResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.savings.v1.WithdrawalObject', '10': 'data'},
  ],
};

/// Descriptor for `WithdrawalRequestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawalRequestResponseDescriptor = $convert.base64Decode(
    'ChlXaXRoZHJhd2FsUmVxdWVzdFJlc3BvbnNlEjAKBGRhdGEYASABKAsyHC5zYXZpbmdzLnYxLl'
    'dpdGhkcmF3YWxPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use withdrawalApproveRequestDescriptor instead')
const WithdrawalApproveRequest$json = {
  '1': 'WithdrawalApproveRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `WithdrawalApproveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawalApproveRequestDescriptor = $convert.base64Decode(
    'ChhXaXRoZHJhd2FsQXBwcm92ZVJlcXVlc3QSKwoCaWQYASABKAlCG7pIGHIWEAMYKDIQWzAtOW'
    'Etel8tXXszLDQwfVICaWQ=');

@$core.Deprecated('Use withdrawalApproveResponseDescriptor instead')
const WithdrawalApproveResponse$json = {
  '1': 'WithdrawalApproveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.savings.v1.WithdrawalObject', '10': 'data'},
  ],
};

/// Descriptor for `WithdrawalApproveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawalApproveResponseDescriptor = $convert.base64Decode(
    'ChlXaXRoZHJhd2FsQXBwcm92ZVJlc3BvbnNlEjAKBGRhdGEYASABKAsyHC5zYXZpbmdzLnYxLl'
    'dpdGhkcmF3YWxPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use withdrawalGetRequestDescriptor instead')
const WithdrawalGetRequest$json = {
  '1': 'WithdrawalGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `WithdrawalGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawalGetRequestDescriptor = $convert.base64Decode(
    'ChRXaXRoZHJhd2FsR2V0UmVxdWVzdBIrCgJpZBgBIAEoCUIbukgYchYQAxgoMhBbMC05YS16Xy'
    '1dezMsNDB9UgJpZA==');

@$core.Deprecated('Use withdrawalGetResponseDescriptor instead')
const WithdrawalGetResponse$json = {
  '1': 'WithdrawalGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.savings.v1.WithdrawalObject', '10': 'data'},
  ],
};

/// Descriptor for `WithdrawalGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawalGetResponseDescriptor = $convert.base64Decode(
    'ChVXaXRoZHJhd2FsR2V0UmVzcG9uc2USMAoEZGF0YRgBIAEoCzIcLnNhdmluZ3MudjEuV2l0aG'
    'RyYXdhbE9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use withdrawalSearchRequestDescriptor instead')
const WithdrawalSearchRequest$json = {
  '1': 'WithdrawalSearchRequest',
  '2': [
    {'1': 'savings_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'savingsAccountId'},
    {'1': 'status', '3': 2, '4': 1, '5': 14, '6': '.savings.v1.WithdrawalStatus', '10': 'status'},
    {'1': 'cursor', '3': 3, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `WithdrawalSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawalSearchRequestDescriptor = $convert.base64Decode(
    'ChdXaXRoZHJhd2FsU2VhcmNoUmVxdWVzdBI3ChJzYXZpbmdzX2FjY291bnRfaWQYASABKAlCCb'
    'pIBnIEEAMYKFIQc2F2aW5nc0FjY291bnRJZBI0CgZzdGF0dXMYAiABKA4yHC5zYXZpbmdzLnYx'
    'LldpdGhkcmF3YWxTdGF0dXNSBnN0YXR1cxItCgZjdXJzb3IYAyABKAsyFS5jb21tb24udjEuUG'
    'FnZUN1cnNvclIGY3Vyc29y');

@$core.Deprecated('Use withdrawalSearchResponseDescriptor instead')
const WithdrawalSearchResponse$json = {
  '1': 'WithdrawalSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.savings.v1.WithdrawalObject', '10': 'data'},
  ],
};

/// Descriptor for `WithdrawalSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawalSearchResponseDescriptor = $convert.base64Decode(
    'ChhXaXRoZHJhd2FsU2VhcmNoUmVzcG9uc2USMAoEZGF0YRgBIAMoCzIcLnNhdmluZ3MudjEuV2'
    'l0aGRyYXdhbE9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use interestAccrualGetRequestDescriptor instead')
const InterestAccrualGetRequest$json = {
  '1': 'InterestAccrualGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `InterestAccrualGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List interestAccrualGetRequestDescriptor = $convert.base64Decode(
    'ChlJbnRlcmVzdEFjY3J1YWxHZXRSZXF1ZXN0EisKAmlkGAEgASgJQhu6SBhyFhADGCgyEFswLT'
    'lhLXpfLV17Myw0MH1SAmlk');

@$core.Deprecated('Use interestAccrualGetResponseDescriptor instead')
const InterestAccrualGetResponse$json = {
  '1': 'InterestAccrualGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.savings.v1.InterestAccrualObject', '10': 'data'},
  ],
};

/// Descriptor for `InterestAccrualGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List interestAccrualGetResponseDescriptor = $convert.base64Decode(
    'ChpJbnRlcmVzdEFjY3J1YWxHZXRSZXNwb25zZRI1CgRkYXRhGAEgASgLMiEuc2F2aW5ncy52MS'
    '5JbnRlcmVzdEFjY3J1YWxPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use interestAccrualSearchRequestDescriptor instead')
const InterestAccrualSearchRequest$json = {
  '1': 'InterestAccrualSearchRequest',
  '2': [
    {'1': 'savings_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'savingsAccountId'},
    {'1': 'cursor', '3': 2, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `InterestAccrualSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List interestAccrualSearchRequestDescriptor = $convert.base64Decode(
    'ChxJbnRlcmVzdEFjY3J1YWxTZWFyY2hSZXF1ZXN0EjcKEnNhdmluZ3NfYWNjb3VudF9pZBgBIA'
    'EoCUIJukgGcgQQAxgoUhBzYXZpbmdzQWNjb3VudElkEi0KBmN1cnNvchgCIAEoCzIVLmNvbW1v'
    'bi52MS5QYWdlQ3Vyc29yUgZjdXJzb3I=');

@$core.Deprecated('Use interestAccrualSearchResponseDescriptor instead')
const InterestAccrualSearchResponse$json = {
  '1': 'InterestAccrualSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.savings.v1.InterestAccrualObject', '10': 'data'},
  ],
};

/// Descriptor for `InterestAccrualSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List interestAccrualSearchResponseDescriptor = $convert.base64Decode(
    'Ch1JbnRlcmVzdEFjY3J1YWxTZWFyY2hSZXNwb25zZRI1CgRkYXRhGAEgAygLMiEuc2F2aW5ncy'
    '52MS5JbnRlcmVzdEFjY3J1YWxPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use savingsBalanceGetRequestDescriptor instead')
const SavingsBalanceGetRequest$json = {
  '1': 'SavingsBalanceGetRequest',
  '2': [
    {'1': 'savings_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'savingsAccountId'},
  ],
};

/// Descriptor for `SavingsBalanceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsBalanceGetRequestDescriptor = $convert.base64Decode(
    'ChhTYXZpbmdzQmFsYW5jZUdldFJlcXVlc3QSNwoSc2F2aW5nc19hY2NvdW50X2lkGAEgASgJQg'
    'm6SAZyBBADGChSEHNhdmluZ3NBY2NvdW50SWQ=');

@$core.Deprecated('Use savingsBalanceGetResponseDescriptor instead')
const SavingsBalanceGetResponse$json = {
  '1': 'SavingsBalanceGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.savings.v1.SavingsBalanceObject', '10': 'data'},
  ],
};

/// Descriptor for `SavingsBalanceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsBalanceGetResponseDescriptor = $convert.base64Decode(
    'ChlTYXZpbmdzQmFsYW5jZUdldFJlc3BvbnNlEjQKBGRhdGEYASABKAsyIC5zYXZpbmdzLnYxLl'
    'NhdmluZ3NCYWxhbmNlT2JqZWN0UgRkYXRh');

@$core.Deprecated('Use savingsStatementRequestDescriptor instead')
const SavingsStatementRequest$json = {
  '1': 'SavingsStatementRequest',
  '2': [
    {'1': 'savings_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'savingsAccountId'},
    {'1': 'from_date', '3': 2, '4': 1, '5': 9, '10': 'fromDate'},
    {'1': 'to_date', '3': 3, '4': 1, '5': 9, '10': 'toDate'},
  ],
};

/// Descriptor for `SavingsStatementRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsStatementRequestDescriptor = $convert.base64Decode(
    'ChdTYXZpbmdzU3RhdGVtZW50UmVxdWVzdBI3ChJzYXZpbmdzX2FjY291bnRfaWQYASABKAlCCb'
    'pIBnIEEAMYKFIQc2F2aW5nc0FjY291bnRJZBIbCglmcm9tX2RhdGUYAiABKAlSCGZyb21EYXRl'
    'EhcKB3RvX2RhdGUYAyABKAlSBnRvRGF0ZQ==');

@$core.Deprecated('Use savingsStatementResponseDescriptor instead')
const SavingsStatementResponse$json = {
  '1': 'SavingsStatementResponse',
  '2': [
    {'1': 'account', '3': 1, '4': 1, '5': 11, '6': '.savings.v1.SavingsAccountObject', '10': 'account'},
    {'1': 'balance', '3': 2, '4': 1, '5': 11, '6': '.savings.v1.SavingsBalanceObject', '10': 'balance'},
    {'1': 'entries', '3': 3, '4': 3, '5': 11, '6': '.savings.v1.SavingsStatementEntry', '10': 'entries'},
  ],
};

/// Descriptor for `SavingsStatementResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savingsStatementResponseDescriptor = $convert.base64Decode(
    'ChhTYXZpbmdzU3RhdGVtZW50UmVzcG9uc2USOgoHYWNjb3VudBgBIAEoCzIgLnNhdmluZ3Mudj'
    'EuU2F2aW5nc0FjY291bnRPYmplY3RSB2FjY291bnQSOgoHYmFsYW5jZRgCIAEoCzIgLnNhdmlu'
    'Z3MudjEuU2F2aW5nc0JhbGFuY2VPYmplY3RSB2JhbGFuY2USOwoHZW50cmllcxgDIAMoCzIhLn'
    'NhdmluZ3MudjEuU2F2aW5nc1N0YXRlbWVudEVudHJ5UgdlbnRyaWVz');

const $core.Map<$core.String, $core.dynamic> SavingsServiceBase$json = {
  '1': 'SavingsService',
  '2': [
    {'1': 'SavingsProductSave', '2': '.savings.v1.SavingsProductSaveRequest', '3': '.savings.v1.SavingsProductSaveResponse', '4': {}},
    {
      '1': 'SavingsProductGet',
      '2': '.savings.v1.SavingsProductGetRequest',
      '3': '.savings.v1.SavingsProductGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'SavingsProductSearch',
      '2': '.savings.v1.SavingsProductSearchRequest',
      '3': '.savings.v1.SavingsProductSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'SavingsAccountCreate', '2': '.savings.v1.SavingsAccountCreateRequest', '3': '.savings.v1.SavingsAccountCreateResponse', '4': {}},
    {
      '1': 'SavingsAccountGet',
      '2': '.savings.v1.SavingsAccountGetRequest',
      '3': '.savings.v1.SavingsAccountGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'SavingsAccountSearch',
      '2': '.savings.v1.SavingsAccountSearchRequest',
      '3': '.savings.v1.SavingsAccountSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'SavingsAccountFreeze', '2': '.savings.v1.SavingsAccountFreezeRequest', '3': '.savings.v1.SavingsAccountFreezeResponse', '4': {}},
    {'1': 'SavingsAccountClose', '2': '.savings.v1.SavingsAccountCloseRequest', '3': '.savings.v1.SavingsAccountCloseResponse', '4': {}},
    {'1': 'DepositRecord', '2': '.savings.v1.DepositRecordRequest', '3': '.savings.v1.DepositRecordResponse', '4': {}},
    {
      '1': 'DepositGet',
      '2': '.savings.v1.DepositGetRequest',
      '3': '.savings.v1.DepositGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'DepositSearch',
      '2': '.savings.v1.DepositSearchRequest',
      '3': '.savings.v1.DepositSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'WithdrawalRequest', '2': '.savings.v1.WithdrawalRequestRequest', '3': '.savings.v1.WithdrawalRequestResponse', '4': {}},
    {'1': 'WithdrawalApprove', '2': '.savings.v1.WithdrawalApproveRequest', '3': '.savings.v1.WithdrawalApproveResponse', '4': {}},
    {
      '1': 'WithdrawalGet',
      '2': '.savings.v1.WithdrawalGetRequest',
      '3': '.savings.v1.WithdrawalGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'WithdrawalSearch',
      '2': '.savings.v1.WithdrawalSearchRequest',
      '3': '.savings.v1.WithdrawalSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {
      '1': 'InterestAccrualGet',
      '2': '.savings.v1.InterestAccrualGetRequest',
      '3': '.savings.v1.InterestAccrualGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'InterestAccrualSearch',
      '2': '.savings.v1.InterestAccrualSearchRequest',
      '3': '.savings.v1.InterestAccrualSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {
      '1': 'SavingsBalanceGet',
      '2': '.savings.v1.SavingsBalanceGetRequest',
      '3': '.savings.v1.SavingsBalanceGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'SavingsStatement',
      '2': '.savings.v1.SavingsStatementRequest',
      '3': '.savings.v1.SavingsStatementResponse',
      '4': {'34': 1},
    },
  ],
};

@$core.Deprecated('Use savingsServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> SavingsServiceBase$messageJson = {
  '.savings.v1.SavingsProductSaveRequest': SavingsProductSaveRequest$json,
  '.savings.v1.SavingsProductObject': SavingsProductObject$json,
  '.google.type.Money': $9.Money$json,
  '.google.protobuf.Struct': $6.Struct$json,
  '.google.protobuf.Struct.FieldsEntry': $6.Struct_FieldsEntry$json,
  '.google.protobuf.Value': $6.Value$json,
  '.google.protobuf.ListValue': $6.ListValue$json,
  '.savings.v1.SavingsProductSaveResponse': SavingsProductSaveResponse$json,
  '.savings.v1.SavingsProductGetRequest': SavingsProductGetRequest$json,
  '.savings.v1.SavingsProductGetResponse': SavingsProductGetResponse$json,
  '.savings.v1.SavingsProductSearchRequest': SavingsProductSearchRequest$json,
  '.common.v1.PageCursor': $7.PageCursor$json,
  '.savings.v1.SavingsProductSearchResponse': SavingsProductSearchResponse$json,
  '.savings.v1.SavingsAccountCreateRequest': SavingsAccountCreateRequest$json,
  '.savings.v1.SavingsAccountObject': SavingsAccountObject$json,
  '.savings.v1.SavingsAccountCreateResponse': SavingsAccountCreateResponse$json,
  '.savings.v1.SavingsAccountGetRequest': SavingsAccountGetRequest$json,
  '.savings.v1.SavingsAccountGetResponse': SavingsAccountGetResponse$json,
  '.savings.v1.SavingsAccountSearchRequest': SavingsAccountSearchRequest$json,
  '.savings.v1.SavingsAccountSearchResponse': SavingsAccountSearchResponse$json,
  '.savings.v1.SavingsAccountFreezeRequest': SavingsAccountFreezeRequest$json,
  '.savings.v1.SavingsAccountFreezeResponse': SavingsAccountFreezeResponse$json,
  '.savings.v1.SavingsAccountCloseRequest': SavingsAccountCloseRequest$json,
  '.savings.v1.SavingsAccountCloseResponse': SavingsAccountCloseResponse$json,
  '.savings.v1.DepositRecordRequest': DepositRecordRequest$json,
  '.savings.v1.DepositRecordResponse': DepositRecordResponse$json,
  '.savings.v1.DepositObject': DepositObject$json,
  '.savings.v1.DepositGetRequest': DepositGetRequest$json,
  '.savings.v1.DepositGetResponse': DepositGetResponse$json,
  '.savings.v1.DepositSearchRequest': DepositSearchRequest$json,
  '.savings.v1.DepositSearchResponse': DepositSearchResponse$json,
  '.savings.v1.WithdrawalRequestRequest': WithdrawalRequestRequest$json,
  '.savings.v1.WithdrawalRequestResponse': WithdrawalRequestResponse$json,
  '.savings.v1.WithdrawalObject': WithdrawalObject$json,
  '.savings.v1.WithdrawalApproveRequest': WithdrawalApproveRequest$json,
  '.savings.v1.WithdrawalApproveResponse': WithdrawalApproveResponse$json,
  '.savings.v1.WithdrawalGetRequest': WithdrawalGetRequest$json,
  '.savings.v1.WithdrawalGetResponse': WithdrawalGetResponse$json,
  '.savings.v1.WithdrawalSearchRequest': WithdrawalSearchRequest$json,
  '.savings.v1.WithdrawalSearchResponse': WithdrawalSearchResponse$json,
  '.savings.v1.InterestAccrualGetRequest': InterestAccrualGetRequest$json,
  '.savings.v1.InterestAccrualGetResponse': InterestAccrualGetResponse$json,
  '.savings.v1.InterestAccrualObject': InterestAccrualObject$json,
  '.savings.v1.InterestAccrualSearchRequest': InterestAccrualSearchRequest$json,
  '.savings.v1.InterestAccrualSearchResponse': InterestAccrualSearchResponse$json,
  '.savings.v1.SavingsBalanceGetRequest': SavingsBalanceGetRequest$json,
  '.savings.v1.SavingsBalanceGetResponse': SavingsBalanceGetResponse$json,
  '.savings.v1.SavingsBalanceObject': SavingsBalanceObject$json,
  '.savings.v1.SavingsStatementRequest': SavingsStatementRequest$json,
  '.savings.v1.SavingsStatementResponse': SavingsStatementResponse$json,
  '.savings.v1.SavingsStatementEntry': SavingsStatementEntry$json,
};

/// Descriptor for `SavingsService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List savingsServiceDescriptor = $convert.base64Decode(
    'Cg5TYXZpbmdzU2VydmljZRKqAgoSU2F2aW5nc1Byb2R1Y3RTYXZlEiUuc2F2aW5ncy52MS5TYX'
    'ZpbmdzUHJvZHVjdFNhdmVSZXF1ZXN0GiYuc2F2aW5ncy52MS5TYXZpbmdzUHJvZHVjdFNhdmVS'
    'ZXNwb25zZSLEAbpHwAEKD1NhdmluZ3NQcm9kdWN0cxIiQ3JlYXRlIG9yIHVwZGF0ZSBhIHNhdm'
    'luZ3MgcHJvZHVjdBp1Q3JlYXRlcyBhIG5ldyBzYXZpbmdzIHByb2R1Y3Qgb3IgdXBkYXRlcyBh'
    'biBleGlzdGluZyBvbmUuIFNhdmluZ3MgcHJvZHVjdHMgZGVmaW5lIHRlcm1zLCByYXRlcywgYW'
    '5kIHdpdGhkcmF3YWwgcnVsZXMuKhJzYXZpbmdzUHJvZHVjdFNhdmUS6AEKEVNhdmluZ3NQcm9k'
    'dWN0R2V0EiQuc2F2aW5ncy52MS5TYXZpbmdzUHJvZHVjdEdldFJlcXVlc3QaJS5zYXZpbmdzLn'
    'YxLlNhdmluZ3NQcm9kdWN0R2V0UmVzcG9uc2UihQGQAgG6R38KD1NhdmluZ3NQcm9kdWN0cxIb'
    'R2V0IGEgc2F2aW5ncyBwcm9kdWN0IGJ5IElEGjxSZXRyaWV2ZXMgYSBzYXZpbmdzIHByb2R1Y3'
    'QgcmVjb3JkIGJ5IGl0cyB1bmlxdWUgaWRlbnRpZmllci4qEXNhdmluZ3NQcm9kdWN0R2V0EvAB'
    'ChRTYXZpbmdzUHJvZHVjdFNlYXJjaBInLnNhdmluZ3MudjEuU2F2aW5nc1Byb2R1Y3RTZWFyY2'
    'hSZXF1ZXN0Giguc2F2aW5ncy52MS5TYXZpbmdzUHJvZHVjdFNlYXJjaFJlc3BvbnNlIoIBkAIB'
    'ukd8Cg9TYXZpbmdzUHJvZHVjdHMSF1NlYXJjaCBzYXZpbmdzIHByb2R1Y3RzGjpTZWFyY2hlcy'
    'Bmb3Igc2F2aW5ncyBwcm9kdWN0cyBtYXRjaGluZyBzcGVjaWZpZWQgY3JpdGVyaWEuKhRzYXZp'
    'bmdzUHJvZHVjdFNlYXJjaDABEuoBChRTYXZpbmdzQWNjb3VudENyZWF0ZRInLnNhdmluZ3Mudj'
    'EuU2F2aW5nc0FjY291bnRDcmVhdGVSZXF1ZXN0Giguc2F2aW5ncy52MS5TYXZpbmdzQWNjb3Vu'
    'dENyZWF0ZVJlc3BvbnNlIn+6R3wKD1NhdmluZ3NBY2NvdW50cxIYQ3JlYXRlIGEgc2F2aW5ncy'
    'BhY2NvdW50GjlDcmVhdGVzIGEgbmV3IHNhdmluZ3MgYWNjb3VudCBmb3IgYW4gaW5kaXZpZHVh'
    'bCBvciBncm91cC4qFHNhdmluZ3NBY2NvdW50Q3JlYXRlEugBChFTYXZpbmdzQWNjb3VudEdldB'
    'IkLnNhdmluZ3MudjEuU2F2aW5nc0FjY291bnRHZXRSZXF1ZXN0GiUuc2F2aW5ncy52MS5TYXZp'
    'bmdzQWNjb3VudEdldFJlc3BvbnNlIoUBkAIBukd/Cg9TYXZpbmdzQWNjb3VudHMSG0dldCBhIH'
    'NhdmluZ3MgYWNjb3VudCBieSBJRBo8UmV0cmlldmVzIGEgc2F2aW5ncyBhY2NvdW50IHJlY29y'
    'ZCBieSBpdHMgdW5pcXVlIGlkZW50aWZpZXIuKhFzYXZpbmdzQWNjb3VudEdldBKNAgoUU2F2aW'
    '5nc0FjY291bnRTZWFyY2gSJy5zYXZpbmdzLnYxLlNhdmluZ3NBY2NvdW50U2VhcmNoUmVxdWVz'
    'dBooLnNhdmluZ3MudjEuU2F2aW5nc0FjY291bnRTZWFyY2hSZXNwb25zZSKfAZACAbpHmAEKD1'
    'NhdmluZ3NBY2NvdW50cxIXU2VhcmNoIHNhdmluZ3MgYWNjb3VudHMaVlNlYXJjaGVzIGZvciBz'
    'YXZpbmdzIGFjY291bnRzLiBTdXBwb3J0cyBmaWx0ZXJpbmcgYnkgb3duZXIsIHByb2R1Y3QsIG'
    'JhbmssIGFuZCBzdGF0dXMuKhRzYXZpbmdzQWNjb3VudFNlYXJjaDABEvIBChRTYXZpbmdzQWNj'
    'b3VudEZyZWV6ZRInLnNhdmluZ3MudjEuU2F2aW5nc0FjY291bnRGcmVlemVSZXF1ZXN0Giguc2'
    'F2aW5ncy52MS5TYXZpbmdzQWNjb3VudEZyZWV6ZVJlc3BvbnNlIoYBukeCAQoPU2F2aW5nc0Fj'
    'Y291bnRzEhhGcmVlemUgYSBzYXZpbmdzIGFjY291bnQaP0ZyZWV6ZXMgYSBzYXZpbmdzIGFjY2'
    '91bnQsIHByZXZlbnRpbmcgZGVwb3NpdHMgYW5kIHdpdGhkcmF3YWxzLioUc2F2aW5nc0FjY291'
    'bnRGcmVlemUS0QEKE1NhdmluZ3NBY2NvdW50Q2xvc2USJi5zYXZpbmdzLnYxLlNhdmluZ3NBY2'
    'NvdW50Q2xvc2VSZXF1ZXN0Gicuc2F2aW5ncy52MS5TYXZpbmdzQWNjb3VudENsb3NlUmVzcG9u'
    'c2UiabpHZgoPU2F2aW5nc0FjY291bnRzEhdDbG9zZSBhIHNhdmluZ3MgYWNjb3VudBolQ2xvc2'
    'VzIGEgc2F2aW5ncyBhY2NvdW50IHBlcm1hbmVudGx5LioTc2F2aW5nc0FjY291bnRDbG9zZRKv'
    'AQoNRGVwb3NpdFJlY29yZBIgLnNhdmluZ3MudjEuRGVwb3NpdFJlY29yZFJlcXVlc3QaIS5zYX'
    'ZpbmdzLnYxLkRlcG9zaXRSZWNvcmRSZXNwb25zZSJZukdWCghEZXBvc2l0cxIQUmVjb3JkIGEg'
    'ZGVwb3NpdBopUmVjb3JkcyBhIGRlcG9zaXQgaW50byBhIHNhdmluZ3MgYWNjb3VudC4qDWRlcG'
    '9zaXRSZWNvcmQStAEKCkRlcG9zaXRHZXQSHS5zYXZpbmdzLnYxLkRlcG9zaXRHZXRSZXF1ZXN0'
    'Gh4uc2F2aW5ncy52MS5EZXBvc2l0R2V0UmVzcG9uc2UiZ5ACAbpHYQoIRGVwb3NpdHMSE0dldC'
    'BhIGRlcG9zaXQgYnkgSUQaNFJldHJpZXZlcyBhIGRlcG9zaXQgcmVjb3JkIGJ5IGl0cyB1bmlx'
    'dWUgaWRlbnRpZmllci4qCmRlcG9zaXRHZXQStgEKDURlcG9zaXRTZWFyY2gSIC5zYXZpbmdzLn'
    'YxLkRlcG9zaXRTZWFyY2hSZXF1ZXN0GiEuc2F2aW5ncy52MS5EZXBvc2l0U2VhcmNoUmVzcG9u'
    'c2UiXpACAbpHWAoIRGVwb3NpdHMSD1NlYXJjaCBkZXBvc2l0cxosU2VhcmNoZXMgZm9yIGRlcG'
    '9zaXRzIGZvciBhIHNhdmluZ3MgYWNjb3VudC4qDWRlcG9zaXRTZWFyY2gwARL8AQoRV2l0aGRy'
    'YXdhbFJlcXVlc3QSJC5zYXZpbmdzLnYxLldpdGhkcmF3YWxSZXF1ZXN0UmVxdWVzdBolLnNhdm'
    'luZ3MudjEuV2l0aGRyYXdhbFJlcXVlc3RSZXNwb25zZSKZAbpHlQEKC1dpdGhkcmF3YWxzEhRS'
    'ZXF1ZXN0IGEgd2l0aGRyYXdhbBpdUmVxdWVzdHMgYSB3aXRoZHJhd2FsIGZyb20gYSBzYXZpbm'
    'dzIGFjY291bnQuIE1heSByZXF1aXJlIGFwcHJvdmFsIGJhc2VkIG9uIHdpdGhkcmF3YWwgcnVs'
    'ZXMuKhF3aXRoZHJhd2FsUmVxdWVzdBLDAQoRV2l0aGRyYXdhbEFwcHJvdmUSJC5zYXZpbmdzLn'
    'YxLldpdGhkcmF3YWxBcHByb3ZlUmVxdWVzdBolLnNhdmluZ3MudjEuV2l0aGRyYXdhbEFwcHJv'
    'dmVSZXNwb25zZSJhukdeCgtXaXRoZHJhd2FscxIUQXBwcm92ZSBhIHdpdGhkcmF3YWwaJkFwcH'
    'JvdmVzIGEgcGVuZGluZyB3aXRoZHJhd2FsIHJlcXVlc3QuKhF3aXRoZHJhd2FsQXBwcm92ZRLJ'
    'AQoNV2l0aGRyYXdhbEdldBIgLnNhdmluZ3MudjEuV2l0aGRyYXdhbEdldFJlcXVlc3QaIS5zYX'
    'ZpbmdzLnYxLldpdGhkcmF3YWxHZXRSZXNwb25zZSJzkAIBukdtCgtXaXRoZHJhd2FscxIWR2V0'
    'IGEgd2l0aGRyYXdhbCBieSBJRBo3UmV0cmlldmVzIGEgd2l0aGRyYXdhbCByZWNvcmQgYnkgaX'
    'RzIHVuaXF1ZSBpZGVudGlmaWVyLioNd2l0aGRyYXdhbEdldBLLAQoQV2l0aGRyYXdhbFNlYXJj'
    'aBIjLnNhdmluZ3MudjEuV2l0aGRyYXdhbFNlYXJjaFJlcXVlc3QaJC5zYXZpbmdzLnYxLldpdG'
    'hkcmF3YWxTZWFyY2hSZXNwb25zZSJqkAIBukdkCgtXaXRoZHJhd2FscxISU2VhcmNoIHdpdGhk'
    'cmF3YWxzGi9TZWFyY2hlcyBmb3Igd2l0aGRyYXdhbHMgZm9yIGEgc2F2aW5ncyBhY2NvdW50Li'
    'oQd2l0aGRyYXdhbFNlYXJjaDABEvIBChJJbnRlcmVzdEFjY3J1YWxHZXQSJS5zYXZpbmdzLnYx'
    'LkludGVyZXN0QWNjcnVhbEdldFJlcXVlc3QaJi5zYXZpbmdzLnYxLkludGVyZXN0QWNjcnVhbE'
    'dldFJlc3BvbnNlIowBkAIBukeFAQoQSW50ZXJlc3RBY2NydWFscxIdR2V0IGFuIGludGVyZXN0'
    'IGFjY3J1YWwgYnkgSUQaPlJldHJpZXZlcyBhbiBpbnRlcmVzdCBhY2NydWFsIHJlY29yZCBieS'
    'BpdHMgdW5pcXVlIGlkZW50aWZpZXIuKhJpbnRlcmVzdEFjY3J1YWxHZXQS+QEKFUludGVyZXN0'
    'QWNjcnVhbFNlYXJjaBIoLnNhdmluZ3MudjEuSW50ZXJlc3RBY2NydWFsU2VhcmNoUmVxdWVzdB'
    'opLnNhdmluZ3MudjEuSW50ZXJlc3RBY2NydWFsU2VhcmNoUmVzcG9uc2UiiAGQAgG6R4EBChBJ'
    'bnRlcmVzdEFjY3J1YWxzEhhTZWFyY2ggaW50ZXJlc3QgYWNjcnVhbHMaPFNlYXJjaGVzIGZvci'
    'BpbnRlcmVzdCBhY2NydWFsIHJlY29yZHMgZm9yIGEgc2F2aW5ncyBhY2NvdW50LioVaW50ZXJl'
    'c3RBY2NydWFsU2VhcmNoMAES1wEKEVNhdmluZ3NCYWxhbmNlR2V0EiQuc2F2aW5ncy52MS5TYX'
    'ZpbmdzQmFsYW5jZUdldFJlcXVlc3QaJS5zYXZpbmdzLnYxLlNhdmluZ3NCYWxhbmNlR2V0UmVz'
    'cG9uc2UidZACAbpHbwoPU2F2aW5nc0FjY291bnRzEhNHZXQgc2F2aW5ncyBiYWxhbmNlGjRSZX'
    'RyaWV2ZXMgdGhlIGN1cnJlbnQgYmFsYW5jZSBmb3IgYSBzYXZpbmdzIGFjY291bnQuKhFzYXZp'
    'bmdzQmFsYW5jZUdldBL0AQoQU2F2aW5nc1N0YXRlbWVudBIjLnNhdmluZ3MudjEuU2F2aW5nc1'
    'N0YXRlbWVudFJlcXVlc3QaJC5zYXZpbmdzLnYxLlNhdmluZ3NTdGF0ZW1lbnRSZXNwb25zZSKU'
    'AZACAbpHjQEKD1NhdmluZ3NBY2NvdW50cxIVR2V0IHNhdmluZ3Mgc3RhdGVtZW50GlFHZW5lcm'
    'F0ZXMgYSBzYXZpbmdzIHN0YXRlbWVudCB3aXRoIGFsbCB0cmFuc2FjdGlvbnMgZm9yIHRoZSBz'
    'cGVjaWZpZWQgZGF0ZSByYW5nZS4qEHNhdmluZ3NTdGF0ZW1lbnQ=');

