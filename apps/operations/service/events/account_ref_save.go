package events

import (
	"context"
	"errors"

	"github.com/pitabwire/util"
	"gorm.io/gorm"

	"github.com/antinvestor/service-lender/apps/operations/service/models"
	"github.com/antinvestor/service-lender/apps/operations/service/repository"
)

const AccountRefSaveEvent = "account_ref.save"

type accountRefSave struct {
	repo repository.AccountRefRepository
}

// NewAccountRefSave creates a new account ref save event handler.
func NewAccountRefSave(_ context.Context, repo repository.AccountRefRepository) *accountRefSave {
	return &accountRefSave{repo: repo}
}

func (e *accountRefSave) Name() string {
	return AccountRefSaveEvent
}

func (e *accountRefSave) PayloadType() any {
	return &models.AccountRef{}
}

func (e *accountRefSave) Validate(_ context.Context, payload any) error {
	ar, ok := payload.(*models.AccountRef)
	if !ok {
		return errors.New("invalid payload type for account_ref.save")
	}
	if ar.OwnerID == "" {
		return errors.New("owner_id is required")
	}
	return nil
}

func (e *accountRefSave) Execute(ctx context.Context, payload any) error {
	ar, ok := payload.(*models.AccountRef)
	if !ok {
		return errors.New("invalid payload type for account_ref.save")
	}
	log := util.Log(ctx)

	existing, err := e.repo.GetByID(ctx, ar.ID)
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		log.WithError(err).Error("account_ref.save -- failed to check existing record")
		return err
	}

	if existing != nil && existing.GetID() != "" {
		_, err = e.repo.Update(ctx, ar)
		if err != nil {
			log.WithError(err).Error("account_ref.save -- failed to update record")
			return err
		}
		return nil
	}

	err = e.repo.Create(ctx, ar)
	if err != nil {
		log.WithError(err).Error("account_ref.save -- failed to create record")
		return err
	}
	return nil
}
