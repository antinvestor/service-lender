//
//  Generated code. Do not modify.
//  source: origination/v1/origination.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// LoanProductType defines the type of loan product.
class LoanProductType extends $pb.ProtobufEnum {
  static const LoanProductType LOAN_PRODUCT_TYPE_UNSPECIFIED = LoanProductType._(0, _omitEnumNames ? '' : 'LOAN_PRODUCT_TYPE_UNSPECIFIED');
  static const LoanProductType LOAN_PRODUCT_TYPE_TERM = LoanProductType._(1, _omitEnumNames ? '' : 'LOAN_PRODUCT_TYPE_TERM');
  static const LoanProductType LOAN_PRODUCT_TYPE_REVOLVING = LoanProductType._(2, _omitEnumNames ? '' : 'LOAN_PRODUCT_TYPE_REVOLVING');
  static const LoanProductType LOAN_PRODUCT_TYPE_BULLET = LoanProductType._(3, _omitEnumNames ? '' : 'LOAN_PRODUCT_TYPE_BULLET');
  static const LoanProductType LOAN_PRODUCT_TYPE_GRADUATED = LoanProductType._(4, _omitEnumNames ? '' : 'LOAN_PRODUCT_TYPE_GRADUATED');

  static const $core.List<LoanProductType> values = <LoanProductType> [
    LOAN_PRODUCT_TYPE_UNSPECIFIED,
    LOAN_PRODUCT_TYPE_TERM,
    LOAN_PRODUCT_TYPE_REVOLVING,
    LOAN_PRODUCT_TYPE_BULLET,
    LOAN_PRODUCT_TYPE_GRADUATED,
  ];

  static final $core.Map<$core.int, LoanProductType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static LoanProductType? valueOf($core.int value) => _byValue[value];

  const LoanProductType._($core.int v, $core.String n) : super(v, n);
}

/// InterestMethod defines how interest is calculated.
class InterestMethod extends $pb.ProtobufEnum {
  static const InterestMethod INTEREST_METHOD_UNSPECIFIED = InterestMethod._(0, _omitEnumNames ? '' : 'INTEREST_METHOD_UNSPECIFIED');
  static const InterestMethod INTEREST_METHOD_FLAT = InterestMethod._(1, _omitEnumNames ? '' : 'INTEREST_METHOD_FLAT');
  static const InterestMethod INTEREST_METHOD_REDUCING_BALANCE = InterestMethod._(2, _omitEnumNames ? '' : 'INTEREST_METHOD_REDUCING_BALANCE');
  static const InterestMethod INTEREST_METHOD_COMPOUND = InterestMethod._(3, _omitEnumNames ? '' : 'INTEREST_METHOD_COMPOUND');

  static const $core.List<InterestMethod> values = <InterestMethod> [
    INTEREST_METHOD_UNSPECIFIED,
    INTEREST_METHOD_FLAT,
    INTEREST_METHOD_REDUCING_BALANCE,
    INTEREST_METHOD_COMPOUND,
  ];

  static final $core.Map<$core.int, InterestMethod> _byValue = $pb.ProtobufEnum.initByValue(values);
  static InterestMethod? valueOf($core.int value) => _byValue[value];

  const InterestMethod._($core.int v, $core.String n) : super(v, n);
}

/// RepaymentFrequency defines the repayment schedule frequency.
class RepaymentFrequency extends $pb.ProtobufEnum {
  static const RepaymentFrequency REPAYMENT_FREQUENCY_UNSPECIFIED = RepaymentFrequency._(0, _omitEnumNames ? '' : 'REPAYMENT_FREQUENCY_UNSPECIFIED');
  static const RepaymentFrequency REPAYMENT_FREQUENCY_DAILY = RepaymentFrequency._(1, _omitEnumNames ? '' : 'REPAYMENT_FREQUENCY_DAILY');
  static const RepaymentFrequency REPAYMENT_FREQUENCY_WEEKLY = RepaymentFrequency._(2, _omitEnumNames ? '' : 'REPAYMENT_FREQUENCY_WEEKLY');
  static const RepaymentFrequency REPAYMENT_FREQUENCY_BIWEEKLY = RepaymentFrequency._(3, _omitEnumNames ? '' : 'REPAYMENT_FREQUENCY_BIWEEKLY');
  static const RepaymentFrequency REPAYMENT_FREQUENCY_MONTHLY = RepaymentFrequency._(4, _omitEnumNames ? '' : 'REPAYMENT_FREQUENCY_MONTHLY');
  static const RepaymentFrequency REPAYMENT_FREQUENCY_QUARTERLY = RepaymentFrequency._(5, _omitEnumNames ? '' : 'REPAYMENT_FREQUENCY_QUARTERLY');

