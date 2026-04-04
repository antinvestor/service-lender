//
//  Generated code. Do not modify.
//  source: loans/v1/loans.proto
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

@$core.Deprecated('Use loanStatusDescriptor instead')
const LoanStatus$json = {
  '1': 'LoanStatus',
  '2': [
    {'1': 'LOAN_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'LOAN_STATUS_PENDING_DISBURSEMENT', '2': 1},
    {'1': 'LOAN_STATUS_ACTIVE', '2': 2},
    {'1': 'LOAN_STATUS_DELINQUENT', '2': 3},
    {'1': 'LOAN_STATUS_DEFAULT', '2': 4},
    {'1': 'LOAN_STATUS_PAID_OFF', '2': 5},
    {'1': 'LOAN_STATUS_RESTRUCTURED', '2': 6},
    {'1': 'LOAN_STATUS_WRITTEN_OFF', '2': 7},
    {'1': 'LOAN_STATUS_CLOSED', '2': 8},
  ],
};

/// Descriptor for `LoanStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List loanStatusDescriptor = $convert.base64Decode(
    'CgpMb2FuU3RhdHVzEhsKF0xPQU5fU1RBVFVTX1VOU1BFQ0lGSUVEEAASJAogTE9BTl9TVEFUVV'
    'NfUEVORElOR19ESVNCVVJTRU1FTlQQARIWChJMT0FOX1NUQVRVU19BQ1RJVkUQAhIaChZMT0FO'
    'X1NUQVRVU19ERUxJTlFVRU5UEAMSFwoTTE9BTl9TVEFUVVNfREVGQVVMVBAEEhgKFExPQU5fU1'
    'RBVFVTX1BBSURfT0ZGEAUSHAoYTE9BTl9TVEFUVVNfUkVTVFJVQ1RVUkVEEAYSGwoXTE9BTl9T'
    'VEFUVVNfV1JJVFRFTl9PRkYQBxIWChJMT0FOX1NUQVRVU19DTE9TRUQQCA==');

@$core.Deprecated('Use disbursementStatusDescriptor instead')
const DisbursementStatus$json = {
  '1': 'DisbursementStatus',
  '2': [
    {'1': 'DISBURSEMENT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'DISBURSEMENT_STATUS_PENDING', '2': 1},
    {'1': 'DISBURSEMENT_STATUS_PROCESSING', '2': 2},
    {'1': 'DISBURSEMENT_STATUS_COMPLETED', '2': 3},
    {'1': 'DISBURSEMENT_STATUS_FAILED', '2': 4},
    {'1': 'DISBURSEMENT_STATUS_REVERSED', '2': 5},
  ],
};

/// Descriptor for `DisbursementStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List disbursementStatusDescriptor = $convert.base64Decode(
    'ChJEaXNidXJzZW1lbnRTdGF0dXMSIwofRElTQlVSU0VNRU5UX1NUQVRVU19VTlNQRUNJRklFRB'
    'AAEh8KG0RJU0JVUlNFTUVOVF9TVEFUVVNfUEVORElORxABEiIKHkRJU0JVUlNFTUVOVF9TVEFU'
    'VVNfUFJPQ0VTU0lORxACEiEKHURJU0JVUlNFTUVOVF9TVEFUVVNfQ09NUExFVEVEEAMSHgoaRE'
    'lTQlVSU0VNRU5UX1NUQVRVU19GQUlMRUQQBBIgChxESVNCVVJTRU1FTlRfU1RBVFVTX1JFVkVS'
    'U0VEEAU=');

@$core.Deprecated('Use repaymentStatusDescriptor instead')
const RepaymentStatus$json = {
  '1': 'RepaymentStatus',
  '2': [
    {'1': 'REPAYMENT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'REPAYMENT_STATUS_PENDING', '2': 1},
    {'1': 'REPAYMENT_STATUS_MATCHED', '2': 2},
    {'1': 'REPAYMENT_STATUS_PARTIAL', '2': 3},
    {'1': 'REPAYMENT_STATUS_OVERPAYMENT', '2': 4},
    {'1': 'REPAYMENT_STATUS_REVERSED', '2': 5},
  ],
};

/// Descriptor for `RepaymentStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List repaymentStatusDescriptor = $convert.base64Decode(
    'Cg9SZXBheW1lbnRTdGF0dXMSIAocUkVQQVlNRU5UX1NUQVRVU19VTlNQRUNJRklFRBAAEhwKGF'
    'JFUEFZTUVOVF9TVEFUVVNfUEVORElORxABEhwKGFJFUEFZTUVOVF9TVEFUVVNfTUFUQ0hFRBAC'
    'EhwKGFJFUEFZTUVOVF9TVEFUVVNfUEFSVElBTBADEiAKHFJFUEFZTUVOVF9TVEFUVVNfT1ZFUl'
    'BBWU1FTlQQBBIdChlSRVBBWU1FTlRfU1RBVFVTX1JFVkVSU0VEEAU=');

@$core.Deprecated('Use scheduleEntryStatusDescriptor instead')
const ScheduleEntryStatus$json = {
  '1': 'ScheduleEntryStatus',
  '2': [
    {'1': 'SCHEDULE_ENTRY_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'SCHEDULE_ENTRY_STATUS_UPCOMING', '2': 1},
    {'1': 'SCHEDULE_ENTRY_STATUS_DUE', '2': 2},
    {'1': 'SCHEDULE_ENTRY_STATUS_PAID', '2': 3},
    {'1': 'SCHEDULE_ENTRY_STATUS_PARTIAL', '2': 4},
    {'1': 'SCHEDULE_ENTRY_STATUS_OVERDUE', '2': 5},
    {'1': 'SCHEDULE_ENTRY_STATUS_WAIVED', '2': 6},
  ],
};

/// Descriptor for `ScheduleEntryStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List scheduleEntryStatusDescriptor = $convert.base64Decode(
    'ChNTY2hlZHVsZUVudHJ5U3RhdHVzEiUKIVNDSEVEVUxFX0VOVFJZX1NUQVRVU19VTlNQRUNJRk'
    'lFRBAAEiIKHlNDSEVEVUxFX0VOVFJZX1NUQVRVU19VUENPTUlORxABEh0KGVNDSEVEVUxFX0VO'
    'VFJZX1NUQVRVU19EVUUQAhIeChpTQ0hFRFVMRV9FTlRSWV9TVEFUVVNfUEFJRBADEiEKHVNDSE'
    'VEVUxFX0VOVFJZX1NUQVRVU19QQVJUSUFMEAQSIQodU0NIRURVTEVfRU5UUllfU1RBVFVTX09W'
    'RVJEVUUQBRIgChxTQ0hFRFVMRV9FTlRSWV9TVEFUVVNfV0FJVkVEEAY=');

@$core.Deprecated('Use penaltyTypeDescriptor instead')
const PenaltyType$json = {
  '1': 'PenaltyType',
  '2': [
    {'1': 'PENALTY_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'PENALTY_TYPE_LATE_PAYMENT', '2': 1},
    {'1': 'PENALTY_TYPE_DEFAULT', '2': 2},
    {'1': 'PENALTY_TYPE_EARLY_REPAYMENT', '2': 3},
    {'1': 'PENALTY_TYPE_BOUNCED_PAYMENT', '2': 4},
  ],
};

/// Descriptor for `PenaltyType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List penaltyTypeDescriptor = $convert.base64Decode(
    'CgtQZW5hbHR5VHlwZRIcChhQRU5BTFRZX1RZUEVfVU5TUEVDSUZJRUQQABIdChlQRU5BTFRZX1'
    'RZUEVfTEFURV9QQVlNRU5UEAESGAoUUEVOQUxUWV9UWVBFX0RFRkFVTFQQAhIgChxQRU5BTFRZ'
    'X1RZUEVfRUFSTFlfUkVQQVlNRU5UEAMSIAocUEVOQUxUWV9UWVBFX0JPVU5DRURfUEFZTUVOVB'
    'AE');

@$core.Deprecated('Use restructureTypeDescriptor instead')
const RestructureType$json = {
  '1': 'RestructureType',
  '2': [
    {'1': 'RESTRUCTURE_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'RESTRUCTURE_TYPE_RESCHEDULE', '2': 1},
    {'1': 'RESTRUCTURE_TYPE_REFINANCE', '2': 2},
    {'1': 'RESTRUCTURE_TYPE_RATE_CHANGE', '2': 3},
    {'1': 'RESTRUCTURE_TYPE_PARTIAL_WAIVER', '2': 4},
    {'1': 'RESTRUCTURE_TYPE_WRITE_OFF', '2': 5},
  ],
};

/// Descriptor for `RestructureType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List restructureTypeDescriptor = $convert.base64Decode(
    'Cg9SZXN0cnVjdHVyZVR5cGUSIAocUkVTVFJVQ1RVUkVfVFlQRV9VTlNQRUNJRklFRBAAEh8KG1'
    'JFU1RSVUNUVVJFX1RZUEVfUkVTQ0hFRFVMRRABEh4KGlJFU1RSVUNUVVJFX1RZUEVfUkVGSU5B'
    'TkNFEAISIAocUkVTVFJVQ1RVUkVfVFlQRV9SQVRFX0NIQU5HRRADEiMKH1JFU1RSVUNUVVJFX1'
    'RZUEVfUEFSVElBTF9XQUlWRVIQBBIeChpSRVNUUlVDVFVSRV9UWVBFX1dSSVRFX09GRhAF');

@$core.Deprecated('Use reconciliationStatusDescriptor instead')
const ReconciliationStatus$json = {
  '1': 'ReconciliationStatus',
  '2': [
    {'1': 'RECONCILIATION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'RECONCILIATION_STATUS_PENDING', '2': 1},
    {'1': 'RECONCILIATION_STATUS_MATCHED', '2': 2},
    {'1': 'RECONCILIATION_STATUS_UNMATCHED', '2': 3},
    {'1': 'RECONCILIATION_STATUS_DISPUTED', '2': 4},
  ],
};

/// Descriptor for `ReconciliationStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reconciliationStatusDescriptor = $convert.base64Decode(
    'ChRSZWNvbmNpbGlhdGlvblN0YXR1cxIlCiFSRUNPTkNJTElBVElPTl9TVEFUVVNfVU5TUEVDSU'
    'ZJRUQQABIhCh1SRUNPTkNJTElBVElPTl9TVEFUVVNfUEVORElORxABEiEKHVJFQ09OQ0lMSUFU'
    'SU9OX1NUQVRVU19NQVRDSEVEEAISIwofUkVDT05DSUxJQVRJT05fU1RBVFVTX1VOTUFUQ0hFRB'
    'ADEiIKHlJFQ09OQ0lMSUFUSU9OX1NUQVRVU19ESVNQVVRFRBAE');

@$core.Deprecated('Use interestMethodDescriptor instead')
const InterestMethod$json = {
  '1': 'InterestMethod',
  '2': [
    {'1': 'INTEREST_METHOD_UNSPECIFIED', '2': 0},
    {'1': 'INTEREST_METHOD_FLAT', '2': 1},
    {'1': 'INTEREST_METHOD_REDUCING_BALANCE', '2': 2},
    {'1': 'INTEREST_METHOD_COMPOUND', '2': 3},
  ],
};

/// Descriptor for `InterestMethod`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List interestMethodDescriptor = $convert.base64Decode(
    'Cg5JbnRlcmVzdE1ldGhvZBIfChtJTlRFUkVTVF9NRVRIT0RfVU5TUEVDSUZJRUQQABIYChRJTl'
    'RFUkVTVF9NRVRIT0RfRkxBVBABEiQKIElOVEVSRVNUX01FVEhPRF9SRURVQ0lOR19CQUxBTkNF'
    'EAISHAoYSU5URVJFU1RfTUVUSE9EX0NPTVBPVU5EEAM=');

@$core.Deprecated('Use repaymentFrequencyDescriptor instead')
const RepaymentFrequency$json = {
  '1': 'RepaymentFrequency',
  '2': [
    {'1': 'REPAYMENT_FREQUENCY_UNSPECIFIED', '2': 0},
    {'1': 'REPAYMENT_FREQUENCY_DAILY', '2': 1},
    {'1': 'REPAYMENT_FREQUENCY_WEEKLY', '2': 2},
    {'1': 'REPAYMENT_FREQUENCY_BIWEEKLY', '2': 3},
    {'1': 'REPAYMENT_FREQUENCY_MONTHLY', '2': 4},
    {'1': 'REPAYMENT_FREQUENCY_QUARTERLY', '2': 5},
  ],
};

/// Descriptor for `RepaymentFrequency`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List repaymentFrequencyDescriptor = $convert.base64Decode(
    'ChJSZXBheW1lbnRGcmVxdWVuY3kSIwofUkVQQVlNRU5UX0ZSRVFVRU5DWV9VTlNQRUNJRklFRB'
    'AAEh0KGVJFUEFZTUVOVF9GUkVRVUVOQ1lfREFJTFkQARIeChpSRVBBWU1FTlRfRlJFUVVFTkNZ'
    'X1dFRUtMWRACEiAKHFJFUEFZTUVOVF9GUkVRVUVOQ1lfQklXRUVLTFkQAxIfChtSRVBBWU1FTl'
    'RfRlJFUVVFTkNZX01PTlRITFkQBBIhCh1SRVBBWU1FTlRfRlJFUVVFTkNZX1FVQVJURVJMWRAF');

