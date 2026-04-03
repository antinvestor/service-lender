package business

import (
	"context"
	"fmt"
	"time"

	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/group/service/events"
	"github.com/antinvestor/service-lender/apps/group/service/models"
	"github.com/antinvestor/service-lender/apps/group/service/repository"
	"github.com/antinvestor/service-lender/pkg/constants"
)

type periodBusiness struct {
	eventsMan fevents.Manager
	tenRepo   repository.TenureRepository
	perRepo   repository.PeriodRepository
}

func NewPeriodBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	tenRepo repository.TenureRepository,
	perRepo repository.PeriodRepository,
) PeriodBusiness {
	return &periodBusiness{eventsMan: eventsMan, tenRepo: tenRepo, perRepo: perRepo}
}

// Open creates a new period within the active tenure for the given group.
// It determines the next position from the latest period, and calculates
// start/end dates based on the period type (WEEKLY=7d, BIWEEKLY=14d, MONTHLY=1mo).
// The first period starts at the tenure start date; subsequent periods start
// where the previous period ended.
func (b *periodBusiness) Open(ctx context.Context, groupID string) (*models.Period, error) {
	logger := util.Log(ctx).WithField("method", "PeriodBusiness.Open").
		WithField("group_id", groupID)

	// Get the active tenure
	tenure, err := b.tenRepo.GetActiveByGroupID(ctx, groupID)
	if err != nil {
		return nil, fmt.Errorf("no active tenure for group: %w", err)
	}

	if tenure.State != int32(constants.StateActive) {
		return nil, fmt.Errorf("tenure is not active (state=%d)", tenure.State)
	}

	// Determine period type from tenure properties or default from period_type field
	periodType := models.PeriodTypeWeekly
	if tenure.Properties != nil {
		if v, ok := tenure.Properties["period_type"]; ok {
			if pt, ok := v.(float64); ok && pt > 0 {
				periodType = models.PeriodType(int32(pt))
			}
		}
	}

	// Determine next position and start date from latest period in this tenure
	var nextPosition int32 = 1
	var startDate time.Time
	var parentPeriodID string

	latestPeriod, err := b.perRepo.GetLastestBy(ctx, map[string]any{
		"tenure_id": tenure.GetID(),
	})
	if err == nil && latestPeriod != nil && latestPeriod.GetID() != "" {
		// Ensure previous period is closed before opening a new one
		if latestPeriod.State == int32(constants.StateActive) {
			return nil, fmt.Errorf("previous period (id=%s) is still active, close it first", latestPeriod.GetID())
		}
		nextPosition = latestPeriod.Position + 1
		parentPeriodID = latestPeriod.GetID()

		// Start where the previous period ended
		if latestPeriod.EndDate != nil {
			startDate = *latestPeriod.EndDate
		} else {
			startDate = time.Now().UTC()
		}
	} else {
		// First period: start at tenure start date
		if tenure.StartDate != nil {
			startDate = *tenure.StartDate
		} else {
			startDate = time.Now().UTC()
		}
	}

	// Check that we haven't exceeded the tenure duration
	if nextPosition > tenure.Duration {
		return nil, fmt.Errorf(
			"tenure duration of %d periods exhausted, close tenure and open a new one",
			tenure.Duration,
		)
	}

	// Calculate end date based on period type
	endDate := calculatePeriodEndDate(startDate, periodType)

	period := &models.Period{
		GroupID:        groupID,
		TenureID:       tenure.GetID(),
		StartDate:      &startDate,
		EndDate:        &endDate,
		PeriodType:     int32(periodType),
		Position:       nextPosition,
		ParentPeriodID: parentPeriodID,
		State:          int32(constants.StateActive),
	}
	period.GenID(ctx)
	period.CopyPartitionInfo(&tenure.BaseModel)

	err = b.eventsMan.Emit(ctx, events.PeriodSaveEvent, period)
	if err != nil {
		logger.WithError(err).Error("could not emit period save event")
		return nil, err
	}

	logger.WithField("period_id", period.GetID()).
		WithField("position", nextPosition).
		WithField("start_date", startDate.Format(time.RFC3339)).
		WithField("end_date", endDate.Format(time.RFC3339)).
		Info("new period opened")

	return period, nil
}

// Close marks a period as shutdown, setting its end date to now if it
// extends beyond the current time.
func (b *periodBusiness) Close(ctx context.Context, periodID string) error {
	logger := util.Log(ctx).WithField("method", "PeriodBusiness.Close").
		WithField("period_id", periodID)

	period, err := b.perRepo.GetByID(ctx, periodID)
	if err != nil {
		return fmt.Errorf("period not found: %w", err)
	}

	if period.State == int32(constants.StateShutdown) || period.State == int32(constants.StateDeleted) {
		return fmt.Errorf("period is already closed (state=%d)", period.State)
	}

	now := time.Now().UTC()
	period.EndDate = &now
	period.State = int32(constants.StateShutdown)

	err = b.eventsMan.Emit(ctx, events.PeriodSaveEvent, period)
	if err != nil {
		logger.WithError(err).Error("could not emit period save event")
		return err
	}

	logger.Info("period closed")
	return nil
}

func (b *periodBusiness) GetCurrent(ctx context.Context, groupID string) (*models.Period, error) {
	return b.perRepo.GetCurrentByGroupID(ctx, groupID)
}

// calculatePeriodEndDate computes the end date for a single period.
func calculatePeriodEndDate(start time.Time, periodType models.PeriodType) time.Time {
	switch periodType {
	case models.PeriodTypeBiweekly:
		return start.AddDate(0, 0, 14)
	case models.PeriodTypeMonthly:
		return start.AddDate(0, 1, 0)
	case models.PeriodTypeUnspecified, models.PeriodTypeWeekly:
		return start.AddDate(0, 0, 7)
	default:
		return start.AddDate(0, 0, 7)
	}
}
