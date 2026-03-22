package authz

import (
	"context"

	"github.com/pitabwire/frame/security"
	"github.com/pitabwire/frame/security/authorizer"
)

type Middleware interface {
	CanSavingsProductManage(ctx context.Context) error
	CanSavingsProductView(ctx context.Context) error
	CanSavingsAccountCreate(ctx context.Context) error
	CanSavingsAccountManage(ctx context.Context) error
	CanSavingsAccountView(ctx context.Context) error
	CanDepositRecord(ctx context.Context) error
	CanDepositView(ctx context.Context) error
	CanWithdrawalRequest(ctx context.Context) error
	CanWithdrawalApprove(ctx context.Context) error
	CanWithdrawalView(ctx context.Context) error
	CanInterestAccrualView(ctx context.Context) error
}

type middleware struct {
	checker *authorizer.FunctionChecker
}

func NewMiddleware(service security.Authorizer) Middleware {
	return &middleware{
		checker: authorizer.NewFunctionChecker(service, NamespaceLenderSavings),
	}
}

func (m *middleware) CanSavingsProductManage(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionSavingsProductManage)
}

func (m *middleware) CanSavingsProductView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionSavingsProductView)
}

func (m *middleware) CanSavingsAccountCreate(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionSavingsAccountCreate)
}

func (m *middleware) CanSavingsAccountManage(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionSavingsAccountManage)
}

func (m *middleware) CanSavingsAccountView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionSavingsAccountView)
}

func (m *middleware) CanDepositRecord(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionDepositRecord)
}

func (m *middleware) CanDepositView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionDepositView)
}

func (m *middleware) CanWithdrawalRequest(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionWithdrawalRequest)
}

func (m *middleware) CanWithdrawalApprove(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionWithdrawalApprove)
}

func (m *middleware) CanWithdrawalView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionWithdrawalView)
}

func (m *middleware) CanInterestAccrualView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionInterestAccrualView)
}
