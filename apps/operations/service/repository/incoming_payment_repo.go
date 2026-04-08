package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/operations/service/models"
)

// IncomingPaymentRepository provides data access for incoming payments.
type IncomingPaymentRepository interface {
	datastore.BaseRepository[*models.IncomingPayment]
	GetByTransactionID(ctx context.Context, transactionID string) (*models.IncomingPayment, error)
}

// NewIncomingPaymentRepository creates a new IncomingPaymentRepository.
func NewIncomingPaymentRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) IncomingPaymentRepository {
	return &incomingPaymentRepository{
		BaseRepository: datastore.NewBaseRepository(ctx, dbPool, workMan, func() *models.IncomingPayment {
			return &models.IncomingPayment{}
		}),
	}
}

type incomingPaymentRepository struct {
	datastore.BaseRepository[*models.IncomingPayment]
}

func (r *incomingPaymentRepository) GetByTransactionID(
	ctx context.Context,
	transactionID string,
) (*models.IncomingPayment, error) {
	ip := models.IncomingPayment{}
	err := r.Pool().DB(ctx, true).First(&ip, "transaction_id = ?", transactionID).Error
	if err != nil {
		return nil, err
	}
	return &ip, nil
}
