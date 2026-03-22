package authz

import (
	"context"

	"github.com/pitabwire/frame/security"
	"github.com/pitabwire/frame/security/authorizer"
)

type Middleware interface {
	CanLoanProductManage(ctx context.Context) error
	CanLoanProductView(ctx context.Context) error
	CanLoanView(ctx context.Context) error
	CanLoanViewOwn(ctx context.Context) error
	CanLoanManage(ctx context.Context) error
	CanRepaymentRecord(ctx context.Context) error
	CanRepaymentView(ctx context.Context) error
	CanPenaltyManage(ctx context.Context) error
	CanPenaltyWaive(ctx context.Context) error
	CanPenaltyView(ctx context.Context) error
	CanRestructureCreate(ctx context.Context) error
	CanRestructureApprove(ctx context.Context) error
	CanRestructureView(ctx context.Context) error
	CanReconciliationManage(ctx context.Context) error
	CanReconciliationView(ctx context.Context) error
	CanCollectionInitiate(ctx context.Context) error
	CanStatementView(ctx context.Context) error
	CanWriteOff(ctx context.Context) error
}

type middleware struct {
	checker *authorizer.FunctionChecker
}

func NewMiddleware(service security.Authorizer) Middleware {
	return &middleware{
		checker: authorizer.NewFunctionChecker(service, NamespaceLoanManagement),
	}
}

func (m *middleware) CanLoanView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionLoanView)
}

func (m *middleware) CanLoanViewOwn(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionLoanViewOwn)
}

func (m *middleware) CanLoanProductManage(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionLoanProductManage)
}

func (m *middleware) CanLoanProductView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionLoanProductView)
}

func (m *middleware) CanLoanManage(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionLoanManage)
}

func (m *middleware) CanRepaymentRecord(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionRepaymentRecord)
}

func (m *middleware) CanRepaymentView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionRepaymentView)
}

func (m *middleware) CanPenaltyManage(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionPenaltyManage)
}

func (m *middleware) CanPenaltyWaive(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionPenaltyWaive)
}

func (m *middleware) CanPenaltyView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionPenaltyView)
}

func (m *middleware) CanRestructureCreate(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionRestructureCreate)
}

func (m *middleware) CanRestructureApprove(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionRestructureApprove)
}

func (m *middleware) CanRestructureView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionRestructureView)
}

func (m *middleware) CanReconciliationManage(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionReconciliationManage)
}

func (m *middleware) CanReconciliationView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionReconciliationView)
}

func (m *middleware) CanCollectionInitiate(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionCollectionInitiate)
}

func (m *middleware) CanStatementView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionStatementView)
}

func (m *middleware) CanWriteOff(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionWriteOff)
}