@$core.Deprecated('Use loanAccountObjectDescriptor instead')
const LoanAccountObject$json = {
  '1': 'LoanAccountObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'application_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'applicationId'},
    {'1': 'product_id', '3': 3, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'client_id', '3': 4, '4': 1, '5': 9, '10': 'clientId'},
    {'1': 'agent_id', '3': 5, '4': 1, '5': 9, '10': 'agentId'},
    {'1': 'branch_id', '3': 6, '4': 1, '5': 9, '10': 'branchId'},
    {'1': 'bank_id', '3': 7, '4': 1, '5': 9, '10': 'bankId'},
    {'1': 'status', '3': 8, '4': 1, '5': 14, '6': '.loans.v1.LoanStatus', '10': 'status'},
    {'1': 'principal_amount', '3': 10, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'principalAmount'},
    {'1': 'interest_rate', '3': 11, '4': 1, '5': 9, '10': 'interestRate'},
    {'1': 'term_days', '3': 12, '4': 1, '5': 5, '10': 'termDays'},
    {'1': 'interest_method', '3': 13, '4': 1, '5': 14, '6': '.loans.v1.InterestMethod', '10': 'interestMethod'},
    {'1': 'repayment_frequency', '3': 14, '4': 1, '5': 14, '6': '.loans.v1.RepaymentFrequency', '10': 'repaymentFrequency'},
    {'1': 'disbursed_at', '3': 15, '4': 1, '5': 9, '10': 'disbursedAt'},
    {'1': 'maturity_date', '3': 16, '4': 1, '5': 9, '10': 'maturityDate'},
    {'1': 'first_repayment_date', '3': 17, '4': 1, '5': 9, '10': 'firstRepaymentDate'},
    {'1': 'last_repayment_date', '3': 18, '4': 1, '5': 9, '10': 'lastRepaymentDate'},
    {'1': 'days_past_due', '3': 19, '4': 1, '5': 5, '10': 'daysPastDue'},
    {'1': 'ledger_asset_account_id', '3': 20, '4': 1, '5': 9, '10': 'ledgerAssetAccountId'},
    {'1': 'ledger_interest_income_account_id', '3': 21, '4': 1, '5': 9, '10': 'ledgerInterestIncomeAccountId'},
    {'1': 'ledger_fee_income_account_id', '3': 22, '4': 1, '5': 9, '10': 'ledgerFeeIncomeAccountId'},
    {'1': 'ledger_penalty_income_account_id', '3': 23, '4': 1, '5': 9, '10': 'ledgerPenaltyIncomeAccountId'},
    {'1': 'payment_account_ref', '3': 24, '4': 1, '5': 9, '10': 'paymentAccountRef'},
    {'1': 'properties', '3': 25, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `LoanAccountObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanAccountObjectDescriptor = $convert.base64Decode(
    'ChFMb2FuQWNjb3VudE9iamVjdBIuCgJpZBgBIAEoCUIeukgb2AEBchYQAxgoMhBbMC05YS16Xy'
    '1dezMsNDB9UgJpZBIwCg5hcHBsaWNhdGlvbl9pZBgCIAEoCUIJukgGcgQQAxgoUg1hcHBsaWNh'
    'dGlvbklkEh0KCnByb2R1Y3RfaWQYAyABKAlSCXByb2R1Y3RJZBIbCgljbGllbnRfaWQYBCABKA'
    'lSCGNsaWVudElkEhkKCGFnZW50X2lkGAUgASgJUgdhZ2VudElkEhsKCWJyYW5jaF9pZBgGIAEo'
    'CVIIYnJhbmNoSWQSFwoHYmFua19pZBgHIAEoCVIGYmFua0lkEiwKBnN0YXR1cxgIIAEoDjIULm'
    'xvYW5zLnYxLkxvYW5TdGF0dXNSBnN0YXR1cxI9ChBwcmluY2lwYWxfYW1vdW50GAogASgLMhIu'
    'Z29vZ2xlLnR5cGUuTW9uZXlSD3ByaW5jaXBhbEFtb3VudBIjCg1pbnRlcmVzdF9yYXRlGAsgAS'
    'gJUgxpbnRlcmVzdFJhdGUSGwoJdGVybV9kYXlzGAwgASgFUgh0ZXJtRGF5cxJBCg9pbnRlcmVz'
    'dF9tZXRob2QYDSABKA4yGC5sb2Fucy52MS5JbnRlcmVzdE1ldGhvZFIOaW50ZXJlc3RNZXRob2'
    'QSTQoTcmVwYXltZW50X2ZyZXF1ZW5jeRgOIAEoDjIcLmxvYW5zLnYxLlJlcGF5bWVudEZyZXF1'
    'ZW5jeVIScmVwYXltZW50RnJlcXVlbmN5EiEKDGRpc2J1cnNlZF9hdBgPIAEoCVILZGlzYnVyc2'
    'VkQXQSIwoNbWF0dXJpdHlfZGF0ZRgQIAEoCVIMbWF0dXJpdHlEYXRlEjAKFGZpcnN0X3JlcGF5'
    'bWVudF9kYXRlGBEgASgJUhJmaXJzdFJlcGF5bWVudERhdGUSLgoTbGFzdF9yZXBheW1lbnRfZG'
    'F0ZRgSIAEoCVIRbGFzdFJlcGF5bWVudERhdGUSIgoNZGF5c19wYXN0X2R1ZRgTIAEoBVILZGF5'
    'c1Bhc3REdWUSNQoXbGVkZ2VyX2Fzc2V0X2FjY291bnRfaWQYFCABKAlSFGxlZGdlckFzc2V0QW'
    'Njb3VudElkEkgKIWxlZGdlcl9pbnRlcmVzdF9pbmNvbWVfYWNjb3VudF9pZBgVIAEoCVIdbGVk'
    'Z2VySW50ZXJlc3RJbmNvbWVBY2NvdW50SWQSPgocbGVkZ2VyX2ZlZV9pbmNvbWVfYWNjb3VudF'
    '9pZBgWIAEoCVIYbGVkZ2VyRmVlSW5jb21lQWNjb3VudElkEkYKIGxlZGdlcl9wZW5hbHR5X2lu'
    'Y29tZV9hY2NvdW50X2lkGBcgASgJUhxsZWRnZXJQZW5hbHR5SW5jb21lQWNjb3VudElkEi4KE3'
    'BheW1lbnRfYWNjb3VudF9yZWYYGCABKAlSEXBheW1lbnRBY2NvdW50UmVmEjcKCnByb3BlcnRp'
    'ZXMYGSABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0Ugpwcm9wZXJ0aWVz');

@$core.Deprecated('Use repaymentScheduleObjectDescriptor instead')
const RepaymentScheduleObject$json = {
  '1': 'RepaymentScheduleObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'loan_account_id', '3': 2, '4': 1, '5': 9, '10': 'loanAccountId'},
    {'1': 'version', '3': 3, '4': 1, '5': 5, '10': 'version'},
    {'1': 'is_active', '3': 4, '4': 1, '5': 8, '10': 'isActive'},
    {'1': 'generated_at', '3': 5, '4': 1, '5': 9, '10': 'generatedAt'},
    {'1': 'entries', '3': 6, '4': 3, '5': 11, '6': '.loans.v1.ScheduleEntryObject', '10': 'entries'},
    {'1': 'properties', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `RepaymentScheduleObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List repaymentScheduleObjectDescriptor = $convert.base64Decode(
    'ChdSZXBheW1lbnRTY2hlZHVsZU9iamVjdBIOCgJpZBgBIAEoCVICaWQSJgoPbG9hbl9hY2NvdW'
    '50X2lkGAIgASgJUg1sb2FuQWNjb3VudElkEhgKB3ZlcnNpb24YAyABKAVSB3ZlcnNpb24SGwoJ'
    'aXNfYWN0aXZlGAQgASgIUghpc0FjdGl2ZRIhCgxnZW5lcmF0ZWRfYXQYBSABKAlSC2dlbmVyYX'
    'RlZEF0EjcKB2VudHJpZXMYBiADKAsyHS5sb2Fucy52MS5TY2hlZHVsZUVudHJ5T2JqZWN0Ugdl'
    'bnRyaWVzEjcKCnByb3BlcnRpZXMYByABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0Ugpwcm'
    '9wZXJ0aWVz');

@$core.Deprecated('Use scheduleEntryObjectDescriptor instead')
const ScheduleEntryObject$json = {
  '1': 'ScheduleEntryObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'schedule_id', '3': 2, '4': 1, '5': 9, '10': 'scheduleId'},
    {'1': 'installment_number', '3': 3, '4': 1, '5': 5, '10': 'installmentNumber'},
    {'1': 'due_date', '3': 4, '4': 1, '5': 9, '10': 'dueDate'},
    {'1': 'principal_due', '3': 5, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'principalDue'},
    {'1': 'interest_due', '3': 6, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'interestDue'},
    {'1': 'fees_due', '3': 7, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'feesDue'},
    {'1': 'total_due', '3': 8, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'totalDue'},
    {'1': 'principal_paid', '3': 9, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'principalPaid'},
    {'1': 'interest_paid', '3': 10, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'interestPaid'},
    {'1': 'fees_paid', '3': 11, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'feesPaid'},
    {'1': 'total_paid', '3': 12, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'totalPaid'},
    {'1': 'outstanding', '3': 13, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'outstanding'},
    {'1': 'status', '3': 14, '4': 1, '5': 14, '6': '.loans.v1.ScheduleEntryStatus', '10': 'status'},
    {'1': 'paid_date', '3': 15, '4': 1, '5': 9, '10': 'paidDate'},
    {'1': 'properties', '3': 16, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `ScheduleEntryObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleEntryObjectDescriptor = $convert.base64Decode(
    'ChNTY2hlZHVsZUVudHJ5T2JqZWN0Eg4KAmlkGAEgASgJUgJpZBIfCgtzY2hlZHVsZV9pZBgCIA'
    'EoCVIKc2NoZWR1bGVJZBItChJpbnN0YWxsbWVudF9udW1iZXIYAyABKAVSEWluc3RhbGxtZW50'
    'TnVtYmVyEhkKCGR1ZV9kYXRlGAQgASgJUgdkdWVEYXRlEjcKDXByaW5jaXBhbF9kdWUYBSABKA'
    'syEi5nb29nbGUudHlwZS5Nb25leVIMcHJpbmNpcGFsRHVlEjUKDGludGVyZXN0X2R1ZRgGIAEo'
    'CzISLmdvb2dsZS50eXBlLk1vbmV5UgtpbnRlcmVzdER1ZRItCghmZWVzX2R1ZRgHIAEoCzISLm'
    'dvb2dsZS50eXBlLk1vbmV5UgdmZWVzRHVlEi8KCXRvdGFsX2R1ZRgIIAEoCzISLmdvb2dsZS50'
    'eXBlLk1vbmV5Ugh0b3RhbER1ZRI5Cg5wcmluY2lwYWxfcGFpZBgJIAEoCzISLmdvb2dsZS50eX'
    'BlLk1vbmV5Ug1wcmluY2lwYWxQYWlkEjcKDWludGVyZXN0X3BhaWQYCiABKAsyEi5nb29nbGUu'
    'dHlwZS5Nb25leVIMaW50ZXJlc3RQYWlkEi8KCWZlZXNfcGFpZBgLIAEoCzISLmdvb2dsZS50eX'
    'BlLk1vbmV5UghmZWVzUGFpZBIxCgp0b3RhbF9wYWlkGAwgASgLMhIuZ29vZ2xlLnR5cGUuTW9u'
    'ZXlSCXRvdGFsUGFpZBI0CgtvdXRzdGFuZGluZxgNIAEoCzISLmdvb2dsZS50eXBlLk1vbmV5Ug'
    'tvdXRzdGFuZGluZxI1CgZzdGF0dXMYDiABKA4yHS5sb2Fucy52MS5TY2hlZHVsZUVudHJ5U3Rh'
    'dHVzUgZzdGF0dXMSGwoJcGFpZF9kYXRlGA8gASgJUghwYWlkRGF0ZRI3Cgpwcm9wZXJ0aWVzGB'
    'AgASgLMhcuZ29vZ2xlLnByb3RvYnVmLlN0cnVjdFIKcHJvcGVydGllcw==');

@$core.Deprecated('Use loanBalanceObjectDescriptor instead')
const LoanBalanceObject$json = {
  '1': 'LoanBalanceObject',
  '2': [
    {'1': 'loan_account_id', '3': 1, '4': 1, '5': 9, '10': 'loanAccountId'},
    {'1': 'principal_outstanding', '3': 2, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'principalOutstanding'},
    {'1': 'interest_accrued', '3': 3, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'interestAccrued'},
    {'1': 'fees_outstanding', '3': 4, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'feesOutstanding'},
    {'1': 'penalties_outstanding', '3': 5, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'penaltiesOutstanding'},
    {'1': 'total_outstanding', '3': 6, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'totalOutstanding'},
    {'1': 'total_paid', '3': 7, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'totalPaid'},
    {'1': 'total_disbursed', '3': 8, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'totalDisbursed'},
    {'1': 'last_calculated_at', '3': 9, '4': 1, '5': 9, '10': 'lastCalculatedAt'},
  ],
};

/// Descriptor for `LoanBalanceObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanBalanceObjectDescriptor = $convert.base64Decode(
    'ChFMb2FuQmFsYW5jZU9iamVjdBImCg9sb2FuX2FjY291bnRfaWQYASABKAlSDWxvYW5BY2NvdW'
    '50SWQSRwoVcHJpbmNpcGFsX291dHN0YW5kaW5nGAIgASgLMhIuZ29vZ2xlLnR5cGUuTW9uZXlS'
    'FHByaW5jaXBhbE91dHN0YW5kaW5nEj0KEGludGVyZXN0X2FjY3J1ZWQYAyABKAsyEi5nb29nbG'
    'UudHlwZS5Nb25leVIPaW50ZXJlc3RBY2NydWVkEj0KEGZlZXNfb3V0c3RhbmRpbmcYBCABKAsy'
    'Ei5nb29nbGUudHlwZS5Nb25leVIPZmVlc091dHN0YW5kaW5nEkcKFXBlbmFsdGllc19vdXRzdG'
    'FuZGluZxgFIAEoCzISLmdvb2dsZS50eXBlLk1vbmV5UhRwZW5hbHRpZXNPdXRzdGFuZGluZxI/'
    'ChF0b3RhbF9vdXRzdGFuZGluZxgGIAEoCzISLmdvb2dsZS50eXBlLk1vbmV5UhB0b3RhbE91dH'
    'N0YW5kaW5nEjEKCnRvdGFsX3BhaWQYByABKAsyEi5nb29nbGUudHlwZS5Nb25leVIJdG90YWxQ'
    'YWlkEjsKD3RvdGFsX2Rpc2J1cnNlZBgIIAEoCzISLmdvb2dsZS50eXBlLk1vbmV5Ug50b3RhbE'
    'Rpc2J1cnNlZBIsChJsYXN0X2NhbGN1bGF0ZWRfYXQYCSABKAlSEGxhc3RDYWxjdWxhdGVkQXQ=');

@$core.Deprecated('Use disbursementObjectDescriptor instead')
const DisbursementObject$json = {
  '1': 'DisbursementObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'loan_account_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'loanAccountId'},
    {'1': 'amount', '3': 3, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'amount'},
    {'1': 'status', '3': 5, '4': 1, '5': 14, '6': '.loans.v1.DisbursementStatus', '10': 'status'},
    {'1': 'payment_reference', '3': 6, '4': 1, '5': 9, '10': 'paymentReference'},
    {'1': 'ledger_transaction_id', '3': 7, '4': 1, '5': 9, '10': 'ledgerTransactionId'},
    {'1': 'disbursed_at', '3': 8, '4': 1, '5': 9, '10': 'disbursedAt'},
    {'1': 'channel', '3': 9, '4': 1, '5': 9, '10': 'channel'},
    {'1': 'recipient_reference', '3': 10, '4': 1, '5': 9, '10': 'recipientReference'},
    {'1': 'failure_reason', '3': 11, '4': 1, '5': 9, '10': 'failureReason'},
    {'1': 'idempotency_key', '3': 12, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'properties', '3': 13, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `DisbursementObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disbursementObjectDescriptor = $convert.base64Decode(
    'ChJEaXNidXJzZW1lbnRPYmplY3QSLgoCaWQYASABKAlCHrpIG9gBAXIWEAMYKDIQWzAtOWEtel'
    '8tXXszLDQwfVICaWQSMQoPbG9hbl9hY2NvdW50X2lkGAIgASgJQgm6SAZyBBADGChSDWxvYW5B'
    'Y2NvdW50SWQSKgoGYW1vdW50GAMgASgLMhIuZ29vZ2xlLnR5cGUuTW9uZXlSBmFtb3VudBI0Cg'
    'ZzdGF0dXMYBSABKA4yHC5sb2Fucy52MS5EaXNidXJzZW1lbnRTdGF0dXNSBnN0YXR1cxIrChFw'
    'YXltZW50X3JlZmVyZW5jZRgGIAEoCVIQcGF5bWVudFJlZmVyZW5jZRIyChVsZWRnZXJfdHJhbn'
    'NhY3Rpb25faWQYByABKAlSE2xlZGdlclRyYW5zYWN0aW9uSWQSIQoMZGlzYnVyc2VkX2F0GAgg'
    'ASgJUgtkaXNidXJzZWRBdBIYCgdjaGFubmVsGAkgASgJUgdjaGFubmVsEi8KE3JlY2lwaWVudF'
    '9yZWZlcmVuY2UYCiABKAlSEnJlY2lwaWVudFJlZmVyZW5jZRIlCg5mYWlsdXJlX3JlYXNvbhgL'
    'IAEoCVINZmFpbHVyZVJlYXNvbhInCg9pZGVtcG90ZW5jeV9rZXkYDCABKAlSDmlkZW1wb3Rlbm'
    'N5S2V5EjcKCnByb3BlcnRpZXMYDSABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0Ugpwcm9w'
    'ZXJ0aWVz');

@$core.Deprecated('Use repaymentObjectDescriptor instead')
const RepaymentObject$json = {
  '1': 'RepaymentObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'loan_account_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'loanAccountId'},
    {'1': 'amount', '3': 3, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'amount'},
    {'1': 'status', '3': 5, '4': 1, '5': 14, '6': '.loans.v1.RepaymentStatus', '10': 'status'},
    {'1': 'payment_reference', '3': 6, '4': 1, '5': 9, '10': 'paymentReference'},
    {'1': 'ledger_transaction_id', '3': 7, '4': 1, '5': 9, '10': 'ledgerTransactionId'},
    {'1': 'received_at', '3': 8, '4': 1, '5': 9, '10': 'receivedAt'},
    {'1': 'channel', '3': 9, '4': 1, '5': 9, '10': 'channel'},
    {'1': 'payer_reference', '3': 10, '4': 1, '5': 9, '10': 'payerReference'},
    {'1': 'principal_applied', '3': 11, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'principalApplied'},
    {'1': 'interest_applied', '3': 12, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'interestApplied'},
    {'1': 'fees_applied', '3': 13, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'feesApplied'},
    {'1': 'penalties_applied', '3': 14, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'penaltiesApplied'},
    {'1': 'excess_amount', '3': 15, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'excessAmount'},
    {'1': 'idempotency_key', '3': 16, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'properties', '3': 17, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `RepaymentObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List repaymentObjectDescriptor = $convert.base64Decode(
    'Cg9SZXBheW1lbnRPYmplY3QSLgoCaWQYASABKAlCHrpIG9gBAXIWEAMYKDIQWzAtOWEtel8tXX'
    'szLDQwfVICaWQSMQoPbG9hbl9hY2NvdW50X2lkGAIgASgJQgm6SAZyBBADGChSDWxvYW5BY2Nv'
    'dW50SWQSKgoGYW1vdW50GAMgASgLMhIuZ29vZ2xlLnR5cGUuTW9uZXlSBmFtb3VudBIxCgZzdG'
    'F0dXMYBSABKA4yGS5sb2Fucy52MS5SZXBheW1lbnRTdGF0dXNSBnN0YXR1cxIrChFwYXltZW50'
    'X3JlZmVyZW5jZRgGIAEoCVIQcGF5bWVudFJlZmVyZW5jZRIyChVsZWRnZXJfdHJhbnNhY3Rpb2'
    '5faWQYByABKAlSE2xlZGdlclRyYW5zYWN0aW9uSWQSHwoLcmVjZWl2ZWRfYXQYCCABKAlSCnJl'
    'Y2VpdmVkQXQSGAoHY2hhbm5lbBgJIAEoCVIHY2hhbm5lbBInCg9wYXllcl9yZWZlcmVuY2UYCi'
    'ABKAlSDnBheWVyUmVmZXJlbmNlEj8KEXByaW5jaXBhbF9hcHBsaWVkGAsgASgLMhIuZ29vZ2xl'
    'LnR5cGUuTW9uZXlSEHByaW5jaXBhbEFwcGxpZWQSPQoQaW50ZXJlc3RfYXBwbGllZBgMIAEoCz'
    'ISLmdvb2dsZS50eXBlLk1vbmV5Ug9pbnRlcmVzdEFwcGxpZWQSNQoMZmVlc19hcHBsaWVkGA0g'
    'ASgLMhIuZ29vZ2xlLnR5cGUuTW9uZXlSC2ZlZXNBcHBsaWVkEj8KEXBlbmFsdGllc19hcHBsaW'
    'VkGA4gASgLMhIuZ29vZ2xlLnR5cGUuTW9uZXlSEHBlbmFsdGllc0FwcGxpZWQSNwoNZXhjZXNz'
    'X2Ftb3VudBgPIAEoCzISLmdvb2dsZS50eXBlLk1vbmV5UgxleGNlc3NBbW91bnQSJwoPaWRlbX'
    'BvdGVuY3lfa2V5GBAgASgJUg5pZGVtcG90ZW5jeUtleRI3Cgpwcm9wZXJ0aWVzGBEgASgLMhcu'
    'Z29vZ2xlLnByb3RvYnVmLlN0cnVjdFIKcHJvcGVydGllcw==');

@$core.Deprecated('Use penaltyObjectDescriptor instead')
const PenaltyObject$json = {
  '1': 'PenaltyObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'loan_account_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'loanAccountId'},
    {'1': 'penalty_type', '3': 3, '4': 1, '5': 14, '6': '.loans.v1.PenaltyType', '10': 'penaltyType'},
    {'1': 'amount', '3': 4, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'amount'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'is_waived', '3': 6, '4': 1, '5': 8, '10': 'isWaived'},
    {'1': 'waived_by', '3': 7, '4': 1, '5': 9, '10': 'waivedBy'},
    {'1': 'waived_reason', '3': 8, '4': 1, '5': 9, '10': 'waivedReason'},
    {'1': 'ledger_transaction_id', '3': 9, '4': 1, '5': 9, '10': 'ledgerTransactionId'},
    {'1': 'applied_at', '3': 10, '4': 1, '5': 9, '10': 'appliedAt'},
    {'1': 'schedule_entry_id', '3': 11, '4': 1, '5': 9, '10': 'scheduleEntryId'},
    {'1': 'properties', '3': 12, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `PenaltyObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List penaltyObjectDescriptor = $convert.base64Decode(
    'Cg1QZW5hbHR5T2JqZWN0Ei4KAmlkGAEgASgJQh66SBvYAQFyFhADGCgyEFswLTlhLXpfLV17My'
    'w0MH1SAmlkEjEKD2xvYW5fYWNjb3VudF9pZBgCIAEoCUIJukgGcgQQAxgoUg1sb2FuQWNjb3Vu'
    'dElkEjgKDHBlbmFsdHlfdHlwZRgDIAEoDjIVLmxvYW5zLnYxLlBlbmFsdHlUeXBlUgtwZW5hbH'
    'R5VHlwZRIqCgZhbW91bnQYBCABKAsyEi5nb29nbGUudHlwZS5Nb25leVIGYW1vdW50EhYKBnJl'
    'YXNvbhgFIAEoCVIGcmVhc29uEhsKCWlzX3dhaXZlZBgGIAEoCFIIaXNXYWl2ZWQSGwoJd2Fpdm'
    'VkX2J5GAcgASgJUgh3YWl2ZWRCeRIjCg13YWl2ZWRfcmVhc29uGAggASgJUgx3YWl2ZWRSZWFz'
    'b24SMgoVbGVkZ2VyX3RyYW5zYWN0aW9uX2lkGAkgASgJUhNsZWRnZXJUcmFuc2FjdGlvbklkEh'
    '0KCmFwcGxpZWRfYXQYCiABKAlSCWFwcGxpZWRBdBIqChFzY2hlZHVsZV9lbnRyeV9pZBgLIAEo'
    'CVIPc2NoZWR1bGVFbnRyeUlkEjcKCnByb3BlcnRpZXMYDCABKAsyFy5nb29nbGUucHJvdG9idW'
    'YuU3RydWN0Ugpwcm9wZXJ0aWVz');

@$core.Deprecated('Use loanRestructureObjectDescriptor instead')
const LoanRestructureObject$json = {
  '1': 'LoanRestructureObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'loan_account_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'loanAccountId'},
    {'1': 'restructure_type', '3': 3, '4': 1, '5': 14, '6': '.loans.v1.RestructureType', '10': 'restructureType'},
    {'1': 'requested_by', '3': 4, '4': 1, '5': 9, '10': 'requestedBy'},
    {'1': 'approved_by', '3': 5, '4': 1, '5': 9, '10': 'approvedBy'},
    {'1': 'reason', '3': 6, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'old_interest_rate', '3': 7, '4': 1, '5': 9, '10': 'oldInterestRate'},
    {'1': 'new_interest_rate', '3': 8, '4': 1, '5': 9, '10': 'newInterestRate'},
    {'1': 'old_term_days', '3': 9, '4': 1, '5': 5, '10': 'oldTermDays'},
    {'1': 'new_term_days', '3': 10, '4': 1, '5': 5, '10': 'newTermDays'},
    {'1': 'waived_amount', '3': 11, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'waivedAmount'},
    {'1': 'old_schedule_id', '3': 12, '4': 1, '5': 9, '10': 'oldScheduleId'},
    {'1': 'new_schedule_id', '3': 13, '4': 1, '5': 9, '10': 'newScheduleId'},
    {'1': 'state', '3': 14, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'properties', '3': 15, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `LoanRestructureObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanRestructureObjectDescriptor = $convert.base64Decode(
    'ChVMb2FuUmVzdHJ1Y3R1cmVPYmplY3QSLgoCaWQYASABKAlCHrpIG9gBAXIWEAMYKDIQWzAtOW'
    'Etel8tXXszLDQwfVICaWQSMQoPbG9hbl9hY2NvdW50X2lkGAIgASgJQgm6SAZyBBADGChSDWxv'
    'YW5BY2NvdW50SWQSRAoQcmVzdHJ1Y3R1cmVfdHlwZRgDIAEoDjIZLmxvYW5zLnYxLlJlc3RydW'
    'N0dXJlVHlwZVIPcmVzdHJ1Y3R1cmVUeXBlEiEKDHJlcXVlc3RlZF9ieRgEIAEoCVILcmVxdWVz'
    'dGVkQnkSHwoLYXBwcm92ZWRfYnkYBSABKAlSCmFwcHJvdmVkQnkSFgoGcmVhc29uGAYgASgJUg'
    'ZyZWFzb24SKgoRb2xkX2ludGVyZXN0X3JhdGUYByABKAlSD29sZEludGVyZXN0UmF0ZRIqChFu'
    'ZXdfaW50ZXJlc3RfcmF0ZRgIIAEoCVIPbmV3SW50ZXJlc3RSYXRlEiIKDW9sZF90ZXJtX2RheX'
    'MYCSABKAVSC29sZFRlcm1EYXlzEiIKDW5ld190ZXJtX2RheXMYCiABKAVSC25ld1Rlcm1EYXlz'
    'EjcKDXdhaXZlZF9hbW91bnQYCyABKAsyEi5nb29nbGUudHlwZS5Nb25leVIMd2FpdmVkQW1vdW'
    '50EiYKD29sZF9zY2hlZHVsZV9pZBgMIAEoCVINb2xkU2NoZWR1bGVJZBImCg9uZXdfc2NoZWR1'
    'bGVfaWQYDSABKAlSDW5ld1NjaGVkdWxlSWQSJgoFc3RhdGUYDiABKA4yEC5jb21tb24udjEuU1'
    'RBVEVSBXN0YXRlEjcKCnByb3BlcnRpZXMYDyABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0'
    'Ugpwcm9wZXJ0aWVz');

@$core.Deprecated('Use loanStatusChangeObjectDescriptor instead')
const LoanStatusChangeObject$json = {
  '1': 'LoanStatusChangeObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'loan_account_id', '3': 2, '4': 1, '5': 9, '10': 'loanAccountId'},
    {'1': 'from_status', '3': 3, '4': 1, '5': 5, '10': 'fromStatus'},
    {'1': 'to_status', '3': 4, '4': 1, '5': 5, '10': 'toStatus'},
    {'1': 'changed_by', '3': 5, '4': 1, '5': 9, '10': 'changedBy'},
    {'1': 'reason', '3': 6, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'changed_at', '3': 7, '4': 1, '5': 9, '10': 'changedAt'},
  ],
};

/// Descriptor for `LoanStatusChangeObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanStatusChangeObjectDescriptor = $convert.base64Decode(
    'ChZMb2FuU3RhdHVzQ2hhbmdlT2JqZWN0Eg4KAmlkGAEgASgJUgJpZBImCg9sb2FuX2FjY291bn'
    'RfaWQYAiABKAlSDWxvYW5BY2NvdW50SWQSHwoLZnJvbV9zdGF0dXMYAyABKAVSCmZyb21TdGF0'
    'dXMSGwoJdG9fc3RhdHVzGAQgASgFUgh0b1N0YXR1cxIdCgpjaGFuZ2VkX2J5GAUgASgJUgljaG'
    'FuZ2VkQnkSFgoGcmVhc29uGAYgASgJUgZyZWFzb24SHQoKY2hhbmdlZF9hdBgHIAEoCVIJY2hh'
    'bmdlZEF0');

@$core.Deprecated('Use reconciliationObjectDescriptor instead')
const ReconciliationObject$json = {
  '1': 'ReconciliationObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'loan_account_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'loanAccountId'},
    {'1': 'payment_reference', '3': 3, '4': 1, '5': 9, '10': 'paymentReference'},
    {'1': 'external_reference', '3': 4, '4': 1, '5': 9, '10': 'externalReference'},
    {'1': 'amount', '3': 5, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'amount'},
    {'1': 'status', '3': 7, '4': 1, '5': 14, '6': '.loans.v1.ReconciliationStatus', '10': 'status'},
    {'1': 'matched_repayment_id', '3': 8, '4': 1, '5': 9, '10': 'matchedRepaymentId'},
    {'1': 'notes', '3': 9, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'reconciled_at', '3': 10, '4': 1, '5': 9, '10': 'reconciledAt'},
    {'1': 'reconciled_by', '3': 11, '4': 1, '5': 9, '10': 'reconciledBy'},
    {'1': 'properties', '3': 12, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `ReconciliationObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconciliationObjectDescriptor = $convert.base64Decode(
    'ChRSZWNvbmNpbGlhdGlvbk9iamVjdBIuCgJpZBgBIAEoCUIeukgb2AEBchYQAxgoMhBbMC05YS'
    '16Xy1dezMsNDB9UgJpZBIxCg9sb2FuX2FjY291bnRfaWQYAiABKAlCCbpIBnIEEAMYKFINbG9h'
    'bkFjY291bnRJZBIrChFwYXltZW50X3JlZmVyZW5jZRgDIAEoCVIQcGF5bWVudFJlZmVyZW5jZR'
    'ItChJleHRlcm5hbF9yZWZlcmVuY2UYBCABKAlSEWV4dGVybmFsUmVmZXJlbmNlEioKBmFtb3Vu'
    'dBgFIAEoCzISLmdvb2dsZS50eXBlLk1vbmV5UgZhbW91bnQSNgoGc3RhdHVzGAcgASgOMh4ubG'
    '9hbnMudjEuUmVjb25jaWxpYXRpb25TdGF0dXNSBnN0YXR1cxIwChRtYXRjaGVkX3JlcGF5bWVu'
    'dF9pZBgIIAEoCVISbWF0Y2hlZFJlcGF5bWVudElkEhQKBW5vdGVzGAkgASgJUgVub3RlcxIjCg'
    '1yZWNvbmNpbGVkX2F0GAogASgJUgxyZWNvbmNpbGVkQXQSIwoNcmVjb25jaWxlZF9ieRgLIAEo'
    'CVIMcmVjb25jaWxlZEJ5EjcKCnByb3BlcnRpZXMYDCABKAsyFy5nb29nbGUucHJvdG9idWYuU3'
    'RydWN0Ugpwcm9wZXJ0aWVz');

@$core.Deprecated('Use loanStatementEntryDescriptor instead')
const LoanStatementEntry$json = {
  '1': 'LoanStatementEntry',
  '2': [
    {'1': 'date', '3': 1, '4': 1, '5': 9, '10': 'date'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'debit', '3': 3, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'debit'},
    {'1': 'credit', '3': 4, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'credit'},
    {'1': 'balance', '3': 5, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'balance'},
    {'1': 'reference', '3': 6, '4': 1, '5': 9, '10': 'reference'},
  ],
};

/// Descriptor for `LoanStatementEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanStatementEntryDescriptor = $convert.base64Decode(
    'ChJMb2FuU3RhdGVtZW50RW50cnkSEgoEZGF0ZRgBIAEoCVIEZGF0ZRIgCgtkZXNjcmlwdGlvbh'
    'gCIAEoCVILZGVzY3JpcHRpb24SKAoFZGViaXQYAyABKAsyEi5nb29nbGUudHlwZS5Nb25leVIF'
    'ZGViaXQSKgoGY3JlZGl0GAQgASgLMhIuZ29vZ2xlLnR5cGUuTW9uZXlSBmNyZWRpdBIsCgdiYW'
    'xhbmNlGAUgASgLMhIuZ29vZ2xlLnR5cGUuTW9uZXlSB2JhbGFuY2USHAoJcmVmZXJlbmNlGAYg'
    'ASgJUglyZWZlcmVuY2U=');

@$core.Deprecated('Use loanAccountCreateRequestDescriptor instead')
const LoanAccountCreateRequest$json = {
  '1': 'LoanAccountCreateRequest',
  '2': [
    {'1': 'application_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'applicationId'},
  ],
};

/// Descriptor for `LoanAccountCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanAccountCreateRequestDescriptor = $convert.base64Decode(
    'ChhMb2FuQWNjb3VudENyZWF0ZVJlcXVlc3QSMAoOYXBwbGljYXRpb25faWQYASABKAlCCbpIBn'
    'IEEAMYKFINYXBwbGljYXRpb25JZA==');

@$core.Deprecated('Use loanAccountCreateResponseDescriptor instead')
const LoanAccountCreateResponse$json = {
  '1': 'LoanAccountCreateResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.loans.v1.LoanAccountObject', '10': 'data'},
  ],
};

/// Descriptor for `LoanAccountCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanAccountCreateResponseDescriptor = $convert.base64Decode(
    'ChlMb2FuQWNjb3VudENyZWF0ZVJlc3BvbnNlEi8KBGRhdGEYASABKAsyGy5sb2Fucy52MS5Mb2'
    'FuQWNjb3VudE9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use loanAccountGetRequestDescriptor instead')
const LoanAccountGetRequest$json = {
  '1': 'LoanAccountGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `LoanAccountGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanAccountGetRequestDescriptor = $convert.base64Decode(
    'ChVMb2FuQWNjb3VudEdldFJlcXVlc3QSKwoCaWQYASABKAlCG7pIGHIWEAMYKDIQWzAtOWEtel'
    '8tXXszLDQwfVICaWQ=');

@$core.Deprecated('Use loanAccountGetResponseDescriptor instead')
const LoanAccountGetResponse$json = {
  '1': 'LoanAccountGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.loans.v1.LoanAccountObject', '10': 'data'},
  ],
};

