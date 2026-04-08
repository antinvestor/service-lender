package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/origination/service/models"
	"github.com/antinvestor/service-fintech/apps/origination/service/repository"
)

const UnderwritingDecisionSaveEvent = "underwriting_decision.save"

type UnderwritingDecisionSave struct {
	repo repository.UnderwritingDecisionRepository
}

func NewUnderwritingDecisionSave(
	_ context.Context,
	repo repository.UnderwritingDecisionRepository,
) *UnderwritingDecisionSave {
	return &UnderwritingDecisionSave{repo: repo}
}

func (e *UnderwritingDecisionSave) Name() string     { return UnderwritingDecisionSaveEvent }
func (e *UnderwritingDecisionSave) PayloadType() any { return &models.UnderwritingDecision{} }

func (e *UnderwritingDecisionSave) Validate(_ context.Context, payload any) error {
	ud, ok := payload.(*models.UnderwritingDecision)
	if !ok {
		return errors.New("payload is not of type models.UnderwritingDecision")
	}
	if ud.GetID() == "" {
		return errors.New("underwriting decision ID should already have been set")
	}
	return nil
}

func (e *UnderwritingDecisionSave) Execute(ctx context.Context, payload any) error {
	ud, ok := payload.(*models.UnderwritingDecision)
	if !ok {
		return errors.New("payload is not of type models.UnderwritingDecision")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "underwriting_decision_id": ud.GetID()})
	defer logger.Release()

	existing, getErr := e.repo.GetByID(ctx, ud.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.repo.Update(ctx, ud); err != nil {
			logger.WithError(err).Error("could not update underwriting decision in db")
			return err
		}
		return nil
	}

	if err := e.repo.Create(ctx, ud); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create underwriting decision in db")
		return err
	}

	return nil
}
