package authz

import (
	"context"

	"github.com/pitabwire/frame/security"
	"github.com/pitabwire/frame/security/authorizer"
)

type Middleware interface {
	CanBankManage(ctx context.Context) error
	CanBankView(ctx context.Context) error
	CanBranchManage(ctx context.Context) error
	CanBranchView(ctx context.Context) error
	CanAgentCreate(ctx context.Context) error
	CanAgentManage(ctx context.Context) error
	CanAgentView(ctx context.Context) error
	CanClientCreate(ctx context.Context) error
	CanClientManage(ctx context.Context) error
	CanClientView(ctx context.Context) error
	CanClientReassign(ctx context.Context) error
	CanSystemUserManage(ctx context.Context) error
	CanSystemUserView(ctx context.Context) error
}

type middleware struct {
	checker *authorizer.FunctionChecker
}

func NewMiddleware(service security.Authorizer) Middleware {
	return &middleware{
		checker: authorizer.NewFunctionChecker(service, NamespaceLenderIdentity),
	}
}

func (m *middleware) CanBankManage(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionBankManage)
}

func (m *middleware) CanBankView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionBankView)
}

func (m *middleware) CanBranchManage(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionBranchManage)
}

func (m *middleware) CanBranchView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionBranchView)
}

func (m *middleware) CanAgentCreate(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionAgentCreate)
}

func (m *middleware) CanAgentManage(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionAgentManage)
}

func (m *middleware) CanAgentView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionAgentView)
}

func (m *middleware) CanClientCreate(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionClientCreate)
}

func (m *middleware) CanClientManage(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionClientManage)
}

func (m *middleware) CanClientView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionClientView)
}

func (m *middleware) CanClientReassign(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionClientReassign)
}

func (m *middleware) CanSystemUserManage(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionSystemUserManage)
}

func (m *middleware) CanSystemUserView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionSystemUserView)
}
