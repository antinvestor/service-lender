package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/loans/service/models"
)

type LoanRequestRepository interface {
	datastore.BaseRepository[*models.LoanRequest]
	GetByIdempotencyKey(ctx context.Context, key string) (*models.LoanRequest, error)
	GetByLoanAccountID(ctx context.Context, loanAccountID string) (*models.LoanRequest, error)
}

type loanRequestRepository struct {
	datastore.BaseRepository[*models.LoanRequest]
}

func NewLoanRequestRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) LoanRequestRepository {
	return &loanRequestRepository{
		BaseRepository: datastore.NewBaseRepository[*models.LoanRequest](
			ctx, dbPool, workMan, func() *models.LoanRequest { return &models.LoanRequest{} },
		),
	}
}

func (repo *loanRequestRepository) GetByIdempotencyKey(
	ctx context.Context,
	key string,
) (*models.LoanRequest, error) {
	lr := models.LoanRequest{}
	err := repo.Pool().DB(ctx, true).
		First(&lr, "idempotency_key = ?", key).Error
	if err != nil {
		return nil, err
	}
	return &lr, nil
}

func (repo *loanRequestRepository) GetByLoanAccountID(
	ctx context.Context,
	loanAccountID string,
) (*models.LoanRequest, error) {
	lr := models.LoanRequest{}
	err := repo.Pool().DB(ctx, true).
		First(&lr, "loan_account_id = ?", loanAccountID).Error
	if err != nil {
		return nil, err
	}
	return &lr, nil
}
