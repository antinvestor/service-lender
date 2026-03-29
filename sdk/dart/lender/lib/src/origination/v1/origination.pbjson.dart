//
//  Generated code. Do not modify.
//  source: origination/v1/origination.proto
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

@$core.Deprecated('Use loanProductTypeDescriptor instead')
const LoanProductType$json = {
  '1': 'LoanProductType',
  '2': [
    {'1': 'LOAN_PRODUCT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'LOAN_PRODUCT_TYPE_TERM', '2': 1},
    {'1': 'LOAN_PRODUCT_TYPE_REVOLVING', '2': 2},
    {'1': 'LOAN_PRODUCT_TYPE_BULLET', '2': 3},
    {'1': 'LOAN_PRODUCT_TYPE_GRADUATED', '2': 4},
  ],
};

/// Descriptor for `LoanProductType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List loanProductTypeDescriptor = $convert.base64Decode(
    'Cg9Mb2FuUHJvZHVjdFR5cGUSIQodTE9BTl9QUk9EVUNUX1RZUEVfVU5TUEVDSUZJRUQQABIaCh'
    'ZMT0FOX1BST0RVQ1RfVFlQRV9URVJNEAESHwobTE9BTl9QUk9EVUNUX1RZUEVfUkVWT0xWSU5H'
    'EAISHAoYTE9BTl9QUk9EVUNUX1RZUEVfQlVMTEVUEAMSHwobTE9BTl9QUk9EVUNUX1RZUEVfR1'
    'JBRFVBVEVEEAQ=');

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

@$core.Deprecated('Use applicationStatusDescriptor instead')
const ApplicationStatus$json = {
  '1': 'ApplicationStatus',
  '2': [
    {'1': 'APPLICATION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'APPLICATION_STATUS_DRAFT', '2': 1},
    {'1': 'APPLICATION_STATUS_SUBMITTED', '2': 2},
    {'1': 'APPLICATION_STATUS_KYC_PENDING', '2': 3},
    {'1': 'APPLICATION_STATUS_DOCUMENTS_PENDING', '2': 4},
    {'1': 'APPLICATION_STATUS_VERIFICATION', '2': 5},
    {'1': 'APPLICATION_STATUS_UNDERWRITING', '2': 6},
    {'1': 'APPLICATION_STATUS_APPROVED', '2': 7},
    {'1': 'APPLICATION_STATUS_REJECTED', '2': 8},
    {'1': 'APPLICATION_STATUS_OFFER_GENERATED', '2': 9},
    {'1': 'APPLICATION_STATUS_OFFER_ACCEPTED', '2': 10},
    {'1': 'APPLICATION_STATUS_OFFER_DECLINED', '2': 11},
    {'1': 'APPLICATION_STATUS_LOAN_CREATED', '2': 12},
    {'1': 'APPLICATION_STATUS_CANCELLED', '2': 13},
    {'1': 'APPLICATION_STATUS_EXPIRED', '2': 14},
  ],
};

/// Descriptor for `ApplicationStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List applicationStatusDescriptor = $convert.base64Decode(
    'ChFBcHBsaWNhdGlvblN0YXR1cxIiCh5BUFBMSUNBVElPTl9TVEFUVVNfVU5TUEVDSUZJRUQQAB'
    'IcChhBUFBMSUNBVElPTl9TVEFUVVNfRFJBRlQQARIgChxBUFBMSUNBVElPTl9TVEFUVVNfU1VC'
    'TUlUVEVEEAISIgoeQVBQTElDQVRJT05fU1RBVFVTX0tZQ19QRU5ESU5HEAMSKAokQVBQTElDQV'
    'RJT05fU1RBVFVTX0RPQ1VNRU5UU19QRU5ESU5HEAQSIwofQVBQTElDQVRJT05fU1RBVFVTX1ZF'
    'UklGSUNBVElPThAFEiMKH0FQUExJQ0FUSU9OX1NUQVRVU19VTkRFUldSSVRJTkcQBhIfChtBUF'
    'BMSUNBVElPTl9TVEFUVVNfQVBQUk9WRUQQBxIfChtBUFBMSUNBVElPTl9TVEFUVVNfUkVKRUNU'
    'RUQQCBImCiJBUFBMSUNBVElPTl9TVEFUVVNfT0ZGRVJfR0VORVJBVEVEEAkSJQohQVBQTElDQV'
    'RJT05fU1RBVFVTX09GRkVSX0FDQ0VQVEVEEAoSJQohQVBQTElDQVRJT05fU1RBVFVTX09GRkVS'
    'X0RFQ0xJTkVEEAsSIwofQVBQTElDQVRJT05fU1RBVFVTX0xPQU5fQ1JFQVRFRBAMEiAKHEFQUE'
    'xJQ0FUSU9OX1NUQVRVU19DQU5DRUxMRUQQDRIeChpBUFBMSUNBVElPTl9TVEFUVVNfRVhQSVJF'
    'RBAO');

@$core.Deprecated('Use documentTypeDescriptor instead')
const DocumentType$json = {
  '1': 'DocumentType',
  '2': [
    {'1': 'DOCUMENT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'DOCUMENT_TYPE_NATIONAL_ID', '2': 1},
    {'1': 'DOCUMENT_TYPE_PASSPORT', '2': 2},
    {'1': 'DOCUMENT_TYPE_BUSINESS_REGISTRATION', '2': 3},
    {'1': 'DOCUMENT_TYPE_BANK_STATEMENT', '2': 4},
    {'1': 'DOCUMENT_TYPE_TAX_CERTIFICATE', '2': 5},
    {'1': 'DOCUMENT_TYPE_PROOF_OF_ADDRESS', '2': 6},
    {'1': 'DOCUMENT_TYPE_INCOME_PROOF', '2': 7},
    {'1': 'DOCUMENT_TYPE_COLLATERAL_PHOTO', '2': 8},
    {'1': 'DOCUMENT_TYPE_OTHER', '2': 99},
  ],
};

/// Descriptor for `DocumentType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List documentTypeDescriptor = $convert.base64Decode(
    'CgxEb2N1bWVudFR5cGUSHQoZRE9DVU1FTlRfVFlQRV9VTlNQRUNJRklFRBAAEh0KGURPQ1VNRU'
    '5UX1RZUEVfTkFUSU9OQUxfSUQQARIaChZET0NVTUVOVF9UWVBFX1BBU1NQT1JUEAISJwojRE9D'
    'VU1FTlRfVFlQRV9CVVNJTkVTU19SRUdJU1RSQVRJT04QAxIgChxET0NVTUVOVF9UWVBFX0JBTk'
    'tfU1RBVEVNRU5UEAQSIQodRE9DVU1FTlRfVFlQRV9UQVhfQ0VSVElGSUNBVEUQBRIiCh5ET0NV'
    'TUVOVF9UWVBFX1BST09GX09GX0FERFJFU1MQBhIeChpET0NVTUVOVF9UWVBFX0lOQ09NRV9QUk'
    '9PRhAHEiIKHkRPQ1VNRU5UX1RZUEVfQ09MTEFURVJBTF9QSE9UTxAIEhcKE0RPQ1VNRU5UX1RZ'
    'UEVfT1RIRVIQYw==');

@$core.Deprecated('Use verificationStatusDescriptor instead')
const VerificationStatus$json = {
  '1': 'VerificationStatus',
  '2': [
    {'1': 'VERIFICATION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'VERIFICATION_STATUS_PENDING', '2': 1},
    {'1': 'VERIFICATION_STATUS_IN_PROGRESS', '2': 2},
    {'1': 'VERIFICATION_STATUS_PASSED', '2': 3},
    {'1': 'VERIFICATION_STATUS_FAILED', '2': 4},
    {'1': 'VERIFICATION_STATUS_NEEDS_REVIEW', '2': 5},
  ],
};

/// Descriptor for `VerificationStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List verificationStatusDescriptor = $convert.base64Decode(
    'ChJWZXJpZmljYXRpb25TdGF0dXMSIwofVkVSSUZJQ0FUSU9OX1NUQVRVU19VTlNQRUNJRklFRB'
    'AAEh8KG1ZFUklGSUNBVElPTl9TVEFUVVNfUEVORElORxABEiMKH1ZFUklGSUNBVElPTl9TVEFU'
    'VVNfSU5fUFJPR1JFU1MQAhIeChpWRVJJRklDQVRJT05fU1RBVFVTX1BBU1NFRBADEh4KGlZFUk'
    'lGSUNBVElPTl9TVEFUVVNfRkFJTEVEEAQSJAogVkVSSUZJQ0FUSU9OX1NUQVRVU19ORUVEU19S'
    'RVZJRVcQBQ==');

@$core.Deprecated('Use underwritingOutcomeDescriptor instead')
const UnderwritingOutcome$json = {
  '1': 'UnderwritingOutcome',
  '2': [
    {'1': 'UNDERWRITING_OUTCOME_UNSPECIFIED', '2': 0},
    {'1': 'UNDERWRITING_OUTCOME_APPROVE', '2': 1},
    {'1': 'UNDERWRITING_OUTCOME_REJECT', '2': 2},
    {'1': 'UNDERWRITING_OUTCOME_REFER', '2': 3},
    {'1': 'UNDERWRITING_OUTCOME_COUNTER_OFFER', '2': 4},
  ],
};

/// Descriptor for `UnderwritingOutcome`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List underwritingOutcomeDescriptor = $convert.base64Decode(
    'ChNVbmRlcndyaXRpbmdPdXRjb21lEiQKIFVOREVSV1JJVElOR19PVVRDT01FX1VOU1BFQ0lGSU'
    'VEEAASIAocVU5ERVJXUklUSU5HX09VVENPTUVfQVBQUk9WRRABEh8KG1VOREVSV1JJVElOR19P'
    'VVRDT01FX1JFSkVDVBACEh4KGlVOREVSV1JJVElOR19PVVRDT01FX1JFRkVSEAMSJgoiVU5ERV'
    'JXUklUSU5HX09VVENPTUVfQ09VTlRFUl9PRkZFUhAE');

