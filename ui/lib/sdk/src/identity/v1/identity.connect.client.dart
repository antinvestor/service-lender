//
//  Generated code. Do not modify.
//  source: identity/v1/identity.proto
//

import "package:connectrpc/connect.dart" as connect;
import "identity.pb.dart" as identityv1identity;
import "identity.connect.spec.dart" as specs;
import "../../common/v1/common.pb.dart" as commonv1common;

/// IdentityService manages organizations, branches, and system users for the platform.
/// All RPCs require authentication via Bearer token.
extension type IdentityServiceClient(connect.Transport _transport) {
  /// OrganizationSave creates or updates an organization record.
  Future<identityv1identity.OrganizationSaveResponse> organizationSave(
    identityv1identity.OrganizationSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.IdentityService.organizationSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// OrganizationGet retrieves an organization by its ID.
  Future<identityv1identity.OrganizationGetResponse> organizationGet(
    identityv1identity.OrganizationGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.IdentityService.organizationGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// OrganizationSearch finds organizations matching search criteria.
  Stream<identityv1identity.OrganizationSearchResponse> organizationSearch(
    commonv1common.SearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.IdentityService.organizationSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// BranchSave creates or updates a branch record.
  Future<identityv1identity.BranchSaveResponse> branchSave(
    identityv1identity.BranchSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.IdentityService.branchSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// BranchGet retrieves a branch by its ID.
  Future<identityv1identity.BranchGetResponse> branchGet(
    identityv1identity.BranchGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.IdentityService.branchGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// BranchSearch finds branches matching search criteria.
  Stream<identityv1identity.BranchSearchResponse> branchSearch(
    identityv1identity.BranchSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.IdentityService.branchSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// InvestorSave creates or updates an investor record.
  Future<identityv1identity.InvestorSaveResponse> investorSave(
    identityv1identity.InvestorSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.IdentityService.investorSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// InvestorGet retrieves an investor by their ID.
  Future<identityv1identity.InvestorGetResponse> investorGet(
    identityv1identity.InvestorGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.IdentityService.investorGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// InvestorSearch finds investors matching search criteria.
  Stream<identityv1identity.InvestorSearchResponse> investorSearch(
    identityv1identity.InvestorSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.IdentityService.investorSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// SystemUserSave creates or updates a system user record.
  Future<identityv1identity.SystemUserSaveResponse> systemUserSave(
    identityv1identity.SystemUserSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.IdentityService.systemUserSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// SystemUserGet retrieves a system user by their ID.
  Future<identityv1identity.SystemUserGetResponse> systemUserGet(
    identityv1identity.SystemUserGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.IdentityService.systemUserGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// SystemUserSearch finds system users matching search criteria.
  Stream<identityv1identity.SystemUserSearchResponse> systemUserSearch(
    identityv1identity.SystemUserSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.IdentityService.systemUserSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
