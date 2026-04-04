package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-lender/apps/operations/service/models"
	"github.com/antinvestor/service-lender/apps/operations/service/repository"
)

const IncomingPaymentSaveEvent = "incoming_payment.save"

// NewIncomingPaymentSave creates a new incoming payment save event handler.
func NewIncomingPaymentSave(_ context.Context, repo repository.IncomingPaymentRepository) events.EventI {
	return &eventHandler[*models.IncomingPayment]{
		name:    IncomingPaymentSaveEvent,
		factory: func() *models.IncomingPayment { return &models.IncomingPayment{} },
		validate: func(_ context.Context, ip *models.IncomingPayment) error {
			if ip.TransactionID == "" {
				return errors.New("transaction_id is required")
			}
			return nil
		},
		repo: repo,
	}
}