  static const $core.List<RepaymentFrequency> values = <RepaymentFrequency> [
    REPAYMENT_FREQUENCY_UNSPECIFIED,
    REPAYMENT_FREQUENCY_DAILY,
    REPAYMENT_FREQUENCY_WEEKLY,
    REPAYMENT_FREQUENCY_BIWEEKLY,
    REPAYMENT_FREQUENCY_MONTHLY,
    REPAYMENT_FREQUENCY_QUARTERLY,
  ];

  static final $core.Map<$core.int, RepaymentFrequency> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RepaymentFrequency? valueOf($core.int value) => _byValue[value];

  const RepaymentFrequency._($core.int v, $core.String n) : super(v, n);
}

/// ApplicationStatus defines the current stage of a loan application.
class ApplicationStatus extends $pb.ProtobufEnum {
  static const ApplicationStatus APPLICATION_STATUS_UNSPECIFIED = ApplicationStatus._(0, _omitEnumNames ? '' : 'APPLICATION_STATUS_UNSPECIFIED');
  static const ApplicationStatus APPLICATION_STATUS_DRAFT = ApplicationStatus._(1, _omitEnumNames ? '' : 'APPLICATION_STATUS_DRAFT');
  static const ApplicationStatus APPLICATION_STATUS_SUBMITTED = ApplicationStatus._(2, _omitEnumNames ? '' : 'APPLICATION_STATUS_SUBMITTED');
  static const ApplicationStatus APPLICATION_STATUS_KYC_PENDING = ApplicationStatus._(3, _omitEnumNames ? '' : 'APPLICATION_STATUS_KYC_PENDING');
  static const ApplicationStatus APPLICATION_STATUS_DOCUMENTS_PENDING = ApplicationStatus._(4, _omitEnumNames ? '' : 'APPLICATION_STATUS_DOCUMENTS_PENDING');
  static const ApplicationStatus APPLICATION_STATUS_VERIFICATION = ApplicationStatus._(5, _omitEnumNames ? '' : 'APPLICATION_STATUS_VERIFICATION');
  static const ApplicationStatus APPLICATION_STATUS_UNDERWRITING = ApplicationStatus._(6, _omitEnumNames ? '' : 'APPLICATION_STATUS_UNDERWRITING');
  static const ApplicationStatus APPLICATION_STATUS_APPROVED = ApplicationStatus._(7, _omitEnumNames ? '' : 'APPLICATION_STATUS_APPROVED');
  static const ApplicationStatus APPLICATION_STATUS_REJECTED = ApplicationStatus._(8, _omitEnumNames ? '' : 'APPLICATION_STATUS_REJECTED');
  static const ApplicationStatus APPLICATION_STATUS_OFFER_GENERATED = ApplicationStatus._(9, _omitEnumNames ? '' : 'APPLICATION_STATUS_OFFER_GENERATED');
  static const ApplicationStatus APPLICATION_STATUS_OFFER_ACCEPTED = ApplicationStatus._(10, _omitEnumNames ? '' : 'APPLICATION_STATUS_OFFER_ACCEPTED');
  static const ApplicationStatus APPLICATION_STATUS_OFFER_DECLINED = ApplicationStatus._(11, _omitEnumNames ? '' : 'APPLICATION_STATUS_OFFER_DECLINED');
  static const ApplicationStatus APPLICATION_STATUS_LOAN_CREATED = ApplicationStatus._(12, _omitEnumNames ? '' : 'APPLICATION_STATUS_LOAN_CREATED');
  static const ApplicationStatus APPLICATION_STATUS_CANCELLED = ApplicationStatus._(13, _omitEnumNames ? '' : 'APPLICATION_STATUS_CANCELLED');
  static const ApplicationStatus APPLICATION_STATUS_EXPIRED = ApplicationStatus._(14, _omitEnumNames ? '' : 'APPLICATION_STATUS_EXPIRED');

