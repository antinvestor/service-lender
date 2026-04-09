package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
)

type OrganizationRepository interface {
	datastore.BaseRepository[*models.Organization]
	GetByCode(ctx context.Context, code string) (*models.Organization, error)
	GetByPartitionID(ctx context.Context, partitionID string) (*models.Organization, error)
	GetByTenantID(ctx context.Context, tenantID string, offset, limit int) ([]*models.Organization, error)
}

type organizationRepository struct {
	datastore.BaseRepository[*models.Organization]
}

func NewOrganizationRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) OrganizationRepository {
	return &organizationRepository{
		BaseRepository: datastore.NewBaseRepository[*models.Organization](
			ctx, dbPool, workMan, func() *models.Organization { return &models.Organization{} },
		),
	}
}

func (repo *organizationRepository) GetByCode(ctx context.Context, code string) (*models.Organization, error) {
	organization := models.Organization{}
	err := repo.Pool().DB(ctx, true).First(&organization, "code = ?", code).Error
	if err != nil {
		return nil, err
	}
	return &organization, nil
}

func (repo *organizationRepository) GetByPartitionID(
	ctx context.Context,
	partitionID string,
) (*models.Organization, error) {
	organization := models.Organization{}
	err := repo.Pool().DB(ctx, true).First(&organization, "partition_id = ?", partitionID).Error
	if err != nil {
		return nil, err
	}
	return &organization, nil
}

func (repo *organizationRepository) GetByTenantID(
	ctx context.Context,
	tenantID string,
	offset, limit int,
) ([]*models.Organization, error) {
	var orgs []*models.Organization
	err := repo.Pool().DB(ctx, true).
		Where("tenant_id = ?", tenantID).
		Offset(offset).Limit(limit).
		Find(&orgs).Error
	if err != nil {
		return nil, err
	}
	return orgs, nil
}
