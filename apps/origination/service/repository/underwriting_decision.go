package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/origination/service/models"
)

type UnderwritingDecisionRepository interface {
	datastore.BaseRepository[*models.UnderwritingDecision]
}

type underwritingDecisionRepository struct {
	datastore.BaseRepository[*models.UnderwritingDecision]
}

func NewUnderwritingDecisionRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) UnderwritingDecisionRepository {
	return &underwritingDecisionRepository{
		BaseRepository: datastore.NewBaseRepository[*models.UnderwritingDecision](
			ctx, dbPool, workMan, func() *models.UnderwritingDecision { return &models.UnderwritingDecision{} },
		),
	}
}
