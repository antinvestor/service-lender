package business

import (
	"context"
	"fmt"
	"time"

	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	identityrepo "github.com/antinvestor/service-fintech/apps/identity/service/repository"
	"github.com/antinvestor/service-fintech/apps/stawi/service/events"
	"github.com/antinvestor/service-fintech/apps/stawi/service/models"
	"github.com/antinvestor/service-fintech/apps/stawi/service/repository"
	"github.com/antinvestor/service-fintech/pkg/constants"
)

const (
	// defaultTenureDuration is the default number of periods in a tenure.
	defaultTenureDuration = int32(52)
	// tenureDaysPerWeek is the number of days in a weekly period.
	tenureDaysPerWeek = 7
	// tenureDaysPerBiweek is the number of days in a biweekly period.
	tenureDaysPerBiweek = 14
)

type tenureBusiness struct {
	eventsMan fevents.Manager
	grpRepo   identityrepo.GroupRepository
	tenRepo   repository.TenureRepository
	perRepo   repository.PeriodRepository
}

func NewTenureBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	grpRepo identityrepo.GroupRepository,
	tenRepo repository.TenureRepository,
	perRepo repository.PeriodRepository,
) TenureBusiness {
	return &tenureBusiness{eventsMan: eventsMan, grpRepo: grpRepo, tenRepo: tenRepo, perRepo: perRepo}
}

// Open creates a new tenure for the given group.
// It determines the next position by looking up the latest tenure,
// computes duration from group properties (default 52), and calculates
// the end date based on period type and duration.
func (b *tenureBusiness) Open(ctx context.Context, groupID string) (*models.Tenure, error) {
	logger := util.Log(ctx).WithField("method", "TenureBusiness.Open").
		WithField("group_id", groupID)

	// Get the group to read properties
	group, err := b.grpRepo.GetByID(ctx, groupID)
	if err != nil {
		return nil, fmt.Errorf("group not found: %w", err)
	}

	// Ensure no active tenure already exists
	existing, err := b.tenRepo.GetActiveByGroupID(ctx, groupID)
	if err == nil && existing != nil && existing.State == int32(constants.StateActive) {
		return nil, fmt.Errorf("group already has an active tenure (id=%s)", existing.GetID())
	}

	// Determine next position from latest tenure
	var nextPosition int32 = 1
	latestTenure, err := b.tenRepo.GetLastestBy(ctx, map[string]any{"group_id": groupID})
	if err == nil && latestTenure != nil {
		nextPosition = latestTenure.Position + 1
	}

	// Duration defaults to 52 periods, overridable from group properties
	duration := defaultTenureDuration
	if group.Properties != nil {
		if v, hasDuration := group.Properties["tenure_duration"]; hasDuration {
			if d, isFloat := v.(float64); isFloat && d > 0 {
				duration = int32(d)
			}
		}
	}

	// Determine period type for end date calculation (default WEEKLY)
	periodType := models.PeriodTypeWeekly
	if group.Properties != nil {
		if v, hasPeriodType := group.Properties["period_type"]; hasPeriodType {
			if pt, isFloat := v.(float64); isFloat && pt > 0 {
				periodType = models.PeriodType(int32(pt))
			}
		}
	}

	// Calculate start and end dates
	now := time.Now().UTC()
	endDate := calculateTenureEndDate(now, periodType, duration)

	tenure := &models.Tenure{
		GroupID:   groupID,
		StartDate: &now,
		EndDate:   &endDate,
		Duration:  duration,
		Position:  nextPosition,
		Welcomed:  false,
		State:     int32(constants.StateActive),
	}
	tenure.GenID(ctx)
	tenure.CopyPartitionInfo(&group.BaseModel)

	err = b.eventsMan.Emit(ctx, events.TenureSaveEvent, tenure)
	if err != nil {
		logger.WithError(err).Error("could not emit tenure save event")
		return nil, err
	}

	logger.WithField("tenure_id", tenure.GetID()).
		WithField("position", nextPosition).
		WithField("duration", duration).
		Info("new tenure opened")

	return tenure, nil
}

// Close marks a tenure as shutdown. It also closes any active period
// within the tenure.
func (b *tenureBusiness) Close(ctx context.Context, tenureID string) error {
	logger := util.Log(ctx).WithField("method", "TenureBusiness.Close").
		WithField("tenure_id", tenureID)

	tenure, err := b.tenRepo.GetByID(ctx, tenureID)
	if err != nil {
		return fmt.Errorf("tenure not found: %w", err)
	}

	if tenure.State == int32(constants.StateShutdown) || tenure.State == int32(constants.StateDeleted) {
		return fmt.Errorf("tenure is already closed (state=%d)", tenure.State)
	}

	// Close any active period in this tenure
	currentPeriod, perErr := b.perRepo.GetCurrentByGroupID(ctx, tenure.GroupID)
	if perErr == nil && currentPeriod != nil && currentPeriod.TenureID == tenureID {
		if currentPeriod.State == int32(constants.StateActive) {
			now := time.Now().UTC()
			currentPeriod.EndDate = &now
			currentPeriod.State = int32(constants.StateShutdown)
			if emitErr := b.eventsMan.Emit(ctx, events.PeriodSaveEvent, currentPeriod); emitErr != nil {
				logger.WithError(emitErr).Warn("could not close active period during tenure close")
			}
		}
	}

	now := time.Now().UTC()
	tenure.EndDate = &now
	tenure.State = int32(constants.StateShutdown)

	err = b.eventsMan.Emit(ctx, events.TenureSaveEvent, tenure)
	if err != nil {
		logger.WithError(err).Error("could not emit tenure save event")
		return err
	}

	logger.Info("tenure closed")
	return nil
}

func (b *tenureBusiness) GetActive(ctx context.Context, groupID string) (*models.Tenure, error) {
	return b.tenRepo.GetActiveByGroupID(ctx, groupID)
}

// calculateTenureEndDate computes the end date for a tenure based on
// the period type and number of periods (duration).
func calculateTenureEndDate(start time.Time, periodType models.PeriodType, duration int32) time.Time {
	switch periodType {
	case models.PeriodTypeBiweekly:
		return start.AddDate(0, 0, int(duration)*tenureDaysPerBiweek)
	case models.PeriodTypeMonthly:
		return start.AddDate(0, int(duration), 0)
	case models.PeriodTypeUnspecified, models.PeriodTypeWeekly:
		return start.AddDate(0, 0, int(duration)*tenureDaysPerWeek)
	default:
		return start.AddDate(0, 0, int(duration)*tenureDaysPerWeek)
	}
}
