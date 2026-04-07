package business

import (
	"context"
	"time"

	originationv1 "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/origination/service/models"
	"github.com/antinvestor/service-lender/apps/origination/service/repository"
)

// BackgroundJobs returns a long-running consumer that periodically runs
// maintenance jobs (expire offers, clean drafts). It blocks until ctx is cancelled.
func BackgroundJobs(
	appRepo repository.ApplicationRepository,
	appBusiness ApplicationBusiness,
	draftExpiryDays int,
) func(ctx context.Context) error {
	expireOffers := ExpireOffersJob(appRepo, appBusiness)
	cleanDrafts := CleanDraftApplicationsJob(appRepo, appBusiness, draftExpiryDays)

	return func(ctx context.Context) error {
		logger := util.Log(ctx).WithField("component", "background-jobs")
		ticker := time.NewTicker(1 * time.Hour)
		defer ticker.Stop()

		// Run once at startup.
		runJobs(ctx, logger, expireOffers, cleanDrafts)

		for {
			select {
			case <-ctx.Done():
				return ctx.Err()
			case <-ticker.C:
				runJobs(ctx, logger, expireOffers, cleanDrafts)
			}
		}
	}
}

func runJobs(ctx context.Context, logger *util.LogEntry, jobs ...func(context.Context) error) {
	for _, job := range jobs {
		if err := job(ctx); err != nil {
			logger.WithError(err).Warn("background job failed")
		}
	}
}

// ExpireOffersJob finds applications with OFFER_GENERATED status whose offer has expired
// and transitions them to EXPIRED. Intended to run periodically (e.g. every hour).
func ExpireOffersJob(
	appRepo repository.ApplicationRepository,
	appBusiness ApplicationBusiness,
) func(ctx context.Context) error {
	return func(ctx context.Context) error {
		logger := util.Log(ctx).WithField("job", "ExpireOffers")

		query := data.NewSearchQuery(
			data.WithSearchFiltersAndByValue(map[string]any{
				"status = ?": int32(originationv1.ApplicationStatus_APPLICATION_STATUS_OFFER_GENERATED),
			}),
		)

		results, err := appRepo.Search(ctx, query)
		if err != nil {
			logger.WithError(err).Warn("could not search for expirable offers")
			return nil
		}

		now := time.Now()
		expired := 0

		consumeErr := workerpoolConsumeStream(ctx, results, func(batch []*models.Application) error {
			expired += expireOfferBatch(ctx, logger, appBusiness, batch, now)
			return nil
		})

		if consumeErr != nil {
			logger.WithError(consumeErr).Warn("error consuming expirable offers stream")
		}
		if expired > 0 {
			logger.WithField("count", expired).Info("expired offers")
		}
		return nil
	}
}

// expireOfferBatch processes a single batch of applications, expiring any whose
// offer has passed its deadline and whose status hasn't changed since the query.
func expireOfferBatch(
	ctx context.Context,
	logger *util.LogEntry,
	appBusiness ApplicationBusiness,
	batch []*models.Application,
	now time.Time,
) int {
	expired := 0
	for _, app := range batch {
		if app.Status != int32(originationv1.ApplicationStatus_APPLICATION_STATUS_OFFER_GENERATED) {
			continue
		}
		if app.OfferExpiresAt == nil || app.OfferExpiresAt.After(now) {
			continue
		}
		transErr := appBusiness.TransitionStatus(
			ctx, app.GetID(),
			originationv1.ApplicationStatus_APPLICATION_STATUS_EXPIRED,
			"offer expired",
		)
		if transErr != nil {
			logger.WithField("application_id", app.GetID()).
				WithError(transErr).
				Warn("could not expire offer")
			continue
		}
		expired++
	}
	return expired
}

// cancelStaleDrafts processes a batch of draft applications, cancelling those
// created before cutoff that are still in DRAFT status.
func cancelStaleDrafts(
	ctx context.Context,
	logger *util.LogEntry,
	appBusiness ApplicationBusiness,
	cutoff time.Time,
	batch []*models.Application,
) int {
	cleaned := 0
	for _, app := range batch {
		if app.Status != int32(originationv1.ApplicationStatus_APPLICATION_STATUS_DRAFT) {
			continue
		}
		if app.CreatedAt.After(cutoff) {
			continue
		}

		transErr := appBusiness.TransitionStatus(
			ctx, app.GetID(),
			originationv1.ApplicationStatus_APPLICATION_STATUS_CANCELLED,
			"draft expired after inactivity",
		)
		if transErr != nil {
			logger.WithField("application_id", app.GetID()).
				WithError(transErr).
				Warn("could not cancel stale draft")
			continue
		}
		cleaned++
	}
	return cleaned
}

// CleanDraftApplicationsJob finds DRAFT applications older than draftExpiryDays
// and cancels them. Intended to run daily.
func CleanDraftApplicationsJob(
	appRepo repository.ApplicationRepository,
	appBusiness ApplicationBusiness,
	draftExpiryDays int,
) func(ctx context.Context) error {
	if draftExpiryDays <= 0 {
		draftExpiryDays = 30
	}

	return func(ctx context.Context) error {
		logger := util.Log(ctx).WithField("job", "CleanDraftApplications")

		query := data.NewSearchQuery(
			data.WithSearchFiltersAndByValue(map[string]any{
				"status = ?": int32(originationv1.ApplicationStatus_APPLICATION_STATUS_DRAFT),
			}),
		)

		results, err := appRepo.Search(ctx, query)
		if err != nil {
			logger.WithError(err).Warn("could not search for stale drafts")
			return nil
		}

		cutoff := time.Now().AddDate(0, 0, -draftExpiryDays)
		cleaned := 0

		consumeErr := workerpoolConsumeStream(ctx, results, func(batch []*models.Application) error {
			cleaned += cancelStaleDrafts(ctx, logger, appBusiness, cutoff, batch)
			return nil
		})

		if consumeErr != nil {
			logger.WithError(consumeErr).Warn("error consuming stale drafts stream")
		}

		if cleaned > 0 {
			logger.WithField("count", cleaned).Info("cleaned stale draft applications")
		}

		return nil
	}
}
