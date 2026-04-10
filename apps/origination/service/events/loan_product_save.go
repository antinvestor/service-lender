package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/origination/service/models"
	"github.com/antinvestor/service-fintech/apps/origination/service/repository"
)

const LoanProductSaveEvent = "loan_product.save"

type LoanProductSave struct {
	repo repository.LoanProductRepository
}

func NewLoanProductSave(_ context.Context, repo repository.LoanProductRepository) *LoanProductSave {
	return &LoanProductSave{repo: repo}
}

func (e *LoanProductSave) Name() string     { return LoanProductSaveEvent }
func (e *LoanProductSave) PayloadType() any { return &models.LoanProduct{} }

func (e *LoanProductSave) Validate(_ context.Context, payload any) error {
	lp, ok := payload.(*models.LoanProduct)
	if !ok {
		return errors.New("payload is not of type models.LoanProduct")
	}
	if lp.GetID() == "" {
		return errors.New("loan product ID should already have been set")
	}
	return nil
}

func (e *LoanProductSave) Execute(ctx context.Context, payload any) error {
	lp, ok := payload.(*models.LoanProduct)
	if !ok {
		return errors.New("payload is not of type models.LoanProduct")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "loan_product_id": lp.GetID()})
	defer logger.Release()

	existing, getErr := e.repo.GetByID(ctx, lp.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.repo.Update(ctx, lp); err != nil {
			logger.WithError(err).Error("could not update loan product in db")
			return err
		}
		return nil
	}

	if err := e.repo.Create(ctx, lp); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create loan product in db")
		return err
	}

	return nil
}
