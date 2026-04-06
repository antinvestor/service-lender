package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/antinvestor/service-lender/apps/identity/service/repository"
)

const OrganizationSaveEvent = "organization.save"

type OrganizationSave struct {
	organizationRepo repository.OrganizationRepository
}

func NewOrganizationSave(_ context.Context, organizationRepo repository.OrganizationRepository) *OrganizationSave {
	return &OrganizationSave{organizationRepo: organizationRepo}
}

func (e *OrganizationSave) Name() string     { return OrganizationSaveEvent }
func (e *OrganizationSave) PayloadType() any { return &models.Organization{} }

func (e *OrganizationSave) Validate(_ context.Context, payload any) error {
	organization, ok := payload.(*models.Organization)
	if !ok {
		return errors.New("payload is not of type models.Organization")
	}
	if organization.GetID() == "" {
		return errors.New("organization ID should already have been set")
	}
	return nil
}

func (e *OrganizationSave) Execute(ctx context.Context, payload any) error {
	organization, ok := payload.(*models.Organization)
	if !ok {
		return errors.New("payload is not of type models.Organization")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "organization_id": organization.GetID()})
	defer logger.Release()

	existing, getErr := e.organizationRepo.GetByID(ctx, organization.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.organizationRepo.Update(ctx, organization); err != nil {
			logger.WithError(err).Error("could not update organization in db")
			return err
		}
		return nil
	}

	if err := e.organizationRepo.Create(ctx, organization); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create organization in db")
		return err
	}

	return nil
}
