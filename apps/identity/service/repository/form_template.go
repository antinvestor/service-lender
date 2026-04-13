package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
)

type FormTemplateRepository interface {
	datastore.BaseRepository[*models.FormTemplate]
}

type formTemplateRepository struct {
	datastore.BaseRepository[*models.FormTemplate]
}

func NewFormTemplateRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) FormTemplateRepository {
	return &formTemplateRepository{
		BaseRepository: datastore.NewBaseRepository[*models.FormTemplate](
			ctx, dbPool, workMan, func() *models.FormTemplate { return &models.FormTemplate{} },
		),
	}
}
