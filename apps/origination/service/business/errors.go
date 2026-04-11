package business

import "github.com/antinvestor/service-fintech/pkg/apperrors"

var (
	ErrApplicationNotFound          = apperrors.NewError(apperrors.NotFound, "application not found")
	ErrApplicationDocumentNotFound  = apperrors.NewError(apperrors.NotFound, "application document not found")
	ErrVerificationTaskNotFound     = apperrors.NewError(apperrors.NotFound, "verification task not found")
	ErrUnderwritingDecisionNotFound = apperrors.NewError(apperrors.NotFound, "underwriting decision not found")
	ErrClientNotFound               = apperrors.NewError(apperrors.NotFound, "client not found in identity service")
	ErrAgentNotFound                = apperrors.NewError(apperrors.NotFound, "agent not found in identity service")
	ErrClientNotActive              = apperrors.NewError(
		apperrors.Unprocessable,
		"client is not active and approved for lending",
	)

	ErrInvalidStatusTransition      = apperrors.NewError(apperrors.Unprocessable, "invalid status transition")
	ErrApplicationNotDraft          = apperrors.NewError(apperrors.Unprocessable, "application is not in draft status")
	ErrApplicationNotOfferGenerated = apperrors.NewError(
		apperrors.Unprocessable,
		"application does not have approved loan terms ready",
	)
	ErrApplicationTerminal = apperrors.NewError(
		apperrors.Unprocessable,
		"application is in a terminal status and cannot be modified",
	)
	ErrLoanCreationFailed = apperrors.NewError(apperrors.BadGateway, "could not create loan account")
	ErrOfferExpired       = apperrors.NewError(apperrors.Unprocessable, "approved loan terms have expired")

	ErrClientHasActiveLoan = apperrors.NewError(
		apperrors.Unprocessable,
		"client has an outstanding loan that must be cleared before applying for a new one",
	)
	ErrClientHasPendingApplication = apperrors.NewError(
		apperrors.Unprocessable,
		"client already has a loan application in progress",
	)
	ErrProductAccessDenied = apperrors.NewError(
		apperrors.Forbidden,
		"client does not have access to this loan product",
	)
	ErrProductNotFound = apperrors.NewError(apperrors.NotFound, "loan product not found")

	ErrAmountExceedsCreditLimit = apperrors.NewError(
		apperrors.Unprocessable,
		"requested loan amount exceeds client's effective credit limit",
	)
	ErrCreditLimitCheckFailed = apperrors.NewError(
		apperrors.BadGateway,
		"could not verify client credit limit",
	)
	ErrEligibilityCheckFailed = apperrors.NewError(
		apperrors.BadGateway,
		"could not complete loan eligibility checks",
	)

	ErrFormTemplateNotFound = apperrors.NewError(apperrors.NotFound, "form template not found")
	ErrFormTemplateNotDraft = apperrors.NewError(
		apperrors.Unprocessable,
		"form template is not in draft status and cannot be published",
	)
	ErrFormSubmissionNotFound = apperrors.NewError(apperrors.NotFound, "form submission not found")
)
