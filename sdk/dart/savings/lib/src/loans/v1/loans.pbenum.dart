//
//  Generated code. Do not modify.
//  source: loans/v1/loans.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// LoanStatus defines the current status of a loan account.
class LoanStatus extends $pb.ProtobufEnum {
  static const LoanStatus LOAN_STATUS_UNSPECIFIED = LoanStatus._(0, _omitEnumNames ? '' : 'LOAN_STATUS_UNSPECIFIED');
  static const LoanStatus LOAN_STATUS_PENDING_DISBURSEMENT = LoanStatus._(1, _omitEnumNames ? '' : 'LOAN_STATUS_PENDING_DISBURSEMENT');
  static const LoanStatus LOAN_STATUS_ACTIVE = LoanStatus._(2, _omitEnumNames ? '' : 'LOAN_STATUS_ACTIVE');
  static const LoanStatus LOAN_STATUS_DELINQUENT = LoanStatus._(3, _omitEnumNames ? '' : 'LOAN_STATUS_DELINQUENT');
  static const LoanStatus LOAN_STATUS_DEFAULT = LoanStatus._(4, _omitEnumNames ? '' : 'LOAN_STATUS_DEFAULT');
  static const LoanStatus LOAN_STATUS_PAID_OFF = LoanStatus._(5, _omitEnumNames ? '' : 'LOAN_STATUS_PAID_OFF');
  static const LoanStatus LOAN_STATUS_RESTRUCTURED = LoanStatus._(6, _omitEnumNames ? '' : 'LOAN_STATUS_RESTRUCTURED');
  static const LoanStatus LOAN_STATUS_WRITTEN_OFF = LoanStatus._(7, _omitEnumNames ? '' : 'LOAN_STATUS_WRITTEN_OFF');
  static const LoanStatus LOAN_STATUS_CLOSED = LoanStatus._(8, _omitEnumNames ? '' : 'LOAN_STATUS_CLOSED');

  static const $core.List<LoanStatus> values = <LoanStatus> [
    LOAN_STATUS_UNSPECIFIED,
    LOAN_STATUS_PENDING_DISBURSEMENT,
    LOAN_STATUS_ACTIVE,
    LOAN_STATUS_DELINQUENT,
    LOAN_STATUS_DEFAULT,
    LOAN_STATUS_PAID_OFF,
    LOAN_STATUS_RESTRUCTURED,
    LOAN_STATUS_WRITTEN_OFF,
    LOAN_STATUS_CLOSED,
  ];

  static final $core.Map<$core.int, LoanStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static LoanStatus? valueOf($core.int value) => _byValue[value];

  const LoanStatus._($core.int v, $core.String n) : super(v, n);
}

/// DisbursementStatus defines the status of a loan disbursement.
class DisbursementStatus extends $pb.ProtobufEnum {
  static const DisbursementStatus DISBURSEMENT_STATUS_UNSPECIFIED = DisbursementStatus._(0, _omitEnumNames ? '' : 'DISBURSEMENT_STATUS_UNSPECIFIED');
  static const DisbursementStatus DISBURSEMENT_STATUS_PENDING = DisbursementStatus._(1, _omitEnumNames ? '' : 'DISBURSEMENT_STATUS_PENDING');
  static const DisbursementStatus DISBURSEMENT_STATUS_PROCESSING = DisbursementStatus._(2, _omitEnumNames ? '' : 'DISBURSEMENT_STATUS_PROCESSING');
  static const DisbursementStatus DISBURSEMENT_STATUS_COMPLETED = DisbursementStatus._(3, _omitEnumNames ? '' : 'DISBURSEMENT_STATUS_COMPLETED');
  static const DisbursementStatus DISBURSEMENT_STATUS_FAILED = DisbursementStatus._(4, _omitEnumNames ? '' : 'DISBURSEMENT_STATUS_FAILED');
  static const DisbursementStatus DISBURSEMENT_STATUS_REVERSED = DisbursementStatus._(5, _omitEnumNames ? '' : 'DISBURSEMENT_STATUS_REVERSED');

  static const $core.List<DisbursementStatus> values = <DisbursementStatus> [
    DISBURSEMENT_STATUS_UNSPECIFIED,
    DISBURSEMENT_STATUS_PENDING,
    DISBURSEMENT_STATUS_PROCESSING,
    DISBURSEMENT_STATUS_COMPLETED,
    DISBURSEMENT_STATUS_FAILED,
    DISBURSEMENT_STATUS_REVERSED,
  ];

