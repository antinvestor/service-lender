//
//  Generated code. Do not modify.
//  source: field/v1/field.proto
//

import "package:connectrpc/connect.dart" as connect;
import "field.pb.dart" as fieldv1field;
import "field.connect.spec.dart" as specs;

/// FieldService manages agents and clients in the lending hierarchy.
/// All RPCs require authentication via Bearer token.
extension type FieldServiceClient (connect.Transport _transport) {
  /// AgentSave creates or updates an agent record.
  Future<fieldv1field.AgentSaveResponse> agentSave(
    fieldv1field.AgentSaveRequest input, {
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
  Future<fieldv1field.AgentGetResponse> agentGet(
    fieldv1field.AgentGetRequest input, {
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
  Stream<fieldv1field.AgentSearchResponse> agentSearch(
    fieldv1field.AgentSearchRequest input, {
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
  Stream<fieldv1field.AgentHierarchyResponse> agentHierarchy(
    fieldv1field.AgentHierarchyRequest input, {
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

  /// AgentBranchSave assigns or updates an agent-branch link.
  Future<fieldv1field.AgentBranchSaveResponse> agentBranchSave(
    fieldv1field.AgentBranchSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FieldService.agentBranchSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// AgentBranchDelete removes an agent-branch link.
  Future<fieldv1field.AgentBranchDeleteResponse> agentBranchDelete(
    fieldv1field.AgentBranchDeleteRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FieldService.agentBranchDelete,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// AgentBranchList lists agent-branch assignments.
  Stream<fieldv1field.AgentBranchListResponse> agentBranchList(
    fieldv1field.AgentBranchListRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.FieldService.agentBranchList,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ClientSave onboards or updates a client record.
  Future<fieldv1field.ClientSaveResponse> clientSave(
    fieldv1field.ClientSaveRequest input, {
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
  Future<fieldv1field.ClientGetResponse> clientGet(
    fieldv1field.ClientGetRequest input, {
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
  Stream<fieldv1field.ClientSearchResponse> clientSearch(
    fieldv1field.ClientSearchRequest input, {
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
  Future<fieldv1field.ClientReassignResponse> clientReassign(
    fieldv1field.ClientReassignRequest input, {
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
