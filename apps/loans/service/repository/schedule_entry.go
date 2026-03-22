package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/loans/service/models"
)

type ScheduleEntryRepository interface {
	datastore.BaseRepository[*models.ScheduleEntry]
	GetByScheduleID(ctx context.Context, scheduleID string) ([]*models.ScheduleEntry, error)
	GetByLoanAccountID(ctx context.Context, loanAccountID string) ([]*models.ScheduleEntry, error)
}

type scheduleEntryRepository struct {
	datastore.BaseRepository[*models.ScheduleEntry]
}

func NewScheduleEntryRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) ScheduleEntryRepository {
	return &scheduleEntryRepository{
		BaseRepository: datastore.NewBaseRepository[*models.ScheduleEntry](
			ctx, dbPool, workMan, func() *models.ScheduleEntry { return &models.ScheduleEntry{} },
		),
	}
}

func (repo *scheduleEntryRepository) GetByScheduleID(
	ctx context.Context,
	scheduleID string,
) ([]*models.ScheduleEntry, error) {
	var entries []*models.ScheduleEntry
	err := repo.Pool().DB(ctx, true).
		Where("schedule_id = ?", scheduleID).
		Order("installment_number ASC").
		Find(&entries).Error
	if err != nil {
		return nil, err
	}
	return entries, nil
}

func (repo *scheduleEntryRepository) GetByLoanAccountID(
	ctx context.Context,
	loanAccountID string,
) ([]*models.ScheduleEntry, error) {
	var entries []*models.ScheduleEntry
	err := repo.Pool().DB(ctx, true).
		Where("loan_account_id = ?", loanAccountID).
		Order("installment_number ASC").
		Find(&entries).Error
	if err != nil {
		return nil, err
	}
	return entries, nil
}
