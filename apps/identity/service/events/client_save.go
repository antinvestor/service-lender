package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/antinvestor/service-lender/apps/identity/service/repository"
)

const ClientSaveEvent = "client.save"

type ClientSave struct {
	clientRepo repository.ClientRepository
}

func NewClientSave(_ context.Context, clientRepo repository.ClientRepository) *ClientSave {
	return &ClientSave{clientRepo: clientRepo}
}

func (e *ClientSave) Name() string     { return ClientSaveEvent }
func (e *ClientSave) PayloadType() any { return &models.Client{} }

func (e *ClientSave) Validate(_ context.Context, payload any) error {
	client, ok := payload.(*models.Client)
	if !ok {
		return errors.New("payload is not of type models.Client")
	}
	if client.GetID() == "" {
		return errors.New("client ID should already have been set")
	}
	return nil
}

func (e *ClientSave) Execute(ctx context.Context, payload any) error {
	client, ok := payload.(*models.Client)
	if !ok {
		return errors.New("payload is not of type models.Client")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "client_id": client.GetID()})
	defer logger.Release()

	existing, getErr := e.clientRepo.GetByID(ctx, client.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.clientRepo.Update(ctx, client); err != nil {
			logger.WithError(err).Error("could not update client in db")
			return err
		}
		return nil
	}

	if err := e.clientRepo.Create(ctx, client); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create client in db")
		return err
	}

	return nil
}
