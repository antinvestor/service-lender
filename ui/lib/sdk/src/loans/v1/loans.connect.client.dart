//
//  Generated code. Do not modify.
//  source: loans/v1/loans.proto
//

import "package:connectrpc/connect.dart" as connect;
import "loans.pb.dart" as loansv1loans;
import "loans.connect.spec.dart" as specs;

/// LoanManagementService manages active loans, disbursements, repayments,
/// schedules, penalties, restructures, and reconciliation.
/// All RPCs require authentication via Bearer token.
extension type LoanManagementServiceClient(connect.Transport _transport) {
  /// LoanAccountCreate creates a new loan account from an approved application.
  Future<loansv1loans.LoanAccountCreateResponse> loanAccountCreate(
    loansv1loans.LoanAccountCreateRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.loanAccountCreate,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// LoanAccountGet retrieves a loan account by its ID.
  Future<loansv1loans.LoanAccountGetResponse> loanAccountGet(
    loansv1loans.LoanAccountGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.loanAccountGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// LoanAccountSearch finds loan accounts matching search criteria.
  Stream<loansv1loans.LoanAccountSearchResponse> loanAccountSearch(
    loansv1loans.LoanAccountSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.LoanManagementService.loanAccountSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// LoanBalanceGet retrieves the current balance of a loan.
  Future<loansv1loans.LoanBalanceGetResponse> loanBalanceGet(
    loansv1loans.LoanBalanceGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.loanBalanceGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// LoanStatement generates a loan statement for a date range.
  Future<loansv1loans.LoanStatementResponse> loanStatement(
    loansv1loans.LoanStatementRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.loanStatement,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// DisbursementCreate initiates a loan disbursement.
  Future<loansv1loans.DisbursementCreateResponse> disbursementCreate(
    loansv1loans.DisbursementCreateRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.disbursementCreate,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// DisbursementGet retrieves a disbursement by its ID.
  Future<loansv1loans.DisbursementGetResponse> disbursementGet(
    loansv1loans.DisbursementGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.disbursementGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// DisbursementSearch finds disbursements for a loan.
  Stream<loansv1loans.DisbursementSearchResponse> disbursementSearch(
    loansv1loans.DisbursementSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.LoanManagementService.disbursementSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// RepaymentRecord records an incoming payment for a loan.
  Future<loansv1loans.RepaymentRecordResponse> repaymentRecord(
    loansv1loans.RepaymentRecordRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.repaymentRecord,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// RepaymentGet retrieves a repayment by its ID.
  Future<loansv1loans.RepaymentGetResponse> repaymentGet(
    loansv1loans.RepaymentGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.repaymentGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// RepaymentSearch finds repayments for a loan.
  Stream<loansv1loans.RepaymentSearchResponse> repaymentSearch(
    loansv1loans.RepaymentSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.LoanManagementService.repaymentSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// RepaymentScheduleGet retrieves the active repayment schedule for a loan.
  Future<loansv1loans.RepaymentScheduleGetResponse> repaymentScheduleGet(
    loansv1loans.RepaymentScheduleGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.repaymentScheduleGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// PenaltySave creates or updates a penalty on a loan.
  Future<loansv1loans.PenaltySaveResponse> penaltySave(
    loansv1loans.PenaltySaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.penaltySave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// PenaltyWaive waives a penalty on a loan.
  Future<loansv1loans.PenaltyWaiveResponse> penaltyWaive(
    loansv1loans.PenaltyWaiveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.penaltyWaive,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// PenaltySearch finds penalties for a loan.
  Stream<loansv1loans.PenaltySearchResponse> penaltySearch(
    loansv1loans.PenaltySearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.LoanManagementService.penaltySearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// LoanRestructureCreate requests a loan restructure.
  Future<loansv1loans.LoanRestructureCreateResponse> loanRestructureCreate(
    loansv1loans.LoanRestructureCreateRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.loanRestructureCreate,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// LoanRestructureApprove approves a loan restructure.
  Future<loansv1loans.LoanRestructureApproveResponse> loanRestructureApprove(
    loansv1loans.LoanRestructureApproveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.loanRestructureApprove,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// LoanRestructureReject rejects a loan restructure.
  Future<loansv1loans.LoanRestructureRejectResponse> loanRestructureReject(
    loansv1loans.LoanRestructureRejectRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.loanRestructureReject,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// LoanRestructureSearch finds restructures for a loan.
  Stream<loansv1loans.LoanRestructureSearchResponse> loanRestructureSearch(
    loansv1loans.LoanRestructureSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.LoanManagementService.loanRestructureSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ReconciliationSave creates or updates a reconciliation record.
  Future<loansv1loans.ReconciliationSaveResponse> reconciliationSave(
    loansv1loans.ReconciliationSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.reconciliationSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ReconciliationSearch finds reconciliation records.
  Stream<loansv1loans.ReconciliationSearchResponse> reconciliationSearch(
    loansv1loans.ReconciliationSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.LoanManagementService.reconciliationSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// InitiateCollection sends a payment collection prompt to the client.
  Future<loansv1loans.InitiateCollectionResponse> initiateCollection(
    loansv1loans.InitiateCollectionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.initiateCollection,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// LoanStatusChangeSearch retrieves status change audit trail for a loan.
  Stream<loansv1loans.LoanStatusChangeSearchResponse> loanStatusChangeSearch(
    loansv1loans.LoanStatusChangeSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.LoanManagementService.loanStatusChangeSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// LoanRequest is the client-facing API for direct client loan requests.
  /// Clients call this from app/USSD. The system validates eligibility,
  /// runs automated risk checks, and routes to the responsible agent.
  Future<loansv1loans.LoanRequestResponse> loanRequest(
    loansv1loans.LoanRequestRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.loanRequest,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// PortfolioSummary returns aggregated financial metrics across a filtered
  /// set of loans. Supports filtering by organization, branch, agent, product, and client.
  Future<loansv1loans.PortfolioSummaryResponse> portfolioSummary(
    loansv1loans.PortfolioSummaryRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.portfolioSummary,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// PortfolioExport exports the loan book as CSV for a filtered set of loans.
  Future<loansv1loans.PortfolioExportResponse> portfolioExport(
    loansv1loans.PortfolioExportRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LoanManagementService.portfolioExport,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
