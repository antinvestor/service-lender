package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/loans/service/models"
)

type LoanAccountRepository interface {
	datastore.BaseRepository[*models.LoanAccount]
}

type loanAccountRepository struct {
	datastore.BaseRepository[*models.LoanAccount]
}

func NewLoanAccountRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) LoanAccountRepository {
	return &loanAccountRepository{
		BaseRepository: datastore.NewBaseRepository[*models.LoanAccount](
			ctx, dbPool, workMan, func() *models.LoanAccount { return &models.LoanAccount{} },
		),
	}
}
