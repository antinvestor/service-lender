package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/antinvestor/service-lender/apps/identity/service/repository"
)

const MembershipSaveEvent = "membership.save"

type MembershipSave struct {
	membershipRepo repository.MembershipRepository
}

func NewMembershipSave(_ context.Context, membershipRepo repository.MembershipRepository) *MembershipSave {
	return &MembershipSave{membershipRepo: membershipRepo}
}

func (e *MembershipSave) Name() string     { return MembershipSaveEvent }
func (e *MembershipSave) PayloadType() any { return &models.Membership{} }

func (e *MembershipSave) Validate(_ context.Context, payload any) error {
	membership, ok := payload.(*models.Membership)
	if !ok {
		return errors.New("payload is not of type models.Membership")
	}
	if membership.GetID() == "" {
		return errors.New("membership ID should already have been set")
	}
	return nil
}

func (e *MembershipSave) Execute(ctx context.Context, payload any) error {
	membership, ok := payload.(*models.Membership)
	if !ok {
		return errors.New("payload is not of type models.Membership")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "membership_id": membership.GetID()})
	defer logger.Release()

	existing, getErr := e.membershipRepo.GetByID(ctx, membership.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.membershipRepo.Update(ctx, membership); err != nil {
			logger.WithError(err).Error("could not update membership in db")
			return err
		}
		return nil
	}

	if err := e.membershipRepo.Create(ctx, membership); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create membership in db")
		return err
	}

	return nil
}
