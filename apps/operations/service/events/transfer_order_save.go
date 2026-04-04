package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-lender/apps/operations/service/models"
	"github.com/antinvestor/service-lender/apps/operations/service/repository"
)

const TransferOrderSaveEvent = "transfer_order.save"

// NewTransferOrderSave creates a new transfer order save event handler.
func NewTransferOrderSave(_ context.Context, repo repository.TransferOrderRepository) events.EventI {
	return &eventHandler[*models.TransferOrder]{
		name:    TransferOrderSaveEvent,
		factory: func() *models.TransferOrder { return &models.TransferOrder{} },
		validate: func(_ context.Context, to *models.TransferOrder) error {
			if to.DebitAccountRef == "" {
				return errors.New("debit_account_ref is required")
			}
			if to.CreditAccountRef == "" {
				return errors.New("credit_account_ref is required")
			}
			return nil
		},
		repo: repo,
	}
}
