package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
	"github.com/antinvestor/service-fintech/apps/identity/service/repository"
)

const ClientDataEntrySaveEvent = "client_data_entry.save"

type ClientDataEntrySave struct {
	entryRepo repository.ClientDataEntryRepository
}

func NewClientDataEntrySave(_ context.Context, entryRepo repository.ClientDataEntryRepository) *ClientDataEntrySave {
	return &ClientDataEntrySave{entryRepo: entryRepo}
}

func (e *ClientDataEntrySave) Name() string     { return ClientDataEntrySaveEvent }
func (e *ClientDataEntrySave) PayloadType() any { return &models.ClientDataEntry{} }

func (e *ClientDataEntrySave) Validate(_ context.Context, payload any) error {
	entry, ok := payload.(*models.ClientDataEntry)
	if !ok {
		return errors.New("payload is not of type models.ClientDataEntry")
	}
	if entry.GetID() == "" {
		return errors.New("client data entry ID should already have been set")
	}
	return nil
}

func (e *ClientDataEntrySave) Execute(ctx context.Context, payload any) error {
	entry, ok := payload.(*models.ClientDataEntry)
	if !ok {
		return errors.New("payload is not of type models.ClientDataEntry")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "entry_id": entry.GetID()})
	defer logger.Release()

	existing, getErr := e.entryRepo.GetByID(ctx, entry.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.entryRepo.Update(ctx, entry); err != nil {
			logger.WithError(err).Error("could not update client data entry in db")
			return err
		}
		return nil
	}

	if err := e.entryRepo.Create(ctx, entry); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create client data entry in db")
		return err
	}

	return nil
}
