package repository

import (
	"context"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"
)

type BorrowerRepository interface {
	datastore.BaseRepository[*models.Borrower]
	GetByAgentID(ctx context.Context, agentID string, offset, limit int) ([]*models.Borrower, error)
	GetByProfileID(ctx context.Context, profileID string) (*models.Borrower, error)
}

type borrowerRepository struct {
	datastore.BaseRepository[*models.Borrower]
}

func NewBorrowerRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) BorrowerRepository {
	return &borrowerRepository{
		BaseRepository: datastore.NewBaseRepository[*models.Borrower](
			ctx, dbPool, workMan, func() *models.Borrower { return &models.Borrower{} },
		),
	}
}

func (repo *borrowerRepository) GetByAgentID(ctx context.Context, agentID string, offset, limit int) ([]*models.Borrower, error) {
	var borrowers []*models.Borrower
	err := repo.Pool().DB(ctx, true).
		Where("agent_id = ?", agentID).
		Offset(offset).Limit(limit).
		Find(&borrowers).Error
	if err != nil {
		return nil, err
	}
	return borrowers, nil
}

func (repo *borrowerRepository) GetByProfileID(ctx context.Context, profileID string) (*models.Borrower, error) {
	borrower := models.Borrower{}
	err := repo.Pool().DB(ctx, true).First(&borrower, "profile_id = ?", profileID).Error
	if err != nil {
		return nil, err
	}
	return &borrower, nil
}
