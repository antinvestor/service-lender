package repository //nolint:dupl // similar repository patterns for different entity types

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
)

type InvestorRepository interface {
	datastore.BaseRepository[*models.Investor]
	GetByProfileID(ctx context.Context, profileID string) (*models.Investor, error)
}

type investorRepository struct {
	datastore.BaseRepository[*models.Investor]
}

func NewInvestorRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) InvestorRepository {
	return &investorRepository{
		BaseRepository: datastore.NewBaseRepository[*models.Investor](
			ctx, dbPool, workMan, func() *models.Investor { return &models.Investor{} },
		),
	}
}

func (repo *investorRepository) GetByProfileID(ctx context.Context, profileID string) (*models.Investor, error) {
	investor := models.Investor{}
	err := repo.Pool().DB(ctx, true).First(&investor, "profile_id = ?", profileID).Error
	if err != nil {
		return nil, err
	}
	return &investor, nil
}
