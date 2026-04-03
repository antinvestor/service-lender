package events //nolint:dupl // similar patterns for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/group/service/models"
	"github.com/antinvestor/service-lender/apps/group/service/repository"
)

const CustomerGroupSaveEvent = "customer_group.save"

type customerGroupSave struct {
	repo repository.CustomerGroupRepository
}

// NewCustomerGroupSave creates a new customer group save event handler.
func NewCustomerGroupSave(_ context.Context, repo repository.CustomerGroupRepository) *customerGroupSave {
	return &customerGroupSave{repo: repo}
}

func (e *customerGroupSave) Name() string {
	return CustomerGroupSaveEvent
}

func (e *customerGroupSave) PayloadType() any {
	return &models.CustomerGroup{}
}

func (e *customerGroupSave) Validate(_ context.Context, payload any) error {
	group, ok := payload.(*models.CustomerGroup)
	if !ok {
		return errors.New("invalid payload type for customer_group.save")
	}
	if group.Name == "" {
		return errors.New("customer group name is required")
	}
	return nil
}

func (e *customerGroupSave) Execute(ctx context.Context, payload any) error {
	group, ok := payload.(*models.CustomerGroup)
	if !ok {
		return errors.New("invalid payload type for customer_group.save")
	}
	log := util.Log(ctx)

	if group.GetVersion() > 0 {
		_, err := e.repo.Update(ctx, group)
		if err != nil {
			log.WithError(err).Error("customer_group.save -- could not update customer group")
			return err
		}
		return nil
	}

	err := e.repo.Create(ctx, group)
	if err != nil {
		if data.ErrorIsDuplicateKey(err) {
			log.WithError(err).Warn("customer_group.save -- duplicate customer group, attempting update")
			existing, getErr := e.repo.GetByID(ctx, group.GetID())
			if getErr != nil {
				return getErr
			}
			group.Version = existing.Version
			_, err = e.repo.Update(ctx, group)
			if err != nil {
				log.WithError(err).Error("customer_group.save -- could not update existing customer group")
				return err
			}
			return nil
		}
		log.WithError(err).Error("customer_group.save -- could not create customer group")
		return err
	}

	return nil
}

var _ events.EventI = (*customerGroupSave)(nil)
