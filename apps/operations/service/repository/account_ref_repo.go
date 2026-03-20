package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/operations/service/models"
)

// AccountRefRepository provides data access for account references.
type AccountRefRepository interface {
	datastore.BaseRepository[*models.AccountRef]
	GetByOwnerAndName(ctx context.Context, ownerID, ownerType, name string) (*models.AccountRef, error)
}

// NewAccountRefRepository creates a new AccountRefRepository.
func NewAccountRefRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) AccountRefRepository {
	return &accountRefRepository{
		BaseRepository: datastore.NewBaseRepository(ctx, dbPool, workMan, func() *models.AccountRef {
			return &models.AccountRef{}
		}),
	}
}

type accountRefRepository struct {
	datastore.BaseRepository[*models.AccountRef]
}

func (r *accountRefRepository) GetByOwnerAndName(
	ctx context.Context,
	ownerID, ownerType, name string,
) (*models.AccountRef, error) {
	ar := models.AccountRef{}
	err := r.Pool().
		DB(ctx, true).
		First(&ar, "owner_id = ? AND owner_type = ? AND name = ?", ownerID, ownerType, name).
		Error
	if err != nil {
		return nil, err
	}
	return &ar, nil
}
