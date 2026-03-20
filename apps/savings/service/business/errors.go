package business

import "github.com/antinvestor/service-lender/pkg/apperrors"

var (
	ErrSavingsProductNotFound  = apperrors.NewError(apperrors.NotFound, "savings product not found")
	ErrSavingsAccountNotFound  = apperrors.NewError(apperrors.NotFound, "savings account not found")
	ErrDepositNotFound         = apperrors.NewError(apperrors.NotFound, "deposit not found")
	ErrWithdrawalNotFound      = apperrors.NewError(apperrors.NotFound, "withdrawal not found")
	ErrInterestAccrualNotFound = apperrors.NewError(apperrors.NotFound, "interest accrual not found")
	ErrAccountFrozen           = apperrors.NewError(apperrors.Unprocessable, "savings account is frozen")
	ErrAccountClosed           = apperrors.NewError(apperrors.Unprocessable, "savings account is closed")
	ErrInsufficientBalance     = apperrors.NewError(apperrors.Unprocessable, "insufficient balance for withdrawal")
	ErrInvalidStatusTransition = apperrors.NewError(apperrors.Unprocessable, "invalid status transition")
	ErrDuplicateIdempotencyKey = apperrors.NewError(apperrors.Conflict, "duplicate idempotency key")
)
