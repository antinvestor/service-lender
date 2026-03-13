package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
)

type BorrowerAssignmentHistoryRepository interface {
	datastore.BaseRepository[*models.BorrowerAssignmentHistory]
	GetByBorrowerID(ctx context.Context, borrowerID string) ([]*models.BorrowerAssignmentHistory, error)
}

type borrowerAssignmentHistoryRepository struct {
	datastore.BaseRepository[*models.BorrowerAssignmentHistory]
}

func NewBorrowerAssignmentHistoryRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) BorrowerAssignmentHistoryRepository {
	return &borrowerAssignmentHistoryRepository{
		BaseRepository: datastore.NewBaseRepository[*models.BorrowerAssignmentHistory](
			ctx,
			dbPool,
			workMan,
			func() *models.BorrowerAssignmentHistory { return &models.BorrowerAssignmentHistory{} },
		),
	}
}

func (repo *borrowerAssignmentHistoryRepository) GetByBorrowerID(
	ctx context.Context,
	borrowerID string,
) ([]*models.BorrowerAssignmentHistory, error) {
	var history []*models.BorrowerAssignmentHistory
	err := repo.Pool().DB(ctx, true).
		Where("borrower_id = ?", borrowerID).
		Order("created_at DESC").
		Find(&history).Error
	if err != nil {
		return nil, err
	}
	return history, nil
}
