//
//  Generated code. Do not modify.
//  source: loans/v1/loans.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../common/v1/common.pb.dart' as $7;
import '../../common/v1/common.pbenum.dart' as $7;
import '../../google/protobuf/struct.pb.dart' as $6;
import '../../google/type/money.pb.dart' as $9;
import 'loans.pbenum.dart';

export 'loans.pbenum.dart';

/// LoanAccountObject represents an active loan linked to a client and origination application.
class LoanAccountObject extends $pb.GeneratedMessage {
  factory LoanAccountObject({
    $core.String? id,
    $core.String? applicationId,
    $core.String? productId,
    $core.String? clientId,
    $core.String? agentId,
    $core.String? branchId,
    $core.String? organizationId,
    LoanStatus? status,
    $9.Money? principalAmount,
    $core.String? interestRate,
    $core.int? termDays,
    InterestMethod? interestMethod,
    RepaymentFrequency? repaymentFrequency,
    $core.String? disbursedAt,
    $core.String? maturityDate,
    $core.String? firstRepaymentDate,
    $core.String? lastRepaymentDate,
    $core.int? daysPastDue,
    $core.String? ledgerAssetAccountId,
    $core.String? ledgerInterestIncomeAccountId,
    $core.String? ledgerFeeIncomeAccountId,
    $core.String? ledgerPenaltyIncomeAccountId,
    $core.String? paymentAccountRef,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (applicationId != null) {
      $result.applicationId = applicationId;
    }
    if (productId != null) {
      $result.productId = productId;
    }
    if (clientId != null) {
      $result.clientId = clientId;
    }
    if (agentId != null) {
      $result.agentId = agentId;
    }
    if (branchId != null) {
      $result.branchId = branchId;
    }
    if (organizationId != null) {
      $result.organizationId = organizationId;
    }
    if (status != null) {
      $result.status = status;
    }
    if (principalAmount != null) {
      $result.principalAmount = principalAmount;
    }
    if (interestRate != null) {
      $result.interestRate = interestRate;
    }
    if (termDays != null) {
      $result.termDays = termDays;
    }
    if (interestMethod != null) {
      $result.interestMethod = interestMethod;
    }
    if (repaymentFrequency != null) {
      $result.repaymentFrequency = repaymentFrequency;
    }
    if (disbursedAt != null) {
      $result.disbursedAt = disbursedAt;
    }
    if (maturityDate != null) {
      $result.maturityDate = maturityDate;
    }
    if (firstRepaymentDate != null) {
      $result.firstRepaymentDate = firstRepaymentDate;
    }
    if (lastRepaymentDate != null) {
      $result.lastRepaymentDate = lastRepaymentDate;
    }
    if (daysPastDue != null) {
      $result.daysPastDue = daysPastDue;
    }
    if (ledgerAssetAccountId != null) {
      $result.ledgerAssetAccountId = ledgerAssetAccountId;
    }
    if (ledgerInterestIncomeAccountId != null) {
      $result.ledgerInterestIncomeAccountId = ledgerInterestIncomeAccountId;
    }
    if (ledgerFeeIncomeAccountId != null) {
      $result.ledgerFeeIncomeAccountId = ledgerFeeIncomeAccountId;
    }
    if (ledgerPenaltyIncomeAccountId != null) {
      $result.ledgerPenaltyIncomeAccountId = ledgerPenaltyIncomeAccountId;
    }
    if (paymentAccountRef != null) {
      $result.paymentAccountRef = paymentAccountRef;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  LoanAccountObject._() : super();
  factory LoanAccountObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanAccountObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanAccountObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'applicationId')
    ..aOS(3, _omitFieldNames ? '' : 'productId')
    ..aOS(4, _omitFieldNames ? '' : 'clientId')
    ..aOS(5, _omitFieldNames ? '' : 'agentId')
    ..aOS(6, _omitFieldNames ? '' : 'branchId')
    ..aOS(7, _omitFieldNames ? '' : 'organizationId')
    ..e<LoanStatus>(8, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: LoanStatus.LOAN_STATUS_UNSPECIFIED, valueOf: LoanStatus.valueOf, enumValues: LoanStatus.values)
    ..aOM<$9.Money>(10, _omitFieldNames ? '' : 'principalAmount', subBuilder: $9.Money.create)
    ..aOS(11, _omitFieldNames ? '' : 'interestRate')
    ..a<$core.int>(12, _omitFieldNames ? '' : 'termDays', $pb.PbFieldType.O3)
    ..e<InterestMethod>(13, _omitFieldNames ? '' : 'interestMethod', $pb.PbFieldType.OE, defaultOrMaker: InterestMethod.INTEREST_METHOD_UNSPECIFIED, valueOf: InterestMethod.valueOf, enumValues: InterestMethod.values)
    ..e<RepaymentFrequency>(14, _omitFieldNames ? '' : 'repaymentFrequency', $pb.PbFieldType.OE, defaultOrMaker: RepaymentFrequency.REPAYMENT_FREQUENCY_UNSPECIFIED, valueOf: RepaymentFrequency.valueOf, enumValues: RepaymentFrequency.values)
    ..aOS(15, _omitFieldNames ? '' : 'disbursedAt')
    ..aOS(16, _omitFieldNames ? '' : 'maturityDate')
    ..aOS(17, _omitFieldNames ? '' : 'firstRepaymentDate')
    ..aOS(18, _omitFieldNames ? '' : 'lastRepaymentDate')
    ..a<$core.int>(19, _omitFieldNames ? '' : 'daysPastDue', $pb.PbFieldType.O3)
    ..aOS(20, _omitFieldNames ? '' : 'ledgerAssetAccountId')
    ..aOS(21, _omitFieldNames ? '' : 'ledgerInterestIncomeAccountId')
    ..aOS(22, _omitFieldNames ? '' : 'ledgerFeeIncomeAccountId')
    ..aOS(23, _omitFieldNames ? '' : 'ledgerPenaltyIncomeAccountId')
    ..aOS(24, _omitFieldNames ? '' : 'paymentAccountRef')
    ..aOM<$6.Struct>(25, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanAccountObject clone() => LoanAccountObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanAccountObject copyWith(void Function(LoanAccountObject) updates) => super.copyWith((message) => updates(message as LoanAccountObject)) as LoanAccountObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanAccountObject create() => LoanAccountObject._();
  LoanAccountObject createEmptyInstance() => create();
  static $pb.PbList<LoanAccountObject> createRepeated() => $pb.PbList<LoanAccountObject>();
  @$core.pragma('dart2js:noInline')
  static LoanAccountObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanAccountObject>(create);
  static LoanAccountObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get applicationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set applicationId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasApplicationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearApplicationId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get productId => $_getSZ(2);
  @$pb.TagNumber(3)
  set productId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasProductId() => $_has(2);
  @$pb.TagNumber(3)
  void clearProductId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get clientId => $_getSZ(3);
  @$pb.TagNumber(4)
  set clientId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasClientId() => $_has(3);
  @$pb.TagNumber(4)
  void clearClientId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get agentId => $_getSZ(4);
  @$pb.TagNumber(5)
  set agentId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAgentId() => $_has(4);
  @$pb.TagNumber(5)
  void clearAgentId() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get branchId => $_getSZ(5);
  @$pb.TagNumber(6)
  set branchId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasBranchId() => $_has(5);
  @$pb.TagNumber(6)
  void clearBranchId() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get organizationId => $_getSZ(6);
  @$pb.TagNumber(7)
  set organizationId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasOrganizationId() => $_has(6);
  @$pb.TagNumber(7)
  void clearOrganizationId() => clearField(7);

  @$pb.TagNumber(8)
  LoanStatus get status => $_getN(7);
  @$pb.TagNumber(8)
  set status(LoanStatus v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => clearField(8);

  /// Field 9 removed (currency_code now in Money).
  @$pb.TagNumber(10)
  $9.Money get principalAmount => $_getN(8);
  @$pb.TagNumber(10)
  set principalAmount($9.Money v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasPrincipalAmount() => $_has(8);
  @$pb.TagNumber(10)
  void clearPrincipalAmount() => clearField(10);
  @$pb.TagNumber(10)
  $9.Money ensurePrincipalAmount() => $_ensure(8);

  @$pb.TagNumber(11)
  $core.String get interestRate => $_getSZ(9);
  @$pb.TagNumber(11)
  set interestRate($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(11)
  $core.bool hasInterestRate() => $_has(9);
  @$pb.TagNumber(11)
  void clearInterestRate() => clearField(11);

  @$pb.TagNumber(12)
  $core.int get termDays => $_getIZ(10);
  @$pb.TagNumber(12)
  set termDays($core.int v) { $_setSignedInt32(10, v); }
  @$pb.TagNumber(12)
  $core.bool hasTermDays() => $_has(10);
  @$pb.TagNumber(12)
  void clearTermDays() => clearField(12);

  @$pb.TagNumber(13)
  InterestMethod get interestMethod => $_getN(11);
  @$pb.TagNumber(13)
  set interestMethod(InterestMethod v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasInterestMethod() => $_has(11);
  @$pb.TagNumber(13)
  void clearInterestMethod() => clearField(13);

  @$pb.TagNumber(14)
  RepaymentFrequency get repaymentFrequency => $_getN(12);
  @$pb.TagNumber(14)
  set repaymentFrequency(RepaymentFrequency v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasRepaymentFrequency() => $_has(12);
  @$pb.TagNumber(14)
  void clearRepaymentFrequency() => clearField(14);

  @$pb.TagNumber(15)
  $core.String get disbursedAt => $_getSZ(13);
  @$pb.TagNumber(15)
  set disbursedAt($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(15)
  $core.bool hasDisbursedAt() => $_has(13);
  @$pb.TagNumber(15)
  void clearDisbursedAt() => clearField(15);

  @$pb.TagNumber(16)
  $core.String get maturityDate => $_getSZ(14);
  @$pb.TagNumber(16)
  set maturityDate($core.String v) { $_setString(14, v); }
  @$pb.TagNumber(16)
  $core.bool hasMaturityDate() => $_has(14);
  @$pb.TagNumber(16)
  void clearMaturityDate() => clearField(16);

  @$pb.TagNumber(17)
  $core.String get firstRepaymentDate => $_getSZ(15);
  @$pb.TagNumber(17)
  set firstRepaymentDate($core.String v) { $_setString(15, v); }
  @$pb.TagNumber(17)
  $core.bool hasFirstRepaymentDate() => $_has(15);
  @$pb.TagNumber(17)
  void clearFirstRepaymentDate() => clearField(17);

  @$pb.TagNumber(18)
  $core.String get lastRepaymentDate => $_getSZ(16);
  @$pb.TagNumber(18)
  set lastRepaymentDate($core.String v) { $_setString(16, v); }
  @$pb.TagNumber(18)
  $core.bool hasLastRepaymentDate() => $_has(16);
  @$pb.TagNumber(18)
  void clearLastRepaymentDate() => clearField(18);

  @$pb.TagNumber(19)
  $core.int get daysPastDue => $_getIZ(17);
  @$pb.TagNumber(19)
  set daysPastDue($core.int v) { $_setSignedInt32(17, v); }
  @$pb.TagNumber(19)
  $core.bool hasDaysPastDue() => $_has(17);
  @$pb.TagNumber(19)
  void clearDaysPastDue() => clearField(19);

  @$pb.TagNumber(20)
  $core.String get ledgerAssetAccountId => $_getSZ(18);
  @$pb.TagNumber(20)
  set ledgerAssetAccountId($core.String v) { $_setString(18, v); }
  @$pb.TagNumber(20)
  $core.bool hasLedgerAssetAccountId() => $_has(18);
  @$pb.TagNumber(20)
  void clearLedgerAssetAccountId() => clearField(20);

  @$pb.TagNumber(21)
  $core.String get ledgerInterestIncomeAccountId => $_getSZ(19);
  @$pb.TagNumber(21)
  set ledgerInterestIncomeAccountId($core.String v) { $_setString(19, v); }
  @$pb.TagNumber(21)
  $core.bool hasLedgerInterestIncomeAccountId() => $_has(19);
  @$pb.TagNumber(21)
  void clearLedgerInterestIncomeAccountId() => clearField(21);

  @$pb.TagNumber(22)
  $core.String get ledgerFeeIncomeAccountId => $_getSZ(20);
  @$pb.TagNumber(22)
  set ledgerFeeIncomeAccountId($core.String v) { $_setString(20, v); }
  @$pb.TagNumber(22)
  $core.bool hasLedgerFeeIncomeAccountId() => $_has(20);
  @$pb.TagNumber(22)
  void clearLedgerFeeIncomeAccountId() => clearField(22);

  @$pb.TagNumber(23)
  $core.String get ledgerPenaltyIncomeAccountId => $_getSZ(21);
  @$pb.TagNumber(23)
  set ledgerPenaltyIncomeAccountId($core.String v) { $_setString(21, v); }
  @$pb.TagNumber(23)
  $core.bool hasLedgerPenaltyIncomeAccountId() => $_has(21);
  @$pb.TagNumber(23)
  void clearLedgerPenaltyIncomeAccountId() => clearField(23);

  @$pb.TagNumber(24)
  $core.String get paymentAccountRef => $_getSZ(22);
  @$pb.TagNumber(24)
  set paymentAccountRef($core.String v) { $_setString(22, v); }
  @$pb.TagNumber(24)
  $core.bool hasPaymentAccountRef() => $_has(22);
  @$pb.TagNumber(24)
  void clearPaymentAccountRef() => clearField(24);

  @$pb.TagNumber(25)
  $6.Struct get properties => $_getN(23);
  @$pb.TagNumber(25)
  set properties($6.Struct v) { setField(25, v); }
  @$pb.TagNumber(25)
  $core.bool hasProperties() => $_has(23);
  @$pb.TagNumber(25)
  void clearProperties() => clearField(25);
  @$pb.TagNumber(25)
  $6.Struct ensureProperties() => $_ensure(23);
}

/// RepaymentScheduleObject represents an amortization schedule for a loan.
class RepaymentScheduleObject extends $pb.GeneratedMessage {
  factory RepaymentScheduleObject({
    $core.String? id,
    $core.String? loanAccountId,
    $core.int? version,
    $core.bool? isActive,
    $core.String? generatedAt,
    $core.Iterable<ScheduleEntryObject>? entries,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (version != null) {
      $result.version = version;
    }
    if (isActive != null) {
      $result.isActive = isActive;
    }
    if (generatedAt != null) {
      $result.generatedAt = generatedAt;
    }
    if (entries != null) {
      $result.entries.addAll(entries);
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  RepaymentScheduleObject._() : super();
  factory RepaymentScheduleObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RepaymentScheduleObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RepaymentScheduleObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'loanAccountId')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'version', $pb.PbFieldType.O3)
    ..aOB(4, _omitFieldNames ? '' : 'isActive')
    ..aOS(5, _omitFieldNames ? '' : 'generatedAt')
    ..pc<ScheduleEntryObject>(6, _omitFieldNames ? '' : 'entries', $pb.PbFieldType.PM, subBuilder: ScheduleEntryObject.create)
    ..aOM<$6.Struct>(7, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RepaymentScheduleObject clone() => RepaymentScheduleObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RepaymentScheduleObject copyWith(void Function(RepaymentScheduleObject) updates) => super.copyWith((message) => updates(message as RepaymentScheduleObject)) as RepaymentScheduleObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RepaymentScheduleObject create() => RepaymentScheduleObject._();
  RepaymentScheduleObject createEmptyInstance() => create();
  static $pb.PbList<RepaymentScheduleObject> createRepeated() => $pb.PbList<RepaymentScheduleObject>();
  @$core.pragma('dart2js:noInline')
  static RepaymentScheduleObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RepaymentScheduleObject>(create);
  static RepaymentScheduleObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get loanAccountId => $_getSZ(1);
  @$pb.TagNumber(2)
  set loanAccountId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLoanAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLoanAccountId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get version => $_getIZ(2);
  @$pb.TagNumber(3)
  set version($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isActive => $_getBF(3);
  @$pb.TagNumber(4)
  set isActive($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIsActive() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsActive() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get generatedAt => $_getSZ(4);
  @$pb.TagNumber(5)
  set generatedAt($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasGeneratedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearGeneratedAt() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<ScheduleEntryObject> get entries => $_getList(5);

  @$pb.TagNumber(7)
  $6.Struct get properties => $_getN(6);
  @$pb.TagNumber(7)
  set properties($6.Struct v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasProperties() => $_has(6);
  @$pb.TagNumber(7)
  void clearProperties() => clearField(7);
  @$pb.TagNumber(7)
  $6.Struct ensureProperties() => $_ensure(6);
}

/// ScheduleEntryObject represents an individual installment in a repayment schedule.
class ScheduleEntryObject extends $pb.GeneratedMessage {
  factory ScheduleEntryObject({
    $core.String? id,
    $core.String? scheduleId,
    $core.int? installmentNumber,
    $core.String? dueDate,
    $9.Money? principalDue,
    $9.Money? interestDue,
    $9.Money? feesDue,
    $9.Money? totalDue,
    $9.Money? principalPaid,
    $9.Money? interestPaid,
    $9.Money? feesPaid,
    $9.Money? totalPaid,
    $9.Money? outstanding,
    ScheduleEntryStatus? status,
    $core.String? paidDate,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (scheduleId != null) {
      $result.scheduleId = scheduleId;
    }
    if (installmentNumber != null) {
      $result.installmentNumber = installmentNumber;
    }
    if (dueDate != null) {
      $result.dueDate = dueDate;
    }
    if (principalDue != null) {
      $result.principalDue = principalDue;
    }
    if (interestDue != null) {
      $result.interestDue = interestDue;
    }
    if (feesDue != null) {
      $result.feesDue = feesDue;
    }
    if (totalDue != null) {
      $result.totalDue = totalDue;
    }
    if (principalPaid != null) {
      $result.principalPaid = principalPaid;
    }
    if (interestPaid != null) {
      $result.interestPaid = interestPaid;
    }
    if (feesPaid != null) {
      $result.feesPaid = feesPaid;
    }
    if (totalPaid != null) {
      $result.totalPaid = totalPaid;
    }
    if (outstanding != null) {
      $result.outstanding = outstanding;
    }
    if (status != null) {
      $result.status = status;
    }
    if (paidDate != null) {
      $result.paidDate = paidDate;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  ScheduleEntryObject._() : super();
  factory ScheduleEntryObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScheduleEntryObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ScheduleEntryObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'scheduleId')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'installmentNumber', $pb.PbFieldType.O3)
    ..aOS(4, _omitFieldNames ? '' : 'dueDate')
    ..aOM<$9.Money>(5, _omitFieldNames ? '' : 'principalDue', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(6, _omitFieldNames ? '' : 'interestDue', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(7, _omitFieldNames ? '' : 'feesDue', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(8, _omitFieldNames ? '' : 'totalDue', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(9, _omitFieldNames ? '' : 'principalPaid', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(10, _omitFieldNames ? '' : 'interestPaid', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(11, _omitFieldNames ? '' : 'feesPaid', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(12, _omitFieldNames ? '' : 'totalPaid', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(13, _omitFieldNames ? '' : 'outstanding', subBuilder: $9.Money.create)
    ..e<ScheduleEntryStatus>(14, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: ScheduleEntryStatus.SCHEDULE_ENTRY_STATUS_UNSPECIFIED, valueOf: ScheduleEntryStatus.valueOf, enumValues: ScheduleEntryStatus.values)
    ..aOS(15, _omitFieldNames ? '' : 'paidDate')
    ..aOM<$6.Struct>(16, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScheduleEntryObject clone() => ScheduleEntryObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScheduleEntryObject copyWith(void Function(ScheduleEntryObject) updates) => super.copyWith((message) => updates(message as ScheduleEntryObject)) as ScheduleEntryObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduleEntryObject create() => ScheduleEntryObject._();
  ScheduleEntryObject createEmptyInstance() => create();
  static $pb.PbList<ScheduleEntryObject> createRepeated() => $pb.PbList<ScheduleEntryObject>();
  @$core.pragma('dart2js:noInline')
  static ScheduleEntryObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScheduleEntryObject>(create);
  static ScheduleEntryObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get scheduleId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scheduleId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasScheduleId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScheduleId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get installmentNumber => $_getIZ(2);
  @$pb.TagNumber(3)
  set installmentNumber($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasInstallmentNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearInstallmentNumber() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get dueDate => $_getSZ(3);
  @$pb.TagNumber(4)
  set dueDate($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDueDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearDueDate() => clearField(4);

  @$pb.TagNumber(5)
  $9.Money get principalDue => $_getN(4);
  @$pb.TagNumber(5)
  set principalDue($9.Money v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasPrincipalDue() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrincipalDue() => clearField(5);
  @$pb.TagNumber(5)
  $9.Money ensurePrincipalDue() => $_ensure(4);

  @$pb.TagNumber(6)
  $9.Money get interestDue => $_getN(5);
  @$pb.TagNumber(6)
  set interestDue($9.Money v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasInterestDue() => $_has(5);
  @$pb.TagNumber(6)
  void clearInterestDue() => clearField(6);
  @$pb.TagNumber(6)
  $9.Money ensureInterestDue() => $_ensure(5);

  @$pb.TagNumber(7)
  $9.Money get feesDue => $_getN(6);
  @$pb.TagNumber(7)
  set feesDue($9.Money v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasFeesDue() => $_has(6);
  @$pb.TagNumber(7)
  void clearFeesDue() => clearField(7);
  @$pb.TagNumber(7)
  $9.Money ensureFeesDue() => $_ensure(6);

  @$pb.TagNumber(8)
  $9.Money get totalDue => $_getN(7);
  @$pb.TagNumber(8)
  set totalDue($9.Money v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasTotalDue() => $_has(7);
  @$pb.TagNumber(8)
  void clearTotalDue() => clearField(8);
  @$pb.TagNumber(8)
  $9.Money ensureTotalDue() => $_ensure(7);

  @$pb.TagNumber(9)
  $9.Money get principalPaid => $_getN(8);
  @$pb.TagNumber(9)
  set principalPaid($9.Money v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasPrincipalPaid() => $_has(8);
  @$pb.TagNumber(9)
  void clearPrincipalPaid() => clearField(9);
  @$pb.TagNumber(9)
  $9.Money ensurePrincipalPaid() => $_ensure(8);

  @$pb.TagNumber(10)
  $9.Money get interestPaid => $_getN(9);
  @$pb.TagNumber(10)
  set interestPaid($9.Money v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasInterestPaid() => $_has(9);
  @$pb.TagNumber(10)
  void clearInterestPaid() => clearField(10);
  @$pb.TagNumber(10)
  $9.Money ensureInterestPaid() => $_ensure(9);

  @$pb.TagNumber(11)
  $9.Money get feesPaid => $_getN(10);
  @$pb.TagNumber(11)
  set feesPaid($9.Money v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasFeesPaid() => $_has(10);
  @$pb.TagNumber(11)
  void clearFeesPaid() => clearField(11);
  @$pb.TagNumber(11)
  $9.Money ensureFeesPaid() => $_ensure(10);

  @$pb.TagNumber(12)
  $9.Money get totalPaid => $_getN(11);
  @$pb.TagNumber(12)
  set totalPaid($9.Money v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasTotalPaid() => $_has(11);
  @$pb.TagNumber(12)
  void clearTotalPaid() => clearField(12);
  @$pb.TagNumber(12)
  $9.Money ensureTotalPaid() => $_ensure(11);

  @$pb.TagNumber(13)
  $9.Money get outstanding => $_getN(12);
  @$pb.TagNumber(13)
  set outstanding($9.Money v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasOutstanding() => $_has(12);
  @$pb.TagNumber(13)
  void clearOutstanding() => clearField(13);
  @$pb.TagNumber(13)
  $9.Money ensureOutstanding() => $_ensure(12);

  @$pb.TagNumber(14)
  ScheduleEntryStatus get status => $_getN(13);
  @$pb.TagNumber(14)
  set status(ScheduleEntryStatus v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasStatus() => $_has(13);
  @$pb.TagNumber(14)
  void clearStatus() => clearField(14);

  @$pb.TagNumber(15)
  $core.String get paidDate => $_getSZ(14);
  @$pb.TagNumber(15)
  set paidDate($core.String v) { $_setString(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasPaidDate() => $_has(14);
  @$pb.TagNumber(15)
  void clearPaidDate() => clearField(15);

  @$pb.TagNumber(16)
  $6.Struct get properties => $_getN(15);
  @$pb.TagNumber(16)
  set properties($6.Struct v) { setField(16, v); }
  @$pb.TagNumber(16)
  $core.bool hasProperties() => $_has(15);
  @$pb.TagNumber(16)
  void clearProperties() => clearField(16);
  @$pb.TagNumber(16)
  $6.Struct ensureProperties() => $_ensure(15);
}

/// LoanBalanceObject represents the current balance snapshot of a loan.
class LoanBalanceObject extends $pb.GeneratedMessage {
  factory LoanBalanceObject({
    $core.String? loanAccountId,
    $9.Money? principalOutstanding,
    $9.Money? interestAccrued,
    $9.Money? feesOutstanding,
    $9.Money? penaltiesOutstanding,
    $9.Money? totalOutstanding,
    $9.Money? totalPaid,
    $9.Money? totalDisbursed,
    $core.String? lastCalculatedAt,
  }) {
    final $result = create();
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (principalOutstanding != null) {
      $result.principalOutstanding = principalOutstanding;
    }
    if (interestAccrued != null) {
      $result.interestAccrued = interestAccrued;
    }
    if (feesOutstanding != null) {
      $result.feesOutstanding = feesOutstanding;
    }
    if (penaltiesOutstanding != null) {
      $result.penaltiesOutstanding = penaltiesOutstanding;
    }
    if (totalOutstanding != null) {
      $result.totalOutstanding = totalOutstanding;
    }
    if (totalPaid != null) {
      $result.totalPaid = totalPaid;
    }
    if (totalDisbursed != null) {
      $result.totalDisbursed = totalDisbursed;
    }
    if (lastCalculatedAt != null) {
      $result.lastCalculatedAt = lastCalculatedAt;
    }
    return $result;
  }
  LoanBalanceObject._() : super();
  factory LoanBalanceObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanBalanceObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanBalanceObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'loanAccountId')
    ..aOM<$9.Money>(2, _omitFieldNames ? '' : 'principalOutstanding', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(3, _omitFieldNames ? '' : 'interestAccrued', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(4, _omitFieldNames ? '' : 'feesOutstanding', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(5, _omitFieldNames ? '' : 'penaltiesOutstanding', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(6, _omitFieldNames ? '' : 'totalOutstanding', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(7, _omitFieldNames ? '' : 'totalPaid', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(8, _omitFieldNames ? '' : 'totalDisbursed', subBuilder: $9.Money.create)
    ..aOS(9, _omitFieldNames ? '' : 'lastCalculatedAt')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanBalanceObject clone() => LoanBalanceObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanBalanceObject copyWith(void Function(LoanBalanceObject) updates) => super.copyWith((message) => updates(message as LoanBalanceObject)) as LoanBalanceObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanBalanceObject create() => LoanBalanceObject._();
  LoanBalanceObject createEmptyInstance() => create();
  static $pb.PbList<LoanBalanceObject> createRepeated() => $pb.PbList<LoanBalanceObject>();
  @$core.pragma('dart2js:noInline')
  static LoanBalanceObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanBalanceObject>(create);
  static LoanBalanceObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get loanAccountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set loanAccountId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLoanAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoanAccountId() => clearField(1);

  @$pb.TagNumber(2)
  $9.Money get principalOutstanding => $_getN(1);
  @$pb.TagNumber(2)
  set principalOutstanding($9.Money v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPrincipalOutstanding() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrincipalOutstanding() => clearField(2);
  @$pb.TagNumber(2)
  $9.Money ensurePrincipalOutstanding() => $_ensure(1);

  @$pb.TagNumber(3)
  $9.Money get interestAccrued => $_getN(2);
  @$pb.TagNumber(3)
  set interestAccrued($9.Money v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasInterestAccrued() => $_has(2);
  @$pb.TagNumber(3)
  void clearInterestAccrued() => clearField(3);
  @$pb.TagNumber(3)
  $9.Money ensureInterestAccrued() => $_ensure(2);

  @$pb.TagNumber(4)
  $9.Money get feesOutstanding => $_getN(3);
  @$pb.TagNumber(4)
  set feesOutstanding($9.Money v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasFeesOutstanding() => $_has(3);
  @$pb.TagNumber(4)
  void clearFeesOutstanding() => clearField(4);
  @$pb.TagNumber(4)
  $9.Money ensureFeesOutstanding() => $_ensure(3);

  @$pb.TagNumber(5)
  $9.Money get penaltiesOutstanding => $_getN(4);
  @$pb.TagNumber(5)
  set penaltiesOutstanding($9.Money v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasPenaltiesOutstanding() => $_has(4);
  @$pb.TagNumber(5)
  void clearPenaltiesOutstanding() => clearField(5);
  @$pb.TagNumber(5)
  $9.Money ensurePenaltiesOutstanding() => $_ensure(4);

  @$pb.TagNumber(6)
  $9.Money get totalOutstanding => $_getN(5);
  @$pb.TagNumber(6)
  set totalOutstanding($9.Money v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasTotalOutstanding() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalOutstanding() => clearField(6);
  @$pb.TagNumber(6)
  $9.Money ensureTotalOutstanding() => $_ensure(5);

  @$pb.TagNumber(7)
  $9.Money get totalPaid => $_getN(6);
  @$pb.TagNumber(7)
  set totalPaid($9.Money v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasTotalPaid() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalPaid() => clearField(7);
  @$pb.TagNumber(7)
  $9.Money ensureTotalPaid() => $_ensure(6);

  @$pb.TagNumber(8)
  $9.Money get totalDisbursed => $_getN(7);
  @$pb.TagNumber(8)
  set totalDisbursed($9.Money v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasTotalDisbursed() => $_has(7);
  @$pb.TagNumber(8)
  void clearTotalDisbursed() => clearField(8);
  @$pb.TagNumber(8)
  $9.Money ensureTotalDisbursed() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get lastCalculatedAt => $_getSZ(8);
  @$pb.TagNumber(9)
  set lastCalculatedAt($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasLastCalculatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearLastCalculatedAt() => clearField(9);
}

/// DisbursementObject represents a loan amount paid out to the client.
class DisbursementObject extends $pb.GeneratedMessage {
  factory DisbursementObject({
    $core.String? id,
    $core.String? loanAccountId,
    $9.Money? amount,
    DisbursementStatus? status,
    $core.String? paymentReference,
    $core.String? ledgerTransactionId,
    $core.String? disbursedAt,
    $core.String? channel,
    $core.String? recipientReference,
    $core.String? failureReason,
    $core.String? idempotencyKey,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (status != null) {
      $result.status = status;
    }
    if (paymentReference != null) {
      $result.paymentReference = paymentReference;
    }
    if (ledgerTransactionId != null) {
      $result.ledgerTransactionId = ledgerTransactionId;
    }
    if (disbursedAt != null) {
      $result.disbursedAt = disbursedAt;
    }
    if (channel != null) {
      $result.channel = channel;
    }
    if (recipientReference != null) {
      $result.recipientReference = recipientReference;
    }
    if (failureReason != null) {
      $result.failureReason = failureReason;
    }
    if (idempotencyKey != null) {
      $result.idempotencyKey = idempotencyKey;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  DisbursementObject._() : super();
  factory DisbursementObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DisbursementObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DisbursementObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'loanAccountId')
    ..aOM<$9.Money>(3, _omitFieldNames ? '' : 'amount', subBuilder: $9.Money.create)
    ..e<DisbursementStatus>(5, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: DisbursementStatus.DISBURSEMENT_STATUS_UNSPECIFIED, valueOf: DisbursementStatus.valueOf, enumValues: DisbursementStatus.values)
    ..aOS(6, _omitFieldNames ? '' : 'paymentReference')
    ..aOS(7, _omitFieldNames ? '' : 'ledgerTransactionId')
    ..aOS(8, _omitFieldNames ? '' : 'disbursedAt')
    ..aOS(9, _omitFieldNames ? '' : 'channel')
    ..aOS(10, _omitFieldNames ? '' : 'recipientReference')
    ..aOS(11, _omitFieldNames ? '' : 'failureReason')
    ..aOS(12, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOM<$6.Struct>(13, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DisbursementObject clone() => DisbursementObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DisbursementObject copyWith(void Function(DisbursementObject) updates) => super.copyWith((message) => updates(message as DisbursementObject)) as DisbursementObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisbursementObject create() => DisbursementObject._();
  DisbursementObject createEmptyInstance() => create();
  static $pb.PbList<DisbursementObject> createRepeated() => $pb.PbList<DisbursementObject>();
  @$core.pragma('dart2js:noInline')
  static DisbursementObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DisbursementObject>(create);
  static DisbursementObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get loanAccountId => $_getSZ(1);
  @$pb.TagNumber(2)
  set loanAccountId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLoanAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLoanAccountId() => clearField(2);

  @$pb.TagNumber(3)
  $9.Money get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($9.Money v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);
  @$pb.TagNumber(3)
  $9.Money ensureAmount() => $_ensure(2);

  /// Field 4 removed (currency_code now in Money).
  @$pb.TagNumber(5)
  DisbursementStatus get status => $_getN(3);
  @$pb.TagNumber(5)
  set status(DisbursementStatus v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(5)
  void clearStatus() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get paymentReference => $_getSZ(4);
  @$pb.TagNumber(6)
  set paymentReference($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasPaymentReference() => $_has(4);
  @$pb.TagNumber(6)
  void clearPaymentReference() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get ledgerTransactionId => $_getSZ(5);
  @$pb.TagNumber(7)
  set ledgerTransactionId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(7)
  $core.bool hasLedgerTransactionId() => $_has(5);
  @$pb.TagNumber(7)
  void clearLedgerTransactionId() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get disbursedAt => $_getSZ(6);
  @$pb.TagNumber(8)
  set disbursedAt($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(8)
  $core.bool hasDisbursedAt() => $_has(6);
  @$pb.TagNumber(8)
  void clearDisbursedAt() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get channel => $_getSZ(7);
  @$pb.TagNumber(9)
  set channel($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(9)
  $core.bool hasChannel() => $_has(7);
  @$pb.TagNumber(9)
  void clearChannel() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get recipientReference => $_getSZ(8);
  @$pb.TagNumber(10)
  set recipientReference($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(10)
  $core.bool hasRecipientReference() => $_has(8);
  @$pb.TagNumber(10)
  void clearRecipientReference() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get failureReason => $_getSZ(9);
  @$pb.TagNumber(11)
  set failureReason($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(11)
  $core.bool hasFailureReason() => $_has(9);
  @$pb.TagNumber(11)
  void clearFailureReason() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get idempotencyKey => $_getSZ(10);
  @$pb.TagNumber(12)
  set idempotencyKey($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(12)
  $core.bool hasIdempotencyKey() => $_has(10);
  @$pb.TagNumber(12)
  void clearIdempotencyKey() => clearField(12);

  @$pb.TagNumber(13)
  $6.Struct get properties => $_getN(11);
  @$pb.TagNumber(13)
  set properties($6.Struct v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasProperties() => $_has(11);
  @$pb.TagNumber(13)
  void clearProperties() => clearField(13);
  @$pb.TagNumber(13)
  $6.Struct ensureProperties() => $_ensure(11);
}

/// RepaymentObject represents an incoming payment record for a loan.
class RepaymentObject extends $pb.GeneratedMessage {
  factory RepaymentObject({
    $core.String? id,
    $core.String? loanAccountId,
    $9.Money? amount,
    RepaymentStatus? status,
    $core.String? paymentReference,
    $core.String? ledgerTransactionId,
    $core.String? receivedAt,
    $core.String? channel,
    $core.String? payerReference,
    $9.Money? principalApplied,
    $9.Money? interestApplied,
    $9.Money? feesApplied,
    $9.Money? penaltiesApplied,
    $9.Money? excessAmount,
    $core.String? idempotencyKey,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (status != null) {
      $result.status = status;
    }
    if (paymentReference != null) {
      $result.paymentReference = paymentReference;
    }
    if (ledgerTransactionId != null) {
      $result.ledgerTransactionId = ledgerTransactionId;
    }
    if (receivedAt != null) {
      $result.receivedAt = receivedAt;
    }
    if (channel != null) {
      $result.channel = channel;
    }
    if (payerReference != null) {
      $result.payerReference = payerReference;
    }
    if (principalApplied != null) {
      $result.principalApplied = principalApplied;
    }
    if (interestApplied != null) {
      $result.interestApplied = interestApplied;
    }
    if (feesApplied != null) {
      $result.feesApplied = feesApplied;
    }
    if (penaltiesApplied != null) {
      $result.penaltiesApplied = penaltiesApplied;
    }
    if (excessAmount != null) {
      $result.excessAmount = excessAmount;
    }
    if (idempotencyKey != null) {
      $result.idempotencyKey = idempotencyKey;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  RepaymentObject._() : super();
  factory RepaymentObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RepaymentObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RepaymentObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'loanAccountId')
    ..aOM<$9.Money>(3, _omitFieldNames ? '' : 'amount', subBuilder: $9.Money.create)
    ..e<RepaymentStatus>(5, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: RepaymentStatus.REPAYMENT_STATUS_UNSPECIFIED, valueOf: RepaymentStatus.valueOf, enumValues: RepaymentStatus.values)
    ..aOS(6, _omitFieldNames ? '' : 'paymentReference')
    ..aOS(7, _omitFieldNames ? '' : 'ledgerTransactionId')
    ..aOS(8, _omitFieldNames ? '' : 'receivedAt')
    ..aOS(9, _omitFieldNames ? '' : 'channel')
    ..aOS(10, _omitFieldNames ? '' : 'payerReference')
    ..aOM<$9.Money>(11, _omitFieldNames ? '' : 'principalApplied', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(12, _omitFieldNames ? '' : 'interestApplied', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(13, _omitFieldNames ? '' : 'feesApplied', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(14, _omitFieldNames ? '' : 'penaltiesApplied', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(15, _omitFieldNames ? '' : 'excessAmount', subBuilder: $9.Money.create)
    ..aOS(16, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOM<$6.Struct>(17, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RepaymentObject clone() => RepaymentObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RepaymentObject copyWith(void Function(RepaymentObject) updates) => super.copyWith((message) => updates(message as RepaymentObject)) as RepaymentObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RepaymentObject create() => RepaymentObject._();
  RepaymentObject createEmptyInstance() => create();
  static $pb.PbList<RepaymentObject> createRepeated() => $pb.PbList<RepaymentObject>();
  @$core.pragma('dart2js:noInline')
  static RepaymentObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RepaymentObject>(create);
  static RepaymentObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get loanAccountId => $_getSZ(1);
  @$pb.TagNumber(2)
  set loanAccountId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLoanAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLoanAccountId() => clearField(2);

  @$pb.TagNumber(3)
  $9.Money get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($9.Money v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);
  @$pb.TagNumber(3)
  $9.Money ensureAmount() => $_ensure(2);

  /// Field 4 removed (currency_code now in Money).
  @$pb.TagNumber(5)
  RepaymentStatus get status => $_getN(3);
  @$pb.TagNumber(5)
  set status(RepaymentStatus v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(5)
  void clearStatus() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get paymentReference => $_getSZ(4);
  @$pb.TagNumber(6)
  set paymentReference($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasPaymentReference() => $_has(4);
  @$pb.TagNumber(6)
  void clearPaymentReference() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get ledgerTransactionId => $_getSZ(5);
  @$pb.TagNumber(7)
  set ledgerTransactionId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(7)
  $core.bool hasLedgerTransactionId() => $_has(5);
  @$pb.TagNumber(7)
  void clearLedgerTransactionId() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get receivedAt => $_getSZ(6);
  @$pb.TagNumber(8)
  set receivedAt($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(8)
  $core.bool hasReceivedAt() => $_has(6);
  @$pb.TagNumber(8)
  void clearReceivedAt() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get channel => $_getSZ(7);
  @$pb.TagNumber(9)
  set channel($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(9)
  $core.bool hasChannel() => $_has(7);
  @$pb.TagNumber(9)
  void clearChannel() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get payerReference => $_getSZ(8);
  @$pb.TagNumber(10)
  set payerReference($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(10)
  $core.bool hasPayerReference() => $_has(8);
  @$pb.TagNumber(10)
  void clearPayerReference() => clearField(10);

  @$pb.TagNumber(11)
  $9.Money get principalApplied => $_getN(9);
  @$pb.TagNumber(11)
  set principalApplied($9.Money v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasPrincipalApplied() => $_has(9);
  @$pb.TagNumber(11)
  void clearPrincipalApplied() => clearField(11);
  @$pb.TagNumber(11)
  $9.Money ensurePrincipalApplied() => $_ensure(9);

  @$pb.TagNumber(12)
  $9.Money get interestApplied => $_getN(10);
  @$pb.TagNumber(12)
  set interestApplied($9.Money v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasInterestApplied() => $_has(10);
  @$pb.TagNumber(12)
  void clearInterestApplied() => clearField(12);
  @$pb.TagNumber(12)
  $9.Money ensureInterestApplied() => $_ensure(10);

  @$pb.TagNumber(13)
  $9.Money get feesApplied => $_getN(11);
  @$pb.TagNumber(13)
  set feesApplied($9.Money v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasFeesApplied() => $_has(11);
  @$pb.TagNumber(13)
  void clearFeesApplied() => clearField(13);
  @$pb.TagNumber(13)
  $9.Money ensureFeesApplied() => $_ensure(11);

  @$pb.TagNumber(14)
  $9.Money get penaltiesApplied => $_getN(12);
  @$pb.TagNumber(14)
  set penaltiesApplied($9.Money v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasPenaltiesApplied() => $_has(12);
  @$pb.TagNumber(14)
  void clearPenaltiesApplied() => clearField(14);
  @$pb.TagNumber(14)
  $9.Money ensurePenaltiesApplied() => $_ensure(12);

  @$pb.TagNumber(15)
  $9.Money get excessAmount => $_getN(13);
  @$pb.TagNumber(15)
  set excessAmount($9.Money v) { setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasExcessAmount() => $_has(13);
  @$pb.TagNumber(15)
  void clearExcessAmount() => clearField(15);
  @$pb.TagNumber(15)
  $9.Money ensureExcessAmount() => $_ensure(13);

  @$pb.TagNumber(16)
  $core.String get idempotencyKey => $_getSZ(14);
  @$pb.TagNumber(16)
  set idempotencyKey($core.String v) { $_setString(14, v); }
  @$pb.TagNumber(16)
  $core.bool hasIdempotencyKey() => $_has(14);
  @$pb.TagNumber(16)
  void clearIdempotencyKey() => clearField(16);

  @$pb.TagNumber(17)
  $6.Struct get properties => $_getN(15);
  @$pb.TagNumber(17)
  set properties($6.Struct v) { setField(17, v); }
  @$pb.TagNumber(17)
  $core.bool hasProperties() => $_has(15);
  @$pb.TagNumber(17)
  void clearProperties() => clearField(17);
  @$pb.TagNumber(17)
  $6.Struct ensureProperties() => $_ensure(15);
}

/// PenaltyObject represents a penalty applied to a loan.
class PenaltyObject extends $pb.GeneratedMessage {
  factory PenaltyObject({
    $core.String? id,
    $core.String? loanAccountId,
    PenaltyType? penaltyType,
    $9.Money? amount,
    $core.String? reason,
    $core.bool? isWaived,
    $core.String? waivedBy,
    $core.String? waivedReason,
    $core.String? ledgerTransactionId,
    $core.String? appliedAt,
    $core.String? scheduleEntryId,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (penaltyType != null) {
      $result.penaltyType = penaltyType;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    if (isWaived != null) {
      $result.isWaived = isWaived;
    }
    if (waivedBy != null) {
      $result.waivedBy = waivedBy;
    }
    if (waivedReason != null) {
      $result.waivedReason = waivedReason;
    }
    if (ledgerTransactionId != null) {
      $result.ledgerTransactionId = ledgerTransactionId;
    }
    if (appliedAt != null) {
      $result.appliedAt = appliedAt;
    }
    if (scheduleEntryId != null) {
      $result.scheduleEntryId = scheduleEntryId;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  PenaltyObject._() : super();
  factory PenaltyObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PenaltyObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PenaltyObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'loanAccountId')
    ..e<PenaltyType>(3, _omitFieldNames ? '' : 'penaltyType', $pb.PbFieldType.OE, defaultOrMaker: PenaltyType.PENALTY_TYPE_UNSPECIFIED, valueOf: PenaltyType.valueOf, enumValues: PenaltyType.values)
    ..aOM<$9.Money>(4, _omitFieldNames ? '' : 'amount', subBuilder: $9.Money.create)
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aOB(6, _omitFieldNames ? '' : 'isWaived')
    ..aOS(7, _omitFieldNames ? '' : 'waivedBy')
    ..aOS(8, _omitFieldNames ? '' : 'waivedReason')
    ..aOS(9, _omitFieldNames ? '' : 'ledgerTransactionId')
    ..aOS(10, _omitFieldNames ? '' : 'appliedAt')
    ..aOS(11, _omitFieldNames ? '' : 'scheduleEntryId')
    ..aOM<$6.Struct>(12, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PenaltyObject clone() => PenaltyObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PenaltyObject copyWith(void Function(PenaltyObject) updates) => super.copyWith((message) => updates(message as PenaltyObject)) as PenaltyObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PenaltyObject create() => PenaltyObject._();
  PenaltyObject createEmptyInstance() => create();
  static $pb.PbList<PenaltyObject> createRepeated() => $pb.PbList<PenaltyObject>();
  @$core.pragma('dart2js:noInline')
  static PenaltyObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PenaltyObject>(create);
  static PenaltyObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get loanAccountId => $_getSZ(1);
  @$pb.TagNumber(2)
  set loanAccountId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLoanAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLoanAccountId() => clearField(2);

  @$pb.TagNumber(3)
  PenaltyType get penaltyType => $_getN(2);
  @$pb.TagNumber(3)
  set penaltyType(PenaltyType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPenaltyType() => $_has(2);
  @$pb.TagNumber(3)
  void clearPenaltyType() => clearField(3);

  @$pb.TagNumber(4)
  $9.Money get amount => $_getN(3);
  @$pb.TagNumber(4)
  set amount($9.Money v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => clearField(4);
  @$pb.TagNumber(4)
  $9.Money ensureAmount() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isWaived => $_getBF(5);
  @$pb.TagNumber(6)
  set isWaived($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasIsWaived() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsWaived() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get waivedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set waivedBy($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasWaivedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearWaivedBy() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get waivedReason => $_getSZ(7);
  @$pb.TagNumber(8)
  set waivedReason($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasWaivedReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearWaivedReason() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get ledgerTransactionId => $_getSZ(8);
  @$pb.TagNumber(9)
  set ledgerTransactionId($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasLedgerTransactionId() => $_has(8);
  @$pb.TagNumber(9)
  void clearLedgerTransactionId() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get appliedAt => $_getSZ(9);
  @$pb.TagNumber(10)
  set appliedAt($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasAppliedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearAppliedAt() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get scheduleEntryId => $_getSZ(10);
  @$pb.TagNumber(11)
  set scheduleEntryId($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasScheduleEntryId() => $_has(10);
  @$pb.TagNumber(11)
  void clearScheduleEntryId() => clearField(11);

  @$pb.TagNumber(12)
  $6.Struct get properties => $_getN(11);
  @$pb.TagNumber(12)
  set properties($6.Struct v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasProperties() => $_has(11);
  @$pb.TagNumber(12)
  void clearProperties() => clearField(12);
  @$pb.TagNumber(12)
  $6.Struct ensureProperties() => $_ensure(11);
}

/// LoanRestructureObject represents a loan terms modification.
class LoanRestructureObject extends $pb.GeneratedMessage {
  factory LoanRestructureObject({
    $core.String? id,
    $core.String? loanAccountId,
    RestructureType? restructureType,
    $core.String? requestedBy,
    $core.String? approvedBy,
    $core.String? reason,
    $core.String? oldInterestRate,
    $core.String? newInterestRate,
    $core.int? oldTermDays,
    $core.int? newTermDays,
    $9.Money? waivedAmount,
    $core.String? oldScheduleId,
    $core.String? newScheduleId,
    $7.STATE? state,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (restructureType != null) {
      $result.restructureType = restructureType;
    }
    if (requestedBy != null) {
      $result.requestedBy = requestedBy;
    }
    if (approvedBy != null) {
      $result.approvedBy = approvedBy;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    if (oldInterestRate != null) {
      $result.oldInterestRate = oldInterestRate;
    }
    if (newInterestRate != null) {
      $result.newInterestRate = newInterestRate;
    }
    if (oldTermDays != null) {
      $result.oldTermDays = oldTermDays;
    }
    if (newTermDays != null) {
      $result.newTermDays = newTermDays;
    }
    if (waivedAmount != null) {
      $result.waivedAmount = waivedAmount;
    }
    if (oldScheduleId != null) {
      $result.oldScheduleId = oldScheduleId;
    }
    if (newScheduleId != null) {
      $result.newScheduleId = newScheduleId;
    }
    if (state != null) {
      $result.state = state;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  LoanRestructureObject._() : super();
  factory LoanRestructureObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanRestructureObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanRestructureObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'loanAccountId')
    ..e<RestructureType>(3, _omitFieldNames ? '' : 'restructureType', $pb.PbFieldType.OE, defaultOrMaker: RestructureType.RESTRUCTURE_TYPE_UNSPECIFIED, valueOf: RestructureType.valueOf, enumValues: RestructureType.values)
    ..aOS(4, _omitFieldNames ? '' : 'requestedBy')
    ..aOS(5, _omitFieldNames ? '' : 'approvedBy')
    ..aOS(6, _omitFieldNames ? '' : 'reason')
    ..aOS(7, _omitFieldNames ? '' : 'oldInterestRate')
    ..aOS(8, _omitFieldNames ? '' : 'newInterestRate')
    ..a<$core.int>(9, _omitFieldNames ? '' : 'oldTermDays', $pb.PbFieldType.O3)
    ..a<$core.int>(10, _omitFieldNames ? '' : 'newTermDays', $pb.PbFieldType.O3)
    ..aOM<$9.Money>(11, _omitFieldNames ? '' : 'waivedAmount', subBuilder: $9.Money.create)
    ..aOS(12, _omitFieldNames ? '' : 'oldScheduleId')
    ..aOS(13, _omitFieldNames ? '' : 'newScheduleId')
    ..e<$7.STATE>(14, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: $7.STATE.CREATED, valueOf: $7.STATE.valueOf, enumValues: $7.STATE.values)
    ..aOM<$6.Struct>(15, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanRestructureObject clone() => LoanRestructureObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanRestructureObject copyWith(void Function(LoanRestructureObject) updates) => super.copyWith((message) => updates(message as LoanRestructureObject)) as LoanRestructureObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanRestructureObject create() => LoanRestructureObject._();
  LoanRestructureObject createEmptyInstance() => create();
  static $pb.PbList<LoanRestructureObject> createRepeated() => $pb.PbList<LoanRestructureObject>();
  @$core.pragma('dart2js:noInline')
  static LoanRestructureObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanRestructureObject>(create);
  static LoanRestructureObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get loanAccountId => $_getSZ(1);
  @$pb.TagNumber(2)
  set loanAccountId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLoanAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLoanAccountId() => clearField(2);

  @$pb.TagNumber(3)
  RestructureType get restructureType => $_getN(2);
  @$pb.TagNumber(3)
  set restructureType(RestructureType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasRestructureType() => $_has(2);
  @$pb.TagNumber(3)
  void clearRestructureType() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get requestedBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set requestedBy($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRequestedBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearRequestedBy() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get approvedBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set approvedBy($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasApprovedBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearApprovedBy() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get reason => $_getSZ(5);
  @$pb.TagNumber(6)
  set reason($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearReason() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get oldInterestRate => $_getSZ(6);
  @$pb.TagNumber(7)
  set oldInterestRate($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasOldInterestRate() => $_has(6);
  @$pb.TagNumber(7)
  void clearOldInterestRate() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get newInterestRate => $_getSZ(7);
  @$pb.TagNumber(8)
  set newInterestRate($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasNewInterestRate() => $_has(7);
  @$pb.TagNumber(8)
  void clearNewInterestRate() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get oldTermDays => $_getIZ(8);
  @$pb.TagNumber(9)
  set oldTermDays($core.int v) { $_setSignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasOldTermDays() => $_has(8);
  @$pb.TagNumber(9)
  void clearOldTermDays() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get newTermDays => $_getIZ(9);
  @$pb.TagNumber(10)
  set newTermDays($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasNewTermDays() => $_has(9);
  @$pb.TagNumber(10)
  void clearNewTermDays() => clearField(10);

  @$pb.TagNumber(11)
  $9.Money get waivedAmount => $_getN(10);
  @$pb.TagNumber(11)
  set waivedAmount($9.Money v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasWaivedAmount() => $_has(10);
  @$pb.TagNumber(11)
  void clearWaivedAmount() => clearField(11);
  @$pb.TagNumber(11)
  $9.Money ensureWaivedAmount() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get oldScheduleId => $_getSZ(11);
  @$pb.TagNumber(12)
  set oldScheduleId($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasOldScheduleId() => $_has(11);
  @$pb.TagNumber(12)
  void clearOldScheduleId() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get newScheduleId => $_getSZ(12);
  @$pb.TagNumber(13)
  set newScheduleId($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasNewScheduleId() => $_has(12);
  @$pb.TagNumber(13)
  void clearNewScheduleId() => clearField(13);

  @$pb.TagNumber(14)
  $7.STATE get state => $_getN(13);
  @$pb.TagNumber(14)
  set state($7.STATE v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasState() => $_has(13);
  @$pb.TagNumber(14)
  void clearState() => clearField(14);

  @$pb.TagNumber(15)
  $6.Struct get properties => $_getN(14);
  @$pb.TagNumber(15)
  set properties($6.Struct v) { setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasProperties() => $_has(14);
  @$pb.TagNumber(15)
  void clearProperties() => clearField(15);
  @$pb.TagNumber(15)
  $6.Struct ensureProperties() => $_ensure(14);
}

/// LoanStatusChangeObject records a loan status transition for audit.
class LoanStatusChangeObject extends $pb.GeneratedMessage {
  factory LoanStatusChangeObject({
    $core.String? id,
    $core.String? loanAccountId,
    $core.int? fromStatus,
    $core.int? toStatus,
    $core.String? changedBy,
    $core.String? reason,
    $core.String? changedAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (fromStatus != null) {
      $result.fromStatus = fromStatus;
    }
    if (toStatus != null) {
      $result.toStatus = toStatus;
    }
    if (changedBy != null) {
      $result.changedBy = changedBy;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    if (changedAt != null) {
      $result.changedAt = changedAt;
    }
    return $result;
  }
  LoanStatusChangeObject._() : super();
  factory LoanStatusChangeObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanStatusChangeObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanStatusChangeObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'loanAccountId')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'fromStatus', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'toStatus', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'changedBy')
    ..aOS(6, _omitFieldNames ? '' : 'reason')
    ..aOS(7, _omitFieldNames ? '' : 'changedAt')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanStatusChangeObject clone() => LoanStatusChangeObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanStatusChangeObject copyWith(void Function(LoanStatusChangeObject) updates) => super.copyWith((message) => updates(message as LoanStatusChangeObject)) as LoanStatusChangeObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanStatusChangeObject create() => LoanStatusChangeObject._();
  LoanStatusChangeObject createEmptyInstance() => create();
  static $pb.PbList<LoanStatusChangeObject> createRepeated() => $pb.PbList<LoanStatusChangeObject>();
  @$core.pragma('dart2js:noInline')
  static LoanStatusChangeObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanStatusChangeObject>(create);
  static LoanStatusChangeObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get loanAccountId => $_getSZ(1);
  @$pb.TagNumber(2)
  set loanAccountId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLoanAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLoanAccountId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get fromStatus => $_getIZ(2);
  @$pb.TagNumber(3)
  set fromStatus($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFromStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearFromStatus() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get toStatus => $_getIZ(3);
  @$pb.TagNumber(4)
  set toStatus($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasToStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearToStatus() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get changedBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set changedBy($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasChangedBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearChangedBy() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get reason => $_getSZ(5);
  @$pb.TagNumber(6)
  set reason($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearReason() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get changedAt => $_getSZ(6);
  @$pb.TagNumber(7)
  set changedAt($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasChangedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearChangedAt() => clearField(7);
}

/// ReconciliationObject represents a payment reconciliation record.
class ReconciliationObject extends $pb.GeneratedMessage {
  factory ReconciliationObject({
    $core.String? id,
    $core.String? loanAccountId,
    $core.String? paymentReference,
    $core.String? externalReference,
    $9.Money? amount,
    ReconciliationStatus? status,
    $core.String? matchedRepaymentId,
    $core.String? notes,
    $core.String? reconciledAt,
    $core.String? reconciledBy,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (paymentReference != null) {
      $result.paymentReference = paymentReference;
    }
    if (externalReference != null) {
      $result.externalReference = externalReference;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (status != null) {
      $result.status = status;
    }
    if (matchedRepaymentId != null) {
      $result.matchedRepaymentId = matchedRepaymentId;
    }
    if (notes != null) {
      $result.notes = notes;
    }
    if (reconciledAt != null) {
      $result.reconciledAt = reconciledAt;
    }
    if (reconciledBy != null) {
      $result.reconciledBy = reconciledBy;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  ReconciliationObject._() : super();
  factory ReconciliationObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReconciliationObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReconciliationObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'loanAccountId')
    ..aOS(3, _omitFieldNames ? '' : 'paymentReference')
    ..aOS(4, _omitFieldNames ? '' : 'externalReference')
    ..aOM<$9.Money>(5, _omitFieldNames ? '' : 'amount', subBuilder: $9.Money.create)
    ..e<ReconciliationStatus>(7, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: ReconciliationStatus.RECONCILIATION_STATUS_UNSPECIFIED, valueOf: ReconciliationStatus.valueOf, enumValues: ReconciliationStatus.values)
    ..aOS(8, _omitFieldNames ? '' : 'matchedRepaymentId')
    ..aOS(9, _omitFieldNames ? '' : 'notes')
    ..aOS(10, _omitFieldNames ? '' : 'reconciledAt')
    ..aOS(11, _omitFieldNames ? '' : 'reconciledBy')
    ..aOM<$6.Struct>(12, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReconciliationObject clone() => ReconciliationObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReconciliationObject copyWith(void Function(ReconciliationObject) updates) => super.copyWith((message) => updates(message as ReconciliationObject)) as ReconciliationObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReconciliationObject create() => ReconciliationObject._();
  ReconciliationObject createEmptyInstance() => create();
  static $pb.PbList<ReconciliationObject> createRepeated() => $pb.PbList<ReconciliationObject>();
  @$core.pragma('dart2js:noInline')
  static ReconciliationObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReconciliationObject>(create);
  static ReconciliationObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get loanAccountId => $_getSZ(1);
  @$pb.TagNumber(2)
  set loanAccountId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLoanAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLoanAccountId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get paymentReference => $_getSZ(2);
  @$pb.TagNumber(3)
  set paymentReference($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPaymentReference() => $_has(2);
  @$pb.TagNumber(3)
  void clearPaymentReference() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get externalReference => $_getSZ(3);
  @$pb.TagNumber(4)
  set externalReference($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasExternalReference() => $_has(3);
  @$pb.TagNumber(4)
  void clearExternalReference() => clearField(4);

  @$pb.TagNumber(5)
  $9.Money get amount => $_getN(4);
  @$pb.TagNumber(5)
  set amount($9.Money v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearAmount() => clearField(5);
  @$pb.TagNumber(5)
  $9.Money ensureAmount() => $_ensure(4);

  /// Field 6 removed (currency_code now in Money).
  @$pb.TagNumber(7)
  ReconciliationStatus get status => $_getN(5);
  @$pb.TagNumber(7)
  set status(ReconciliationStatus v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(7)
  void clearStatus() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get matchedRepaymentId => $_getSZ(6);
  @$pb.TagNumber(8)
  set matchedRepaymentId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(8)
  $core.bool hasMatchedRepaymentId() => $_has(6);
  @$pb.TagNumber(8)
  void clearMatchedRepaymentId() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get notes => $_getSZ(7);
  @$pb.TagNumber(9)
  set notes($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(9)
  $core.bool hasNotes() => $_has(7);
  @$pb.TagNumber(9)
  void clearNotes() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get reconciledAt => $_getSZ(8);
  @$pb.TagNumber(10)
  set reconciledAt($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(10)
  $core.bool hasReconciledAt() => $_has(8);
  @$pb.TagNumber(10)
  void clearReconciledAt() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get reconciledBy => $_getSZ(9);
  @$pb.TagNumber(11)
  set reconciledBy($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(11)
  $core.bool hasReconciledBy() => $_has(9);
  @$pb.TagNumber(11)
  void clearReconciledBy() => clearField(11);

  @$pb.TagNumber(12)
  $6.Struct get properties => $_getN(10);
  @$pb.TagNumber(12)
  set properties($6.Struct v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasProperties() => $_has(10);
  @$pb.TagNumber(12)
  void clearProperties() => clearField(12);
  @$pb.TagNumber(12)
  $6.Struct ensureProperties() => $_ensure(10);
}

/// LoanStatementEntry represents a single line in a loan statement.
class LoanStatementEntry extends $pb.GeneratedMessage {
  factory LoanStatementEntry({
    $core.String? date,
    $core.String? description,
    $9.Money? debit,
    $9.Money? credit,
    $9.Money? balance,
    $core.String? reference,
  }) {
    final $result = create();
    if (date != null) {
      $result.date = date;
    }
    if (description != null) {
      $result.description = description;
    }
    if (debit != null) {
      $result.debit = debit;
    }
    if (credit != null) {
      $result.credit = credit;
    }
    if (balance != null) {
      $result.balance = balance;
    }
    if (reference != null) {
      $result.reference = reference;
    }
    return $result;
  }
  LoanStatementEntry._() : super();
  factory LoanStatementEntry.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanStatementEntry.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanStatementEntry', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'date')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aOM<$9.Money>(3, _omitFieldNames ? '' : 'debit', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(4, _omitFieldNames ? '' : 'credit', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(5, _omitFieldNames ? '' : 'balance', subBuilder: $9.Money.create)
    ..aOS(6, _omitFieldNames ? '' : 'reference')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanStatementEntry clone() => LoanStatementEntry()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanStatementEntry copyWith(void Function(LoanStatementEntry) updates) => super.copyWith((message) => updates(message as LoanStatementEntry)) as LoanStatementEntry;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanStatementEntry create() => LoanStatementEntry._();
  LoanStatementEntry createEmptyInstance() => create();
  static $pb.PbList<LoanStatementEntry> createRepeated() => $pb.PbList<LoanStatementEntry>();
  @$core.pragma('dart2js:noInline')
  static LoanStatementEntry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanStatementEntry>(create);
  static LoanStatementEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get date => $_getSZ(0);
  @$pb.TagNumber(1)
  set date($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => clearField(2);

  @$pb.TagNumber(3)
  $9.Money get debit => $_getN(2);
  @$pb.TagNumber(3)
  set debit($9.Money v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasDebit() => $_has(2);
  @$pb.TagNumber(3)
  void clearDebit() => clearField(3);
  @$pb.TagNumber(3)
  $9.Money ensureDebit() => $_ensure(2);

  @$pb.TagNumber(4)
  $9.Money get credit => $_getN(3);
  @$pb.TagNumber(4)
  set credit($9.Money v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCredit() => $_has(3);
  @$pb.TagNumber(4)
  void clearCredit() => clearField(4);
  @$pb.TagNumber(4)
  $9.Money ensureCredit() => $_ensure(3);

  @$pb.TagNumber(5)
  $9.Money get balance => $_getN(4);
  @$pb.TagNumber(5)
  set balance($9.Money v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasBalance() => $_has(4);
  @$pb.TagNumber(5)
  void clearBalance() => clearField(5);
  @$pb.TagNumber(5)
  $9.Money ensureBalance() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get reference => $_getSZ(5);
  @$pb.TagNumber(6)
  set reference($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasReference() => $_has(5);
  @$pb.TagNumber(6)
  void clearReference() => clearField(6);
}

class LoanAccountCreateRequest extends $pb.GeneratedMessage {
  factory LoanAccountCreateRequest({
    $core.String? applicationId,
  }) {
    final $result = create();
    if (applicationId != null) {
      $result.applicationId = applicationId;
    }
    return $result;
  }
  LoanAccountCreateRequest._() : super();
  factory LoanAccountCreateRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanAccountCreateRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanAccountCreateRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'applicationId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanAccountCreateRequest clone() => LoanAccountCreateRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanAccountCreateRequest copyWith(void Function(LoanAccountCreateRequest) updates) => super.copyWith((message) => updates(message as LoanAccountCreateRequest)) as LoanAccountCreateRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanAccountCreateRequest create() => LoanAccountCreateRequest._();
  LoanAccountCreateRequest createEmptyInstance() => create();
  static $pb.PbList<LoanAccountCreateRequest> createRepeated() => $pb.PbList<LoanAccountCreateRequest>();
  @$core.pragma('dart2js:noInline')
  static LoanAccountCreateRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanAccountCreateRequest>(create);
  static LoanAccountCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get applicationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set applicationId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasApplicationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearApplicationId() => clearField(1);
}

class LoanAccountCreateResponse extends $pb.GeneratedMessage {
  factory LoanAccountCreateResponse({
    LoanAccountObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  LoanAccountCreateResponse._() : super();
  factory LoanAccountCreateResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanAccountCreateResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanAccountCreateResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<LoanAccountObject>(1, _omitFieldNames ? '' : 'data', subBuilder: LoanAccountObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanAccountCreateResponse clone() => LoanAccountCreateResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanAccountCreateResponse copyWith(void Function(LoanAccountCreateResponse) updates) => super.copyWith((message) => updates(message as LoanAccountCreateResponse)) as LoanAccountCreateResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanAccountCreateResponse create() => LoanAccountCreateResponse._();
  LoanAccountCreateResponse createEmptyInstance() => create();
  static $pb.PbList<LoanAccountCreateResponse> createRepeated() => $pb.PbList<LoanAccountCreateResponse>();
  @$core.pragma('dart2js:noInline')
  static LoanAccountCreateResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanAccountCreateResponse>(create);
  static LoanAccountCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LoanAccountObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(LoanAccountObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  LoanAccountObject ensureData() => $_ensure(0);
}

class LoanAccountGetRequest extends $pb.GeneratedMessage {
  factory LoanAccountGetRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  LoanAccountGetRequest._() : super();
  factory LoanAccountGetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanAccountGetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanAccountGetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanAccountGetRequest clone() => LoanAccountGetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanAccountGetRequest copyWith(void Function(LoanAccountGetRequest) updates) => super.copyWith((message) => updates(message as LoanAccountGetRequest)) as LoanAccountGetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanAccountGetRequest create() => LoanAccountGetRequest._();
  LoanAccountGetRequest createEmptyInstance() => create();
  static $pb.PbList<LoanAccountGetRequest> createRepeated() => $pb.PbList<LoanAccountGetRequest>();
  @$core.pragma('dart2js:noInline')
  static LoanAccountGetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanAccountGetRequest>(create);
  static LoanAccountGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class LoanAccountGetResponse extends $pb.GeneratedMessage {
  factory LoanAccountGetResponse({
    LoanAccountObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  LoanAccountGetResponse._() : super();
  factory LoanAccountGetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanAccountGetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanAccountGetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<LoanAccountObject>(1, _omitFieldNames ? '' : 'data', subBuilder: LoanAccountObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanAccountGetResponse clone() => LoanAccountGetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanAccountGetResponse copyWith(void Function(LoanAccountGetResponse) updates) => super.copyWith((message) => updates(message as LoanAccountGetResponse)) as LoanAccountGetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanAccountGetResponse create() => LoanAccountGetResponse._();
  LoanAccountGetResponse createEmptyInstance() => create();
  static $pb.PbList<LoanAccountGetResponse> createRepeated() => $pb.PbList<LoanAccountGetResponse>();
  @$core.pragma('dart2js:noInline')
  static LoanAccountGetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanAccountGetResponse>(create);
  static LoanAccountGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LoanAccountObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(LoanAccountObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  LoanAccountObject ensureData() => $_ensure(0);
}

class LoanAccountSearchRequest extends $pb.GeneratedMessage {
  factory LoanAccountSearchRequest({
    $core.String? query,
    $core.String? clientId,
    $core.String? agentId,
    $core.String? branchId,
    $core.String? organizationId,
    LoanStatus? status,
    $7.PageCursor? cursor,
  }) {
    final $result = create();
    if (query != null) {
      $result.query = query;
    }
    if (clientId != null) {
      $result.clientId = clientId;
    }
    if (agentId != null) {
      $result.agentId = agentId;
    }
    if (branchId != null) {
      $result.branchId = branchId;
    }
    if (organizationId != null) {
      $result.organizationId = organizationId;
    }
    if (status != null) {
      $result.status = status;
    }
    if (cursor != null) {
      $result.cursor = cursor;
    }
    return $result;
  }
  LoanAccountSearchRequest._() : super();
  factory LoanAccountSearchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanAccountSearchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanAccountSearchRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aOS(2, _omitFieldNames ? '' : 'clientId')
    ..aOS(3, _omitFieldNames ? '' : 'agentId')
    ..aOS(4, _omitFieldNames ? '' : 'branchId')
    ..aOS(5, _omitFieldNames ? '' : 'organizationId')
    ..e<LoanStatus>(6, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: LoanStatus.LOAN_STATUS_UNSPECIFIED, valueOf: LoanStatus.valueOf, enumValues: LoanStatus.values)
    ..aOM<$7.PageCursor>(7, _omitFieldNames ? '' : 'cursor', subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanAccountSearchRequest clone() => LoanAccountSearchRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanAccountSearchRequest copyWith(void Function(LoanAccountSearchRequest) updates) => super.copyWith((message) => updates(message as LoanAccountSearchRequest)) as LoanAccountSearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanAccountSearchRequest create() => LoanAccountSearchRequest._();
  LoanAccountSearchRequest createEmptyInstance() => create();
  static $pb.PbList<LoanAccountSearchRequest> createRepeated() => $pb.PbList<LoanAccountSearchRequest>();
  @$core.pragma('dart2js:noInline')
  static LoanAccountSearchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanAccountSearchRequest>(create);
  static LoanAccountSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasClientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get agentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set agentId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAgentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAgentId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get branchId => $_getSZ(3);
  @$pb.TagNumber(4)
  set branchId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBranchId() => $_has(3);
  @$pb.TagNumber(4)
  void clearBranchId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get organizationId => $_getSZ(4);
  @$pb.TagNumber(5)
  set organizationId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasOrganizationId() => $_has(4);
  @$pb.TagNumber(5)
  void clearOrganizationId() => clearField(5);

  @$pb.TagNumber(6)
  LoanStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(LoanStatus v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => clearField(6);

  @$pb.TagNumber(7)
  $7.PageCursor get cursor => $_getN(6);
  @$pb.TagNumber(7)
  set cursor($7.PageCursor v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasCursor() => $_has(6);
  @$pb.TagNumber(7)
  void clearCursor() => clearField(7);
  @$pb.TagNumber(7)
  $7.PageCursor ensureCursor() => $_ensure(6);
}

class LoanAccountSearchResponse extends $pb.GeneratedMessage {
  factory LoanAccountSearchResponse({
    $core.Iterable<LoanAccountObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  LoanAccountSearchResponse._() : super();
  factory LoanAccountSearchResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanAccountSearchResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanAccountSearchResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..pc<LoanAccountObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: LoanAccountObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanAccountSearchResponse clone() => LoanAccountSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanAccountSearchResponse copyWith(void Function(LoanAccountSearchResponse) updates) => super.copyWith((message) => updates(message as LoanAccountSearchResponse)) as LoanAccountSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanAccountSearchResponse create() => LoanAccountSearchResponse._();
  LoanAccountSearchResponse createEmptyInstance() => create();
  static $pb.PbList<LoanAccountSearchResponse> createRepeated() => $pb.PbList<LoanAccountSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static LoanAccountSearchResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanAccountSearchResponse>(create);
  static LoanAccountSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<LoanAccountObject> get data => $_getList(0);
}

class LoanBalanceGetRequest extends $pb.GeneratedMessage {
  factory LoanBalanceGetRequest({
    $core.String? loanAccountId,
  }) {
    final $result = create();
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    return $result;
  }
  LoanBalanceGetRequest._() : super();
  factory LoanBalanceGetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanBalanceGetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanBalanceGetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'loanAccountId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanBalanceGetRequest clone() => LoanBalanceGetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanBalanceGetRequest copyWith(void Function(LoanBalanceGetRequest) updates) => super.copyWith((message) => updates(message as LoanBalanceGetRequest)) as LoanBalanceGetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanBalanceGetRequest create() => LoanBalanceGetRequest._();
  LoanBalanceGetRequest createEmptyInstance() => create();
  static $pb.PbList<LoanBalanceGetRequest> createRepeated() => $pb.PbList<LoanBalanceGetRequest>();
  @$core.pragma('dart2js:noInline')
  static LoanBalanceGetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanBalanceGetRequest>(create);
  static LoanBalanceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get loanAccountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set loanAccountId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLoanAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoanAccountId() => clearField(1);
}

class LoanBalanceGetResponse extends $pb.GeneratedMessage {
  factory LoanBalanceGetResponse({
    LoanBalanceObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  LoanBalanceGetResponse._() : super();
  factory LoanBalanceGetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanBalanceGetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanBalanceGetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<LoanBalanceObject>(1, _omitFieldNames ? '' : 'data', subBuilder: LoanBalanceObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanBalanceGetResponse clone() => LoanBalanceGetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanBalanceGetResponse copyWith(void Function(LoanBalanceGetResponse) updates) => super.copyWith((message) => updates(message as LoanBalanceGetResponse)) as LoanBalanceGetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanBalanceGetResponse create() => LoanBalanceGetResponse._();
  LoanBalanceGetResponse createEmptyInstance() => create();
  static $pb.PbList<LoanBalanceGetResponse> createRepeated() => $pb.PbList<LoanBalanceGetResponse>();
  @$core.pragma('dart2js:noInline')
  static LoanBalanceGetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanBalanceGetResponse>(create);
  static LoanBalanceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LoanBalanceObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(LoanBalanceObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  LoanBalanceObject ensureData() => $_ensure(0);
}

class DisbursementCreateRequest extends $pb.GeneratedMessage {
  factory DisbursementCreateRequest({
    $core.String? loanAccountId,
    $core.String? channel,
    $core.String? recipientReference,
    $core.String? idempotencyKey,
  }) {
    final $result = create();
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (channel != null) {
      $result.channel = channel;
    }
    if (recipientReference != null) {
      $result.recipientReference = recipientReference;
    }
    if (idempotencyKey != null) {
      $result.idempotencyKey = idempotencyKey;
    }
    return $result;
  }
  DisbursementCreateRequest._() : super();
  factory DisbursementCreateRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DisbursementCreateRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DisbursementCreateRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'loanAccountId')
    ..aOS(2, _omitFieldNames ? '' : 'channel')
    ..aOS(3, _omitFieldNames ? '' : 'recipientReference')
    ..aOS(4, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DisbursementCreateRequest clone() => DisbursementCreateRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DisbursementCreateRequest copyWith(void Function(DisbursementCreateRequest) updates) => super.copyWith((message) => updates(message as DisbursementCreateRequest)) as DisbursementCreateRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisbursementCreateRequest create() => DisbursementCreateRequest._();
  DisbursementCreateRequest createEmptyInstance() => create();
  static $pb.PbList<DisbursementCreateRequest> createRepeated() => $pb.PbList<DisbursementCreateRequest>();
  @$core.pragma('dart2js:noInline')
  static DisbursementCreateRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DisbursementCreateRequest>(create);
  static DisbursementCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get loanAccountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set loanAccountId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLoanAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoanAccountId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get channel => $_getSZ(1);
  @$pb.TagNumber(2)
  set channel($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasChannel() => $_has(1);
  @$pb.TagNumber(2)
  void clearChannel() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get recipientReference => $_getSZ(2);
  @$pb.TagNumber(3)
  set recipientReference($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRecipientReference() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecipientReference() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get idempotencyKey => $_getSZ(3);
  @$pb.TagNumber(4)
  set idempotencyKey($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIdempotencyKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearIdempotencyKey() => clearField(4);
}

class DisbursementCreateResponse extends $pb.GeneratedMessage {
  factory DisbursementCreateResponse({
    DisbursementObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  DisbursementCreateResponse._() : super();
  factory DisbursementCreateResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DisbursementCreateResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DisbursementCreateResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<DisbursementObject>(1, _omitFieldNames ? '' : 'data', subBuilder: DisbursementObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DisbursementCreateResponse clone() => DisbursementCreateResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DisbursementCreateResponse copyWith(void Function(DisbursementCreateResponse) updates) => super.copyWith((message) => updates(message as DisbursementCreateResponse)) as DisbursementCreateResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisbursementCreateResponse create() => DisbursementCreateResponse._();
  DisbursementCreateResponse createEmptyInstance() => create();
  static $pb.PbList<DisbursementCreateResponse> createRepeated() => $pb.PbList<DisbursementCreateResponse>();
  @$core.pragma('dart2js:noInline')
  static DisbursementCreateResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DisbursementCreateResponse>(create);
  static DisbursementCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DisbursementObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(DisbursementObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  DisbursementObject ensureData() => $_ensure(0);
}

class DisbursementGetRequest extends $pb.GeneratedMessage {
  factory DisbursementGetRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DisbursementGetRequest._() : super();
  factory DisbursementGetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DisbursementGetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DisbursementGetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DisbursementGetRequest clone() => DisbursementGetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DisbursementGetRequest copyWith(void Function(DisbursementGetRequest) updates) => super.copyWith((message) => updates(message as DisbursementGetRequest)) as DisbursementGetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisbursementGetRequest create() => DisbursementGetRequest._();
  DisbursementGetRequest createEmptyInstance() => create();
  static $pb.PbList<DisbursementGetRequest> createRepeated() => $pb.PbList<DisbursementGetRequest>();
  @$core.pragma('dart2js:noInline')
  static DisbursementGetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DisbursementGetRequest>(create);
  static DisbursementGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class DisbursementGetResponse extends $pb.GeneratedMessage {
  factory DisbursementGetResponse({
    DisbursementObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  DisbursementGetResponse._() : super();
  factory DisbursementGetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DisbursementGetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DisbursementGetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<DisbursementObject>(1, _omitFieldNames ? '' : 'data', subBuilder: DisbursementObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DisbursementGetResponse clone() => DisbursementGetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DisbursementGetResponse copyWith(void Function(DisbursementGetResponse) updates) => super.copyWith((message) => updates(message as DisbursementGetResponse)) as DisbursementGetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisbursementGetResponse create() => DisbursementGetResponse._();
  DisbursementGetResponse createEmptyInstance() => create();
  static $pb.PbList<DisbursementGetResponse> createRepeated() => $pb.PbList<DisbursementGetResponse>();
  @$core.pragma('dart2js:noInline')
  static DisbursementGetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DisbursementGetResponse>(create);
  static DisbursementGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DisbursementObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(DisbursementObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  DisbursementObject ensureData() => $_ensure(0);
}

class DisbursementSearchRequest extends $pb.GeneratedMessage {
  factory DisbursementSearchRequest({
    $core.String? loanAccountId,
    DisbursementStatus? status,
    $7.PageCursor? cursor,
  }) {
    final $result = create();
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (status != null) {
      $result.status = status;
    }
    if (cursor != null) {
      $result.cursor = cursor;
    }
    return $result;
  }
  DisbursementSearchRequest._() : super();
  factory DisbursementSearchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DisbursementSearchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DisbursementSearchRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'loanAccountId')
    ..e<DisbursementStatus>(2, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: DisbursementStatus.DISBURSEMENT_STATUS_UNSPECIFIED, valueOf: DisbursementStatus.valueOf, enumValues: DisbursementStatus.values)
    ..aOM<$7.PageCursor>(3, _omitFieldNames ? '' : 'cursor', subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DisbursementSearchRequest clone() => DisbursementSearchRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DisbursementSearchRequest copyWith(void Function(DisbursementSearchRequest) updates) => super.copyWith((message) => updates(message as DisbursementSearchRequest)) as DisbursementSearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisbursementSearchRequest create() => DisbursementSearchRequest._();
  DisbursementSearchRequest createEmptyInstance() => create();
  static $pb.PbList<DisbursementSearchRequest> createRepeated() => $pb.PbList<DisbursementSearchRequest>();
  @$core.pragma('dart2js:noInline')
  static DisbursementSearchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DisbursementSearchRequest>(create);
  static DisbursementSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get loanAccountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set loanAccountId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLoanAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoanAccountId() => clearField(1);

  @$pb.TagNumber(2)
  DisbursementStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(DisbursementStatus v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);

  @$pb.TagNumber(3)
  $7.PageCursor get cursor => $_getN(2);
  @$pb.TagNumber(3)
  set cursor($7.PageCursor v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCursor() => $_has(2);
  @$pb.TagNumber(3)
  void clearCursor() => clearField(3);
  @$pb.TagNumber(3)
  $7.PageCursor ensureCursor() => $_ensure(2);
}

class DisbursementSearchResponse extends $pb.GeneratedMessage {
  factory DisbursementSearchResponse({
    $core.Iterable<DisbursementObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  DisbursementSearchResponse._() : super();
  factory DisbursementSearchResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DisbursementSearchResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DisbursementSearchResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..pc<DisbursementObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: DisbursementObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DisbursementSearchResponse clone() => DisbursementSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DisbursementSearchResponse copyWith(void Function(DisbursementSearchResponse) updates) => super.copyWith((message) => updates(message as DisbursementSearchResponse)) as DisbursementSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisbursementSearchResponse create() => DisbursementSearchResponse._();
  DisbursementSearchResponse createEmptyInstance() => create();
  static $pb.PbList<DisbursementSearchResponse> createRepeated() => $pb.PbList<DisbursementSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static DisbursementSearchResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DisbursementSearchResponse>(create);
  static DisbursementSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<DisbursementObject> get data => $_getList(0);
}

class RepaymentRecordRequest extends $pb.GeneratedMessage {
  factory RepaymentRecordRequest({
    $core.String? loanAccountId,
    $9.Money? amount,
    $core.String? paymentReference,
    $core.String? channel,
    $core.String? payerReference,
    $core.String? receivedAt,
    $core.String? idempotencyKey,
  }) {
    final $result = create();
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (paymentReference != null) {
      $result.paymentReference = paymentReference;
    }
    if (channel != null) {
      $result.channel = channel;
    }
    if (payerReference != null) {
      $result.payerReference = payerReference;
    }
    if (receivedAt != null) {
      $result.receivedAt = receivedAt;
    }
    if (idempotencyKey != null) {
      $result.idempotencyKey = idempotencyKey;
    }
    return $result;
  }
  RepaymentRecordRequest._() : super();
  factory RepaymentRecordRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RepaymentRecordRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RepaymentRecordRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'loanAccountId')
    ..aOM<$9.Money>(2, _omitFieldNames ? '' : 'amount', subBuilder: $9.Money.create)
    ..aOS(3, _omitFieldNames ? '' : 'paymentReference')
    ..aOS(4, _omitFieldNames ? '' : 'channel')
    ..aOS(5, _omitFieldNames ? '' : 'payerReference')
    ..aOS(6, _omitFieldNames ? '' : 'receivedAt')
    ..aOS(7, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RepaymentRecordRequest clone() => RepaymentRecordRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RepaymentRecordRequest copyWith(void Function(RepaymentRecordRequest) updates) => super.copyWith((message) => updates(message as RepaymentRecordRequest)) as RepaymentRecordRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RepaymentRecordRequest create() => RepaymentRecordRequest._();
  RepaymentRecordRequest createEmptyInstance() => create();
  static $pb.PbList<RepaymentRecordRequest> createRepeated() => $pb.PbList<RepaymentRecordRequest>();
  @$core.pragma('dart2js:noInline')
  static RepaymentRecordRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RepaymentRecordRequest>(create);
  static RepaymentRecordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get loanAccountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set loanAccountId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLoanAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoanAccountId() => clearField(1);

  @$pb.TagNumber(2)
  $9.Money get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount($9.Money v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);
  @$pb.TagNumber(2)
  $9.Money ensureAmount() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get paymentReference => $_getSZ(2);
  @$pb.TagNumber(3)
  set paymentReference($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPaymentReference() => $_has(2);
  @$pb.TagNumber(3)
  void clearPaymentReference() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get channel => $_getSZ(3);
  @$pb.TagNumber(4)
  set channel($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasChannel() => $_has(3);
  @$pb.TagNumber(4)
  void clearChannel() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get payerReference => $_getSZ(4);
  @$pb.TagNumber(5)
  set payerReference($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPayerReference() => $_has(4);
  @$pb.TagNumber(5)
  void clearPayerReference() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get receivedAt => $_getSZ(5);
  @$pb.TagNumber(6)
  set receivedAt($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasReceivedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearReceivedAt() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get idempotencyKey => $_getSZ(6);
  @$pb.TagNumber(7)
  set idempotencyKey($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasIdempotencyKey() => $_has(6);
  @$pb.TagNumber(7)
  void clearIdempotencyKey() => clearField(7);
}

class RepaymentRecordResponse extends $pb.GeneratedMessage {
  factory RepaymentRecordResponse({
    RepaymentObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  RepaymentRecordResponse._() : super();
  factory RepaymentRecordResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RepaymentRecordResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RepaymentRecordResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<RepaymentObject>(1, _omitFieldNames ? '' : 'data', subBuilder: RepaymentObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RepaymentRecordResponse clone() => RepaymentRecordResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RepaymentRecordResponse copyWith(void Function(RepaymentRecordResponse) updates) => super.copyWith((message) => updates(message as RepaymentRecordResponse)) as RepaymentRecordResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RepaymentRecordResponse create() => RepaymentRecordResponse._();
  RepaymentRecordResponse createEmptyInstance() => create();
  static $pb.PbList<RepaymentRecordResponse> createRepeated() => $pb.PbList<RepaymentRecordResponse>();
  @$core.pragma('dart2js:noInline')
  static RepaymentRecordResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RepaymentRecordResponse>(create);
  static RepaymentRecordResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RepaymentObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(RepaymentObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  RepaymentObject ensureData() => $_ensure(0);
}

class RepaymentGetRequest extends $pb.GeneratedMessage {
  factory RepaymentGetRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  RepaymentGetRequest._() : super();
  factory RepaymentGetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RepaymentGetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RepaymentGetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RepaymentGetRequest clone() => RepaymentGetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RepaymentGetRequest copyWith(void Function(RepaymentGetRequest) updates) => super.copyWith((message) => updates(message as RepaymentGetRequest)) as RepaymentGetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RepaymentGetRequest create() => RepaymentGetRequest._();
  RepaymentGetRequest createEmptyInstance() => create();
  static $pb.PbList<RepaymentGetRequest> createRepeated() => $pb.PbList<RepaymentGetRequest>();
  @$core.pragma('dart2js:noInline')
  static RepaymentGetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RepaymentGetRequest>(create);
  static RepaymentGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class RepaymentGetResponse extends $pb.GeneratedMessage {
  factory RepaymentGetResponse({
    RepaymentObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  RepaymentGetResponse._() : super();
  factory RepaymentGetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RepaymentGetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RepaymentGetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<RepaymentObject>(1, _omitFieldNames ? '' : 'data', subBuilder: RepaymentObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RepaymentGetResponse clone() => RepaymentGetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RepaymentGetResponse copyWith(void Function(RepaymentGetResponse) updates) => super.copyWith((message) => updates(message as RepaymentGetResponse)) as RepaymentGetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RepaymentGetResponse create() => RepaymentGetResponse._();
  RepaymentGetResponse createEmptyInstance() => create();
  static $pb.PbList<RepaymentGetResponse> createRepeated() => $pb.PbList<RepaymentGetResponse>();
  @$core.pragma('dart2js:noInline')
  static RepaymentGetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RepaymentGetResponse>(create);
  static RepaymentGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RepaymentObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(RepaymentObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  RepaymentObject ensureData() => $_ensure(0);
}

class RepaymentSearchRequest extends $pb.GeneratedMessage {
  factory RepaymentSearchRequest({
    $core.String? loanAccountId,
    RepaymentStatus? status,
    $7.PageCursor? cursor,
  }) {
    final $result = create();
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (status != null) {
      $result.status = status;
    }
    if (cursor != null) {
      $result.cursor = cursor;
    }
    return $result;
  }
  RepaymentSearchRequest._() : super();
  factory RepaymentSearchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RepaymentSearchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RepaymentSearchRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'loanAccountId')
    ..e<RepaymentStatus>(2, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: RepaymentStatus.REPAYMENT_STATUS_UNSPECIFIED, valueOf: RepaymentStatus.valueOf, enumValues: RepaymentStatus.values)
    ..aOM<$7.PageCursor>(3, _omitFieldNames ? '' : 'cursor', subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RepaymentSearchRequest clone() => RepaymentSearchRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RepaymentSearchRequest copyWith(void Function(RepaymentSearchRequest) updates) => super.copyWith((message) => updates(message as RepaymentSearchRequest)) as RepaymentSearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RepaymentSearchRequest create() => RepaymentSearchRequest._();
  RepaymentSearchRequest createEmptyInstance() => create();
  static $pb.PbList<RepaymentSearchRequest> createRepeated() => $pb.PbList<RepaymentSearchRequest>();
  @$core.pragma('dart2js:noInline')
  static RepaymentSearchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RepaymentSearchRequest>(create);
  static RepaymentSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get loanAccountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set loanAccountId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLoanAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoanAccountId() => clearField(1);

  @$pb.TagNumber(2)
  RepaymentStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(RepaymentStatus v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);

  @$pb.TagNumber(3)
  $7.PageCursor get cursor => $_getN(2);
  @$pb.TagNumber(3)
  set cursor($7.PageCursor v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCursor() => $_has(2);
  @$pb.TagNumber(3)
  void clearCursor() => clearField(3);
  @$pb.TagNumber(3)
  $7.PageCursor ensureCursor() => $_ensure(2);
}

class RepaymentSearchResponse extends $pb.GeneratedMessage {
  factory RepaymentSearchResponse({
    $core.Iterable<RepaymentObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  RepaymentSearchResponse._() : super();
  factory RepaymentSearchResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RepaymentSearchResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RepaymentSearchResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..pc<RepaymentObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: RepaymentObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RepaymentSearchResponse clone() => RepaymentSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RepaymentSearchResponse copyWith(void Function(RepaymentSearchResponse) updates) => super.copyWith((message) => updates(message as RepaymentSearchResponse)) as RepaymentSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RepaymentSearchResponse create() => RepaymentSearchResponse._();
  RepaymentSearchResponse createEmptyInstance() => create();
  static $pb.PbList<RepaymentSearchResponse> createRepeated() => $pb.PbList<RepaymentSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static RepaymentSearchResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RepaymentSearchResponse>(create);
  static RepaymentSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<RepaymentObject> get data => $_getList(0);
}

class RepaymentScheduleGetRequest extends $pb.GeneratedMessage {
  factory RepaymentScheduleGetRequest({
    $core.String? loanAccountId,
  }) {
    final $result = create();
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    return $result;
  }
  RepaymentScheduleGetRequest._() : super();
  factory RepaymentScheduleGetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RepaymentScheduleGetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RepaymentScheduleGetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'loanAccountId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RepaymentScheduleGetRequest clone() => RepaymentScheduleGetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RepaymentScheduleGetRequest copyWith(void Function(RepaymentScheduleGetRequest) updates) => super.copyWith((message) => updates(message as RepaymentScheduleGetRequest)) as RepaymentScheduleGetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RepaymentScheduleGetRequest create() => RepaymentScheduleGetRequest._();
  RepaymentScheduleGetRequest createEmptyInstance() => create();
  static $pb.PbList<RepaymentScheduleGetRequest> createRepeated() => $pb.PbList<RepaymentScheduleGetRequest>();
  @$core.pragma('dart2js:noInline')
  static RepaymentScheduleGetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RepaymentScheduleGetRequest>(create);
  static RepaymentScheduleGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get loanAccountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set loanAccountId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLoanAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoanAccountId() => clearField(1);
}

class RepaymentScheduleGetResponse extends $pb.GeneratedMessage {
  factory RepaymentScheduleGetResponse({
    RepaymentScheduleObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  RepaymentScheduleGetResponse._() : super();
  factory RepaymentScheduleGetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RepaymentScheduleGetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RepaymentScheduleGetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<RepaymentScheduleObject>(1, _omitFieldNames ? '' : 'data', subBuilder: RepaymentScheduleObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RepaymentScheduleGetResponse clone() => RepaymentScheduleGetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RepaymentScheduleGetResponse copyWith(void Function(RepaymentScheduleGetResponse) updates) => super.copyWith((message) => updates(message as RepaymentScheduleGetResponse)) as RepaymentScheduleGetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RepaymentScheduleGetResponse create() => RepaymentScheduleGetResponse._();
  RepaymentScheduleGetResponse createEmptyInstance() => create();
  static $pb.PbList<RepaymentScheduleGetResponse> createRepeated() => $pb.PbList<RepaymentScheduleGetResponse>();
  @$core.pragma('dart2js:noInline')
  static RepaymentScheduleGetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RepaymentScheduleGetResponse>(create);
  static RepaymentScheduleGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RepaymentScheduleObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(RepaymentScheduleObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  RepaymentScheduleObject ensureData() => $_ensure(0);
}

class PenaltySaveRequest extends $pb.GeneratedMessage {
  factory PenaltySaveRequest({
    PenaltyObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  PenaltySaveRequest._() : super();
  factory PenaltySaveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PenaltySaveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PenaltySaveRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<PenaltyObject>(1, _omitFieldNames ? '' : 'data', subBuilder: PenaltyObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PenaltySaveRequest clone() => PenaltySaveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PenaltySaveRequest copyWith(void Function(PenaltySaveRequest) updates) => super.copyWith((message) => updates(message as PenaltySaveRequest)) as PenaltySaveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PenaltySaveRequest create() => PenaltySaveRequest._();
  PenaltySaveRequest createEmptyInstance() => create();
  static $pb.PbList<PenaltySaveRequest> createRepeated() => $pb.PbList<PenaltySaveRequest>();
  @$core.pragma('dart2js:noInline')
  static PenaltySaveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PenaltySaveRequest>(create);
  static PenaltySaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  PenaltyObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(PenaltyObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  PenaltyObject ensureData() => $_ensure(0);
}

class PenaltySaveResponse extends $pb.GeneratedMessage {
  factory PenaltySaveResponse({
    PenaltyObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  PenaltySaveResponse._() : super();
  factory PenaltySaveResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PenaltySaveResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PenaltySaveResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<PenaltyObject>(1, _omitFieldNames ? '' : 'data', subBuilder: PenaltyObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PenaltySaveResponse clone() => PenaltySaveResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PenaltySaveResponse copyWith(void Function(PenaltySaveResponse) updates) => super.copyWith((message) => updates(message as PenaltySaveResponse)) as PenaltySaveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PenaltySaveResponse create() => PenaltySaveResponse._();
  PenaltySaveResponse createEmptyInstance() => create();
  static $pb.PbList<PenaltySaveResponse> createRepeated() => $pb.PbList<PenaltySaveResponse>();
  @$core.pragma('dart2js:noInline')
  static PenaltySaveResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PenaltySaveResponse>(create);
  static PenaltySaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PenaltyObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(PenaltyObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  PenaltyObject ensureData() => $_ensure(0);
}

class PenaltyWaiveRequest extends $pb.GeneratedMessage {
  factory PenaltyWaiveRequest({
    $core.String? id,
    $core.String? reason,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    return $result;
  }
  PenaltyWaiveRequest._() : super();
  factory PenaltyWaiveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PenaltyWaiveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PenaltyWaiveRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PenaltyWaiveRequest clone() => PenaltyWaiveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PenaltyWaiveRequest copyWith(void Function(PenaltyWaiveRequest) updates) => super.copyWith((message) => updates(message as PenaltyWaiveRequest)) as PenaltyWaiveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PenaltyWaiveRequest create() => PenaltyWaiveRequest._();
  PenaltyWaiveRequest createEmptyInstance() => create();
  static $pb.PbList<PenaltyWaiveRequest> createRepeated() => $pb.PbList<PenaltyWaiveRequest>();
  @$core.pragma('dart2js:noInline')
  static PenaltyWaiveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PenaltyWaiveRequest>(create);
  static PenaltyWaiveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => clearField(2);
}

class PenaltyWaiveResponse extends $pb.GeneratedMessage {
  factory PenaltyWaiveResponse({
    PenaltyObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  PenaltyWaiveResponse._() : super();
  factory PenaltyWaiveResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PenaltyWaiveResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PenaltyWaiveResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<PenaltyObject>(1, _omitFieldNames ? '' : 'data', subBuilder: PenaltyObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PenaltyWaiveResponse clone() => PenaltyWaiveResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PenaltyWaiveResponse copyWith(void Function(PenaltyWaiveResponse) updates) => super.copyWith((message) => updates(message as PenaltyWaiveResponse)) as PenaltyWaiveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PenaltyWaiveResponse create() => PenaltyWaiveResponse._();
  PenaltyWaiveResponse createEmptyInstance() => create();
  static $pb.PbList<PenaltyWaiveResponse> createRepeated() => $pb.PbList<PenaltyWaiveResponse>();
  @$core.pragma('dart2js:noInline')
  static PenaltyWaiveResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PenaltyWaiveResponse>(create);
  static PenaltyWaiveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PenaltyObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(PenaltyObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  PenaltyObject ensureData() => $_ensure(0);
}

class PenaltySearchRequest extends $pb.GeneratedMessage {
  factory PenaltySearchRequest({
    $core.String? loanAccountId,
    PenaltyType? penaltyType,
    $7.PageCursor? cursor,
  }) {
    final $result = create();
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (penaltyType != null) {
      $result.penaltyType = penaltyType;
    }
    if (cursor != null) {
      $result.cursor = cursor;
    }
    return $result;
  }
  PenaltySearchRequest._() : super();
  factory PenaltySearchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PenaltySearchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PenaltySearchRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'loanAccountId')
    ..e<PenaltyType>(2, _omitFieldNames ? '' : 'penaltyType', $pb.PbFieldType.OE, defaultOrMaker: PenaltyType.PENALTY_TYPE_UNSPECIFIED, valueOf: PenaltyType.valueOf, enumValues: PenaltyType.values)
    ..aOM<$7.PageCursor>(3, _omitFieldNames ? '' : 'cursor', subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PenaltySearchRequest clone() => PenaltySearchRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PenaltySearchRequest copyWith(void Function(PenaltySearchRequest) updates) => super.copyWith((message) => updates(message as PenaltySearchRequest)) as PenaltySearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PenaltySearchRequest create() => PenaltySearchRequest._();
  PenaltySearchRequest createEmptyInstance() => create();
  static $pb.PbList<PenaltySearchRequest> createRepeated() => $pb.PbList<PenaltySearchRequest>();
  @$core.pragma('dart2js:noInline')
  static PenaltySearchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PenaltySearchRequest>(create);
  static PenaltySearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get loanAccountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set loanAccountId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLoanAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoanAccountId() => clearField(1);

  @$pb.TagNumber(2)
  PenaltyType get penaltyType => $_getN(1);
  @$pb.TagNumber(2)
  set penaltyType(PenaltyType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPenaltyType() => $_has(1);
  @$pb.TagNumber(2)
  void clearPenaltyType() => clearField(2);

  @$pb.TagNumber(3)
  $7.PageCursor get cursor => $_getN(2);
  @$pb.TagNumber(3)
  set cursor($7.PageCursor v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCursor() => $_has(2);
  @$pb.TagNumber(3)
  void clearCursor() => clearField(3);
  @$pb.TagNumber(3)
  $7.PageCursor ensureCursor() => $_ensure(2);
}

class PenaltySearchResponse extends $pb.GeneratedMessage {
  factory PenaltySearchResponse({
    $core.Iterable<PenaltyObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  PenaltySearchResponse._() : super();
  factory PenaltySearchResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PenaltySearchResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PenaltySearchResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..pc<PenaltyObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: PenaltyObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PenaltySearchResponse clone() => PenaltySearchResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PenaltySearchResponse copyWith(void Function(PenaltySearchResponse) updates) => super.copyWith((message) => updates(message as PenaltySearchResponse)) as PenaltySearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PenaltySearchResponse create() => PenaltySearchResponse._();
  PenaltySearchResponse createEmptyInstance() => create();
  static $pb.PbList<PenaltySearchResponse> createRepeated() => $pb.PbList<PenaltySearchResponse>();
  @$core.pragma('dart2js:noInline')
  static PenaltySearchResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PenaltySearchResponse>(create);
  static PenaltySearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<PenaltyObject> get data => $_getList(0);
}

class LoanRestructureCreateRequest extends $pb.GeneratedMessage {
  factory LoanRestructureCreateRequest({
    LoanRestructureObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  LoanRestructureCreateRequest._() : super();
  factory LoanRestructureCreateRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanRestructureCreateRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanRestructureCreateRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<LoanRestructureObject>(1, _omitFieldNames ? '' : 'data', subBuilder: LoanRestructureObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanRestructureCreateRequest clone() => LoanRestructureCreateRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanRestructureCreateRequest copyWith(void Function(LoanRestructureCreateRequest) updates) => super.copyWith((message) => updates(message as LoanRestructureCreateRequest)) as LoanRestructureCreateRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanRestructureCreateRequest create() => LoanRestructureCreateRequest._();
  LoanRestructureCreateRequest createEmptyInstance() => create();
  static $pb.PbList<LoanRestructureCreateRequest> createRepeated() => $pb.PbList<LoanRestructureCreateRequest>();
  @$core.pragma('dart2js:noInline')
  static LoanRestructureCreateRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanRestructureCreateRequest>(create);
  static LoanRestructureCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  LoanRestructureObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(LoanRestructureObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  LoanRestructureObject ensureData() => $_ensure(0);
}

class LoanRestructureCreateResponse extends $pb.GeneratedMessage {
  factory LoanRestructureCreateResponse({
    LoanRestructureObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  LoanRestructureCreateResponse._() : super();
  factory LoanRestructureCreateResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanRestructureCreateResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanRestructureCreateResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<LoanRestructureObject>(1, _omitFieldNames ? '' : 'data', subBuilder: LoanRestructureObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanRestructureCreateResponse clone() => LoanRestructureCreateResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanRestructureCreateResponse copyWith(void Function(LoanRestructureCreateResponse) updates) => super.copyWith((message) => updates(message as LoanRestructureCreateResponse)) as LoanRestructureCreateResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanRestructureCreateResponse create() => LoanRestructureCreateResponse._();
  LoanRestructureCreateResponse createEmptyInstance() => create();
  static $pb.PbList<LoanRestructureCreateResponse> createRepeated() => $pb.PbList<LoanRestructureCreateResponse>();
  @$core.pragma('dart2js:noInline')
  static LoanRestructureCreateResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanRestructureCreateResponse>(create);
  static LoanRestructureCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LoanRestructureObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(LoanRestructureObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  LoanRestructureObject ensureData() => $_ensure(0);
}

class LoanRestructureApproveRequest extends $pb.GeneratedMessage {
  factory LoanRestructureApproveRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  LoanRestructureApproveRequest._() : super();
  factory LoanRestructureApproveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanRestructureApproveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanRestructureApproveRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanRestructureApproveRequest clone() => LoanRestructureApproveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanRestructureApproveRequest copyWith(void Function(LoanRestructureApproveRequest) updates) => super.copyWith((message) => updates(message as LoanRestructureApproveRequest)) as LoanRestructureApproveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanRestructureApproveRequest create() => LoanRestructureApproveRequest._();
  LoanRestructureApproveRequest createEmptyInstance() => create();
  static $pb.PbList<LoanRestructureApproveRequest> createRepeated() => $pb.PbList<LoanRestructureApproveRequest>();
  @$core.pragma('dart2js:noInline')
  static LoanRestructureApproveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanRestructureApproveRequest>(create);
  static LoanRestructureApproveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class LoanRestructureApproveResponse extends $pb.GeneratedMessage {
  factory LoanRestructureApproveResponse({
    LoanRestructureObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  LoanRestructureApproveResponse._() : super();
  factory LoanRestructureApproveResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanRestructureApproveResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanRestructureApproveResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<LoanRestructureObject>(1, _omitFieldNames ? '' : 'data', subBuilder: LoanRestructureObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanRestructureApproveResponse clone() => LoanRestructureApproveResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanRestructureApproveResponse copyWith(void Function(LoanRestructureApproveResponse) updates) => super.copyWith((message) => updates(message as LoanRestructureApproveResponse)) as LoanRestructureApproveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanRestructureApproveResponse create() => LoanRestructureApproveResponse._();
  LoanRestructureApproveResponse createEmptyInstance() => create();
  static $pb.PbList<LoanRestructureApproveResponse> createRepeated() => $pb.PbList<LoanRestructureApproveResponse>();
  @$core.pragma('dart2js:noInline')
  static LoanRestructureApproveResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanRestructureApproveResponse>(create);
  static LoanRestructureApproveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LoanRestructureObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(LoanRestructureObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  LoanRestructureObject ensureData() => $_ensure(0);
}

class LoanRestructureRejectRequest extends $pb.GeneratedMessage {
  factory LoanRestructureRejectRequest({
    $core.String? id,
    $core.String? reason,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    return $result;
  }
  LoanRestructureRejectRequest._() : super();
  factory LoanRestructureRejectRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanRestructureRejectRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanRestructureRejectRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanRestructureRejectRequest clone() => LoanRestructureRejectRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanRestructureRejectRequest copyWith(void Function(LoanRestructureRejectRequest) updates) => super.copyWith((message) => updates(message as LoanRestructureRejectRequest)) as LoanRestructureRejectRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanRestructureRejectRequest create() => LoanRestructureRejectRequest._();
  LoanRestructureRejectRequest createEmptyInstance() => create();
  static $pb.PbList<LoanRestructureRejectRequest> createRepeated() => $pb.PbList<LoanRestructureRejectRequest>();
  @$core.pragma('dart2js:noInline')
  static LoanRestructureRejectRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanRestructureRejectRequest>(create);
  static LoanRestructureRejectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => clearField(2);
}

class LoanRestructureRejectResponse extends $pb.GeneratedMessage {
  factory LoanRestructureRejectResponse({
    LoanRestructureObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  LoanRestructureRejectResponse._() : super();
  factory LoanRestructureRejectResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanRestructureRejectResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanRestructureRejectResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<LoanRestructureObject>(1, _omitFieldNames ? '' : 'data', subBuilder: LoanRestructureObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanRestructureRejectResponse clone() => LoanRestructureRejectResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanRestructureRejectResponse copyWith(void Function(LoanRestructureRejectResponse) updates) => super.copyWith((message) => updates(message as LoanRestructureRejectResponse)) as LoanRestructureRejectResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanRestructureRejectResponse create() => LoanRestructureRejectResponse._();
  LoanRestructureRejectResponse createEmptyInstance() => create();
  static $pb.PbList<LoanRestructureRejectResponse> createRepeated() => $pb.PbList<LoanRestructureRejectResponse>();
  @$core.pragma('dart2js:noInline')
  static LoanRestructureRejectResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanRestructureRejectResponse>(create);
  static LoanRestructureRejectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LoanRestructureObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(LoanRestructureObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  LoanRestructureObject ensureData() => $_ensure(0);
}

class LoanRestructureSearchRequest extends $pb.GeneratedMessage {
  factory LoanRestructureSearchRequest({
    $core.String? loanAccountId,
    $7.PageCursor? cursor,
  }) {
    final $result = create();
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (cursor != null) {
      $result.cursor = cursor;
    }
    return $result;
  }
  LoanRestructureSearchRequest._() : super();
  factory LoanRestructureSearchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanRestructureSearchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanRestructureSearchRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'loanAccountId')
    ..aOM<$7.PageCursor>(2, _omitFieldNames ? '' : 'cursor', subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanRestructureSearchRequest clone() => LoanRestructureSearchRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanRestructureSearchRequest copyWith(void Function(LoanRestructureSearchRequest) updates) => super.copyWith((message) => updates(message as LoanRestructureSearchRequest)) as LoanRestructureSearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanRestructureSearchRequest create() => LoanRestructureSearchRequest._();
  LoanRestructureSearchRequest createEmptyInstance() => create();
  static $pb.PbList<LoanRestructureSearchRequest> createRepeated() => $pb.PbList<LoanRestructureSearchRequest>();
  @$core.pragma('dart2js:noInline')
  static LoanRestructureSearchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanRestructureSearchRequest>(create);
  static LoanRestructureSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get loanAccountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set loanAccountId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLoanAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoanAccountId() => clearField(1);

  @$pb.TagNumber(2)
  $7.PageCursor get cursor => $_getN(1);
  @$pb.TagNumber(2)
  set cursor($7.PageCursor v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearCursor() => clearField(2);
  @$pb.TagNumber(2)
  $7.PageCursor ensureCursor() => $_ensure(1);
}

class LoanRestructureSearchResponse extends $pb.GeneratedMessage {
  factory LoanRestructureSearchResponse({
    $core.Iterable<LoanRestructureObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  LoanRestructureSearchResponse._() : super();
  factory LoanRestructureSearchResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanRestructureSearchResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanRestructureSearchResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..pc<LoanRestructureObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: LoanRestructureObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanRestructureSearchResponse clone() => LoanRestructureSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanRestructureSearchResponse copyWith(void Function(LoanRestructureSearchResponse) updates) => super.copyWith((message) => updates(message as LoanRestructureSearchResponse)) as LoanRestructureSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanRestructureSearchResponse create() => LoanRestructureSearchResponse._();
  LoanRestructureSearchResponse createEmptyInstance() => create();
  static $pb.PbList<LoanRestructureSearchResponse> createRepeated() => $pb.PbList<LoanRestructureSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static LoanRestructureSearchResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanRestructureSearchResponse>(create);
  static LoanRestructureSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<LoanRestructureObject> get data => $_getList(0);
}

class LoanStatementRequest extends $pb.GeneratedMessage {
  factory LoanStatementRequest({
    $core.String? loanAccountId,
    $core.String? fromDate,
    $core.String? toDate,
  }) {
    final $result = create();
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (fromDate != null) {
      $result.fromDate = fromDate;
    }
    if (toDate != null) {
      $result.toDate = toDate;
    }
    return $result;
  }
  LoanStatementRequest._() : super();
  factory LoanStatementRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanStatementRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanStatementRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'loanAccountId')
    ..aOS(2, _omitFieldNames ? '' : 'fromDate')
    ..aOS(3, _omitFieldNames ? '' : 'toDate')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanStatementRequest clone() => LoanStatementRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanStatementRequest copyWith(void Function(LoanStatementRequest) updates) => super.copyWith((message) => updates(message as LoanStatementRequest)) as LoanStatementRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanStatementRequest create() => LoanStatementRequest._();
  LoanStatementRequest createEmptyInstance() => create();
  static $pb.PbList<LoanStatementRequest> createRepeated() => $pb.PbList<LoanStatementRequest>();
  @$core.pragma('dart2js:noInline')
  static LoanStatementRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanStatementRequest>(create);
  static LoanStatementRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get loanAccountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set loanAccountId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLoanAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoanAccountId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get fromDate => $_getSZ(1);
  @$pb.TagNumber(2)
  set fromDate($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFromDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromDate() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get toDate => $_getSZ(2);
  @$pb.TagNumber(3)
  set toDate($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasToDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearToDate() => clearField(3);
}

class LoanStatementResponse extends $pb.GeneratedMessage {
  factory LoanStatementResponse({
    LoanAccountObject? loan,
    LoanBalanceObject? balance,
    $core.Iterable<LoanStatementEntry>? entries,
  }) {
    final $result = create();
    if (loan != null) {
      $result.loan = loan;
    }
    if (balance != null) {
      $result.balance = balance;
    }
    if (entries != null) {
      $result.entries.addAll(entries);
    }
    return $result;
  }
  LoanStatementResponse._() : super();
  factory LoanStatementResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanStatementResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanStatementResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<LoanAccountObject>(1, _omitFieldNames ? '' : 'loan', subBuilder: LoanAccountObject.create)
    ..aOM<LoanBalanceObject>(2, _omitFieldNames ? '' : 'balance', subBuilder: LoanBalanceObject.create)
    ..pc<LoanStatementEntry>(3, _omitFieldNames ? '' : 'entries', $pb.PbFieldType.PM, subBuilder: LoanStatementEntry.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanStatementResponse clone() => LoanStatementResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanStatementResponse copyWith(void Function(LoanStatementResponse) updates) => super.copyWith((message) => updates(message as LoanStatementResponse)) as LoanStatementResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanStatementResponse create() => LoanStatementResponse._();
  LoanStatementResponse createEmptyInstance() => create();
  static $pb.PbList<LoanStatementResponse> createRepeated() => $pb.PbList<LoanStatementResponse>();
  @$core.pragma('dart2js:noInline')
  static LoanStatementResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanStatementResponse>(create);
  static LoanStatementResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LoanAccountObject get loan => $_getN(0);
  @$pb.TagNumber(1)
  set loan(LoanAccountObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLoan() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoan() => clearField(1);
  @$pb.TagNumber(1)
  LoanAccountObject ensureLoan() => $_ensure(0);

  @$pb.TagNumber(2)
  LoanBalanceObject get balance => $_getN(1);
  @$pb.TagNumber(2)
  set balance(LoanBalanceObject v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasBalance() => $_has(1);
  @$pb.TagNumber(2)
  void clearBalance() => clearField(2);
  @$pb.TagNumber(2)
  LoanBalanceObject ensureBalance() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.List<LoanStatementEntry> get entries => $_getList(2);
}

class ReconciliationSaveRequest extends $pb.GeneratedMessage {
  factory ReconciliationSaveRequest({
    ReconciliationObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  ReconciliationSaveRequest._() : super();
  factory ReconciliationSaveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReconciliationSaveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReconciliationSaveRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<ReconciliationObject>(1, _omitFieldNames ? '' : 'data', subBuilder: ReconciliationObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReconciliationSaveRequest clone() => ReconciliationSaveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReconciliationSaveRequest copyWith(void Function(ReconciliationSaveRequest) updates) => super.copyWith((message) => updates(message as ReconciliationSaveRequest)) as ReconciliationSaveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReconciliationSaveRequest create() => ReconciliationSaveRequest._();
  ReconciliationSaveRequest createEmptyInstance() => create();
  static $pb.PbList<ReconciliationSaveRequest> createRepeated() => $pb.PbList<ReconciliationSaveRequest>();
  @$core.pragma('dart2js:noInline')
  static ReconciliationSaveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReconciliationSaveRequest>(create);
  static ReconciliationSaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ReconciliationObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(ReconciliationObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  ReconciliationObject ensureData() => $_ensure(0);
}

class ReconciliationSaveResponse extends $pb.GeneratedMessage {
  factory ReconciliationSaveResponse({
    ReconciliationObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  ReconciliationSaveResponse._() : super();
  factory ReconciliationSaveResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReconciliationSaveResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReconciliationSaveResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<ReconciliationObject>(1, _omitFieldNames ? '' : 'data', subBuilder: ReconciliationObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReconciliationSaveResponse clone() => ReconciliationSaveResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReconciliationSaveResponse copyWith(void Function(ReconciliationSaveResponse) updates) => super.copyWith((message) => updates(message as ReconciliationSaveResponse)) as ReconciliationSaveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReconciliationSaveResponse create() => ReconciliationSaveResponse._();
  ReconciliationSaveResponse createEmptyInstance() => create();
  static $pb.PbList<ReconciliationSaveResponse> createRepeated() => $pb.PbList<ReconciliationSaveResponse>();
  @$core.pragma('dart2js:noInline')
  static ReconciliationSaveResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReconciliationSaveResponse>(create);
  static ReconciliationSaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReconciliationObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(ReconciliationObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  ReconciliationObject ensureData() => $_ensure(0);
}

class ReconciliationSearchRequest extends $pb.GeneratedMessage {
  factory ReconciliationSearchRequest({
    $core.String? loanAccountId,
    ReconciliationStatus? status,
    $7.PageCursor? cursor,
  }) {
    final $result = create();
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (status != null) {
      $result.status = status;
    }
    if (cursor != null) {
      $result.cursor = cursor;
    }
    return $result;
  }
  ReconciliationSearchRequest._() : super();
  factory ReconciliationSearchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReconciliationSearchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReconciliationSearchRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'loanAccountId')
    ..e<ReconciliationStatus>(2, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: ReconciliationStatus.RECONCILIATION_STATUS_UNSPECIFIED, valueOf: ReconciliationStatus.valueOf, enumValues: ReconciliationStatus.values)
    ..aOM<$7.PageCursor>(3, _omitFieldNames ? '' : 'cursor', subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReconciliationSearchRequest clone() => ReconciliationSearchRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReconciliationSearchRequest copyWith(void Function(ReconciliationSearchRequest) updates) => super.copyWith((message) => updates(message as ReconciliationSearchRequest)) as ReconciliationSearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReconciliationSearchRequest create() => ReconciliationSearchRequest._();
  ReconciliationSearchRequest createEmptyInstance() => create();
  static $pb.PbList<ReconciliationSearchRequest> createRepeated() => $pb.PbList<ReconciliationSearchRequest>();
  @$core.pragma('dart2js:noInline')
  static ReconciliationSearchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReconciliationSearchRequest>(create);
  static ReconciliationSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get loanAccountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set loanAccountId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLoanAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoanAccountId() => clearField(1);

  @$pb.TagNumber(2)
  ReconciliationStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(ReconciliationStatus v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);

  @$pb.TagNumber(3)
  $7.PageCursor get cursor => $_getN(2);
  @$pb.TagNumber(3)
  set cursor($7.PageCursor v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCursor() => $_has(2);
  @$pb.TagNumber(3)
  void clearCursor() => clearField(3);
  @$pb.TagNumber(3)
  $7.PageCursor ensureCursor() => $_ensure(2);
}

class ReconciliationSearchResponse extends $pb.GeneratedMessage {
  factory ReconciliationSearchResponse({
    $core.Iterable<ReconciliationObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  ReconciliationSearchResponse._() : super();
  factory ReconciliationSearchResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReconciliationSearchResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReconciliationSearchResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..pc<ReconciliationObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: ReconciliationObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReconciliationSearchResponse clone() => ReconciliationSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReconciliationSearchResponse copyWith(void Function(ReconciliationSearchResponse) updates) => super.copyWith((message) => updates(message as ReconciliationSearchResponse)) as ReconciliationSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReconciliationSearchResponse create() => ReconciliationSearchResponse._();
  ReconciliationSearchResponse createEmptyInstance() => create();
  static $pb.PbList<ReconciliationSearchResponse> createRepeated() => $pb.PbList<ReconciliationSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static ReconciliationSearchResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReconciliationSearchResponse>(create);
  static ReconciliationSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ReconciliationObject> get data => $_getList(0);
}

class InitiateCollectionRequest extends $pb.GeneratedMessage {
  factory InitiateCollectionRequest({
    $core.String? loanAccountId,
    $core.String? amount,
    $core.String? phoneNumber,
    $core.String? idempotencyKey,
  }) {
    final $result = create();
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (phoneNumber != null) {
      $result.phoneNumber = phoneNumber;
    }
    if (idempotencyKey != null) {
      $result.idempotencyKey = idempotencyKey;
    }
    return $result;
  }
  InitiateCollectionRequest._() : super();
  factory InitiateCollectionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InitiateCollectionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'InitiateCollectionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'loanAccountId')
    ..aOS(2, _omitFieldNames ? '' : 'amount')
    ..aOS(3, _omitFieldNames ? '' : 'phoneNumber')
    ..aOS(4, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InitiateCollectionRequest clone() => InitiateCollectionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InitiateCollectionRequest copyWith(void Function(InitiateCollectionRequest) updates) => super.copyWith((message) => updates(message as InitiateCollectionRequest)) as InitiateCollectionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InitiateCollectionRequest create() => InitiateCollectionRequest._();
  InitiateCollectionRequest createEmptyInstance() => create();
  static $pb.PbList<InitiateCollectionRequest> createRepeated() => $pb.PbList<InitiateCollectionRequest>();
  @$core.pragma('dart2js:noInline')
  static InitiateCollectionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InitiateCollectionRequest>(create);
  static InitiateCollectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get loanAccountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set loanAccountId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLoanAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoanAccountId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get amount => $_getSZ(1);
  @$pb.TagNumber(2)
  set amount($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get phoneNumber => $_getSZ(2);
  @$pb.TagNumber(3)
  set phoneNumber($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPhoneNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhoneNumber() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get idempotencyKey => $_getSZ(3);
  @$pb.TagNumber(4)
  set idempotencyKey($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIdempotencyKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearIdempotencyKey() => clearField(4);
}

class InitiateCollectionResponse extends $pb.GeneratedMessage {
  factory InitiateCollectionResponse({
    $core.String? paymentPromptId,
    $core.String? status,
  }) {
    final $result = create();
    if (paymentPromptId != null) {
      $result.paymentPromptId = paymentPromptId;
    }
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  InitiateCollectionResponse._() : super();
  factory InitiateCollectionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InitiateCollectionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'InitiateCollectionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'paymentPromptId')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InitiateCollectionResponse clone() => InitiateCollectionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InitiateCollectionResponse copyWith(void Function(InitiateCollectionResponse) updates) => super.copyWith((message) => updates(message as InitiateCollectionResponse)) as InitiateCollectionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InitiateCollectionResponse create() => InitiateCollectionResponse._();
  InitiateCollectionResponse createEmptyInstance() => create();
  static $pb.PbList<InitiateCollectionResponse> createRepeated() => $pb.PbList<InitiateCollectionResponse>();
  @$core.pragma('dart2js:noInline')
  static InitiateCollectionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InitiateCollectionResponse>(create);
  static InitiateCollectionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get paymentPromptId => $_getSZ(0);
  @$pb.TagNumber(1)
  set paymentPromptId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPaymentPromptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaymentPromptId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);
}

class LoanStatusChangeSearchRequest extends $pb.GeneratedMessage {
  factory LoanStatusChangeSearchRequest({
    $core.String? loanAccountId,
    $7.PageCursor? cursor,
  }) {
    final $result = create();
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (cursor != null) {
      $result.cursor = cursor;
    }
    return $result;
  }
  LoanStatusChangeSearchRequest._() : super();
  factory LoanStatusChangeSearchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanStatusChangeSearchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanStatusChangeSearchRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'loanAccountId')
    ..aOM<$7.PageCursor>(2, _omitFieldNames ? '' : 'cursor', subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanStatusChangeSearchRequest clone() => LoanStatusChangeSearchRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanStatusChangeSearchRequest copyWith(void Function(LoanStatusChangeSearchRequest) updates) => super.copyWith((message) => updates(message as LoanStatusChangeSearchRequest)) as LoanStatusChangeSearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanStatusChangeSearchRequest create() => LoanStatusChangeSearchRequest._();
  LoanStatusChangeSearchRequest createEmptyInstance() => create();
  static $pb.PbList<LoanStatusChangeSearchRequest> createRepeated() => $pb.PbList<LoanStatusChangeSearchRequest>();
  @$core.pragma('dart2js:noInline')
  static LoanStatusChangeSearchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanStatusChangeSearchRequest>(create);
  static LoanStatusChangeSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get loanAccountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set loanAccountId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLoanAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoanAccountId() => clearField(1);

  @$pb.TagNumber(2)
  $7.PageCursor get cursor => $_getN(1);
  @$pb.TagNumber(2)
  set cursor($7.PageCursor v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearCursor() => clearField(2);
  @$pb.TagNumber(2)
  $7.PageCursor ensureCursor() => $_ensure(1);
}

class LoanStatusChangeSearchResponse extends $pb.GeneratedMessage {
  factory LoanStatusChangeSearchResponse({
    $core.Iterable<LoanStatusChangeObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  LoanStatusChangeSearchResponse._() : super();
  factory LoanStatusChangeSearchResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanStatusChangeSearchResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanStatusChangeSearchResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..pc<LoanStatusChangeObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: LoanStatusChangeObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanStatusChangeSearchResponse clone() => LoanStatusChangeSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanStatusChangeSearchResponse copyWith(void Function(LoanStatusChangeSearchResponse) updates) => super.copyWith((message) => updates(message as LoanStatusChangeSearchResponse)) as LoanStatusChangeSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanStatusChangeSearchResponse create() => LoanStatusChangeSearchResponse._();
  LoanStatusChangeSearchResponse createEmptyInstance() => create();
  static $pb.PbList<LoanStatusChangeSearchResponse> createRepeated() => $pb.PbList<LoanStatusChangeSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static LoanStatusChangeSearchResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanStatusChangeSearchResponse>(create);
  static LoanStatusChangeSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<LoanStatusChangeObject> get data => $_getList(0);
}

/// LoanRequestRequest is the client-facing API for direct client loan requests.
/// Clients call this from app/USSD. The system validates eligibility, runs
/// automated risk checks, and routes to the responsible agent for approval.
class LoanRequestRequest extends $pb.GeneratedMessage {
  factory LoanRequestRequest({
    $core.String? clientId,
    $core.String? productId,
    $9.Money? requestedAmount,
    $core.int? requestedTermDays,
    $core.String? purpose,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (clientId != null) {
      $result.clientId = clientId;
    }
    if (productId != null) {
      $result.productId = productId;
    }
    if (requestedAmount != null) {
      $result.requestedAmount = requestedAmount;
    }
    if (requestedTermDays != null) {
      $result.requestedTermDays = requestedTermDays;
    }
    if (purpose != null) {
      $result.purpose = purpose;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  LoanRequestRequest._() : super();
  factory LoanRequestRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanRequestRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanRequestRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientId')
    ..aOS(2, _omitFieldNames ? '' : 'productId')
    ..aOM<$9.Money>(3, _omitFieldNames ? '' : 'requestedAmount', subBuilder: $9.Money.create)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'requestedTermDays', $pb.PbFieldType.O3)
    ..aOS(6, _omitFieldNames ? '' : 'purpose')
    ..aOM<$6.Struct>(7, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanRequestRequest clone() => LoanRequestRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanRequestRequest copyWith(void Function(LoanRequestRequest) updates) => super.copyWith((message) => updates(message as LoanRequestRequest)) as LoanRequestRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanRequestRequest create() => LoanRequestRequest._();
  LoanRequestRequest createEmptyInstance() => create();
  static $pb.PbList<LoanRequestRequest> createRepeated() => $pb.PbList<LoanRequestRequest>();
  @$core.pragma('dart2js:noInline')
  static LoanRequestRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanRequestRequest>(create);
  static LoanRequestRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get productId => $_getSZ(1);
  @$pb.TagNumber(2)
  set productId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProductId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductId() => clearField(2);

  @$pb.TagNumber(3)
  $9.Money get requestedAmount => $_getN(2);
  @$pb.TagNumber(3)
  set requestedAmount($9.Money v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasRequestedAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequestedAmount() => clearField(3);
  @$pb.TagNumber(3)
  $9.Money ensureRequestedAmount() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get requestedTermDays => $_getIZ(3);
  @$pb.TagNumber(4)
  set requestedTermDays($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRequestedTermDays() => $_has(3);
  @$pb.TagNumber(4)
  void clearRequestedTermDays() => clearField(4);

  /// Field 5 removed (currency_code now in Money).
  @$pb.TagNumber(6)
  $core.String get purpose => $_getSZ(4);
  @$pb.TagNumber(6)
  set purpose($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasPurpose() => $_has(4);
  @$pb.TagNumber(6)
  void clearPurpose() => clearField(6);

  @$pb.TagNumber(7)
  $6.Struct get properties => $_getN(5);
  @$pb.TagNumber(7)
  set properties($6.Struct v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasProperties() => $_has(5);
  @$pb.TagNumber(7)
  void clearProperties() => clearField(7);
  @$pb.TagNumber(7)
  $6.Struct ensureProperties() => $_ensure(5);
}

class LoanRequestResponse extends $pb.GeneratedMessage {
  factory LoanRequestResponse({
    $core.String? requestId,
    $core.String? status,
    $core.bool? riskAssessmentPassed,
    $core.String? message,
  }) {
    final $result = create();
    if (requestId != null) {
      $result.requestId = requestId;
    }
    if (status != null) {
      $result.status = status;
    }
    if (riskAssessmentPassed != null) {
      $result.riskAssessmentPassed = riskAssessmentPassed;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  LoanRequestResponse._() : super();
  factory LoanRequestResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanRequestResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanRequestResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aOB(3, _omitFieldNames ? '' : 'riskAssessmentPassed')
    ..aOS(4, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanRequestResponse clone() => LoanRequestResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanRequestResponse copyWith(void Function(LoanRequestResponse) updates) => super.copyWith((message) => updates(message as LoanRequestResponse)) as LoanRequestResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanRequestResponse create() => LoanRequestResponse._();
  LoanRequestResponse createEmptyInstance() => create();
  static $pb.PbList<LoanRequestResponse> createRepeated() => $pb.PbList<LoanRequestResponse>();
  @$core.pragma('dart2js:noInline')
  static LoanRequestResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanRequestResponse>(create);
  static LoanRequestResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get riskAssessmentPassed => $_getBF(2);
  @$pb.TagNumber(3)
  set riskAssessmentPassed($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRiskAssessmentPassed() => $_has(2);
  @$pb.TagNumber(3)
  void clearRiskAssessmentPassed() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get message => $_getSZ(3);
  @$pb.TagNumber(4)
  set message($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessage() => clearField(4);
}

/// PortfolioSummary provides aggregate financial metrics across a filtered set of loans.
class PortfolioSummary extends $pb.GeneratedMessage {
  factory PortfolioSummary({
    $core.int? totalLoans,
    $core.int? activeLoans,
    $core.int? delinquentLoans,
    $core.int? defaultLoans,
    $core.int? paidOffLoans,
    $core.int? writtenOffLoans,
    $9.Money? totalDisbursed,
    $9.Money? totalOutstanding,
    $9.Money? totalCollected,
    $9.Money? principalOutstanding,
    $9.Money? interestOutstanding,
    $9.Money? feesOutstanding,
    $9.Money? penaltiesOutstanding,
    $core.String? currencyCode,
    $core.String? collectionRate,
    $core.String? par30,
  }) {
    final $result = create();
    if (totalLoans != null) {
      $result.totalLoans = totalLoans;
    }
    if (activeLoans != null) {
      $result.activeLoans = activeLoans;
    }
    if (delinquentLoans != null) {
      $result.delinquentLoans = delinquentLoans;
    }
    if (defaultLoans != null) {
      $result.defaultLoans = defaultLoans;
    }
    if (paidOffLoans != null) {
      $result.paidOffLoans = paidOffLoans;
    }
    if (writtenOffLoans != null) {
      $result.writtenOffLoans = writtenOffLoans;
    }
    if (totalDisbursed != null) {
      $result.totalDisbursed = totalDisbursed;
    }
    if (totalOutstanding != null) {
      $result.totalOutstanding = totalOutstanding;
    }
    if (totalCollected != null) {
      $result.totalCollected = totalCollected;
    }
    if (principalOutstanding != null) {
      $result.principalOutstanding = principalOutstanding;
    }
    if (interestOutstanding != null) {
      $result.interestOutstanding = interestOutstanding;
    }
    if (feesOutstanding != null) {
      $result.feesOutstanding = feesOutstanding;
    }
    if (penaltiesOutstanding != null) {
      $result.penaltiesOutstanding = penaltiesOutstanding;
    }
    if (currencyCode != null) {
      $result.currencyCode = currencyCode;
    }
    if (collectionRate != null) {
      $result.collectionRate = collectionRate;
    }
    if (par30 != null) {
      $result.par30 = par30;
    }
    return $result;
  }
  PortfolioSummary._() : super();
  factory PortfolioSummary.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PortfolioSummary.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PortfolioSummary', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'totalLoans', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'activeLoans', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'delinquentLoans', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'defaultLoans', $pb.PbFieldType.O3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'paidOffLoans', $pb.PbFieldType.O3)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'writtenOffLoans', $pb.PbFieldType.O3)
    ..aOM<$9.Money>(7, _omitFieldNames ? '' : 'totalDisbursed', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(8, _omitFieldNames ? '' : 'totalOutstanding', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(9, _omitFieldNames ? '' : 'totalCollected', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(10, _omitFieldNames ? '' : 'principalOutstanding', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(11, _omitFieldNames ? '' : 'interestOutstanding', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(12, _omitFieldNames ? '' : 'feesOutstanding', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(13, _omitFieldNames ? '' : 'penaltiesOutstanding', subBuilder: $9.Money.create)
    ..aOS(14, _omitFieldNames ? '' : 'currencyCode')
    ..aOS(15, _omitFieldNames ? '' : 'collectionRate')
    ..aOS(16, _omitFieldNames ? '' : 'par30', protoName: 'par_30')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PortfolioSummary clone() => PortfolioSummary()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PortfolioSummary copyWith(void Function(PortfolioSummary) updates) => super.copyWith((message) => updates(message as PortfolioSummary)) as PortfolioSummary;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PortfolioSummary create() => PortfolioSummary._();
  PortfolioSummary createEmptyInstance() => create();
  static $pb.PbList<PortfolioSummary> createRepeated() => $pb.PbList<PortfolioSummary>();
  @$core.pragma('dart2js:noInline')
  static PortfolioSummary getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PortfolioSummary>(create);
  static PortfolioSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalLoans => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalLoans($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTotalLoans() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalLoans() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get activeLoans => $_getIZ(1);
  @$pb.TagNumber(2)
  set activeLoans($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasActiveLoans() => $_has(1);
  @$pb.TagNumber(2)
  void clearActiveLoans() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get delinquentLoans => $_getIZ(2);
  @$pb.TagNumber(3)
  set delinquentLoans($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDelinquentLoans() => $_has(2);
  @$pb.TagNumber(3)
  void clearDelinquentLoans() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get defaultLoans => $_getIZ(3);
  @$pb.TagNumber(4)
  set defaultLoans($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDefaultLoans() => $_has(3);
  @$pb.TagNumber(4)
  void clearDefaultLoans() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get paidOffLoans => $_getIZ(4);
  @$pb.TagNumber(5)
  set paidOffLoans($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPaidOffLoans() => $_has(4);
  @$pb.TagNumber(5)
  void clearPaidOffLoans() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get writtenOffLoans => $_getIZ(5);
  @$pb.TagNumber(6)
  set writtenOffLoans($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasWrittenOffLoans() => $_has(5);
  @$pb.TagNumber(6)
  void clearWrittenOffLoans() => clearField(6);

  @$pb.TagNumber(7)
  $9.Money get totalDisbursed => $_getN(6);
  @$pb.TagNumber(7)
  set totalDisbursed($9.Money v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasTotalDisbursed() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalDisbursed() => clearField(7);
  @$pb.TagNumber(7)
  $9.Money ensureTotalDisbursed() => $_ensure(6);

  @$pb.TagNumber(8)
  $9.Money get totalOutstanding => $_getN(7);
  @$pb.TagNumber(8)
  set totalOutstanding($9.Money v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasTotalOutstanding() => $_has(7);
  @$pb.TagNumber(8)
  void clearTotalOutstanding() => clearField(8);
  @$pb.TagNumber(8)
  $9.Money ensureTotalOutstanding() => $_ensure(7);

  @$pb.TagNumber(9)
  $9.Money get totalCollected => $_getN(8);
  @$pb.TagNumber(9)
  set totalCollected($9.Money v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasTotalCollected() => $_has(8);
  @$pb.TagNumber(9)
  void clearTotalCollected() => clearField(9);
  @$pb.TagNumber(9)
  $9.Money ensureTotalCollected() => $_ensure(8);

  @$pb.TagNumber(10)
  $9.Money get principalOutstanding => $_getN(9);
  @$pb.TagNumber(10)
  set principalOutstanding($9.Money v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasPrincipalOutstanding() => $_has(9);
  @$pb.TagNumber(10)
  void clearPrincipalOutstanding() => clearField(10);
  @$pb.TagNumber(10)
  $9.Money ensurePrincipalOutstanding() => $_ensure(9);

  @$pb.TagNumber(11)
  $9.Money get interestOutstanding => $_getN(10);
  @$pb.TagNumber(11)
  set interestOutstanding($9.Money v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasInterestOutstanding() => $_has(10);
  @$pb.TagNumber(11)
  void clearInterestOutstanding() => clearField(11);
  @$pb.TagNumber(11)
  $9.Money ensureInterestOutstanding() => $_ensure(10);

  @$pb.TagNumber(12)
  $9.Money get feesOutstanding => $_getN(11);
  @$pb.TagNumber(12)
  set feesOutstanding($9.Money v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasFeesOutstanding() => $_has(11);
  @$pb.TagNumber(12)
  void clearFeesOutstanding() => clearField(12);
  @$pb.TagNumber(12)
  $9.Money ensureFeesOutstanding() => $_ensure(11);

  @$pb.TagNumber(13)
  $9.Money get penaltiesOutstanding => $_getN(12);
  @$pb.TagNumber(13)
  set penaltiesOutstanding($9.Money v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasPenaltiesOutstanding() => $_has(12);
  @$pb.TagNumber(13)
  void clearPenaltiesOutstanding() => clearField(13);
  @$pb.TagNumber(13)
  $9.Money ensurePenaltiesOutstanding() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get currencyCode => $_getSZ(13);
  @$pb.TagNumber(14)
  set currencyCode($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasCurrencyCode() => $_has(13);
  @$pb.TagNumber(14)
  void clearCurrencyCode() => clearField(14);

  /// collection_rate is total_collected / total_disbursed as a percentage string (e.g. "85.50").
  @$pb.TagNumber(15)
  $core.String get collectionRate => $_getSZ(14);
  @$pb.TagNumber(15)
  set collectionRate($core.String v) { $_setString(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasCollectionRate() => $_has(14);
  @$pb.TagNumber(15)
  void clearCollectionRate() => clearField(15);

  /// par_30 is portfolio-at-risk > 30 days as a percentage string (e.g. "12.30").
  @$pb.TagNumber(16)
  $core.String get par30 => $_getSZ(15);
  @$pb.TagNumber(16)
  set par30($core.String v) { $_setString(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasPar30() => $_has(15);
  @$pb.TagNumber(16)
  void clearPar30() => clearField(16);
}

class PortfolioSummaryRequest extends $pb.GeneratedMessage {
  factory PortfolioSummaryRequest({
    $core.String? organizationId,
    $core.String? branchId,
    $core.String? agentId,
    $core.String? productId,
    $core.String? clientId,
    $core.String? currencyCode,
  }) {
    final $result = create();
    if (organizationId != null) {
      $result.organizationId = organizationId;
    }
    if (branchId != null) {
      $result.branchId = branchId;
    }
    if (agentId != null) {
      $result.agentId = agentId;
    }
    if (productId != null) {
      $result.productId = productId;
    }
    if (clientId != null) {
      $result.clientId = clientId;
    }
    if (currencyCode != null) {
      $result.currencyCode = currencyCode;
    }
    return $result;
  }
  PortfolioSummaryRequest._() : super();
  factory PortfolioSummaryRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PortfolioSummaryRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PortfolioSummaryRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'organizationId')
    ..aOS(2, _omitFieldNames ? '' : 'branchId')
    ..aOS(3, _omitFieldNames ? '' : 'agentId')
    ..aOS(4, _omitFieldNames ? '' : 'productId')
    ..aOS(5, _omitFieldNames ? '' : 'clientId')
    ..aOS(6, _omitFieldNames ? '' : 'currencyCode')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PortfolioSummaryRequest clone() => PortfolioSummaryRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PortfolioSummaryRequest copyWith(void Function(PortfolioSummaryRequest) updates) => super.copyWith((message) => updates(message as PortfolioSummaryRequest)) as PortfolioSummaryRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PortfolioSummaryRequest create() => PortfolioSummaryRequest._();
  PortfolioSummaryRequest createEmptyInstance() => create();
  static $pb.PbList<PortfolioSummaryRequest> createRepeated() => $pb.PbList<PortfolioSummaryRequest>();
  @$core.pragma('dart2js:noInline')
  static PortfolioSummaryRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PortfolioSummaryRequest>(create);
  static PortfolioSummaryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get organizationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set organizationId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrganizationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrganizationId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get branchId => $_getSZ(1);
  @$pb.TagNumber(2)
  set branchId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBranchId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBranchId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get agentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set agentId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAgentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAgentId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get productId => $_getSZ(3);
  @$pb.TagNumber(4)
  set productId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasProductId() => $_has(3);
  @$pb.TagNumber(4)
  void clearProductId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get clientId => $_getSZ(4);
  @$pb.TagNumber(5)
  set clientId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasClientId() => $_has(4);
  @$pb.TagNumber(5)
  void clearClientId() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get currencyCode => $_getSZ(5);
  @$pb.TagNumber(6)
  set currencyCode($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCurrencyCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrencyCode() => clearField(6);
}

class PortfolioSummaryResponse extends $pb.GeneratedMessage {
  factory PortfolioSummaryResponse({
    PortfolioSummary? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  PortfolioSummaryResponse._() : super();
  factory PortfolioSummaryResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PortfolioSummaryResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PortfolioSummaryResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOM<PortfolioSummary>(1, _omitFieldNames ? '' : 'data', subBuilder: PortfolioSummary.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PortfolioSummaryResponse clone() => PortfolioSummaryResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PortfolioSummaryResponse copyWith(void Function(PortfolioSummaryResponse) updates) => super.copyWith((message) => updates(message as PortfolioSummaryResponse)) as PortfolioSummaryResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PortfolioSummaryResponse create() => PortfolioSummaryResponse._();
  PortfolioSummaryResponse createEmptyInstance() => create();
  static $pb.PbList<PortfolioSummaryResponse> createRepeated() => $pb.PbList<PortfolioSummaryResponse>();
  @$core.pragma('dart2js:noInline')
  static PortfolioSummaryResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PortfolioSummaryResponse>(create);
  static PortfolioSummaryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PortfolioSummary get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(PortfolioSummary v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  PortfolioSummary ensureData() => $_ensure(0);
}

class PortfolioExportRequest extends $pb.GeneratedMessage {
  factory PortfolioExportRequest({
    $core.String? organizationId,
    $core.String? branchId,
    $core.String? agentId,
    $core.String? productId,
    $core.String? clientId,
    $core.String? currencyCode,
    $core.String? format,
  }) {
    final $result = create();
    if (organizationId != null) {
      $result.organizationId = organizationId;
    }
    if (branchId != null) {
      $result.branchId = branchId;
    }
    if (agentId != null) {
      $result.agentId = agentId;
    }
    if (productId != null) {
      $result.productId = productId;
    }
    if (clientId != null) {
      $result.clientId = clientId;
    }
    if (currencyCode != null) {
      $result.currencyCode = currencyCode;
    }
    if (format != null) {
      $result.format = format;
    }
    return $result;
  }
  PortfolioExportRequest._() : super();
  factory PortfolioExportRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PortfolioExportRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PortfolioExportRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'organizationId')
    ..aOS(2, _omitFieldNames ? '' : 'branchId')
    ..aOS(3, _omitFieldNames ? '' : 'agentId')
    ..aOS(4, _omitFieldNames ? '' : 'productId')
    ..aOS(5, _omitFieldNames ? '' : 'clientId')
    ..aOS(6, _omitFieldNames ? '' : 'currencyCode')
    ..aOS(7, _omitFieldNames ? '' : 'format')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PortfolioExportRequest clone() => PortfolioExportRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PortfolioExportRequest copyWith(void Function(PortfolioExportRequest) updates) => super.copyWith((message) => updates(message as PortfolioExportRequest)) as PortfolioExportRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PortfolioExportRequest create() => PortfolioExportRequest._();
  PortfolioExportRequest createEmptyInstance() => create();
  static $pb.PbList<PortfolioExportRequest> createRepeated() => $pb.PbList<PortfolioExportRequest>();
  @$core.pragma('dart2js:noInline')
  static PortfolioExportRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PortfolioExportRequest>(create);
  static PortfolioExportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get organizationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set organizationId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrganizationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrganizationId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get branchId => $_getSZ(1);
  @$pb.TagNumber(2)
  set branchId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBranchId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBranchId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get agentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set agentId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAgentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAgentId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get productId => $_getSZ(3);
  @$pb.TagNumber(4)
  set productId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasProductId() => $_has(3);
  @$pb.TagNumber(4)
  void clearProductId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get clientId => $_getSZ(4);
  @$pb.TagNumber(5)
  set clientId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasClientId() => $_has(4);
  @$pb.TagNumber(5)
  void clearClientId() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get currencyCode => $_getSZ(5);
  @$pb.TagNumber(6)
  set currencyCode($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCurrencyCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrencyCode() => clearField(6);

  /// format is the export format: "CSV" (default).
  @$pb.TagNumber(7)
  $core.String get format => $_getSZ(6);
  @$pb.TagNumber(7)
  set format($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasFormat() => $_has(6);
  @$pb.TagNumber(7)
  void clearFormat() => clearField(7);
}

class PortfolioExportResponse extends $pb.GeneratedMessage {
  factory PortfolioExportResponse({
    $core.List<$core.int>? data,
    $core.String? filename,
    $core.String? contentType,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    if (filename != null) {
      $result.filename = filename;
    }
    if (contentType != null) {
      $result.contentType = contentType;
    }
    return $result;
  }
  PortfolioExportResponse._() : super();
  factory PortfolioExportResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PortfolioExportResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PortfolioExportResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'loans.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'filename')
    ..aOS(3, _omitFieldNames ? '' : 'contentType')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PortfolioExportResponse clone() => PortfolioExportResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PortfolioExportResponse copyWith(void Function(PortfolioExportResponse) updates) => super.copyWith((message) => updates(message as PortfolioExportResponse)) as PortfolioExportResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PortfolioExportResponse create() => PortfolioExportResponse._();
  PortfolioExportResponse createEmptyInstance() => create();
  static $pb.PbList<PortfolioExportResponse> createRepeated() => $pb.PbList<PortfolioExportResponse>();
  @$core.pragma('dart2js:noInline')
  static PortfolioExportResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PortfolioExportResponse>(create);
  static PortfolioExportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get filename => $_getSZ(1);
  @$pb.TagNumber(2)
  set filename($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFilename() => $_has(1);
  @$pb.TagNumber(2)
  void clearFilename() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get contentType => $_getSZ(2);
  @$pb.TagNumber(3)
  set contentType($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasContentType() => $_has(2);
  @$pb.TagNumber(3)
  void clearContentType() => clearField(3);
}

class LoanManagementServiceApi {
  $pb.RpcClient _client;
  LoanManagementServiceApi(this._client);

  $async.Future<LoanAccountCreateResponse> loanAccountCreate($pb.ClientContext? ctx, LoanAccountCreateRequest request) =>
    _client.invoke<LoanAccountCreateResponse>(ctx, 'LoanManagementService', 'LoanAccountCreate', request, LoanAccountCreateResponse())
  ;
  $async.Future<LoanAccountGetResponse> loanAccountGet($pb.ClientContext? ctx, LoanAccountGetRequest request) =>
    _client.invoke<LoanAccountGetResponse>(ctx, 'LoanManagementService', 'LoanAccountGet', request, LoanAccountGetResponse())
  ;
  $async.Future<LoanAccountSearchResponse> loanAccountSearch($pb.ClientContext? ctx, LoanAccountSearchRequest request) =>
    _client.invoke<LoanAccountSearchResponse>(ctx, 'LoanManagementService', 'LoanAccountSearch', request, LoanAccountSearchResponse())
  ;
  $async.Future<LoanBalanceGetResponse> loanBalanceGet($pb.ClientContext? ctx, LoanBalanceGetRequest request) =>
    _client.invoke<LoanBalanceGetResponse>(ctx, 'LoanManagementService', 'LoanBalanceGet', request, LoanBalanceGetResponse())
  ;
  $async.Future<LoanStatementResponse> loanStatement($pb.ClientContext? ctx, LoanStatementRequest request) =>
    _client.invoke<LoanStatementResponse>(ctx, 'LoanManagementService', 'LoanStatement', request, LoanStatementResponse())
  ;
  $async.Future<DisbursementCreateResponse> disbursementCreate($pb.ClientContext? ctx, DisbursementCreateRequest request) =>
    _client.invoke<DisbursementCreateResponse>(ctx, 'LoanManagementService', 'DisbursementCreate', request, DisbursementCreateResponse())
  ;
  $async.Future<DisbursementGetResponse> disbursementGet($pb.ClientContext? ctx, DisbursementGetRequest request) =>
    _client.invoke<DisbursementGetResponse>(ctx, 'LoanManagementService', 'DisbursementGet', request, DisbursementGetResponse())
  ;
  $async.Future<DisbursementSearchResponse> disbursementSearch($pb.ClientContext? ctx, DisbursementSearchRequest request) =>
    _client.invoke<DisbursementSearchResponse>(ctx, 'LoanManagementService', 'DisbursementSearch', request, DisbursementSearchResponse())
  ;
  $async.Future<RepaymentRecordResponse> repaymentRecord($pb.ClientContext? ctx, RepaymentRecordRequest request) =>
    _client.invoke<RepaymentRecordResponse>(ctx, 'LoanManagementService', 'RepaymentRecord', request, RepaymentRecordResponse())
  ;
  $async.Future<RepaymentGetResponse> repaymentGet($pb.ClientContext? ctx, RepaymentGetRequest request) =>
    _client.invoke<RepaymentGetResponse>(ctx, 'LoanManagementService', 'RepaymentGet', request, RepaymentGetResponse())
  ;
  $async.Future<RepaymentSearchResponse> repaymentSearch($pb.ClientContext? ctx, RepaymentSearchRequest request) =>
    _client.invoke<RepaymentSearchResponse>(ctx, 'LoanManagementService', 'RepaymentSearch', request, RepaymentSearchResponse())
  ;
  $async.Future<RepaymentScheduleGetResponse> repaymentScheduleGet($pb.ClientContext? ctx, RepaymentScheduleGetRequest request) =>
    _client.invoke<RepaymentScheduleGetResponse>(ctx, 'LoanManagementService', 'RepaymentScheduleGet', request, RepaymentScheduleGetResponse())
  ;
  $async.Future<PenaltySaveResponse> penaltySave($pb.ClientContext? ctx, PenaltySaveRequest request) =>
    _client.invoke<PenaltySaveResponse>(ctx, 'LoanManagementService', 'PenaltySave', request, PenaltySaveResponse())
  ;
  $async.Future<PenaltyWaiveResponse> penaltyWaive($pb.ClientContext? ctx, PenaltyWaiveRequest request) =>
    _client.invoke<PenaltyWaiveResponse>(ctx, 'LoanManagementService', 'PenaltyWaive', request, PenaltyWaiveResponse())
  ;
  $async.Future<PenaltySearchResponse> penaltySearch($pb.ClientContext? ctx, PenaltySearchRequest request) =>
    _client.invoke<PenaltySearchResponse>(ctx, 'LoanManagementService', 'PenaltySearch', request, PenaltySearchResponse())
  ;
  $async.Future<LoanRestructureCreateResponse> loanRestructureCreate($pb.ClientContext? ctx, LoanRestructureCreateRequest request) =>
    _client.invoke<LoanRestructureCreateResponse>(ctx, 'LoanManagementService', 'LoanRestructureCreate', request, LoanRestructureCreateResponse())
  ;
  $async.Future<LoanRestructureApproveResponse> loanRestructureApprove($pb.ClientContext? ctx, LoanRestructureApproveRequest request) =>
    _client.invoke<LoanRestructureApproveResponse>(ctx, 'LoanManagementService', 'LoanRestructureApprove', request, LoanRestructureApproveResponse())
  ;
  $async.Future<LoanRestructureRejectResponse> loanRestructureReject($pb.ClientContext? ctx, LoanRestructureRejectRequest request) =>
    _client.invoke<LoanRestructureRejectResponse>(ctx, 'LoanManagementService', 'LoanRestructureReject', request, LoanRestructureRejectResponse())
  ;
  $async.Future<LoanRestructureSearchResponse> loanRestructureSearch($pb.ClientContext? ctx, LoanRestructureSearchRequest request) =>
    _client.invoke<LoanRestructureSearchResponse>(ctx, 'LoanManagementService', 'LoanRestructureSearch', request, LoanRestructureSearchResponse())
  ;
  $async.Future<ReconciliationSaveResponse> reconciliationSave($pb.ClientContext? ctx, ReconciliationSaveRequest request) =>
    _client.invoke<ReconciliationSaveResponse>(ctx, 'LoanManagementService', 'ReconciliationSave', request, ReconciliationSaveResponse())
  ;
  $async.Future<ReconciliationSearchResponse> reconciliationSearch($pb.ClientContext? ctx, ReconciliationSearchRequest request) =>
    _client.invoke<ReconciliationSearchResponse>(ctx, 'LoanManagementService', 'ReconciliationSearch', request, ReconciliationSearchResponse())
  ;
  $async.Future<InitiateCollectionResponse> initiateCollection($pb.ClientContext? ctx, InitiateCollectionRequest request) =>
    _client.invoke<InitiateCollectionResponse>(ctx, 'LoanManagementService', 'InitiateCollection', request, InitiateCollectionResponse())
  ;
  $async.Future<LoanStatusChangeSearchResponse> loanStatusChangeSearch($pb.ClientContext? ctx, LoanStatusChangeSearchRequest request) =>
    _client.invoke<LoanStatusChangeSearchResponse>(ctx, 'LoanManagementService', 'LoanStatusChangeSearch', request, LoanStatusChangeSearchResponse())
  ;
  $async.Future<LoanRequestResponse> loanRequest($pb.ClientContext? ctx, LoanRequestRequest request) =>
    _client.invoke<LoanRequestResponse>(ctx, 'LoanManagementService', 'LoanRequest', request, LoanRequestResponse())
  ;
  $async.Future<PortfolioSummaryResponse> portfolioSummary($pb.ClientContext? ctx, PortfolioSummaryRequest request) =>
    _client.invoke<PortfolioSummaryResponse>(ctx, 'LoanManagementService', 'PortfolioSummary', request, PortfolioSummaryResponse())
  ;
  $async.Future<PortfolioExportResponse> portfolioExport($pb.ClientContext? ctx, PortfolioExportRequest request) =>
    _client.invoke<PortfolioExportResponse>(ctx, 'LoanManagementService', 'PortfolioExport', request, PortfolioExportResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
