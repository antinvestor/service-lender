//
//  Generated code. Do not modify.
//  source: lender/v1/field.proto
//

import "package:connectrpc/connect.dart" as connect;
import "field.pb.dart" as lenderv1field;

/// FieldService manages agents and borrowers in the lending hierarchy.
/// All RPCs require authentication via Bearer token.
abstract final class FieldService {
  /// Fully-qualified name of the FieldService service.
  static const name = 'lender.v1.FieldService';

  /// AgentSave creates or updates an agent record.
  static const agentSave = connect.Spec(
    '/$name/AgentSave',
    connect.StreamType.unary,
    lenderv1field.AgentSaveRequest.new,
    lenderv1field.AgentSaveResponse.new,
  );

  /// AgentGet retrieves an agent by their ID.
  static const agentGet = connect.Spec(
    '/$name/AgentGet',
    connect.StreamType.unary,
    lenderv1field.AgentGetRequest.new,
    lenderv1field.AgentGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// AgentSearch finds agents matching search criteria.
  static const agentSearch = connect.Spec(
    '/$name/AgentSearch',
    connect.StreamType.server,
    lenderv1field.AgentSearchRequest.new,
    lenderv1field.AgentSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// AgentHierarchy retrieves the descendant tree of an agent.
  static const agentHierarchy = connect.Spec(
    '/$name/AgentHierarchy',
    connect.StreamType.server,
    lenderv1field.AgentHierarchyRequest.new,
    lenderv1field.AgentHierarchyResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// BorrowerSave onboards or updates a borrower record.
  static const borrowerSave = connect.Spec(
    '/$name/BorrowerSave',
    connect.StreamType.unary,
    lenderv1field.BorrowerSaveRequest.new,
    lenderv1field.BorrowerSaveResponse.new,
  );

  /// BorrowerGet retrieves a borrower by their ID.
  static const borrowerGet = connect.Spec(
    '/$name/BorrowerGet',
    connect.StreamType.unary,
    lenderv1field.BorrowerGetRequest.new,
    lenderv1field.BorrowerGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// BorrowerSearch finds borrowers matching search criteria.
  static const borrowerSearch = connect.Spec(
    '/$name/BorrowerSearch',
    connect.StreamType.server,
    lenderv1field.BorrowerSearchRequest.new,
    lenderv1field.BorrowerSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// BorrowerReassign moves a borrower from one agent to another.
  static const borrowerReassign = connect.Spec(
    '/$name/BorrowerReassign',
    connect.StreamType.unary,
    lenderv1field.BorrowerReassignRequest.new,
    lenderv1field.BorrowerReassignResponse.new,
  );
}