@$core.Deprecated('Use loanProductObjectDescriptor instead')
const LoanProductObject$json = {
  '1': 'LoanProductObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'bank_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'bankId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'code', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'code'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {'1': 'product_type', '3': 6, '4': 1, '5': 14, '6': '.origination.v1.LoanProductType', '10': 'productType'},
    {'1': 'currency_code', '3': 7, '4': 1, '5': 9, '8': {}, '10': 'currencyCode'},
    {'1': 'interest_method', '3': 8, '4': 1, '5': 14, '6': '.origination.v1.InterestMethod', '10': 'interestMethod'},
    {'1': 'repayment_frequency', '3': 9, '4': 1, '5': 14, '6': '.origination.v1.RepaymentFrequency', '10': 'repaymentFrequency'},
    {'1': 'min_amount', '3': 10, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'minAmount'},
    {'1': 'max_amount', '3': 11, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'maxAmount'},
    {'1': 'min_term_days', '3': 12, '4': 1, '5': 5, '10': 'minTermDays'},
    {'1': 'max_term_days', '3': 13, '4': 1, '5': 5, '10': 'maxTermDays'},
    {'1': 'annual_interest_rate', '3': 14, '4': 1, '5': 9, '10': 'annualInterestRate'},
    {'1': 'processing_fee_percent', '3': 15, '4': 1, '5': 9, '10': 'processingFeePercent'},
    {'1': 'insurance_fee_percent', '3': 16, '4': 1, '5': 9, '10': 'insuranceFeePercent'},
    {'1': 'late_penalty_rate', '3': 17, '4': 1, '5': 9, '10': 'latePenaltyRate'},
    {'1': 'grace_period_days', '3': 18, '4': 1, '5': 5, '10': 'gracePeriodDays'},
    {'1': 'kyc_schema', '3': 19, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'kycSchema'},
    {'1': 'fee_structure', '3': 20, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'feeStructure'},
    {'1': 'eligibility_criteria', '3': 21, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'eligibilityCriteria'},
    {'1': 'required_documents', '3': 22, '4': 3, '5': 9, '10': 'requiredDocuments'},
    {'1': 'state', '3': 23, '4': 1, '5': 14, '6': '.common.v1.STATE', '10': 'state'},
    {'1': 'properties', '3': 24, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `LoanProductObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanProductObjectDescriptor = $convert.base64Decode(
    'ChFMb2FuUHJvZHVjdE9iamVjdBIuCgJpZBgBIAEoCUIeukgb2AEBchYQAxgoMhBbMC05YS16Xy'
    '1dezMsNDB9UgJpZBIiCgdiYW5rX2lkGAIgASgJQgm6SAZyBBADGChSBmJhbmtJZBIbCgRuYW1l'
    'GAMgASgJQge6SARyAhABUgRuYW1lEhsKBGNvZGUYBCABKAlCB7pIBHICEAFSBGNvZGUSIAoLZG'
    'VzY3JpcHRpb24YBSABKAlSC2Rlc2NyaXB0aW9uEkIKDHByb2R1Y3RfdHlwZRgGIAEoDjIfLm9y'
    'aWdpbmF0aW9uLnYxLkxvYW5Qcm9kdWN0VHlwZVILcHJvZHVjdFR5cGUSLQoNY3VycmVuY3lfY2'
    '9kZRgHIAEoCUIIukgFcgOYAQNSDGN1cnJlbmN5Q29kZRJHCg9pbnRlcmVzdF9tZXRob2QYCCAB'
    'KA4yHi5vcmlnaW5hdGlvbi52MS5JbnRlcmVzdE1ldGhvZFIOaW50ZXJlc3RNZXRob2QSUwoTcm'
    'VwYXltZW50X2ZyZXF1ZW5jeRgJIAEoDjIiLm9yaWdpbmF0aW9uLnYxLlJlcGF5bWVudEZyZXF1'
    'ZW5jeVIScmVwYXltZW50RnJlcXVlbmN5EjEKCm1pbl9hbW91bnQYCiABKAsyEi5nb29nbGUudH'
    'lwZS5Nb25leVIJbWluQW1vdW50EjEKCm1heF9hbW91bnQYCyABKAsyEi5nb29nbGUudHlwZS5N'
    'b25leVIJbWF4QW1vdW50EiIKDW1pbl90ZXJtX2RheXMYDCABKAVSC21pblRlcm1EYXlzEiIKDW'
    '1heF90ZXJtX2RheXMYDSABKAVSC21heFRlcm1EYXlzEjAKFGFubnVhbF9pbnRlcmVzdF9yYXRl'
    'GA4gASgJUhJhbm51YWxJbnRlcmVzdFJhdGUSNAoWcHJvY2Vzc2luZ19mZWVfcGVyY2VudBgPIA'
    'EoCVIUcHJvY2Vzc2luZ0ZlZVBlcmNlbnQSMgoVaW5zdXJhbmNlX2ZlZV9wZXJjZW50GBAgASgJ'
    'UhNpbnN1cmFuY2VGZWVQZXJjZW50EioKEWxhdGVfcGVuYWx0eV9yYXRlGBEgASgJUg9sYXRlUG'
    'VuYWx0eVJhdGUSKgoRZ3JhY2VfcGVyaW9kX2RheXMYEiABKAVSD2dyYWNlUGVyaW9kRGF5cxI2'
    'CgpreWNfc2NoZW1hGBMgASgLMhcuZ29vZ2xlLnByb3RvYnVmLlN0cnVjdFIJa3ljU2NoZW1hEj'
    'wKDWZlZV9zdHJ1Y3R1cmUYFCABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0UgxmZWVTdHJ1'
    'Y3R1cmUSSgoUZWxpZ2liaWxpdHlfY3JpdGVyaWEYFSABKAsyFy5nb29nbGUucHJvdG9idWYuU3'
    'RydWN0UhNlbGlnaWJpbGl0eUNyaXRlcmlhEi0KEnJlcXVpcmVkX2RvY3VtZW50cxgWIAMoCVIR'
    'cmVxdWlyZWREb2N1bWVudHMSJgoFc3RhdGUYFyABKA4yEC5jb21tb24udjEuU1RBVEVSBXN0YX'
    'RlEjcKCnByb3BlcnRpZXMYGCABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0Ugpwcm9wZXJ0'
    'aWVz');

@$core.Deprecated('Use applicationObjectDescriptor instead')
const ApplicationObject$json = {
  '1': 'ApplicationObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'productId'},
    {'1': 'borrower_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'borrowerId'},
    {'1': 'agent_id', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'agentId'},
    {'1': 'branch_id', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'branchId'},
    {'1': 'bank_id', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'bankId'},
    {'1': 'status', '3': 7, '4': 1, '5': 14, '6': '.origination.v1.ApplicationStatus', '10': 'status'},
    {'1': 'requested_amount', '3': 8, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'requestedAmount'},
    {'1': 'approved_amount', '3': 9, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'approvedAmount'},
    {'1': 'requested_term_days', '3': 10, '4': 1, '5': 5, '10': 'requestedTermDays'},
    {'1': 'approved_term_days', '3': 11, '4': 1, '5': 5, '10': 'approvedTermDays'},
    {'1': 'interest_rate', '3': 12, '4': 1, '5': 9, '10': 'interestRate'},
    {'1': 'kyc_data', '3': 14, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'kycData'},
    {'1': 'purpose', '3': 15, '4': 1, '5': 9, '10': 'purpose'},
    {'1': 'rejection_reason', '3': 16, '4': 1, '5': 9, '10': 'rejectionReason'},
    {'1': 'workflow_instance_id', '3': 17, '4': 1, '5': 9, '10': 'workflowInstanceId'},
    {'1': 'offer_expires_at', '3': 18, '4': 1, '5': 9, '10': 'offerExpiresAt'},
    {'1': 'submitted_at', '3': 19, '4': 1, '5': 9, '10': 'submittedAt'},
    {'1': 'decided_at', '3': 20, '4': 1, '5': 9, '10': 'decidedAt'},
    {'1': 'loan_account_id', '3': 21, '4': 1, '5': 9, '10': 'loanAccountId'},
    {'1': 'properties', '3': 22, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `ApplicationObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationObjectDescriptor = $convert.base64Decode(
    'ChFBcHBsaWNhdGlvbk9iamVjdBIuCgJpZBgBIAEoCUIeukgb2AEBchYQAxgoMhBbMC05YS16Xy'
    '1dezMsNDB9UgJpZBIoCgpwcm9kdWN0X2lkGAIgASgJQgm6SAZyBBADGChSCXByb2R1Y3RJZBIq'
    'Cgtib3Jyb3dlcl9pZBgDIAEoCUIJukgGcgQQAxgoUgpib3Jyb3dlcklkEicKCGFnZW50X2lkGA'
    'QgASgJQgy6SAnYAQFyBBADGChSB2FnZW50SWQSKQoJYnJhbmNoX2lkGAUgASgJQgy6SAnYAQFy'
    'BBADGChSCGJyYW5jaElkEiIKB2JhbmtfaWQYBiABKAlCCbpIBnIEEAMYKFIGYmFua0lkEjkKBn'
    'N0YXR1cxgHIAEoDjIhLm9yaWdpbmF0aW9uLnYxLkFwcGxpY2F0aW9uU3RhdHVzUgZzdGF0dXMS'
    'PQoQcmVxdWVzdGVkX2Ftb3VudBgIIAEoCzISLmdvb2dsZS50eXBlLk1vbmV5Ug9yZXF1ZXN0ZW'
    'RBbW91bnQSOwoPYXBwcm92ZWRfYW1vdW50GAkgASgLMhIuZ29vZ2xlLnR5cGUuTW9uZXlSDmFw'
    'cHJvdmVkQW1vdW50Ei4KE3JlcXVlc3RlZF90ZXJtX2RheXMYCiABKAVSEXJlcXVlc3RlZFRlcm'
    '1EYXlzEiwKEmFwcHJvdmVkX3Rlcm1fZGF5cxgLIAEoBVIQYXBwcm92ZWRUZXJtRGF5cxIjCg1p'
    'bnRlcmVzdF9yYXRlGAwgASgJUgxpbnRlcmVzdFJhdGUSMgoIa3ljX2RhdGEYDiABKAsyFy5nb2'
    '9nbGUucHJvdG9idWYuU3RydWN0UgdreWNEYXRhEhgKB3B1cnBvc2UYDyABKAlSB3B1cnBvc2US'
    'KQoQcmVqZWN0aW9uX3JlYXNvbhgQIAEoCVIPcmVqZWN0aW9uUmVhc29uEjAKFHdvcmtmbG93X2'
    'luc3RhbmNlX2lkGBEgASgJUhJ3b3JrZmxvd0luc3RhbmNlSWQSKAoQb2ZmZXJfZXhwaXJlc19h'
    'dBgSIAEoCVIOb2ZmZXJFeHBpcmVzQXQSIQoMc3VibWl0dGVkX2F0GBMgASgJUgtzdWJtaXR0ZW'
    'RBdBIdCgpkZWNpZGVkX2F0GBQgASgJUglkZWNpZGVkQXQSJgoPbG9hbl9hY2NvdW50X2lkGBUg'
    'ASgJUg1sb2FuQWNjb3VudElkEjcKCnByb3BlcnRpZXMYFiABKAsyFy5nb29nbGUucHJvdG9idW'
    'YuU3RydWN0Ugpwcm9wZXJ0aWVz');

@$core.Deprecated('Use applicationDocumentObjectDescriptor instead')
const ApplicationDocumentObject$json = {
  '1': 'ApplicationDocumentObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'application_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'applicationId'},
    {'1': 'document_type', '3': 3, '4': 1, '5': 14, '6': '.origination.v1.DocumentType', '10': 'documentType'},
    {'1': 'file_id', '3': 4, '4': 1, '5': 9, '10': 'fileId'},
    {'1': 'file_name', '3': 5, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'mime_type', '3': 6, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'verification_status', '3': 7, '4': 1, '5': 14, '6': '.origination.v1.VerificationStatus', '10': 'verificationStatus'},
    {'1': 'verified_by', '3': 8, '4': 1, '5': 9, '10': 'verifiedBy'},
    {'1': 'verified_at', '3': 9, '4': 1, '5': 9, '10': 'verifiedAt'},
    {'1': 'rejection_reason', '3': 10, '4': 1, '5': 9, '10': 'rejectionReason'},
    {'1': 'properties', '3': 11, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `ApplicationDocumentObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationDocumentObjectDescriptor = $convert.base64Decode(
    'ChlBcHBsaWNhdGlvbkRvY3VtZW50T2JqZWN0Ei4KAmlkGAEgASgJQh66SBvYAQFyFhADGCgyEF'
    'swLTlhLXpfLV17Myw0MH1SAmlkEjAKDmFwcGxpY2F0aW9uX2lkGAIgASgJQgm6SAZyBBADGChS'
    'DWFwcGxpY2F0aW9uSWQSQQoNZG9jdW1lbnRfdHlwZRgDIAEoDjIcLm9yaWdpbmF0aW9uLnYxLk'
    'RvY3VtZW50VHlwZVIMZG9jdW1lbnRUeXBlEhcKB2ZpbGVfaWQYBCABKAlSBmZpbGVJZBIbCglm'
    'aWxlX25hbWUYBSABKAlSCGZpbGVOYW1lEhsKCW1pbWVfdHlwZRgGIAEoCVIIbWltZVR5cGUSUw'
    'oTdmVyaWZpY2F0aW9uX3N0YXR1cxgHIAEoDjIiLm9yaWdpbmF0aW9uLnYxLlZlcmlmaWNhdGlv'
    'blN0YXR1c1ISdmVyaWZpY2F0aW9uU3RhdHVzEh8KC3ZlcmlmaWVkX2J5GAggASgJUgp2ZXJpZm'
    'llZEJ5Eh8KC3ZlcmlmaWVkX2F0GAkgASgJUgp2ZXJpZmllZEF0EikKEHJlamVjdGlvbl9yZWFz'
    'b24YCiABKAlSD3JlamVjdGlvblJlYXNvbhI3Cgpwcm9wZXJ0aWVzGAsgASgLMhcuZ29vZ2xlLn'
    'Byb3RvYnVmLlN0cnVjdFIKcHJvcGVydGllcw==');

@$core.Deprecated('Use verificationTaskObjectDescriptor instead')
const VerificationTaskObject$json = {
  '1': 'VerificationTaskObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'application_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'applicationId'},
    {'1': 'assigned_to', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'assignedTo'},
    {'1': 'verification_type', '3': 4, '4': 1, '5': 9, '10': 'verificationType'},
    {'1': 'status', '3': 5, '4': 1, '5': 14, '6': '.origination.v1.VerificationStatus', '10': 'status'},
    {'1': 'notes', '3': 6, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'checklist', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'checklist'},
    {'1': 'results', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'results'},
    {'1': 'completed_at', '3': 9, '4': 1, '5': 9, '10': 'completedAt'},
    {'1': 'properties', '3': 10, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `VerificationTaskObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationTaskObjectDescriptor = $convert.base64Decode(
    'ChZWZXJpZmljYXRpb25UYXNrT2JqZWN0Ei4KAmlkGAEgASgJQh66SBvYAQFyFhADGCgyEFswLT'
    'lhLXpfLV17Myw0MH1SAmlkEjAKDmFwcGxpY2F0aW9uX2lkGAIgASgJQgm6SAZyBBADGChSDWFw'
    'cGxpY2F0aW9uSWQSKwoLYXNzaWduZWRfdG8YAyABKAlCCrpIB9gBAXICGChSCmFzc2lnbmVkVG'
    '8SKwoRdmVyaWZpY2F0aW9uX3R5cGUYBCABKAlSEHZlcmlmaWNhdGlvblR5cGUSOgoGc3RhdHVz'
    'GAUgASgOMiIub3JpZ2luYXRpb24udjEuVmVyaWZpY2F0aW9uU3RhdHVzUgZzdGF0dXMSFAoFbm'
    '90ZXMYBiABKAlSBW5vdGVzEjUKCWNoZWNrbGlzdBgHIAEoCzIXLmdvb2dsZS5wcm90b2J1Zi5T'
    'dHJ1Y3RSCWNoZWNrbGlzdBIxCgdyZXN1bHRzGAggASgLMhcuZ29vZ2xlLnByb3RvYnVmLlN0cn'
    'VjdFIHcmVzdWx0cxIhCgxjb21wbGV0ZWRfYXQYCSABKAlSC2NvbXBsZXRlZEF0EjcKCnByb3Bl'
    'cnRpZXMYCiABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0Ugpwcm9wZXJ0aWVz');

@$core.Deprecated('Use underwritingDecisionObjectDescriptor instead')
const UnderwritingDecisionObject$json = {
  '1': 'UnderwritingDecisionObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'application_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'applicationId'},
    {'1': 'decided_by', '3': 3, '4': 1, '5': 9, '10': 'decidedBy'},
    {'1': 'outcome', '3': 4, '4': 1, '5': 14, '6': '.origination.v1.UnderwritingOutcome', '10': 'outcome'},
    {'1': 'credit_score', '3': 5, '4': 1, '5': 5, '10': 'creditScore'},
    {'1': 'risk_grade', '3': 6, '4': 1, '5': 9, '10': 'riskGrade'},
    {'1': 'approved_amount', '3': 7, '4': 1, '5': 11, '6': '.google.type.Money', '10': 'approvedAmount'},
    {'1': 'approved_term_days', '3': 8, '4': 1, '5': 5, '10': 'approvedTermDays'},
    {'1': 'approved_rate', '3': 9, '4': 1, '5': 9, '10': 'approvedRate'},
    {'1': 'reason', '3': 10, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'scoring_details', '3': 11, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'scoringDetails'},
    {'1': 'conditions', '3': 12, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'conditions'},
    {'1': 'properties', '3': 13, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'properties'},
  ],
};

/// Descriptor for `UnderwritingDecisionObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List underwritingDecisionObjectDescriptor = $convert.base64Decode(
    'ChpVbmRlcndyaXRpbmdEZWNpc2lvbk9iamVjdBIuCgJpZBgBIAEoCUIeukgb2AEBchYQAxgoMh'
    'BbMC05YS16Xy1dezMsNDB9UgJpZBIwCg5hcHBsaWNhdGlvbl9pZBgCIAEoCUIJukgGcgQQAxgo'
    'Ug1hcHBsaWNhdGlvbklkEh0KCmRlY2lkZWRfYnkYAyABKAlSCWRlY2lkZWRCeRI9CgdvdXRjb2'
    '1lGAQgASgOMiMub3JpZ2luYXRpb24udjEuVW5kZXJ3cml0aW5nT3V0Y29tZVIHb3V0Y29tZRIh'
    'CgxjcmVkaXRfc2NvcmUYBSABKAVSC2NyZWRpdFNjb3JlEh0KCnJpc2tfZ3JhZGUYBiABKAlSCX'
    'Jpc2tHcmFkZRI7Cg9hcHByb3ZlZF9hbW91bnQYByABKAsyEi5nb29nbGUudHlwZS5Nb25leVIO'
    'YXBwcm92ZWRBbW91bnQSLAoSYXBwcm92ZWRfdGVybV9kYXlzGAggASgFUhBhcHByb3ZlZFRlcm'
    '1EYXlzEiMKDWFwcHJvdmVkX3JhdGUYCSABKAlSDGFwcHJvdmVkUmF0ZRIWCgZyZWFzb24YCiAB'
    'KAlSBnJlYXNvbhJACg9zY29yaW5nX2RldGFpbHMYCyABKAsyFy5nb29nbGUucHJvdG9idWYuU3'
    'RydWN0Ug5zY29yaW5nRGV0YWlscxI3Cgpjb25kaXRpb25zGAwgASgLMhcuZ29vZ2xlLnByb3Rv'
    'YnVmLlN0cnVjdFIKY29uZGl0aW9ucxI3Cgpwcm9wZXJ0aWVzGA0gASgLMhcuZ29vZ2xlLnByb3'
    'RvYnVmLlN0cnVjdFIKcHJvcGVydGllcw==');

