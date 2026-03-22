package business

import (
	"context"

	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/funding/service/repository"
	"github.com/antinvestor/service-lender/pkg/calculation"
)

type loanWindowBusiness struct {
	eventsMan fevents.Manager
	lwRepo    repository.LoanWindowRepository
}

func NewLoanWindowBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	lwRepo repository.LoanWindowRepository,
) LoanWindowBusiness {
	return &loanWindowBusiness{eventsMan: eventsMan, lwRepo: lwRepo}
}

func (b *loanWindowBusiness) Evaluate(ctx context.Context, groupID string) (map[string]interface{}, error) {
	logger := util.Log(ctx).WithField("method", "LoanWindowBusiness.Evaluate")

	// Count existing loan windows for this group to determine completed periods
	completedPeriods, err := b.lwRepo.CountByGroupID(ctx, groupID)
	if err != nil {
		logger.WithError(err).Warn("could not count loan windows, defaulting to 0")
		completedPeriods = 0
	}

	// Default cycle parameters from product config
	// These would typically come from group properties or product configuration
	maturityPeriod := int32(4)
	gracePeriod := int32(1)
	loanTenure := int32(4)
	coolOff := int32(0)

	shouldOpen := calculation.ShouldOpenLoanWindow(completedPeriods, maturityPeriod, gracePeriod, loanTenure, coolOff)
	cycle := calculation.ActiveLoanWindowCycle(completedPeriods, maturityPeriod, gracePeriod, loanTenure, coolOff)

	logger.WithField("group_id", groupID).
		WithField("completed_periods", completedPeriods).
		WithField("should_open", shouldOpen).
		WithField("cycle_position", cycle).
		Info("loan window evaluation completed")

	return map[string]interface{}{
		"group_id":          groupID,
		"should_open":       shouldOpen,
		"cycle_position":    cycle,
		"completed_periods": completedPeriods,
	}, nil
}