/// Descriptor for `LoanAccountGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanAccountGetResponseDescriptor = $convert.base64Decode(
    'ChZMb2FuQWNjb3VudEdldFJlc3BvbnNlEi8KBGRhdGEYASABKAsyGy5sb2Fucy52MS5Mb2FuQW'
    'Njb3VudE9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use loanAccountSearchRequestDescriptor instead')
const LoanAccountSearchRequest$json = {
  '1': 'LoanAccountSearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'client_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'clientId'},
    {'1': 'agent_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'agentId'},
    {'1': 'branch_id', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'branchId'},
    {'1': 'bank_id', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'bankId'},
    {'1': 'status', '3': 6, '4': 1, '5': 14, '6': '.loans.v1.LoanStatus', '10': 'status'},
    {'1': 'cursor', '3': 7, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `LoanAccountSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanAccountSearchRequestDescriptor = $convert.base64Decode(
    'ChhMb2FuQWNjb3VudFNlYXJjaFJlcXVlc3QSFAoFcXVlcnkYASABKAlSBXF1ZXJ5EikKCWNsaW'
    'VudF9pZBgCIAEoCUIMukgJ2AEBcgQQAxgoUghjbGllbnRJZBInCghhZ2VudF9pZBgDIAEoCUIM'
    'ukgJ2AEBcgQQAxgoUgdhZ2VudElkEikKCWJyYW5jaF9pZBgEIAEoCUIMukgJ2AEBcgQQAxgoUg'
    'hicmFuY2hJZBIlCgdiYW5rX2lkGAUgASgJQgy6SAnYAQFyBBADGChSBmJhbmtJZBIsCgZzdGF0'
    'dXMYBiABKA4yFC5sb2Fucy52MS5Mb2FuU3RhdHVzUgZzdGF0dXMSLQoGY3Vyc29yGAcgASgLMh'
    'UuY29tbW9uLnYxLlBhZ2VDdXJzb3JSBmN1cnNvcg==');

@$core.Deprecated('Use loanAccountSearchResponseDescriptor instead')
const LoanAccountSearchResponse$json = {
  '1': 'LoanAccountSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.loans.v1.LoanAccountObject', '10': 'data'},
  ],
};

/// Descriptor for `LoanAccountSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanAccountSearchResponseDescriptor = $convert.base64Decode(
    'ChlMb2FuQWNjb3VudFNlYXJjaFJlc3BvbnNlEi8KBGRhdGEYASADKAsyGy5sb2Fucy52MS5Mb2'
    'FuQWNjb3VudE9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use loanBalanceGetRequestDescriptor instead')
const LoanBalanceGetRequest$json = {
  '1': 'LoanBalanceGetRequest',
  '2': [
    {'1': 'loan_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'loanAccountId'},
  ],
};

/// Descriptor for `LoanBalanceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanBalanceGetRequestDescriptor = $convert.base64Decode(
    'ChVMb2FuQmFsYW5jZUdldFJlcXVlc3QSMQoPbG9hbl9hY2NvdW50X2lkGAEgASgJQgm6SAZyBB'
    'ADGChSDWxvYW5BY2NvdW50SWQ=');

@$core.Deprecated('Use loanBalanceGetResponseDescriptor instead')
const LoanBalanceGetResponse$json = {
  '1': 'LoanBalanceGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.loans.v1.LoanBalanceObject', '10': 'data'},
  ],
};

