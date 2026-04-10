package business

import "github.com/antinvestor/service-fintech/pkg/apperrors"

var (
	ErrLoanProductNotFound    = apperrors.NewError(apperrors.NotFound, "loan product not found")
	ErrLoanAccountNotFound    = apperrors.NewError(apperrors.NotFound, "loan account not found")
	ErrRepaymentNotFound      = apperrors.NewError(apperrors.NotFound, "repayment not found")
	ErrPenaltyNotFound        = apperrors.NewError(apperrors.NotFound, "penalty not found")
	ErrRestructureNotFound    = apperrors.NewError(apperrors.NotFound, "loan restructure not found")
	ErrScheduleNotFound       = apperrors.NewError(apperrors.NotFound, "repayment schedule not found")
	ErrBalanceNotFound        = apperrors.NewError(apperrors.NotFound, "loan balance not found")
	ErrReconciliationNotFound = apperrors.NewError(apperrors.NotFound, "reconciliation not found")

	ErrInvalidStatusTransition    = apperrors.NewError(apperrors.Unprocessable, "invalid loan status transition")
	ErrLoanNotActive              = apperrors.NewError(apperrors.Unprocessable, "loan is not in active status")
	ErrLoanNotPendingDisbursement = apperrors.NewError(apperrors.Unprocessable, "loan is not pending disbursement")
	ErrRestructureNotPending      = apperrors.NewError(apperrors.Unprocessable, "restructure is not in pending state")
	ErrPenaltyAlreadyWaived       = apperrors.NewError(apperrors.Unprocessable, "penalty is already waived")

	ErrDisbursementNotFound          = apperrors.NewError(apperrors.NotFound, "disbursement not found")
	ErrDuplicateIdempotencyKey       = apperrors.NewError(apperrors.Conflict, "duplicate idempotency key")
	ErrApplicationNotFound           = apperrors.NewError(apperrors.NotFound, "origination application not found")
	ErrOriginationServiceUnavailable = apperrors.NewError(
		apperrors.ServiceUnavailable,
		"origination service is not available",
	)
)
