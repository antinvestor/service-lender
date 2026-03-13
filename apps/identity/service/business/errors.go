package business

import "github.com/antinvestor/service-ant-lender/pkg/apperrors"

var (
	ErrBankNotFound       = apperrors.NewError(apperrors.NotFound, "bank not found")
	ErrBranchNotFound     = apperrors.NewError(apperrors.NotFound, "branch not found")
	ErrAgentNotFound      = apperrors.NewError(apperrors.NotFound, "agent not found")
	ErrClientNotFound     = apperrors.NewError(apperrors.NotFound, "client not found")
	ErrSystemUserNotFound = apperrors.NewError(apperrors.NotFound, "system user not found")

	ErrAgentDepthExceeded = apperrors.NewError(apperrors.Unprocessable, "agent hierarchy depth limit exceeded")
	ErrAgentInactive      = apperrors.NewError(apperrors.Unprocessable, "agent is not active")
	ErrClientAlreadyExists = apperrors.NewError(apperrors.Conflict, "client with this profile already exists")
	ErrReassignSameAgent  = apperrors.NewError(apperrors.BadRequest, "client is already assigned to this agent")
	ErrReassignCrossBank  = apperrors.NewError(apperrors.BadRequest, "cannot reassign client to agent in different bank")
)
