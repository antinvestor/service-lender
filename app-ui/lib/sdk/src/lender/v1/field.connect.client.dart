//
//  Generated code. Do not modify.
//  source: lender/v1/field.proto
//

import "package:connectrpc/connect.dart" as connect;
import "field.pb.dart" as lenderv1field;
import "field.connect.spec.dart" as specs;

/// FieldService manages agents and borrowers in the lending hierarchy.
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

  /// BorrowerSave onboards or updates a borrower record.
  Future<lenderv1field.BorrowerSaveResponse> borrowerSave(
    lenderv1field.BorrowerSaveRequest input, {
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
  Future<lenderv1field.BorrowerGetResponse> borrowerGet(
    lenderv1field.BorrowerGetRequest input, {
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
  Stream<lenderv1field.BorrowerSearchResponse> borrowerSearch(
    lenderv1field.BorrowerSearchRequest input, {
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
  Future<lenderv1field.BorrowerReassignResponse> borrowerReassign(
    lenderv1field.BorrowerReassignRequest input, {
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
