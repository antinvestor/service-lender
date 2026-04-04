package repository //nolint:dupl // similar patterns for different entity types

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/loans/service/models"
)

type LoanProductRepository interface {
	datastore.BaseRepository[*models.LoanProduct]
	GetByCode(ctx context.Context, code string) (*models.LoanProduct, error)
}

type loanProductRepository struct {
	datastore.BaseRepository[*models.LoanProduct]
}

func NewLoanProductRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) LoanProductRepository {
	return &loanProductRepository{
		BaseRepository: datastore.NewBaseRepository[*models.LoanProduct](
			ctx, dbPool, workMan, func() *models.LoanProduct { return &models.LoanProduct{} },
		),
	}
}

func (repo *loanProductRepository) GetByCode(
	ctx context.Context,
	code string,
) (*models.LoanProduct, error) {
	loanProduct := models.LoanProduct{}
	err := repo.Pool().DB(ctx, true).
		First(&loanProduct, "code = ?", code).Error
	if err != nil {
		return nil, err
	}
	return &loanProduct, nil
}