/// Descriptor for `LoanBalanceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanBalanceGetResponseDescriptor = $convert.base64Decode(
    'ChZMb2FuQmFsYW5jZUdldFJlc3BvbnNlEi8KBGRhdGEYASABKAsyGy5sb2Fucy52MS5Mb2FuQm'
    'FsYW5jZU9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use disbursementCreateRequestDescriptor instead')
const DisbursementCreateRequest$json = {
  '1': 'DisbursementCreateRequest',
  '2': [
    {'1': 'loan_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'loanAccountId'},
    {'1': 'channel', '3': 2, '4': 1, '5': 9, '10': 'channel'},
    {'1': 'recipient_reference', '3': 3, '4': 1, '5': 9, '10': 'recipientReference'},
    {'1': 'idempotency_key', '3': 4, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `DisbursementCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disbursementCreateRequestDescriptor = $convert.base64Decode(
    'ChlEaXNidXJzZW1lbnRDcmVhdGVSZXF1ZXN0EjEKD2xvYW5fYWNjb3VudF9pZBgBIAEoCUIJuk'
    'gGcgQQAxgoUg1sb2FuQWNjb3VudElkEhgKB2NoYW5uZWwYAiABKAlSB2NoYW5uZWwSLwoTcmVj'
    'aXBpZW50X3JlZmVyZW5jZRgDIAEoCVIScmVjaXBpZW50UmVmZXJlbmNlEicKD2lkZW1wb3Rlbm'
    'N5X2tleRgEIAEoCVIOaWRlbXBvdGVuY3lLZXk=');

@$core.Deprecated('Use disbursementCreateResponseDescriptor instead')
const DisbursementCreateResponse$json = {
  '1': 'DisbursementCreateResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.loans.v1.DisbursementObject', '10': 'data'},
  ],
};

/// Descriptor for `DisbursementCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disbursementCreateResponseDescriptor = $convert.base64Decode(
    'ChpEaXNidXJzZW1lbnRDcmVhdGVSZXNwb25zZRIwCgRkYXRhGAEgASgLMhwubG9hbnMudjEuRG'
    'lzYnVyc2VtZW50T2JqZWN0UgRkYXRh');

@$core.Deprecated('Use disbursementGetRequestDescriptor instead')
const DisbursementGetRequest$json = {
  '1': 'DisbursementGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `DisbursementGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disbursementGetRequestDescriptor = $convert.base64Decode(
    'ChZEaXNidXJzZW1lbnRHZXRSZXF1ZXN0EisKAmlkGAEgASgJQhu6SBhyFhADGCgyEFswLTlhLX'
    'pfLV17Myw0MH1SAmlk');

@$core.Deprecated('Use disbursementGetResponseDescriptor instead')
const DisbursementGetResponse$json = {
  '1': 'DisbursementGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.loans.v1.DisbursementObject', '10': 'data'},
  ],
};

/// Descriptor for `DisbursementGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disbursementGetResponseDescriptor = $convert.base64Decode(
    'ChdEaXNidXJzZW1lbnRHZXRSZXNwb25zZRIwCgRkYXRhGAEgASgLMhwubG9hbnMudjEuRGlzYn'
    'Vyc2VtZW50T2JqZWN0UgRkYXRh');

@$core.Deprecated('Use disbursementSearchRequestDescriptor instead')
const DisbursementSearchRequest$json = {
  '1': 'DisbursementSearchRequest',
  '2': [
    {'1': 'loan_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'loanAccountId'},
    {'1': 'status', '3': 2, '4': 1, '5': 14, '6': '.loans.v1.DisbursementStatus', '10': 'status'},
    {'1': 'cursor', '3': 3, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `DisbursementSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disbursementSearchRequestDescriptor = $convert.base64Decode(
    'ChlEaXNidXJzZW1lbnRTZWFyY2hSZXF1ZXN0EjEKD2xvYW5fYWNjb3VudF9pZBgBIAEoCUIJuk'
    'gGcgQQAxgoUg1sb2FuQWNjb3VudElkEjQKBnN0YXR1cxgCIAEoDjIcLmxvYW5zLnYxLkRpc2J1'
    'cnNlbWVudFN0YXR1c1IGc3RhdHVzEi0KBmN1cnNvchgDIAEoCzIVLmNvbW1vbi52MS5QYWdlQ3'
    'Vyc29yUgZjdXJzb3I=');

@$core.Deprecated('Use disbursementSearchResponseDescriptor instead')
const DisbursementSearchResponse$json = {
  '1': 'DisbursementSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.loans.v1.DisbursementObject', '10': 'data'},
  ],
};

/// Descriptor for `DisbursementSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disbursementSearchResponseDescriptor = $convert.base64Decode(
    'ChpEaXNidXJzZW1lbnRTZWFyY2hSZXNwb25zZRIwCgRkYXRhGAEgAygLMhwubG9hbnMudjEuRG'
    'lzYnVyc2VtZW50T2JqZWN0UgRkYXRh');

@$core.Deprecated('Use repaymentRecordRequestDescriptor instead')
const RepaymentRecordRequest$json = {
  '1': 'RepaymentRecordRequest',
  '2': [
    {'1': 'loan_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'loanAccountId'},
    {'1': 'amount', '3': 2, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'amount'},
    {'1': 'payment_reference', '3': 3, '4': 1, '5': 9, '10': 'paymentReference'},
    {'1': 'channel', '3': 4, '4': 1, '5': 9, '10': 'channel'},
    {'1': 'payer_reference', '3': 5, '4': 1, '5': 9, '10': 'payerReference'},
    {'1': 'received_at', '3': 6, '4': 1, '5': 9, '10': 'receivedAt'},
    {'1': 'idempotency_key', '3': 7, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `RepaymentRecordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List repaymentRecordRequestDescriptor = $convert.base64Decode(
    'ChZSZXBheW1lbnRSZWNvcmRSZXF1ZXN0EjEKD2xvYW5fYWNjb3VudF9pZBgBIAEoCUIJukgGcg'
    'QQAxgoUg1sb2FuQWNjb3VudElkEioKBmFtb3VudBgCIAEoCzISLmdvb2dsZS50eXBlLk1vbmV5'
    'UgZhbW91bnQSKwoRcGF5bWVudF9yZWZlcmVuY2UYAyABKAlSEHBheW1lbnRSZWZlcmVuY2USGA'
    'oHY2hhbm5lbBgEIAEoCVIHY2hhbm5lbBInCg9wYXllcl9yZWZlcmVuY2UYBSABKAlSDnBheWVy'
    'UmVmZXJlbmNlEh8KC3JlY2VpdmVkX2F0GAYgASgJUgpyZWNlaXZlZEF0EicKD2lkZW1wb3Rlbm'
    'N5X2tleRgHIAEoCVIOaWRlbXBvdGVuY3lLZXk=');

@$core.Deprecated('Use repaymentRecordResponseDescriptor instead')
const RepaymentRecordResponse$json = {
  '1': 'RepaymentRecordResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.loans.v1.RepaymentObject', '10': 'data'},
  ],
};

/// Descriptor for `RepaymentRecordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List repaymentRecordResponseDescriptor = $convert.base64Decode(
    'ChdSZXBheW1lbnRSZWNvcmRSZXNwb25zZRItCgRkYXRhGAEgASgLMhkubG9hbnMudjEuUmVwYX'
    'ltZW50T2JqZWN0UgRkYXRh');

@$core.Deprecated('Use repaymentGetRequestDescriptor instead')
const RepaymentGetRequest$json = {
  '1': 'RepaymentGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `RepaymentGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List repaymentGetRequestDescriptor = $convert.base64Decode(
    'ChNSZXBheW1lbnRHZXRSZXF1ZXN0EisKAmlkGAEgASgJQhu6SBhyFhADGCgyEFswLTlhLXpfLV'
    '17Myw0MH1SAmlk');

@$core.Deprecated('Use repaymentGetResponseDescriptor instead')
const RepaymentGetResponse$json = {
  '1': 'RepaymentGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.loans.v1.RepaymentObject', '10': 'data'},
  ],
};

/// Descriptor for `RepaymentGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List repaymentGetResponseDescriptor = $convert.base64Decode(
    'ChRSZXBheW1lbnRHZXRSZXNwb25zZRItCgRkYXRhGAEgASgLMhkubG9hbnMudjEuUmVwYXltZW'
    '50T2JqZWN0UgRkYXRh');

@$core.Deprecated('Use repaymentSearchRequestDescriptor instead')
const RepaymentSearchRequest$json = {
  '1': 'RepaymentSearchRequest',
  '2': [
    {'1': 'loan_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'loanAccountId'},
    {'1': 'status', '3': 2, '4': 1, '5': 14, '6': '.loans.v1.RepaymentStatus', '10': 'status'},
    {'1': 'cursor', '3': 3, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `RepaymentSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List repaymentSearchRequestDescriptor = $convert.base64Decode(
    'ChZSZXBheW1lbnRTZWFyY2hSZXF1ZXN0EjEKD2xvYW5fYWNjb3VudF9pZBgBIAEoCUIJukgGcg'
    'QQAxgoUg1sb2FuQWNjb3VudElkEjEKBnN0YXR1cxgCIAEoDjIZLmxvYW5zLnYxLlJlcGF5bWVu'
    'dFN0YXR1c1IGc3RhdHVzEi0KBmN1cnNvchgDIAEoCzIVLmNvbW1vbi52MS5QYWdlQ3Vyc29yUg'
    'ZjdXJzb3I=');

@$core.Deprecated('Use repaymentSearchResponseDescriptor instead')
const RepaymentSearchResponse$json = {
  '1': 'RepaymentSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.loans.v1.RepaymentObject', '10': 'data'},
  ],
};

/// Descriptor for `RepaymentSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List repaymentSearchResponseDescriptor = $convert.base64Decode(
    'ChdSZXBheW1lbnRTZWFyY2hSZXNwb25zZRItCgRkYXRhGAEgAygLMhkubG9hbnMudjEuUmVwYX'
    'ltZW50T2JqZWN0UgRkYXRh');

@$core.Deprecated('Use repaymentScheduleGetRequestDescriptor instead')
const RepaymentScheduleGetRequest$json = {
  '1': 'RepaymentScheduleGetRequest',
  '2': [
    {'1': 'loan_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'loanAccountId'},
  ],
};

/// Descriptor for `RepaymentScheduleGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List repaymentScheduleGetRequestDescriptor = $convert.base64Decode(
    'ChtSZXBheW1lbnRTY2hlZHVsZUdldFJlcXVlc3QSMQoPbG9hbl9hY2NvdW50X2lkGAEgASgJQg'
    'm6SAZyBBADGChSDWxvYW5BY2NvdW50SWQ=');

@$core.Deprecated('Use repaymentScheduleGetResponseDescriptor instead')
const RepaymentScheduleGetResponse$json = {
  '1': 'RepaymentScheduleGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.loans.v1.RepaymentScheduleObject', '10': 'data'},
  ],
};

/// Descriptor for `RepaymentScheduleGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List repaymentScheduleGetResponseDescriptor = $convert.base64Decode(
    'ChxSZXBheW1lbnRTY2hlZHVsZUdldFJlc3BvbnNlEjUKBGRhdGEYASABKAsyIS5sb2Fucy52MS'
    '5SZXBheW1lbnRTY2hlZHVsZU9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use penaltySaveRequestDescriptor instead')
const PenaltySaveRequest$json = {
  '1': 'PenaltySaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.loans.v1.PenaltyObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `PenaltySaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List penaltySaveRequestDescriptor = $convert.base64Decode(
    'ChJQZW5hbHR5U2F2ZVJlcXVlc3QSMwoEZGF0YRgBIAEoCzIXLmxvYW5zLnYxLlBlbmFsdHlPYm'
    'plY3RCBrpIA8gBAVIEZGF0YQ==');

@$core.Deprecated('Use penaltySaveResponseDescriptor instead')
const PenaltySaveResponse$json = {
  '1': 'PenaltySaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.loans.v1.PenaltyObject', '10': 'data'},
  ],
};

/// Descriptor for `PenaltySaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List penaltySaveResponseDescriptor = $convert.base64Decode(
    'ChNQZW5hbHR5U2F2ZVJlc3BvbnNlEisKBGRhdGEYASABKAsyFy5sb2Fucy52MS5QZW5hbHR5T2'
    'JqZWN0UgRkYXRh');

@$core.Deprecated('Use penaltyWaiveRequestDescriptor instead')
const PenaltyWaiveRequest$json = {
  '1': 'PenaltyWaiveRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `PenaltyWaiveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List penaltyWaiveRequestDescriptor = $convert.base64Decode(
    'ChNQZW5hbHR5V2FpdmVSZXF1ZXN0EisKAmlkGAEgASgJQhu6SBhyFhADGCgyEFswLTlhLXpfLV'
    '17Myw0MH1SAmlkEhYKBnJlYXNvbhgCIAEoCVIGcmVhc29u');

@$core.Deprecated('Use penaltyWaiveResponseDescriptor instead')
const PenaltyWaiveResponse$json = {
  '1': 'PenaltyWaiveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.loans.v1.PenaltyObject', '10': 'data'},
  ],
};

/// Descriptor for `PenaltyWaiveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List penaltyWaiveResponseDescriptor = $convert.base64Decode(
    'ChRQZW5hbHR5V2FpdmVSZXNwb25zZRIrCgRkYXRhGAEgASgLMhcubG9hbnMudjEuUGVuYWx0eU'
    '9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use penaltySearchRequestDescriptor instead')
const PenaltySearchRequest$json = {
  '1': 'PenaltySearchRequest',
  '2': [
    {'1': 'loan_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'loanAccountId'},
    {'1': 'penalty_type', '3': 2, '4': 1, '5': 14, '6': '.loans.v1.PenaltyType', '10': 'penaltyType'},
    {'1': 'cursor', '3': 3, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `PenaltySearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List penaltySearchRequestDescriptor = $convert.base64Decode(
    'ChRQZW5hbHR5U2VhcmNoUmVxdWVzdBIxCg9sb2FuX2FjY291bnRfaWQYASABKAlCCbpIBnIEEA'
    'MYKFINbG9hbkFjY291bnRJZBI4CgxwZW5hbHR5X3R5cGUYAiABKA4yFS5sb2Fucy52MS5QZW5h'
    'bHR5VHlwZVILcGVuYWx0eVR5cGUSLQoGY3Vyc29yGAMgASgLMhUuY29tbW9uLnYxLlBhZ2VDdX'
    'Jzb3JSBmN1cnNvcg==');

@$core.Deprecated('Use penaltySearchResponseDescriptor instead')
const PenaltySearchResponse$json = {
  '1': 'PenaltySearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.loans.v1.PenaltyObject', '10': 'data'},
  ],
};

/// Descriptor for `PenaltySearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List penaltySearchResponseDescriptor = $convert.base64Decode(
    'ChVQZW5hbHR5U2VhcmNoUmVzcG9uc2USKwoEZGF0YRgBIAMoCzIXLmxvYW5zLnYxLlBlbmFsdH'
    'lPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use loanRestructureCreateRequestDescriptor instead')
const LoanRestructureCreateRequest$json = {
  '1': 'LoanRestructureCreateRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.loans.v1.LoanRestructureObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `LoanRestructureCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanRestructureCreateRequestDescriptor = $convert.base64Decode(
    'ChxMb2FuUmVzdHJ1Y3R1cmVDcmVhdGVSZXF1ZXN0EjsKBGRhdGEYASABKAsyHy5sb2Fucy52MS'
    '5Mb2FuUmVzdHJ1Y3R1cmVPYmplY3RCBrpIA8gBAVIEZGF0YQ==');

@$core.Deprecated('Use loanRestructureCreateResponseDescriptor instead')
const LoanRestructureCreateResponse$json = {
  '1': 'LoanRestructureCreateResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.loans.v1.LoanRestructureObject', '10': 'data'},
  ],
};

/// Descriptor for `LoanRestructureCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanRestructureCreateResponseDescriptor = $convert.base64Decode(
    'Ch1Mb2FuUmVzdHJ1Y3R1cmVDcmVhdGVSZXNwb25zZRIzCgRkYXRhGAEgASgLMh8ubG9hbnMudj'
    'EuTG9hblJlc3RydWN0dXJlT2JqZWN0UgRkYXRh');

@$core.Deprecated('Use loanRestructureApproveRequestDescriptor instead')
const LoanRestructureApproveRequest$json = {
  '1': 'LoanRestructureApproveRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `LoanRestructureApproveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanRestructureApproveRequestDescriptor = $convert.base64Decode(
    'Ch1Mb2FuUmVzdHJ1Y3R1cmVBcHByb3ZlUmVxdWVzdBIrCgJpZBgBIAEoCUIbukgYchYQAxgoMh'
    'BbMC05YS16Xy1dezMsNDB9UgJpZA==');

@$core.Deprecated('Use loanRestructureApproveResponseDescriptor instead')
const LoanRestructureApproveResponse$json = {
  '1': 'LoanRestructureApproveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.loans.v1.LoanRestructureObject', '10': 'data'},
  ],
};

