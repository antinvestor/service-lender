//
//  Generated code. Do not modify.
//  source: identity/v1/identity.proto
//

import "package:connectrpc/connect.dart" as connect;
import "identity.pb.dart" as identityv1identity;
import "../../common/v1/common.pb.dart" as commonv1common;

/// IdentityService manages organizations, branches, and system users for the platform.
/// All RPCs require authentication via Bearer token.
abstract final class IdentityService {
  /// Fully-qualified name of the IdentityService service.
  static const name = 'identity.v1.IdentityService';

  /// OrganizationSave creates or updates an organization record.
  static const organizationSave = connect.Spec(
    '/$name/OrganizationSave',
    connect.StreamType.unary,
    identityv1identity.OrganizationSaveRequest.new,
    identityv1identity.OrganizationSaveResponse.new,
  );

  /// OrganizationGet retrieves an organization by its ID.
  static const organizationGet = connect.Spec(
    '/$name/OrganizationGet',
    connect.StreamType.unary,
    identityv1identity.OrganizationGetRequest.new,
    identityv1identity.OrganizationGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// OrganizationSearch finds organizations matching search criteria.
  static const organizationSearch = connect.Spec(
    '/$name/OrganizationSearch',
    connect.StreamType.server,
    commonv1common.SearchRequest.new,
    identityv1identity.OrganizationSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// BranchSave creates or updates a branch record.
  static const branchSave = connect.Spec(
    '/$name/BranchSave',
    connect.StreamType.unary,
    identityv1identity.BranchSaveRequest.new,
    identityv1identity.BranchSaveResponse.new,
  );

  /// BranchGet retrieves a branch by its ID.
  static const branchGet = connect.Spec(
    '/$name/BranchGet',
    connect.StreamType.unary,
    identityv1identity.BranchGetRequest.new,
    identityv1identity.BranchGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// BranchSearch finds branches matching search criteria.
  static const branchSearch = connect.Spec(
    '/$name/BranchSearch',
    connect.StreamType.server,
    identityv1identity.BranchSearchRequest.new,
    identityv1identity.BranchSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// InvestorSave creates or updates an investor record.
  static const investorSave = connect.Spec(
    '/$name/InvestorSave',
    connect.StreamType.unary,
    identityv1identity.InvestorSaveRequest.new,
    identityv1identity.InvestorSaveResponse.new,
  );

  /// InvestorGet retrieves an investor by their ID.
  static const investorGet = connect.Spec(
    '/$name/InvestorGet',
    connect.StreamType.unary,
    identityv1identity.InvestorGetRequest.new,
    identityv1identity.InvestorGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// InvestorSearch finds investors matching search criteria.
  static const investorSearch = connect.Spec(
    '/$name/InvestorSearch',
    connect.StreamType.server,
    identityv1identity.InvestorSearchRequest.new,
    identityv1identity.InvestorSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// SystemUserSave creates or updates a system user record.
  static const systemUserSave = connect.Spec(
    '/$name/SystemUserSave',
    connect.StreamType.unary,
    identityv1identity.SystemUserSaveRequest.new,
    identityv1identity.SystemUserSaveResponse.new,
  );

  /// SystemUserGet retrieves a system user by their ID.
  static const systemUserGet = connect.Spec(
    '/$name/SystemUserGet',
    connect.StreamType.unary,
    identityv1identity.SystemUserGetRequest.new,
    identityv1identity.SystemUserGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// SystemUserSearch finds system users matching search criteria.
  static const systemUserSearch = connect.Spec(
    '/$name/SystemUserSearch',
    connect.StreamType.server,
    identityv1identity.SystemUserSearchRequest.new,
    identityv1identity.SystemUserSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );
}
