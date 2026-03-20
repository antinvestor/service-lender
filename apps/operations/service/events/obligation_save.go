package events

import (
	"context"
	"errors"

	"github.com/pitabwire/util"
	"gorm.io/gorm"

	"github.com/antinvestor/service-lender/apps/operations/service/models"
	"github.com/antinvestor/service-lender/apps/operations/service/repository"
)

const ObligationSaveEvent = "obligation.save"

type obligationSave struct {
	repo repository.ObligationRepository
}

// NewObligationSave creates a new obligation save event handler.
func NewObligationSave(_ context.Context, repo repository.ObligationRepository) *obligationSave {
	return &obligationSave{repo: repo}
}

func (e *obligationSave) Name() string {
	return ObligationSaveEvent
}

func (e *obligationSave) PayloadType() any {
	return &models.Obligation{}
}

func (e *obligationSave) Validate(_ context.Context, payload any) error {
	ob, ok := payload.(*models.Obligation)
	if !ok {
		return errors.New("invalid payload type for obligation.save")
	}
	if ob.MembershipID == "" {
		return errors.New("membership_id is required")
	}
	return nil
}

func (e *obligationSave) Execute(ctx context.Context, payload any) error {
	ob := payload.(*models.Obligation)
	log := util.Log(ctx)

	existing, err := e.repo.GetByID(ctx, ob.ID)
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		log.WithError(err).Error("obligation.save -- failed to check existing record")
		return err
	}

	if existing != nil && existing.GetID() != "" {
		_, err = e.repo.Update(ctx, ob)
		if err != nil {
			log.WithError(err).Error("obligation.save -- failed to update record")
			return err
		}
		return nil
	}

	err = e.repo.Create(ctx, ob)
	if err != nil {
		log.WithError(err).Error("obligation.save -- failed to create record")
		return err
	}
	return nil
}
