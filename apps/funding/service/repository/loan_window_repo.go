package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/funding/service/models"
	"github.com/antinvestor/service-lender/pkg/constants"
)

// LoanWindowRepository provides data access for loan windows.
type LoanWindowRepository interface {
	datastore.BaseRepository[*models.LoanWindow]
	CountByGroupID(ctx context.Context, groupID string) (int32, error)
	GetByGroupID(ctx context.Context, groupID string) ([]*models.LoanWindow, error)
}

// NewLoanWindowRepository creates a new LoanWindowRepository.
func NewLoanWindowRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) LoanWindowRepository {
	return &loanWindowRepository{
		BaseRepository: datastore.NewBaseRepository(ctx, dbPool, workMan, func() *models.LoanWindow {
			return &models.LoanWindow{}
		}),
	}
}

type loanWindowRepository struct {
	datastore.BaseRepository[*models.LoanWindow]
}

func (r *loanWindowRepository) CountByGroupID(ctx context.Context, groupID string) (int32, error) {
	var count int64
	err := r.Pool().DB(ctx, true).Model(&models.LoanWindow{}).
		Where("group_id = ?", groupID).Count(&count).Error
	return constants.SafeInt32FromInt64(count), err
}

func (r *loanWindowRepository) GetByGroupID(ctx context.Context, groupID string) ([]*models.LoanWindow, error) {
	var windows []*models.LoanWindow
	err := r.Pool().DB(ctx, true).Where("group_id = ?", groupID).Find(&windows).Error
	return windows, err
}
