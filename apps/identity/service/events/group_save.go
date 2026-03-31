package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/antinvestor/service-lender/apps/identity/service/repository"
)

const GroupSaveEvent = "group.save"

type GroupSave struct {
	groupRepo repository.GroupRepository
}

func NewGroupSave(_ context.Context, groupRepo repository.GroupRepository) *GroupSave {
	return &GroupSave{groupRepo: groupRepo}
}

func (e *GroupSave) Name() string     { return GroupSaveEvent }
func (e *GroupSave) PayloadType() any { return &models.Group{} }

func (e *GroupSave) Validate(_ context.Context, payload any) error {
	group, ok := payload.(*models.Group)
	if !ok {
		return errors.New("payload is not of type models.Group")
	}
	if group.GetID() == "" {
		return errors.New("group ID should already have been set")
	}
	return nil
}

func (e *GroupSave) Execute(ctx context.Context, payload any) error {
	group, ok := payload.(*models.Group)
	if !ok {
		return errors.New("payload is not of type models.Group")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "group_id": group.GetID()})
	defer logger.Release()

	existing, getErr := e.groupRepo.GetByID(ctx, group.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.groupRepo.Update(ctx, group); err != nil {
			logger.WithError(err).Error("could not update group in db")
			return err
		}
		return nil
	}

	if err := e.groupRepo.Create(ctx, group); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create group in db")
		return err
	}

	return nil
}
