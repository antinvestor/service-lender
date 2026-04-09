//
//  Generated code. Do not modify.
//  source: identity/v1/identity.proto
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
import 'identity.pbenum.dart';

export 'identity.pbenum.dart';

/// OrganizationObject represents a top-level institution mapped to a partition.
/// This is a generic entity that can represent banks, microfinance institutions,
/// SACCOs, fintechs, cooperatives, or any other organization type.
class OrganizationObject extends $pb.GeneratedMessage {
  factory OrganizationObject({
    $core.String? id,
    $core.String? partitionId,
    $core.String? name,
    $core.String? code,
    $core.String? profileId,
    $7.STATE? state,
    OrganizationType? organizationType,
    $6.Struct? properties,
    $core.String? clientId,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (partitionId != null) {
      $result.partitionId = partitionId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (code != null) {
      $result.code = code;
    }
    if (profileId != null) {
      $result.profileId = profileId;
    }
    if (state != null) {
      $result.state = state;
    }
    if (organizationType != null) {
      $result.organizationType = organizationType;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    if (clientId != null) {
      $result.clientId = clientId;
    }
    return $result;
  }
  OrganizationObject._() : super();
  factory OrganizationObject.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory OrganizationObject.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrganizationObject',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'partitionId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'code')
    ..aOS(5, _omitFieldNames ? '' : 'profileId')
    ..e<$7.STATE>(6, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE,
        defaultOrMaker: $7.STATE.CREATED,
        valueOf: $7.STATE.valueOf,
        enumValues: $7.STATE.values)
    ..e<OrganizationType>(
        7, _omitFieldNames ? '' : 'organizationType', $pb.PbFieldType.OE,
        defaultOrMaker: OrganizationType.ORGANIZATION_TYPE_UNSPECIFIED,
        valueOf: OrganizationType.valueOf,
        enumValues: OrganizationType.values)
    ..aOM<$6.Struct>(8, _omitFieldNames ? '' : 'properties',
        subBuilder: $6.Struct.create)
    ..aOS(9, _omitFieldNames ? '' : 'clientId')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  OrganizationObject clone() => OrganizationObject()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  OrganizationObject copyWith(void Function(OrganizationObject) updates) =>
      super.copyWith((message) => updates(message as OrganizationObject))
          as OrganizationObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrganizationObject create() => OrganizationObject._();
  OrganizationObject createEmptyInstance() => create();
  static $pb.PbList<OrganizationObject> createRepeated() =>
      $pb.PbList<OrganizationObject>();
  @$core.pragma('dart2js:noInline')
  static OrganizationObject getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrganizationObject>(create);
  static OrganizationObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get partitionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set partitionId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPartitionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPartitionId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get code => $_getSZ(3);
  @$pb.TagNumber(4)
  set code($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearCode() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get profileId => $_getSZ(4);
  @$pb.TagNumber(5)
  set profileId($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasProfileId() => $_has(4);
  @$pb.TagNumber(5)
  void clearProfileId() => clearField(5);

  @$pb.TagNumber(6)
  $7.STATE get state => $_getN(5);
  @$pb.TagNumber(6)
  set state($7.STATE v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasState() => $_has(5);
  @$pb.TagNumber(6)
  void clearState() => clearField(6);

  @$pb.TagNumber(7)
  OrganizationType get organizationType => $_getN(6);
  @$pb.TagNumber(7)
  set organizationType(OrganizationType v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasOrganizationType() => $_has(6);
  @$pb.TagNumber(7)
  void clearOrganizationType() => clearField(7);

  @$pb.TagNumber(8)
  $6.Struct get properties => $_getN(7);
  @$pb.TagNumber(8)
  set properties($6.Struct v) {
    setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasProperties() => $_has(7);
  @$pb.TagNumber(8)
  void clearProperties() => clearField(8);
  @$pb.TagNumber(8)
  $6.Struct ensureProperties() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get clientId => $_getSZ(8);
  @$pb.TagNumber(9)
  set clientId($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasClientId() => $_has(8);
  @$pb.TagNumber(9)
  void clearClientId() => clearField(9);
}

/// BranchObject represents a branch within an organization, mapped to a child partition with a geographic area.
class BranchObject extends $pb.GeneratedMessage {
  factory BranchObject({
    $core.String? id,
    $core.String? organizationId,
    $core.String? partitionId,
    $core.String? name,
    $core.String? code,
    $core.String? geoId,
    $7.STATE? state,
    $6.Struct? properties,
    $core.String? clientId,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (organizationId != null) {
      $result.organizationId = organizationId;
    }
    if (partitionId != null) {
      $result.partitionId = partitionId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (code != null) {
      $result.code = code;
    }
    if (geoId != null) {
      $result.geoId = geoId;
    }
    if (state != null) {
      $result.state = state;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    if (clientId != null) {
      $result.clientId = clientId;
    }
    return $result;
  }
  BranchObject._() : super();
  factory BranchObject.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BranchObject.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BranchObject',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'organizationId')
    ..aOS(3, _omitFieldNames ? '' : 'partitionId')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOS(5, _omitFieldNames ? '' : 'code')
    ..aOS(6, _omitFieldNames ? '' : 'geoId')
    ..e<$7.STATE>(7, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE,
        defaultOrMaker: $7.STATE.CREATED,
        valueOf: $7.STATE.valueOf,
        enumValues: $7.STATE.values)
    ..aOM<$6.Struct>(8, _omitFieldNames ? '' : 'properties',
        subBuilder: $6.Struct.create)
    ..aOS(9, _omitFieldNames ? '' : 'clientId')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BranchObject clone() => BranchObject()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BranchObject copyWith(void Function(BranchObject) updates) =>
      super.copyWith((message) => updates(message as BranchObject))
          as BranchObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BranchObject create() => BranchObject._();
  BranchObject createEmptyInstance() => create();
  static $pb.PbList<BranchObject> createRepeated() =>
      $pb.PbList<BranchObject>();
  @$core.pragma('dart2js:noInline')
  static BranchObject getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BranchObject>(create);
  static BranchObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get organizationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set organizationId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasOrganizationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrganizationId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get partitionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set partitionId($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPartitionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPartitionId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get code => $_getSZ(4);
  @$pb.TagNumber(5)
  set code($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearCode() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get geoId => $_getSZ(5);
  @$pb.TagNumber(6)
  set geoId($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasGeoId() => $_has(5);
  @$pb.TagNumber(6)
  void clearGeoId() => clearField(6);

  @$pb.TagNumber(7)
  $7.STATE get state => $_getN(6);
  @$pb.TagNumber(7)
  set state($7.STATE v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasState() => $_has(6);
  @$pb.TagNumber(7)
  void clearState() => clearField(7);

  @$pb.TagNumber(8)
  $6.Struct get properties => $_getN(7);
  @$pb.TagNumber(8)
  set properties($6.Struct v) {
    setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasProperties() => $_has(7);
  @$pb.TagNumber(8)
  void clearProperties() => clearField(8);
  @$pb.TagNumber(8)
  $6.Struct ensureProperties() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get clientId => $_getSZ(8);
  @$pb.TagNumber(9)
  set clientId($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasClientId() => $_has(8);
  @$pb.TagNumber(9)
  void clearClientId() => clearField(9);
}

/// InvestorObject represents an independent investor with a profile link.
/// Investors are not assigned to agents — they exist independently.
class InvestorObject extends $pb.GeneratedMessage {
  factory InvestorObject({
    $core.String? id,
    $core.String? profileId,
    $core.String? name,
    $7.STATE? state,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
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
  InvestorObject._() : super();
  factory InvestorObject.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory InvestorObject.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InvestorObject',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'profileId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..e<$7.STATE>(4, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE,
        defaultOrMaker: $7.STATE.CREATED,
        valueOf: $7.STATE.valueOf,
        enumValues: $7.STATE.values)
    ..aOM<$6.Struct>(5, _omitFieldNames ? '' : 'properties',
        subBuilder: $6.Struct.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  InvestorObject clone() => InvestorObject()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  InvestorObject copyWith(void Function(InvestorObject) updates) =>
      super.copyWith((message) => updates(message as InvestorObject))
          as InvestorObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InvestorObject create() => InvestorObject._();
  InvestorObject createEmptyInstance() => create();
  static $pb.PbList<InvestorObject> createRepeated() =>
      $pb.PbList<InvestorObject>();
  @$core.pragma('dart2js:noInline')
  static InvestorObject getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InvestorObject>(create);
  static InvestorObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get profileId => $_getSZ(1);
  @$pb.TagNumber(2)
  set profileId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasProfileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProfileId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $7.STATE get state => $_getN(3);
  @$pb.TagNumber(4)
  set state($7.STATE v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasState() => $_has(3);
  @$pb.TagNumber(4)
  void clearState() => clearField(4);

  @$pb.TagNumber(5)
  $6.Struct get properties => $_getN(4);
  @$pb.TagNumber(5)
  set properties($6.Struct v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasProperties() => $_has(4);
  @$pb.TagNumber(5)
  void clearProperties() => clearField(5);
  @$pb.TagNumber(5)
  $6.Struct ensureProperties() => $_ensure(4);
}

/// SystemUserObject represents a user with a specific role in the lending workflow.
class SystemUserObject extends $pb.GeneratedMessage {
  factory SystemUserObject({
    $core.String? id,
    $core.String? profileId,
    $core.String? branchId,
    SystemUserRole? role,
    $core.String? serviceAccountId,
    $7.STATE? state,
    $6.Struct? properties,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (profileId != null) {
      $result.profileId = profileId;
    }
    if (branchId != null) {
      $result.branchId = branchId;
    }
    if (role != null) {
      $result.role = role;
    }
    if (serviceAccountId != null) {
      $result.serviceAccountId = serviceAccountId;
    }
    if (state != null) {
      $result.state = state;
    }
    if (properties != null) {
      $result.properties = properties;
    }
    return $result;
  }
  SystemUserObject._() : super();
  factory SystemUserObject.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SystemUserObject.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SystemUserObject',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'profileId')
    ..aOS(3, _omitFieldNames ? '' : 'branchId')
    ..e<SystemUserRole>(4, _omitFieldNames ? '' : 'role', $pb.PbFieldType.OE,
        defaultOrMaker: SystemUserRole.SYSTEM_USER_ROLE_UNSPECIFIED,
        valueOf: SystemUserRole.valueOf,
        enumValues: SystemUserRole.values)
    ..aOS(5, _omitFieldNames ? '' : 'serviceAccountId')
    ..e<$7.STATE>(6, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE,
        defaultOrMaker: $7.STATE.CREATED,
        valueOf: $7.STATE.valueOf,
        enumValues: $7.STATE.values)
    ..aOM<$6.Struct>(7, _omitFieldNames ? '' : 'properties',
        subBuilder: $6.Struct.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SystemUserObject clone() => SystemUserObject()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SystemUserObject copyWith(void Function(SystemUserObject) updates) =>
      super.copyWith((message) => updates(message as SystemUserObject))
          as SystemUserObject;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SystemUserObject create() => SystemUserObject._();
  SystemUserObject createEmptyInstance() => create();
  static $pb.PbList<SystemUserObject> createRepeated() =>
      $pb.PbList<SystemUserObject>();
  @$core.pragma('dart2js:noInline')
  static SystemUserObject getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SystemUserObject>(create);
  static SystemUserObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get profileId => $_getSZ(1);
  @$pb.TagNumber(2)
  set profileId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasProfileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProfileId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get branchId => $_getSZ(2);
  @$pb.TagNumber(3)
  set branchId($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasBranchId() => $_has(2);
  @$pb.TagNumber(3)
  void clearBranchId() => clearField(3);

  @$pb.TagNumber(4)
  SystemUserRole get role => $_getN(3);
  @$pb.TagNumber(4)
  set role(SystemUserRole v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasRole() => $_has(3);
  @$pb.TagNumber(4)
  void clearRole() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get serviceAccountId => $_getSZ(4);
  @$pb.TagNumber(5)
  set serviceAccountId($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasServiceAccountId() => $_has(4);
  @$pb.TagNumber(5)
  void clearServiceAccountId() => clearField(5);

  @$pb.TagNumber(6)
  $7.STATE get state => $_getN(5);
  @$pb.TagNumber(6)
  set state($7.STATE v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasState() => $_has(5);
  @$pb.TagNumber(6)
  void clearState() => clearField(6);

  @$pb.TagNumber(7)
  $6.Struct get properties => $_getN(6);
  @$pb.TagNumber(7)
  set properties($6.Struct v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasProperties() => $_has(6);
  @$pb.TagNumber(7)
  void clearProperties() => clearField(7);
  @$pb.TagNumber(7)
  $6.Struct ensureProperties() => $_ensure(6);
}

/// Organization messages
class OrganizationSaveRequest extends $pb.GeneratedMessage {
  factory OrganizationSaveRequest({
    OrganizationObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  OrganizationSaveRequest._() : super();
  factory OrganizationSaveRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory OrganizationSaveRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrganizationSaveRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOM<OrganizationObject>(1, _omitFieldNames ? '' : 'data',
        subBuilder: OrganizationObject.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  OrganizationSaveRequest clone() =>
      OrganizationSaveRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  OrganizationSaveRequest copyWith(
          void Function(OrganizationSaveRequest) updates) =>
      super.copyWith((message) => updates(message as OrganizationSaveRequest))
          as OrganizationSaveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrganizationSaveRequest create() => OrganizationSaveRequest._();
  OrganizationSaveRequest createEmptyInstance() => create();
  static $pb.PbList<OrganizationSaveRequest> createRepeated() =>
      $pb.PbList<OrganizationSaveRequest>();
  @$core.pragma('dart2js:noInline')
  static OrganizationSaveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrganizationSaveRequest>(create);
  static OrganizationSaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  OrganizationObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(OrganizationObject v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  OrganizationObject ensureData() => $_ensure(0);
}

class OrganizationSaveResponse extends $pb.GeneratedMessage {
  factory OrganizationSaveResponse({
    OrganizationObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  OrganizationSaveResponse._() : super();
  factory OrganizationSaveResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory OrganizationSaveResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrganizationSaveResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOM<OrganizationObject>(1, _omitFieldNames ? '' : 'data',
        subBuilder: OrganizationObject.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  OrganizationSaveResponse clone() =>
      OrganizationSaveResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  OrganizationSaveResponse copyWith(
          void Function(OrganizationSaveResponse) updates) =>
      super.copyWith((message) => updates(message as OrganizationSaveResponse))
          as OrganizationSaveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrganizationSaveResponse create() => OrganizationSaveResponse._();
  OrganizationSaveResponse createEmptyInstance() => create();
  static $pb.PbList<OrganizationSaveResponse> createRepeated() =>
      $pb.PbList<OrganizationSaveResponse>();
  @$core.pragma('dart2js:noInline')
  static OrganizationSaveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrganizationSaveResponse>(create);
  static OrganizationSaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  OrganizationObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(OrganizationObject v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  OrganizationObject ensureData() => $_ensure(0);
}

class OrganizationGetRequest extends $pb.GeneratedMessage {
  factory OrganizationGetRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  OrganizationGetRequest._() : super();
  factory OrganizationGetRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory OrganizationGetRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrganizationGetRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  OrganizationGetRequest clone() =>
      OrganizationGetRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  OrganizationGetRequest copyWith(
          void Function(OrganizationGetRequest) updates) =>
      super.copyWith((message) => updates(message as OrganizationGetRequest))
          as OrganizationGetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrganizationGetRequest create() => OrganizationGetRequest._();
  OrganizationGetRequest createEmptyInstance() => create();
  static $pb.PbList<OrganizationGetRequest> createRepeated() =>
      $pb.PbList<OrganizationGetRequest>();
  @$core.pragma('dart2js:noInline')
  static OrganizationGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrganizationGetRequest>(create);
  static OrganizationGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class OrganizationGetResponse extends $pb.GeneratedMessage {
  factory OrganizationGetResponse({
    OrganizationObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  OrganizationGetResponse._() : super();
  factory OrganizationGetResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory OrganizationGetResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrganizationGetResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOM<OrganizationObject>(1, _omitFieldNames ? '' : 'data',
        subBuilder: OrganizationObject.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  OrganizationGetResponse clone() =>
      OrganizationGetResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  OrganizationGetResponse copyWith(
          void Function(OrganizationGetResponse) updates) =>
      super.copyWith((message) => updates(message as OrganizationGetResponse))
          as OrganizationGetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrganizationGetResponse create() => OrganizationGetResponse._();
  OrganizationGetResponse createEmptyInstance() => create();
  static $pb.PbList<OrganizationGetResponse> createRepeated() =>
      $pb.PbList<OrganizationGetResponse>();
  @$core.pragma('dart2js:noInline')
  static OrganizationGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrganizationGetResponse>(create);
  static OrganizationGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  OrganizationObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(OrganizationObject v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  OrganizationObject ensureData() => $_ensure(0);
}

class OrganizationSearchResponse extends $pb.GeneratedMessage {
  factory OrganizationSearchResponse({
    $core.Iterable<OrganizationObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  OrganizationSearchResponse._() : super();
  factory OrganizationSearchResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory OrganizationSearchResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrganizationSearchResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..pc<OrganizationObject>(
        1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM,
        subBuilder: OrganizationObject.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  OrganizationSearchResponse clone() =>
      OrganizationSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  OrganizationSearchResponse copyWith(
          void Function(OrganizationSearchResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OrganizationSearchResponse))
          as OrganizationSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrganizationSearchResponse create() => OrganizationSearchResponse._();
  OrganizationSearchResponse createEmptyInstance() => create();
  static $pb.PbList<OrganizationSearchResponse> createRepeated() =>
      $pb.PbList<OrganizationSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static OrganizationSearchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrganizationSearchResponse>(create);
  static OrganizationSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<OrganizationObject> get data => $_getList(0);
}

/// Branch messages
class BranchSaveRequest extends $pb.GeneratedMessage {
  factory BranchSaveRequest({
    BranchObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  BranchSaveRequest._() : super();
  factory BranchSaveRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BranchSaveRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BranchSaveRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOM<BranchObject>(1, _omitFieldNames ? '' : 'data',
        subBuilder: BranchObject.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BranchSaveRequest clone() => BranchSaveRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BranchSaveRequest copyWith(void Function(BranchSaveRequest) updates) =>
      super.copyWith((message) => updates(message as BranchSaveRequest))
          as BranchSaveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BranchSaveRequest create() => BranchSaveRequest._();
  BranchSaveRequest createEmptyInstance() => create();
  static $pb.PbList<BranchSaveRequest> createRepeated() =>
      $pb.PbList<BranchSaveRequest>();
  @$core.pragma('dart2js:noInline')
  static BranchSaveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BranchSaveRequest>(create);
  static BranchSaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  BranchObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(BranchObject v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  BranchObject ensureData() => $_ensure(0);
}

class BranchSaveResponse extends $pb.GeneratedMessage {
  factory BranchSaveResponse({
    BranchObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  BranchSaveResponse._() : super();
  factory BranchSaveResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BranchSaveResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BranchSaveResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOM<BranchObject>(1, _omitFieldNames ? '' : 'data',
        subBuilder: BranchObject.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BranchSaveResponse clone() => BranchSaveResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BranchSaveResponse copyWith(void Function(BranchSaveResponse) updates) =>
      super.copyWith((message) => updates(message as BranchSaveResponse))
          as BranchSaveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BranchSaveResponse create() => BranchSaveResponse._();
  BranchSaveResponse createEmptyInstance() => create();
  static $pb.PbList<BranchSaveResponse> createRepeated() =>
      $pb.PbList<BranchSaveResponse>();
  @$core.pragma('dart2js:noInline')
  static BranchSaveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BranchSaveResponse>(create);
  static BranchSaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BranchObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(BranchObject v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  BranchObject ensureData() => $_ensure(0);
}

class BranchGetRequest extends $pb.GeneratedMessage {
  factory BranchGetRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  BranchGetRequest._() : super();
  factory BranchGetRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BranchGetRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BranchGetRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BranchGetRequest clone() => BranchGetRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BranchGetRequest copyWith(void Function(BranchGetRequest) updates) =>
      super.copyWith((message) => updates(message as BranchGetRequest))
          as BranchGetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BranchGetRequest create() => BranchGetRequest._();
  BranchGetRequest createEmptyInstance() => create();
  static $pb.PbList<BranchGetRequest> createRepeated() =>
      $pb.PbList<BranchGetRequest>();
  @$core.pragma('dart2js:noInline')
  static BranchGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BranchGetRequest>(create);
  static BranchGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class BranchGetResponse extends $pb.GeneratedMessage {
  factory BranchGetResponse({
    BranchObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  BranchGetResponse._() : super();
  factory BranchGetResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BranchGetResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BranchGetResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOM<BranchObject>(1, _omitFieldNames ? '' : 'data',
        subBuilder: BranchObject.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BranchGetResponse clone() => BranchGetResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BranchGetResponse copyWith(void Function(BranchGetResponse) updates) =>
      super.copyWith((message) => updates(message as BranchGetResponse))
          as BranchGetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BranchGetResponse create() => BranchGetResponse._();
  BranchGetResponse createEmptyInstance() => create();
  static $pb.PbList<BranchGetResponse> createRepeated() =>
      $pb.PbList<BranchGetResponse>();
  @$core.pragma('dart2js:noInline')
  static BranchGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BranchGetResponse>(create);
  static BranchGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BranchObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(BranchObject v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  BranchObject ensureData() => $_ensure(0);
}

class BranchSearchRequest extends $pb.GeneratedMessage {
  factory BranchSearchRequest({
    $core.String? query,
    $core.String? organizationId,
    $7.PageCursor? cursor,
  }) {
    final $result = create();
    if (query != null) {
      $result.query = query;
    }
    if (organizationId != null) {
      $result.organizationId = organizationId;
    }
    if (cursor != null) {
      $result.cursor = cursor;
    }
    return $result;
  }
  BranchSearchRequest._() : super();
  factory BranchSearchRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BranchSearchRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BranchSearchRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aOS(2, _omitFieldNames ? '' : 'organizationId')
    ..aOM<$7.PageCursor>(3, _omitFieldNames ? '' : 'cursor',
        subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BranchSearchRequest clone() => BranchSearchRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BranchSearchRequest copyWith(void Function(BranchSearchRequest) updates) =>
      super.copyWith((message) => updates(message as BranchSearchRequest))
          as BranchSearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BranchSearchRequest create() => BranchSearchRequest._();
  BranchSearchRequest createEmptyInstance() => create();
  static $pb.PbList<BranchSearchRequest> createRepeated() =>
      $pb.PbList<BranchSearchRequest>();
  @$core.pragma('dart2js:noInline')
  static BranchSearchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BranchSearchRequest>(create);
  static BranchSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get organizationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set organizationId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasOrganizationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrganizationId() => clearField(2);

  @$pb.TagNumber(3)
  $7.PageCursor get cursor => $_getN(2);
  @$pb.TagNumber(3)
  set cursor($7.PageCursor v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCursor() => $_has(2);
  @$pb.TagNumber(3)
  void clearCursor() => clearField(3);
  @$pb.TagNumber(3)
  $7.PageCursor ensureCursor() => $_ensure(2);
}

class BranchSearchResponse extends $pb.GeneratedMessage {
  factory BranchSearchResponse({
    $core.Iterable<BranchObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  BranchSearchResponse._() : super();
  factory BranchSearchResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BranchSearchResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BranchSearchResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..pc<BranchObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM,
        subBuilder: BranchObject.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BranchSearchResponse clone() =>
      BranchSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BranchSearchResponse copyWith(void Function(BranchSearchResponse) updates) =>
      super.copyWith((message) => updates(message as BranchSearchResponse))
          as BranchSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BranchSearchResponse create() => BranchSearchResponse._();
  BranchSearchResponse createEmptyInstance() => create();
  static $pb.PbList<BranchSearchResponse> createRepeated() =>
      $pb.PbList<BranchSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static BranchSearchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BranchSearchResponse>(create);
  static BranchSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<BranchObject> get data => $_getList(0);
}

/// Investor messages
class InvestorSaveRequest extends $pb.GeneratedMessage {
  factory InvestorSaveRequest({
    InvestorObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  InvestorSaveRequest._() : super();
  factory InvestorSaveRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory InvestorSaveRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InvestorSaveRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOM<InvestorObject>(1, _omitFieldNames ? '' : 'data',
        subBuilder: InvestorObject.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  InvestorSaveRequest clone() => InvestorSaveRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  InvestorSaveRequest copyWith(void Function(InvestorSaveRequest) updates) =>
      super.copyWith((message) => updates(message as InvestorSaveRequest))
          as InvestorSaveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InvestorSaveRequest create() => InvestorSaveRequest._();
  InvestorSaveRequest createEmptyInstance() => create();
  static $pb.PbList<InvestorSaveRequest> createRepeated() =>
      $pb.PbList<InvestorSaveRequest>();
  @$core.pragma('dart2js:noInline')
  static InvestorSaveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InvestorSaveRequest>(create);
  static InvestorSaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  InvestorObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(InvestorObject v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  InvestorObject ensureData() => $_ensure(0);
}

class InvestorSaveResponse extends $pb.GeneratedMessage {
  factory InvestorSaveResponse({
    InvestorObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  InvestorSaveResponse._() : super();
  factory InvestorSaveResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory InvestorSaveResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InvestorSaveResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOM<InvestorObject>(1, _omitFieldNames ? '' : 'data',
        subBuilder: InvestorObject.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  InvestorSaveResponse clone() =>
      InvestorSaveResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  InvestorSaveResponse copyWith(void Function(InvestorSaveResponse) updates) =>
      super.copyWith((message) => updates(message as InvestorSaveResponse))
          as InvestorSaveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InvestorSaveResponse create() => InvestorSaveResponse._();
  InvestorSaveResponse createEmptyInstance() => create();
  static $pb.PbList<InvestorSaveResponse> createRepeated() =>
      $pb.PbList<InvestorSaveResponse>();
  @$core.pragma('dart2js:noInline')
  static InvestorSaveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InvestorSaveResponse>(create);
  static InvestorSaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  InvestorObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(InvestorObject v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  InvestorObject ensureData() => $_ensure(0);
}

class InvestorGetRequest extends $pb.GeneratedMessage {
  factory InvestorGetRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  InvestorGetRequest._() : super();
  factory InvestorGetRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory InvestorGetRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InvestorGetRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  InvestorGetRequest clone() => InvestorGetRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  InvestorGetRequest copyWith(void Function(InvestorGetRequest) updates) =>
      super.copyWith((message) => updates(message as InvestorGetRequest))
          as InvestorGetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InvestorGetRequest create() => InvestorGetRequest._();
  InvestorGetRequest createEmptyInstance() => create();
  static $pb.PbList<InvestorGetRequest> createRepeated() =>
      $pb.PbList<InvestorGetRequest>();
  @$core.pragma('dart2js:noInline')
  static InvestorGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InvestorGetRequest>(create);
  static InvestorGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class InvestorGetResponse extends $pb.GeneratedMessage {
  factory InvestorGetResponse({
    InvestorObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  InvestorGetResponse._() : super();
  factory InvestorGetResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory InvestorGetResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InvestorGetResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOM<InvestorObject>(1, _omitFieldNames ? '' : 'data',
        subBuilder: InvestorObject.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  InvestorGetResponse clone() => InvestorGetResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  InvestorGetResponse copyWith(void Function(InvestorGetResponse) updates) =>
      super.copyWith((message) => updates(message as InvestorGetResponse))
          as InvestorGetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InvestorGetResponse create() => InvestorGetResponse._();
  InvestorGetResponse createEmptyInstance() => create();
  static $pb.PbList<InvestorGetResponse> createRepeated() =>
      $pb.PbList<InvestorGetResponse>();
  @$core.pragma('dart2js:noInline')
  static InvestorGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InvestorGetResponse>(create);
  static InvestorGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  InvestorObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(InvestorObject v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  InvestorObject ensureData() => $_ensure(0);
}

class InvestorSearchRequest extends $pb.GeneratedMessage {
  factory InvestorSearchRequest({
    $core.String? query,
    $7.PageCursor? cursor,
  }) {
    final $result = create();
    if (query != null) {
      $result.query = query;
    }
    if (cursor != null) {
      $result.cursor = cursor;
    }
    return $result;
  }
  InvestorSearchRequest._() : super();
  factory InvestorSearchRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory InvestorSearchRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InvestorSearchRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aOM<$7.PageCursor>(2, _omitFieldNames ? '' : 'cursor',
        subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  InvestorSearchRequest clone() =>
      InvestorSearchRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  InvestorSearchRequest copyWith(
          void Function(InvestorSearchRequest) updates) =>
      super.copyWith((message) => updates(message as InvestorSearchRequest))
          as InvestorSearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InvestorSearchRequest create() => InvestorSearchRequest._();
  InvestorSearchRequest createEmptyInstance() => create();
  static $pb.PbList<InvestorSearchRequest> createRepeated() =>
      $pb.PbList<InvestorSearchRequest>();
  @$core.pragma('dart2js:noInline')
  static InvestorSearchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InvestorSearchRequest>(create);
  static InvestorSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => clearField(1);

  @$pb.TagNumber(2)
  $7.PageCursor get cursor => $_getN(1);
  @$pb.TagNumber(2)
  set cursor($7.PageCursor v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearCursor() => clearField(2);
  @$pb.TagNumber(2)
  $7.PageCursor ensureCursor() => $_ensure(1);
}

class InvestorSearchResponse extends $pb.GeneratedMessage {
  factory InvestorSearchResponse({
    $core.Iterable<InvestorObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  InvestorSearchResponse._() : super();
  factory InvestorSearchResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory InvestorSearchResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InvestorSearchResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..pc<InvestorObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM,
        subBuilder: InvestorObject.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  InvestorSearchResponse clone() =>
      InvestorSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  InvestorSearchResponse copyWith(
          void Function(InvestorSearchResponse) updates) =>
      super.copyWith((message) => updates(message as InvestorSearchResponse))
          as InvestorSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InvestorSearchResponse create() => InvestorSearchResponse._();
  InvestorSearchResponse createEmptyInstance() => create();
  static $pb.PbList<InvestorSearchResponse> createRepeated() =>
      $pb.PbList<InvestorSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static InvestorSearchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InvestorSearchResponse>(create);
  static InvestorSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<InvestorObject> get data => $_getList(0);
}

/// SystemUser messages
class SystemUserSaveRequest extends $pb.GeneratedMessage {
  factory SystemUserSaveRequest({
    SystemUserObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  SystemUserSaveRequest._() : super();
  factory SystemUserSaveRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SystemUserSaveRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SystemUserSaveRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOM<SystemUserObject>(1, _omitFieldNames ? '' : 'data',
        subBuilder: SystemUserObject.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SystemUserSaveRequest clone() =>
      SystemUserSaveRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SystemUserSaveRequest copyWith(
          void Function(SystemUserSaveRequest) updates) =>
      super.copyWith((message) => updates(message as SystemUserSaveRequest))
          as SystemUserSaveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SystemUserSaveRequest create() => SystemUserSaveRequest._();
  SystemUserSaveRequest createEmptyInstance() => create();
  static $pb.PbList<SystemUserSaveRequest> createRepeated() =>
      $pb.PbList<SystemUserSaveRequest>();
  @$core.pragma('dart2js:noInline')
  static SystemUserSaveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SystemUserSaveRequest>(create);
  static SystemUserSaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  SystemUserObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(SystemUserObject v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  SystemUserObject ensureData() => $_ensure(0);
}

class SystemUserSaveResponse extends $pb.GeneratedMessage {
  factory SystemUserSaveResponse({
    SystemUserObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  SystemUserSaveResponse._() : super();
  factory SystemUserSaveResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SystemUserSaveResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SystemUserSaveResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOM<SystemUserObject>(1, _omitFieldNames ? '' : 'data',
        subBuilder: SystemUserObject.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SystemUserSaveResponse clone() =>
      SystemUserSaveResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SystemUserSaveResponse copyWith(
          void Function(SystemUserSaveResponse) updates) =>
      super.copyWith((message) => updates(message as SystemUserSaveResponse))
          as SystemUserSaveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SystemUserSaveResponse create() => SystemUserSaveResponse._();
  SystemUserSaveResponse createEmptyInstance() => create();
  static $pb.PbList<SystemUserSaveResponse> createRepeated() =>
      $pb.PbList<SystemUserSaveResponse>();
  @$core.pragma('dart2js:noInline')
  static SystemUserSaveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SystemUserSaveResponse>(create);
  static SystemUserSaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SystemUserObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(SystemUserObject v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  SystemUserObject ensureData() => $_ensure(0);
}

class SystemUserGetRequest extends $pb.GeneratedMessage {
  factory SystemUserGetRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  SystemUserGetRequest._() : super();
  factory SystemUserGetRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SystemUserGetRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SystemUserGetRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SystemUserGetRequest clone() =>
      SystemUserGetRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SystemUserGetRequest copyWith(void Function(SystemUserGetRequest) updates) =>
      super.copyWith((message) => updates(message as SystemUserGetRequest))
          as SystemUserGetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SystemUserGetRequest create() => SystemUserGetRequest._();
  SystemUserGetRequest createEmptyInstance() => create();
  static $pb.PbList<SystemUserGetRequest> createRepeated() =>
      $pb.PbList<SystemUserGetRequest>();
  @$core.pragma('dart2js:noInline')
  static SystemUserGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SystemUserGetRequest>(create);
  static SystemUserGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class SystemUserGetResponse extends $pb.GeneratedMessage {
  factory SystemUserGetResponse({
    SystemUserObject? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  SystemUserGetResponse._() : super();
  factory SystemUserGetResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SystemUserGetResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SystemUserGetResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOM<SystemUserObject>(1, _omitFieldNames ? '' : 'data',
        subBuilder: SystemUserObject.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SystemUserGetResponse clone() =>
      SystemUserGetResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SystemUserGetResponse copyWith(
          void Function(SystemUserGetResponse) updates) =>
      super.copyWith((message) => updates(message as SystemUserGetResponse))
          as SystemUserGetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SystemUserGetResponse create() => SystemUserGetResponse._();
  SystemUserGetResponse createEmptyInstance() => create();
  static $pb.PbList<SystemUserGetResponse> createRepeated() =>
      $pb.PbList<SystemUserGetResponse>();
  @$core.pragma('dart2js:noInline')
  static SystemUserGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SystemUserGetResponse>(create);
  static SystemUserGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SystemUserObject get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(SystemUserObject v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  SystemUserObject ensureData() => $_ensure(0);
}

class SystemUserSearchRequest extends $pb.GeneratedMessage {
  factory SystemUserSearchRequest({
    $core.String? query,
    SystemUserRole? role,
    $core.String? branchId,
    $7.PageCursor? cursor,
  }) {
    final $result = create();
    if (query != null) {
      $result.query = query;
    }
    if (role != null) {
      $result.role = role;
    }
    if (branchId != null) {
      $result.branchId = branchId;
    }
    if (cursor != null) {
      $result.cursor = cursor;
    }
    return $result;
  }
  SystemUserSearchRequest._() : super();
  factory SystemUserSearchRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SystemUserSearchRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SystemUserSearchRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..e<SystemUserRole>(2, _omitFieldNames ? '' : 'role', $pb.PbFieldType.OE,
        defaultOrMaker: SystemUserRole.SYSTEM_USER_ROLE_UNSPECIFIED,
        valueOf: SystemUserRole.valueOf,
        enumValues: SystemUserRole.values)
    ..aOS(3, _omitFieldNames ? '' : 'branchId')
    ..aOM<$7.PageCursor>(4, _omitFieldNames ? '' : 'cursor',
        subBuilder: $7.PageCursor.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SystemUserSearchRequest clone() =>
      SystemUserSearchRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SystemUserSearchRequest copyWith(
          void Function(SystemUserSearchRequest) updates) =>
      super.copyWith((message) => updates(message as SystemUserSearchRequest))
          as SystemUserSearchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SystemUserSearchRequest create() => SystemUserSearchRequest._();
  SystemUserSearchRequest createEmptyInstance() => create();
  static $pb.PbList<SystemUserSearchRequest> createRepeated() =>
      $pb.PbList<SystemUserSearchRequest>();
  @$core.pragma('dart2js:noInline')
  static SystemUserSearchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SystemUserSearchRequest>(create);
  static SystemUserSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => clearField(1);

  @$pb.TagNumber(2)
  SystemUserRole get role => $_getN(1);
  @$pb.TagNumber(2)
  set role(SystemUserRole v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get branchId => $_getSZ(2);
  @$pb.TagNumber(3)
  set branchId($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasBranchId() => $_has(2);
  @$pb.TagNumber(3)
  void clearBranchId() => clearField(3);

  @$pb.TagNumber(4)
  $7.PageCursor get cursor => $_getN(3);
  @$pb.TagNumber(4)
  set cursor($7.PageCursor v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasCursor() => $_has(3);
  @$pb.TagNumber(4)
  void clearCursor() => clearField(4);
  @$pb.TagNumber(4)
  $7.PageCursor ensureCursor() => $_ensure(3);
}

class SystemUserSearchResponse extends $pb.GeneratedMessage {
  factory SystemUserSearchResponse({
    $core.Iterable<SystemUserObject>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  SystemUserSearchResponse._() : super();
  factory SystemUserSearchResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SystemUserSearchResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SystemUserSearchResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'identity.v1'),
      createEmptyInstance: create)
    ..pc<SystemUserObject>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM,
        subBuilder: SystemUserObject.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SystemUserSearchResponse clone() =>
      SystemUserSearchResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SystemUserSearchResponse copyWith(
          void Function(SystemUserSearchResponse) updates) =>
      super.copyWith((message) => updates(message as SystemUserSearchResponse))
          as SystemUserSearchResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SystemUserSearchResponse create() => SystemUserSearchResponse._();
  SystemUserSearchResponse createEmptyInstance() => create();
  static $pb.PbList<SystemUserSearchResponse> createRepeated() =>
      $pb.PbList<SystemUserSearchResponse>();
  @$core.pragma('dart2js:noInline')
  static SystemUserSearchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SystemUserSearchResponse>(create);
  static SystemUserSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SystemUserObject> get data => $_getList(0);
}

class IdentityServiceApi {
  $pb.RpcClient _client;
  IdentityServiceApi(this._client);

  $async.Future<OrganizationSaveResponse> organizationSave(
          $pb.ClientContext? ctx, OrganizationSaveRequest request) =>
      _client.invoke<OrganizationSaveResponse>(ctx, 'IdentityService',
          'OrganizationSave', request, OrganizationSaveResponse());
  $async.Future<OrganizationGetResponse> organizationGet(
          $pb.ClientContext? ctx, OrganizationGetRequest request) =>
      _client.invoke<OrganizationGetResponse>(ctx, 'IdentityService',
          'OrganizationGet', request, OrganizationGetResponse());
  $async.Future<OrganizationSearchResponse> organizationSearch(
          $pb.ClientContext? ctx, $7.SearchRequest request) =>
      _client.invoke<OrganizationSearchResponse>(ctx, 'IdentityService',
          'OrganizationSearch', request, OrganizationSearchResponse());
  $async.Future<BranchSaveResponse> branchSave(
          $pb.ClientContext? ctx, BranchSaveRequest request) =>
      _client.invoke<BranchSaveResponse>(
          ctx, 'IdentityService', 'BranchSave', request, BranchSaveResponse());
  $async.Future<BranchGetResponse> branchGet(
          $pb.ClientContext? ctx, BranchGetRequest request) =>
      _client.invoke<BranchGetResponse>(
          ctx, 'IdentityService', 'BranchGet', request, BranchGetResponse());
  $async.Future<BranchSearchResponse> branchSearch(
          $pb.ClientContext? ctx, BranchSearchRequest request) =>
      _client.invoke<BranchSearchResponse>(ctx, 'IdentityService',
          'BranchSearch', request, BranchSearchResponse());
  $async.Future<InvestorSaveResponse> investorSave(
          $pb.ClientContext? ctx, InvestorSaveRequest request) =>
      _client.invoke<InvestorSaveResponse>(ctx, 'IdentityService',
          'InvestorSave', request, InvestorSaveResponse());
  $async.Future<InvestorGetResponse> investorGet(
          $pb.ClientContext? ctx, InvestorGetRequest request) =>
      _client.invoke<InvestorGetResponse>(ctx, 'IdentityService', 'InvestorGet',
          request, InvestorGetResponse());
  $async.Future<InvestorSearchResponse> investorSearch(
          $pb.ClientContext? ctx, InvestorSearchRequest request) =>
      _client.invoke<InvestorSearchResponse>(ctx, 'IdentityService',
          'InvestorSearch', request, InvestorSearchResponse());
  $async.Future<SystemUserSaveResponse> systemUserSave(
          $pb.ClientContext? ctx, SystemUserSaveRequest request) =>
      _client.invoke<SystemUserSaveResponse>(ctx, 'IdentityService',
          'SystemUserSave', request, SystemUserSaveResponse());
  $async.Future<SystemUserGetResponse> systemUserGet(
          $pb.ClientContext? ctx, SystemUserGetRequest request) =>
      _client.invoke<SystemUserGetResponse>(ctx, 'IdentityService',
          'SystemUserGet', request, SystemUserGetResponse());
  $async.Future<SystemUserSearchResponse> systemUserSearch(
          $pb.ClientContext? ctx, SystemUserSearchRequest request) =>
      _client.invoke<SystemUserSearchResponse>(ctx, 'IdentityService',
          'SystemUserSearch', request, SystemUserSearchResponse());
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
