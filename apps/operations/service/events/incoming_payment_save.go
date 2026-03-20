package events

import (
	"context"
	"errors"

	"github.com/pitabwire/util"
	"gorm.io/gorm"

	"github.com/antinvestor/service-lender/apps/operations/service/models"
	"github.com/antinvestor/service-lender/apps/operations/service/repository"
)

const IncomingPaymentSaveEvent = "incoming_payment.save"

type incomingPaymentSave struct {
	repo repository.IncomingPaymentRepository
}

// NewIncomingPaymentSave creates a new incoming payment save event handler.
func NewIncomingPaymentSave(_ context.Context, repo repository.IncomingPaymentRepository) *incomingPaymentSave {
	return &incomingPaymentSave{repo: repo}
}

func (e *incomingPaymentSave) Name() string {
	return IncomingPaymentSaveEvent
}

func (e *incomingPaymentSave) PayloadType() any {
	return &models.IncomingPayment{}
}

func (e *incomingPaymentSave) Validate(_ context.Context, payload any) error {
	ip, ok := payload.(*models.IncomingPayment)
	if !ok {
		return errors.New("invalid payload type for incoming_payment.save")
	}
	if ip.TransactionID == "" {
		return errors.New("transaction_id is required")
	}
	return nil
}

func (e *incomingPaymentSave) Execute(ctx context.Context, payload any) error {
	ip := payload.(*models.IncomingPayment)
	log := util.Log(ctx)

	existing, err := e.repo.GetByID(ctx, ip.ID)
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		log.WithError(err).Error("incoming_payment.save -- failed to check existing record")
		return err
	}

	if existing != nil && existing.GetID() != "" {
		_, err = e.repo.Update(ctx, ip)
		if err != nil {
			log.WithError(err).Error("incoming_payment.save -- failed to update record")
			return err
		}
		return nil
	}

	err = e.repo.Create(ctx, ip)
	if err != nil {
		log.WithError(err).Error("incoming_payment.save -- failed to create record")
		return err
	}
	return nil
}