/// Descriptor for `LoanRestructureApproveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanRestructureApproveResponseDescriptor = $convert.base64Decode(
    'Ch5Mb2FuUmVzdHJ1Y3R1cmVBcHByb3ZlUmVzcG9uc2USMwoEZGF0YRgBIAEoCzIfLmxvYW5zLn'
    'YxLkxvYW5SZXN0cnVjdHVyZU9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use loanRestructureRejectRequestDescriptor instead')
const LoanRestructureRejectRequest$json = {
  '1': 'LoanRestructureRejectRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `LoanRestructureRejectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanRestructureRejectRequestDescriptor = $convert.base64Decode(
    'ChxMb2FuUmVzdHJ1Y3R1cmVSZWplY3RSZXF1ZXN0EisKAmlkGAEgASgJQhu6SBhyFhADGCgyEF'
    'swLTlhLXpfLV17Myw0MH1SAmlkEhYKBnJlYXNvbhgCIAEoCVIGcmVhc29u');

@$core.Deprecated('Use loanRestructureRejectResponseDescriptor instead')
const LoanRestructureRejectResponse$json = {
  '1': 'LoanRestructureRejectResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.loans.v1.LoanRestructureObject', '10': 'data'},
  ],
};

/// Descriptor for `LoanRestructureRejectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanRestructureRejectResponseDescriptor = $convert.base64Decode(
    'Ch1Mb2FuUmVzdHJ1Y3R1cmVSZWplY3RSZXNwb25zZRIzCgRkYXRhGAEgASgLMh8ubG9hbnMudj'
    'EuTG9hblJlc3RydWN0dXJlT2JqZWN0UgRkYXRh');