  static final $core.Map<$core.int, DisbursementStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DisbursementStatus? valueOf($core.int value) => _byValue[value];

  const DisbursementStatus._($core.int v, $core.String n) : super(v, n);
}

/// RepaymentStatus defines the status of a repayment record.
class RepaymentStatus extends $pb.ProtobufEnum {
  static const RepaymentStatus REPAYMENT_STATUS_UNSPECIFIED = RepaymentStatus._(0, _omitEnumNames ? '' : 'REPAYMENT_STATUS_UNSPECIFIED');
  static const RepaymentStatus REPAYMENT_STATUS_PENDING = RepaymentStatus._(1, _omitEnumNames ? '' : 'REPAYMENT_STATUS_PENDING');
  static const RepaymentStatus REPAYMENT_STATUS_MATCHED = RepaymentStatus._(2, _omitEnumNames ? '' : 'REPAYMENT_STATUS_MATCHED');
  static const RepaymentStatus REPAYMENT_STATUS_PARTIAL = RepaymentStatus._(3, _omitEnumNames ? '' : 'REPAYMENT_STATUS_PARTIAL');
  static const RepaymentStatus REPAYMENT_STATUS_OVERPAYMENT = RepaymentStatus._(4, _omitEnumNames ? '' : 'REPAYMENT_STATUS_OVERPAYMENT');
  static const RepaymentStatus REPAYMENT_STATUS_REVERSED = RepaymentStatus._(5, _omitEnumNames ? '' : 'REPAYMENT_STATUS_REVERSED');

  static const $core.List<RepaymentStatus> values = <RepaymentStatus> [
    REPAYMENT_STATUS_UNSPECIFIED,
    REPAYMENT_STATUS_PENDING,
    REPAYMENT_STATUS_MATCHED,
    REPAYMENT_STATUS_PARTIAL,
    REPAYMENT_STATUS_OVERPAYMENT,
    REPAYMENT_STATUS_REVERSED,
  ];

  static final $core.Map<$core.int, RepaymentStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RepaymentStatus? valueOf($core.int value) => _byValue[value];

  const RepaymentStatus._($core.int v, $core.String n) : super(v, n);
}

/// ScheduleEntryStatus defines the status of a repayment schedule entry.
class ScheduleEntryStatus extends $pb.ProtobufEnum {
  static const ScheduleEntryStatus SCHEDULE_ENTRY_STATUS_UNSPECIFIED = ScheduleEntryStatus._(0, _omitEnumNames ? '' : 'SCHEDULE_ENTRY_STATUS_UNSPECIFIED');
  static const ScheduleEntryStatus SCHEDULE_ENTRY_STATUS_UPCOMING = ScheduleEntryStatus._(1, _omitEnumNames ? '' : 'SCHEDULE_ENTRY_STATUS_UPCOMING');
  static const ScheduleEntryStatus SCHEDULE_ENTRY_STATUS_DUE = ScheduleEntryStatus._(2, _omitEnumNames ? '' : 'SCHEDULE_ENTRY_STATUS_DUE');
  static const ScheduleEntryStatus SCHEDULE_ENTRY_STATUS_PAID = ScheduleEntryStatus._(3, _omitEnumNames ? '' : 'SCHEDULE_ENTRY_STATUS_PAID');
  static const ScheduleEntryStatus SCHEDULE_ENTRY_STATUS_PARTIAL = ScheduleEntryStatus._(4, _omitEnumNames ? '' : 'SCHEDULE_ENTRY_STATUS_PARTIAL');
  static const ScheduleEntryStatus SCHEDULE_ENTRY_STATUS_OVERDUE = ScheduleEntryStatus._(5, _omitEnumNames ? '' : 'SCHEDULE_ENTRY_STATUS_OVERDUE');
  static const ScheduleEntryStatus SCHEDULE_ENTRY_STATUS_WAIVED = ScheduleEntryStatus._(6, _omitEnumNames ? '' : 'SCHEDULE_ENTRY_STATUS_WAIVED');

  static const $core.List<ScheduleEntryStatus> values = <ScheduleEntryStatus> [
    SCHEDULE_ENTRY_STATUS_UNSPECIFIED,
    SCHEDULE_ENTRY_STATUS_UPCOMING,
    SCHEDULE_ENTRY_STATUS_DUE,
    SCHEDULE_ENTRY_STATUS_PAID,
    SCHEDULE_ENTRY_STATUS_PARTIAL,
    SCHEDULE_ENTRY_STATUS_OVERDUE,
    SCHEDULE_ENTRY_STATUS_WAIVED,
  ];

