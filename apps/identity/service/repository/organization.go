package repository //nolint:dupl // similar repository patterns for different entity types

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