@$core.Deprecated('Use loanRestructureSearchRequestDescriptor instead')
const LoanRestructureSearchRequest$json = {
  '1': 'LoanRestructureSearchRequest',
  '2': [
    {'1': 'loan_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'loanAccountId'},
    {'1': 'cursor', '3': 2, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `LoanRestructureSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanRestructureSearchRequestDescriptor = $convert.base64Decode(
    'ChxMb2FuUmVzdHJ1Y3R1cmVTZWFyY2hSZXF1ZXN0EjEKD2xvYW5fYWNjb3VudF9pZBgBIAEoCU'
    'IJukgGcgQQAxgoUg1sb2FuQWNjb3VudElkEi0KBmN1cnNvchgCIAEoCzIVLmNvbW1vbi52MS5Q'
    'YWdlQ3Vyc29yUgZjdXJzb3I=');

@$core.Deprecated('Use loanRestructureSearchResponseDescriptor instead')
const LoanRestructureSearchResponse$json = {
  '1': 'LoanRestructureSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.loans.v1.LoanRestructureObject', '10': 'data'},
  ],
};

/// Descriptor for `LoanRestructureSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanRestructureSearchResponseDescriptor = $convert.base64Decode(
    'Ch1Mb2FuUmVzdHJ1Y3R1cmVTZWFyY2hSZXNwb25zZRIzCgRkYXRhGAEgAygLMh8ubG9hbnMudj'
    'EuTG9hblJlc3RydWN0dXJlT2JqZWN0UgRkYXRh');

@$core.Deprecated('Use loanStatementRequestDescriptor instead')
const LoanStatementRequest$json = {
  '1': 'LoanStatementRequest',
  '2': [
    {'1': 'loan_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'loanAccountId'},
    {'1': 'from_date', '3': 2, '4': 1, '5': 9, '10': 'fromDate'},
    {'1': 'to_date', '3': 3, '4': 1, '5': 9, '10': 'toDate'},
  ],
};

/// Descriptor for `LoanStatementRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanStatementRequestDescriptor = $convert.base64Decode(
    'ChRMb2FuU3RhdGVtZW50UmVxdWVzdBIxCg9sb2FuX2FjY291bnRfaWQYASABKAlCCbpIBnIEEA'
    'MYKFINbG9hbkFjY291bnRJZBIbCglmcm9tX2RhdGUYAiABKAlSCGZyb21EYXRlEhcKB3RvX2Rh'
    'dGUYAyABKAlSBnRvRGF0ZQ==');

@$core.Deprecated('Use loanStatementResponseDescriptor instead')
const LoanStatementResponse$json = {
  '1': 'LoanStatementResponse',
  '2': [
    {'1': 'loan', '3': 1, '4': 1, '5': 11, '6': '.loans.v1.LoanAccountObject', '10': 'loan'},
    {'1': 'balance', '3': 2, '4': 1, '5': 11, '6': '.loans.v1.LoanBalanceObject', '10': 'balance'},
    {'1': 'entries', '3': 3, '4': 3, '5': 11, '6': '.loans.v1.LoanStatementEntry', '10': 'entries'},
  ],
};

/// Descriptor for `LoanStatementResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanStatementResponseDescriptor = $convert.base64Decode(
    'ChVMb2FuU3RhdGVtZW50UmVzcG9uc2USLwoEbG9hbhgBIAEoCzIbLmxvYW5zLnYxLkxvYW5BY2'
    'NvdW50T2JqZWN0UgRsb2FuEjUKB2JhbGFuY2UYAiABKAsyGy5sb2Fucy52MS5Mb2FuQmFsYW5j'
    'ZU9iamVjdFIHYmFsYW5jZRI2CgdlbnRyaWVzGAMgAygLMhwubG9hbnMudjEuTG9hblN0YXRlbW'
    'VudEVudHJ5UgdlbnRyaWVz');

@$core.Deprecated('Use reconciliationSaveRequestDescriptor instead')
const ReconciliationSaveRequest$json = {
  '1': 'ReconciliationSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.loans.v1.ReconciliationObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `ReconciliationSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconciliationSaveRequestDescriptor = $convert.base64Decode(
    'ChlSZWNvbmNpbGlhdGlvblNhdmVSZXF1ZXN0EjoKBGRhdGEYASABKAsyHi5sb2Fucy52MS5SZW'
    'NvbmNpbGlhdGlvbk9iamVjdEIGukgDyAEBUgRkYXRh');

@$core.Deprecated('Use reconciliationSaveResponseDescriptor instead')
const ReconciliationSaveResponse$json = {
  '1': 'ReconciliationSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.loans.v1.ReconciliationObject', '10': 'data'},
  ],
};

/// Descriptor for `ReconciliationSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconciliationSaveResponseDescriptor = $convert.base64Decode(
    'ChpSZWNvbmNpbGlhdGlvblNhdmVSZXNwb25zZRIyCgRkYXRhGAEgASgLMh4ubG9hbnMudjEuUm'
    'Vjb25jaWxpYXRpb25PYmplY3RSBGRhdGE=');

