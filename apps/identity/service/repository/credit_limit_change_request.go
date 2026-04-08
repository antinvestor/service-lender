package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
)

type CreditLimitChangeRequestRepository interface {
	datastore.BaseRepository[*models.CreditLimitChangeRequest]
	GetPendingByClientID(ctx context.Context, clientID string) ([]*models.CreditLimitChangeRequest, error)
}

type creditLimitChangeRequestRepository struct {
	datastore.BaseRepository[*models.CreditLimitChangeRequest]
}

func NewCreditLimitChangeRequestRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) CreditLimitChangeRequestRepository {
	return &creditLimitChangeRequestRepository{
		BaseRepository: datastore.NewBaseRepository[*models.CreditLimitChangeRequest](
			ctx, dbPool, workMan, func() *models.CreditLimitChangeRequest { return &models.CreditLimitChangeRequest{} },
		),
	}
}

func (r *creditLimitChangeRequestRepository) GetPendingByClientID(
	ctx context.Context,
	clientID string,
) ([]*models.CreditLimitChangeRequest, error) {
	var requests []*models.CreditLimitChangeRequest
	err := r.Pool().DB(ctx, true).
		Where("client_id = ? AND status = ?", clientID, 1). // 1 = pending
		Order("created_at DESC").
		Find(&requests).Error
	return requests, err
}
