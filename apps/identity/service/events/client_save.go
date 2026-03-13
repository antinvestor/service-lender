package events

import (
	"context"
	"errors"

	"github.com/antinvestor/service-ant-lender/apps/identity/service/models"
	"github.com/antinvestor/service-ant-lender/apps/identity/service/repository"
	"github.com/pitabwire/util"
)

const ClientSaveEvent = "client.save"

type ClientSave struct {
	clientRepo repository.ClientRepository
}

func NewClientSave(_ context.Context, clientRepo repository.ClientRepository) *ClientSave {
	return &ClientSave{clientRepo: clientRepo}
}

func (e *ClientSave) Name() string         { return ClientSaveEvent }
func (e *ClientSave) PayloadType() any     { return &models.Client{} }

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
	client := payload.(*models.Client)

	logger := util.Log(ctx).WithField("type", e.Name()).WithField("client_id", client.GetID())
	defer logger.Release()
	logger.Debug("event handler started")

	err := e.clientRepo.Create(ctx, client)
	if err != nil {
		logger.WithError(err).Error("could not save client to db")
		return err
	}

	logger.Debug("event handler completed successfully")
	return nil
}
