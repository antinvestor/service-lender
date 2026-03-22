package authz

import (
	"context"

	"github.com/pitabwire/frame/security"
	"github.com/pitabwire/frame/security/authorizer"
)

type Middleware interface {
	CanApplicationCreate(ctx context.Context) error
	CanApplicationManage(ctx context.Context) error
	CanApplicationView(ctx context.Context) error
	CanApplicationSubmit(ctx context.Context) error
	CanApplicationCancel(ctx context.Context) error
	CanApplicationAcceptOffer(ctx context.Context) error
	CanApplicationDeclineOffer(ctx context.Context) error
	CanDocumentManage(ctx context.Context) error
	CanDocumentView(ctx context.Context) error
	CanVerificationTaskManage(ctx context.Context) error
	CanVerificationTaskView(ctx context.Context) error
	CanVerificationTaskComplete(ctx context.Context) error
	CanUnderwritingManage(ctx context.Context) error
	CanUnderwritingView(ctx context.Context) error
}

type middleware struct {
	checker *authorizer.FunctionChecker
}

func NewMiddleware(service security.Authorizer) Middleware {
	return &middleware{
		checker: authorizer.NewFunctionChecker(service, NamespaceLenderOrigination),
	}
}

func (m *middleware) CanApplicationCreate(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionApplicationCreate)
}

func (m *middleware) CanApplicationManage(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionApplicationManage)
}

func (m *middleware) CanApplicationView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionApplicationView)
}

func (m *middleware) CanApplicationSubmit(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionApplicationSubmit)
}

func (m *middleware) CanApplicationCancel(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionApplicationCancel)
}

func (m *middleware) CanApplicationAcceptOffer(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionApplicationAcceptOffer)
}

func (m *middleware) CanApplicationDeclineOffer(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionApplicationDeclineOffer)
}

func (m *middleware) CanDocumentManage(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionDocumentManage)
}

func (m *middleware) CanDocumentView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionDocumentView)
}

func (m *middleware) CanVerificationTaskManage(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionVerificationTaskManage)
}

func (m *middleware) CanVerificationTaskView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionVerificationTaskView)
}

func (m *middleware) CanVerificationTaskComplete(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionVerificationTaskComplete)
}

func (m *middleware) CanUnderwritingManage(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionUnderwritingManage)
}

func (m *middleware) CanUnderwritingView(ctx context.Context) error {
	return m.checker.Check(ctx, PermissionUnderwritingView)
}
