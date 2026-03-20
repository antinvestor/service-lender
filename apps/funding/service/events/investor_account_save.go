package events

import (
	"context"
	"errors"

	"github.com/pitabwire/util"
	"gorm.io/gorm"

	"github.com/antinvestor/service-lender/apps/funding/service/models"
	"github.com/antinvestor/service-lender/apps/funding/service/repository"
)

const InvestorAccountSaveEvent = "investor_account.save"

type investorAccountSave struct {
	repo repository.InvestorAccountRepository
}

// NewInvestorAccountSave creates a new investor account save event handler.
func NewInvestorAccountSave(_ context.Context, repo repository.InvestorAccountRepository) *investorAccountSave {
	return &investorAccountSave{repo: repo}
}

func (e *investorAccountSave) Name() string {
	return InvestorAccountSaveEvent
}

func (e *investorAccountSave) PayloadType() any {
	return &models.InvestorAccount{}
}

func (e *investorAccountSave) Validate(_ context.Context, payload any) error {
	ia, ok := payload.(*models.InvestorAccount)
	if !ok {
		return errors.New("invalid payload type for investor_account.save")
	}
	if ia.InvestorID == "" {
		return errors.New("investor_id is required")
	}
	if ia.Currency == "" {
		return errors.New("currency is required")
	}
	return nil
}

func (e *investorAccountSave) Execute(ctx context.Context, payload any) error {
	ia := payload.(*models.InvestorAccount)
	log := util.Log(ctx)

	existing, err := e.repo.GetByID(ctx, ia.ID)
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		log.WithError(err).Error("investor_account.save -- failed to check existing record")
		return err
	}

	if existing != nil && existing.GetID() != "" {
		_, err = e.repo.Update(ctx, ia)
		if err != nil {
			log.WithError(err).Error("investor_account.save -- failed to update record")
			return err
		}
		return nil
	}

	err = e.repo.Create(ctx, ia)
	if err != nil {
		log.WithError(err).Error("investor_account.save -- failed to create record")
		return err
	}
	return nil
}
