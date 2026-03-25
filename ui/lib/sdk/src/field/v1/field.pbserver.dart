//
//  Generated code. Do not modify.
//  source: field/v1/field.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'field.pb.dart' as $8;
import 'field.pbjson.dart';

export 'field.pb.dart';

abstract class FieldServiceBase extends $pb.GeneratedService {
  $async.Future<$8.AgentSaveResponse> agentSave($pb.ServerContext ctx, $8.AgentSaveRequest request);
  $async.Future<$8.AgentGetResponse> agentGet($pb.ServerContext ctx, $8.AgentGetRequest request);
  $async.Future<$8.AgentSearchResponse> agentSearch($pb.ServerContext ctx, $8.AgentSearchRequest request);
  $async.Future<$8.AgentHierarchyResponse> agentHierarchy($pb.ServerContext ctx, $8.AgentHierarchyRequest request);
  $async.Future<$8.BorrowerSaveResponse> borrowerSave($pb.ServerContext ctx, $8.BorrowerSaveRequest request);
  $async.Future<$8.BorrowerGetResponse> borrowerGet($pb.ServerContext ctx, $8.BorrowerGetRequest request);
  $async.Future<$8.BorrowerSearchResponse> borrowerSearch($pb.ServerContext ctx, $8.BorrowerSearchRequest request);
  $async.Future<$8.BorrowerReassignResponse> borrowerReassign($pb.ServerContext ctx, $8.BorrowerReassignRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'AgentSave': return $8.AgentSaveRequest();
      case 'AgentGet': return $8.AgentGetRequest();
      case 'AgentSearch': return $8.AgentSearchRequest();
      case 'AgentHierarchy': return $8.AgentHierarchyRequest();
      case 'BorrowerSave': return $8.BorrowerSaveRequest();
      case 'BorrowerGet': return $8.BorrowerGetRequest();
      case 'BorrowerSearch': return $8.BorrowerSearchRequest();
      case 'BorrowerReassign': return $8.BorrowerReassignRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'AgentSave': return this.agentSave(ctx, request as $8.AgentSaveRequest);
      case 'AgentGet': return this.agentGet(ctx, request as $8.AgentGetRequest);
      case 'AgentSearch': return this.agentSearch(ctx, request as $8.AgentSearchRequest);
      case 'AgentHierarchy': return this.agentHierarchy(ctx, request as $8.AgentHierarchyRequest);
      case 'BorrowerSave': return this.borrowerSave(ctx, request as $8.BorrowerSaveRequest);
      case 'BorrowerGet': return this.borrowerGet(ctx, request as $8.BorrowerGetRequest);
      case 'BorrowerSearch': return this.borrowerSearch(ctx, request as $8.BorrowerSearchRequest);
      case 'BorrowerReassign': return this.borrowerReassign(ctx, request as $8.BorrowerReassignRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => FieldServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => FieldServiceBase$messageJson;
}

