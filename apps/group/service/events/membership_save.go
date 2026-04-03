package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/group/service/models"
	"github.com/antinvestor/service-lender/apps/group/service/repository"
)

const MembershipSaveEvent = "membership.save"

type membershipSave struct {
	repo repository.MembershipRepository
}

// NewMembershipSave creates a new membership save event handler.
func NewMembershipSave(_ context.Context, repo repository.MembershipRepository) *membershipSave {
	return &membershipSave{repo: repo}
}

func (e *membershipSave) Name() string {
	return MembershipSaveEvent
}

func (e *membershipSave) PayloadType() any {
	return &models.Membership{}
}

func (e *membershipSave) Validate(_ context.Context, payload any) error {
	membership, ok := payload.(*models.Membership)
	if !ok {
		return errors.New("invalid payload type for membership.save")
	}
	if membership.GroupID == "" {
		return errors.New("membership group ID is required")
	}
	return nil
}

func (e *membershipSave) Execute(ctx context.Context, payload any) error {
	membership, ok := payload.(*models.Membership)
	if !ok {
		return errors.New("invalid payload type for membership.save")
	}
	log := util.Log(ctx)

	if membership.GetVersion() > 0 {
		_, err := e.repo.Update(ctx, membership)
		if err != nil {
			log.WithError(err).Error("membership.save -- could not update membership")
			return err
		}
		return nil
	}

	err := e.repo.Create(ctx, membership)
	if err != nil {
		if data.ErrorIsDuplicateKey(err) {
			log.WithError(err).Warn("membership.save -- duplicate membership, attempting update")
			existing, getErr := e.repo.GetByID(ctx, membership.GetID())
			if getErr != nil {
				return getErr
			}
			membership.Version = existing.Version
			_, err = e.repo.Update(ctx, membership)
			if err != nil {
				log.WithError(err).Error("membership.save -- could not update existing membership")
				return err
			}
			return nil
		}
		log.WithError(err).Error("membership.save -- could not create membership")
		return err
	}

	return nil
}

var _ events.EventI = (*membershipSave)(nil)
