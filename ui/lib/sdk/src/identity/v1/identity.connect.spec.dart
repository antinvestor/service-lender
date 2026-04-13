//
//  Generated code. Do not modify.
//  source: identity/v1/identity.proto
//

import "package:connectrpc/connect.dart" as connect;
import "identity.pb.dart" as identityv1identity;
import "../../common/v1/common.pb.dart" as commonv1common;

/// IdentityService manages organizations, org units, and system users for the platform.
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

  /// OrgUnitSave creates or updates a hierarchical org unit record.
  static const orgUnitSave = connect.Spec(
    '/$name/OrgUnitSave',
    connect.StreamType.unary,
    identityv1identity.OrgUnitSaveRequest.new,
    identityv1identity.OrgUnitSaveResponse.new,
  );

  /// OrgUnitGet retrieves an org unit by its ID.
  static const orgUnitGet = connect.Spec(
    '/$name/OrgUnitGet',
    connect.StreamType.unary,
    identityv1identity.OrgUnitGetRequest.new,
    identityv1identity.OrgUnitGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// OrgUnitSearch finds org units matching search criteria.
  static const orgUnitSearch = connect.Spec(
    '/$name/OrgUnitSearch',
    connect.StreamType.server,
    identityv1identity.OrgUnitSearchRequest.new,
    identityv1identity.OrgUnitSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// BranchSave creates or updates a legacy leaf branch record.
  /// Prefer OrgUnitSave with type BRANCH for new integrations.
  static const branchSave = connect.Spec(
    '/$name/BranchSave',
    connect.StreamType.unary,
    identityv1identity.BranchSaveRequest.new,
    identityv1identity.BranchSaveResponse.new,
  );

  /// BranchGet retrieves a legacy leaf branch by its ID.
  static const branchGet = connect.Spec(
    '/$name/BranchGet',
    connect.StreamType.unary,
    identityv1identity.BranchGetRequest.new,
    identityv1identity.BranchGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// BranchSearch finds legacy leaf branches matching search criteria.
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

  /// ClientGroupSave creates or updates a client group record.
  static const clientGroupSave = connect.Spec(
    '/$name/ClientGroupSave',
    connect.StreamType.unary,
    identityv1identity.ClientGroupSaveRequest.new,
    identityv1identity.ClientGroupSaveResponse.new,
  );

  /// ClientGroupGet retrieves a client group by its ID.
  static const clientGroupGet = connect.Spec(
    '/$name/ClientGroupGet',
    connect.StreamType.unary,
    identityv1identity.ClientGroupGetRequest.new,
    identityv1identity.ClientGroupGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// ClientGroupSearch finds client groups matching search criteria.
  static const clientGroupSearch = connect.Spec(
    '/$name/ClientGroupSearch',
    connect.StreamType.server,
    identityv1identity.ClientGroupSearchRequest.new,
    identityv1identity.ClientGroupSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// MembershipSave creates or updates a membership record.
  static const membershipSave = connect.Spec(
    '/$name/MembershipSave',
    connect.StreamType.unary,
    identityv1identity.MembershipSaveRequest.new,
    identityv1identity.MembershipSaveResponse.new,
  );

  /// MembershipGet retrieves a membership by its ID.
  static const membershipGet = connect.Spec(
    '/$name/MembershipGet',
    connect.StreamType.unary,
    identityv1identity.MembershipGetRequest.new,
    identityv1identity.MembershipGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// MembershipSearch finds memberships matching search criteria.
  static const membershipSearch = connect.Spec(
    '/$name/MembershipSearch',
    connect.StreamType.server,
    identityv1identity.MembershipSearchRequest.new,
    identityv1identity.MembershipSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// InvestorAccountSave creates or updates an investor capital account.
  static const investorAccountSave = connect.Spec(
    '/$name/InvestorAccountSave',
    connect.StreamType.unary,
    identityv1identity.InvestorAccountSaveRequest.new,
    identityv1identity.InvestorAccountSaveResponse.new,
  );

  /// InvestorAccountGet retrieves an investor account by its ID.
  static const investorAccountGet = connect.Spec(
    '/$name/InvestorAccountGet',
    connect.StreamType.unary,
    identityv1identity.InvestorAccountGetRequest.new,
    identityv1identity.InvestorAccountGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// InvestorAccountSearch finds investor accounts matching search criteria.
  static const investorAccountSearch = connect.Spec(
    '/$name/InvestorAccountSearch',
    connect.StreamType.server,
    identityv1identity.InvestorAccountSearchRequest.new,
    identityv1identity.InvestorAccountSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// InvestorDeposit adds funds to an investor capital account.
  static const investorDeposit = connect.Spec(
    '/$name/InvestorDeposit',
    connect.StreamType.unary,
    identityv1identity.InvestorDepositRequest.new,
    identityv1identity.InvestorDepositResponse.new,
  );

  /// InvestorWithdraw removes funds from an investor capital account.
  static const investorWithdraw = connect.Spec(
    '/$name/InvestorWithdraw',
    connect.StreamType.unary,
    identityv1identity.InvestorWithdrawRequest.new,
    identityv1identity.InvestorWithdrawResponse.new,
  );

  /// ClientDataSave creates or updates a client data entry.
  static const clientDataSave = connect.Spec(
    '/$name/ClientDataSave',
    connect.StreamType.unary,
    identityv1identity.ClientDataSaveRequest.new,
    identityv1identity.ClientDataSaveResponse.new,
  );

  /// ClientDataGet retrieves a single data entry by client_id and field_key.
  static const clientDataGet = connect.Spec(
    '/$name/ClientDataGet',
    connect.StreamType.unary,
    identityv1identity.ClientDataGetRequest.new,
    identityv1identity.ClientDataGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// ClientDataList lists all data entries for a client with optional status filter.
  static const clientDataList = connect.Spec(
    '/$name/ClientDataList',
    connect.StreamType.server,
    identityv1identity.ClientDataListRequest.new,
    identityv1identity.ClientDataListResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// ClientDataVerify marks a data entry as verified.
  static const clientDataVerify = connect.Spec(
    '/$name/ClientDataVerify',
    connect.StreamType.unary,
    identityv1identity.ClientDataVerifyRequest.new,
    identityv1identity.ClientDataVerifyResponse.new,
  );

  /// ClientDataReject marks a data entry as rejected.
  static const clientDataReject = connect.Spec(
    '/$name/ClientDataReject',
    connect.StreamType.unary,
    identityv1identity.ClientDataRejectRequest.new,
    identityv1identity.ClientDataRejectResponse.new,
  );

  /// ClientDataRequestInfo requests more information for a data entry.
  static const clientDataRequestInfo = connect.Spec(
    '/$name/ClientDataRequestInfo',
    connect.StreamType.unary,
    identityv1identity.ClientDataRequestInfoRequest.new,
    identityv1identity.ClientDataRequestInfoResponse.new,
  );

  /// ClientDataHistory retrieves the revision history for a data entry.
  static const clientDataHistory = connect.Spec(
    '/$name/ClientDataHistory',
    connect.StreamType.unary,
    identityv1identity.ClientDataHistoryRequest.new,
    identityv1identity.ClientDataHistoryResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );
}
