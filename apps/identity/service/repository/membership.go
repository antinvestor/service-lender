package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
)

type MembershipRepository interface {
	datastore.BaseRepository[*models.Membership]
	GetByGroupID(ctx context.Context, groupID string, offset, limit int) ([]*models.Membership, error)
	GetByProfileID(ctx context.Context, profileID string, offset, limit int) ([]*models.Membership, error)
}

type membershipRepository struct {
	datastore.BaseRepository[*models.Membership]
}

func NewMembershipRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) MembershipRepository {
	return &membershipRepository{
		BaseRepository: datastore.NewBaseRepository[*models.Membership](
			ctx, dbPool, workMan, func() *models.Membership { return &models.Membership{} },
		),
	}
}

func (repo *membershipRepository) GetByGroupID(
	ctx context.Context,
	groupID string,
	offset, limit int,
) ([]*models.Membership, error) {
	var memberships []*models.Membership
	err := repo.Pool().DB(ctx, true).
		Where("group_id = ?", groupID).
		Offset(offset).Limit(limit).
		Find(&memberships).Error
	if err != nil {
		return nil, err
	}
	return memberships, nil
}

func (repo *membershipRepository) GetByProfileID(
	ctx context.Context,
	profileID string,
	offset, limit int,
) ([]*models.Membership, error) {
	var memberships []*models.Membership
	err := repo.Pool().DB(ctx, true).
		Where("profile_id = ?", profileID).
		Offset(offset).Limit(limit).
		Find(&memberships).Error
	if err != nil {
		return nil, err
	}
	return memberships, nil
}