  static const $core.List<ApplicationStatus> values = <ApplicationStatus> [
    APPLICATION_STATUS_UNSPECIFIED,
    APPLICATION_STATUS_DRAFT,
    APPLICATION_STATUS_SUBMITTED,
    APPLICATION_STATUS_KYC_PENDING,
    APPLICATION_STATUS_DOCUMENTS_PENDING,
    APPLICATION_STATUS_VERIFICATION,
    APPLICATION_STATUS_UNDERWRITING,
    APPLICATION_STATUS_APPROVED,
    APPLICATION_STATUS_REJECTED,
    APPLICATION_STATUS_OFFER_GENERATED,
    APPLICATION_STATUS_OFFER_ACCEPTED,
    APPLICATION_STATUS_OFFER_DECLINED,
    APPLICATION_STATUS_LOAN_CREATED,
    APPLICATION_STATUS_CANCELLED,
    APPLICATION_STATUS_EXPIRED,
  ];

  static final $core.Map<$core.int, ApplicationStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ApplicationStatus? valueOf($core.int value) => _byValue[value];

  const ApplicationStatus._($core.int v, $core.String n) : super(v, n);
}

/// DocumentType defines the type of document attached to an application.
class DocumentType extends $pb.ProtobufEnum {
  static const DocumentType DOCUMENT_TYPE_UNSPECIFIED = DocumentType._(0, _omitEnumNames ? '' : 'DOCUMENT_TYPE_UNSPECIFIED');
  static const DocumentType DOCUMENT_TYPE_NATIONAL_ID = DocumentType._(1, _omitEnumNames ? '' : 'DOCUMENT_TYPE_NATIONAL_ID');
  static const DocumentType DOCUMENT_TYPE_PASSPORT = DocumentType._(2, _omitEnumNames ? '' : 'DOCUMENT_TYPE_PASSPORT');
  static const DocumentType DOCUMENT_TYPE_BUSINESS_REGISTRATION = DocumentType._(3, _omitEnumNames ? '' : 'DOCUMENT_TYPE_BUSINESS_REGISTRATION');
  static const DocumentType DOCUMENT_TYPE_BANK_STATEMENT = DocumentType._(4, _omitEnumNames ? '' : 'DOCUMENT_TYPE_BANK_STATEMENT');
  static const DocumentType DOCUMENT_TYPE_TAX_CERTIFICATE = DocumentType._(5, _omitEnumNames ? '' : 'DOCUMENT_TYPE_TAX_CERTIFICATE');
  static const DocumentType DOCUMENT_TYPE_PROOF_OF_ADDRESS = DocumentType._(6, _omitEnumNames ? '' : 'DOCUMENT_TYPE_PROOF_OF_ADDRESS');
  static const DocumentType DOCUMENT_TYPE_INCOME_PROOF = DocumentType._(7, _omitEnumNames ? '' : 'DOCUMENT_TYPE_INCOME_PROOF');
  static const DocumentType DOCUMENT_TYPE_COLLATERAL_PHOTO = DocumentType._(8, _omitEnumNames ? '' : 'DOCUMENT_TYPE_COLLATERAL_PHOTO');
  static const DocumentType DOCUMENT_TYPE_OTHER = DocumentType._(99, _omitEnumNames ? '' : 'DOCUMENT_TYPE_OTHER');

  static const $core.List<DocumentType> values = <DocumentType> [
    DOCUMENT_TYPE_UNSPECIFIED,
    DOCUMENT_TYPE_NATIONAL_ID,
    DOCUMENT_TYPE_PASSPORT,
    DOCUMENT_TYPE_BUSINESS_REGISTRATION,
    DOCUMENT_TYPE_BANK_STATEMENT,
    DOCUMENT_TYPE_TAX_CERTIFICATE,
    DOCUMENT_TYPE_PROOF_OF_ADDRESS,
    DOCUMENT_TYPE_INCOME_PROOF,
    DOCUMENT_TYPE_COLLATERAL_PHOTO,
    DOCUMENT_TYPE_OTHER,
  ];

