package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/antinvestor/service-lender/apps/identity/service/repository"
)

const BankSaveEvent = "bank.save"

type BankSave struct {
	bankRepo repository.BankRepository
}

func NewBankSave(_ context.Context, bankRepo repository.BankRepository) *BankSave {
	return &BankSave{bankRepo: bankRepo}
}

func (e *BankSave) Name() string     { return BankSaveEvent }
func (e *BankSave) PayloadType() any { return &models.Bank{} }

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
	bank, ok := payload.(*models.Bank)
	if !ok {
		return errors.New("payload is not of type models.Bank")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "bank_id": bank.GetID()})
	defer logger.Release()

	existing, getErr := e.bankRepo.GetByID(ctx, bank.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.bankRepo.Update(ctx, bank); err != nil {
			logger.WithError(err).Error("could not update bank in db")
			return err
		}
		return nil
	}

	if err := e.bankRepo.Create(ctx, bank); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create bank in db")
		return err
	}

	return nil
}
