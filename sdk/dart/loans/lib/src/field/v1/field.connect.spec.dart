//
//  Generated code. Do not modify.
//  source: field/v1/field.proto
//

import "package:connectrpc/connect.dart" as connect;
import "field.pb.dart" as fieldv1field;

/// FieldService manages agents and clients in the lending hierarchy.
/// All RPCs require authentication via Bearer token.
abstract final class FieldService {
  /// Fully-qualified name of the FieldService service.
  static const name = 'field.v1.FieldService';

  /// AgentSave creates or updates an agent record.
  static const agentSave = connect.Spec(
    '/$name/AgentSave',
    connect.StreamType.unary,
    fieldv1field.AgentSaveRequest.new,
    fieldv1field.AgentSaveResponse.new,
  );

  /// AgentGet retrieves an agent by their ID.
  static const agentGet = connect.Spec(
    '/$name/AgentGet',
    connect.StreamType.unary,
    fieldv1field.AgentGetRequest.new,
    fieldv1field.AgentGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// AgentSearch finds agents matching search criteria.
  static const agentSearch = connect.Spec(
    '/$name/AgentSearch',
    connect.StreamType.server,
    fieldv1field.AgentSearchRequest.new,
    fieldv1field.AgentSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// AgentHierarchy retrieves the descendant tree of an agent.
  static const agentHierarchy = connect.Spec(
    '/$name/AgentHierarchy',
    connect.StreamType.server,
    fieldv1field.AgentHierarchyRequest.new,
    fieldv1field.AgentHierarchyResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// ClientSave onboards or updates a client record.
  static const clientSave = connect.Spec(
    '/$name/ClientSave',
    connect.StreamType.unary,
    fieldv1field.ClientSaveRequest.new,
    fieldv1field.ClientSaveResponse.new,
  );

  /// ClientGet retrieves a client by their ID.
  static const clientGet = connect.Spec(
    '/$name/ClientGet',
    connect.StreamType.unary,
    fieldv1field.ClientGetRequest.new,
    fieldv1field.ClientGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// ClientSearch finds clients matching search criteria.
  static const clientSearch = connect.Spec(
    '/$name/ClientSearch',
    connect.StreamType.server,
    fieldv1field.ClientSearchRequest.new,
    fieldv1field.ClientSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// ClientReassign moves a client from one agent to another.
  static const clientReassign = connect.Spec(
    '/$name/ClientReassign',
    connect.StreamType.unary,
    fieldv1field.ClientReassignRequest.new,
    fieldv1field.ClientReassignResponse.new,
  );
}
