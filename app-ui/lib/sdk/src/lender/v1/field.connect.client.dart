//
//  Generated code. Do not modify.
//  source: lender/v1/field.proto
//

import "package:connectrpc/connect.dart" as connect;
import "field.pb.dart" as lenderv1field;
import "field.connect.spec.dart" as specs;

/// FieldService manages agents and clients in the lending hierarchy.
/// All RPCs require authentication via Bearer token.
extension type FieldServiceClient (connect.Transport _transport) {
  /// AgentSave creates or updates an agent record.
  Future<lenderv1field.AgentSaveResponse> agentSave(
    lenderv1field.AgentSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FieldService.agentSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// AgentGet retrieves an agent by their ID.
  Future<lenderv1field.AgentGetResponse> agentGet(
    lenderv1field.AgentGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FieldService.agentGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// AgentSearch finds agents matching search criteria.
  Stream<lenderv1field.AgentSearchResponse> agentSearch(
    lenderv1field.AgentSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.FieldService.agentSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// AgentHierarchy retrieves the descendant tree of an agent.
  Stream<lenderv1field.AgentHierarchyResponse> agentHierarchy(
    lenderv1field.AgentHierarchyRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.FieldService.agentHierarchy,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ClientSave onboards or updates a client record.
  Future<lenderv1field.ClientSaveResponse> clientSave(
    lenderv1field.ClientSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FieldService.clientSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ClientGet retrieves a client by their ID.
  Future<lenderv1field.ClientGetResponse> clientGet(
    lenderv1field.ClientGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FieldService.clientGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ClientSearch finds clients matching search criteria.
  Stream<lenderv1field.ClientSearchResponse> clientSearch(
    lenderv1field.ClientSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.FieldService.clientSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ClientReassign moves a client from one agent to another.
  Future<lenderv1field.ClientReassignResponse> clientReassign(
    lenderv1field.ClientReassignRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FieldService.clientReassign,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
