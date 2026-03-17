package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/antinvestor/service-lender/apps/identity/service/repository"
)

const BorrowerSaveEvent = "borrower.save"

type BorrowerSave struct {
	borrowerRepo repository.BorrowerRepository
}

func NewBorrowerSave(_ context.Context, borrowerRepo repository.BorrowerRepository) *BorrowerSave {
	return &BorrowerSave{borrowerRepo: borrowerRepo}
}

func (e *BorrowerSave) Name() string     { return BorrowerSaveEvent }
func (e *BorrowerSave) PayloadType() any { return &models.Borrower{} }

func (e *BorrowerSave) Validate(_ context.Context, payload any) error {
	borrower, ok := payload.(*models.Borrower)
	if !ok {
		return errors.New("payload is not of type models.Borrower")
	}
	if borrower.GetID() == "" {
		return errors.New("borrower ID should already have been set")
	}
	return nil
}

func (e *BorrowerSave) Execute(ctx context.Context, payload any) error {
	borrower, ok := payload.(*models.Borrower)
	if !ok {
		return errors.New("payload is not of type models.Borrower")
	}

	logger := util.Log(ctx).WithField("type", e.Name()).WithField("borrower_id", borrower.GetID())
	defer logger.Release()
	logger.Debug("event handler started")

	existing, getErr := e.borrowerRepo.GetByID(ctx, borrower.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.borrowerRepo.Update(ctx, borrower); err != nil {
			logger.WithError(err).Error("could not update borrower in db")
			return err
		}
		logger.Debug("event handler completed successfully")
		return nil
	}

	if err := e.borrowerRepo.Create(ctx, borrower); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create borrower in db")
		return err
	}

	logger.Debug("event handler completed successfully")
	return nil
}