  static final $core.Map<$core.int, ScheduleEntryStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ScheduleEntryStatus? valueOf($core.int value) => _byValue[value];

  const ScheduleEntryStatus._($core.int v, $core.String n) : super(v, n);
}

/// PenaltyType defines the type of penalty applied to a loan.
class PenaltyType extends $pb.ProtobufEnum {
  static const PenaltyType PENALTY_TYPE_UNSPECIFIED = PenaltyType._(0, _omitEnumNames ? '' : 'PENALTY_TYPE_UNSPECIFIED');
  static const PenaltyType PENALTY_TYPE_LATE_PAYMENT = PenaltyType._(1, _omitEnumNames ? '' : 'PENALTY_TYPE_LATE_PAYMENT');
  static const PenaltyType PENALTY_TYPE_DEFAULT = PenaltyType._(2, _omitEnumNames ? '' : 'PENALTY_TYPE_DEFAULT');
  static const PenaltyType PENALTY_TYPE_EARLY_REPAYMENT = PenaltyType._(3, _omitEnumNames ? '' : 'PENALTY_TYPE_EARLY_REPAYMENT');
  static const PenaltyType PENALTY_TYPE_BOUNCED_PAYMENT = PenaltyType._(4, _omitEnumNames ? '' : 'PENALTY_TYPE_BOUNCED_PAYMENT');

  static const $core.List<PenaltyType> values = <PenaltyType> [
    PENALTY_TYPE_UNSPECIFIED,
    PENALTY_TYPE_LATE_PAYMENT,
    PENALTY_TYPE_DEFAULT,
    PENALTY_TYPE_EARLY_REPAYMENT,
    PENALTY_TYPE_BOUNCED_PAYMENT,
  ];

  static final $core.Map<$core.int, PenaltyType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PenaltyType? valueOf($core.int value) => _byValue[value];

  const PenaltyType._($core.int v, $core.String n) : super(v, n);
}

/// RestructureType defines the type of loan restructure.
class RestructureType extends $pb.ProtobufEnum {
  static const RestructureType RESTRUCTURE_TYPE_UNSPECIFIED = RestructureType._(0, _omitEnumNames ? '' : 'RESTRUCTURE_TYPE_UNSPECIFIED');
  static const RestructureType RESTRUCTURE_TYPE_RESCHEDULE = RestructureType._(1, _omitEnumNames ? '' : 'RESTRUCTURE_TYPE_RESCHEDULE');
  static const RestructureType RESTRUCTURE_TYPE_REFINANCE = RestructureType._(2, _omitEnumNames ? '' : 'RESTRUCTURE_TYPE_REFINANCE');
  static const RestructureType RESTRUCTURE_TYPE_RATE_CHANGE = RestructureType._(3, _omitEnumNames ? '' : 'RESTRUCTURE_TYPE_RATE_CHANGE');
  static const RestructureType RESTRUCTURE_TYPE_PARTIAL_WAIVER = RestructureType._(4, _omitEnumNames ? '' : 'RESTRUCTURE_TYPE_PARTIAL_WAIVER');
  static const RestructureType RESTRUCTURE_TYPE_WRITE_OFF = RestructureType._(5, _omitEnumNames ? '' : 'RESTRUCTURE_TYPE_WRITE_OFF');

  static const $core.List<RestructureType> values = <RestructureType> [
    RESTRUCTURE_TYPE_UNSPECIFIED,
    RESTRUCTURE_TYPE_RESCHEDULE,
    RESTRUCTURE_TYPE_REFINANCE,
    RESTRUCTURE_TYPE_RATE_CHANGE,
    RESTRUCTURE_TYPE_PARTIAL_WAIVER,
    RESTRUCTURE_TYPE_WRITE_OFF,
  ];

  static final $core.Map<$core.int, RestructureType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RestructureType? valueOf($core.int value) => _byValue[value];

  const RestructureType._($core.int v, $core.String n) : super(v, n);
}