@$core.Deprecated('Use loanProductSaveRequestDescriptor instead')
const LoanProductSaveRequest$json = {
  '1': 'LoanProductSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.LoanProductObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `LoanProductSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanProductSaveRequestDescriptor = $convert.base64Decode(
    'ChZMb2FuUHJvZHVjdFNhdmVSZXF1ZXN0Ej0KBGRhdGEYASABKAsyIS5vcmlnaW5hdGlvbi52MS'
    '5Mb2FuUHJvZHVjdE9iamVjdEIGukgDyAEBUgRkYXRh');

@$core.Deprecated('Use loanProductSaveResponseDescriptor instead')
const LoanProductSaveResponse$json = {
  '1': 'LoanProductSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.LoanProductObject', '10': 'data'},
  ],
};

/// Descriptor for `LoanProductSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanProductSaveResponseDescriptor = $convert.base64Decode(
    'ChdMb2FuUHJvZHVjdFNhdmVSZXNwb25zZRI1CgRkYXRhGAEgASgLMiEub3JpZ2luYXRpb24udj'
    'EuTG9hblByb2R1Y3RPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use loanProductGetRequestDescriptor instead')
const LoanProductGetRequest$json = {
  '1': 'LoanProductGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `LoanProductGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanProductGetRequestDescriptor = $convert.base64Decode(
    'ChVMb2FuUHJvZHVjdEdldFJlcXVlc3QSKwoCaWQYASABKAlCG7pIGHIWEAMYKDIQWzAtOWEtel'
    '8tXXszLDQwfVICaWQ=');

@$core.Deprecated('Use loanProductGetResponseDescriptor instead')
const LoanProductGetResponse$json = {
  '1': 'LoanProductGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.LoanProductObject', '10': 'data'},
  ],
};

/// Descriptor for `LoanProductGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanProductGetResponseDescriptor = $convert.base64Decode(
    'ChZMb2FuUHJvZHVjdEdldFJlc3BvbnNlEjUKBGRhdGEYASABKAsyIS5vcmlnaW5hdGlvbi52MS'
    '5Mb2FuUHJvZHVjdE9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use loanProductSearchRequestDescriptor instead')
const LoanProductSearchRequest$json = {
  '1': 'LoanProductSearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'bank_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'bankId'},
    {'1': 'product_type', '3': 3, '4': 1, '5': 14, '6': '.origination.v1.LoanProductType', '10': 'productType'},
    {'1': 'cursor', '3': 4, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `LoanProductSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanProductSearchRequestDescriptor = $convert.base64Decode(
    'ChhMb2FuUHJvZHVjdFNlYXJjaFJlcXVlc3QSFAoFcXVlcnkYASABKAlSBXF1ZXJ5EiUKB2Jhbm'
    'tfaWQYAiABKAlCDLpICdgBAXIEEAMYKFIGYmFua0lkEkIKDHByb2R1Y3RfdHlwZRgDIAEoDjIf'
    'Lm9yaWdpbmF0aW9uLnYxLkxvYW5Qcm9kdWN0VHlwZVILcHJvZHVjdFR5cGUSLQoGY3Vyc29yGA'
    'QgASgLMhUuY29tbW9uLnYxLlBhZ2VDdXJzb3JSBmN1cnNvcg==');

@$core.Deprecated('Use loanProductSearchResponseDescriptor instead')
const LoanProductSearchResponse$json = {
  '1': 'LoanProductSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.origination.v1.LoanProductObject', '10': 'data'},
  ],
};

/// Descriptor for `LoanProductSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loanProductSearchResponseDescriptor = $convert.base64Decode(
    'ChlMb2FuUHJvZHVjdFNlYXJjaFJlc3BvbnNlEjUKBGRhdGEYASADKAsyIS5vcmlnaW5hdGlvbi'
    '52MS5Mb2FuUHJvZHVjdE9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use applicationSaveRequestDescriptor instead')
const ApplicationSaveRequest$json = {
  '1': 'ApplicationSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.ApplicationObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `ApplicationSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationSaveRequestDescriptor = $convert.base64Decode(
    'ChZBcHBsaWNhdGlvblNhdmVSZXF1ZXN0Ej0KBGRhdGEYASABKAsyIS5vcmlnaW5hdGlvbi52MS'
    '5BcHBsaWNhdGlvbk9iamVjdEIGukgDyAEBUgRkYXRh');

@$core.Deprecated('Use applicationSaveResponseDescriptor instead')
const ApplicationSaveResponse$json = {
  '1': 'ApplicationSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.ApplicationObject', '10': 'data'},
  ],
};

