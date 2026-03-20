package events

import (
	"context"
	"errors"

	"github.com/pitabwire/util"
	"gorm.io/gorm"

	"github.com/antinvestor/service-lender/apps/operations/service/models"
	"github.com/antinvestor/service-lender/apps/operations/service/repository"
)

const CBSSyncRecordSaveEvent = "cbs_sync_record.save"

type cbsSyncRecordSave struct {
	repo repository.CBSSyncRecordRepository
}

// NewCBSSyncRecordSave creates a new CBS sync record save event handler.
func NewCBSSyncRecordSave(_ context.Context, repo repository.CBSSyncRecordRepository) *cbsSyncRecordSave {
	return &cbsSyncRecordSave{repo: repo}
}

func (e *cbsSyncRecordSave) Name() string {
	return CBSSyncRecordSaveEvent
}

func (e *cbsSyncRecordSave) PayloadType() any {
	return &models.CBSSyncRecord{}
}

func (e *cbsSyncRecordSave) Validate(_ context.Context, payload any) error {
	cs, ok := payload.(*models.CBSSyncRecord)
	if !ok {
		return errors.New("invalid payload type for cbs_sync_record.save")
	}
	if cs.OwnerID == "" {
		return errors.New("owner_id is required")
	}
	return nil
}

func (e *cbsSyncRecordSave) Execute(ctx context.Context, payload any) error {
	cs := payload.(*models.CBSSyncRecord)
	log := util.Log(ctx)

	existing, err := e.repo.GetByID(ctx, cs.ID)
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		log.WithError(err).Error("cbs_sync_record.save -- failed to check existing record")
		return err
	}

	if existing != nil && existing.GetID() != "" {
		_, err = e.repo.Update(ctx, cs)
		if err != nil {
			log.WithError(err).Error("cbs_sync_record.save -- failed to update record")
			return err
		}
		return nil
	}

	err = e.repo.Create(ctx, cs)
	if err != nil {
		log.WithError(err).Error("cbs_sync_record.save -- failed to create record")
		return err
	}
	return nil
}