@$core.Deprecated('Use reconciliationSearchRequestDescriptor instead')
const ReconciliationSearchRequest$json = {
  '1': 'ReconciliationSearchRequest',
  '2': [
    {'1': 'loan_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'loanAccountId'},
    {'1': 'status', '3': 2, '4': 1, '5': 14, '6': '.loans.v1.ReconciliationStatus', '10': 'status'},
    {'1': 'cursor', '3': 3, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `ReconciliationSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconciliationSearchRequestDescriptor = $convert.base64Decode(
    'ChtSZWNvbmNpbGlhdGlvblNlYXJjaFJlcXVlc3QSNAoPbG9hbl9hY2NvdW50X2lkGAEgASgJQg'
    'y6SAnYAQFyBBADGChSDWxvYW5BY2NvdW50SWQSNgoGc3RhdHVzGAIgASgOMh4ubG9hbnMudjEu'
    'UmVjb25jaWxpYXRpb25TdGF0dXNSBnN0YXR1cxItCgZjdXJzb3IYAyABKAsyFS5jb21tb24udj'
    'EuUGFnZUN1cnNvclIGY3Vyc29y');

@$core.Deprecated('Use reconciliationSearchResponseDescriptor instead')
const ReconciliationSearchResponse$json = {
  '1': 'ReconciliationSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.loans.v1.ReconciliationObject', '10': 'data'},
  ],
};

/// Descriptor for `ReconciliationSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconciliationSearchResponseDescriptor = $convert.base64Decode(
    'ChxSZWNvbmNpbGlhdGlvblNlYXJjaFJlc3BvbnNlEjIKBGRhdGEYASADKAsyHi5sb2Fucy52MS'
    '5SZWNvbmNpbGlhdGlvbk9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use initiateCollectionRequestDescriptor instead')
const InitiateCollectionRequest$json = {
  '1': 'InitiateCollectionRequest',
  '2': [
    {'1': 'loan_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'loanAccountId'},
    {'1': 'amount', '3': 2, '4': 1, '5': 9, '10': 'amount'},
    {'1': 'phone_number', '3': 3, '4': 1, '5': 9, '10': 'phoneNumber'},
    {'1': 'idempotency_key', '3': 4, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `InitiateCollectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List initiateCollectionRequestDescriptor = $convert.base64Decode(
    'ChlJbml0aWF0ZUNvbGxlY3Rpb25SZXF1ZXN0EjEKD2xvYW5fYWNjb3VudF9pZBgBIAEoCUIJuk'
    'gGcgQQAxgoUg1sb2FuQWNjb3VudElkEhYKBmFtb3VudBgCIAEoCVIGYW1vdW50EiEKDHBob25l'
    'X251bWJlchgDIAEoCVILcGhvbmVOdW1iZXISJwoPaWRlbXBvdGVuY3lfa2V5GAQgASgJUg5pZG'
    'VtcG90ZW5jeUtleQ==');

@$core.Deprecated('Use initiateCollectionResponseDescriptor instead')
const InitiateCollectionResponse$json = {
  '1': 'InitiateCollectionResponse',
  '2': [
    {'1': 'payment_prompt_id', '3': 1, '4': 1, '5': 9, '10': 'paymentPromptId'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `InitiateCollectionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List initiateCollectionResponseDescriptor = $convert.base64Decode(
    'ChpJbml0aWF0ZUNvbGxlY3Rpb25SZXNwb25zZRIqChFwYXltZW50X3Byb21wdF9pZBgBIAEoCV'
    'IPcGF5bWVudFByb21wdElkEhYKBnN0YXR1cxgCIAEoCVIGc3RhdHVz');

@$core.Deprecated('Use loanStatusChangeSearchRequestDescriptor instead')
const LoanStatusChangeSearchRequest$json = {
  '1': 'LoanStatusChangeSearchRequest',
  '2': [
    {'1': 'loan_account_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'loanAccountId'},
    {'1': 'cursor', '3': 2, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `LoanStatusChangeSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanStatusChangeSearchRequestDescriptor = $convert.base64Decode(
    'Ch1Mb2FuU3RhdHVzQ2hhbmdlU2VhcmNoUmVxdWVzdBIxCg9sb2FuX2FjY291bnRfaWQYASABKA'
    'lCCbpIBnIEEAMYKFINbG9hbkFjY291bnRJZBItCgZjdXJzb3IYAiABKAsyFS5jb21tb24udjEu'
    'UGFnZUN1cnNvclIGY3Vyc29y');

@$core.Deprecated('Use loanStatusChangeSearchResponseDescriptor instead')
const LoanStatusChangeSearchResponse$json = {
  '1': 'LoanStatusChangeSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.loans.v1.LoanStatusChangeObject', '10': 'data'},
  ],
};

/// Descriptor for `LoanStatusChangeSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanStatusChangeSearchResponseDescriptor = $convert.base64Decode(
    'Ch5Mb2FuU3RhdHVzQ2hhbmdlU2VhcmNoUmVzcG9uc2USNAoEZGF0YRgBIAMoCzIgLmxvYW5zLn'
    'YxLkxvYW5TdGF0dXNDaGFuZ2VPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use loanRequestRequestDescriptor instead')
const LoanRequestRequest$json = {
  '1': 'LoanRequestRequest',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'clientId'},
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'productId'},
    {'1': 'requested_amount', '3': 3, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'requestedAmount'},
    {'1': 'requested_term_days', '3': 4, '4': 1, '5': 5, '10': 'requestedTermDays'},
    {'1': 'purpose', '3': 6, '4': 1, '5': 9, '10': 'purpose'},
    {'1': 'properties', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `LoanRequestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanRequestRequestDescriptor = $convert.base64Decode(
    'ChJMb2FuUmVxdWVzdFJlcXVlc3QSJgoJY2xpZW50X2lkGAEgASgJQgm6SAZyBBADGChSCGNsaW'
    'VudElkEigKCnByb2R1Y3RfaWQYAiABKAlCCbpIBnIEEAMYKFIJcHJvZHVjdElkEj0KEHJlcXVl'
    'c3RlZF9hbW91bnQYAyABKAsyEi5nb29nbGUudHlwZS5Nb25leVIPcmVxdWVzdGVkQW1vdW50Ei'
    '4KE3JlcXVlc3RlZF90ZXJtX2RheXMYBCABKAVSEXJlcXVlc3RlZFRlcm1EYXlzEhgKB3B1cnBv'
    'c2UYBiABKAlSB3B1cnBvc2USNwoKcHJvcGVydGllcxgHIAEoCzIXLmdvb2dsZS5wcm90b2J1Zi'
    '5TdHJ1Y3RSCnByb3BlcnRpZXM=');

@$core.Deprecated('Use loanRequestResponseDescriptor instead')
const LoanRequestResponse$json = {
  '1': 'LoanRequestResponse',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'risk_assessment_passed', '3': 3, '4': 1, '5': 8, '10': 'riskAssessmentPassed'},
    {'1': 'message', '3': 4, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `LoanRequestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanRequestResponseDescriptor = $convert.base64Decode(
    'ChNMb2FuUmVxdWVzdFJlc3BvbnNlEh0KCnJlcXVlc3RfaWQYASABKAlSCXJlcXVlc3RJZBIWCg'
    'ZzdGF0dXMYAiABKAlSBnN0YXR1cxI0ChZyaXNrX2Fzc2Vzc21lbnRfcGFzc2VkGAMgASgIUhRy'
    'aXNrQXNzZXNzbWVudFBhc3NlZBIYCgdtZXNzYWdlGAQgASgJUgdtZXNzYWdl');

const $core.Map<$core.String, $core.dynamic> LoanManagementServiceBase$json = {
  '1': 'LoanManagementService',
  '2': [
    {'1': 'LoanAccountCreate', '2': '.loans.v1.LoanAccountCreateRequest', '3': '.loans.v1.LoanAccountCreateResponse', '4': {}},
    {
      '1': 'LoanAccountGet',
      '2': '.loans.v1.LoanAccountGetRequest',
      '3': '.loans.v1.LoanAccountGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'LoanAccountSearch',
      '2': '.loans.v1.LoanAccountSearchRequest',
      '3': '.loans.v1.LoanAccountSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {
      '1': 'LoanBalanceGet',
      '2': '.loans.v1.LoanBalanceGetRequest',
      '3': '.loans.v1.LoanBalanceGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'LoanStatement',
      '2': '.loans.v1.LoanStatementRequest',
      '3': '.loans.v1.LoanStatementResponse',
      '4': {'34': 1},
    },
    {'1': 'DisbursementCreate', '2': '.loans.v1.DisbursementCreateRequest', '3': '.loans.v1.DisbursementCreateResponse', '4': {}},
    {
      '1': 'DisbursementGet',
      '2': '.loans.v1.DisbursementGetRequest',
      '3': '.loans.v1.DisbursementGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'DisbursementSearch',
      '2': '.loans.v1.DisbursementSearchRequest',
      '3': '.loans.v1.DisbursementSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'RepaymentRecord', '2': '.loans.v1.RepaymentRecordRequest', '3': '.loans.v1.RepaymentRecordResponse', '4': {}},
    {
      '1': 'RepaymentGet',
      '2': '.loans.v1.RepaymentGetRequest',
      '3': '.loans.v1.RepaymentGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'RepaymentSearch',
      '2': '.loans.v1.RepaymentSearchRequest',
      '3': '.loans.v1.RepaymentSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {
      '1': 'RepaymentScheduleGet',
      '2': '.loans.v1.RepaymentScheduleGetRequest',
      '3': '.loans.v1.RepaymentScheduleGetResponse',
      '4': {'34': 1},
    },
    {'1': 'PenaltySave', '2': '.loans.v1.PenaltySaveRequest', '3': '.loans.v1.PenaltySaveResponse', '4': {}},
    {'1': 'PenaltyWaive', '2': '.loans.v1.PenaltyWaiveRequest', '3': '.loans.v1.PenaltyWaiveResponse', '4': {}},
    {
      '1': 'PenaltySearch',
      '2': '.loans.v1.PenaltySearchRequest',
      '3': '.loans.v1.PenaltySearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'LoanRestructureCreate', '2': '.loans.v1.LoanRestructureCreateRequest', '3': '.loans.v1.LoanRestructureCreateResponse', '4': {}},
    {'1': 'LoanRestructureApprove', '2': '.loans.v1.LoanRestructureApproveRequest', '3': '.loans.v1.LoanRestructureApproveResponse', '4': {}},
    {'1': 'LoanRestructureReject', '2': '.loans.v1.LoanRestructureRejectRequest', '3': '.loans.v1.LoanRestructureRejectResponse', '4': {}},
    {
      '1': 'LoanRestructureSearch',
      '2': '.loans.v1.LoanRestructureSearchRequest',
      '3': '.loans.v1.LoanRestructureSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'ReconciliationSave', '2': '.loans.v1.ReconciliationSaveRequest', '3': '.loans.v1.ReconciliationSaveResponse', '4': {}},
    {
      '1': 'ReconciliationSearch',
      '2': '.loans.v1.ReconciliationSearchRequest',
      '3': '.loans.v1.ReconciliationSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'InitiateCollection', '2': '.loans.v1.InitiateCollectionRequest', '3': '.loans.v1.InitiateCollectionResponse', '4': {}},
    {
      '1': 'LoanStatusChangeSearch',
      '2': '.loans.v1.LoanStatusChangeSearchRequest',
      '3': '.loans.v1.LoanStatusChangeSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'LoanRequest', '2': '.loans.v1.LoanRequestRequest', '3': '.loans.v1.LoanRequestResponse', '4': {}},
  ],
  '3': {},
};

@$core.Deprecated('Use loanManagementServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> LoanManagementServiceBase$messageJson = {
  '.loans.v1.LoanAccountCreateRequest': LoanAccountCreateRequest$json,
  '.loans.v1.LoanAccountCreateResponse': LoanAccountCreateResponse$json,
  '.loans.v1.LoanAccountObject': LoanAccountObject$json,
  '.google.type.Money': $9.Money$json,
  '.google.protobuf.Struct': $6.Struct$json,
  '.google.protobuf.Struct.FieldsEntry': $6.Struct_FieldsEntry$json,
  '.google.protobuf.Value': $6.Value$json,
  '.google.protobuf.ListValue': $6.ListValue$json,
  '.loans.v1.LoanAccountGetRequest': LoanAccountGetRequest$json,
  '.loans.v1.LoanAccountGetResponse': LoanAccountGetResponse$json,
  '.loans.v1.LoanAccountSearchRequest': LoanAccountSearchRequest$json,
  '.common.v1.PageCursor': $7.PageCursor$json,
  '.loans.v1.LoanAccountSearchResponse': LoanAccountSearchResponse$json,
  '.loans.v1.LoanBalanceGetRequest': LoanBalanceGetRequest$json,
  '.loans.v1.LoanBalanceGetResponse': LoanBalanceGetResponse$json,
  '.loans.v1.LoanBalanceObject': LoanBalanceObject$json,
  '.loans.v1.LoanStatementRequest': LoanStatementRequest$json,
  '.loans.v1.LoanStatementResponse': LoanStatementResponse$json,
  '.loans.v1.LoanStatementEntry': LoanStatementEntry$json,
  '.loans.v1.DisbursementCreateRequest': DisbursementCreateRequest$json,
  '.loans.v1.DisbursementCreateResponse': DisbursementCreateResponse$json,
  '.loans.v1.DisbursementObject': DisbursementObject$json,
  '.loans.v1.DisbursementGetRequest': DisbursementGetRequest$json,
  '.loans.v1.DisbursementGetResponse': DisbursementGetResponse$json,
  '.loans.v1.DisbursementSearchRequest': DisbursementSearchRequest$json,
  '.loans.v1.DisbursementSearchResponse': DisbursementSearchResponse$json,
  '.loans.v1.RepaymentRecordRequest': RepaymentRecordRequest$json,
  '.loans.v1.RepaymentRecordResponse': RepaymentRecordResponse$json,
  '.loans.v1.RepaymentObject': RepaymentObject$json,
  '.loans.v1.RepaymentGetRequest': RepaymentGetRequest$json,
  '.loans.v1.RepaymentGetResponse': RepaymentGetResponse$json,
  '.loans.v1.RepaymentSearchRequest': RepaymentSearchRequest$json,
  '.loans.v1.RepaymentSearchResponse': RepaymentSearchResponse$json,
  '.loans.v1.RepaymentScheduleGetRequest': RepaymentScheduleGetRequest$json,
  '.loans.v1.RepaymentScheduleGetResponse': RepaymentScheduleGetResponse$json,
  '.loans.v1.RepaymentScheduleObject': RepaymentScheduleObject$json,
  '.loans.v1.ScheduleEntryObject': ScheduleEntryObject$json,
  '.loans.v1.PenaltySaveRequest': PenaltySaveRequest$json,
  '.loans.v1.PenaltyObject': PenaltyObject$json,
  '.loans.v1.PenaltySaveResponse': PenaltySaveResponse$json,
  '.loans.v1.PenaltyWaiveRequest': PenaltyWaiveRequest$json,
  '.loans.v1.PenaltyWaiveResponse': PenaltyWaiveResponse$json,
  '.loans.v1.PenaltySearchRequest': PenaltySearchRequest$json,
  '.loans.v1.PenaltySearchResponse': PenaltySearchResponse$json,
  '.loans.v1.LoanRestructureCreateRequest': LoanRestructureCreateRequest$json,
  '.loans.v1.LoanRestructureObject': LoanRestructureObject$json,
  '.loans.v1.LoanRestructureCreateResponse': LoanRestructureCreateResponse$json,
  '.loans.v1.LoanRestructureApproveRequest': LoanRestructureApproveRequest$json,
  '.loans.v1.LoanRestructureApproveResponse': LoanRestructureApproveResponse$json,
  '.loans.v1.LoanRestructureRejectRequest': LoanRestructureRejectRequest$json,
  '.loans.v1.LoanRestructureRejectResponse': LoanRestructureRejectResponse$json,
  '.loans.v1.LoanRestructureSearchRequest': LoanRestructureSearchRequest$json,
  '.loans.v1.LoanRestructureSearchResponse': LoanRestructureSearchResponse$json,
  '.loans.v1.ReconciliationSaveRequest': ReconciliationSaveRequest$json,
  '.loans.v1.ReconciliationObject': ReconciliationObject$json,
  '.loans.v1.ReconciliationSaveResponse': ReconciliationSaveResponse$json,
  '.loans.v1.ReconciliationSearchRequest': ReconciliationSearchRequest$json,
  '.loans.v1.ReconciliationSearchResponse': ReconciliationSearchResponse$json,
  '.loans.v1.InitiateCollectionRequest': InitiateCollectionRequest$json,
  '.loans.v1.InitiateCollectionResponse': InitiateCollectionResponse$json,
  '.loans.v1.LoanStatusChangeSearchRequest': LoanStatusChangeSearchRequest$json,
  '.loans.v1.LoanStatusChangeSearchResponse': LoanStatusChangeSearchResponse$json,
  '.loans.v1.LoanStatusChangeObject': LoanStatusChangeObject$json,
  '.loans.v1.LoanRequestRequest': LoanRequestRequest$json,
  '.loans.v1.LoanRequestResponse': LoanRequestResponse$json,
};

/// Descriptor for `LoanManagementService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List loanManagementServiceDescriptor = $convert.base64Decode(
    'ChVMb2FuTWFuYWdlbWVudFNlcnZpY2US8QEKEUxvYW5BY2NvdW50Q3JlYXRlEiIubG9hbnMudj'
    'EuTG9hbkFjY291bnRDcmVhdGVSZXF1ZXN0GiMubG9hbnMudjEuTG9hbkFjY291bnRDcmVhdGVS'
    'ZXNwb25zZSKSAbpHfgoMTG9hbkFjY291bnRzEhVDcmVhdGUgYSBsb2FuIGFjY291bnQaRENyZW'
    'F0ZXMgYSBuZXcgbG9hbiBhY2NvdW50IGZyb20gYW4gYXBwcm92ZWQgb3JpZ2luYXRpb24gYXBw'
    'bGljYXRpb24uKhFsb2FuQWNjb3VudENyZWF0ZYK1GA0KC2xvYW5fbWFuYWdlEt4BCg5Mb2FuQW'
    'Njb3VudEdldBIfLmxvYW5zLnYxLkxvYW5BY2NvdW50R2V0UmVxdWVzdBogLmxvYW5zLnYxLkxv'
    'YW5BY2NvdW50R2V0UmVzcG9uc2UiiAGQAgG6R3MKDExvYW5BY2NvdW50cxIYR2V0IGEgbG9hbi'
    'BhY2NvdW50IGJ5IElEGjlSZXRyaWV2ZXMgYSBsb2FuIGFjY291bnQgcmVjb3JkIGJ5IGl0cyB1'
    'bmlxdWUgaWRlbnRpZmllci4qDmxvYW5BY2NvdW50R2V0grUYCwoJbG9hbl92aWV3EooCChFMb2'
    'FuQWNjb3VudFNlYXJjaBIiLmxvYW5zLnYxLkxvYW5BY2NvdW50U2VhcmNoUmVxdWVzdBojLmxv'
    'YW5zLnYxLkxvYW5BY2NvdW50U2VhcmNoUmVzcG9uc2UiqQGQAgG6R5MBCgxMb2FuQWNjb3VudH'
    'MSFFNlYXJjaCBsb2FuIGFjY291bnRzGlpTZWFyY2hlcyBmb3IgbG9hbiBhY2NvdW50cy4gU3Vw'
    'cG9ydHMgZmlsdGVyaW5nIGJ5IGNsaWVudCwgYWdlbnQsIGJyYW5jaCwgYmFuaywgYW5kIHN0YX'
    'R1cy4qEWxvYW5BY2NvdW50U2VhcmNogrUYCwoJbG9hbl92aWV3MAES1wEKDkxvYW5CYWxhbmNl'
    'R2V0Eh8ubG9hbnMudjEuTG9hbkJhbGFuY2VHZXRSZXF1ZXN0GiAubG9hbnMudjEuTG9hbkJhbG'
    'FuY2VHZXRSZXNwb25zZSKBAZACAbpHbAoMTG9hbkFjY291bnRzEhBHZXQgbG9hbiBiYWxhbmNl'
    'GjpSZXRyaWV2ZXMgdGhlIGN1cnJlbnQgYmFsYW5jZSBzbmFwc2hvdCBmb3IgYSBsb2FuIGFjY2'
    '91bnQuKg5sb2FuQmFsYW5jZUdldIK1GAsKCWxvYW5fdmlldxLqAQoNTG9hblN0YXRlbWVudBIe'
    'LmxvYW5zLnYxLkxvYW5TdGF0ZW1lbnRSZXF1ZXN0Gh8ubG9hbnMudjEuTG9hblN0YXRlbWVudF'
    'Jlc3BvbnNlIpcBkAIBukeBAQoMTG9hbkFjY291bnRzEhJHZXQgbG9hbiBzdGF0ZW1lbnQaTkdl'
    'bmVyYXRlcyBhIGxvYW4gc3RhdGVtZW50IHdpdGggYWxsIHRyYW5zYWN0aW9ucyBmb3IgdGhlIH'
    'NwZWNpZmllZCBkYXRlIHJhbmdlLioNbG9hblN0YXRlbWVudIK1GAsKCWxvYW5fdmlldxKBAgoS'
    'RGlzYnVyc2VtZW50Q3JlYXRlEiMubG9hbnMudjEuRGlzYnVyc2VtZW50Q3JlYXRlUmVxdWVzdB'
    'okLmxvYW5zLnYxLkRpc2J1cnNlbWVudENyZWF0ZVJlc3BvbnNlIp8BukeCAQoNRGlzYnVyc2Vt'
    'ZW50cxIVQ3JlYXRlIGEgZGlzYnVyc2VtZW50GkZJbml0aWF0ZXMgYSBsb2FuIGRpc2J1cnNlbW'
    'VudCB0byB0aGUgY2xpZW50IHZpYSB0aGUgc3BlY2lmaWVkIGNoYW5uZWwuKhJkaXNidXJzZW1l'
    'bnRDcmVhdGWCtRgVChNkaXNidXJzZW1lbnRfbWFuYWdlEusBCg9EaXNidXJzZW1lbnRHZXQSIC'
    '5sb2Fucy52MS5EaXNidXJzZW1lbnRHZXRSZXF1ZXN0GiEubG9hbnMudjEuRGlzYnVyc2VtZW50'
    'R2V0UmVzcG9uc2UikgGQAgG6R3UKDURpc2J1cnNlbWVudHMSGEdldCBhIGRpc2J1cnNlbWVudC'
    'BieSBJRBo5UmV0cmlldmVzIGEgZGlzYnVyc2VtZW50IHJlY29yZCBieSBpdHMgdW5pcXVlIGlk'
    'ZW50aWZpZXIuKg9kaXNidXJzZW1lbnRHZXSCtRgTChFkaXNidXJzZW1lbnRfdmlldxLqAQoSRG'
    'lzYnVyc2VtZW50U2VhcmNoEiMubG9hbnMudjEuRGlzYnVyc2VtZW50U2VhcmNoUmVxdWVzdBok'
    'LmxvYW5zLnYxLkRpc2J1cnNlbWVudFNlYXJjaFJlc3BvbnNlIoYBkAIBukdpCg1EaXNidXJzZW'
    '1lbnRzEhRTZWFyY2ggZGlzYnVyc2VtZW50cxouU2VhcmNoZXMgZm9yIGRpc2J1cnNlbWVudHMg'
    'Zm9yIGEgbG9hbiBhY2NvdW50LioSZGlzYnVyc2VtZW50U2VhcmNogrUYEwoRZGlzYnVyc2VtZW'
    '50X3ZpZXcwARLzAQoPUmVwYXltZW50UmVjb3JkEiAubG9hbnMudjEuUmVwYXltZW50UmVjb3Jk'
    'UmVxdWVzdBohLmxvYW5zLnYxLlJlcGF5bWVudFJlY29yZFJlc3BvbnNlIpoBukeAAQoKUmVwYX'
    'ltZW50cxISUmVjb3JkIGEgcmVwYXltZW50Gk1SZWNvcmRzIGFuIGluY29taW5nIHBheW1lbnQg'
    'YW5kIGFsbG9jYXRlcyBpdCB0byBvdXRzdGFuZGluZyBzY2hlZHVsZSBlbnRyaWVzLioPcmVwYX'
    'ltZW50UmVjb3JkgrUYEgoQcmVwYXltZW50X21hbmFnZRLTAQoMUmVwYXltZW50R2V0Eh0ubG9h'
    'bnMudjEuUmVwYXltZW50R2V0UmVxdWVzdBoeLmxvYW5zLnYxLlJlcGF5bWVudEdldFJlc3Bvbn'
    'NlIoMBkAIBukdpCgpSZXBheW1lbnRzEhVHZXQgYSByZXBheW1lbnQgYnkgSUQaNlJldHJpZXZl'
    'cyBhIHJlcGF5bWVudCByZWNvcmQgYnkgaXRzIHVuaXF1ZSBpZGVudGlmaWVyLioMcmVwYXltZW'
    '50R2V0grUYEAoOcmVwYXltZW50X3ZpZXcS0QEKD1JlcGF5bWVudFNlYXJjaBIgLmxvYW5zLnYx'
    'LlJlcGF5bWVudFNlYXJjaFJlcXVlc3QaIS5sb2Fucy52MS5SZXBheW1lbnRTZWFyY2hSZXNwb2'
    '5zZSJ3kAIBukddCgpSZXBheW1lbnRzEhFTZWFyY2ggcmVwYXltZW50cxorU2VhcmNoZXMgZm9y'
    'IHJlcGF5bWVudHMgZm9yIGEgbG9hbiBhY2NvdW50LioPcmVwYXltZW50U2VhcmNogrUYEAoOcm'
    'VwYXltZW50X3ZpZXcwARKFAgoUUmVwYXltZW50U2NoZWR1bGVHZXQSJS5sb2Fucy52MS5SZXBh'
    'eW1lbnRTY2hlZHVsZUdldFJlcXVlc3QaJi5sb2Fucy52MS5SZXBheW1lbnRTY2hlZHVsZUdldF'
    'Jlc3BvbnNlIp0BkAIBukeCAQoSUmVwYXltZW50U2NoZWR1bGVzEhZHZXQgcmVwYXltZW50IHNj'
    'aGVkdWxlGj5SZXRyaWV2ZXMgdGhlIGFjdGl2ZSBhbW9ydGl6YXRpb24gc2NoZWR1bGUgZm9yIG'
    'EgbG9hbiBhY2NvdW50LioUcmVwYXltZW50U2NoZWR1bGVHZXSCtRgQCg5yZXBheW1lbnRfdmll'
    'dxLRAQoLUGVuYWx0eVNhdmUSHC5sb2Fucy52MS5QZW5hbHR5U2F2ZVJlcXVlc3QaHS5sb2Fucy'
    '52MS5QZW5hbHR5U2F2ZVJlc3BvbnNlIoQBukdtCglQZW5hbHRpZXMSGkNyZWF0ZSBvciB1cGRh'
    'dGUgYSBwZW5hbHR5GjdDcmVhdGVzIG9yIHVwZGF0ZXMgYSBwZW5hbHR5IHJlY29yZCBmb3IgYS'
    'Bsb2FuIGFjY291bnQuKgtwZW5hbHR5U2F2ZYK1GBAKDnBlbmFsdHlfbWFuYWdlErEBCgxQZW5h'
    'bHR5V2FpdmUSHS5sb2Fucy52MS5QZW5hbHR5V2FpdmVSZXF1ZXN0Gh4ubG9hbnMudjEuUGVuYW'
    'x0eVdhaXZlUmVzcG9uc2UiYrpHSwoJUGVuYWx0aWVzEg9XYWl2ZSBhIHBlbmFsdHkaH1dhaXZl'
    'cyBhIHBlbmFsdHkgd2l0aCBhIHJlYXNvbi4qDHBlbmFsdHlXYWl2ZYK1GBAKDnBlbmFsdHlfbW'
    'FuYWdlEsQBCg1QZW5hbHR5U2VhcmNoEh4ubG9hbnMudjEuUGVuYWx0eVNlYXJjaFJlcXVlc3Qa'
    'Hy5sb2Fucy52MS5QZW5hbHR5U2VhcmNoUmVzcG9uc2UicJACAbpHWAoJUGVuYWx0aWVzEhBTZW'
    'FyY2ggcGVuYWx0aWVzGipTZWFyY2hlcyBmb3IgcGVuYWx0aWVzIGZvciBhIGxvYW4gYWNjb3Vu'
    'dC4qDXBlbmFsdHlTZWFyY2iCtRgOCgxwZW5hbHR5X3ZpZXcwARLyAQoVTG9hblJlc3RydWN0dX'
    'JlQ3JlYXRlEiYubG9hbnMudjEuTG9hblJlc3RydWN0dXJlQ3JlYXRlUmVxdWVzdBonLmxvYW5z'
    'LnYxLkxvYW5SZXN0cnVjdHVyZUNyZWF0ZVJlc3BvbnNlIocBukdsCgxSZXN0cnVjdHVyZXMSHE'
    'NyZWF0ZSBhIHJlc3RydWN0dXJlIHJlcXVlc3QaJ0NyZWF0ZXMgYSBuZXcgbG9hbiByZXN0cnVj'
    'dHVyZSByZXF1ZXN0LioVbG9hblJlc3RydWN0dXJlQ3JlYXRlgrUYFAoScmVzdHJ1Y3R1cmVfbW'
    'FuYWdlEqECChZMb2FuUmVzdHJ1Y3R1cmVBcHByb3ZlEicubG9hbnMudjEuTG9hblJlc3RydWN0'
    'dXJlQXBwcm92ZVJlcXVlc3QaKC5sb2Fucy52MS5Mb2FuUmVzdHJ1Y3R1cmVBcHByb3ZlUmVzcG'
    '9uc2UiswG6R5cBCgxSZXN0cnVjdHVyZXMSFUFwcHJvdmUgYSByZXN0cnVjdHVyZRpYQXBwcm92'
    'ZXMgYSBwZW5kaW5nIGxvYW4gcmVzdHJ1Y3R1cmUsIG1vZGlmeWluZyBsb2FuIHRlcm1zIGFuZC'
    'ByZWdlbmVyYXRpbmcgdGhlIHNjaGVkdWxlLioWbG9hblJlc3RydWN0dXJlQXBwcm92ZYK1GBQK'
    'EnJlc3RydWN0dXJlX21hbmFnZRL0AQoVTG9hblJlc3RydWN0dXJlUmVqZWN0EiYubG9hbnMudj'
    'EuTG9hblJlc3RydWN0dXJlUmVqZWN0UmVxdWVzdBonLmxvYW5zLnYxLkxvYW5SZXN0cnVjdHVy'
    'ZVJlamVjdFJlc3BvbnNlIokBukduCgxSZXN0cnVjdHVyZXMSFFJlamVjdCBhIHJlc3RydWN0dX'
    'JlGjFSZWplY3RzIGEgcGVuZGluZyBsb2FuIHJlc3RydWN0dXJlIHdpdGggYSByZWFzb24uKhVs'
    'b2FuUmVzdHJ1Y3R1cmVSZWplY3SCtRgUChJyZXN0cnVjdHVyZV9tYW5hZ2US+QEKFUxvYW5SZX'
    'N0cnVjdHVyZVNlYXJjaBImLmxvYW5zLnYxLkxvYW5SZXN0cnVjdHVyZVNlYXJjaFJlcXVlc3Qa'
    'Jy5sb2Fucy52MS5Mb2FuUmVzdHJ1Y3R1cmVTZWFyY2hSZXNwb25zZSKMAZACAbpHcAoMUmVzdH'
    'J1Y3R1cmVzEhNTZWFyY2ggcmVzdHJ1Y3R1cmVzGjRTZWFyY2hlcyBmb3IgcmVzdHJ1Y3R1cmUg'
    'cmVjb3JkcyBmb3IgYSBsb2FuIGFjY291bnQuKhVsb2FuUmVzdHJ1Y3R1cmVTZWFyY2iCtRgSCh'
    'ByZXN0cnVjdHVyZV92aWV3MAES/AEKElJlY29uY2lsaWF0aW9uU2F2ZRIjLmxvYW5zLnYxLlJl'
    'Y29uY2lsaWF0aW9uU2F2ZVJlcXVlc3QaJC5sb2Fucy52MS5SZWNvbmNpbGlhdGlvblNhdmVSZX'
    'Nwb25zZSKaAbpHfAoOUmVjb25jaWxpYXRpb24SIUNyZWF0ZSBvciB1cGRhdGUgYSByZWNvbmNp'
    'bGlhdGlvbhozQ3JlYXRlcyBvciB1cGRhdGVzIGEgcGF5bWVudCByZWNvbmNpbGlhdGlvbiByZW'
    'NvcmQuKhJyZWNvbmNpbGlhdGlvblNhdmWCtRgXChVyZWNvbmNpbGlhdGlvbl9tYW5hZ2USlwIK'
    'FFJlY29uY2lsaWF0aW9uU2VhcmNoEiUubG9hbnMudjEuUmVjb25jaWxpYXRpb25TZWFyY2hSZX'
    'F1ZXN0GiYubG9hbnMudjEuUmVjb25jaWxpYXRpb25TZWFyY2hSZXNwb25zZSKtAZACAbpHiwEK'
    'DlJlY29uY2lsaWF0aW9uEhZTZWFyY2ggcmVjb25jaWxpYXRpb25zGktTZWFyY2hlcyBmb3Igcm'
    'Vjb25jaWxpYXRpb24gcmVjb3Jkcy4gU3VwcG9ydHMgZmlsdGVyaW5nIGJ5IGxvYW4gYW5kIHN0'
    'YXR1cy4qFHJlY29uY2lsaWF0aW9uU2VhcmNogrUYFwoVcmVjb25jaWxpYXRpb25fbWFuYWdlMA'
    'EShQIKEkluaXRpYXRlQ29sbGVjdGlvbhIjLmxvYW5zLnYxLkluaXRpYXRlQ29sbGVjdGlvblJl'
    'cXVlc3QaJC5sb2Fucy52MS5Jbml0aWF0ZUNvbGxlY3Rpb25SZXNwb25zZSKjAbpHiAEKCkNvbG'
    'xlY3Rpb24SG0luaXRpYXRlIHBheW1lbnQgY29sbGVjdGlvbhpJU2VuZHMgYW4gU1RLIHB1c2gg'
    'b3IgcGF5bWVudCBwcm9tcHQgdG8gY29sbGVjdCBhIHBheW1lbnQgZnJvbSB0aGUgY2xpZW50Li'
    'oSaW5pdGlhdGVDb2xsZWN0aW9ugrUYEwoRY29sbGVjdGlvbl9tYW5hZ2US/QEKFkxvYW5TdGF0'
    'dXNDaGFuZ2VTZWFyY2gSJy5sb2Fucy52MS5Mb2FuU3RhdHVzQ2hhbmdlU2VhcmNoUmVxdWVzdB'
    'ooLmxvYW5zLnYxLkxvYW5TdGF0dXNDaGFuZ2VTZWFyY2hSZXNwb25zZSKNAZACAbpHeAoFQXVk'
    'aXQSGlNlYXJjaCBsb2FuIHN0YXR1cyBjaGFuZ2VzGjtSZXRyaWV2ZXMgdGhlIHN0YXR1cyBjaG'
    'FuZ2UgYXVkaXQgdHJhaWwgZm9yIGEgbG9hbiBhY2NvdW50LioWbG9hblN0YXR1c0NoYW5nZVNl'
    'YXJjaIK1GAsKCWxvYW5fdmlldzABEuMCCgtMb2FuUmVxdWVzdBIcLmxvYW5zLnYxLkxvYW5SZX'
    'F1ZXN0UmVxdWVzdBodLmxvYW5zLnYxLkxvYW5SZXF1ZXN0UmVzcG9uc2UilgK6R4ECCgtMb2Fu'
    'UmVxdWVzdBIeUmVxdWVzdCBhIGxvYW4gKGRpcmVjdCBjbGllbnQpGsQBQSBjbGllbnQtZmFjaW'
    '5nIEFQSSBmb3IgZGlyZWN0IGNsaWVudCBsb2FuIHJlcXVlc3RzLiBWYWxpZGF0ZXMgZWxpZ2li'
    'aWxpdHksIHJ1bnMgYXV0b21hdGVkIHJpc2sgY2hlY2tzLCBhbmQgcm91dGVzIHRvIHRoZSBhZ2'
    'VudCBmb3IgYXBwcm92YWwuIFJldHVybnMgdGhlIHJlcXVlc3Qgc3RhdHVzIGFuZCByZWZlcmVu'
    'Y2UgZm9yIHRyYWNraW5nLioLbG9hblJlcXVlc3SCtRgNCgtsb2FuX21hbmFnZRqCCYK1GP0ICg'
    '1zZXJ2aWNlX2xvYW5zEglsb2FuX3ZpZXcSC2xvYW5fbWFuYWdlEhFkaXNidXJzZW1lbnRfdmll'
    'dxITZGlzYnVyc2VtZW50X21hbmFnZRIOcmVwYXltZW50X3ZpZXcSEHJlcGF5bWVudF9tYW5hZ2'
    'USDHBlbmFsdHlfdmlldxIOcGVuYWx0eV9tYW5hZ2USEHJlc3RydWN0dXJlX3ZpZXcSEnJlc3Ry'
    'dWN0dXJlX21hbmFnZRIVcmVjb25jaWxpYXRpb25fbWFuYWdlEhFjb2xsZWN0aW9uX21hbmFnZR'
    'rSAQgBEglsb2FuX3ZpZXcSC2xvYW5fbWFuYWdlEhFkaXNidXJzZW1lbnRfdmlldxITZGlzYnVy'
    'c2VtZW50X21hbmFnZRIOcmVwYXltZW50X3ZpZXcSEHJlcGF5bWVudF9tYW5hZ2USDHBlbmFsdH'
    'lfdmlldxIOcGVuYWx0eV9tYW5hZ2USEHJlc3RydWN0dXJlX3ZpZXcSEnJlc3RydWN0dXJlX21h'
    'bmFnZRIVcmVjb25jaWxpYXRpb25fbWFuYWdlEhFjb2xsZWN0aW9uX21hbmFnZRrSAQgCEglsb2'
    'FuX3ZpZXcSC2xvYW5fbWFuYWdlEhFkaXNidXJzZW1lbnRfdmlldxITZGlzYnVyc2VtZW50X21h'
    'bmFnZRIOcmVwYXltZW50X3ZpZXcSEHJlcGF5bWVudF9tYW5hZ2USDHBlbmFsdHlfdmlldxIOcG'
    'VuYWx0eV9tYW5hZ2USEHJlc3RydWN0dXJlX3ZpZXcSEnJlc3RydWN0dXJlX21hbmFnZRIVcmVj'
    'b25jaWxpYXRpb25fbWFuYWdlEhFjb2xsZWN0aW9uX21hbmFnZRp5CAMSCWxvYW5fdmlldxIRZG'
    'lzYnVyc2VtZW50X3ZpZXcSDnJlcGF5bWVudF92aWV3EhByZXBheW1lbnRfbWFuYWdlEgxwZW5h'
    'bHR5X3ZpZXcSEHJlc3RydWN0dXJlX3ZpZXcSFXJlY29uY2lsaWF0aW9uX21hbmFnZRpQCAQSCW'
    'xvYW5fdmlldxIRZGlzYnVyc2VtZW50X3ZpZXcSDnJlcGF5bWVudF92aWV3EgxwZW5hbHR5X3Zp'
    'ZXcSEHJlc3RydWN0dXJlX3ZpZXcaUAgFEglsb2FuX3ZpZXcSEWRpc2J1cnNlbWVudF92aWV3Eg'
    '5yZXBheW1lbnRfdmlldxIMcGVuYWx0eV92aWV3EhByZXN0cnVjdHVyZV92aWV3GtIBCAYSCWxv'
    'YW5fdmlldxILbG9hbl9tYW5hZ2USEWRpc2J1cnNlbWVudF92aWV3EhNkaXNidXJzZW1lbnRfbW'
    'FuYWdlEg5yZXBheW1lbnRfdmlldxIQcmVwYXltZW50X21hbmFnZRIMcGVuYWx0eV92aWV3Eg5w'
    'ZW5hbHR5X21hbmFnZRIQcmVzdHJ1Y3R1cmVfdmlldxIScmVzdHJ1Y3R1cmVfbWFuYWdlEhVyZW'
    'NvbmNpbGlhdGlvbl9tYW5hZ2USEWNvbGxlY3Rpb25fbWFuYWdl');

