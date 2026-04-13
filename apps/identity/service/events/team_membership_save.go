package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
	"github.com/antinvestor/service-fintech/apps/identity/service/repository"
)

const TeamMembershipSaveEvent = "team_membership.save"

type TeamMembershipSave struct {
	repo repository.TeamMembershipRepository
}

func NewTeamMembershipSave(_ context.Context, repo repository.TeamMembershipRepository) *TeamMembershipSave {
	return &TeamMembershipSave{repo: repo}
}

func (e *TeamMembershipSave) Name() string     { return TeamMembershipSaveEvent }
func (e *TeamMembershipSave) PayloadType() any { return &models.TeamMembership{} }

func (e *TeamMembershipSave) Validate(_ context.Context, payload any) error {
	m, ok := payload.(*models.TeamMembership)
	if !ok {
		return errors.New("payload is not of type models.TeamMembership")
	}
	if m.GetID() == "" {
		return errors.New("team membership ID should already have been set")
	}
	return nil
}

func (e *TeamMembershipSave) Execute(ctx context.Context, payload any) error {
	m, ok := payload.(*models.TeamMembership)
	if !ok {
		return errors.New("payload is not of type models.TeamMembership")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "membership_id": m.GetID()})
	defer logger.Release()

	existing, getErr := e.repo.GetByID(ctx, m.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.repo.Update(ctx, m); err != nil {
			logger.WithError(err).Error("could not update team membership in db")
			return err
		}
		return nil
	}

	if err := e.repo.Create(ctx, m); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create team membership in db")
		return err
	}

	return nil
}