/// Descriptor for `ApplicationSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationSaveResponseDescriptor = $convert.base64Decode(
    'ChdBcHBsaWNhdGlvblNhdmVSZXNwb25zZRI1CgRkYXRhGAEgASgLMiEub3JpZ2luYXRpb24udj'
    'EuQXBwbGljYXRpb25PYmplY3RSBGRhdGE=');

@$core.Deprecated('Use applicationGetRequestDescriptor instead')
const ApplicationGetRequest$json = {
  '1': 'ApplicationGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `ApplicationGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationGetRequestDescriptor = $convert.base64Decode(
    'ChVBcHBsaWNhdGlvbkdldFJlcXVlc3QSKwoCaWQYASABKAlCG7pIGHIWEAMYKDIQWzAtOWEtel'
    '8tXXszLDQwfVICaWQ=');

@$core.Deprecated('Use applicationGetResponseDescriptor instead')
const ApplicationGetResponse$json = {
  '1': 'ApplicationGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.ApplicationObject', '10': 'data'},
  ],
};

/// Descriptor for `ApplicationGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationGetResponseDescriptor = $convert.base64Decode(
    'ChZBcHBsaWNhdGlvbkdldFJlc3BvbnNlEjUKBGRhdGEYASABKAsyIS5vcmlnaW5hdGlvbi52MS'
    '5BcHBsaWNhdGlvbk9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use applicationSearchRequestDescriptor instead')
const ApplicationSearchRequest$json = {
  '1': 'ApplicationSearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'borrower_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'borrowerId'},
    {'1': 'agent_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'agentId'},
    {'1': 'branch_id', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'branchId'},
    {'1': 'bank_id', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'bankId'},
    {'1': 'status', '3': 6, '4': 1, '5': 14, '6': '.origination.v1.ApplicationStatus', '10': 'status'},
    {'1': 'cursor', '3': 7, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `ApplicationSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationSearchRequestDescriptor = $convert.base64Decode(
    'ChhBcHBsaWNhdGlvblNlYXJjaFJlcXVlc3QSFAoFcXVlcnkYASABKAlSBXF1ZXJ5Ei0KC2Jvcn'
    'Jvd2VyX2lkGAIgASgJQgy6SAnYAQFyBBADGChSCmJvcnJvd2VySWQSJwoIYWdlbnRfaWQYAyAB'
    'KAlCDLpICdgBAXIEEAMYKFIHYWdlbnRJZBIpCglicmFuY2hfaWQYBCABKAlCDLpICdgBAXIEEA'
    'MYKFIIYnJhbmNoSWQSJQoHYmFua19pZBgFIAEoCUIMukgJ2AEBcgQQAxgoUgZiYW5rSWQSOQoG'
    'c3RhdHVzGAYgASgOMiEub3JpZ2luYXRpb24udjEuQXBwbGljYXRpb25TdGF0dXNSBnN0YXR1cx'
    'ItCgZjdXJzb3IYByABKAsyFS5jb21tb24udjEuUGFnZUN1cnNvclIGY3Vyc29y');

@$core.Deprecated('Use applicationSearchResponseDescriptor instead')
const ApplicationSearchResponse$json = {
  '1': 'ApplicationSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.origination.v1.ApplicationObject', '10': 'data'},
  ],
};

/// Descriptor for `ApplicationSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationSearchResponseDescriptor = $convert.base64Decode(
    'ChlBcHBsaWNhdGlvblNlYXJjaFJlc3BvbnNlEjUKBGRhdGEYASADKAsyIS5vcmlnaW5hdGlvbi'
    '52MS5BcHBsaWNhdGlvbk9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use applicationSubmitRequestDescriptor instead')
const ApplicationSubmitRequest$json = {
  '1': 'ApplicationSubmitRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `ApplicationSubmitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationSubmitRequestDescriptor = $convert.base64Decode(
    'ChhBcHBsaWNhdGlvblN1Ym1pdFJlcXVlc3QSKwoCaWQYASABKAlCG7pIGHIWEAMYKDIQWzAtOW'
    'Etel8tXXszLDQwfVICaWQ=');

@$core.Deprecated('Use applicationSubmitResponseDescriptor instead')
const ApplicationSubmitResponse$json = {
  '1': 'ApplicationSubmitResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.ApplicationObject', '10': 'data'},
  ],
};

/// Descriptor for `ApplicationSubmitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationSubmitResponseDescriptor = $convert.base64Decode(
    'ChlBcHBsaWNhdGlvblN1Ym1pdFJlc3BvbnNlEjUKBGRhdGEYASABKAsyIS5vcmlnaW5hdGlvbi'
    '52MS5BcHBsaWNhdGlvbk9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use applicationCancelRequestDescriptor instead')
const ApplicationCancelRequest$json = {
  '1': 'ApplicationCancelRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ApplicationCancelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationCancelRequestDescriptor = $convert.base64Decode(
    'ChhBcHBsaWNhdGlvbkNhbmNlbFJlcXVlc3QSKwoCaWQYASABKAlCG7pIGHIWEAMYKDIQWzAtOW'
    'Etel8tXXszLDQwfVICaWQSFgoGcmVhc29uGAIgASgJUgZyZWFzb24=');

@$core.Deprecated('Use applicationCancelResponseDescriptor instead')
const ApplicationCancelResponse$json = {
  '1': 'ApplicationCancelResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.ApplicationObject', '10': 'data'},
  ],
};

/// Descriptor for `ApplicationCancelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationCancelResponseDescriptor = $convert.base64Decode(
    'ChlBcHBsaWNhdGlvbkNhbmNlbFJlc3BvbnNlEjUKBGRhdGEYASABKAsyIS5vcmlnaW5hdGlvbi'
    '52MS5BcHBsaWNhdGlvbk9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use applicationAcceptOfferRequestDescriptor instead')
const ApplicationAcceptOfferRequest$json = {
  '1': 'ApplicationAcceptOfferRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `ApplicationAcceptOfferRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationAcceptOfferRequestDescriptor = $convert.base64Decode(
    'Ch1BcHBsaWNhdGlvbkFjY2VwdE9mZmVyUmVxdWVzdBIrCgJpZBgBIAEoCUIbukgYchYQAxgoMh'
    'BbMC05YS16Xy1dezMsNDB9UgJpZA==');

@$core.Deprecated('Use applicationAcceptOfferResponseDescriptor instead')
const ApplicationAcceptOfferResponse$json = {
  '1': 'ApplicationAcceptOfferResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.ApplicationObject', '10': 'data'},
  ],
};

/// Descriptor for `ApplicationAcceptOfferResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationAcceptOfferResponseDescriptor = $convert.base64Decode(
    'Ch5BcHBsaWNhdGlvbkFjY2VwdE9mZmVyUmVzcG9uc2USNQoEZGF0YRgBIAEoCzIhLm9yaWdpbm'
    'F0aW9uLnYxLkFwcGxpY2F0aW9uT2JqZWN0UgRkYXRh');

@$core.Deprecated('Use applicationDeclineOfferRequestDescriptor instead')
const ApplicationDeclineOfferRequest$json = {
  '1': 'ApplicationDeclineOfferRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ApplicationDeclineOfferRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationDeclineOfferRequestDescriptor = $convert.base64Decode(
    'Ch5BcHBsaWNhdGlvbkRlY2xpbmVPZmZlclJlcXVlc3QSKwoCaWQYASABKAlCG7pIGHIWEAMYKD'
    'IQWzAtOWEtel8tXXszLDQwfVICaWQSFgoGcmVhc29uGAIgASgJUgZyZWFzb24=');

@$core.Deprecated('Use applicationDeclineOfferResponseDescriptor instead')
const ApplicationDeclineOfferResponse$json = {
  '1': 'ApplicationDeclineOfferResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.ApplicationObject', '10': 'data'},
  ],
};

/// Descriptor for `ApplicationDeclineOfferResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationDeclineOfferResponseDescriptor = $convert.base64Decode(
    'Ch9BcHBsaWNhdGlvbkRlY2xpbmVPZmZlclJlc3BvbnNlEjUKBGRhdGEYASABKAsyIS5vcmlnaW'
    '5hdGlvbi52MS5BcHBsaWNhdGlvbk9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use applicationDocumentSaveRequestDescriptor instead')
const ApplicationDocumentSaveRequest$json = {
  '1': 'ApplicationDocumentSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.ApplicationDocumentObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `ApplicationDocumentSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationDocumentSaveRequestDescriptor = $convert.base64Decode(
    'Ch5BcHBsaWNhdGlvbkRvY3VtZW50U2F2ZVJlcXVlc3QSRQoEZGF0YRgBIAEoCzIpLm9yaWdpbm'
    'F0aW9uLnYxLkFwcGxpY2F0aW9uRG9jdW1lbnRPYmplY3RCBrpIA8gBAVIEZGF0YQ==');

@$core.Deprecated('Use applicationDocumentSaveResponseDescriptor instead')
const ApplicationDocumentSaveResponse$json = {
  '1': 'ApplicationDocumentSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.ApplicationDocumentObject', '10': 'data'},
  ],
};

/// Descriptor for `ApplicationDocumentSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationDocumentSaveResponseDescriptor = $convert.base64Decode(
    'Ch9BcHBsaWNhdGlvbkRvY3VtZW50U2F2ZVJlc3BvbnNlEj0KBGRhdGEYASABKAsyKS5vcmlnaW'
    '5hdGlvbi52MS5BcHBsaWNhdGlvbkRvY3VtZW50T2JqZWN0UgRkYXRh');

@$core.Deprecated('Use applicationDocumentGetRequestDescriptor instead')
const ApplicationDocumentGetRequest$json = {
  '1': 'ApplicationDocumentGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `ApplicationDocumentGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationDocumentGetRequestDescriptor = $convert.base64Decode(
    'Ch1BcHBsaWNhdGlvbkRvY3VtZW50R2V0UmVxdWVzdBIrCgJpZBgBIAEoCUIbukgYchYQAxgoMh'
    'BbMC05YS16Xy1dezMsNDB9UgJpZA==');

@$core.Deprecated('Use applicationDocumentGetResponseDescriptor instead')
const ApplicationDocumentGetResponse$json = {
  '1': 'ApplicationDocumentGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.ApplicationDocumentObject', '10': 'data'},
  ],
};

/// Descriptor for `ApplicationDocumentGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationDocumentGetResponseDescriptor = $convert.base64Decode(
    'Ch5BcHBsaWNhdGlvbkRvY3VtZW50R2V0UmVzcG9uc2USPQoEZGF0YRgBIAEoCzIpLm9yaWdpbm'
    'F0aW9uLnYxLkFwcGxpY2F0aW9uRG9jdW1lbnRPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use applicationDocumentSearchRequestDescriptor instead')
