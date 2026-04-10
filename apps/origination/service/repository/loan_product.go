package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/origination/service/models"
)

type LoanProductRepository interface {
	datastore.BaseRepository[*models.LoanProduct]
	GetByOrganizationID(ctx context.Context, organizationID string) ([]*models.LoanProduct, error)
}

type loanProductRepository struct {
	datastore.BaseRepository[*models.LoanProduct]
}

func NewLoanProductRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) LoanProductRepository {
	return &loanProductRepository{
		BaseRepository: datastore.NewBaseRepository[*models.LoanProduct](
			ctx, dbPool, workMan, func() *models.LoanProduct { return &models.LoanProduct{} },
		),
	}
}

func (repo *loanProductRepository) GetByOrganizationID(
	ctx context.Context,
	organizationID string,
) ([]*models.LoanProduct, error) {
	var products []*models.LoanProduct
	err := repo.Pool().DB(ctx, true).
		Where("organization_id = ?", organizationID).
		Find(&products).Error
	if err != nil {
		return nil, err
	}
	return products, nil
}
