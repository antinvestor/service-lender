package repository //nolint:dupl // similar patterns for different entity types

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/loans/service/models"
)

type LoanBalanceRepository interface {
	datastore.BaseRepository[*models.LoanBalance]
	GetByLoanAccountID(ctx context.Context, loanAccountID string) (*models.LoanBalance, error)
}

type loanBalanceRepository struct {
	datastore.BaseRepository[*models.LoanBalance]
}

func NewLoanBalanceRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) LoanBalanceRepository {
	return &loanBalanceRepository{
		BaseRepository: datastore.NewBaseRepository[*models.LoanBalance](
			ctx, dbPool, workMan, func() *models.LoanBalance { return &models.LoanBalance{} },
		),
	}
}

func (repo *loanBalanceRepository) GetByLoanAccountID(
	ctx context.Context,
	loanAccountID string,
) (*models.LoanBalance, error) {
	balance := models.LoanBalance{}
	err := repo.Pool().DB(ctx, true).
		First(&balance, "loan_account_id = ?", loanAccountID).Error
	if err != nil {
		return nil, err
	}
	return &balance, nil
}
