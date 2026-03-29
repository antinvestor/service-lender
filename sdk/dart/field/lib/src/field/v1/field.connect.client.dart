//
//  Generated code. Do not modify.
//  source: field/v1/field.proto
//

import "package:connectrpc/connect.dart" as connect;
import "field.pb.dart" as fieldv1field;
import "field.connect.spec.dart" as specs;

/// FieldService manages agents and borrowers in the lending hierarchy.
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

  /// BorrowerSave onboards or updates a borrower record.
  Future<fieldv1field.BorrowerSaveResponse> borrowerSave(
    fieldv1field.BorrowerSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FieldService.borrowerSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// BorrowerGet retrieves a borrower by their ID.
  Future<fieldv1field.BorrowerGetResponse> borrowerGet(
    fieldv1field.BorrowerGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FieldService.borrowerGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// BorrowerSearch finds borrowers matching search criteria.
  Stream<fieldv1field.BorrowerSearchResponse> borrowerSearch(
    fieldv1field.BorrowerSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.FieldService.borrowerSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// BorrowerReassign moves a borrower from one agent to another.
  Future<fieldv1field.BorrowerReassignResponse> borrowerReassign(
    fieldv1field.BorrowerReassignRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FieldService.borrowerReassign,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
