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
	CanBorrowerCreate(ctx context.Context) error
	CanBorrowerManage(ctx context.Context) error
	CanBorrowerView(ctx context.Context) error
	CanBorrowerReassign(ctx context.Context) error
	CanInvestorCreate(ctx context.Context) error
	CanInvestorManage(ctx context.Context) error
	CanInvestorView(ctx context.Context) error
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

func (m *middleware) CanBorrowerCreate(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionBorrowerCreate)
}

func (m *middleware) CanBorrowerManage(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionBorrowerManage)
}

func (m *middleware) CanBorrowerView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionBorrowerView)
}

func (m *middleware) CanBorrowerReassign(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionBorrowerReassign)
}

func (m *middleware) CanInvestorCreate(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionInvestorCreate)
}

func (m *middleware) CanInvestorManage(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionInvestorManage)
}

func (m *middleware) CanInvestorView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionInvestorView)
}

func (m *middleware) CanSystemUserManage(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionSystemUserManage)
}

func (m *middleware) CanSystemUserView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionSystemUserView)
}
