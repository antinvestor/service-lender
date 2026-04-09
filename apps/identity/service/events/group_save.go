package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
	"github.com/antinvestor/service-fintech/apps/identity/service/repository"
)

const ClientGroupSaveEvent = "client_group.save"

type ClientGroupSave struct {
	clientGroupRepo repository.ClientGroupRepository
}

func NewClientGroupSave(_ context.Context, clientGroupRepo repository.ClientGroupRepository) *ClientGroupSave {
	return &ClientGroupSave{clientGroupRepo: clientGroupRepo}
}

func (e *ClientGroupSave) Name() string     { return ClientGroupSaveEvent }
func (e *ClientGroupSave) PayloadType() any { return &models.ClientGroup{} }

func (e *ClientGroupSave) Validate(_ context.Context, payload any) error {
	group, ok := payload.(*models.ClientGroup)
	if !ok {
		return errors.New("payload is not of type models.ClientGroup")
	}
	if group.GetID() == "" {
		return errors.New("group ID should already have been set")
	}
	return nil
}

func (e *ClientGroupSave) Execute(ctx context.Context, payload any) error {
	group, ok := payload.(*models.ClientGroup)
	if !ok {
		return errors.New("payload is not of type models.ClientGroup")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "group_id": group.GetID()})
	defer logger.Release()

	existing, getErr := e.clientGroupRepo.GetByID(ctx, group.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.clientGroupRepo.Update(ctx, group); err != nil {
			logger.WithError(err).Error("could not update client group in db")
			return err
		}
		return nil
	}

	if err := e.clientGroupRepo.Create(ctx, group); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create client group in db")
		return err
	}

	return nil
}
