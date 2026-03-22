//
//  Generated code. Do not modify.
//  source: field/v1/field.proto
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
import 'field.pbenum.dart';

export 'field.pbenum.dart';

/// AgentObject represents a field agent in the lending hierarchy.
/// Agents are organized in a tree structure within branches.
class AgentObject extends $pb.GeneratedMessage {
  factory AgentObject({
    $core.String? id,
    $core.String? branchId,
    $core.String? parentAgentId,
    $core.String? profileId,
    AgentType? agentType,
    $core.String? name,
    $core.String? geoId,
    $core.int? depth,
    $7.STATE? state,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (branchId != null) {
      $result.branchId = branchId;
    }
    if (parentAgentId != null) {
      $result.parentAgentId = parentAgentId;
    }
    if (profileId != null) {
      $result.profileId = profileId;
    }
    if (agentType != null) {
      $result.agentType = agentType;
    }
    if (name != null) {
      $result.name = name;
    }
    if (geoId != null) {
      $result.geoId = geoId;
    }
    if (depth != null) {
      $result.depth = depth;
    }
    if (state != null) {
      $result.state = state;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  AgentObject._() : super();
  factory AgentObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AgentObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AgentObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'field.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'branchId')
    ..aOS(3, _omitFieldNames ? '' : 'parentAgentId')
    ..aOS(4, _omitFieldNames ? '' : 'profileId')
    ..e<AgentType>(5, _omitFieldNames ? '' : 'agentType', $pb.PbFieldType.OE, defaultOrMaker: AgentType.AGENT_TYPE_UNSPECIFIED, valueOf: AgentType.valueOf, enumValues: AgentType.values)
    ..aOS(6, _omitFieldNames ? '' : 'name')
    ..aOS(7, _omitFieldNames ? '' : 'geoId')
    ..a<$core.int>(8, _omitFieldNames ? '' : 'depth', $pb.PbFieldType.O3)
    ..e<$7.STATE>(9, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: $7.STATE.CREATED, valueOf: $7.STATE.valueOf, enumValues: $7.STATE.values)
    ..aOM<$6.Struct>(10, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AgentObject clone() => AgentObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AgentObject copyWith(void Function(AgentObject) updates) => super.copyWith((message) => updates(message as AgentObject)) as AgentObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgentObject create() => AgentObject._();
  AgentObject createEmptyInstance() => create();
  static $pb.PbList<AgentObject> createRepeated() => $pb.PbList<AgentObject>();
  @$core.pragma('dart2js:noInline')
  static AgentObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgentObject>(create);
  static AgentObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get branchId => $_getSZ(1);
  @$pb.TagNumber(2)
  set branchId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBranchId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBranchId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get parentAgentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set parentAgentId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasParentAgentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearParentAgentId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get profileId => $_getSZ(3);
  @$pb.TagNumber(4)
  set profileId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasProfileId() => $_has(3);
  @$pb.TagNumber(4)
  void clearProfileId() => clearField(4);

  @$pb.TagNumber(5)
  AgentType get agentType => $_getN(4);
  @$pb.TagNumber(5)
  set agentType(AgentType v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasAgentType() => $_has(4);
  @$pb.TagNumber(5)
  void clearAgentType() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get name => $_getSZ(5);
  @$pb.TagNumber(6)
  set name($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasName() => $_has(5);
  @$pb.TagNumber(6)
  void clearName() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get geoId => $_getSZ(6);
  @$pb.TagNumber(7)
  set geoId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasGeoId() => $_has(6);
  @$pb.TagNumber(7)
  void clearGeoId() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get depth => $_getIZ(7);
  @$pb.TagNumber(8)
  set depth($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasDepth() => $_has(7);
  @$pb.TagNumber(8)
  void clearDepth() => clearField(8);

  @$pb.TagNumber(9)
  $7.STATE get state => $_getN(8);
  @$pb.TagNumber(9)
  set state($7.STATE v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasState() => $_has(8);
  @$pb.TagNumber(9)
  void clearState() => clearField(9);

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

/// BorrowerObject represents a loan recipient assigned to an agent.
class BorrowerObject extends $pb.GeneratedMessage {
  factory BorrowerObject({
    $core.String? id,
    $core.String? agentId,
    $core.String? profileId,
    $core.String? name,
    $7.STATE? state,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (agentId != null) {
      $result.agentId = agentId;
    }
    if (profileId != null) {
      $result.profileId = profileId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (state != null) {
      $result.state = state;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  BorrowerObject._() : super();
  factory BorrowerObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BorrowerObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BorrowerObject', package: const $pb.PackageName(_omitMessageNames ? '' : 'field.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'agentId')
    ..aOS(3, _omitFieldNames ? '' : 'profileId')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..e<$7.STATE>(5, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: $7.STATE.CREATED, valueOf: $7.STATE.valueOf, enumValues: $7.STATE.values)
    ..aOM<$6.Struct>(6, _omitFieldNames ? '' : 'properties', subBuilder: $6.Struct.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BorrowerObject clone() => BorrowerObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BorrowerObject copyWith(void Function(BorrowerObject) updates) => super.copyWith((message) => updates(message as BorrowerObject)) as BorrowerObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BorrowerObject create() => BorrowerObject._();
  BorrowerObject createEmptyInstance() => create();
  static $pb.PbList<BorrowerObject> createRepeated() => $pb.PbList<BorrowerObject>();
  @$core.pragma('dart2js:noInline')
  static BorrowerObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BorrowerObject>(create);
  static BorrowerObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get agentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set agentId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAgentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAgentId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get profileId => $_getSZ(2);
  @$pb.TagNumber(3)
  set profileId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasProfileId() => $_has(2);
  @$pb.TagNumber(3)
  void clearProfileId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => clearField(4);

  @$pb.TagNumber(5)
  $7.STATE get state => $_getN(4);
  @$pb.TagNumber(5)
  set state($7.STATE v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasState() => $_has(4);
  @$pb.TagNumber(5)
  void clearState() => clearField(5);

  @$pb.TagNumber(6)
  $6.Struct get properties => $_getN(5);
  @$pb.TagNumber(6)
  set properties($6.Struct v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasProperties() => $_has(5);
  @$pb.TagNumber(6)
  void clearProperties() => clearField(6);
  @$pb.TagNumber(6)
  $6.Struct ensureProperties() => $_ensure(5);
}

/// Agent messages
class AgentSaveRequest extends $pb.GeneratedMessage {
  factory AgentSaveRequest({
    AgentObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  AgentSaveRequest._() : super();
  factory AgentSaveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AgentSaveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AgentSaveRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'field.v1'), createEmptyInstance: create)
    ..aOM<AgentObject>(1, _omitFieldNames ? '' : 'data', subBuilder: AgentObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AgentSaveRequest clone() => AgentSaveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AgentSaveRequest copyWith(void Function(AgentSaveRequest) updates) => super.copyWith((message) => updates(message as AgentSaveRequest)) as AgentSaveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgentSaveRequest create() => AgentSaveRequest._();
  AgentSaveRequest createEmptyInstance() => create();
  static $pb.PbList<AgentSaveRequest> createRepeated() => $pb.PbList<AgentSaveRequest>();
  @$core.pragma('dart2js:noInline')
  static AgentSaveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgentSaveRequest>(create);
  static AgentSaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  AgentObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(AgentObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  AgentObject ensureData() => $_ensure(0);
}

class AgentSaveResponse extends $pb.GeneratedMessage {
  factory AgentSaveResponse({
    AgentObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  AgentSaveResponse._() : super();
  factory AgentSaveResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AgentSaveResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AgentSaveResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'field.v1'), createEmptyInstance: create)
    ..aOM<AgentObject>(1, _omitFieldNames ? '' : 'data', subBuilder: AgentObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AgentSaveResponse clone() => AgentSaveResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AgentSaveResponse copyWith(void Function(AgentSaveResponse) updates) => super.copyWith((message) => updates(message as AgentSaveResponse)) as AgentSaveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgentSaveResponse create() => AgentSaveResponse._();
  AgentSaveResponse createEmptyInstance() => create();
  static $pb.PbList<AgentSaveResponse> createRepeated() => $pb.PbList<AgentSaveResponse>();
  @$core.pragma('dart2js:noInline')
  static AgentSaveResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgentSaveResponse>(create);
  static AgentSaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AgentObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(AgentObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  AgentObject ensureData() => $_ensure(0);
}

class AgentGetRequest extends $pb.GeneratedMessage {
  factory AgentGetRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  AgentGetRequest._() : super();
  factory AgentGetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AgentGetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AgentGetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'field.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AgentGetRequest clone() => AgentGetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AgentGetRequest copyWith(void Function(AgentGetRequest) updates) => super.copyWith((message) => updates(message as AgentGetRequest)) as AgentGetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgentGetRequest create() => AgentGetRequest._();
  AgentGetRequest createEmptyInstance() => create();
  static $pb.PbList<AgentGetRequest> createRepeated() => $pb.PbList<AgentGetRequest>();
  @$core.pragma('dart2js:noInline')
  static AgentGetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgentGetRequest>(create);
  static AgentGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class AgentGetResponse extends $pb.GeneratedMessage {
  factory AgentGetResponse({
    AgentObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  AgentGetResponse._() : super();
  factory AgentGetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AgentGetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AgentGetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'field.v1'), createEmptyInstance: create)
    ..aOM<AgentObject>(1, _omitFieldNames ? '' : 'data', subBuilder: AgentObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AgentGetResponse clone() => AgentGetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AgentGetResponse copyWith(void Function(AgentGetResponse) updates) => super.copyWith((message) => updates(message as AgentGetResponse)) as AgentGetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgentGetResponse create() => AgentGetResponse._();
  AgentGetResponse createEmptyInstance() => create();
  static $pb.PbList<AgentGetResponse> createRepeated() => $pb.PbList<AgentGetResponse>();
  @$core.pragma('dart2js:noInline')
  static AgentGetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgentGetResponse>(create);
  static AgentGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AgentObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(AgentObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  AgentObject ensureData() => $_ensure(0);
}

class AgentSearchRequest extends $pb.GeneratedMessage {
  factory AgentSearchRequest({
    $core.String? query,
    $core.String? branchId,
    $core.String? parentAgentId,
    $7.PageCursor? cursor,
  }) {
    final $result = create();
    if (query != null) {
      $result.query = query;
    }
    if (branchId != null) {
      $result.branchId = branchId;
    }
    if (parentAgentId != null) {
      $result.parentAgentId = parentAgentId;
    }
    if (cursor != null) {
      $result.cursor = cursor;
    }
    return $result;
  }
  AgentSearchRequest._() : super();
  factory AgentSearchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AgentSearchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AgentSearchRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'field.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aOS(2, _omitFieldNames ? '' : 'branchId')
    ..aOS(3, _omitFieldNames ? '' : 'parentAgentId')
    ..aOM<$7.PageCursor>(4, _omitFieldNames ? '' : 'cursor', subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AgentSearchRequest clone() => AgentSearchRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AgentSearchRequest copyWith(void Function(AgentSearchRequest) updates) => super.copyWith((message) => updates(message as AgentSearchRequest)) as AgentSearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgentSearchRequest create() => AgentSearchRequest._();
  AgentSearchRequest createEmptyInstance() => create();
  static $pb.PbList<AgentSearchRequest> createRepeated() => $pb.PbList<AgentSearchRequest>();
  @$core.pragma('dart2js:noInline')
  static AgentSearchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgentSearchRequest>(create);
  static AgentSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get branchId => $_getSZ(1);
  @$pb.TagNumber(2)
  set branchId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBranchId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBranchId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get parentAgentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set parentAgentId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasParentAgentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearParentAgentId() => clearField(3);

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

class AgentSearchResponse extends $pb.GeneratedMessage {
  factory AgentSearchResponse({
    $core.Iterable<AgentObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  AgentSearchResponse._() : super();
  factory AgentSearchResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AgentSearchResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AgentSearchResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'field.v1'), createEmptyInstance: create)
    ..pc<AgentObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: AgentObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AgentSearchResponse clone() => AgentSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AgentSearchResponse copyWith(void Function(AgentSearchResponse) updates) => super.copyWith((message) => updates(message as AgentSearchResponse)) as AgentSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgentSearchResponse create() => AgentSearchResponse._();
  AgentSearchResponse createEmptyInstance() => create();
  static $pb.PbList<AgentSearchResponse> createRepeated() => $pb.PbList<AgentSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static AgentSearchResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgentSearchResponse>(create);
  static AgentSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<AgentObject> get data => $_getList(0);
}

/// AgentHierarchyRequest retrieves an agent's descendant tree.
class AgentHierarchyRequest extends $pb.GeneratedMessage {
  factory AgentHierarchyRequest({
    $core.String? agentId,
    $core.int? maxDepth,
  }) {
    final $result = create();
    if (agentId != null) {
      $result.agentId = agentId;
    }
    if (maxDepth != null) {
      $result.maxDepth = maxDepth;
    }
    return $result;
  }
  AgentHierarchyRequest._() : super();
  factory AgentHierarchyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AgentHierarchyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AgentHierarchyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'field.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'agentId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'maxDepth', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AgentHierarchyRequest clone() => AgentHierarchyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AgentHierarchyRequest copyWith(void Function(AgentHierarchyRequest) updates) => super.copyWith((message) => updates(message as AgentHierarchyRequest)) as AgentHierarchyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgentHierarchyRequest create() => AgentHierarchyRequest._();
  AgentHierarchyRequest createEmptyInstance() => create();
  static $pb.PbList<AgentHierarchyRequest> createRepeated() => $pb.PbList<AgentHierarchyRequest>();
  @$core.pragma('dart2js:noInline')
  static AgentHierarchyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgentHierarchyRequest>(create);
  static AgentHierarchyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get agentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set agentId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAgentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAgentId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get maxDepth => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxDepth($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMaxDepth() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxDepth() => clearField(2);
}

class AgentHierarchyResponse extends $pb.GeneratedMessage {
  factory AgentHierarchyResponse({
    $core.Iterable<AgentObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  AgentHierarchyResponse._() : super();
  factory AgentHierarchyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AgentHierarchyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AgentHierarchyResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'field.v1'), createEmptyInstance: create)
    ..pc<AgentObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: AgentObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AgentHierarchyResponse clone() => AgentHierarchyResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AgentHierarchyResponse copyWith(void Function(AgentHierarchyResponse) updates) => super.copyWith((message) => updates(message as AgentHierarchyResponse)) as AgentHierarchyResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgentHierarchyResponse create() => AgentHierarchyResponse._();
  AgentHierarchyResponse createEmptyInstance() => create();
  static $pb.PbList<AgentHierarchyResponse> createRepeated() => $pb.PbList<AgentHierarchyResponse>();
  @$core.pragma('dart2js:noInline')
  static AgentHierarchyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgentHierarchyResponse>(create);
  static AgentHierarchyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<AgentObject> get data => $_getList(0);
}

/// Borrower messages
class BorrowerSaveRequest extends $pb.GeneratedMessage {
  factory BorrowerSaveRequest({
    BorrowerObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  BorrowerSaveRequest._() : super();
  factory BorrowerSaveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BorrowerSaveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BorrowerSaveRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'field.v1'), createEmptyInstance: create)
    ..aOM<BorrowerObject>(1, _omitFieldNames ? '' : 'data', subBuilder: BorrowerObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BorrowerSaveRequest clone() => BorrowerSaveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BorrowerSaveRequest copyWith(void Function(BorrowerSaveRequest) updates) => super.copyWith((message) => updates(message as BorrowerSaveRequest)) as BorrowerSaveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BorrowerSaveRequest create() => BorrowerSaveRequest._();
  BorrowerSaveRequest createEmptyInstance() => create();
  static $pb.PbList<BorrowerSaveRequest> createRepeated() => $pb.PbList<BorrowerSaveRequest>();
  @$core.pragma('dart2js:noInline')
  static BorrowerSaveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BorrowerSaveRequest>(create);
  static BorrowerSaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  BorrowerObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(BorrowerObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  BorrowerObject ensureData() => $_ensure(0);
}

class BorrowerSaveResponse extends $pb.GeneratedMessage {
  factory BorrowerSaveResponse({
    BorrowerObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  BorrowerSaveResponse._() : super();
  factory BorrowerSaveResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BorrowerSaveResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BorrowerSaveResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'field.v1'), createEmptyInstance: create)
    ..aOM<BorrowerObject>(1, _omitFieldNames ? '' : 'data', subBuilder: BorrowerObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BorrowerSaveResponse clone() => BorrowerSaveResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BorrowerSaveResponse copyWith(void Function(BorrowerSaveResponse) updates) => super.copyWith((message) => updates(message as BorrowerSaveResponse)) as BorrowerSaveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BorrowerSaveResponse create() => BorrowerSaveResponse._();
  BorrowerSaveResponse createEmptyInstance() => create();
  static $pb.PbList<BorrowerSaveResponse> createRepeated() => $pb.PbList<BorrowerSaveResponse>();
  @$core.pragma('dart2js:noInline')
  static BorrowerSaveResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BorrowerSaveResponse>(create);
  static BorrowerSaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BorrowerObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(BorrowerObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  BorrowerObject ensureData() => $_ensure(0);
}

class BorrowerGetRequest extends $pb.GeneratedMessage {
  factory BorrowerGetRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  BorrowerGetRequest._() : super();
  factory BorrowerGetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BorrowerGetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BorrowerGetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'field.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BorrowerGetRequest clone() => BorrowerGetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BorrowerGetRequest copyWith(void Function(BorrowerGetRequest) updates) => super.copyWith((message) => updates(message as BorrowerGetRequest)) as BorrowerGetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BorrowerGetRequest create() => BorrowerGetRequest._();
  BorrowerGetRequest createEmptyInstance() => create();
  static $pb.PbList<BorrowerGetRequest> createRepeated() => $pb.PbList<BorrowerGetRequest>();
  @$core.pragma('dart2js:noInline')
  static BorrowerGetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BorrowerGetRequest>(create);
  static BorrowerGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class BorrowerGetResponse extends $pb.GeneratedMessage {
  factory BorrowerGetResponse({
    BorrowerObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  BorrowerGetResponse._() : super();
  factory BorrowerGetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BorrowerGetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BorrowerGetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'field.v1'), createEmptyInstance: create)
    ..aOM<BorrowerObject>(1, _omitFieldNames ? '' : 'data', subBuilder: BorrowerObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BorrowerGetResponse clone() => BorrowerGetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BorrowerGetResponse copyWith(void Function(BorrowerGetResponse) updates) => super.copyWith((message) => updates(message as BorrowerGetResponse)) as BorrowerGetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BorrowerGetResponse create() => BorrowerGetResponse._();
  BorrowerGetResponse createEmptyInstance() => create();
  static $pb.PbList<BorrowerGetResponse> createRepeated() => $pb.PbList<BorrowerGetResponse>();
  @$core.pragma('dart2js:noInline')
  static BorrowerGetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BorrowerGetResponse>(create);
  static BorrowerGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BorrowerObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(BorrowerObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  BorrowerObject ensureData() => $_ensure(0);
}

class BorrowerSearchRequest extends $pb.GeneratedMessage {
  factory BorrowerSearchRequest({
    $core.String? query,
    $core.String? agentId,
    $7.PageCursor? cursor,
  }) {
    final $result = create();
    if (query != null) {
      $result.query = query;
    }
    if (agentId != null) {
      $result.agentId = agentId;
    }
    if (cursor != null) {
      $result.cursor = cursor;
    }
    return $result;
  }
  BorrowerSearchRequest._() : super();
  factory BorrowerSearchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BorrowerSearchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BorrowerSearchRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'field.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aOS(2, _omitFieldNames ? '' : 'agentId')
    ..aOM<$7.PageCursor>(3, _omitFieldNames ? '' : 'cursor', subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BorrowerSearchRequest clone() => BorrowerSearchRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BorrowerSearchRequest copyWith(void Function(BorrowerSearchRequest) updates) => super.copyWith((message) => updates(message as BorrowerSearchRequest)) as BorrowerSearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BorrowerSearchRequest create() => BorrowerSearchRequest._();
  BorrowerSearchRequest createEmptyInstance() => create();
  static $pb.PbList<BorrowerSearchRequest> createRepeated() => $pb.PbList<BorrowerSearchRequest>();
  @$core.pragma('dart2js:noInline')
  static BorrowerSearchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BorrowerSearchRequest>(create);
  static BorrowerSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get agentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set agentId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAgentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAgentId() => clearField(2);

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

class BorrowerSearchResponse extends $pb.GeneratedMessage {
  factory BorrowerSearchResponse({
    $core.Iterable<BorrowerObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  BorrowerSearchResponse._() : super();
  factory BorrowerSearchResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BorrowerSearchResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BorrowerSearchResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'field.v1'), createEmptyInstance: create)
    ..pc<BorrowerObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: BorrowerObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BorrowerSearchResponse clone() => BorrowerSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BorrowerSearchResponse copyWith(void Function(BorrowerSearchResponse) updates) => super.copyWith((message) => updates(message as BorrowerSearchResponse)) as BorrowerSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BorrowerSearchResponse create() => BorrowerSearchResponse._();
  BorrowerSearchResponse createEmptyInstance() => create();
  static $pb.PbList<BorrowerSearchResponse> createRepeated() => $pb.PbList<BorrowerSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static BorrowerSearchResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BorrowerSearchResponse>(create);
  static BorrowerSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<BorrowerObject> get data => $_getList(0);
}

/// BorrowerReassignRequest moves a borrower to a different agent.
class BorrowerReassignRequest extends $pb.GeneratedMessage {
  factory BorrowerReassignRequest({
    $core.String? borrowerId,
    $core.String? newAgentId,
    $core.String? reason,
  }) {
    final $result = create();
    if (borrowerId != null) {
      $result.borrowerId = borrowerId;
    }
    if (newAgentId != null) {
      $result.newAgentId = newAgentId;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    return $result;
  }
  BorrowerReassignRequest._() : super();
  factory BorrowerReassignRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BorrowerReassignRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BorrowerReassignRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'field.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'borrowerId')
    ..aOS(2, _omitFieldNames ? '' : 'newAgentId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BorrowerReassignRequest clone() => BorrowerReassignRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BorrowerReassignRequest copyWith(void Function(BorrowerReassignRequest) updates) => super.copyWith((message) => updates(message as BorrowerReassignRequest)) as BorrowerReassignRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BorrowerReassignRequest create() => BorrowerReassignRequest._();
  BorrowerReassignRequest createEmptyInstance() => create();
  static $pb.PbList<BorrowerReassignRequest> createRepeated() => $pb.PbList<BorrowerReassignRequest>();
  @$core.pragma('dart2js:noInline')
  static BorrowerReassignRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BorrowerReassignRequest>(create);
  static BorrowerReassignRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get borrowerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set borrowerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBorrowerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBorrowerId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get newAgentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set newAgentId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNewAgentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewAgentId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => clearField(3);
}

class BorrowerReassignResponse extends $pb.GeneratedMessage {
  factory BorrowerReassignResponse({
    BorrowerObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  BorrowerReassignResponse._() : super();
  factory BorrowerReassignResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BorrowerReassignResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BorrowerReassignResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'field.v1'), createEmptyInstance: create)
    ..aOM<BorrowerObject>(1, _omitFieldNames ? '' : 'data', subBuilder: BorrowerObject.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BorrowerReassignResponse clone() => BorrowerReassignResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BorrowerReassignResponse copyWith(void Function(BorrowerReassignResponse) updates) => super.copyWith((message) => updates(message as BorrowerReassignResponse)) as BorrowerReassignResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BorrowerReassignResponse create() => BorrowerReassignResponse._();
  BorrowerReassignResponse createEmptyInstance() => create();
  static $pb.PbList<BorrowerReassignResponse> createRepeated() => $pb.PbList<BorrowerReassignResponse>();
  @$core.pragma('dart2js:noInline')
  static BorrowerReassignResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BorrowerReassignResponse>(create);
  static BorrowerReassignResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BorrowerObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(BorrowerObject v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  BorrowerObject ensureData() => $_ensure(0);
}

class FieldServiceApi {
  $pb.RpcClient _client;
  FieldServiceApi(this._client);

  $async.Future<AgentSaveResponse> agentSave($pb.ClientContext? ctx, AgentSaveRequest request) =>
    _client.invoke<AgentSaveResponse>(ctx, 'FieldService', 'AgentSave', request, AgentSaveResponse())
  ;
  $async.Future<AgentGetResponse> agentGet($pb.ClientContext? ctx, AgentGetRequest request) =>
    _client.invoke<AgentGetResponse>(ctx, 'FieldService', 'AgentGet', request, AgentGetResponse())
  ;
  $async.Future<AgentSearchResponse> agentSearch($pb.ClientContext? ctx, AgentSearchRequest request) =>
    _client.invoke<AgentSearchResponse>(ctx, 'FieldService', 'AgentSearch', request, AgentSearchResponse())
  ;
  $async.Future<AgentHierarchyResponse> agentHierarchy($pb.ClientContext? ctx, AgentHierarchyRequest request) =>
    _client.invoke<AgentHierarchyResponse>(ctx, 'FieldService', 'AgentHierarchy', request, AgentHierarchyResponse())
  ;
  $async.Future<BorrowerSaveResponse> borrowerSave($pb.ClientContext? ctx, BorrowerSaveRequest request) =>
    _client.invoke<BorrowerSaveResponse>(ctx, 'FieldService', 'BorrowerSave', request, BorrowerSaveResponse())
  ;
  $async.Future<BorrowerGetResponse> borrowerGet($pb.ClientContext? ctx, BorrowerGetRequest request) =>
    _client.invoke<BorrowerGetResponse>(ctx, 'FieldService', 'BorrowerGet', request, BorrowerGetResponse())
  ;
  $async.Future<BorrowerSearchResponse> borrowerSearch($pb.ClientContext? ctx, BorrowerSearchRequest request) =>
    _client.invoke<BorrowerSearchResponse>(ctx, 'FieldService', 'BorrowerSearch', request, BorrowerSearchResponse())
  ;
  $async.Future<BorrowerReassignResponse> borrowerReassign($pb.ClientContext? ctx, BorrowerReassignRequest request) =>
    _client.invoke<BorrowerReassignResponse>(ctx, 'FieldService', 'BorrowerReassign', request, BorrowerReassignResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
