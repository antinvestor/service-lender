package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
)

type BranchRepository interface {
	datastore.BaseRepository[*models.Branch]
	GetByCode(ctx context.Context, code string) (*models.Branch, error)
	GetByOrganizationID(ctx context.Context, organizationID string, offset, limit int) ([]*models.Branch, error)
}

type branchRepository struct {
	datastore.BaseRepository[*models.Branch]
}

func NewBranchRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) BranchRepository {
	return &branchRepository{
		BaseRepository: datastore.NewBaseRepository[*models.Branch](
			ctx, dbPool, workMan, func() *models.Branch { return &models.Branch{} },
		),
	}
}

func (repo *branchRepository) GetByCode(ctx context.Context, code string) (*models.Branch, error) {
	branch := models.Branch{}
	err := repo.Pool().DB(ctx, true).First(&branch, "code = ?", code).Error
	if err != nil {
		return nil, err
	}
	return &branch, nil
}

func (repo *branchRepository) GetByOrganizationID(
	ctx context.Context,
	organizationID string,
	offset, limit int,
) ([]*models.Branch, error) {
	var branches []*models.Branch
	err := repo.Pool().DB(ctx, true).
		Where("organization_id = ?", organizationID).
		Offset(offset).Limit(limit).
		Find(&branches).Error
	if err != nil {
		return nil, err
	}
	return branches, nil
}
