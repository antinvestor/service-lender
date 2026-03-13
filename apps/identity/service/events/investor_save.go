package events

import (
	"context"
	"errors"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/antinvestor/service-lender/apps/identity/service/repository"
	"github.com/pitabwire/util"
)

const InvestorSaveEvent = "investor.save"

type InvestorSave struct {
	investorRepo repository.InvestorRepository
}

func NewInvestorSave(_ context.Context, investorRepo repository.InvestorRepository) *InvestorSave {
	return &InvestorSave{investorRepo: investorRepo}
}

func (e *InvestorSave) Name() string     { return InvestorSaveEvent }
func (e *InvestorSave) PayloadType() any { return &models.Investor{} }

func (e *InvestorSave) Validate(_ context.Context, payload any) error {
	investor, ok := payload.(*models.Investor)
	if !ok {
		return errors.New("payload is not of type models.Investor")
	}
	if investor.GetID() == "" {
		return errors.New("investor ID should already have been set")
	}
	return nil
}

func (e *InvestorSave) Execute(ctx context.Context, payload any) error {
	investor := payload.(*models.Investor)

	logger := util.Log(ctx).WithField("type", e.Name()).WithField("investor_id", investor.GetID())
	defer logger.Release()
	logger.Debug("event handler started")

	err := e.investorRepo.Create(ctx, investor)
	if err != nil {
		logger.WithError(err).Error("could not save investor to db")
		return err
	}

	logger.Debug("event handler completed successfully")
	return nil
}
