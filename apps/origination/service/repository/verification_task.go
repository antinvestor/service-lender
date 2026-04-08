package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/origination/service/models"
)

type VerificationTaskRepository interface {
	datastore.BaseRepository[*models.VerificationTask]
}

type verificationTaskRepository struct {
	datastore.BaseRepository[*models.VerificationTask]
}

func NewVerificationTaskRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) VerificationTaskRepository {
	return &verificationTaskRepository{
		BaseRepository: datastore.NewBaseRepository[*models.VerificationTask](
			ctx, dbPool, workMan, func() *models.VerificationTask { return &models.VerificationTask{} },
		),
	}
}
