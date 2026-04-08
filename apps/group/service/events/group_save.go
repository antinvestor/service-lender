package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-fintech/apps/group/service/models"
	"github.com/antinvestor/service-fintech/apps/group/service/repository"
)

const CustomerGroupSaveEvent = "customer_group.save"

// NewCustomerGroupSave creates a new customer group save event handler.
func NewCustomerGroupSave(_ context.Context, repo repository.CustomerGroupRepository) events.EventI {
	return &eventHandler[*models.CustomerGroup]{
		name:    CustomerGroupSaveEvent,
		factory: func() *models.CustomerGroup { return &models.CustomerGroup{} },
		validate: func(_ context.Context, group *models.CustomerGroup) error {
			if group.Name == "" {
				return errors.New("customer group name is required")
			}
			return nil
		},
		repo: repo,
	}
}
