package business

import "github.com/antinvestor/service-lender/pkg/apperrors"

var (
	ErrBankNotFound       = apperrors.NewError(apperrors.NotFound, "bank not found")
	ErrBranchNotFound     = apperrors.NewError(apperrors.NotFound, "branch not found")
	ErrAgentNotFound      = apperrors.NewError(apperrors.NotFound, "agent not found")
	ErrBorrowerNotFound   = apperrors.NewError(apperrors.NotFound, "borrower not found")
	ErrInvestorNotFound   = apperrors.NewError(apperrors.NotFound, "investor not found")
	ErrSystemUserNotFound = apperrors.NewError(apperrors.NotFound, "system user not found")

	ErrAgentDepthExceeded    = apperrors.NewError(apperrors.Unprocessable, "agent hierarchy depth limit exceeded")
	ErrAgentInactive         = apperrors.NewError(apperrors.Unprocessable, "agent is not active")
	ErrBorrowerAlreadyExists = apperrors.NewError(apperrors.Conflict, "borrower with this profile already exists")
	ErrReassignSameAgent     = apperrors.NewError(apperrors.BadRequest, "borrower is already assigned to this agent")
	ErrReassignCrossBank     = apperrors.NewError(apperrors.BadRequest, "cannot reassign borrower to agent in different bank")
)
