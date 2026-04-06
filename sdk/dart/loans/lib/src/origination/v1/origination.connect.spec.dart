//
//  Generated code. Do not modify.
//  source: origination/v1/origination.proto
//

import "package:connectrpc/connect.dart" as connect;
import "origination.pb.dart" as originationv1origination;

/// OriginationService manages loan products, applications, documents,
/// verification tasks, and underwriting decisions.
/// All RPCs require authentication via Bearer token.
abstract final class OriginationService {
  /// Fully-qualified name of the OriginationService service.
  static const name = 'origination.v1.OriginationService';

  /// LoanProductSave creates or updates a loan product.
  static const loanProductSave = connect.Spec(
    '/$name/LoanProductSave',
    connect.StreamType.unary,
    originationv1origination.LoanProductSaveRequest.new,
    originationv1origination.LoanProductSaveResponse.new,
  );

  /// LoanProductGet retrieves a loan product by its ID.
  static const loanProductGet = connect.Spec(
    '/$name/LoanProductGet',
    connect.StreamType.unary,
    originationv1origination.LoanProductGetRequest.new,
    originationv1origination.LoanProductGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// LoanProductSearch finds loan products matching search criteria.
  static const loanProductSearch = connect.Spec(
    '/$name/LoanProductSearch',
    connect.StreamType.server,
    originationv1origination.LoanProductSearchRequest.new,
    originationv1origination.LoanProductSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// ApplicationSave creates or updates a loan application.
  static const applicationSave = connect.Spec(
    '/$name/ApplicationSave',
    connect.StreamType.unary,
    originationv1origination.ApplicationSaveRequest.new,
    originationv1origination.ApplicationSaveResponse.new,
  );

  /// ApplicationGet retrieves an application by its ID.
  static const applicationGet = connect.Spec(
    '/$name/ApplicationGet',
    connect.StreamType.unary,
    originationv1origination.ApplicationGetRequest.new,
    originationv1origination.ApplicationGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// ApplicationSearch finds applications matching search criteria.
  static const applicationSearch = connect.Spec(
    '/$name/ApplicationSearch',
    connect.StreamType.server,
    originationv1origination.ApplicationSearchRequest.new,
    originationv1origination.ApplicationSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// ApplicationSubmit transitions a draft application to submitted status.
  static const applicationSubmit = connect.Spec(
    '/$name/ApplicationSubmit',
    connect.StreamType.unary,
    originationv1origination.ApplicationSubmitRequest.new,
    originationv1origination.ApplicationSubmitResponse.new,
  );

  /// ApplicationCancel cancels an application.
  static const applicationCancel = connect.Spec(
    '/$name/ApplicationCancel',
    connect.StreamType.unary,
    originationv1origination.ApplicationCancelRequest.new,
    originationv1origination.ApplicationCancelResponse.new,
  );

  /// ApplicationAcceptOffer accepts a generated loan offer.
  static const applicationAcceptOffer = connect.Spec(
    '/$name/ApplicationAcceptOffer',
    connect.StreamType.unary,
    originationv1origination.ApplicationAcceptOfferRequest.new,
    originationv1origination.ApplicationAcceptOfferResponse.new,
  );

  /// ApplicationDeclineOffer declines a generated loan offer.
  static const applicationDeclineOffer = connect.Spec(
    '/$name/ApplicationDeclineOffer',
    connect.StreamType.unary,
    originationv1origination.ApplicationDeclineOfferRequest.new,
    originationv1origination.ApplicationDeclineOfferResponse.new,
  );

  /// ApplicationDocumentSave creates or updates an application document.
  static const applicationDocumentSave = connect.Spec(
    '/$name/ApplicationDocumentSave',
    connect.StreamType.unary,
    originationv1origination.ApplicationDocumentSaveRequest.new,
    originationv1origination.ApplicationDocumentSaveResponse.new,
  );

  /// ApplicationDocumentGet retrieves an application document by its ID.
  static const applicationDocumentGet = connect.Spec(
    '/$name/ApplicationDocumentGet',
    connect.StreamType.unary,
    originationv1origination.ApplicationDocumentGetRequest.new,
    originationv1origination.ApplicationDocumentGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// ApplicationDocumentSearch finds application documents matching criteria.
  static const applicationDocumentSearch = connect.Spec(
    '/$name/ApplicationDocumentSearch',
    connect.StreamType.server,
    originationv1origination.ApplicationDocumentSearchRequest.new,
    originationv1origination.ApplicationDocumentSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// VerificationTaskSave creates or updates a verification task.
  static const verificationTaskSave = connect.Spec(
    '/$name/VerificationTaskSave',
    connect.StreamType.unary,
    originationv1origination.VerificationTaskSaveRequest.new,
    originationv1origination.VerificationTaskSaveResponse.new,
  );

  /// VerificationTaskGet retrieves a verification task by its ID.
  static const verificationTaskGet = connect.Spec(
    '/$name/VerificationTaskGet',
    connect.StreamType.unary,
    originationv1origination.VerificationTaskGetRequest.new,
    originationv1origination.VerificationTaskGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// VerificationTaskSearch finds verification tasks matching criteria.
  static const verificationTaskSearch = connect.Spec(
    '/$name/VerificationTaskSearch',
    connect.StreamType.server,
    originationv1origination.VerificationTaskSearchRequest.new,
    originationv1origination.VerificationTaskSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// VerificationTaskComplete marks a verification task as complete.
  static const verificationTaskComplete = connect.Spec(
    '/$name/VerificationTaskComplete',
    connect.StreamType.unary,
    originationv1origination.VerificationTaskCompleteRequest.new,
    originationv1origination.VerificationTaskCompleteResponse.new,
  );

  /// UnderwritingDecisionSave creates or updates an underwriting decision.
  static const underwritingDecisionSave = connect.Spec(
    '/$name/UnderwritingDecisionSave',
    connect.StreamType.unary,
    originationv1origination.UnderwritingDecisionSaveRequest.new,
    originationv1origination.UnderwritingDecisionSaveResponse.new,
  );

  /// UnderwritingDecisionGet retrieves an underwriting decision by its ID.
  static const underwritingDecisionGet = connect.Spec(
    '/$name/UnderwritingDecisionGet',
    connect.StreamType.unary,
    originationv1origination.UnderwritingDecisionGetRequest.new,
    originationv1origination.UnderwritingDecisionGetResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );

  /// UnderwritingDecisionSearch finds underwriting decisions for an application.
  static const underwritingDecisionSearch = connect.Spec(
    '/$name/UnderwritingDecisionSearch',
    connect.StreamType.server,
    originationv1origination.UnderwritingDecisionSearchRequest.new,
    originationv1origination.UnderwritingDecisionSearchResponse.new,
    idempotency: connect.Idempotency.noSideEffects,
  );
}
