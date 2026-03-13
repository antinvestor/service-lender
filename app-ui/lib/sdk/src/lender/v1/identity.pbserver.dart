//
//  Generated code. Do not modify.
//  source: lender/v1/identity.proto
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

import '../../common/v1/common.pb.dart' as $7;
import 'identity.pb.dart' as $9;
import 'identity.pbjson.dart';

export 'identity.pb.dart';

abstract class IdentityServiceBase extends $pb.GeneratedService {
  $async.Future<$9.BankSaveResponse> bankSave($pb.ServerContext ctx, $9.BankSaveRequest request);
  $async.Future<$9.BankGetResponse> bankGet($pb.ServerContext ctx, $9.BankGetRequest request);
  $async.Future<$9.BankSearchResponse> bankSearch($pb.ServerContext ctx, $7.SearchRequest request);
  $async.Future<$9.BranchSaveResponse> branchSave($pb.ServerContext ctx, $9.BranchSaveRequest request);
  $async.Future<$9.BranchGetResponse> branchGet($pb.ServerContext ctx, $9.BranchGetRequest request);
  $async.Future<$9.BranchSearchResponse> branchSearch($pb.ServerContext ctx, $9.BranchSearchRequest request);
  $async.Future<$9.SystemUserSaveResponse> systemUserSave($pb.ServerContext ctx, $9.SystemUserSaveRequest request);
  $async.Future<$9.SystemUserGetResponse> systemUserGet($pb.ServerContext ctx, $9.SystemUserGetRequest request);
  $async.Future<$9.SystemUserSearchResponse> systemUserSearch($pb.ServerContext ctx, $9.SystemUserSearchRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'BankSave': return $9.BankSaveRequest();
      case 'BankGet': return $9.BankGetRequest();
      case 'BankSearch': return $7.SearchRequest();
      case 'BranchSave': return $9.BranchSaveRequest();
      case 'BranchGet': return $9.BranchGetRequest();
      case 'BranchSearch': return $9.BranchSearchRequest();
      case 'SystemUserSave': return $9.SystemUserSaveRequest();
      case 'SystemUserGet': return $9.SystemUserGetRequest();
      case 'SystemUserSearch': return $9.SystemUserSearchRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'BankSave': return this.bankSave(ctx, request as $9.BankSaveRequest);
      case 'BankGet': return this.bankGet(ctx, request as $9.BankGetRequest);
      case 'BankSearch': return this.bankSearch(ctx, request as $7.SearchRequest);
      case 'BranchSave': return this.branchSave(ctx, request as $9.BranchSaveRequest);
      case 'BranchGet': return this.branchGet(ctx, request as $9.BranchGetRequest);
      case 'BranchSearch': return this.branchSearch(ctx, request as $9.BranchSearchRequest);
      case 'SystemUserSave': return this.systemUserSave(ctx, request as $9.SystemUserSaveRequest);
      case 'SystemUserGet': return this.systemUserGet(ctx, request as $9.SystemUserGetRequest);
      case 'SystemUserSearch': return this.systemUserSearch(ctx, request as $9.SystemUserSearchRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => IdentityServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => IdentityServiceBase$messageJson;
}