const ApplicationDocumentSearchRequest$json = {
  '1': 'ApplicationDocumentSearchRequest',
  '2': [
    {'1': 'application_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'applicationId'},
    {'1': 'document_type', '3': 2, '4': 1, '5': 14, '6': '.origination.v1.DocumentType', '10': 'documentType'},
    {'1': 'cursor', '3': 3, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `ApplicationDocumentSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationDocumentSearchRequestDescriptor = $convert.base64Decode(
    'CiBBcHBsaWNhdGlvbkRvY3VtZW50U2VhcmNoUmVxdWVzdBIwCg5hcHBsaWNhdGlvbl9pZBgBIA'
    'EoCUIJukgGcgQQAxgoUg1hcHBsaWNhdGlvbklkEkEKDWRvY3VtZW50X3R5cGUYAiABKA4yHC5v'
    'cmlnaW5hdGlvbi52MS5Eb2N1bWVudFR5cGVSDGRvY3VtZW50VHlwZRItCgZjdXJzb3IYAyABKA'
    'syFS5jb21tb24udjEuUGFnZUN1cnNvclIGY3Vyc29y');

@$core.Deprecated('Use applicationDocumentSearchResponseDescriptor instead')
const ApplicationDocumentSearchResponse$json = {
  '1': 'ApplicationDocumentSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.origination.v1.ApplicationDocumentObject', '10': 'data'},
  ],
};

/// Descriptor for `ApplicationDocumentSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationDocumentSearchResponseDescriptor = $convert.base64Decode(
    'CiFBcHBsaWNhdGlvbkRvY3VtZW50U2VhcmNoUmVzcG9uc2USPQoEZGF0YRgBIAMoCzIpLm9yaW'
    'dpbmF0aW9uLnYxLkFwcGxpY2F0aW9uRG9jdW1lbnRPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use verificationTaskSaveRequestDescriptor instead')
const VerificationTaskSaveRequest$json = {
  '1': 'VerificationTaskSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.VerificationTaskObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `VerificationTaskSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationTaskSaveRequestDescriptor = $convert.base64Decode(
    'ChtWZXJpZmljYXRpb25UYXNrU2F2ZVJlcXVlc3QSQgoEZGF0YRgBIAEoCzImLm9yaWdpbmF0aW'
    '9uLnYxLlZlcmlmaWNhdGlvblRhc2tPYmplY3RCBrpIA8gBAVIEZGF0YQ==');

@$core.Deprecated('Use verificationTaskSaveResponseDescriptor instead')
const VerificationTaskSaveResponse$json = {
  '1': 'VerificationTaskSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.VerificationTaskObject', '10': 'data'},
  ],
};

/// Descriptor for `VerificationTaskSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationTaskSaveResponseDescriptor = $convert.base64Decode(
    'ChxWZXJpZmljYXRpb25UYXNrU2F2ZVJlc3BvbnNlEjoKBGRhdGEYASABKAsyJi5vcmlnaW5hdG'
    'lvbi52MS5WZXJpZmljYXRpb25UYXNrT2JqZWN0UgRkYXRh');

@$core.Deprecated('Use verificationTaskGetRequestDescriptor instead')
const VerificationTaskGetRequest$json = {
  '1': 'VerificationTaskGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `VerificationTaskGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationTaskGetRequestDescriptor = $convert.base64Decode(
    'ChpWZXJpZmljYXRpb25UYXNrR2V0UmVxdWVzdBIrCgJpZBgBIAEoCUIbukgYchYQAxgoMhBbMC'
    '05YS16Xy1dezMsNDB9UgJpZA==');

@$core.Deprecated('Use verificationTaskGetResponseDescriptor instead')
const VerificationTaskGetResponse$json = {
  '1': 'VerificationTaskGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.VerificationTaskObject', '10': 'data'},
  ],
};

/// Descriptor for `VerificationTaskGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationTaskGetResponseDescriptor = $convert.base64Decode(
    'ChtWZXJpZmljYXRpb25UYXNrR2V0UmVzcG9uc2USOgoEZGF0YRgBIAEoCzImLm9yaWdpbmF0aW'
    '9uLnYxLlZlcmlmaWNhdGlvblRhc2tPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use verificationTaskSearchRequestDescriptor instead')
const VerificationTaskSearchRequest$json = {
  '1': 'VerificationTaskSearchRequest',
  '2': [
    {'1': 'application_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'applicationId'},
    {'1': 'assigned_to', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'assignedTo'},
    {'1': 'status', '3': 3, '4': 1, '5': 14, '6': '.origination.v1.VerificationStatus', '10': 'status'},
    {'1': 'cursor', '3': 4, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `VerificationTaskSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationTaskSearchRequestDescriptor = $convert.base64Decode(
    'Ch1WZXJpZmljYXRpb25UYXNrU2VhcmNoUmVxdWVzdBIzCg5hcHBsaWNhdGlvbl9pZBgBIAEoCU'
    'IMukgJ2AEBcgQQAxgoUg1hcHBsaWNhdGlvbklkEisKC2Fzc2lnbmVkX3RvGAIgASgJQgq6SAfY'
    'AQFyAhgoUgphc3NpZ25lZFRvEjoKBnN0YXR1cxgDIAEoDjIiLm9yaWdpbmF0aW9uLnYxLlZlcm'
    'lmaWNhdGlvblN0YXR1c1IGc3RhdHVzEi0KBmN1cnNvchgEIAEoCzIVLmNvbW1vbi52MS5QYWdl'
    'Q3Vyc29yUgZjdXJzb3I=');

@$core.Deprecated('Use verificationTaskSearchResponseDescriptor instead')
const VerificationTaskSearchResponse$json = {
  '1': 'VerificationTaskSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.origination.v1.VerificationTaskObject', '10': 'data'},
  ],
};

/// Descriptor for `VerificationTaskSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationTaskSearchResponseDescriptor = $convert.base64Decode(
    'Ch5WZXJpZmljYXRpb25UYXNrU2VhcmNoUmVzcG9uc2USOgoEZGF0YRgBIAMoCzImLm9yaWdpbm'
    'F0aW9uLnYxLlZlcmlmaWNhdGlvblRhc2tPYmplY3RSBGRhdGE=');

@$core.Deprecated('Use verificationTaskCompleteRequestDescriptor instead')
const VerificationTaskCompleteRequest$json = {
  '1': 'VerificationTaskCompleteRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'status', '3': 2, '4': 1, '5': 14, '6': '.origination.v1.VerificationStatus', '10': 'status'},
    {'1': 'notes', '3': 3, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'results', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'results'},
  ],
};

/// Descriptor for `VerificationTaskCompleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationTaskCompleteRequestDescriptor = $convert.base64Decode(
    'Ch9WZXJpZmljYXRpb25UYXNrQ29tcGxldGVSZXF1ZXN0EisKAmlkGAEgASgJQhu6SBhyFhADGC'
    'gyEFswLTlhLXpfLV17Myw0MH1SAmlkEjoKBnN0YXR1cxgCIAEoDjIiLm9yaWdpbmF0aW9uLnYx'
    'LlZlcmlmaWNhdGlvblN0YXR1c1IGc3RhdHVzEhQKBW5vdGVzGAMgASgJUgVub3RlcxIxCgdyZX'
    'N1bHRzGAQgASgLMhcuZ29vZ2xlLnByb3RvYnVmLlN0cnVjdFIHcmVzdWx0cw==');

@$core.Deprecated('Use verificationTaskCompleteResponseDescriptor instead')
const VerificationTaskCompleteResponse$json = {
  '1': 'VerificationTaskCompleteResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.VerificationTaskObject', '10': 'data'},
  ],
};

/// Descriptor for `VerificationTaskCompleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationTaskCompleteResponseDescriptor = $convert.base64Decode(
    'CiBWZXJpZmljYXRpb25UYXNrQ29tcGxldGVSZXNwb25zZRI6CgRkYXRhGAEgASgLMiYub3JpZ2'
    'luYXRpb24udjEuVmVyaWZpY2F0aW9uVGFza09iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use underwritingDecisionSaveRequestDescriptor instead')
const UnderwritingDecisionSaveRequest$json = {
  '1': 'UnderwritingDecisionSaveRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.UnderwritingDecisionObject', '8': {}, '10': 'data'},
  ],
};

/// Descriptor for `UnderwritingDecisionSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List underwritingDecisionSaveRequestDescriptor = $convert.base64Decode(
    'Ch9VbmRlcndyaXRpbmdEZWNpc2lvblNhdmVSZXF1ZXN0EkYKBGRhdGEYASABKAsyKi5vcmlnaW'
    '5hdGlvbi52MS5VbmRlcndyaXRpbmdEZWNpc2lvbk9iamVjdEIGukgDyAEBUgRkYXRh');

@$core.Deprecated('Use underwritingDecisionSaveResponseDescriptor instead')
const UnderwritingDecisionSaveResponse$json = {
  '1': 'UnderwritingDecisionSaveResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.UnderwritingDecisionObject', '10': 'data'},
  ],
};

/// Descriptor for `UnderwritingDecisionSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List underwritingDecisionSaveResponseDescriptor = $convert.base64Decode(
    'CiBVbmRlcndyaXRpbmdEZWNpc2lvblNhdmVSZXNwb25zZRI+CgRkYXRhGAEgASgLMioub3JpZ2'
    'luYXRpb24udjEuVW5kZXJ3cml0aW5nRGVjaXNpb25PYmplY3RSBGRhdGE=');

@$core.Deprecated('Use underwritingDecisionGetRequestDescriptor instead')
const UnderwritingDecisionGetRequest$json = {
  '1': 'UnderwritingDecisionGetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `UnderwritingDecisionGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List underwritingDecisionGetRequestDescriptor = $convert.base64Decode(
    'Ch5VbmRlcndyaXRpbmdEZWNpc2lvbkdldFJlcXVlc3QSKwoCaWQYASABKAlCG7pIGHIWEAMYKD'
    'IQWzAtOWEtel8tXXszLDQwfVICaWQ=');

@$core.Deprecated('Use underwritingDecisionGetResponseDescriptor instead')
const UnderwritingDecisionGetResponse$json = {
  '1': 'UnderwritingDecisionGetResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.origination.v1.UnderwritingDecisionObject', '10': 'data'},
  ],
};

/// Descriptor for `UnderwritingDecisionGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List underwritingDecisionGetResponseDescriptor = $convert.base64Decode(
    'Ch9VbmRlcndyaXRpbmdEZWNpc2lvbkdldFJlc3BvbnNlEj4KBGRhdGEYASABKAsyKi5vcmlnaW'
    '5hdGlvbi52MS5VbmRlcndyaXRpbmdEZWNpc2lvbk9iamVjdFIEZGF0YQ==');

@$core.Deprecated('Use underwritingDecisionSearchRequestDescriptor instead')
const UnderwritingDecisionSearchRequest$json = {
  '1': 'UnderwritingDecisionSearchRequest',
  '2': [
    {'1': 'application_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'applicationId'},
    {'1': 'cursor', '3': 2, '4': 1, '5': 11, '6': '.common.v1.PageCursor', '10': 'cursor'},
  ],
};

/// Descriptor for `UnderwritingDecisionSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List underwritingDecisionSearchRequestDescriptor = $convert.base64Decode(
    'CiFVbmRlcndyaXRpbmdEZWNpc2lvblNlYXJjaFJlcXVlc3QSMAoOYXBwbGljYXRpb25faWQYAS'
    'ABKAlCCbpIBnIEEAMYKFINYXBwbGljYXRpb25JZBItCgZjdXJzb3IYAiABKAsyFS5jb21tb24u'
    'djEuUGFnZUN1cnNvclIGY3Vyc29y');

