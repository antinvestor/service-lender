//
//  Generated code. Do not modify.
//  source: origination/v1/origination.proto
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
import 'origination.pbenum.dart';

export 'origination.pbenum.dart';

/// LoanProductObject defines loan terms, rates, fees, and limits for a bank.
class LoanProductObject extends $pb.GeneratedMessage {
  factory LoanProductObject({
    $core.String? id,
    $core.String? organizationId,
    $core.String? name,
    $core.String? code,
    $core.String? description,
    LoanProductType? productType,
    $core.String? currencyCode,
    InterestMethod? interestMethod,
    RepaymentFrequency? repaymentFrequency,
    $9.Money? minAmount,
    $9.Money? maxAmount,
    $core.int? minTermDays,
    $core.int? maxTermDays,
    $core.String? annualInterestRate,
    $core.String? processingFeePercent,
    $core.String? insuranceFeePercent,
    $core.String? latePenaltyRate,
    $core.int? gracePeriodDays,
    $6.Struct? feeStructure,
    $6.Struct? eligibilityCriteria,
    $7.STATE? state,
    $6.Struct? properties,
    $core.Iterable<ProductFormRequirement>? requiredForms,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (organizationId != null) {
      $result.organizationId = organizationId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (code != null) {
      $result.code = code;
    }
    if (description != null) {
      $result.description = description;
    }
    if (productType != null) {
      $result.productType = productType;
    }
    if (currencyCode != null) {
      $result.currencyCode = currencyCode;
    }
    if (interestMethod != null) {
      $result.interestMethod = interestMethod;
    }
    if (repaymentFrequency != null) {
      $result.repaymentFrequency = repaymentFrequency;
    }
    if (minAmount != null) {
      $result.minAmount = minAmount;
    }
    if (maxAmount != null) {
      $result.maxAmount = maxAmount;
    }
    if (minTermDays != null) {
      $result.minTermDays = minTermDays;
    }
    if (maxTermDays != null) {
      $result.maxTermDays = maxTermDays;
    }
    if (annualInterestRate != null) {
      $result.annualInterestRate = annualInterestRate;
    }
    if (processingFeePercent != null) {
      $result.processingFeePercent = processingFeePercent;
    }
    if (insuranceFeePercent != null) {
      $result.insuranceFeePercent = insuranceFeePercent;
    }
    if (latePenaltyRate != null) {
      $result.latePenaltyRate = latePenaltyRate;
    }
    if (gracePeriodDays != null) {
      $result.gracePeriodDays = gracePeriodDays;
    }
    if (feeStructure != null) {
      $result.feeStructure = feeStructure;
    }
    if (eligibilityCriteria != null) {
      $result.eligibilityCriteria = eligibilityCriteria;
    }
    if (state != null) {
      $result.state = state;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    if (requiredForms != null) {
      $result.requiredForms.addAll(requiredForms);
    }
    return $result;
  }
  LoanProductObject._() : super();
  factory LoanProductObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanProductObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanProductObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'organizationId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'code')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..e<LoanProductType>(6, _omitFieldNames ? '' : 'productType', $pb.PbFieldType.OE, defaultOrMaker: LoanProductType.LOAN_PRODUCT_TYPE_UNSPECIFIED, valueOf: LoanProductType.valueOf, enumValues: LoanProductType.values)
    ..aOS(7, _omitFieldNames ? '' : 'currencyCode')
    ..e<InterestMethod>(8, _omitFieldNames ? '' : 'interestMethod', $pb.PbFieldType.OE, defaultOrMaker: InterestMethod.INTEREST_METHOD_UNSPECIFIED, valueOf: InterestMethod.valueOf, enumValues: InterestMethod.values)
    ..e<RepaymentFrequency>(9, _omitFieldNames ? '' : 'repaymentFrequency', $pb.PbFieldType.OE, defaultOrMaker: RepaymentFrequency.REPAYMENT_FREQUENCY_UNSPECIFIED, valueOf: RepaymentFrequency.valueOf, enumValues: RepaymentFrequency.values)
    ..aOM<$9.Money>(10, _omitFieldNames ? '' : 'minAmount', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(11, _omitFieldNames ? '' : 'maxAmount', subBuilder: $9.Money.create)
    ..a<$core.int>(12, _omitFieldNames ? '' : 'minTermDays', $pb.PbFieldType.O3)
    ..a<$core.int>(13, _omitFieldNames ? '' : 'maxTermDays', $pb.PbFieldType.O3)
    ..aOS(14, _omitFieldNames ? '' : 'annualInterestRate')
    ..aOS(15, _omitFieldNames ? '' : 'processingFeePercent')
    ..aOS(16, _omitFieldNames ? '' : 'insuranceFeePercent')
    ..aOS(17, _omitFieldNames ? '' : 'latePenaltyRate')
    ..a<$core.int>(18, _omitFieldNames ? '' : 'gracePeriodDays', $pb.PbFieldType.O3)
    ..aOM<$6.Struct>(20, _omitFieldNames ? '' : 'feeStructure', subBuilder: $6.Struct.create)
    ..aOM<$6.Struct>(21, _omitFieldNames ? '' : 'eligibilityCriteria', subBuilder: $6.Struct.create)
    ..e<$7.STATE>(23, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: $7.STATE.CREATED, valueOf: $7.STATE.valueOf, enumValues: $7.STATE.values)
    ..aOM<$6.Struct>(24, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..pc<ProductFormRequirement>(25, _omitFieldNames ? '' : 'requiredForms', $pb.PbFieldType.PM, subBuilder: ProductFormRequirement.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanProductObject clone() => LoanProductObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanProductObject copyWith(void Function(LoanProductObject) updates) => super.copyWith((message) => updates(message as LoanProductObject)) as LoanProductObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanProductObject create() => LoanProductObject._();
  LoanProductObject createEmptyInstance() => create();
  static $pb.PbList<LoanProductObject> createRepeated() => $pb.PbList<LoanProductObject>();
  @$core.pragma('dart2js:noInline')
  static LoanProductObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanProductObject>(create);
  static LoanProductObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get organizationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set organizationId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOrganizationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrganizationId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get code => $_getSZ(3);
  @$pb.TagNumber(4)
  set code($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearCode() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => clearField(5);

  @$pb.TagNumber(6)
  LoanProductType get productType => $_getN(5);
  @$pb.TagNumber(6)
  set productType(LoanProductType v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasProductType() => $_has(5);
  @$pb.TagNumber(6)
  void clearProductType() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get currencyCode => $_getSZ(6);
  @$pb.TagNumber(7)
  set currencyCode($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCurrencyCode() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrencyCode() => clearField(7);

  @$pb.TagNumber(8)
  InterestMethod get interestMethod => $_getN(7);
  @$pb.TagNumber(8)
  set interestMethod(InterestMethod v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasInterestMethod() => $_has(7);
  @$pb.TagNumber(8)
  void clearInterestMethod() => clearField(8);

  @$pb.TagNumber(9)
  RepaymentFrequency get repaymentFrequency => $_getN(8);
  @$pb.TagNumber(9)
  set repaymentFrequency(RepaymentFrequency v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasRepaymentFrequency() => $_has(8);
  @$pb.TagNumber(9)
  void clearRepaymentFrequency() => clearField(9);

  @$pb.TagNumber(10)
  $9.Money get minAmount => $_getN(9);
  @$pb.TagNumber(10)
  set minAmount($9.Money v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasMinAmount() => $_has(9);
  @$pb.TagNumber(10)
  void clearMinAmount() => clearField(10);
  @$pb.TagNumber(10)
  $9.Money ensureMinAmount() => $_ensure(9);

  @$pb.TagNumber(11)
  $9.Money get maxAmount => $_getN(10);
  @$pb.TagNumber(11)
  set maxAmount($9.Money v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasMaxAmount() => $_has(10);
  @$pb.TagNumber(11)
  void clearMaxAmount() => clearField(11);
  @$pb.TagNumber(11)
  $9.Money ensureMaxAmount() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.int get minTermDays => $_getIZ(11);
  @$pb.TagNumber(12)
  set minTermDays($core.int v) { $_setSignedInt32(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasMinTermDays() => $_has(11);
  @$pb.TagNumber(12)
  void clearMinTermDays() => clearField(12);

  @$pb.TagNumber(13)
  $core.int get maxTermDays => $_getIZ(12);
  @$pb.TagNumber(13)
  set maxTermDays($core.int v) { $_setSignedInt32(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasMaxTermDays() => $_has(12);
  @$pb.TagNumber(13)
  void clearMaxTermDays() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get annualInterestRate => $_getSZ(13);
  @$pb.TagNumber(14)
  set annualInterestRate($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasAnnualInterestRate() => $_has(13);
  @$pb.TagNumber(14)
  void clearAnnualInterestRate() => clearField(14);

  @$pb.TagNumber(15)
  $core.String get processingFeePercent => $_getSZ(14);
  @$pb.TagNumber(15)
  set processingFeePercent($core.String v) { $_setString(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasProcessingFeePercent() => $_has(14);
  @$pb.TagNumber(15)
  void clearProcessingFeePercent() => clearField(15);

  @$pb.TagNumber(16)
  $core.String get insuranceFeePercent => $_getSZ(15);
  @$pb.TagNumber(16)
  set insuranceFeePercent($core.String v) { $_setString(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasInsuranceFeePercent() => $_has(15);
  @$pb.TagNumber(16)
  void clearInsuranceFeePercent() => clearField(16);

  @$pb.TagNumber(17)
  $core.String get latePenaltyRate => $_getSZ(16);
  @$pb.TagNumber(17)
  set latePenaltyRate($core.String v) { $_setString(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasLatePenaltyRate() => $_has(16);
  @$pb.TagNumber(17)
  void clearLatePenaltyRate() => clearField(17);

  @$pb.TagNumber(18)
  $core.int get gracePeriodDays => $_getIZ(17);
  @$pb.TagNumber(18)
  set gracePeriodDays($core.int v) { $_setSignedInt32(17, v); }
  @$pb.TagNumber(18)
  $core.bool hasGracePeriodDays() => $_has(17);
  @$pb.TagNumber(18)
  void clearGracePeriodDays() => clearField(18);

  @$pb.TagNumber(20)
  $6.Struct get feeStructure => $_getN(18);
  @$pb.TagNumber(20)
  set feeStructure($6.Struct v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasFeeStructure() => $_has(18);
  @$pb.TagNumber(20)
  void clearFeeStructure() => clearField(20);
  @$pb.TagNumber(20)
  $6.Struct ensureFeeStructure() => $_ensure(18);

  @$pb.TagNumber(21)
  $6.Struct get eligibilityCriteria => $_getN(19);
  @$pb.TagNumber(21)
  set eligibilityCriteria($6.Struct v) { setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasEligibilityCriteria() => $_has(19);
  @$pb.TagNumber(21)
  void clearEligibilityCriteria() => clearField(21);
  @$pb.TagNumber(21)
  $6.Struct ensureEligibilityCriteria() => $_ensure(19);

  @$pb.TagNumber(23)
  $7.STATE get state => $_getN(20);
  @$pb.TagNumber(23)
  set state($7.STATE v) { setField(23, v); }
  @$pb.TagNumber(23)
  $core.bool hasState() => $_has(20);
  @$pb.TagNumber(23)
  void clearState() => clearField(23);

  @$pb.TagNumber(24)
  $6.Struct get properties => $_getN(21);
  @$pb.TagNumber(24)
  set properties($6.Struct v) { setField(24, v); }
  @$pb.TagNumber(24)
  $core.bool hasProperties() => $_has(21);
  @$pb.TagNumber(24)
  void clearProperties() => clearField(24);
  @$pb.TagNumber(24)
  $6.Struct ensureProperties() => $_ensure(21);

  @$pb.TagNumber(25)
  $core.List<ProductFormRequirement> get requiredForms => $_getList(22);
}

/// ApplicationObject represents a client's loan application.
class ApplicationObject extends $pb.GeneratedMessage {
  factory ApplicationObject({
    $core.String? id,
    $core.String? productId,
    $core.String? clientId,
    $core.String? agentId,
    $core.String? branchId,
    $core.String? organizationId,
    ApplicationStatus? status,
    $9.Money? requestedAmount,
    $9.Money? approvedAmount,
    $core.int? requestedTermDays,
    $core.int? approvedTermDays,
    $core.String? interestRate,
    $6.Struct? kycData,
    $core.String? purpose,
    $core.String? rejectionReason,
    $core.String? workflowInstanceId,
    $core.String? offerExpiresAt,
    $core.String? submittedAt,
    $core.String? decidedAt,
    $core.String? loanAccountId,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
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
    if (requestedAmount != null) {
      $result.requestedAmount = requestedAmount;
    }
    if (approvedAmount != null) {
      $result.approvedAmount = approvedAmount;
    }
    if (requestedTermDays != null) {
      $result.requestedTermDays = requestedTermDays;
    }
    if (approvedTermDays != null) {
      $result.approvedTermDays = approvedTermDays;
    }
    if (interestRate != null) {
      $result.interestRate = interestRate;
    }
    if (kycData != null) {
      $result.kycData = kycData;
    }
    if (purpose != null) {
      $result.purpose = purpose;
    }
    if (rejectionReason != null) {
      $result.rejectionReason = rejectionReason;
    }
    if (workflowInstanceId != null) {
      $result.workflowInstanceId = workflowInstanceId;
    }
    if (offerExpiresAt != null) {
      $result.offerExpiresAt = offerExpiresAt;
    }
    if (submittedAt != null) {
      $result.submittedAt = submittedAt;
    }
    if (decidedAt != null) {
      $result.decidedAt = decidedAt;
    }
    if (loanAccountId != null) {
      $result.loanAccountId = loanAccountId;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  ApplicationObject._() : super();
  factory ApplicationObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'productId')
    ..aOS(3, _omitFieldNames ? '' : 'clientId')
    ..aOS(4, _omitFieldNames ? '' : 'agentId')
    ..aOS(5, _omitFieldNames ? '' : 'branchId')
    ..aOS(6, _omitFieldNames ? '' : 'organizationId')
    ..e<ApplicationStatus>(7, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: ApplicationStatus.APPLICATION_STATUS_UNSPECIFIED, valueOf: ApplicationStatus.valueOf, enumValues: ApplicationStatus.values)
    ..aOM<$9.Money>(8, _omitFieldNames ? '' : 'requestedAmount', subBuilder: $9.Money.create)
    ..aOM<$9.Money>(9, _omitFieldNames ? '' : 'approvedAmount', subBuilder: $9.Money.create)
    ..a<$core.int>(10, _omitFieldNames ? '' : 'requestedTermDays', $pb.PbFieldType.O3)
    ..a<$core.int>(11, _omitFieldNames ? '' : 'approvedTermDays', $pb.PbFieldType.O3)
    ..aOS(12, _omitFieldNames ? '' : 'interestRate')
    ..aOM<$6.Struct>(14, _omitFieldNames ? '' : 'kycData', subBuilder: $6.Struct.create)
    ..aOS(15, _omitFieldNames ? '' : 'purpose')
    ..aOS(16, _omitFieldNames ? '' : 'rejectionReason')
    ..aOS(17, _omitFieldNames ? '' : 'workflowInstanceId')
    ..aOS(18, _omitFieldNames ? '' : 'offerExpiresAt')
    ..aOS(19, _omitFieldNames ? '' : 'submittedAt')
    ..aOS(20, _omitFieldNames ? '' : 'decidedAt')
    ..aOS(21, _omitFieldNames ? '' : 'loanAccountId')
    ..aOM<$6.Struct>(22, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationObject clone() => ApplicationObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationObject copyWith(void Function(ApplicationObject) updates) => super.copyWith((message) => updates(message as ApplicationObject)) as ApplicationObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationObject create() => ApplicationObject._();
  ApplicationObject createEmptyInstance() => create();
  static $pb.PbList<ApplicationObject> createRepeated() => $pb.PbList<ApplicationObject>();
  @$core.pragma('dart2js:noInline')
  static ApplicationObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationObject>(create);
  static ApplicationObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get productId => $_getSZ(1);
  @$pb.TagNumber(2)
  set productId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProductId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get clientId => $_getSZ(2);
  @$pb.TagNumber(3)
  set clientId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasClientId() => $_has(2);
  @$pb.TagNumber(3)
  void clearClientId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get agentId => $_getSZ(3);
  @$pb.TagNumber(4)
  set agentId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAgentId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAgentId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get branchId => $_getSZ(4);
  @$pb.TagNumber(5)
  set branchId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasBranchId() => $_has(4);
  @$pb.TagNumber(5)
  void clearBranchId() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get organizationId => $_getSZ(5);
  @$pb.TagNumber(6)
  set organizationId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasOrganizationId() => $_has(5);
  @$pb.TagNumber(6)
  void clearOrganizationId() => clearField(6);

  @$pb.TagNumber(7)
  ApplicationStatus get status => $_getN(6);
  @$pb.TagNumber(7)
  set status(ApplicationStatus v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => clearField(7);

  @$pb.TagNumber(8)
  $9.Money get requestedAmount => $_getN(7);
  @$pb.TagNumber(8)
  set requestedAmount($9.Money v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasRequestedAmount() => $_has(7);
  @$pb.TagNumber(8)
  void clearRequestedAmount() => clearField(8);
  @$pb.TagNumber(8)
  $9.Money ensureRequestedAmount() => $_ensure(7);

  @$pb.TagNumber(9)
  $9.Money get approvedAmount => $_getN(8);
  @$pb.TagNumber(9)
  set approvedAmount($9.Money v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasApprovedAmount() => $_has(8);
  @$pb.TagNumber(9)
  void clearApprovedAmount() => clearField(9);
  @$pb.TagNumber(9)
  $9.Money ensureApprovedAmount() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.int get requestedTermDays => $_getIZ(9);
  @$pb.TagNumber(10)
  set requestedTermDays($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasRequestedTermDays() => $_has(9);
  @$pb.TagNumber(10)
  void clearRequestedTermDays() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get approvedTermDays => $_getIZ(10);
  @$pb.TagNumber(11)
  set approvedTermDays($core.int v) { $_setSignedInt32(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasApprovedTermDays() => $_has(10);
  @$pb.TagNumber(11)
  void clearApprovedTermDays() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get interestRate => $_getSZ(11);
  @$pb.TagNumber(12)
  set interestRate($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasInterestRate() => $_has(11);
  @$pb.TagNumber(12)
  void clearInterestRate() => clearField(12);

  @$pb.TagNumber(14)
  $6.Struct get kycData => $_getN(12);
  @$pb.TagNumber(14)
  set kycData($6.Struct v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasKycData() => $_has(12);
  @$pb.TagNumber(14)
  void clearKycData() => clearField(14);
  @$pb.TagNumber(14)
  $6.Struct ensureKycData() => $_ensure(12);

  @$pb.TagNumber(15)
  $core.String get purpose => $_getSZ(13);
  @$pb.TagNumber(15)
  set purpose($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(15)
  $core.bool hasPurpose() => $_has(13);
  @$pb.TagNumber(15)
  void clearPurpose() => clearField(15);

  @$pb.TagNumber(16)
  $core.String get rejectionReason => $_getSZ(14);
  @$pb.TagNumber(16)
  set rejectionReason($core.String v) { $_setString(14, v); }
  @$pb.TagNumber(16)
  $core.bool hasRejectionReason() => $_has(14);
  @$pb.TagNumber(16)
  void clearRejectionReason() => clearField(16);

  @$pb.TagNumber(17)
  $core.String get workflowInstanceId => $_getSZ(15);
  @$pb.TagNumber(17)
  set workflowInstanceId($core.String v) { $_setString(15, v); }
  @$pb.TagNumber(17)
  $core.bool hasWorkflowInstanceId() => $_has(15);
  @$pb.TagNumber(17)
  void clearWorkflowInstanceId() => clearField(17);

  @$pb.TagNumber(18)
  $core.String get offerExpiresAt => $_getSZ(16);
  @$pb.TagNumber(18)
  set offerExpiresAt($core.String v) { $_setString(16, v); }
  @$pb.TagNumber(18)
  $core.bool hasOfferExpiresAt() => $_has(16);
  @$pb.TagNumber(18)
  void clearOfferExpiresAt() => clearField(18);

  @$pb.TagNumber(19)
  $core.String get submittedAt => $_getSZ(17);
  @$pb.TagNumber(19)
  set submittedAt($core.String v) { $_setString(17, v); }
  @$pb.TagNumber(19)
  $core.bool hasSubmittedAt() => $_has(17);
  @$pb.TagNumber(19)
  void clearSubmittedAt() => clearField(19);

  @$pb.TagNumber(20)
  $core.String get decidedAt => $_getSZ(18);
  @$pb.TagNumber(20)
  set decidedAt($core.String v) { $_setString(18, v); }
  @$pb.TagNumber(20)
  $core.bool hasDecidedAt() => $_has(18);
  @$pb.TagNumber(20)
  void clearDecidedAt() => clearField(20);

  @$pb.TagNumber(21)
  $core.String get loanAccountId => $_getSZ(19);
  @$pb.TagNumber(21)
  set loanAccountId($core.String v) { $_setString(19, v); }
  @$pb.TagNumber(21)
  $core.bool hasLoanAccountId() => $_has(19);
  @$pb.TagNumber(21)
  void clearLoanAccountId() => clearField(21);

  @$pb.TagNumber(22)
  $6.Struct get properties => $_getN(20);
  @$pb.TagNumber(22)
  set properties($6.Struct v) { setField(22, v); }
  @$pb.TagNumber(22)
  $core.bool hasProperties() => $_has(20);
  @$pb.TagNumber(22)
  void clearProperties() => clearField(22);
  @$pb.TagNumber(22)
  $6.Struct ensureProperties() => $_ensure(20);
}

/// ApplicationDocumentObject represents a document attached to an application.
class ApplicationDocumentObject extends $pb.GeneratedMessage {
  factory ApplicationDocumentObject({
    $core.String? id,
    $core.String? applicationId,
    DocumentType? documentType,
    $core.String? fileId,
    $core.String? fileName,
    $core.String? mimeType,
    VerificationStatus? verificationStatus,
    $core.String? verifiedBy,
    $core.String? verifiedAt,
    $core.String? rejectionReason,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (applicationId != null) {
      $result.applicationId = applicationId;
    }
    if (documentType != null) {
      $result.documentType = documentType;
    }
    if (fileId != null) {
      $result.fileId = fileId;
    }
    if (fileName != null) {
      $result.fileName = fileName;
    }
    if (mimeType != null) {
      $result.mimeType = mimeType;
    }
    if (verificationStatus != null) {
      $result.verificationStatus = verificationStatus;
    }
    if (verifiedBy != null) {
      $result.verifiedBy = verifiedBy;
    }
    if (verifiedAt != null) {
      $result.verifiedAt = verifiedAt;
    }
    if (rejectionReason != null) {
      $result.rejectionReason = rejectionReason;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  ApplicationDocumentObject._() : super();
  factory ApplicationDocumentObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationDocumentObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationDocumentObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'applicationId')
    ..e<DocumentType>(3, _omitFieldNames ? '' : 'documentType', $pb.PbFieldType.OE, defaultOrMaker: DocumentType.DOCUMENT_TYPE_UNSPECIFIED, valueOf: DocumentType.valueOf, enumValues: DocumentType.values)
    ..aOS(4, _omitFieldNames ? '' : 'fileId')
    ..aOS(5, _omitFieldNames ? '' : 'fileName')
    ..aOS(6, _omitFieldNames ? '' : 'mimeType')
    ..e<VerificationStatus>(7, _omitFieldNames ? '' : 'verificationStatus', $pb.PbFieldType.OE, defaultOrMaker: VerificationStatus.VERIFICATION_STATUS_UNSPECIFIED, valueOf: VerificationStatus.valueOf, enumValues: VerificationStatus.values)
    ..aOS(8, _omitFieldNames ? '' : 'verifiedBy')
    ..aOS(9, _omitFieldNames ? '' : 'verifiedAt')
    ..aOS(10, _omitFieldNames ? '' : 'rejectionReason')
    ..aOM<$6.Struct>(11, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationDocumentObject clone() => ApplicationDocumentObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationDocumentObject copyWith(void Function(ApplicationDocumentObject) updates) => super.copyWith((message) => updates(message as ApplicationDocumentObject)) as ApplicationDocumentObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationDocumentObject create() => ApplicationDocumentObject._();
  ApplicationDocumentObject createEmptyInstance() => create();
  static $pb.PbList<ApplicationDocumentObject> createRepeated() => $pb.PbList<ApplicationDocumentObject>();
  @$core.pragma('dart2js:noInline')
  static ApplicationDocumentObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationDocumentObject>(create);
  static ApplicationDocumentObject? _defaultInstance;

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
  DocumentType get documentType => $_getN(2);
  @$pb.TagNumber(3)
  set documentType(DocumentType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasDocumentType() => $_has(2);
  @$pb.TagNumber(3)
  void clearDocumentType() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get fileId => $_getSZ(3);
  @$pb.TagNumber(4)
  set fileId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFileId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFileId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get fileName => $_getSZ(4);
  @$pb.TagNumber(5)
  set fileName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFileName() => $_has(4);
  @$pb.TagNumber(5)
  void clearFileName() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get mimeType => $_getSZ(5);
  @$pb.TagNumber(6)
  set mimeType($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMimeType() => $_has(5);
  @$pb.TagNumber(6)
  void clearMimeType() => clearField(6);

  @$pb.TagNumber(7)
  VerificationStatus get verificationStatus => $_getN(6);
  @$pb.TagNumber(7)
  set verificationStatus(VerificationStatus v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasVerificationStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearVerificationStatus() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get verifiedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set verifiedBy($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasVerifiedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearVerifiedBy() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get verifiedAt => $_getSZ(8);
  @$pb.TagNumber(9)
  set verifiedAt($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasVerifiedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearVerifiedAt() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get rejectionReason => $_getSZ(9);
  @$pb.TagNumber(10)
  set rejectionReason($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasRejectionReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearRejectionReason() => clearField(10);

  @$pb.TagNumber(11)
  $6.Struct get properties => $_getN(10);
  @$pb.TagNumber(11)
  set properties($6.Struct v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasProperties() => $_has(10);
  @$pb.TagNumber(11)
  void clearProperties() => clearField(11);
  @$pb.TagNumber(11)
  $6.Struct ensureProperties() => $_ensure(10);
}

/// VerificationTaskObject represents a verification task assigned to a verifier.
class VerificationTaskObject extends $pb.GeneratedMessage {
  factory VerificationTaskObject({
    $core.String? id,
    $core.String? applicationId,
    $core.String? assignedTo,
    $core.String? verificationType,
    VerificationStatus? status,
    $core.String? notes,
    $6.Struct? checklist,
    $6.Struct? results,
    $core.String? completedAt,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (applicationId != null) {
      $result.applicationId = applicationId;
    }
    if (assignedTo != null) {
      $result.assignedTo = assignedTo;
    }
    if (verificationType != null) {
      $result.verificationType = verificationType;
    }
    if (status != null) {
      $result.status = status;
    }
    if (notes != null) {
      $result.notes = notes;
    }
    if (checklist != null) {
      $result.checklist = checklist;
    }
    if (results != null) {
      $result.results = results;
    }
    if (completedAt != null) {
      $result.completedAt = completedAt;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  VerificationTaskObject._() : super();
  factory VerificationTaskObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VerificationTaskObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VerificationTaskObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'applicationId')
    ..aOS(3, _omitFieldNames ? '' : 'assignedTo')
    ..aOS(4, _omitFieldNames ? '' : 'verificationType')
    ..e<VerificationStatus>(5, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: VerificationStatus.VERIFICATION_STATUS_UNSPECIFIED, valueOf: VerificationStatus.valueOf, enumValues: VerificationStatus.values)
    ..aOS(6, _omitFieldNames ? '' : 'notes')
    ..aOM<$6.Struct>(7, _omitFieldNames ? '' : 'checklist', subBuilder: $6.Struct.create)
    ..aOM<$6.Struct>(8, _omitFieldNames ? '' : 'results', subBuilder: $6.Struct.create)
    ..aOS(9, _omitFieldNames ? '' : 'completedAt')
    ..aOM<$6.Struct>(10, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VerificationTaskObject clone() => VerificationTaskObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VerificationTaskObject copyWith(void Function(VerificationTaskObject) updates) => super.copyWith((message) => updates(message as VerificationTaskObject)) as VerificationTaskObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerificationTaskObject create() => VerificationTaskObject._();
  VerificationTaskObject createEmptyInstance() => create();
  static $pb.PbList<VerificationTaskObject> createRepeated() => $pb.PbList<VerificationTaskObject>();
  @$core.pragma('dart2js:noInline')
  static VerificationTaskObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VerificationTaskObject>(create);
  static VerificationTaskObject? _defaultInstance;

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
  $core.String get assignedTo => $_getSZ(2);
  @$pb.TagNumber(3)
  set assignedTo($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAssignedTo() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssignedTo() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get verificationType => $_getSZ(3);
  @$pb.TagNumber(4)
  set verificationType($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasVerificationType() => $_has(3);
  @$pb.TagNumber(4)
  void clearVerificationType() => clearField(4);

  @$pb.TagNumber(5)
  VerificationStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(VerificationStatus v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get notes => $_getSZ(5);
  @$pb.TagNumber(6)
  set notes($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasNotes() => $_has(5);
  @$pb.TagNumber(6)
  void clearNotes() => clearField(6);

  @$pb.TagNumber(7)
  $6.Struct get checklist => $_getN(6);
  @$pb.TagNumber(7)
  set checklist($6.Struct v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasChecklist() => $_has(6);
  @$pb.TagNumber(7)
  void clearChecklist() => clearField(7);
  @$pb.TagNumber(7)
  $6.Struct ensureChecklist() => $_ensure(6);

  @$pb.TagNumber(8)
  $6.Struct get results => $_getN(7);
  @$pb.TagNumber(8)
  set results($6.Struct v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasResults() => $_has(7);
  @$pb.TagNumber(8)
  void clearResults() => clearField(8);
  @$pb.TagNumber(8)
  $6.Struct ensureResults() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get completedAt => $_getSZ(8);
  @$pb.TagNumber(9)
  set completedAt($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCompletedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCompletedAt() => clearField(9);

  @$pb.TagNumber(10)
  $6.Struct get properties => $_getN(9);
  @$pb.TagNumber(10)
  set properties($6.Struct v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasProperties() => $_has(9);
  @$pb.TagNumber(10)
  void clearProperties() => clearField(10);
  @$pb.TagNumber(10)
  $6.Struct ensureProperties() => $_ensure(9);
}

/// UnderwritingDecisionObject represents a credit assessment decision.
class UnderwritingDecisionObject extends $pb.GeneratedMessage {
  factory UnderwritingDecisionObject({
    $core.String? id,
    $core.String? applicationId,
    $core.String? decidedBy,
    UnderwritingOutcome? outcome,
    $core.int? creditScore,
    $core.String? riskGrade,
    $9.Money? approvedAmount,
    $core.int? approvedTermDays,
    $core.String? approvedRate,
    $core.String? reason,
    $6.Struct? scoringDetails,
    $6.Struct? conditions,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (applicationId != null) {
      $result.applicationId = applicationId;
    }
    if (decidedBy != null) {
      $result.decidedBy = decidedBy;
    }
    if (outcome != null) {
      $result.outcome = outcome;
    }
    if (creditScore != null) {
      $result.creditScore = creditScore;
    }
    if (riskGrade != null) {
      $result.riskGrade = riskGrade;
    }
    if (approvedAmount != null) {
      $result.approvedAmount = approvedAmount;
    }
    if (approvedTermDays != null) {
      $result.approvedTermDays = approvedTermDays;
    }
    if (approvedRate != null) {
      $result.approvedRate = approvedRate;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    if (scoringDetails != null) {
      $result.scoringDetails = scoringDetails;
    }
    if (conditions != null) {
      $result.conditions = conditions;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  UnderwritingDecisionObject._() : super();
  factory UnderwritingDecisionObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UnderwritingDecisionObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UnderwritingDecisionObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'applicationId')
    ..aOS(3, _omitFieldNames ? '' : 'decidedBy')
    ..e<UnderwritingOutcome>(4, _omitFieldNames ? '' : 'outcome', $pb.PbFieldType.OE, defaultOrMaker: UnderwritingOutcome.UNDERWRITING_OUTCOME_UNSPECIFIED, valueOf: UnderwritingOutcome.valueOf, enumValues: UnderwritingOutcome.values)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'creditScore', $pb.PbFieldType.O3)
    ..aOS(6, _omitFieldNames ? '' : 'riskGrade')
    ..aOM<$9.Money>(7, _omitFieldNames ? '' : 'approvedAmount', subBuilder: $9.Money.create)
    ..a<$core.int>(8, _omitFieldNames ? '' : 'approvedTermDays', $pb.PbFieldType.O3)
    ..aOS(9, _omitFieldNames ? '' : 'approvedRate')
    ..aOS(10, _omitFieldNames ? '' : 'reason')
    ..aOM<$6.Struct>(11, _omitFieldNames ? '' : 'scoringDetails', subBuilder: $6.Struct.create)
    ..aOM<$6.Struct>(12, _omitFieldNames ? '' : 'conditions', subBuilder: $6.Struct.create)
    ..aOM<$6.Struct>(13, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UnderwritingDecisionObject clone() => UnderwritingDecisionObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UnderwritingDecisionObject copyWith(void Function(UnderwritingDecisionObject) updates) => super.copyWith((message) => updates(message as UnderwritingDecisionObject)) as UnderwritingDecisionObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnderwritingDecisionObject create() => UnderwritingDecisionObject._();
  UnderwritingDecisionObject createEmptyInstance() => create();
  static $pb.PbList<UnderwritingDecisionObject> createRepeated() => $pb.PbList<UnderwritingDecisionObject>();
  @$core.pragma('dart2js:noInline')
  static UnderwritingDecisionObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnderwritingDecisionObject>(create);
  static UnderwritingDecisionObject? _defaultInstance;

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
  $core.String get decidedBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set decidedBy($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDecidedBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearDecidedBy() => clearField(3);

  @$pb.TagNumber(4)
  UnderwritingOutcome get outcome => $_getN(3);
  @$pb.TagNumber(4)
  set outcome(UnderwritingOutcome v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasOutcome() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutcome() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get creditScore => $_getIZ(4);
  @$pb.TagNumber(5)
  set creditScore($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCreditScore() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreditScore() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get riskGrade => $_getSZ(5);
  @$pb.TagNumber(6)
  set riskGrade($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasRiskGrade() => $_has(5);
  @$pb.TagNumber(6)
  void clearRiskGrade() => clearField(6);

  @$pb.TagNumber(7)
  $9.Money get approvedAmount => $_getN(6);
  @$pb.TagNumber(7)
  set approvedAmount($9.Money v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasApprovedAmount() => $_has(6);
  @$pb.TagNumber(7)
  void clearApprovedAmount() => clearField(7);
  @$pb.TagNumber(7)
  $9.Money ensureApprovedAmount() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.int get approvedTermDays => $_getIZ(7);
  @$pb.TagNumber(8)
  set approvedTermDays($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasApprovedTermDays() => $_has(7);
  @$pb.TagNumber(8)
  void clearApprovedTermDays() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get approvedRate => $_getSZ(8);
  @$pb.TagNumber(9)
  set approvedRate($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasApprovedRate() => $_has(8);
  @$pb.TagNumber(9)
  void clearApprovedRate() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get reason => $_getSZ(9);
  @$pb.TagNumber(10)
  set reason($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearReason() => clearField(10);

  @$pb.TagNumber(11)
  $6.Struct get scoringDetails => $_getN(10);
  @$pb.TagNumber(11)
  set scoringDetails($6.Struct v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasScoringDetails() => $_has(10);
  @$pb.TagNumber(11)
  void clearScoringDetails() => clearField(11);
  @$pb.TagNumber(11)
  $6.Struct ensureScoringDetails() => $_ensure(10);

  @$pb.TagNumber(12)
  $6.Struct get conditions => $_getN(11);
  @$pb.TagNumber(12)
  set conditions($6.Struct v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasConditions() => $_has(11);
  @$pb.TagNumber(12)
  void clearConditions() => clearField(12);
  @$pb.TagNumber(12)
  $6.Struct ensureConditions() => $_ensure(11);

  @$pb.TagNumber(13)
  $6.Struct get properties => $_getN(12);
  @$pb.TagNumber(13)
  set properties($6.Struct v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasProperties() => $_has(12);
  @$pb.TagNumber(13)
  void clearProperties() => clearField(13);
  @$pb.TagNumber(13)
  $6.Struct ensureProperties() => $_ensure(12);
}

/// ProductFormRequirement defines a form template required by a product.
class ProductFormRequirement extends $pb.GeneratedMessage {
  factory ProductFormRequirement({
    $core.String? templateId,
    $core.String? stage,
    $core.bool? required,
    $core.int? order,
    $core.String? description,
  }) {
    final $result = create();
    if (templateId != null) {
      $result.templateId = templateId;
    }
    if (stage != null) {
      $result.stage = stage;
    }
    if (required != null) {
      $result.required = required;
    }
    if (order != null) {
      $result.order = order;
    }
    if (description != null) {
      $result.description = description;
    }
    return $result;
  }
  ProductFormRequirement._() : super();
  factory ProductFormRequirement.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProductFormRequirement.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProductFormRequirement', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'templateId')
    ..aOS(2, _omitFieldNames ? '' : 'stage')
    ..aOB(3, _omitFieldNames ? '' : 'required')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'order', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProductFormRequirement clone() => ProductFormRequirement()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProductFormRequirement copyWith(void Function(ProductFormRequirement) updates) => super.copyWith((message) => updates(message as ProductFormRequirement)) as ProductFormRequirement;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProductFormRequirement create() => ProductFormRequirement._();
  ProductFormRequirement createEmptyInstance() => create();
  static $pb.PbList<ProductFormRequirement> createRepeated() => $pb.PbList<ProductFormRequirement>();
  @$core.pragma('dart2js:noInline')
  static ProductFormRequirement getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProductFormRequirement>(create);
  static ProductFormRequirement? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get templateId => $_getSZ(0);
  @$pb.TagNumber(1)
  set templateId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTemplateId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemplateId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get stage => $_getSZ(1);
  @$pb.TagNumber(2)
  set stage($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStage() => $_has(1);
  @$pb.TagNumber(2)
  void clearStage() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get required => $_getBF(2);
  @$pb.TagNumber(3)
  set required($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRequired() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequired() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get order => $_getIZ(3);
  @$pb.TagNumber(4)
  set order($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOrder() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrder() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => clearField(5);
}

/// FormFieldDefinition defines a single field in a form template.
class FormFieldDefinition extends $pb.GeneratedMessage {
  factory FormFieldDefinition({
    $core.String? key,
    $core.String? label,
    FormFieldType? fieldType,
    FormFieldGroup? group,
    $core.bool? required,
    $core.String? description,
    $core.String? placeholder,
    $core.String? defaultValue,
    $core.String? validationPattern,
    $core.String? validationMessage,
    $core.Iterable<$core.String>? options,
    $core.int? minLength,
    $core.int? maxLength,
    $core.String? minValue,
    $core.String? maxValue,
    $core.int? order,
    $core.String? section,
    $core.bool? encrypted,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (key != null) {
      $result.key = key;
    }
    if (label != null) {
      $result.label = label;
    }
    if (fieldType != null) {
      $result.fieldType = fieldType;
    }
    if (group != null) {
      $result.group = group;
    }
    if (required != null) {
      $result.required = required;
    }
    if (description != null) {
      $result.description = description;
    }
    if (placeholder != null) {
      $result.placeholder = placeholder;
    }
    if (defaultValue != null) {
      $result.defaultValue = defaultValue;
    }
    if (validationPattern != null) {
      $result.validationPattern = validationPattern;
    }
    if (validationMessage != null) {
      $result.validationMessage = validationMessage;
    }
    if (options != null) {
      $result.options.addAll(options);
    }
    if (minLength != null) {
      $result.minLength = minLength;
    }
    if (maxLength != null) {
      $result.maxLength = maxLength;
    }
    if (minValue != null) {
      $result.minValue = minValue;
    }
    if (maxValue != null) {
      $result.maxValue = maxValue;
    }
    if (order != null) {
      $result.order = order;
    }
    if (section != null) {
      $result.section = section;
    }
    if (encrypted != null) {
      $result.encrypted = encrypted;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  FormFieldDefinition._() : super();
  factory FormFieldDefinition.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FormFieldDefinition.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FormFieldDefinition', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..e<FormFieldType>(3, _omitFieldNames ? '' : 'fieldType', $pb.PbFieldType.OE, defaultOrMaker: FormFieldType.FORM_FIELD_TYPE_UNSPECIFIED, valueOf: FormFieldType.valueOf, enumValues: FormFieldType.values)
    ..e<FormFieldGroup>(4, _omitFieldNames ? '' : 'group', $pb.PbFieldType.OE, defaultOrMaker: FormFieldGroup.FORM_FIELD_GROUP_UNSPECIFIED, valueOf: FormFieldGroup.valueOf, enumValues: FormFieldGroup.values)
    ..aOB(5, _omitFieldNames ? '' : 'required')
    ..aOS(6, _omitFieldNames ? '' : 'description')
    ..aOS(7, _omitFieldNames ? '' : 'placeholder')
    ..aOS(8, _omitFieldNames ? '' : 'defaultValue')
    ..aOS(9, _omitFieldNames ? '' : 'validationPattern')
    ..aOS(10, _omitFieldNames ? '' : 'validationMessage')
    ..pPS(11, _omitFieldNames ? '' : 'options')
    ..a<$core.int>(12, _omitFieldNames ? '' : 'minLength', $pb.PbFieldType.O3)
    ..a<$core.int>(13, _omitFieldNames ? '' : 'maxLength', $pb.PbFieldType.O3)
    ..aOS(14, _omitFieldNames ? '' : 'minValue')
    ..aOS(15, _omitFieldNames ? '' : 'maxValue')
    ..a<$core.int>(16, _omitFieldNames ? '' : 'order', $pb.PbFieldType.O3)
    ..aOS(17, _omitFieldNames ? '' : 'section')
    ..aOB(18, _omitFieldNames ? '' : 'encrypted')
    ..aOM<$6.Struct>(19, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FormFieldDefinition clone() => FormFieldDefinition()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FormFieldDefinition copyWith(void Function(FormFieldDefinition) updates) => super.copyWith((message) => updates(message as FormFieldDefinition)) as FormFieldDefinition;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormFieldDefinition create() => FormFieldDefinition._();
  FormFieldDefinition createEmptyInstance() => create();
  static $pb.PbList<FormFieldDefinition> createRepeated() => $pb.PbList<FormFieldDefinition>();
  @$core.pragma('dart2js:noInline')
  static FormFieldDefinition getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FormFieldDefinition>(create);
  static FormFieldDefinition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => clearField(2);

  @$pb.TagNumber(3)
  FormFieldType get fieldType => $_getN(2);
  @$pb.TagNumber(3)
  set fieldType(FormFieldType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFieldType() => $_has(2);
  @$pb.TagNumber(3)
  void clearFieldType() => clearField(3);

  @$pb.TagNumber(4)
  FormFieldGroup get group => $_getN(3);
  @$pb.TagNumber(4)
  set group(FormFieldGroup v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasGroup() => $_has(3);
  @$pb.TagNumber(4)
  void clearGroup() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get required => $_getBF(4);
  @$pb.TagNumber(5)
  set required($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRequired() => $_has(4);
  @$pb.TagNumber(5)
  void clearRequired() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get description => $_getSZ(5);
  @$pb.TagNumber(6)
  set description($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDescription() => $_has(5);
  @$pb.TagNumber(6)
  void clearDescription() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get placeholder => $_getSZ(6);
  @$pb.TagNumber(7)
  set placeholder($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasPlaceholder() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlaceholder() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get defaultValue => $_getSZ(7);
  @$pb.TagNumber(8)
  set defaultValue($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasDefaultValue() => $_has(7);
  @$pb.TagNumber(8)
  void clearDefaultValue() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get validationPattern => $_getSZ(8);
  @$pb.TagNumber(9)
  set validationPattern($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasValidationPattern() => $_has(8);
  @$pb.TagNumber(9)
  void clearValidationPattern() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get validationMessage => $_getSZ(9);
  @$pb.TagNumber(10)
  set validationMessage($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasValidationMessage() => $_has(9);
  @$pb.TagNumber(10)
  void clearValidationMessage() => clearField(10);

  @$pb.TagNumber(11)
  $core.List<$core.String> get options => $_getList(10);

  @$pb.TagNumber(12)
  $core.int get minLength => $_getIZ(11);
  @$pb.TagNumber(12)
  set minLength($core.int v) { $_setSignedInt32(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasMinLength() => $_has(11);
  @$pb.TagNumber(12)
  void clearMinLength() => clearField(12);

  @$pb.TagNumber(13)
  $core.int get maxLength => $_getIZ(12);
  @$pb.TagNumber(13)
  set maxLength($core.int v) { $_setSignedInt32(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasMaxLength() => $_has(12);
  @$pb.TagNumber(13)
  void clearMaxLength() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get minValue => $_getSZ(13);
  @$pb.TagNumber(14)
  set minValue($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasMinValue() => $_has(13);
  @$pb.TagNumber(14)
  void clearMinValue() => clearField(14);

  @$pb.TagNumber(15)
  $core.String get maxValue => $_getSZ(14);
  @$pb.TagNumber(15)
  set maxValue($core.String v) { $_setString(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasMaxValue() => $_has(14);
  @$pb.TagNumber(15)
  void clearMaxValue() => clearField(15);

  @$pb.TagNumber(16)
  $core.int get order => $_getIZ(15);
  @$pb.TagNumber(16)
  set order($core.int v) { $_setSignedInt32(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasOrder() => $_has(15);
  @$pb.TagNumber(16)
  void clearOrder() => clearField(16);

  @$pb.TagNumber(17)
  $core.String get section => $_getSZ(16);
  @$pb.TagNumber(17)
  set section($core.String v) { $_setString(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasSection() => $_has(16);
  @$pb.TagNumber(17)
  void clearSection() => clearField(17);

  @$pb.TagNumber(18)
  $core.bool get encrypted => $_getBF(17);
  @$pb.TagNumber(18)
  set encrypted($core.bool v) { $_setBool(17, v); }
  @$pb.TagNumber(18)
  $core.bool hasEncrypted() => $_has(17);
  @$pb.TagNumber(18)
  void clearEncrypted() => clearField(18);

  @$pb.TagNumber(19)
  $6.Struct get properties => $_getN(18);
  @$pb.TagNumber(19)
  set properties($6.Struct v) { setField(19, v); }
  @$pb.TagNumber(19)
  $core.bool hasProperties() => $_has(18);
  @$pb.TagNumber(19)
  void clearProperties() => clearField(19);
  @$pb.TagNumber(19)
  $6.Struct ensureProperties() => $_ensure(18);
}

/// FormTemplateObject defines a reusable form schema.
class FormTemplateObject extends $pb.GeneratedMessage {
  factory FormTemplateObject({
    $core.String? id,
    $core.String? organizationId,
    $core.String? name,
    $core.String? description,
    $core.int? version,
    FormTemplateStatus? status,
    $core.Iterable<FormFieldDefinition>? fields,
    $core.Iterable<$core.String>? sections,
    $6.Struct? validationRules,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (organizationId != null) {
      $result.organizationId = organizationId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (description != null) {
      $result.description = description;
    }
    if (version != null) {
      $result.version = version;
    }
    if (status != null) {
      $result.status = status;
    }
    if (fields != null) {
      $result.fields.addAll(fields);
    }
    if (sections != null) {
      $result.sections.addAll(sections);
    }
    if (validationRules != null) {
      $result.validationRules = validationRules;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  FormTemplateObject._() : super();
  factory FormTemplateObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FormTemplateObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FormTemplateObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'organizationId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'version', $pb.PbFieldType.O3)
    ..e<FormTemplateStatus>(6, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: FormTemplateStatus.FORM_TEMPLATE_STATUS_UNSPECIFIED, valueOf: FormTemplateStatus.valueOf, enumValues: FormTemplateStatus.values)
    ..pc<FormFieldDefinition>(7, _omitFieldNames ? '' : 'fields', $pb.PbFieldType.PM, subBuilder: FormFieldDefinition.create)
    ..pPS(8, _omitFieldNames ? '' : 'sections')
    ..aOM<$6.Struct>(9, _omitFieldNames ? '' : 'validationRules', subBuilder: $6.Struct.create)
    ..aOM<$6.Struct>(10, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FormTemplateObject clone() => FormTemplateObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FormTemplateObject copyWith(void Function(FormTemplateObject) updates) => super.copyWith((message) => updates(message as FormTemplateObject)) as FormTemplateObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormTemplateObject create() => FormTemplateObject._();
  FormTemplateObject createEmptyInstance() => create();
  static $pb.PbList<FormTemplateObject> createRepeated() => $pb.PbList<FormTemplateObject>();
  @$core.pragma('dart2js:noInline')
  static FormTemplateObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FormTemplateObject>(create);
  static FormTemplateObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get organizationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set organizationId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOrganizationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrganizationId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get version => $_getIZ(4);
  @$pb.TagNumber(5)
  set version($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearVersion() => clearField(5);

  @$pb.TagNumber(6)
  FormTemplateStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(FormTemplateStatus v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<FormFieldDefinition> get fields => $_getList(6);

  @$pb.TagNumber(8)
  $core.List<$core.String> get sections => $_getList(7);

  @$pb.TagNumber(9)
  $6.Struct get validationRules => $_getN(8);
  @$pb.TagNumber(9)
  set validationRules($6.Struct v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasValidationRules() => $_has(8);
  @$pb.TagNumber(9)
  void clearValidationRules() => clearField(9);
  @$pb.TagNumber(9)
  $6.Struct ensureValidationRules() => $_ensure(8);

  @$pb.TagNumber(10)
  $6.Struct get properties => $_getN(9);
  @$pb.TagNumber(10)
  set properties($6.Struct v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasProperties() => $_has(9);
  @$pb.TagNumber(10)
  void clearProperties() => clearField(10);
  @$pb.TagNumber(10)
  $6.Struct ensureProperties() => $_ensure(9);
}

/// FormSubmissionObject captures filled form data for an application.
class FormSubmissionObject extends $pb.GeneratedMessage {
  factory FormSubmissionObject({
    $core.String? id,
    $core.String? applicationId,
    $core.String? templateId,
    $core.int? templateVersion,
    $core.String? submittedBy,
    $6.Struct? data,
    $6.Struct? fileRefs,
    $7.STATE? state,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (applicationId != null) {
      $result.applicationId = applicationId;
    }
    if (templateId != null) {
      $result.templateId = templateId;
    }
    if (templateVersion != null) {
      $result.templateVersion = templateVersion;
    }
    if (submittedBy != null) {
      $result.submittedBy = submittedBy;
    }
    if (data != null) {
      $result.data = data;
    }
    if (fileRefs != null) {
      $result.fileRefs = fileRefs;
    }
    if (state != null) {
      $result.state = state;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  FormSubmissionObject._() : super();
  factory FormSubmissionObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FormSubmissionObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FormSubmissionObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'applicationId')
    ..aOS(3, _omitFieldNames ? '' : 'templateId')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'templateVersion', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'submittedBy')
    ..aOM<$6.Struct>(6, _omitFieldNames ? '' : 'data', subBuilder: $6.Struct.create)
    ..aOM<$6.Struct>(7, _omitFieldNames ? '' : 'fileRefs', subBuilder: $6.Struct.create)
    ..e<$7.STATE>(8, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: $7.STATE.CREATED, valueOf: $7.STATE.valueOf, enumValues: $7.STATE.values)
    ..aOM<$6.Struct>(9, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FormSubmissionObject clone() => FormSubmissionObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FormSubmissionObject copyWith(void Function(FormSubmissionObject) updates) => super.copyWith((message) => updates(message as FormSubmissionObject)) as FormSubmissionObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormSubmissionObject create() => FormSubmissionObject._();
  FormSubmissionObject createEmptyInstance() => create();
  static $pb.PbList<FormSubmissionObject> createRepeated() => $pb.PbList<FormSubmissionObject>();
  @$core.pragma('dart2js:noInline')
  static FormSubmissionObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FormSubmissionObject>(create);
  static FormSubmissionObject? _defaultInstance;

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
  $core.String get templateId => $_getSZ(2);
  @$pb.TagNumber(3)
  set templateId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTemplateId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTemplateId() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get templateVersion => $_getIZ(3);
  @$pb.TagNumber(4)
  set templateVersion($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTemplateVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearTemplateVersion() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get submittedBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set submittedBy($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSubmittedBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearSubmittedBy() => clearField(5);

  @$pb.TagNumber(6)
  $6.Struct get data => $_getN(5);
  @$pb.TagNumber(6)
  set data($6.Struct v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasData() => $_has(5);
  @$pb.TagNumber(6)
  void clearData() => clearField(6);
  @$pb.TagNumber(6)
  $6.Struct ensureData() => $_ensure(5);

  @$pb.TagNumber(7)
  $6.Struct get fileRefs => $_getN(6);
  @$pb.TagNumber(7)
  set fileRefs($6.Struct v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasFileRefs() => $_has(6);
  @$pb.TagNumber(7)
  void clearFileRefs() => clearField(7);
  @$pb.TagNumber(7)
  $6.Struct ensureFileRefs() => $_ensure(6);

  @$pb.TagNumber(8)
  $7.STATE get state => $_getN(7);
  @$pb.TagNumber(8)
  set state($7.STATE v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasState() => $_has(7);
  @$pb.TagNumber(8)
  void clearState() => clearField(8);

  @$pb.TagNumber(9)
  $6.Struct get properties => $_getN(8);
  @$pb.TagNumber(9)
  set properties($6.Struct v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasProperties() => $_has(8);
  @$pb.TagNumber(9)
  void clearProperties() => clearField(9);
  @$pb.TagNumber(9)
  $6.Struct ensureProperties() => $_ensure(8);
}

class LoanProductSaveRequest extends $pb.GeneratedMessage {
  factory LoanProductSaveRequest({
    LoanProductObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  LoanProductSaveRequest._() : super();
  factory LoanProductSaveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanProductSaveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanProductSaveRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<LoanProductObject>(1, _omitFieldNames ? '' : 'data', subBuilder: LoanProductObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanProductSaveRequest clone() => LoanProductSaveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanProductSaveRequest copyWith(void Function(LoanProductSaveRequest) updates) => super.copyWith((message) => updates(message as LoanProductSaveRequest)) as LoanProductSaveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanProductSaveRequest create() => LoanProductSaveRequest._();
  LoanProductSaveRequest createEmptyInstance() => create();
  static $pb.PbList<LoanProductSaveRequest> createRepeated() => $pb.PbList<LoanProductSaveRequest>();
  @$core.pragma('dart2js:noInline')
  static LoanProductSaveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanProductSaveRequest>(create);
  static LoanProductSaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  LoanProductObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(LoanProductObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  LoanProductObject ensureData() => $_ensure(0);
}

class LoanProductSaveResponse extends $pb.GeneratedMessage {
  factory LoanProductSaveResponse({
    LoanProductObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  LoanProductSaveResponse._() : super();
  factory LoanProductSaveResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanProductSaveResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanProductSaveResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<LoanProductObject>(1, _omitFieldNames ? '' : 'data', subBuilder: LoanProductObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanProductSaveResponse clone() => LoanProductSaveResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanProductSaveResponse copyWith(void Function(LoanProductSaveResponse) updates) => super.copyWith((message) => updates(message as LoanProductSaveResponse)) as LoanProductSaveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanProductSaveResponse create() => LoanProductSaveResponse._();
  LoanProductSaveResponse createEmptyInstance() => create();
  static $pb.PbList<LoanProductSaveResponse> createRepeated() => $pb.PbList<LoanProductSaveResponse>();
  @$core.pragma('dart2js:noInline')
  static LoanProductSaveResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanProductSaveResponse>(create);
  static LoanProductSaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LoanProductObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(LoanProductObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  LoanProductObject ensureData() => $_ensure(0);
}

class LoanProductGetRequest extends $pb.GeneratedMessage {
  factory LoanProductGetRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  LoanProductGetRequest._() : super();
  factory LoanProductGetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanProductGetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanProductGetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanProductGetRequest clone() => LoanProductGetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanProductGetRequest copyWith(void Function(LoanProductGetRequest) updates) => super.copyWith((message) => updates(message as LoanProductGetRequest)) as LoanProductGetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanProductGetRequest create() => LoanProductGetRequest._();
  LoanProductGetRequest createEmptyInstance() => create();
  static $pb.PbList<LoanProductGetRequest> createRepeated() => $pb.PbList<LoanProductGetRequest>();
  @$core.pragma('dart2js:noInline')
  static LoanProductGetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanProductGetRequest>(create);
  static LoanProductGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class LoanProductGetResponse extends $pb.GeneratedMessage {
  factory LoanProductGetResponse({
    LoanProductObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  LoanProductGetResponse._() : super();
  factory LoanProductGetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanProductGetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanProductGetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<LoanProductObject>(1, _omitFieldNames ? '' : 'data', subBuilder: LoanProductObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanProductGetResponse clone() => LoanProductGetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanProductGetResponse copyWith(void Function(LoanProductGetResponse) updates) => super.copyWith((message) => updates(message as LoanProductGetResponse)) as LoanProductGetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanProductGetResponse create() => LoanProductGetResponse._();
  LoanProductGetResponse createEmptyInstance() => create();
  static $pb.PbList<LoanProductGetResponse> createRepeated() => $pb.PbList<LoanProductGetResponse>();
  @$core.pragma('dart2js:noInline')
  static LoanProductGetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanProductGetResponse>(create);
  static LoanProductGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LoanProductObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(LoanProductObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  LoanProductObject ensureData() => $_ensure(0);
}

class LoanProductSearchRequest extends $pb.GeneratedMessage {
  factory LoanProductSearchRequest({
    $core.String? query,
    $core.String? organizationId,
    LoanProductType? productType,
    $7.PageCursor? cursor,
  }) {
    final $result = create();
    if (query != null) {
      $result.query = query;
    }
    if (organizationId != null) {
      $result.organizationId = organizationId;
    }
    if (productType != null) {
      $result.productType = productType;
    }
    if (cursor != null) {
      $result.cursor = cursor;
    }
    return $result;
  }
  LoanProductSearchRequest._() : super();
  factory LoanProductSearchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanProductSearchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanProductSearchRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aOS(2, _omitFieldNames ? '' : 'organizationId')
    ..e<LoanProductType>(3, _omitFieldNames ? '' : 'productType', $pb.PbFieldType.OE, defaultOrMaker: LoanProductType.LOAN_PRODUCT_TYPE_UNSPECIFIED, valueOf: LoanProductType.valueOf, enumValues: LoanProductType.values)
    ..aOM<$7.PageCursor>(4, _omitFieldNames ? '' : 'cursor', subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanProductSearchRequest clone() => LoanProductSearchRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanProductSearchRequest copyWith(void Function(LoanProductSearchRequest) updates) => super.copyWith((message) => updates(message as LoanProductSearchRequest)) as LoanProductSearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanProductSearchRequest create() => LoanProductSearchRequest._();
  LoanProductSearchRequest createEmptyInstance() => create();
  static $pb.PbList<LoanProductSearchRequest> createRepeated() => $pb.PbList<LoanProductSearchRequest>();
  @$core.pragma('dart2js:noInline')
  static LoanProductSearchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanProductSearchRequest>(create);
  static LoanProductSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get organizationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set organizationId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOrganizationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrganizationId() => clearField(2);

  @$pb.TagNumber(3)
  LoanProductType get productType => $_getN(2);
  @$pb.TagNumber(3)
  set productType(LoanProductType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasProductType() => $_has(2);
  @$pb.TagNumber(3)
  void clearProductType() => clearField(3);

  @$pb.TagNumber(4)
  $7.PageCursor get cursor => $_getN(3);
  @$pb.TagNumber(4)
  set cursor($7.PageCursor v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCursor() => $_has(3);
  @$pb.TagNumber(4)
  void clearCursor() => clearField(4);
  @$pb.TagNumber(4)
  $7.PageCursor ensureCursor() => $_ensure(3);
}

class LoanProductSearchResponse extends $pb.GeneratedMessage {
  factory LoanProductSearchResponse({
    $core.Iterable<LoanProductObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  LoanProductSearchResponse._() : super();
  factory LoanProductSearchResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoanProductSearchResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoanProductSearchResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..pc<LoanProductObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: LoanProductObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoanProductSearchResponse clone() => LoanProductSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoanProductSearchResponse copyWith(void Function(LoanProductSearchResponse) updates) => super.copyWith((message) => updates(message as LoanProductSearchResponse)) as LoanProductSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoanProductSearchResponse create() => LoanProductSearchResponse._();
  LoanProductSearchResponse createEmptyInstance() => create();
  static $pb.PbList<LoanProductSearchResponse> createRepeated() => $pb.PbList<LoanProductSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static LoanProductSearchResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoanProductSearchResponse>(create);
  static LoanProductSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<LoanProductObject> get data => $_getList(0);
}

class ApplicationSaveRequest extends $pb.GeneratedMessage {
  factory ApplicationSaveRequest({
    ApplicationObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  ApplicationSaveRequest._() : super();
  factory ApplicationSaveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationSaveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationSaveRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<ApplicationObject>(1, _omitFieldNames ? '' : 'data', subBuilder: ApplicationObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationSaveRequest clone() => ApplicationSaveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationSaveRequest copyWith(void Function(ApplicationSaveRequest) updates) => super.copyWith((message) => updates(message as ApplicationSaveRequest)) as ApplicationSaveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationSaveRequest create() => ApplicationSaveRequest._();
  ApplicationSaveRequest createEmptyInstance() => create();
  static $pb.PbList<ApplicationSaveRequest> createRepeated() => $pb.PbList<ApplicationSaveRequest>();
  @$core.pragma('dart2js:noInline')
  static ApplicationSaveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationSaveRequest>(create);
  static ApplicationSaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ApplicationObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(ApplicationObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  ApplicationObject ensureData() => $_ensure(0);
}

class ApplicationSaveResponse extends $pb.GeneratedMessage {
  factory ApplicationSaveResponse({
    ApplicationObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  ApplicationSaveResponse._() : super();
  factory ApplicationSaveResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationSaveResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationSaveResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<ApplicationObject>(1, _omitFieldNames ? '' : 'data', subBuilder: ApplicationObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationSaveResponse clone() => ApplicationSaveResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationSaveResponse copyWith(void Function(ApplicationSaveResponse) updates) => super.copyWith((message) => updates(message as ApplicationSaveResponse)) as ApplicationSaveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationSaveResponse create() => ApplicationSaveResponse._();
  ApplicationSaveResponse createEmptyInstance() => create();
  static $pb.PbList<ApplicationSaveResponse> createRepeated() => $pb.PbList<ApplicationSaveResponse>();
  @$core.pragma('dart2js:noInline')
  static ApplicationSaveResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationSaveResponse>(create);
  static ApplicationSaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ApplicationObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(ApplicationObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  ApplicationObject ensureData() => $_ensure(0);
}

class ApplicationGetRequest extends $pb.GeneratedMessage {
  factory ApplicationGetRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  ApplicationGetRequest._() : super();
  factory ApplicationGetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationGetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationGetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationGetRequest clone() => ApplicationGetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationGetRequest copyWith(void Function(ApplicationGetRequest) updates) => super.copyWith((message) => updates(message as ApplicationGetRequest)) as ApplicationGetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationGetRequest create() => ApplicationGetRequest._();
  ApplicationGetRequest createEmptyInstance() => create();
  static $pb.PbList<ApplicationGetRequest> createRepeated() => $pb.PbList<ApplicationGetRequest>();
  @$core.pragma('dart2js:noInline')
  static ApplicationGetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationGetRequest>(create);
  static ApplicationGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class ApplicationGetResponse extends $pb.GeneratedMessage {
  factory ApplicationGetResponse({
    ApplicationObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  ApplicationGetResponse._() : super();
  factory ApplicationGetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationGetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationGetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<ApplicationObject>(1, _omitFieldNames ? '' : 'data', subBuilder: ApplicationObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationGetResponse clone() => ApplicationGetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationGetResponse copyWith(void Function(ApplicationGetResponse) updates) => super.copyWith((message) => updates(message as ApplicationGetResponse)) as ApplicationGetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationGetResponse create() => ApplicationGetResponse._();
  ApplicationGetResponse createEmptyInstance() => create();
  static $pb.PbList<ApplicationGetResponse> createRepeated() => $pb.PbList<ApplicationGetResponse>();
  @$core.pragma('dart2js:noInline')
  static ApplicationGetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationGetResponse>(create);
  static ApplicationGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ApplicationObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(ApplicationObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  ApplicationObject ensureData() => $_ensure(0);
}

class ApplicationSearchRequest extends $pb.GeneratedMessage {
  factory ApplicationSearchRequest({
    $core.String? query,
    $core.String? clientId,
    $core.String? agentId,
    $core.String? branchId,
    $core.String? organizationId,
    ApplicationStatus? status,
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
  ApplicationSearchRequest._() : super();
  factory ApplicationSearchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationSearchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationSearchRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aOS(2, _omitFieldNames ? '' : 'clientId')
    ..aOS(3, _omitFieldNames ? '' : 'agentId')
    ..aOS(4, _omitFieldNames ? '' : 'branchId')
    ..aOS(5, _omitFieldNames ? '' : 'organizationId')
    ..e<ApplicationStatus>(6, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: ApplicationStatus.APPLICATION_STATUS_UNSPECIFIED, valueOf: ApplicationStatus.valueOf, enumValues: ApplicationStatus.values)
    ..aOM<$7.PageCursor>(7, _omitFieldNames ? '' : 'cursor', subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationSearchRequest clone() => ApplicationSearchRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationSearchRequest copyWith(void Function(ApplicationSearchRequest) updates) => super.copyWith((message) => updates(message as ApplicationSearchRequest)) as ApplicationSearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationSearchRequest create() => ApplicationSearchRequest._();
  ApplicationSearchRequest createEmptyInstance() => create();
  static $pb.PbList<ApplicationSearchRequest> createRepeated() => $pb.PbList<ApplicationSearchRequest>();
  @$core.pragma('dart2js:noInline')
  static ApplicationSearchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationSearchRequest>(create);
  static ApplicationSearchRequest? _defaultInstance;

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
  ApplicationStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(ApplicationStatus v) { setField(6, v); }
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

class ApplicationSearchResponse extends $pb.GeneratedMessage {
  factory ApplicationSearchResponse({
    $core.Iterable<ApplicationObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  ApplicationSearchResponse._() : super();
  factory ApplicationSearchResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationSearchResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationSearchResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..pc<ApplicationObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: ApplicationObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationSearchResponse clone() => ApplicationSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationSearchResponse copyWith(void Function(ApplicationSearchResponse) updates) => super.copyWith((message) => updates(message as ApplicationSearchResponse)) as ApplicationSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationSearchResponse create() => ApplicationSearchResponse._();
  ApplicationSearchResponse createEmptyInstance() => create();
  static $pb.PbList<ApplicationSearchResponse> createRepeated() => $pb.PbList<ApplicationSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static ApplicationSearchResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationSearchResponse>(create);
  static ApplicationSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ApplicationObject> get data => $_getList(0);
}

class ApplicationSubmitRequest extends $pb.GeneratedMessage {
  factory ApplicationSubmitRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  ApplicationSubmitRequest._() : super();
  factory ApplicationSubmitRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationSubmitRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationSubmitRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationSubmitRequest clone() => ApplicationSubmitRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationSubmitRequest copyWith(void Function(ApplicationSubmitRequest) updates) => super.copyWith((message) => updates(message as ApplicationSubmitRequest)) as ApplicationSubmitRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationSubmitRequest create() => ApplicationSubmitRequest._();
  ApplicationSubmitRequest createEmptyInstance() => create();
  static $pb.PbList<ApplicationSubmitRequest> createRepeated() => $pb.PbList<ApplicationSubmitRequest>();
  @$core.pragma('dart2js:noInline')
  static ApplicationSubmitRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationSubmitRequest>(create);
  static ApplicationSubmitRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class ApplicationSubmitResponse extends $pb.GeneratedMessage {
  factory ApplicationSubmitResponse({
    ApplicationObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  ApplicationSubmitResponse._() : super();
  factory ApplicationSubmitResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationSubmitResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationSubmitResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<ApplicationObject>(1, _omitFieldNames ? '' : 'data', subBuilder: ApplicationObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationSubmitResponse clone() => ApplicationSubmitResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationSubmitResponse copyWith(void Function(ApplicationSubmitResponse) updates) => super.copyWith((message) => updates(message as ApplicationSubmitResponse)) as ApplicationSubmitResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationSubmitResponse create() => ApplicationSubmitResponse._();
  ApplicationSubmitResponse createEmptyInstance() => create();
  static $pb.PbList<ApplicationSubmitResponse> createRepeated() => $pb.PbList<ApplicationSubmitResponse>();
  @$core.pragma('dart2js:noInline')
  static ApplicationSubmitResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationSubmitResponse>(create);
  static ApplicationSubmitResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ApplicationObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(ApplicationObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  ApplicationObject ensureData() => $_ensure(0);
}

class ApplicationCancelRequest extends $pb.GeneratedMessage {
  factory ApplicationCancelRequest({
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
  ApplicationCancelRequest._() : super();
  factory ApplicationCancelRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationCancelRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationCancelRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationCancelRequest clone() => ApplicationCancelRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationCancelRequest copyWith(void Function(ApplicationCancelRequest) updates) => super.copyWith((message) => updates(message as ApplicationCancelRequest)) as ApplicationCancelRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationCancelRequest create() => ApplicationCancelRequest._();
  ApplicationCancelRequest createEmptyInstance() => create();
  static $pb.PbList<ApplicationCancelRequest> createRepeated() => $pb.PbList<ApplicationCancelRequest>();
  @$core.pragma('dart2js:noInline')
  static ApplicationCancelRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationCancelRequest>(create);
  static ApplicationCancelRequest? _defaultInstance;

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

class ApplicationCancelResponse extends $pb.GeneratedMessage {
  factory ApplicationCancelResponse({
    ApplicationObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  ApplicationCancelResponse._() : super();
  factory ApplicationCancelResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationCancelResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationCancelResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<ApplicationObject>(1, _omitFieldNames ? '' : 'data', subBuilder: ApplicationObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationCancelResponse clone() => ApplicationCancelResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationCancelResponse copyWith(void Function(ApplicationCancelResponse) updates) => super.copyWith((message) => updates(message as ApplicationCancelResponse)) as ApplicationCancelResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationCancelResponse create() => ApplicationCancelResponse._();
  ApplicationCancelResponse createEmptyInstance() => create();
  static $pb.PbList<ApplicationCancelResponse> createRepeated() => $pb.PbList<ApplicationCancelResponse>();
  @$core.pragma('dart2js:noInline')
  static ApplicationCancelResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationCancelResponse>(create);
  static ApplicationCancelResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ApplicationObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(ApplicationObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  ApplicationObject ensureData() => $_ensure(0);
}

class ApplicationAcceptOfferRequest extends $pb.GeneratedMessage {
  factory ApplicationAcceptOfferRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  ApplicationAcceptOfferRequest._() : super();
  factory ApplicationAcceptOfferRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationAcceptOfferRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationAcceptOfferRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationAcceptOfferRequest clone() => ApplicationAcceptOfferRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationAcceptOfferRequest copyWith(void Function(ApplicationAcceptOfferRequest) updates) => super.copyWith((message) => updates(message as ApplicationAcceptOfferRequest)) as ApplicationAcceptOfferRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationAcceptOfferRequest create() => ApplicationAcceptOfferRequest._();
  ApplicationAcceptOfferRequest createEmptyInstance() => create();
  static $pb.PbList<ApplicationAcceptOfferRequest> createRepeated() => $pb.PbList<ApplicationAcceptOfferRequest>();
  @$core.pragma('dart2js:noInline')
  static ApplicationAcceptOfferRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationAcceptOfferRequest>(create);
  static ApplicationAcceptOfferRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class ApplicationAcceptOfferResponse extends $pb.GeneratedMessage {
  factory ApplicationAcceptOfferResponse({
    ApplicationObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  ApplicationAcceptOfferResponse._() : super();
  factory ApplicationAcceptOfferResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationAcceptOfferResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationAcceptOfferResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<ApplicationObject>(1, _omitFieldNames ? '' : 'data', subBuilder: ApplicationObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationAcceptOfferResponse clone() => ApplicationAcceptOfferResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationAcceptOfferResponse copyWith(void Function(ApplicationAcceptOfferResponse) updates) => super.copyWith((message) => updates(message as ApplicationAcceptOfferResponse)) as ApplicationAcceptOfferResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationAcceptOfferResponse create() => ApplicationAcceptOfferResponse._();
  ApplicationAcceptOfferResponse createEmptyInstance() => create();
  static $pb.PbList<ApplicationAcceptOfferResponse> createRepeated() => $pb.PbList<ApplicationAcceptOfferResponse>();
  @$core.pragma('dart2js:noInline')
  static ApplicationAcceptOfferResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationAcceptOfferResponse>(create);
  static ApplicationAcceptOfferResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ApplicationObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(ApplicationObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  ApplicationObject ensureData() => $_ensure(0);
}

class ApplicationDeclineOfferRequest extends $pb.GeneratedMessage {
  factory ApplicationDeclineOfferRequest({
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
  ApplicationDeclineOfferRequest._() : super();
  factory ApplicationDeclineOfferRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationDeclineOfferRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationDeclineOfferRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationDeclineOfferRequest clone() => ApplicationDeclineOfferRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationDeclineOfferRequest copyWith(void Function(ApplicationDeclineOfferRequest) updates) => super.copyWith((message) => updates(message as ApplicationDeclineOfferRequest)) as ApplicationDeclineOfferRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationDeclineOfferRequest create() => ApplicationDeclineOfferRequest._();
  ApplicationDeclineOfferRequest createEmptyInstance() => create();
  static $pb.PbList<ApplicationDeclineOfferRequest> createRepeated() => $pb.PbList<ApplicationDeclineOfferRequest>();
  @$core.pragma('dart2js:noInline')
  static ApplicationDeclineOfferRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationDeclineOfferRequest>(create);
  static ApplicationDeclineOfferRequest? _defaultInstance;

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

class ApplicationDeclineOfferResponse extends $pb.GeneratedMessage {
  factory ApplicationDeclineOfferResponse({
    ApplicationObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  ApplicationDeclineOfferResponse._() : super();
  factory ApplicationDeclineOfferResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationDeclineOfferResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationDeclineOfferResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<ApplicationObject>(1, _omitFieldNames ? '' : 'data', subBuilder: ApplicationObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationDeclineOfferResponse clone() => ApplicationDeclineOfferResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationDeclineOfferResponse copyWith(void Function(ApplicationDeclineOfferResponse) updates) => super.copyWith((message) => updates(message as ApplicationDeclineOfferResponse)) as ApplicationDeclineOfferResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationDeclineOfferResponse create() => ApplicationDeclineOfferResponse._();
  ApplicationDeclineOfferResponse createEmptyInstance() => create();
  static $pb.PbList<ApplicationDeclineOfferResponse> createRepeated() => $pb.PbList<ApplicationDeclineOfferResponse>();
  @$core.pragma('dart2js:noInline')
  static ApplicationDeclineOfferResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationDeclineOfferResponse>(create);
  static ApplicationDeclineOfferResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ApplicationObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(ApplicationObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  ApplicationObject ensureData() => $_ensure(0);
}

class ApplicationDocumentSaveRequest extends $pb.GeneratedMessage {
  factory ApplicationDocumentSaveRequest({
    ApplicationDocumentObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  ApplicationDocumentSaveRequest._() : super();
  factory ApplicationDocumentSaveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationDocumentSaveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationDocumentSaveRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<ApplicationDocumentObject>(1, _omitFieldNames ? '' : 'data', subBuilder: ApplicationDocumentObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationDocumentSaveRequest clone() => ApplicationDocumentSaveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationDocumentSaveRequest copyWith(void Function(ApplicationDocumentSaveRequest) updates) => super.copyWith((message) => updates(message as ApplicationDocumentSaveRequest)) as ApplicationDocumentSaveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationDocumentSaveRequest create() => ApplicationDocumentSaveRequest._();
  ApplicationDocumentSaveRequest createEmptyInstance() => create();
  static $pb.PbList<ApplicationDocumentSaveRequest> createRepeated() => $pb.PbList<ApplicationDocumentSaveRequest>();
  @$core.pragma('dart2js:noInline')
  static ApplicationDocumentSaveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationDocumentSaveRequest>(create);
  static ApplicationDocumentSaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ApplicationDocumentObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(ApplicationDocumentObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  ApplicationDocumentObject ensureData() => $_ensure(0);
}

class ApplicationDocumentSaveResponse extends $pb.GeneratedMessage {
  factory ApplicationDocumentSaveResponse({
    ApplicationDocumentObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  ApplicationDocumentSaveResponse._() : super();
  factory ApplicationDocumentSaveResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationDocumentSaveResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationDocumentSaveResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<ApplicationDocumentObject>(1, _omitFieldNames ? '' : 'data', subBuilder: ApplicationDocumentObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationDocumentSaveResponse clone() => ApplicationDocumentSaveResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationDocumentSaveResponse copyWith(void Function(ApplicationDocumentSaveResponse) updates) => super.copyWith((message) => updates(message as ApplicationDocumentSaveResponse)) as ApplicationDocumentSaveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationDocumentSaveResponse create() => ApplicationDocumentSaveResponse._();
  ApplicationDocumentSaveResponse createEmptyInstance() => create();
  static $pb.PbList<ApplicationDocumentSaveResponse> createRepeated() => $pb.PbList<ApplicationDocumentSaveResponse>();
  @$core.pragma('dart2js:noInline')
  static ApplicationDocumentSaveResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationDocumentSaveResponse>(create);
  static ApplicationDocumentSaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ApplicationDocumentObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(ApplicationDocumentObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  ApplicationDocumentObject ensureData() => $_ensure(0);
}

class ApplicationDocumentGetRequest extends $pb.GeneratedMessage {
  factory ApplicationDocumentGetRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  ApplicationDocumentGetRequest._() : super();
  factory ApplicationDocumentGetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationDocumentGetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationDocumentGetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationDocumentGetRequest clone() => ApplicationDocumentGetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationDocumentGetRequest copyWith(void Function(ApplicationDocumentGetRequest) updates) => super.copyWith((message) => updates(message as ApplicationDocumentGetRequest)) as ApplicationDocumentGetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationDocumentGetRequest create() => ApplicationDocumentGetRequest._();
  ApplicationDocumentGetRequest createEmptyInstance() => create();
  static $pb.PbList<ApplicationDocumentGetRequest> createRepeated() => $pb.PbList<ApplicationDocumentGetRequest>();
  @$core.pragma('dart2js:noInline')
  static ApplicationDocumentGetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationDocumentGetRequest>(create);
  static ApplicationDocumentGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class ApplicationDocumentGetResponse extends $pb.GeneratedMessage {
  factory ApplicationDocumentGetResponse({
    ApplicationDocumentObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  ApplicationDocumentGetResponse._() : super();
  factory ApplicationDocumentGetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationDocumentGetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationDocumentGetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<ApplicationDocumentObject>(1, _omitFieldNames ? '' : 'data', subBuilder: ApplicationDocumentObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationDocumentGetResponse clone() => ApplicationDocumentGetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationDocumentGetResponse copyWith(void Function(ApplicationDocumentGetResponse) updates) => super.copyWith((message) => updates(message as ApplicationDocumentGetResponse)) as ApplicationDocumentGetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationDocumentGetResponse create() => ApplicationDocumentGetResponse._();
  ApplicationDocumentGetResponse createEmptyInstance() => create();
  static $pb.PbList<ApplicationDocumentGetResponse> createRepeated() => $pb.PbList<ApplicationDocumentGetResponse>();
  @$core.pragma('dart2js:noInline')
  static ApplicationDocumentGetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationDocumentGetResponse>(create);
  static ApplicationDocumentGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ApplicationDocumentObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(ApplicationDocumentObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  ApplicationDocumentObject ensureData() => $_ensure(0);
}

class ApplicationDocumentSearchRequest extends $pb.GeneratedMessage {
  factory ApplicationDocumentSearchRequest({
    $core.String? applicationId,
    DocumentType? documentType,
    $7.PageCursor? cursor,
  }) {
    final $result = create();
    if (applicationId != null) {
      $result.applicationId = applicationId;
    }
    if (documentType != null) {
      $result.documentType = documentType;
    }
    if (cursor != null) {
      $result.cursor = cursor;
    }
    return $result;
  }
  ApplicationDocumentSearchRequest._() : super();
  factory ApplicationDocumentSearchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationDocumentSearchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationDocumentSearchRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'applicationId')
    ..e<DocumentType>(2, _omitFieldNames ? '' : 'documentType', $pb.PbFieldType.OE, defaultOrMaker: DocumentType.DOCUMENT_TYPE_UNSPECIFIED, valueOf: DocumentType.valueOf, enumValues: DocumentType.values)
    ..aOM<$7.PageCursor>(3, _omitFieldNames ? '' : 'cursor', subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationDocumentSearchRequest clone() => ApplicationDocumentSearchRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationDocumentSearchRequest copyWith(void Function(ApplicationDocumentSearchRequest) updates) => super.copyWith((message) => updates(message as ApplicationDocumentSearchRequest)) as ApplicationDocumentSearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationDocumentSearchRequest create() => ApplicationDocumentSearchRequest._();
  ApplicationDocumentSearchRequest createEmptyInstance() => create();
  static $pb.PbList<ApplicationDocumentSearchRequest> createRepeated() => $pb.PbList<ApplicationDocumentSearchRequest>();
  @$core.pragma('dart2js:noInline')
  static ApplicationDocumentSearchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationDocumentSearchRequest>(create);
  static ApplicationDocumentSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get applicationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set applicationId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasApplicationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearApplicationId() => clearField(1);

  @$pb.TagNumber(2)
  DocumentType get documentType => $_getN(1);
  @$pb.TagNumber(2)
  set documentType(DocumentType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasDocumentType() => $_has(1);
  @$pb.TagNumber(2)
  void clearDocumentType() => clearField(2);

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

class ApplicationDocumentSearchResponse extends $pb.GeneratedMessage {
  factory ApplicationDocumentSearchResponse({
    $core.Iterable<ApplicationDocumentObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  ApplicationDocumentSearchResponse._() : super();
  factory ApplicationDocumentSearchResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApplicationDocumentSearchResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApplicationDocumentSearchResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..pc<ApplicationDocumentObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: ApplicationDocumentObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApplicationDocumentSearchResponse clone() => ApplicationDocumentSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApplicationDocumentSearchResponse copyWith(void Function(ApplicationDocumentSearchResponse) updates) => super.copyWith((message) => updates(message as ApplicationDocumentSearchResponse)) as ApplicationDocumentSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationDocumentSearchResponse create() => ApplicationDocumentSearchResponse._();
  ApplicationDocumentSearchResponse createEmptyInstance() => create();
  static $pb.PbList<ApplicationDocumentSearchResponse> createRepeated() => $pb.PbList<ApplicationDocumentSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static ApplicationDocumentSearchResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApplicationDocumentSearchResponse>(create);
  static ApplicationDocumentSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ApplicationDocumentObject> get data => $_getList(0);
}

class VerificationTaskSaveRequest extends $pb.GeneratedMessage {
  factory VerificationTaskSaveRequest({
    VerificationTaskObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  VerificationTaskSaveRequest._() : super();
  factory VerificationTaskSaveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VerificationTaskSaveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VerificationTaskSaveRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<VerificationTaskObject>(1, _omitFieldNames ? '' : 'data', subBuilder: VerificationTaskObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VerificationTaskSaveRequest clone() => VerificationTaskSaveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VerificationTaskSaveRequest copyWith(void Function(VerificationTaskSaveRequest) updates) => super.copyWith((message) => updates(message as VerificationTaskSaveRequest)) as VerificationTaskSaveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerificationTaskSaveRequest create() => VerificationTaskSaveRequest._();
  VerificationTaskSaveRequest createEmptyInstance() => create();
  static $pb.PbList<VerificationTaskSaveRequest> createRepeated() => $pb.PbList<VerificationTaskSaveRequest>();
  @$core.pragma('dart2js:noInline')
  static VerificationTaskSaveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VerificationTaskSaveRequest>(create);
  static VerificationTaskSaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  VerificationTaskObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(VerificationTaskObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  VerificationTaskObject ensureData() => $_ensure(0);
}

class VerificationTaskSaveResponse extends $pb.GeneratedMessage {
  factory VerificationTaskSaveResponse({
    VerificationTaskObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  VerificationTaskSaveResponse._() : super();
  factory VerificationTaskSaveResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VerificationTaskSaveResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VerificationTaskSaveResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<VerificationTaskObject>(1, _omitFieldNames ? '' : 'data', subBuilder: VerificationTaskObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VerificationTaskSaveResponse clone() => VerificationTaskSaveResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VerificationTaskSaveResponse copyWith(void Function(VerificationTaskSaveResponse) updates) => super.copyWith((message) => updates(message as VerificationTaskSaveResponse)) as VerificationTaskSaveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerificationTaskSaveResponse create() => VerificationTaskSaveResponse._();
  VerificationTaskSaveResponse createEmptyInstance() => create();
  static $pb.PbList<VerificationTaskSaveResponse> createRepeated() => $pb.PbList<VerificationTaskSaveResponse>();
  @$core.pragma('dart2js:noInline')
  static VerificationTaskSaveResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VerificationTaskSaveResponse>(create);
  static VerificationTaskSaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  VerificationTaskObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(VerificationTaskObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  VerificationTaskObject ensureData() => $_ensure(0);
}

class VerificationTaskGetRequest extends $pb.GeneratedMessage {
  factory VerificationTaskGetRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  VerificationTaskGetRequest._() : super();
  factory VerificationTaskGetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VerificationTaskGetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VerificationTaskGetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VerificationTaskGetRequest clone() => VerificationTaskGetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VerificationTaskGetRequest copyWith(void Function(VerificationTaskGetRequest) updates) => super.copyWith((message) => updates(message as VerificationTaskGetRequest)) as VerificationTaskGetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerificationTaskGetRequest create() => VerificationTaskGetRequest._();
  VerificationTaskGetRequest createEmptyInstance() => create();
  static $pb.PbList<VerificationTaskGetRequest> createRepeated() => $pb.PbList<VerificationTaskGetRequest>();
  @$core.pragma('dart2js:noInline')
  static VerificationTaskGetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VerificationTaskGetRequest>(create);
  static VerificationTaskGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class VerificationTaskGetResponse extends $pb.GeneratedMessage {
  factory VerificationTaskGetResponse({
    VerificationTaskObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  VerificationTaskGetResponse._() : super();
  factory VerificationTaskGetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VerificationTaskGetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VerificationTaskGetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<VerificationTaskObject>(1, _omitFieldNames ? '' : 'data', subBuilder: VerificationTaskObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VerificationTaskGetResponse clone() => VerificationTaskGetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VerificationTaskGetResponse copyWith(void Function(VerificationTaskGetResponse) updates) => super.copyWith((message) => updates(message as VerificationTaskGetResponse)) as VerificationTaskGetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerificationTaskGetResponse create() => VerificationTaskGetResponse._();
  VerificationTaskGetResponse createEmptyInstance() => create();
  static $pb.PbList<VerificationTaskGetResponse> createRepeated() => $pb.PbList<VerificationTaskGetResponse>();
  @$core.pragma('dart2js:noInline')
  static VerificationTaskGetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VerificationTaskGetResponse>(create);
  static VerificationTaskGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  VerificationTaskObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(VerificationTaskObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  VerificationTaskObject ensureData() => $_ensure(0);
}

class VerificationTaskSearchRequest extends $pb.GeneratedMessage {
  factory VerificationTaskSearchRequest({
    $core.String? applicationId,
    $core.String? assignedTo,
    VerificationStatus? status,
    $7.PageCursor? cursor,
  }) {
    final $result = create();
    if (applicationId != null) {
      $result.applicationId = applicationId;
    }
    if (assignedTo != null) {
      $result.assignedTo = assignedTo;
    }
    if (status != null) {
      $result.status = status;
    }
    if (cursor != null) {
      $result.cursor = cursor;
    }
    return $result;
  }
  VerificationTaskSearchRequest._() : super();
  factory VerificationTaskSearchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VerificationTaskSearchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VerificationTaskSearchRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'applicationId')
    ..aOS(2, _omitFieldNames ? '' : 'assignedTo')
    ..e<VerificationStatus>(3, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: VerificationStatus.VERIFICATION_STATUS_UNSPECIFIED, valueOf: VerificationStatus.valueOf, enumValues: VerificationStatus.values)
    ..aOM<$7.PageCursor>(4, _omitFieldNames ? '' : 'cursor', subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VerificationTaskSearchRequest clone() => VerificationTaskSearchRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VerificationTaskSearchRequest copyWith(void Function(VerificationTaskSearchRequest) updates) => super.copyWith((message) => updates(message as VerificationTaskSearchRequest)) as VerificationTaskSearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerificationTaskSearchRequest create() => VerificationTaskSearchRequest._();
  VerificationTaskSearchRequest createEmptyInstance() => create();
  static $pb.PbList<VerificationTaskSearchRequest> createRepeated() => $pb.PbList<VerificationTaskSearchRequest>();
  @$core.pragma('dart2js:noInline')
  static VerificationTaskSearchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VerificationTaskSearchRequest>(create);
  static VerificationTaskSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get applicationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set applicationId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasApplicationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearApplicationId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get assignedTo => $_getSZ(1);
  @$pb.TagNumber(2)
  set assignedTo($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAssignedTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssignedTo() => clearField(2);

  @$pb.TagNumber(3)
  VerificationStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(VerificationStatus v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => clearField(3);

  @$pb.TagNumber(4)
  $7.PageCursor get cursor => $_getN(3);
  @$pb.TagNumber(4)
  set cursor($7.PageCursor v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCursor() => $_has(3);
  @$pb.TagNumber(4)
  void clearCursor() => clearField(4);
  @$pb.TagNumber(4)
  $7.PageCursor ensureCursor() => $_ensure(3);
}

class VerificationTaskSearchResponse extends $pb.GeneratedMessage {
  factory VerificationTaskSearchResponse({
    $core.Iterable<VerificationTaskObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  VerificationTaskSearchResponse._() : super();
  factory VerificationTaskSearchResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VerificationTaskSearchResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VerificationTaskSearchResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..pc<VerificationTaskObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: VerificationTaskObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VerificationTaskSearchResponse clone() => VerificationTaskSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VerificationTaskSearchResponse copyWith(void Function(VerificationTaskSearchResponse) updates) => super.copyWith((message) => updates(message as VerificationTaskSearchResponse)) as VerificationTaskSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerificationTaskSearchResponse create() => VerificationTaskSearchResponse._();
  VerificationTaskSearchResponse createEmptyInstance() => create();
  static $pb.PbList<VerificationTaskSearchResponse> createRepeated() => $pb.PbList<VerificationTaskSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static VerificationTaskSearchResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VerificationTaskSearchResponse>(create);
  static VerificationTaskSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<VerificationTaskObject> get data => $_getList(0);
}

class VerificationTaskCompleteRequest extends $pb.GeneratedMessage {
  factory VerificationTaskCompleteRequest({
    $core.String? id,
    VerificationStatus? status,
    $core.String? notes,
    $6.Struct? results,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (status != null) {
      $result.status = status;
    }
    if (notes != null) {
      $result.notes = notes;
    }
    if (results != null) {
      $result.results = results;
    }
    return $result;
  }
  VerificationTaskCompleteRequest._() : super();
  factory VerificationTaskCompleteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VerificationTaskCompleteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VerificationTaskCompleteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..e<VerificationStatus>(2, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: VerificationStatus.VERIFICATION_STATUS_UNSPECIFIED, valueOf: VerificationStatus.valueOf, enumValues: VerificationStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'notes')
    ..aOM<$6.Struct>(4, _omitFieldNames ? '' : 'results', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VerificationTaskCompleteRequest clone() => VerificationTaskCompleteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VerificationTaskCompleteRequest copyWith(void Function(VerificationTaskCompleteRequest) updates) => super.copyWith((message) => updates(message as VerificationTaskCompleteRequest)) as VerificationTaskCompleteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerificationTaskCompleteRequest create() => VerificationTaskCompleteRequest._();
  VerificationTaskCompleteRequest createEmptyInstance() => create();
  static $pb.PbList<VerificationTaskCompleteRequest> createRepeated() => $pb.PbList<VerificationTaskCompleteRequest>();
  @$core.pragma('dart2js:noInline')
  static VerificationTaskCompleteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VerificationTaskCompleteRequest>(create);
  static VerificationTaskCompleteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  VerificationStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(VerificationStatus v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get notes => $_getSZ(2);
  @$pb.TagNumber(3)
  set notes($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNotes() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotes() => clearField(3);

  @$pb.TagNumber(4)
  $6.Struct get results => $_getN(3);
  @$pb.TagNumber(4)
  set results($6.Struct v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasResults() => $_has(3);
  @$pb.TagNumber(4)
  void clearResults() => clearField(4);
  @$pb.TagNumber(4)
  $6.Struct ensureResults() => $_ensure(3);
}

class VerificationTaskCompleteResponse extends $pb.GeneratedMessage {
  factory VerificationTaskCompleteResponse({
    VerificationTaskObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  VerificationTaskCompleteResponse._() : super();
  factory VerificationTaskCompleteResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VerificationTaskCompleteResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VerificationTaskCompleteResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<VerificationTaskObject>(1, _omitFieldNames ? '' : 'data', subBuilder: VerificationTaskObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VerificationTaskCompleteResponse clone() => VerificationTaskCompleteResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VerificationTaskCompleteResponse copyWith(void Function(VerificationTaskCompleteResponse) updates) => super.copyWith((message) => updates(message as VerificationTaskCompleteResponse)) as VerificationTaskCompleteResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerificationTaskCompleteResponse create() => VerificationTaskCompleteResponse._();
  VerificationTaskCompleteResponse createEmptyInstance() => create();
  static $pb.PbList<VerificationTaskCompleteResponse> createRepeated() => $pb.PbList<VerificationTaskCompleteResponse>();
  @$core.pragma('dart2js:noInline')
  static VerificationTaskCompleteResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VerificationTaskCompleteResponse>(create);
  static VerificationTaskCompleteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  VerificationTaskObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(VerificationTaskObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  VerificationTaskObject ensureData() => $_ensure(0);
}

class UnderwritingDecisionSaveRequest extends $pb.GeneratedMessage {
  factory UnderwritingDecisionSaveRequest({
    UnderwritingDecisionObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  UnderwritingDecisionSaveRequest._() : super();
  factory UnderwritingDecisionSaveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UnderwritingDecisionSaveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UnderwritingDecisionSaveRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<UnderwritingDecisionObject>(1, _omitFieldNames ? '' : 'data', subBuilder: UnderwritingDecisionObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UnderwritingDecisionSaveRequest clone() => UnderwritingDecisionSaveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UnderwritingDecisionSaveRequest copyWith(void Function(UnderwritingDecisionSaveRequest) updates) => super.copyWith((message) => updates(message as UnderwritingDecisionSaveRequest)) as UnderwritingDecisionSaveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnderwritingDecisionSaveRequest create() => UnderwritingDecisionSaveRequest._();
  UnderwritingDecisionSaveRequest createEmptyInstance() => create();
  static $pb.PbList<UnderwritingDecisionSaveRequest> createRepeated() => $pb.PbList<UnderwritingDecisionSaveRequest>();
  @$core.pragma('dart2js:noInline')
  static UnderwritingDecisionSaveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnderwritingDecisionSaveRequest>(create);
  static UnderwritingDecisionSaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  UnderwritingDecisionObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(UnderwritingDecisionObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  UnderwritingDecisionObject ensureData() => $_ensure(0);
}

class UnderwritingDecisionSaveResponse extends $pb.GeneratedMessage {
  factory UnderwritingDecisionSaveResponse({
    UnderwritingDecisionObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  UnderwritingDecisionSaveResponse._() : super();
  factory UnderwritingDecisionSaveResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UnderwritingDecisionSaveResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UnderwritingDecisionSaveResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<UnderwritingDecisionObject>(1, _omitFieldNames ? '' : 'data', subBuilder: UnderwritingDecisionObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UnderwritingDecisionSaveResponse clone() => UnderwritingDecisionSaveResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UnderwritingDecisionSaveResponse copyWith(void Function(UnderwritingDecisionSaveResponse) updates) => super.copyWith((message) => updates(message as UnderwritingDecisionSaveResponse)) as UnderwritingDecisionSaveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnderwritingDecisionSaveResponse create() => UnderwritingDecisionSaveResponse._();
  UnderwritingDecisionSaveResponse createEmptyInstance() => create();
  static $pb.PbList<UnderwritingDecisionSaveResponse> createRepeated() => $pb.PbList<UnderwritingDecisionSaveResponse>();
  @$core.pragma('dart2js:noInline')
  static UnderwritingDecisionSaveResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnderwritingDecisionSaveResponse>(create);
  static UnderwritingDecisionSaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  UnderwritingDecisionObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(UnderwritingDecisionObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  UnderwritingDecisionObject ensureData() => $_ensure(0);
}

class UnderwritingDecisionGetRequest extends $pb.GeneratedMessage {
  factory UnderwritingDecisionGetRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  UnderwritingDecisionGetRequest._() : super();
  factory UnderwritingDecisionGetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UnderwritingDecisionGetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UnderwritingDecisionGetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UnderwritingDecisionGetRequest clone() => UnderwritingDecisionGetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UnderwritingDecisionGetRequest copyWith(void Function(UnderwritingDecisionGetRequest) updates) => super.copyWith((message) => updates(message as UnderwritingDecisionGetRequest)) as UnderwritingDecisionGetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnderwritingDecisionGetRequest create() => UnderwritingDecisionGetRequest._();
  UnderwritingDecisionGetRequest createEmptyInstance() => create();
  static $pb.PbList<UnderwritingDecisionGetRequest> createRepeated() => $pb.PbList<UnderwritingDecisionGetRequest>();
  @$core.pragma('dart2js:noInline')
  static UnderwritingDecisionGetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnderwritingDecisionGetRequest>(create);
  static UnderwritingDecisionGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class UnderwritingDecisionGetResponse extends $pb.GeneratedMessage {
  factory UnderwritingDecisionGetResponse({
    UnderwritingDecisionObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  UnderwritingDecisionGetResponse._() : super();
  factory UnderwritingDecisionGetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UnderwritingDecisionGetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UnderwritingDecisionGetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<UnderwritingDecisionObject>(1, _omitFieldNames ? '' : 'data', subBuilder: UnderwritingDecisionObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UnderwritingDecisionGetResponse clone() => UnderwritingDecisionGetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UnderwritingDecisionGetResponse copyWith(void Function(UnderwritingDecisionGetResponse) updates) => super.copyWith((message) => updates(message as UnderwritingDecisionGetResponse)) as UnderwritingDecisionGetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnderwritingDecisionGetResponse create() => UnderwritingDecisionGetResponse._();
  UnderwritingDecisionGetResponse createEmptyInstance() => create();
  static $pb.PbList<UnderwritingDecisionGetResponse> createRepeated() => $pb.PbList<UnderwritingDecisionGetResponse>();
  @$core.pragma('dart2js:noInline')
  static UnderwritingDecisionGetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnderwritingDecisionGetResponse>(create);
  static UnderwritingDecisionGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  UnderwritingDecisionObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(UnderwritingDecisionObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  UnderwritingDecisionObject ensureData() => $_ensure(0);
}

class UnderwritingDecisionSearchRequest extends $pb.GeneratedMessage {
  factory UnderwritingDecisionSearchRequest({
    $core.String? applicationId,
    $7.PageCursor? cursor,
  }) {
    final $result = create();
    if (applicationId != null) {
      $result.applicationId = applicationId;
    }
    if (cursor != null) {
      $result.cursor = cursor;
    }
    return $result;
  }
  UnderwritingDecisionSearchRequest._() : super();
  factory UnderwritingDecisionSearchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UnderwritingDecisionSearchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UnderwritingDecisionSearchRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'applicationId')
    ..aOM<$7.PageCursor>(2, _omitFieldNames ? '' : 'cursor', subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UnderwritingDecisionSearchRequest clone() => UnderwritingDecisionSearchRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UnderwritingDecisionSearchRequest copyWith(void Function(UnderwritingDecisionSearchRequest) updates) => super.copyWith((message) => updates(message as UnderwritingDecisionSearchRequest)) as UnderwritingDecisionSearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnderwritingDecisionSearchRequest create() => UnderwritingDecisionSearchRequest._();
  UnderwritingDecisionSearchRequest createEmptyInstance() => create();
  static $pb.PbList<UnderwritingDecisionSearchRequest> createRepeated() => $pb.PbList<UnderwritingDecisionSearchRequest>();
  @$core.pragma('dart2js:noInline')
  static UnderwritingDecisionSearchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnderwritingDecisionSearchRequest>(create);
  static UnderwritingDecisionSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get applicationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set applicationId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasApplicationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearApplicationId() => clearField(1);

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

class UnderwritingDecisionSearchResponse extends $pb.GeneratedMessage {
  factory UnderwritingDecisionSearchResponse({
    $core.Iterable<UnderwritingDecisionObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  UnderwritingDecisionSearchResponse._() : super();
  factory UnderwritingDecisionSearchResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UnderwritingDecisionSearchResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UnderwritingDecisionSearchResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..pc<UnderwritingDecisionObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: UnderwritingDecisionObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UnderwritingDecisionSearchResponse clone() => UnderwritingDecisionSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UnderwritingDecisionSearchResponse copyWith(void Function(UnderwritingDecisionSearchResponse) updates) => super.copyWith((message) => updates(message as UnderwritingDecisionSearchResponse)) as UnderwritingDecisionSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnderwritingDecisionSearchResponse create() => UnderwritingDecisionSearchResponse._();
  UnderwritingDecisionSearchResponse createEmptyInstance() => create();
  static $pb.PbList<UnderwritingDecisionSearchResponse> createRepeated() => $pb.PbList<UnderwritingDecisionSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static UnderwritingDecisionSearchResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnderwritingDecisionSearchResponse>(create);
  static UnderwritingDecisionSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<UnderwritingDecisionObject> get data => $_getList(0);
}

class FormTemplateSaveRequest extends $pb.GeneratedMessage {
  factory FormTemplateSaveRequest({
    FormTemplateObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  FormTemplateSaveRequest._() : super();
  factory FormTemplateSaveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FormTemplateSaveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FormTemplateSaveRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<FormTemplateObject>(1, _omitFieldNames ? '' : 'data', subBuilder: FormTemplateObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FormTemplateSaveRequest clone() => FormTemplateSaveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FormTemplateSaveRequest copyWith(void Function(FormTemplateSaveRequest) updates) => super.copyWith((message) => updates(message as FormTemplateSaveRequest)) as FormTemplateSaveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormTemplateSaveRequest create() => FormTemplateSaveRequest._();
  FormTemplateSaveRequest createEmptyInstance() => create();
  static $pb.PbList<FormTemplateSaveRequest> createRepeated() => $pb.PbList<FormTemplateSaveRequest>();
  @$core.pragma('dart2js:noInline')
  static FormTemplateSaveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FormTemplateSaveRequest>(create);
  static FormTemplateSaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  FormTemplateObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(FormTemplateObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  FormTemplateObject ensureData() => $_ensure(0);
}

class FormTemplateSaveResponse extends $pb.GeneratedMessage {
  factory FormTemplateSaveResponse({
    FormTemplateObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  FormTemplateSaveResponse._() : super();
  factory FormTemplateSaveResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FormTemplateSaveResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FormTemplateSaveResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<FormTemplateObject>(1, _omitFieldNames ? '' : 'data', subBuilder: FormTemplateObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FormTemplateSaveResponse clone() => FormTemplateSaveResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FormTemplateSaveResponse copyWith(void Function(FormTemplateSaveResponse) updates) => super.copyWith((message) => updates(message as FormTemplateSaveResponse)) as FormTemplateSaveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormTemplateSaveResponse create() => FormTemplateSaveResponse._();
  FormTemplateSaveResponse createEmptyInstance() => create();
  static $pb.PbList<FormTemplateSaveResponse> createRepeated() => $pb.PbList<FormTemplateSaveResponse>();
  @$core.pragma('dart2js:noInline')
  static FormTemplateSaveResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FormTemplateSaveResponse>(create);
  static FormTemplateSaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FormTemplateObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(FormTemplateObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  FormTemplateObject ensureData() => $_ensure(0);
}

class FormTemplateGetRequest extends $pb.GeneratedMessage {
  factory FormTemplateGetRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  FormTemplateGetRequest._() : super();
  factory FormTemplateGetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FormTemplateGetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FormTemplateGetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FormTemplateGetRequest clone() => FormTemplateGetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FormTemplateGetRequest copyWith(void Function(FormTemplateGetRequest) updates) => super.copyWith((message) => updates(message as FormTemplateGetRequest)) as FormTemplateGetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormTemplateGetRequest create() => FormTemplateGetRequest._();
  FormTemplateGetRequest createEmptyInstance() => create();
  static $pb.PbList<FormTemplateGetRequest> createRepeated() => $pb.PbList<FormTemplateGetRequest>();
  @$core.pragma('dart2js:noInline')
  static FormTemplateGetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FormTemplateGetRequest>(create);
  static FormTemplateGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class FormTemplateGetResponse extends $pb.GeneratedMessage {
  factory FormTemplateGetResponse({
    FormTemplateObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  FormTemplateGetResponse._() : super();
  factory FormTemplateGetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FormTemplateGetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FormTemplateGetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<FormTemplateObject>(1, _omitFieldNames ? '' : 'data', subBuilder: FormTemplateObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FormTemplateGetResponse clone() => FormTemplateGetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FormTemplateGetResponse copyWith(void Function(FormTemplateGetResponse) updates) => super.copyWith((message) => updates(message as FormTemplateGetResponse)) as FormTemplateGetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormTemplateGetResponse create() => FormTemplateGetResponse._();
  FormTemplateGetResponse createEmptyInstance() => create();
  static $pb.PbList<FormTemplateGetResponse> createRepeated() => $pb.PbList<FormTemplateGetResponse>();
  @$core.pragma('dart2js:noInline')
  static FormTemplateGetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FormTemplateGetResponse>(create);
  static FormTemplateGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FormTemplateObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(FormTemplateObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  FormTemplateObject ensureData() => $_ensure(0);
}

class FormTemplateSearchRequest extends $pb.GeneratedMessage {
  factory FormTemplateSearchRequest({
    $core.String? query,
    $core.String? organizationId,
    FormTemplateStatus? status,
    $7.PageCursor? cursor,
  }) {
    final $result = create();
    if (query != null) {
      $result.query = query;
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
  FormTemplateSearchRequest._() : super();
  factory FormTemplateSearchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FormTemplateSearchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FormTemplateSearchRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aOS(2, _omitFieldNames ? '' : 'organizationId')
    ..e<FormTemplateStatus>(3, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: FormTemplateStatus.FORM_TEMPLATE_STATUS_UNSPECIFIED, valueOf: FormTemplateStatus.valueOf, enumValues: FormTemplateStatus.values)
    ..aOM<$7.PageCursor>(4, _omitFieldNames ? '' : 'cursor', subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FormTemplateSearchRequest clone() => FormTemplateSearchRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FormTemplateSearchRequest copyWith(void Function(FormTemplateSearchRequest) updates) => super.copyWith((message) => updates(message as FormTemplateSearchRequest)) as FormTemplateSearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormTemplateSearchRequest create() => FormTemplateSearchRequest._();
  FormTemplateSearchRequest createEmptyInstance() => create();
  static $pb.PbList<FormTemplateSearchRequest> createRepeated() => $pb.PbList<FormTemplateSearchRequest>();
  @$core.pragma('dart2js:noInline')
  static FormTemplateSearchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FormTemplateSearchRequest>(create);
  static FormTemplateSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get organizationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set organizationId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOrganizationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrganizationId() => clearField(2);

  @$pb.TagNumber(3)
  FormTemplateStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(FormTemplateStatus v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => clearField(3);

  @$pb.TagNumber(4)
  $7.PageCursor get cursor => $_getN(3);
  @$pb.TagNumber(4)
  set cursor($7.PageCursor v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCursor() => $_has(3);
  @$pb.TagNumber(4)
  void clearCursor() => clearField(4);
  @$pb.TagNumber(4)
  $7.PageCursor ensureCursor() => $_ensure(3);
}

class FormTemplateSearchResponse extends $pb.GeneratedMessage {
  factory FormTemplateSearchResponse({
    $core.Iterable<FormTemplateObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  FormTemplateSearchResponse._() : super();
  factory FormTemplateSearchResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FormTemplateSearchResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FormTemplateSearchResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..pc<FormTemplateObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: FormTemplateObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FormTemplateSearchResponse clone() => FormTemplateSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FormTemplateSearchResponse copyWith(void Function(FormTemplateSearchResponse) updates) => super.copyWith((message) => updates(message as FormTemplateSearchResponse)) as FormTemplateSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormTemplateSearchResponse create() => FormTemplateSearchResponse._();
  FormTemplateSearchResponse createEmptyInstance() => create();
  static $pb.PbList<FormTemplateSearchResponse> createRepeated() => $pb.PbList<FormTemplateSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static FormTemplateSearchResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FormTemplateSearchResponse>(create);
  static FormTemplateSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<FormTemplateObject> get data => $_getList(0);
}

class FormTemplatePublishRequest extends $pb.GeneratedMessage {
  factory FormTemplatePublishRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  FormTemplatePublishRequest._() : super();
  factory FormTemplatePublishRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FormTemplatePublishRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FormTemplatePublishRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FormTemplatePublishRequest clone() => FormTemplatePublishRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FormTemplatePublishRequest copyWith(void Function(FormTemplatePublishRequest) updates) => super.copyWith((message) => updates(message as FormTemplatePublishRequest)) as FormTemplatePublishRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormTemplatePublishRequest create() => FormTemplatePublishRequest._();
  FormTemplatePublishRequest createEmptyInstance() => create();
  static $pb.PbList<FormTemplatePublishRequest> createRepeated() => $pb.PbList<FormTemplatePublishRequest>();
  @$core.pragma('dart2js:noInline')
  static FormTemplatePublishRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FormTemplatePublishRequest>(create);
  static FormTemplatePublishRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class FormTemplatePublishResponse extends $pb.GeneratedMessage {
  factory FormTemplatePublishResponse({
    FormTemplateObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  FormTemplatePublishResponse._() : super();
  factory FormTemplatePublishResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FormTemplatePublishResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FormTemplatePublishResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<FormTemplateObject>(1, _omitFieldNames ? '' : 'data', subBuilder: FormTemplateObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FormTemplatePublishResponse clone() => FormTemplatePublishResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FormTemplatePublishResponse copyWith(void Function(FormTemplatePublishResponse) updates) => super.copyWith((message) => updates(message as FormTemplatePublishResponse)) as FormTemplatePublishResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormTemplatePublishResponse create() => FormTemplatePublishResponse._();
  FormTemplatePublishResponse createEmptyInstance() => create();
  static $pb.PbList<FormTemplatePublishResponse> createRepeated() => $pb.PbList<FormTemplatePublishResponse>();
  @$core.pragma('dart2js:noInline')
  static FormTemplatePublishResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FormTemplatePublishResponse>(create);
  static FormTemplatePublishResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FormTemplateObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(FormTemplateObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  FormTemplateObject ensureData() => $_ensure(0);
}

class FormSubmissionSaveRequest extends $pb.GeneratedMessage {
  factory FormSubmissionSaveRequest({
    FormSubmissionObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  FormSubmissionSaveRequest._() : super();
  factory FormSubmissionSaveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FormSubmissionSaveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FormSubmissionSaveRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<FormSubmissionObject>(1, _omitFieldNames ? '' : 'data', subBuilder: FormSubmissionObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FormSubmissionSaveRequest clone() => FormSubmissionSaveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FormSubmissionSaveRequest copyWith(void Function(FormSubmissionSaveRequest) updates) => super.copyWith((message) => updates(message as FormSubmissionSaveRequest)) as FormSubmissionSaveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormSubmissionSaveRequest create() => FormSubmissionSaveRequest._();
  FormSubmissionSaveRequest createEmptyInstance() => create();
  static $pb.PbList<FormSubmissionSaveRequest> createRepeated() => $pb.PbList<FormSubmissionSaveRequest>();
  @$core.pragma('dart2js:noInline')
  static FormSubmissionSaveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FormSubmissionSaveRequest>(create);
  static FormSubmissionSaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  FormSubmissionObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(FormSubmissionObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  FormSubmissionObject ensureData() => $_ensure(0);
}

class FormSubmissionSaveResponse extends $pb.GeneratedMessage {
  factory FormSubmissionSaveResponse({
    FormSubmissionObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  FormSubmissionSaveResponse._() : super();
  factory FormSubmissionSaveResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FormSubmissionSaveResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FormSubmissionSaveResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<FormSubmissionObject>(1, _omitFieldNames ? '' : 'data', subBuilder: FormSubmissionObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FormSubmissionSaveResponse clone() => FormSubmissionSaveResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FormSubmissionSaveResponse copyWith(void Function(FormSubmissionSaveResponse) updates) => super.copyWith((message) => updates(message as FormSubmissionSaveResponse)) as FormSubmissionSaveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormSubmissionSaveResponse create() => FormSubmissionSaveResponse._();
  FormSubmissionSaveResponse createEmptyInstance() => create();
  static $pb.PbList<FormSubmissionSaveResponse> createRepeated() => $pb.PbList<FormSubmissionSaveResponse>();
  @$core.pragma('dart2js:noInline')
  static FormSubmissionSaveResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FormSubmissionSaveResponse>(create);
  static FormSubmissionSaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FormSubmissionObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(FormSubmissionObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  FormSubmissionObject ensureData() => $_ensure(0);
}

class FormSubmissionGetRequest extends $pb.GeneratedMessage {
  factory FormSubmissionGetRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  FormSubmissionGetRequest._() : super();
  factory FormSubmissionGetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FormSubmissionGetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FormSubmissionGetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FormSubmissionGetRequest clone() => FormSubmissionGetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FormSubmissionGetRequest copyWith(void Function(FormSubmissionGetRequest) updates) => super.copyWith((message) => updates(message as FormSubmissionGetRequest)) as FormSubmissionGetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormSubmissionGetRequest create() => FormSubmissionGetRequest._();
  FormSubmissionGetRequest createEmptyInstance() => create();
  static $pb.PbList<FormSubmissionGetRequest> createRepeated() => $pb.PbList<FormSubmissionGetRequest>();
  @$core.pragma('dart2js:noInline')
  static FormSubmissionGetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FormSubmissionGetRequest>(create);
  static FormSubmissionGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class FormSubmissionGetResponse extends $pb.GeneratedMessage {
  factory FormSubmissionGetResponse({
    FormSubmissionObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  FormSubmissionGetResponse._() : super();
  factory FormSubmissionGetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FormSubmissionGetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FormSubmissionGetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOM<FormSubmissionObject>(1, _omitFieldNames ? '' : 'data', subBuilder: FormSubmissionObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FormSubmissionGetResponse clone() => FormSubmissionGetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FormSubmissionGetResponse copyWith(void Function(FormSubmissionGetResponse) updates) => super.copyWith((message) => updates(message as FormSubmissionGetResponse)) as FormSubmissionGetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormSubmissionGetResponse create() => FormSubmissionGetResponse._();
  FormSubmissionGetResponse createEmptyInstance() => create();
  static $pb.PbList<FormSubmissionGetResponse> createRepeated() => $pb.PbList<FormSubmissionGetResponse>();
  @$core.pragma('dart2js:noInline')
  static FormSubmissionGetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FormSubmissionGetResponse>(create);
  static FormSubmissionGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FormSubmissionObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(FormSubmissionObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  FormSubmissionObject ensureData() => $_ensure(0);
}

class FormSubmissionSearchRequest extends $pb.GeneratedMessage {
  factory FormSubmissionSearchRequest({
    $core.String? applicationId,
    $core.String? templateId,
    $7.PageCursor? cursor,
  }) {
    final $result = create();
    if (applicationId != null) {
      $result.applicationId = applicationId;
    }
    if (templateId != null) {
      $result.templateId = templateId;
    }
    if (cursor != null) {
      $result.cursor = cursor;
    }
    return $result;
  }
  FormSubmissionSearchRequest._() : super();
  factory FormSubmissionSearchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FormSubmissionSearchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FormSubmissionSearchRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'applicationId')
    ..aOS(2, _omitFieldNames ? '' : 'templateId')
    ..aOM<$7.PageCursor>(3, _omitFieldNames ? '' : 'cursor', subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FormSubmissionSearchRequest clone() => FormSubmissionSearchRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FormSubmissionSearchRequest copyWith(void Function(FormSubmissionSearchRequest) updates) => super.copyWith((message) => updates(message as FormSubmissionSearchRequest)) as FormSubmissionSearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormSubmissionSearchRequest create() => FormSubmissionSearchRequest._();
  FormSubmissionSearchRequest createEmptyInstance() => create();
  static $pb.PbList<FormSubmissionSearchRequest> createRepeated() => $pb.PbList<FormSubmissionSearchRequest>();
  @$core.pragma('dart2js:noInline')
  static FormSubmissionSearchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FormSubmissionSearchRequest>(create);
  static FormSubmissionSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get applicationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set applicationId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasApplicationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearApplicationId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get templateId => $_getSZ(1);
  @$pb.TagNumber(2)
  set templateId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTemplateId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTemplateId() => clearField(2);

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

class FormSubmissionSearchResponse extends $pb.GeneratedMessage {
  factory FormSubmissionSearchResponse({
    $core.Iterable<FormSubmissionObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  FormSubmissionSearchResponse._() : super();
  factory FormSubmissionSearchResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FormSubmissionSearchResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FormSubmissionSearchResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'origination.v1'), createEmptyInstance: create)
    ..pc<FormSubmissionObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: FormSubmissionObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FormSubmissionSearchResponse clone() => FormSubmissionSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FormSubmissionSearchResponse copyWith(void Function(FormSubmissionSearchResponse) updates) => super.copyWith((message) => updates(message as FormSubmissionSearchResponse)) as FormSubmissionSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormSubmissionSearchResponse create() => FormSubmissionSearchResponse._();
  FormSubmissionSearchResponse createEmptyInstance() => create();
  static $pb.PbList<FormSubmissionSearchResponse> createRepeated() => $pb.PbList<FormSubmissionSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static FormSubmissionSearchResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FormSubmissionSearchResponse>(create);
  static FormSubmissionSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<FormSubmissionObject> get data => $_getList(0);
}

class OriginationServiceApi {
  $pb.RpcClient _client;
  OriginationServiceApi(this._client);

  $async.Future<LoanProductSaveResponse> loanProductSave($pb.ClientContext? ctx, LoanProductSaveRequest request) =>
    _client.invoke<LoanProductSaveResponse>(ctx, 'OriginationService', 'LoanProductSave', request, LoanProductSaveResponse())
  ;
  $async.Future<LoanProductGetResponse> loanProductGet($pb.ClientContext? ctx, LoanProductGetRequest request) =>
    _client.invoke<LoanProductGetResponse>(ctx, 'OriginationService', 'LoanProductGet', request, LoanProductGetResponse())
  ;
  $async.Future<LoanProductSearchResponse> loanProductSearch($pb.ClientContext? ctx, LoanProductSearchRequest request) =>
    _client.invoke<LoanProductSearchResponse>(ctx, 'OriginationService', 'LoanProductSearch', request, LoanProductSearchResponse())
  ;
  $async.Future<ApplicationSaveResponse> applicationSave($pb.ClientContext? ctx, ApplicationSaveRequest request) =>
    _client.invoke<ApplicationSaveResponse>(ctx, 'OriginationService', 'ApplicationSave', request, ApplicationSaveResponse())
  ;
  $async.Future<ApplicationGetResponse> applicationGet($pb.ClientContext? ctx, ApplicationGetRequest request) =>
    _client.invoke<ApplicationGetResponse>(ctx, 'OriginationService', 'ApplicationGet', request, ApplicationGetResponse())
  ;
  $async.Future<ApplicationSearchResponse> applicationSearch($pb.ClientContext? ctx, ApplicationSearchRequest request) =>
    _client.invoke<ApplicationSearchResponse>(ctx, 'OriginationService', 'ApplicationSearch', request, ApplicationSearchResponse())
  ;
  $async.Future<ApplicationSubmitResponse> applicationSubmit($pb.ClientContext? ctx, ApplicationSubmitRequest request) =>
    _client.invoke<ApplicationSubmitResponse>(ctx, 'OriginationService', 'ApplicationSubmit', request, ApplicationSubmitResponse())
  ;
  $async.Future<ApplicationCancelResponse> applicationCancel($pb.ClientContext? ctx, ApplicationCancelRequest request) =>
    _client.invoke<ApplicationCancelResponse>(ctx, 'OriginationService', 'ApplicationCancel', request, ApplicationCancelResponse())
  ;
  $async.Future<ApplicationAcceptOfferResponse> applicationAcceptOffer($pb.ClientContext? ctx, ApplicationAcceptOfferRequest request) =>
    _client.invoke<ApplicationAcceptOfferResponse>(ctx, 'OriginationService', 'ApplicationAcceptOffer', request, ApplicationAcceptOfferResponse())
  ;
  $async.Future<ApplicationDeclineOfferResponse> applicationDeclineOffer($pb.ClientContext? ctx, ApplicationDeclineOfferRequest request) =>
    _client.invoke<ApplicationDeclineOfferResponse>(ctx, 'OriginationService', 'ApplicationDeclineOffer', request, ApplicationDeclineOfferResponse())
  ;
  $async.Future<ApplicationDocumentSaveResponse> applicationDocumentSave($pb.ClientContext? ctx, ApplicationDocumentSaveRequest request) =>
    _client.invoke<ApplicationDocumentSaveResponse>(ctx, 'OriginationService', 'ApplicationDocumentSave', request, ApplicationDocumentSaveResponse())
  ;
  $async.Future<ApplicationDocumentGetResponse> applicationDocumentGet($pb.ClientContext? ctx, ApplicationDocumentGetRequest request) =>
    _client.invoke<ApplicationDocumentGetResponse>(ctx, 'OriginationService', 'ApplicationDocumentGet', request, ApplicationDocumentGetResponse())
  ;
  $async.Future<ApplicationDocumentSearchResponse> applicationDocumentSearch($pb.ClientContext? ctx, ApplicationDocumentSearchRequest request) =>
    _client.invoke<ApplicationDocumentSearchResponse>(ctx, 'OriginationService', 'ApplicationDocumentSearch', request, ApplicationDocumentSearchResponse())
  ;
  $async.Future<VerificationTaskSaveResponse> verificationTaskSave($pb.ClientContext? ctx, VerificationTaskSaveRequest request) =>
    _client.invoke<VerificationTaskSaveResponse>(ctx, 'OriginationService', 'VerificationTaskSave', request, VerificationTaskSaveResponse())
  ;
  $async.Future<VerificationTaskGetResponse> verificationTaskGet($pb.ClientContext? ctx, VerificationTaskGetRequest request) =>
    _client.invoke<VerificationTaskGetResponse>(ctx, 'OriginationService', 'VerificationTaskGet', request, VerificationTaskGetResponse())
  ;
  $async.Future<VerificationTaskSearchResponse> verificationTaskSearch($pb.ClientContext? ctx, VerificationTaskSearchRequest request) =>
    _client.invoke<VerificationTaskSearchResponse>(ctx, 'OriginationService', 'VerificationTaskSearch', request, VerificationTaskSearchResponse())
  ;
  $async.Future<VerificationTaskCompleteResponse> verificationTaskComplete($pb.ClientContext? ctx, VerificationTaskCompleteRequest request) =>
    _client.invoke<VerificationTaskCompleteResponse>(ctx, 'OriginationService', 'VerificationTaskComplete', request, VerificationTaskCompleteResponse())
  ;
  $async.Future<UnderwritingDecisionSaveResponse> underwritingDecisionSave($pb.ClientContext? ctx, UnderwritingDecisionSaveRequest request) =>
    _client.invoke<UnderwritingDecisionSaveResponse>(ctx, 'OriginationService', 'UnderwritingDecisionSave', request, UnderwritingDecisionSaveResponse())
  ;
  $async.Future<UnderwritingDecisionGetResponse> underwritingDecisionGet($pb.ClientContext? ctx, UnderwritingDecisionGetRequest request) =>
    _client.invoke<UnderwritingDecisionGetResponse>(ctx, 'OriginationService', 'UnderwritingDecisionGet', request, UnderwritingDecisionGetResponse())
  ;
  $async.Future<UnderwritingDecisionSearchResponse> underwritingDecisionSearch($pb.ClientContext? ctx, UnderwritingDecisionSearchRequest request) =>
    _client.invoke<UnderwritingDecisionSearchResponse>(ctx, 'OriginationService', 'UnderwritingDecisionSearch', request, UnderwritingDecisionSearchResponse())
  ;
  $async.Future<FormTemplateSaveResponse> formTemplateSave($pb.ClientContext? ctx, FormTemplateSaveRequest request) =>
    _client.invoke<FormTemplateSaveResponse>(ctx, 'OriginationService', 'FormTemplateSave', request, FormTemplateSaveResponse())
  ;
  $async.Future<FormTemplateGetResponse> formTemplateGet($pb.ClientContext? ctx, FormTemplateGetRequest request) =>
    _client.invoke<FormTemplateGetResponse>(ctx, 'OriginationService', 'FormTemplateGet', request, FormTemplateGetResponse())
  ;
  $async.Future<FormTemplateSearchResponse> formTemplateSearch($pb.ClientContext? ctx, FormTemplateSearchRequest request) =>
    _client.invoke<FormTemplateSearchResponse>(ctx, 'OriginationService', 'FormTemplateSearch', request, FormTemplateSearchResponse())
  ;
  $async.Future<FormTemplatePublishResponse> formTemplatePublish($pb.ClientContext? ctx, FormTemplatePublishRequest request) =>
    _client.invoke<FormTemplatePublishResponse>(ctx, 'OriginationService', 'FormTemplatePublish', request, FormTemplatePublishResponse())
  ;
  $async.Future<FormSubmissionSaveResponse> formSubmissionSave($pb.ClientContext? ctx, FormSubmissionSaveRequest request) =>
    _client.invoke<FormSubmissionSaveResponse>(ctx, 'OriginationService', 'FormSubmissionSave', request, FormSubmissionSaveResponse())
  ;
  $async.Future<FormSubmissionGetResponse> formSubmissionGet($pb.ClientContext? ctx, FormSubmissionGetRequest request) =>
    _client.invoke<FormSubmissionGetResponse>(ctx, 'OriginationService', 'FormSubmissionGet', request, FormSubmissionGetResponse())
  ;
  $async.Future<FormSubmissionSearchResponse> formSubmissionSearch($pb.ClientContext? ctx, FormSubmissionSearchRequest request) =>
    _client.invoke<FormSubmissionSearchResponse>(ctx, 'OriginationService', 'FormSubmissionSearch', request, FormSubmissionSearchResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
