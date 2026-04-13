package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
	"github.com/antinvestor/service-fintech/apps/identity/service/repository"
)

const ClientRelationshipSaveEvent = "client_relationship.save"

type ClientRelationshipSave struct {
	crRepo repository.ClientRelationshipRepository
}

func NewClientRelationshipSave(
	_ context.Context,
	crRepo repository.ClientRelationshipRepository,
) *ClientRelationshipSave {
	return &ClientRelationshipSave{crRepo: crRepo}
}

func (e *ClientRelationshipSave) Name() string     { return ClientRelationshipSaveEvent }
func (e *ClientRelationshipSave) PayloadType() any { return &models.ClientRelationship{} }

func (e *ClientRelationshipSave) Validate(_ context.Context, payload any) error {
	cr, ok := payload.(*models.ClientRelationship)
	if !ok {
		return errors.New("payload is not of type models.ClientRelationship")
	}
	if cr.GetID() == "" {
		return errors.New("client relationship ID should already have been set")
	}
	return nil
}

func (e *ClientRelationshipSave) Execute(ctx context.Context, payload any) error {
	cr, ok := payload.(*models.ClientRelationship)
	if !ok {
		return errors.New("payload is not of type models.ClientRelationship")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "cr_id": cr.GetID()})
	defer logger.Release()

	existing, getErr := e.crRepo.GetByID(ctx, cr.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.crRepo.Update(ctx, cr); err != nil {
			logger.WithError(err).Error("could not update client relationship in db")
			return err
		}
		return nil
	}

	if err := e.crRepo.Create(ctx, cr); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create client relationship in db")
		return err
	}

	return nil
}
