package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
	"github.com/antinvestor/service-fintech/apps/identity/service/repository"
)

const InternalTeamSaveEvent = "internal_team.save"

type InternalTeamSave struct {
	repo repository.InternalTeamRepository
}

func NewInternalTeamSave(_ context.Context, repo repository.InternalTeamRepository) *InternalTeamSave {
	return &InternalTeamSave{repo: repo}
}

func (e *InternalTeamSave) Name() string     { return InternalTeamSaveEvent }
func (e *InternalTeamSave) PayloadType() any { return &models.InternalTeam{} }

func (e *InternalTeamSave) Validate(_ context.Context, payload any) error {
	m, ok := payload.(*models.InternalTeam)
	if !ok {
		return errors.New("payload is not of type models.InternalTeam")
	}
	if m.GetID() == "" {
		return errors.New("internal team ID should already have been set")
	}
	return nil
}

func (e *InternalTeamSave) Execute(ctx context.Context, payload any) error {
	m, ok := payload.(*models.InternalTeam)
	if !ok {
		return errors.New("payload is not of type models.InternalTeam")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "team_id": m.GetID()})
	defer logger.Release()

	existing, getErr := e.repo.GetByID(ctx, m.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.repo.Update(ctx, m); err != nil {
			logger.WithError(err).Error("could not update internal team in db")
			return err
		}
		return nil
	}

	if err := e.repo.Create(ctx, m); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create internal team in db")
		return err
	}

	return nil
}
