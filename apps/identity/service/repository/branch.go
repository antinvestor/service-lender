package repository

import (
	"context"

	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
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
	err := repo.Pool().DB(ctx, true).First(
		&branch,
		"code = ? AND unit_type = ?",
		code,
		int32(identityv1.OrgUnitType_ORG_UNIT_TYPE_BRANCH),
	).Error
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
		Where(
			"organization_id = ? AND unit_type = ?",
			organizationID,
			int32(identityv1.OrgUnitType_ORG_UNIT_TYPE_BRANCH),
		).
		Offset(offset).Limit(limit).
		Find(&branches).Error
	if err != nil {
		return nil, err
	}
	return branches, nil
}
