//
//  Generated code. Do not modify.
//  source: lender/v1/field.proto
//

import "package:connectrpc/connect.dart" as connect;
import "field.pb.dart" as lenderv1field;

/// FieldService manages agents and clients in the lending hierarchy.
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

  /// ClientSave onboards or updates a client record.
  static const clientSave = connect.Spec(
    '/$name/ClientSave',
    connect.StreamType.unary,
    lenderv1field.ClientSaveRequest.new,
    lenderv1field.ClientSaveResponse.new,
  );

  /// ClientGet retrieves a client by their ID.
  static const clientGet = connect.Spec(
    '/$name/ClientGet',
    connect.StreamType.unary,
    lenderv1field.ClientGetRequest.new,
    lenderv1field.ClientGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// ClientSearch finds clients matching search criteria.
  static const clientSearch = connect.Spec(
    '/$name/ClientSearch',
    connect.StreamType.server,
    lenderv1field.ClientSearchRequest.new,
    lenderv1field.ClientSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// ClientReassign moves a client from one agent to another.
  static const clientReassign = connect.Spec(
    '/$name/ClientReassign',
    connect.StreamType.unary,
    lenderv1field.ClientReassignRequest.new,
    lenderv1field.ClientReassignResponse.new,
  );
}