@$core.Deprecated('Use underwritingDecisionSearchResponseDescriptor instead')
const UnderwritingDecisionSearchResponse$json = {
  '1': 'UnderwritingDecisionSearchResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.origination.v1.UnderwritingDecisionObject', '10': 'data'},
  ],
};

/// Descriptor for `UnderwritingDecisionSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List underwritingDecisionSearchResponseDescriptor = $convert.base64Decode(
    'CiJVbmRlcndyaXRpbmdEZWNpc2lvblNlYXJjaFJlc3BvbnNlEj4KBGRhdGEYASADKAsyKi5vcm'
    'lnaW5hdGlvbi52MS5VbmRlcndyaXRpbmdEZWNpc2lvbk9iamVjdFIEZGF0YQ==');

const $core.Map<$core.String, $core.dynamic> OriginationServiceBase$json = {
  '1': 'OriginationService',
  '2': [
    {'1': 'LoanProductSave', '2': '.origination.v1.LoanProductSaveRequest', '3': '.origination.v1.LoanProductSaveResponse', '4': {}},
    {
      '1': 'LoanProductGet',
      '2': '.origination.v1.LoanProductGetRequest',
      '3': '.origination.v1.LoanProductGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'LoanProductSearch',
      '2': '.origination.v1.LoanProductSearchRequest',
      '3': '.origination.v1.LoanProductSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'ApplicationSave', '2': '.origination.v1.ApplicationSaveRequest', '3': '.origination.v1.ApplicationSaveResponse', '4': {}},
    {
      '1': 'ApplicationGet',
      '2': '.origination.v1.ApplicationGetRequest',
      '3': '.origination.v1.ApplicationGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'ApplicationSearch',
      '2': '.origination.v1.ApplicationSearchRequest',
      '3': '.origination.v1.ApplicationSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'ApplicationSubmit', '2': '.origination.v1.ApplicationSubmitRequest', '3': '.origination.v1.ApplicationSubmitResponse', '4': {}},
    {'1': 'ApplicationCancel', '2': '.origination.v1.ApplicationCancelRequest', '3': '.origination.v1.ApplicationCancelResponse', '4': {}},
    {'1': 'ApplicationAcceptOffer', '2': '.origination.v1.ApplicationAcceptOfferRequest', '3': '.origination.v1.ApplicationAcceptOfferResponse', '4': {}},
    {'1': 'ApplicationDeclineOffer', '2': '.origination.v1.ApplicationDeclineOfferRequest', '3': '.origination.v1.ApplicationDeclineOfferResponse', '4': {}},
    {'1': 'ApplicationDocumentSave', '2': '.origination.v1.ApplicationDocumentSaveRequest', '3': '.origination.v1.ApplicationDocumentSaveResponse', '4': {}},
    {
      '1': 'ApplicationDocumentGet',
      '2': '.origination.v1.ApplicationDocumentGetRequest',
      '3': '.origination.v1.ApplicationDocumentGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'ApplicationDocumentSearch',
      '2': '.origination.v1.ApplicationDocumentSearchRequest',
      '3': '.origination.v1.ApplicationDocumentSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'VerificationTaskSave', '2': '.origination.v1.VerificationTaskSaveRequest', '3': '.origination.v1.VerificationTaskSaveResponse', '4': {}},
    {
      '1': 'VerificationTaskGet',
      '2': '.origination.v1.VerificationTaskGetRequest',
      '3': '.origination.v1.VerificationTaskGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'VerificationTaskSearch',
      '2': '.origination.v1.VerificationTaskSearchRequest',
      '3': '.origination.v1.VerificationTaskSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
    {'1': 'VerificationTaskComplete', '2': '.origination.v1.VerificationTaskCompleteRequest', '3': '.origination.v1.VerificationTaskCompleteResponse', '4': {}},
    {'1': 'UnderwritingDecisionSave', '2': '.origination.v1.UnderwritingDecisionSaveRequest', '3': '.origination.v1.UnderwritingDecisionSaveResponse', '4': {}},
    {
      '1': 'UnderwritingDecisionGet',
      '2': '.origination.v1.UnderwritingDecisionGetRequest',
      '3': '.origination.v1.UnderwritingDecisionGetResponse',
      '4': {'34': 1},
    },
    {
      '1': 'UnderwritingDecisionSearch',
      '2': '.origination.v1.UnderwritingDecisionSearchRequest',
      '3': '.origination.v1.UnderwritingDecisionSearchResponse',
      '4': {'34': 1},
      '6': true,
    },
  ],
  '3': {},
};

@$core.Deprecated('Use originationServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> OriginationServiceBase$messageJson = {
  '.origination.v1.LoanProductSaveRequest': LoanProductSaveRequest$json,
  '.origination.v1.LoanProductObject': LoanProductObject$json,
  '.google.type.Money': $9.Money$json,
  '.google.protobuf.Struct': $6.Struct$json,
  '.google.protobuf.Struct.FieldsEntry': $6.Struct_FieldsEntry$json,
  '.google.protobuf.Value': $6.Value$json,
  '.google.protobuf.ListValue': $6.ListValue$json,
  '.origination.v1.LoanProductSaveResponse': LoanProductSaveResponse$json,
  '.origination.v1.LoanProductGetRequest': LoanProductGetRequest$json,
  '.origination.v1.LoanProductGetResponse': LoanProductGetResponse$json,
  '.origination.v1.LoanProductSearchRequest': LoanProductSearchRequest$json,
  '.common.v1.PageCursor': $7.PageCursor$json,
  '.origination.v1.LoanProductSearchResponse': LoanProductSearchResponse$json,
  '.origination.v1.ApplicationSaveRequest': ApplicationSaveRequest$json,
  '.origination.v1.ApplicationObject': ApplicationObject$json,
  '.origination.v1.ApplicationSaveResponse': ApplicationSaveResponse$json,
  '.origination.v1.ApplicationGetRequest': ApplicationGetRequest$json,
  '.origination.v1.ApplicationGetResponse': ApplicationGetResponse$json,
  '.origination.v1.ApplicationSearchRequest': ApplicationSearchRequest$json,
  '.origination.v1.ApplicationSearchResponse': ApplicationSearchResponse$json,
  '.origination.v1.ApplicationSubmitRequest': ApplicationSubmitRequest$json,
  '.origination.v1.ApplicationSubmitResponse': ApplicationSubmitResponse$json,
  '.origination.v1.ApplicationCancelRequest': ApplicationCancelRequest$json,
  '.origination.v1.ApplicationCancelResponse': ApplicationCancelResponse$json,
  '.origination.v1.ApplicationAcceptOfferRequest': ApplicationAcceptOfferRequest$json,
  '.origination.v1.ApplicationAcceptOfferResponse': ApplicationAcceptOfferResponse$json,
  '.origination.v1.ApplicationDeclineOfferRequest': ApplicationDeclineOfferRequest$json,
  '.origination.v1.ApplicationDeclineOfferResponse': ApplicationDeclineOfferResponse$json,
  '.origination.v1.ApplicationDocumentSaveRequest': ApplicationDocumentSaveRequest$json,
  '.origination.v1.ApplicationDocumentObject': ApplicationDocumentObject$json,
  '.origination.v1.ApplicationDocumentSaveResponse': ApplicationDocumentSaveResponse$json,
  '.origination.v1.ApplicationDocumentGetRequest': ApplicationDocumentGetRequest$json,
  '.origination.v1.ApplicationDocumentGetResponse': ApplicationDocumentGetResponse$json,
  '.origination.v1.ApplicationDocumentSearchRequest': ApplicationDocumentSearchRequest$json,
  '.origination.v1.ApplicationDocumentSearchResponse': ApplicationDocumentSearchResponse$json,
  '.origination.v1.VerificationTaskSaveRequest': VerificationTaskSaveRequest$json,
  '.origination.v1.VerificationTaskObject': VerificationTaskObject$json,
  '.origination.v1.VerificationTaskSaveResponse': VerificationTaskSaveResponse$json,
  '.origination.v1.VerificationTaskGetRequest': VerificationTaskGetRequest$json,
  '.origination.v1.VerificationTaskGetResponse': VerificationTaskGetResponse$json,
  '.origination.v1.VerificationTaskSearchRequest': VerificationTaskSearchRequest$json,
  '.origination.v1.VerificationTaskSearchResponse': VerificationTaskSearchResponse$json,
  '.origination.v1.VerificationTaskCompleteRequest': VerificationTaskCompleteRequest$json,
  '.origination.v1.VerificationTaskCompleteResponse': VerificationTaskCompleteResponse$json,
  '.origination.v1.UnderwritingDecisionSaveRequest': UnderwritingDecisionSaveRequest$json,
  '.origination.v1.UnderwritingDecisionObject': UnderwritingDecisionObject$json,
  '.origination.v1.UnderwritingDecisionSaveResponse': UnderwritingDecisionSaveResponse$json,
  '.origination.v1.UnderwritingDecisionGetRequest': UnderwritingDecisionGetRequest$json,
  '.origination.v1.UnderwritingDecisionGetResponse': UnderwritingDecisionGetResponse$json,
  '.origination.v1.UnderwritingDecisionSearchRequest': UnderwritingDecisionSearchRequest$json,
  '.origination.v1.UnderwritingDecisionSearchResponse': UnderwritingDecisionSearchResponse$json,
};

/// Descriptor for `OriginationService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List originationServiceDescriptor = $convert.base64Decode(
    'ChJPcmlnaW5hdGlvblNlcnZpY2USvQIKD0xvYW5Qcm9kdWN0U2F2ZRImLm9yaWdpbmF0aW9uLn'
    'YxLkxvYW5Qcm9kdWN0U2F2ZVJlcXVlc3QaJy5vcmlnaW5hdGlvbi52MS5Mb2FuUHJvZHVjdFNh'
    'dmVSZXNwb25zZSLYAbpHuwEKDExvYW5Qcm9kdWN0cxIfQ3JlYXRlIG9yIHVwZGF0ZSBhIGxvYW'
    '4gcHJvZHVjdBp5Q3JlYXRlcyBhIG5ldyBsb2FuIHByb2R1Y3Qgb3IgdXBkYXRlcyBhbiBleGlz'
    'dGluZyBvbmUuIExvYW4gcHJvZHVjdHMgZGVmaW5lIHRlcm1zLCByYXRlcywgZmVlcywgYW5kIG'
    'VsaWdpYmlsaXR5IGNyaXRlcmlhLioPbG9hblByb2R1Y3RTYXZlgrUYFQoTbG9hbl9wcm9kdWN0'
    'X21hbmFnZRLyAQoOTG9hblByb2R1Y3RHZXQSJS5vcmlnaW5hdGlvbi52MS5Mb2FuUHJvZHVjdE'
    'dldFJlcXVlc3QaJi5vcmlnaW5hdGlvbi52MS5Mb2FuUHJvZHVjdEdldFJlc3BvbnNlIpABkAIB'
    'ukdzCgxMb2FuUHJvZHVjdHMSGEdldCBhIGxvYW4gcHJvZHVjdCBieSBJRBo5UmV0cmlldmVzIG'
    'EgbG9hbiBwcm9kdWN0IHJlY29yZCBieSBpdHMgdW5pcXVlIGlkZW50aWZpZXIuKg5sb2FuUHJv'
    'ZHVjdEdldIK1GBMKEWxvYW5fcHJvZHVjdF92aWV3EqgCChFMb2FuUHJvZHVjdFNlYXJjaBIoLm'
    '9yaWdpbmF0aW9uLnYxLkxvYW5Qcm9kdWN0U2VhcmNoUmVxdWVzdBopLm9yaWdpbmF0aW9uLnYx'
    'LkxvYW5Qcm9kdWN0U2VhcmNoUmVzcG9uc2UiuwGQAgG6R50BCgxMb2FuUHJvZHVjdHMSFFNlYX'
    'JjaCBsb2FuIHByb2R1Y3RzGmRTZWFyY2hlcyBmb3IgbG9hbiBwcm9kdWN0cyBtYXRjaGluZyBz'
    'cGVjaWZpZWQgY3JpdGVyaWEuIFN1cHBvcnRzIGZpbHRlcmluZyBieSBiYW5rIGFuZCBwcm9kdW'
    'N0IHR5cGUuKhFsb2FuUHJvZHVjdFNlYXJjaIK1GBMKEWxvYW5fcHJvZHVjdF92aWV3MAESpwIK'
    'D0FwcGxpY2F0aW9uU2F2ZRImLm9yaWdpbmF0aW9uLnYxLkFwcGxpY2F0aW9uU2F2ZVJlcXVlc3'
    'QaJy5vcmlnaW5hdGlvbi52MS5BcHBsaWNhdGlvblNhdmVSZXNwb25zZSLCAbpHpgEKDEFwcGxp'
    'Y2F0aW9ucxIjQ3JlYXRlIG9yIHVwZGF0ZSBhIGxvYW4gYXBwbGljYXRpb24aYENyZWF0ZXMgYS'
    'BuZXcgbG9hbiBhcHBsaWNhdGlvbiBvciB1cGRhdGVzIGFuIGV4aXN0aW5nIGRyYWZ0LiBBcHBs'
    'aWNhdGlvbnMgc3RhcnQgaW4gRFJBRlQgc3RhdHVzLioPYXBwbGljYXRpb25TYXZlgrUYFAoSYX'
    'BwbGljYXRpb25fbWFuYWdlEvUBCg5BcHBsaWNhdGlvbkdldBIlLm9yaWdpbmF0aW9uLnYxLkFw'
    'cGxpY2F0aW9uR2V0UmVxdWVzdBomLm9yaWdpbmF0aW9uLnYxLkFwcGxpY2F0aW9uR2V0UmVzcG'
    '9uc2UikwGQAgG6R3cKDEFwcGxpY2F0aW9ucxIYR2V0IGFuIGFwcGxpY2F0aW9uIGJ5IElEGj1S'
    'ZXRyaWV2ZXMgYSBsb2FuIGFwcGxpY2F0aW9uIHJlY29yZCBieSBpdHMgdW5pcXVlIGlkZW50aW'
    'ZpZXIuKg5hcHBsaWNhdGlvbkdldIK1GBIKEGFwcGxpY2F0aW9uX3ZpZXcSuQIKEUFwcGxpY2F0'
    'aW9uU2VhcmNoEigub3JpZ2luYXRpb24udjEuQXBwbGljYXRpb25TZWFyY2hSZXF1ZXN0Gikub3'
    'JpZ2luYXRpb24udjEuQXBwbGljYXRpb25TZWFyY2hSZXNwb25zZSLMAZACAbpHrwEKDEFwcGxp'
    'Y2F0aW9ucxITU2VhcmNoIGFwcGxpY2F0aW9ucxp3U2VhcmNoZXMgZm9yIGFwcGxpY2F0aW9ucy'
    'BtYXRjaGluZyBzcGVjaWZpZWQgY3JpdGVyaWEuIFN1cHBvcnRzIGZpbHRlcmluZyBieSBib3Jy'
    'b3dlciwgYWdlbnQsIGJyYW5jaCwgYmFuaywgYW5kIHN0YXR1cy4qEWFwcGxpY2F0aW9uU2Vhcm'
    'NogrUYEgoQYXBwbGljYXRpb25fdmlldzABEqUCChFBcHBsaWNhdGlvblN1Ym1pdBIoLm9yaWdp'
    'bmF0aW9uLnYxLkFwcGxpY2F0aW9uU3VibWl0UmVxdWVzdBopLm9yaWdpbmF0aW9uLnYxLkFwcG'
    'xpY2F0aW9uU3VibWl0UmVzcG9uc2UiugG6R54BCgxBcHBsaWNhdGlvbnMSGlN1Ym1pdCBhIGRy'
    'YWZ0IGFwcGxpY2F0aW9uGl9UcmFuc2l0aW9ucyBhbiBhcHBsaWNhdGlvbiBmcm9tIERSQUZUIH'
    'RvIFNVQk1JVFRFRCBzdGF0dXMsIHRyaWdnZXJpbmcgdGhlIG9yaWdpbmF0aW9uIHdvcmtmbG93'
    'LioRYXBwbGljYXRpb25TdWJtaXSCtRgUChJhcHBsaWNhdGlvbl9zdWJtaXQS8QEKEUFwcGxpY2'
    'F0aW9uQ2FuY2VsEigub3JpZ2luYXRpb24udjEuQXBwbGljYXRpb25DYW5jZWxSZXF1ZXN0Giku'
    'b3JpZ2luYXRpb24udjEuQXBwbGljYXRpb25DYW5jZWxSZXNwb25zZSKGAbpHawoMQXBwbGljYX'
    'Rpb25zEhVDYW5jZWwgYW4gYXBwbGljYXRpb24aMUNhbmNlbHMgYSBub24tdGVybWluYWwgYXBw'
    'bGljYXRpb24gd2l0aCBhIHJlYXNvbi4qEWFwcGxpY2F0aW9uQ2FuY2VsgrUYFAoSYXBwbGljYX'
    'Rpb25fbWFuYWdlEpMCChZBcHBsaWNhdGlvbkFjY2VwdE9mZmVyEi0ub3JpZ2luYXRpb24udjEu'
    'QXBwbGljYXRpb25BY2NlcHRPZmZlclJlcXVlc3QaLi5vcmlnaW5hdGlvbi52MS5BcHBsaWNhdG'
    'lvbkFjY2VwdE9mZmVyUmVzcG9uc2UimQG6R34KDEFwcGxpY2F0aW9ucxITQWNjZXB0IGEgbG9h'
    'biBvZmZlchpBQWNjZXB0cyBhIGdlbmVyYXRlZCBsb2FuIG9mZmVyLCB0cmlnZ2VyaW5nIGxvYW'
    '4gYWNjb3VudCBjcmVhdGlvbi4qFmFwcGxpY2F0aW9uQWNjZXB0T2ZmZXKCtRgUChJhcHBsaWNh'
    'dGlvbl9tYW5hZ2UShQIKF0FwcGxpY2F0aW9uRGVjbGluZU9mZmVyEi4ub3JpZ2luYXRpb24udj'
    'EuQXBwbGljYXRpb25EZWNsaW5lT2ZmZXJSZXF1ZXN0Gi8ub3JpZ2luYXRpb24udjEuQXBwbGlj'
    'YXRpb25EZWNsaW5lT2ZmZXJSZXNwb25zZSKIAbpHbQoMQXBwbGljYXRpb25zEhREZWNsaW5lIG'
    'EgbG9hbiBvZmZlchouRGVjbGluZXMgYSBnZW5lcmF0ZWQgbG9hbiBvZmZlciB3aXRoIGEgcmVh'
    'c29uLioXYXBwbGljYXRpb25EZWNsaW5lT2ZmZXKCtRgUChJhcHBsaWNhdGlvbl9tYW5hZ2USsg'
    'IKF0FwcGxpY2F0aW9uRG9jdW1lbnRTYXZlEi4ub3JpZ2luYXRpb24udjEuQXBwbGljYXRpb25E'
    'b2N1bWVudFNhdmVSZXF1ZXN0Gi8ub3JpZ2luYXRpb24udjEuQXBwbGljYXRpb25Eb2N1bWVudF'
    'NhdmVSZXNwb25zZSK1AbpHkAEKFEFwcGxpY2F0aW9uRG9jdW1lbnRzEihDcmVhdGUgb3IgdXBk'
    'YXRlIGFuIGFwcGxpY2F0aW9uIGRvY3VtZW50GjVBdHRhY2hlcyBvciB1cGRhdGVzIGEgZG9jdW'
    '1lbnQgb24gYSBsb2FuIGFwcGxpY2F0aW9uLioXYXBwbGljYXRpb25Eb2N1bWVudFNhdmWCtRgd'
    'ChthcHBsaWNhdGlvbl9kb2N1bWVudF9tYW5hZ2UStQIKFkFwcGxpY2F0aW9uRG9jdW1lbnRHZX'
    'QSLS5vcmlnaW5hdGlvbi52MS5BcHBsaWNhdGlvbkRvY3VtZW50R2V0UmVxdWVzdBouLm9yaWdp'
    'bmF0aW9uLnYxLkFwcGxpY2F0aW9uRG9jdW1lbnRHZXRSZXNwb25zZSK7AZACAbpHlQEKFEFwcG'
    'xpY2F0aW9uRG9jdW1lbnRzEiFHZXQgYW4gYXBwbGljYXRpb24gZG9jdW1lbnQgYnkgSUQaQlJl'
    'dHJpZXZlcyBhbiBhcHBsaWNhdGlvbiBkb2N1bWVudCByZWNvcmQgYnkgaXRzIHVuaXF1ZSBpZG'
    'VudGlmaWVyLioWYXBwbGljYXRpb25Eb2N1bWVudEdldIK1GBsKGWFwcGxpY2F0aW9uX2RvY3Vt'
    'ZW50X3ZpZXcS0wIKGUFwcGxpY2F0aW9uRG9jdW1lbnRTZWFyY2gSMC5vcmlnaW5hdGlvbi52MS'
    '5BcHBsaWNhdGlvbkRvY3VtZW50U2VhcmNoUmVxdWVzdBoxLm9yaWdpbmF0aW9uLnYxLkFwcGxp'
    'Y2F0aW9uRG9jdW1lbnRTZWFyY2hSZXNwb25zZSLOAZACAbpHqAEKFEFwcGxpY2F0aW9uRG9jdW'
    '1lbnRzEhxTZWFyY2ggYXBwbGljYXRpb24gZG9jdW1lbnRzGldTZWFyY2hlcyBmb3IgZG9jdW1l'
    'bnRzIGF0dGFjaGVkIHRvIGFuIGFwcGxpY2F0aW9uLiBTdXBwb3J0cyBmaWx0ZXJpbmcgYnkgZG'
    '9jdW1lbnQgdHlwZS4qGWFwcGxpY2F0aW9uRG9jdW1lbnRTZWFyY2iCtRgbChlhcHBsaWNhdGlv'
    'bl9kb2N1bWVudF92aWV3MAESsAIKFFZlcmlmaWNhdGlvblRhc2tTYXZlEisub3JpZ2luYXRpb2'
    '4udjEuVmVyaWZpY2F0aW9uVGFza1NhdmVSZXF1ZXN0Giwub3JpZ2luYXRpb24udjEuVmVyaWZp'
    'Y2F0aW9uVGFza1NhdmVSZXNwb25zZSK8AbpHnwEKEVZlcmlmaWNhdGlvblRhc2tzEiRDcmVhdG'
    'Ugb3IgdXBkYXRlIGEgdmVyaWZpY2F0aW9uIHRhc2saTkNyZWF0ZXMgYSBuZXcgdmVyaWZpY2F0'
    'aW9uIHRhc2sgb3IgdXBkYXRlcyBhbiBleGlzdGluZyBvbmUgZm9yIGFuIGFwcGxpY2F0aW9uLi'
    'oUdmVyaWZpY2F0aW9uVGFza1NhdmWCtRgVChN2ZXJpZmljYXRpb25fbWFuYWdlEpYCChNWZXJp'
    'ZmljYXRpb25UYXNrR2V0Eioub3JpZ2luYXRpb24udjEuVmVyaWZpY2F0aW9uVGFza0dldFJlcX'
    'Vlc3QaKy5vcmlnaW5hdGlvbi52MS5WZXJpZmljYXRpb25UYXNrR2V0UmVzcG9uc2UipQGQAgG6'
    'R4cBChFWZXJpZmljYXRpb25UYXNrcxIdR2V0IGEgdmVyaWZpY2F0aW9uIHRhc2sgYnkgSUQaPl'
    'JldHJpZXZlcyBhIHZlcmlmaWNhdGlvbiB0YXNrIHJlY29yZCBieSBpdHMgdW5pcXVlIGlkZW50'
    'aWZpZXIuKhN2ZXJpZmljYXRpb25UYXNrR2V0grUYEwoRdmVyaWZpY2F0aW9uX3ZpZXcSuwIKFl'
    'ZlcmlmaWNhdGlvblRhc2tTZWFyY2gSLS5vcmlnaW5hdGlvbi52MS5WZXJpZmljYXRpb25UYXNr'
    'U2VhcmNoUmVxdWVzdBouLm9yaWdpbmF0aW9uLnYxLlZlcmlmaWNhdGlvblRhc2tTZWFyY2hSZX'
    'Nwb25zZSK/AZACAbpHoQEKEVZlcmlmaWNhdGlvblRhc2tzEhlTZWFyY2ggdmVyaWZpY2F0aW9u'
    'IHRhc2tzGllTZWFyY2hlcyBmb3IgdmVyaWZpY2F0aW9uIHRhc2tzLiBTdXBwb3J0cyBmaWx0ZX'
    'JpbmcgYnkgYXBwbGljYXRpb24sIGFzc2lnbmVlLCBhbmQgc3RhdHVzLioWdmVyaWZpY2F0aW9u'
    'VGFza1NlYXJjaIK1GBMKEXZlcmlmaWNhdGlvbl92aWV3MAESpQIKGFZlcmlmaWNhdGlvblRhc2'
    'tDb21wbGV0ZRIvLm9yaWdpbmF0aW9uLnYxLlZlcmlmaWNhdGlvblRhc2tDb21wbGV0ZVJlcXVl'
    'c3QaMC5vcmlnaW5hdGlvbi52MS5WZXJpZmljYXRpb25UYXNrQ29tcGxldGVSZXNwb25zZSKlAb'
    'pHiAEKEVZlcmlmaWNhdGlvblRhc2tzEhxDb21wbGV0ZSBhIHZlcmlmaWNhdGlvbiB0YXNrGjtN'
    'YXJrcyBhIHZlcmlmaWNhdGlvbiB0YXNrIGFzIFBBU1NFRCBvciBGQUlMRUQgd2l0aCByZXN1bH'
    'RzLioYdmVyaWZpY2F0aW9uVGFza0NvbXBsZXRlgrUYFQoTdmVyaWZpY2F0aW9uX21hbmFnZRKz'
    'AgoYVW5kZXJ3cml0aW5nRGVjaXNpb25TYXZlEi8ub3JpZ2luYXRpb24udjEuVW5kZXJ3cml0aW'
    '5nRGVjaXNpb25TYXZlUmVxdWVzdBowLm9yaWdpbmF0aW9uLnYxLlVuZGVyd3JpdGluZ0RlY2lz'
    'aW9uU2F2ZVJlc3BvbnNlIrMBukeWAQoVVW5kZXJ3cml0aW5nRGVjaXNpb25zEilDcmVhdGUgb3'
    'IgdXBkYXRlIGFuIHVuZGVyd3JpdGluZyBkZWNpc2lvbho4UmVjb3JkcyBhbiB1bmRlcndyaXRp'
    'bmcgZGVjaXNpb24gZm9yIGEgbG9hbiBhcHBsaWNhdGlvbi4qGHVuZGVyd3JpdGluZ0RlY2lzaW'
    '9uU2F2ZYK1GBUKE3VuZGVyd3JpdGluZ19tYW5hZ2UStAIKF1VuZGVyd3JpdGluZ0RlY2lzaW9u'
    'R2V0Ei4ub3JpZ2luYXRpb24udjEuVW5kZXJ3cml0aW5nRGVjaXNpb25HZXRSZXF1ZXN0Gi8ub3'
    'JpZ2luYXRpb24udjEuVW5kZXJ3cml0aW5nRGVjaXNpb25HZXRSZXNwb25zZSK3AZACAbpHmQEK'
    'FVVuZGVyd3JpdGluZ0RlY2lzaW9ucxIiR2V0IGFuIHVuZGVyd3JpdGluZyBkZWNpc2lvbiBieS'
    'BJRBpDUmV0cmlldmVzIGFuIHVuZGVyd3JpdGluZyBkZWNpc2lvbiByZWNvcmQgYnkgaXRzIHVu'
    'aXF1ZSBpZGVudGlmaWVyLioXdW5kZXJ3cml0aW5nRGVjaXNpb25HZXSCtRgTChF1bmRlcndyaX'
    'RpbmdfdmlldxK2AgoaVW5kZXJ3cml0aW5nRGVjaXNpb25TZWFyY2gSMS5vcmlnaW5hdGlvbi52'
    'MS5VbmRlcndyaXRpbmdEZWNpc2lvblNlYXJjaFJlcXVlc3QaMi5vcmlnaW5hdGlvbi52MS5Vbm'
    'RlcndyaXRpbmdEZWNpc2lvblNlYXJjaFJlc3BvbnNlIq4BkAIBukeQAQoVVW5kZXJ3cml0aW5n'
    'RGVjaXNpb25zEh1TZWFyY2ggdW5kZXJ3cml0aW5nIGRlY2lzaW9ucxo8U2VhcmNoZXMgZm9yIH'
    'VuZGVyd3JpdGluZyBkZWNpc2lvbnMgZm9yIGEgZ2l2ZW4gYXBwbGljYXRpb24uKhp1bmRlcndy'
    'aXRpbmdEZWNpc2lvblNlYXJjaIK1GBMKEXVuZGVyd3JpdGluZ192aWV3MAEazQqCtRjICgoTc2'
    'VydmljZV9vcmlnaW5hdGlvbhIRbG9hbl9wcm9kdWN0X3ZpZXcSE2xvYW5fcHJvZHVjdF9tYW5h'
    'Z2USEGFwcGxpY2F0aW9uX3ZpZXcSEmFwcGxpY2F0aW9uX21hbmFnZRISYXBwbGljYXRpb25fc3'
    'VibWl0EhlhcHBsaWNhdGlvbl9kb2N1bWVudF92aWV3EhthcHBsaWNhdGlvbl9kb2N1bWVudF9t'
    'YW5hZ2USEXZlcmlmaWNhdGlvbl92aWV3EhN2ZXJpZmljYXRpb25fbWFuYWdlEhF1bmRlcndyaX'
    'RpbmdfdmlldxITdW5kZXJ3cml0aW5nX21hbmFnZRrsAQgBEhFsb2FuX3Byb2R1Y3RfdmlldxIT'
    'bG9hbl9wcm9kdWN0X21hbmFnZRIQYXBwbGljYXRpb25fdmlldxISYXBwbGljYXRpb25fbWFuYW'
    'dlEhJhcHBsaWNhdGlvbl9zdWJtaXQSGWFwcGxpY2F0aW9uX2RvY3VtZW50X3ZpZXcSG2FwcGxp'
    'Y2F0aW9uX2RvY3VtZW50X21hbmFnZRIRdmVyaWZpY2F0aW9uX3ZpZXcSE3ZlcmlmaWNhdGlvbl'
    '9tYW5hZ2USEXVuZGVyd3JpdGluZ192aWV3EhN1bmRlcndyaXRpbmdfbWFuYWdlGuwBCAISEWxv'
    'YW5fcHJvZHVjdF92aWV3EhNsb2FuX3Byb2R1Y3RfbWFuYWdlEhBhcHBsaWNhdGlvbl92aWV3Eh'
    'JhcHBsaWNhdGlvbl9tYW5hZ2USEmFwcGxpY2F0aW9uX3N1Ym1pdBIZYXBwbGljYXRpb25fZG9j'
    'dW1lbnRfdmlldxIbYXBwbGljYXRpb25fZG9jdW1lbnRfbWFuYWdlEhF2ZXJpZmljYXRpb25fdm'
    'lldxITdmVyaWZpY2F0aW9uX21hbmFnZRIRdW5kZXJ3cml0aW5nX3ZpZXcSE3VuZGVyd3JpdGlu'
    'Z19tYW5hZ2UapQEIAxIRbG9hbl9wcm9kdWN0X3ZpZXcSEGFwcGxpY2F0aW9uX3ZpZXcSEmFwcG'
    'xpY2F0aW9uX21hbmFnZRISYXBwbGljYXRpb25fc3VibWl0EhlhcHBsaWNhdGlvbl9kb2N1bWVu'
    'dF92aWV3EhF2ZXJpZmljYXRpb25fdmlldxITdmVyaWZpY2F0aW9uX21hbmFnZRIRdW5kZXJ3cm'
    'l0aW5nX3ZpZXcaaAgEEhFsb2FuX3Byb2R1Y3RfdmlldxIQYXBwbGljYXRpb25fdmlldxIZYXBw'
    'bGljYXRpb25fZG9jdW1lbnRfdmlldxIRdmVyaWZpY2F0aW9uX3ZpZXcSEXVuZGVyd3JpdGluZ1'
    '92aWV3GmgIBRIRbG9hbl9wcm9kdWN0X3ZpZXcSEGFwcGxpY2F0aW9uX3ZpZXcSGWFwcGxpY2F0'
    'aW9uX2RvY3VtZW50X3ZpZXcSEXZlcmlmaWNhdGlvbl92aWV3EhF1bmRlcndyaXRpbmdfdmlldx'
    'rsAQgGEhFsb2FuX3Byb2R1Y3RfdmlldxITbG9hbl9wcm9kdWN0X21hbmFnZRIQYXBwbGljYXRp'
    'b25fdmlldxISYXBwbGljYXRpb25fbWFuYWdlEhJhcHBsaWNhdGlvbl9zdWJtaXQSGWFwcGxpY2'
    'F0aW9uX2RvY3VtZW50X3ZpZXcSG2FwcGxpY2F0aW9uX2RvY3VtZW50X21hbmFnZRIRdmVyaWZp'
    'Y2F0aW9uX3ZpZXcSE3ZlcmlmaWNhdGlvbl9tYW5hZ2USEXVuZGVyd3JpdGluZ192aWV3EhN1bm'
    'RlcndyaXRpbmdfbWFuYWdl');

