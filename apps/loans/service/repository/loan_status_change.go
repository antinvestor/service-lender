package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/loans/service/models"
)

type LoanStatusChangeRepository interface {
	datastore.BaseRepository[*models.LoanStatusChange]
}

type loanStatusChangeRepository struct {
	datastore.BaseRepository[*models.LoanStatusChange]
}

func NewLoanStatusChangeRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) LoanStatusChangeRepository {
	return &loanStatusChangeRepository{
		BaseRepository: datastore.NewBaseRepository[*models.LoanStatusChange](
			ctx, dbPool, workMan, func() *models.LoanStatusChange { return &models.LoanStatusChange{} },
		),
	}
}
