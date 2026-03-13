//
//  Generated code. Do not modify.
//  source: lender/v1/field.proto
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
  $async.Future<$8.ClientSaveResponse> clientSave($pb.ServerContext ctx, $8.ClientSaveRequest request);
  $async.Future<$8.ClientGetResponse> clientGet($pb.ServerContext ctx, $8.ClientGetRequest request);
  $async.Future<$8.ClientSearchResponse> clientSearch($pb.ServerContext ctx, $8.ClientSearchRequest request);
  $async.Future<$8.ClientReassignResponse> clientReassign($pb.ServerContext ctx, $8.ClientReassignRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'AgentSave': return $8.AgentSaveRequest();
      case 'AgentGet': return $8.AgentGetRequest();
      case 'AgentSearch': return $8.AgentSearchRequest();
      case 'AgentHierarchy': return $8.AgentHierarchyRequest();
      case 'ClientSave': return $8.ClientSaveRequest();
      case 'ClientGet': return $8.ClientGetRequest();
      case 'ClientSearch': return $8.ClientSearchRequest();
      case 'ClientReassign': return $8.ClientReassignRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'AgentSave': return this.agentSave(ctx, request as $8.AgentSaveRequest);
      case 'AgentGet': return this.agentGet(ctx, request as $8.AgentGetRequest);
      case 'AgentSearch': return this.agentSearch(ctx, request as $8.AgentSearchRequest);
      case 'AgentHierarchy': return this.agentHierarchy(ctx, request as $8.AgentHierarchyRequest);
      case 'ClientSave': return this.clientSave(ctx, request as $8.ClientSaveRequest);
      case 'ClientGet': return this.clientGet(ctx, request as $8.ClientGetRequest);
      case 'ClientSearch': return this.clientSearch(ctx, request as $8.ClientSearchRequest);
      case 'ClientReassign': return this.clientReassign(ctx, request as $8.ClientReassignRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => FieldServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => FieldServiceBase$messageJson;
}

