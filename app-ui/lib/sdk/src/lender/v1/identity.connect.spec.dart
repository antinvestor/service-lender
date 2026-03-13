//
//  Generated code. Do not modify.
//  source: lender/v1/identity.proto
//

import "package:connectrpc/connect.dart" as connect;
import "identity.pb.dart" as lenderv1identity;
import "../../common/v1/common.pb.dart" as commonv1common;

/// IdentityService manages banks, branches, and system users for the lending platform.
/// All RPCs require authentication via Bearer token.
abstract final class IdentityService {
  /// Fully-qualified name of the IdentityService service.
  static const name = 'lender.v1.IdentityService';

  /// BankSave creates or updates a bank record.
  static const bankSave = connect.Spec(
    '/$name/BankSave',
    connect.StreamType.unary,
    lenderv1identity.BankSaveRequest.new,
    lenderv1identity.BankSaveResponse.new,
  );

  /// BankGet retrieves a bank by its ID.
  static const bankGet = connect.Spec(
    '/$name/BankGet',
    connect.StreamType.unary,
    lenderv1identity.BankGetRequest.new,
    lenderv1identity.BankGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// BankSearch finds banks matching search criteria.
  static const bankSearch = connect.Spec(
    '/$name/BankSearch',
    connect.StreamType.server,
    commonv1common.SearchRequest.new,
    lenderv1identity.BankSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// BranchSave creates or updates a branch record.
  static const branchSave = connect.Spec(
    '/$name/BranchSave',
    connect.StreamType.unary,
    lenderv1identity.BranchSaveRequest.new,
    lenderv1identity.BranchSaveResponse.new,
  );

  /// BranchGet retrieves a branch by its ID.
  static const branchGet = connect.Spec(
    '/$name/BranchGet',
    connect.StreamType.unary,
    lenderv1identity.BranchGetRequest.new,
    lenderv1identity.BranchGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// BranchSearch finds branches matching search criteria.
  static const branchSearch = connect.Spec(
    '/$name/BranchSearch',
    connect.StreamType.server,
    lenderv1identity.BranchSearchRequest.new,
    lenderv1identity.BranchSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// SystemUserSave creates or updates a system user record.
  static const systemUserSave = connect.Spec(
    '/$name/SystemUserSave',
    connect.StreamType.unary,
    lenderv1identity.SystemUserSaveRequest.new,
    lenderv1identity.SystemUserSaveResponse.new,
  );

  /// SystemUserGet retrieves a system user by their ID.
  static const systemUserGet = connect.Spec(
    '/$name/SystemUserGet',
    connect.StreamType.unary,
    lenderv1identity.SystemUserGetRequest.new,
    lenderv1identity.SystemUserGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// SystemUserSearch finds system users matching search criteria.
  static const systemUserSearch = connect.Spec(
    '/$name/SystemUserSearch',
    connect.StreamType.server,
    lenderv1identity.SystemUserSearchRequest.new,
    lenderv1identity.SystemUserSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );
}
