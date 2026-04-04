package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-lender/apps/operations/service/models"
	"github.com/antinvestor/service-lender/apps/operations/service/repository"
)

const CBSSyncRecordSaveEvent = "cbs_sync_record.save"

// NewCBSSyncRecordSave creates a new CBS sync record save event handler.
func NewCBSSyncRecordSave(_ context.Context, repo repository.CBSSyncRecordRepository) events.EventI {
	return &eventHandler[*models.CBSSyncRecord]{
		name:    CBSSyncRecordSaveEvent,
		factory: func() *models.CBSSyncRecord { return &models.CBSSyncRecord{} },
		validate: func(_ context.Context, cs *models.CBSSyncRecord) error {
			if cs.OwnerID == "" {
				return errors.New("owner_id is required")
			}
			return nil
		},
		repo: repo,
	}
}
