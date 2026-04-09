//
//  Generated code. Do not modify.
//  source: origination/v1/origination.proto
//

import "package:connectrpc/connect.dart" as connect;
import "origination.pb.dart" as originationv1origination;
import "origination.connect.spec.dart" as specs;

/// OriginationService manages loan products, applications, documents,
/// verification tasks, and underwriting decisions.
/// All RPCs require authentication via Bearer token.
extension type OriginationServiceClient (connect.Transport _transport) {
  /// LoanProductSave creates or updates a loan product.
  Future<originationv1origination.LoanProductSaveResponse> loanProductSave(
    originationv1origination.LoanProductSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.loanProductSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// LoanProductGet retrieves a loan product by its ID.
  Future<originationv1origination.LoanProductGetResponse> loanProductGet(
    originationv1origination.LoanProductGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.loanProductGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// LoanProductSearch finds loan products matching search criteria.
  Stream<originationv1origination.LoanProductSearchResponse> loanProductSearch(
    originationv1origination.LoanProductSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.OriginationService.loanProductSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ApplicationSave creates or updates a loan application.
  Future<originationv1origination.ApplicationSaveResponse> applicationSave(
    originationv1origination.ApplicationSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.applicationSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ApplicationGet retrieves an application by its ID.
  Future<originationv1origination.ApplicationGetResponse> applicationGet(
    originationv1origination.ApplicationGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.applicationGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ApplicationSearch finds applications matching search criteria.
  Stream<originationv1origination.ApplicationSearchResponse> applicationSearch(
    originationv1origination.ApplicationSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.OriginationService.applicationSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ApplicationSubmit transitions a draft application to submitted status.
  Future<originationv1origination.ApplicationSubmitResponse> applicationSubmit(
    originationv1origination.ApplicationSubmitRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.applicationSubmit,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ApplicationCancel cancels an application.
  Future<originationv1origination.ApplicationCancelResponse> applicationCancel(
    originationv1origination.ApplicationCancelRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.applicationCancel,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ApplicationAcceptOffer accepts a generated loan offer.
  Future<originationv1origination.ApplicationAcceptOfferResponse> applicationAcceptOffer(
    originationv1origination.ApplicationAcceptOfferRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.applicationAcceptOffer,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ApplicationDeclineOffer declines a generated loan offer.
  Future<originationv1origination.ApplicationDeclineOfferResponse> applicationDeclineOffer(
    originationv1origination.ApplicationDeclineOfferRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.applicationDeclineOffer,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ApplicationDocumentSave creates or updates an application document.
  Future<originationv1origination.ApplicationDocumentSaveResponse> applicationDocumentSave(
    originationv1origination.ApplicationDocumentSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.applicationDocumentSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ApplicationDocumentGet retrieves an application document by its ID.
  Future<originationv1origination.ApplicationDocumentGetResponse> applicationDocumentGet(
    originationv1origination.ApplicationDocumentGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.applicationDocumentGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ApplicationDocumentSearch finds application documents matching criteria.
  Stream<originationv1origination.ApplicationDocumentSearchResponse> applicationDocumentSearch(
    originationv1origination.ApplicationDocumentSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.OriginationService.applicationDocumentSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// VerificationTaskSave creates or updates a verification task.
  Future<originationv1origination.VerificationTaskSaveResponse> verificationTaskSave(
    originationv1origination.VerificationTaskSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.verificationTaskSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// VerificationTaskGet retrieves a verification task by its ID.
  Future<originationv1origination.VerificationTaskGetResponse> verificationTaskGet(
    originationv1origination.VerificationTaskGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.verificationTaskGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// VerificationTaskSearch finds verification tasks matching criteria.
  Stream<originationv1origination.VerificationTaskSearchResponse> verificationTaskSearch(
    originationv1origination.VerificationTaskSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.OriginationService.verificationTaskSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// VerificationTaskComplete marks a verification task as complete.
  Future<originationv1origination.VerificationTaskCompleteResponse> verificationTaskComplete(
    originationv1origination.VerificationTaskCompleteRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.verificationTaskComplete,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// UnderwritingDecisionSave creates or updates an underwriting decision.
  Future<originationv1origination.UnderwritingDecisionSaveResponse> underwritingDecisionSave(
    originationv1origination.UnderwritingDecisionSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.underwritingDecisionSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// UnderwritingDecisionGet retrieves an underwriting decision by its ID.
  Future<originationv1origination.UnderwritingDecisionGetResponse> underwritingDecisionGet(
    originationv1origination.UnderwritingDecisionGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.underwritingDecisionGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// UnderwritingDecisionSearch finds underwriting decisions for an application.
  Stream<originationv1origination.UnderwritingDecisionSearchResponse> underwritingDecisionSearch(
    originationv1origination.UnderwritingDecisionSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.OriginationService.underwritingDecisionSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// FormTemplateSave creates or updates a form template.
  Future<originationv1origination.FormTemplateSaveResponse> formTemplateSave(
    originationv1origination.FormTemplateSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.formTemplateSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// FormTemplateGet retrieves a form template by its ID.
  Future<originationv1origination.FormTemplateGetResponse> formTemplateGet(
    originationv1origination.FormTemplateGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.formTemplateGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// FormTemplateSearch finds form templates matching search criteria.
  Stream<originationv1origination.FormTemplateSearchResponse> formTemplateSearch(
    originationv1origination.FormTemplateSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.OriginationService.formTemplateSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// FormTemplatePublish publishes a draft form template, incrementing its version.
  Future<originationv1origination.FormTemplatePublishResponse> formTemplatePublish(
    originationv1origination.FormTemplatePublishRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.formTemplatePublish,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// FormSubmissionSave creates or updates a form submission.
  Future<originationv1origination.FormSubmissionSaveResponse> formSubmissionSave(
    originationv1origination.FormSubmissionSaveRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.formSubmissionSave,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// FormSubmissionGet retrieves a form submission by its ID.
  Future<originationv1origination.FormSubmissionGetResponse> formSubmissionGet(
    originationv1origination.FormSubmissionGetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OriginationService.formSubmissionGet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// FormSubmissionSearch finds form submissions matching search criteria.
  Stream<originationv1origination.FormSubmissionSearchResponse> formSubmissionSearch(
    originationv1origination.FormSubmissionSearchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.OriginationService.formSubmissionSearch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
