package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/group/service/models"
	"github.com/antinvestor/service-lender/pkg/constants"
)

// MembershipRepository provides data access for memberships.
type MembershipRepository interface {
	datastore.BaseRepository[*models.Membership]
	GetByGroupID(ctx context.Context, groupID string) ([]*models.Membership, error)
	GetByProfileID(ctx context.Context, profileID string) ([]*models.Membership, error)
}

// NewMembershipRepository creates a new MembershipRepository.
func NewMembershipRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) MembershipRepository {
	return &membershipRepository{
		BaseRepository: datastore.NewBaseRepository(ctx, dbPool, workMan, func() *models.Membership {
			return &models.Membership{}
		}),
	}
}

type membershipRepository struct {
	datastore.BaseRepository[*models.Membership]
}

func (r *membershipRepository) GetByGroupID(ctx context.Context, groupID string) ([]*models.Membership, error) {
	var memberships []*models.Membership
	err := r.Pool().
		DB(ctx, true).
		Where("group_id = ? AND state != ?", groupID, constants.StateDeleted).
		Find(&memberships).
		Error
	return memberships, err
}

func (r *membershipRepository) GetByProfileID(ctx context.Context, profileID string) ([]*models.Membership, error) {
	var memberships []*models.Membership
	err := r.Pool().
		DB(ctx, true).
		Where("profile_id = ? AND state != ?", profileID, constants.StateDeleted).
		Find(&memberships).
		Error
	return memberships, err
}
