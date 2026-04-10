package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/loans/service/models"
)

type LoanBalanceRepository interface {
	datastore.BaseRepository[*models.LoanBalance]
	GetByLoanAccountID(ctx context.Context, loanAccountID string) (*models.LoanBalance, error)
}

type loanBalanceRepository struct {
	entityRepository[*models.LoanBalance]
}

func NewLoanBalanceRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) LoanBalanceRepository {
	return &loanBalanceRepository{
		entityRepository: newEntityRepository(ctx, dbPool, workMan, func() *models.LoanBalance {
			return &models.LoanBalance{}
		}),
	}
}

func (repo *loanBalanceRepository) GetByLoanAccountID(
	ctx context.Context,
	loanAccountID string,
) (*models.LoanBalance, error) {
	return repo.findOneByField(ctx, "loan_account_id = ?", loanAccountID)
}
