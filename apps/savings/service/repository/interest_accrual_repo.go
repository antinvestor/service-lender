package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/savings/service/models"
)

type InterestAccrualRepository interface {
	datastore.BaseRepository[*models.InterestAccrual]
}

type interestAccrualRepository struct {
	datastore.BaseRepository[*models.InterestAccrual]
}

func NewInterestAccrualRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) InterestAccrualRepository {
	return &interestAccrualRepository{
		BaseRepository: datastore.NewBaseRepository[*models.InterestAccrual](
			ctx, dbPool, workMan, func() *models.InterestAccrual { return &models.InterestAccrual{} },
		),
	}
}
