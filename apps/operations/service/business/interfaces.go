package business

import (
	"context"

	"github.com/antinvestor/service-fintech/apps/operations/service/models"
)

// PaymentRoutingBusiness handles payment identification and allocation.
type PaymentRoutingBusiness interface {
	IdentifyPayment(ctx context.Context, paymentData map[string]interface{}) (map[string]interface{}, error)
	AllocatePayment(ctx context.Context, paymentID string) (map[string]interface{}, error)
}

// TransferOrderBusiness handles transfer order creation and execution.
type TransferOrderBusiness interface {
	Save(ctx context.Context, order *models.TransferOrder) error
	Execute(ctx context.Context, orderID string) error
}

// ObligationBusiness handles financial obligation management.
type ObligationBusiness interface {
	CalculateForGroup(ctx context.Context, groupID string) error
	CreateLoanObligations(ctx context.Context, loanAccountID string, entries []ScheduleEntryInfo) error
	GetStatus(ctx context.Context, obligationID string) (map[string]interface{}, error)
}
