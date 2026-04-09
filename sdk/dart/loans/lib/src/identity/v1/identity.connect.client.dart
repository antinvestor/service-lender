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
extension type IdentityServiceClient (connect.Transport _transport) {
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

  /// ClientGroupSave creates or updates a client group record.
  Future<identityv1identity.ClientGroupSaveResponse> clientGroupSave(
    identityv1identity.ClientGroupSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.IdentityService.clientGroupSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ClientGroupGet retrieves a client group by its ID.
  Future<identityv1identity.ClientGroupGetResponse> clientGroupGet(
    identityv1identity.ClientGroupGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.IdentityService.clientGroupGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ClientGroupSearch finds client groups matching search criteria.
  Stream<identityv1identity.ClientGroupSearchResponse> clientGroupSearch(
    identityv1identity.ClientGroupSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.IdentityService.clientGroupSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// MembershipSave creates or updates a membership record.
  Future<identityv1identity.MembershipSaveResponse> membershipSave(
    identityv1identity.MembershipSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.IdentityService.membershipSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// MembershipGet retrieves a membership by its ID.
  Future<identityv1identity.MembershipGetResponse> membershipGet(
    identityv1identity.MembershipGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.IdentityService.membershipGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// MembershipSearch finds memberships matching search criteria.
  Stream<identityv1identity.MembershipSearchResponse> membershipSearch(
    identityv1identity.MembershipSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.IdentityService.membershipSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// InvestorAccountSave creates or updates an investor capital account.
  Future<identityv1identity.InvestorAccountSaveResponse> investorAccountSave(
    identityv1identity.InvestorAccountSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.IdentityService.investorAccountSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// InvestorAccountGet retrieves an investor account by its ID.
  Future<identityv1identity.InvestorAccountGetResponse> investorAccountGet(
    identityv1identity.InvestorAccountGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.IdentityService.investorAccountGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// InvestorAccountSearch finds investor accounts matching search criteria.
  Stream<identityv1identity.InvestorAccountSearchResponse> investorAccountSearch(
    identityv1identity.InvestorAccountSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.IdentityService.investorAccountSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// InvestorDeposit adds funds to an investor capital account.
  Future<identityv1identity.InvestorDepositResponse> investorDeposit(
    identityv1identity.InvestorDepositRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.IdentityService.investorDeposit,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// InvestorWithdraw removes funds from an investor capital account.
  Future<identityv1identity.InvestorWithdrawResponse> investorWithdraw(
    identityv1identity.InvestorWithdrawRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.IdentityService.investorWithdraw,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
