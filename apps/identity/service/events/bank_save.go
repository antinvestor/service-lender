package events

import (
	"context"
	"errors"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/antinvestor/service-lender/apps/identity/service/repository"
	"github.com/pitabwire/util"
)

const BankSaveEvent = "bank.save"

type BankSave struct {
	bankRepo repository.BankRepository
}

func NewBankSave(_ context.Context, bankRepo repository.BankRepository) *BankSave {
	return &BankSave{bankRepo: bankRepo}
}

func (e *BankSave) Name() string         { return BankSaveEvent }
func (e *BankSave) PayloadType() any     { return &models.Bank{} }

func (e *BankSave) Validate(_ context.Context, payload any) error {
	bank, ok := payload.(*models.Bank)
	if !ok {
		return errors.New("payload is not of type models.Bank")
	}
	if bank.GetID() == "" {
		return errors.New("bank ID should already have been set")
	}
	return nil
}

func (e *BankSave) Execute(ctx context.Context, payload any) error {
	bank := payload.(*models.Bank)

	logger := util.Log(ctx).WithField("type", e.Name()).WithField("bank_id", bank.GetID())
	defer logger.Release()
	logger.Debug("event handler started")

	err := e.bankRepo.Create(ctx, bank)
	if err != nil {
		logger.WithError(err).Error("could not save bank to db")
		return err
	}

	logger.Debug("event handler completed successfully")
	return nil
}
