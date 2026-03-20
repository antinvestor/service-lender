package events

import (
	"context"
	"errors"

	"github.com/pitabwire/util"
	"gorm.io/gorm"

	"github.com/antinvestor/service-lender/apps/operations/service/models"
	"github.com/antinvestor/service-lender/apps/operations/service/repository"
)

const TransferOrderSaveEvent = "transfer_order.save"

type transferOrderSave struct {
	repo repository.TransferOrderRepository
}

// NewTransferOrderSave creates a new transfer order save event handler.
func NewTransferOrderSave(_ context.Context, repo repository.TransferOrderRepository) *transferOrderSave {
	return &transferOrderSave{repo: repo}
}

func (e *transferOrderSave) Name() string {
	return TransferOrderSaveEvent
}

func (e *transferOrderSave) PayloadType() any {
	return &models.TransferOrder{}
}

func (e *transferOrderSave) Validate(_ context.Context, payload any) error {
	to, ok := payload.(*models.TransferOrder)
	if !ok {
		return errors.New("invalid payload type for transfer_order.save")
	}
	if to.DebitAccountRef == "" {
		return errors.New("debit_account_ref is required")
	}
	if to.CreditAccountRef == "" {
		return errors.New("credit_account_ref is required")
	}
	return nil
}

func (e *transferOrderSave) Execute(ctx context.Context, payload any) error {
	to := payload.(*models.TransferOrder)
	log := util.Log(ctx)

	existing, err := e.repo.GetByID(ctx, to.ID)
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		log.WithError(err).Error("transfer_order.save -- failed to check existing record")
		return err
	}

	if existing != nil && existing.GetID() != "" {
		_, err = e.repo.Update(ctx, to)
		if err != nil {
			log.WithError(err).Error("transfer_order.save -- failed to update record")
			return err
		}
		return nil
	}

	err = e.repo.Create(ctx, to)
	if err != nil {
		log.WithError(err).Error("transfer_order.save -- failed to create record")
		return err
	}
	return nil
}