  static final $core.Map<$core.int, DocumentType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DocumentType? valueOf($core.int value) => _byValue[value];

  const DocumentType._($core.int v, $core.String n) : super(v, n);
}

/// VerificationStatus defines the status of a verification task or document.
class VerificationStatus extends $pb.ProtobufEnum {
  static const VerificationStatus VERIFICATION_STATUS_UNSPECIFIED = VerificationStatus._(0, _omitEnumNames ? '' : 'VERIFICATION_STATUS_UNSPECIFIED');
  static const VerificationStatus VERIFICATION_STATUS_PENDING = VerificationStatus._(1, _omitEnumNames ? '' : 'VERIFICATION_STATUS_PENDING');
  static const VerificationStatus VERIFICATION_STATUS_IN_PROGRESS = VerificationStatus._(2, _omitEnumNames ? '' : 'VERIFICATION_STATUS_IN_PROGRESS');
  static const VerificationStatus VERIFICATION_STATUS_PASSED = VerificationStatus._(3, _omitEnumNames ? '' : 'VERIFICATION_STATUS_PASSED');
  static const VerificationStatus VERIFICATION_STATUS_FAILED = VerificationStatus._(4, _omitEnumNames ? '' : 'VERIFICATION_STATUS_FAILED');
  static const VerificationStatus VERIFICATION_STATUS_NEEDS_REVIEW = VerificationStatus._(5, _omitEnumNames ? '' : 'VERIFICATION_STATUS_NEEDS_REVIEW');

  static const $core.List<VerificationStatus> values = <VerificationStatus> [
    VERIFICATION_STATUS_UNSPECIFIED,
    VERIFICATION_STATUS_PENDING,
    VERIFICATION_STATUS_IN_PROGRESS,
    VERIFICATION_STATUS_PASSED,
    VERIFICATION_STATUS_FAILED,
    VERIFICATION_STATUS_NEEDS_REVIEW,
  ];

  static final $core.Map<$core.int, VerificationStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static VerificationStatus? valueOf($core.int value) => _byValue[value];

  const VerificationStatus._($core.int v, $core.String n) : super(v, n);
}

/// UnderwritingOutcome defines the result of an underwriting decision.
class UnderwritingOutcome extends $pb.ProtobufEnum {
  static const UnderwritingOutcome UNDERWRITING_OUTCOME_UNSPECIFIED = UnderwritingOutcome._(0, _omitEnumNames ? '' : 'UNDERWRITING_OUTCOME_UNSPECIFIED');
  static const UnderwritingOutcome UNDERWRITING_OUTCOME_APPROVE = UnderwritingOutcome._(1, _omitEnumNames ? '' : 'UNDERWRITING_OUTCOME_APPROVE');
  static const UnderwritingOutcome UNDERWRITING_OUTCOME_REJECT = UnderwritingOutcome._(2, _omitEnumNames ? '' : 'UNDERWRITING_OUTCOME_REJECT');
  static const UnderwritingOutcome UNDERWRITING_OUTCOME_REFER = UnderwritingOutcome._(3, _omitEnumNames ? '' : 'UNDERWRITING_OUTCOME_REFER');
  static const UnderwritingOutcome UNDERWRITING_OUTCOME_COUNTER_OFFER = UnderwritingOutcome._(4, _omitEnumNames ? '' : 'UNDERWRITING_OUTCOME_COUNTER_OFFER');

  static const $core.List<UnderwritingOutcome> values = <UnderwritingOutcome> [
    UNDERWRITING_OUTCOME_UNSPECIFIED,
    UNDERWRITING_OUTCOME_APPROVE,
    UNDERWRITING_OUTCOME_REJECT,
    UNDERWRITING_OUTCOME_REFER,
    UNDERWRITING_OUTCOME_COUNTER_OFFER,
  ];

  static final $core.Map<$core.int, UnderwritingOutcome> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UnderwritingOutcome? valueOf($core.int value) => _byValue[value];

  const UnderwritingOutcome._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