/// ReconciliationStatus defines the status of a payment reconciliation.
class ReconciliationStatus extends $pb.ProtobufEnum {
  static const ReconciliationStatus RECONCILIATION_STATUS_UNSPECIFIED = ReconciliationStatus._(0, _omitEnumNames ? '' : 'RECONCILIATION_STATUS_UNSPECIFIED');
  static const ReconciliationStatus RECONCILIATION_STATUS_PENDING = ReconciliationStatus._(1, _omitEnumNames ? '' : 'RECONCILIATION_STATUS_PENDING');
  static const ReconciliationStatus RECONCILIATION_STATUS_MATCHED = ReconciliationStatus._(2, _omitEnumNames ? '' : 'RECONCILIATION_STATUS_MATCHED');
  static const ReconciliationStatus RECONCILIATION_STATUS_UNMATCHED = ReconciliationStatus._(3, _omitEnumNames ? '' : 'RECONCILIATION_STATUS_UNMATCHED');
  static const ReconciliationStatus RECONCILIATION_STATUS_DISPUTED = ReconciliationStatus._(4, _omitEnumNames ? '' : 'RECONCILIATION_STATUS_DISPUTED');

  static const $core.List<ReconciliationStatus> values = <ReconciliationStatus> [
    RECONCILIATION_STATUS_UNSPECIFIED,
    RECONCILIATION_STATUS_PENDING,
    RECONCILIATION_STATUS_MATCHED,
    RECONCILIATION_STATUS_UNMATCHED,
    RECONCILIATION_STATUS_DISPUTED,
  ];

  static final $core.Map<$core.int, ReconciliationStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ReconciliationStatus? valueOf($core.int value) => _byValue[value];

  const ReconciliationStatus._($core.int v, $core.String n) : super(v, n);
}

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

/// LoanRequestStatus defines the current stage of a loan request.
class LoanRequestStatus extends $pb.ProtobufEnum {
  static const LoanRequestStatus LOAN_REQUEST_STATUS_UNSPECIFIED = LoanRequestStatus._(0, _omitEnumNames ? '' : 'LOAN_REQUEST_STATUS_UNSPECIFIED');
  static const LoanRequestStatus LOAN_REQUEST_STATUS_DRAFT = LoanRequestStatus._(1, _omitEnumNames ? '' : 'LOAN_REQUEST_STATUS_DRAFT');
  static const LoanRequestStatus LOAN_REQUEST_STATUS_SUBMITTED = LoanRequestStatus._(2, _omitEnumNames ? '' : 'LOAN_REQUEST_STATUS_SUBMITTED');
  static const LoanRequestStatus LOAN_REQUEST_STATUS_APPROVED = LoanRequestStatus._(3, _omitEnumNames ? '' : 'LOAN_REQUEST_STATUS_APPROVED');
  static const LoanRequestStatus LOAN_REQUEST_STATUS_REJECTED = LoanRequestStatus._(4, _omitEnumNames ? '' : 'LOAN_REQUEST_STATUS_REJECTED');
  static const LoanRequestStatus LOAN_REQUEST_STATUS_CANCELLED = LoanRequestStatus._(5, _omitEnumNames ? '' : 'LOAN_REQUEST_STATUS_CANCELLED');
  static const LoanRequestStatus LOAN_REQUEST_STATUS_EXPIRED = LoanRequestStatus._(6, _omitEnumNames ? '' : 'LOAN_REQUEST_STATUS_EXPIRED');
  static const LoanRequestStatus LOAN_REQUEST_STATUS_LOAN_CREATED = LoanRequestStatus._(7, _omitEnumNames ? '' : 'LOAN_REQUEST_STATUS_LOAN_CREATED');

  static const $core.List<LoanRequestStatus> values = <LoanRequestStatus> [
    LOAN_REQUEST_STATUS_UNSPECIFIED,
    LOAN_REQUEST_STATUS_DRAFT,
    LOAN_REQUEST_STATUS_SUBMITTED,
    LOAN_REQUEST_STATUS_APPROVED,
    LOAN_REQUEST_STATUS_REJECTED,
    LOAN_REQUEST_STATUS_CANCELLED,
    LOAN_REQUEST_STATUS_EXPIRED,
    LOAN_REQUEST_STATUS_LOAN_CREATED,
  ];

  static final $core.Map<$core.int, LoanRequestStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static LoanRequestStatus? valueOf($core.int value) => _byValue[value];

  const LoanRequestStatus._($core.int v, $core.String n) : super(v, n);
}

/// InterestMethod defines how interest is calculated on a loan.
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


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
