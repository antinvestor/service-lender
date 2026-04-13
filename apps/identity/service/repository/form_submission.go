package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
)

type FormSubmissionRepository interface {
	datastore.BaseRepository[*models.FormSubmission]
	GetByEntityAndTemplate(ctx context.Context, entityID, templateID string) (*models.FormSubmission, error)
}

type formSubmissionRepository struct {
	datastore.BaseRepository[*models.FormSubmission]
}

func NewFormSubmissionRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) FormSubmissionRepository {
	return &formSubmissionRepository{
		BaseRepository: datastore.NewBaseRepository[*models.FormSubmission](
			ctx, dbPool, workMan, func() *models.FormSubmission { return &models.FormSubmission{} },
		),
	}
}

func (repo *formSubmissionRepository) GetByEntityAndTemplate(
	ctx context.Context,
	entityID, templateID string,
) (*models.FormSubmission, error) {
	fs := models.FormSubmission{}
	err := repo.Pool().DB(ctx, true).
		First(&fs, "entity_id = ? AND template_id = ?", entityID, templateID).Error
	if err != nil {
		return nil, err
	}
	return &fs, nil
}
