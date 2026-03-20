package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/loans/service/models"
)

type LoanRestructureRepository interface {
	datastore.BaseRepository[*models.LoanRestructure]
}

type loanRestructureRepository struct {
	datastore.BaseRepository[*models.LoanRestructure]
}

func NewLoanRestructureRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) LoanRestructureRepository {
	return &loanRestructureRepository{
		BaseRepository: datastore.NewBaseRepository[*models.LoanRestructure](
			ctx, dbPool, workMan, func() *models.LoanRestructure { return &models.LoanRestructure{} },
		),
	}
}
