package business

import (
	"context"
	"fmt"
	"strconv"
	"time"

	originationv1 "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/origination/service/events"
	"github.com/antinvestor/service-fintech/apps/origination/service/models"
	"github.com/antinvestor/service-fintech/apps/origination/service/repository"
)

type UnderwritingDecisionBusiness interface {
	Save(
		ctx context.Context,
		obj *originationv1.UnderwritingDecisionObject,
	) (*originationv1.UnderwritingDecisionObject, error)
	Get(ctx context.Context, id string) (*originationv1.UnderwritingDecisionObject, error)
	Search(
		ctx context.Context,
		req *originationv1.UnderwritingDecisionSearchRequest,
		consumer func(ctx context.Context, batch []*originationv1.UnderwritingDecisionObject) error,
	) error
}

type underwritingDecisionBusiness struct {
	eventsMan   fevents.Manager
	udRepo      repository.UnderwritingDecisionRepository
	appRepo     repository.ApplicationRepository
	appBusiness ApplicationBusiness
	offerExpiry int // days until offer expires
}

func NewUnderwritingDecisionBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	udRepo repository.UnderwritingDecisionRepository,
	appRepo repository.ApplicationRepository,
	appBusiness ApplicationBusiness,
	offerExpiryDays int,
) UnderwritingDecisionBusiness {
	if offerExpiryDays <= 0 {
		offerExpiryDays = 7
	}
	return &underwritingDecisionBusiness{
		eventsMan:   eventsMan,
		udRepo:      udRepo,
		appRepo:     appRepo,
		appBusiness: appBusiness,
		offerExpiry: offerExpiryDays,
	}
}

func (b *underwritingDecisionBusiness) Save(
	ctx context.Context,
	obj *originationv1.UnderwritingDecisionObject,
) (*originationv1.UnderwritingDecisionObject, error) {
	logger := util.Log(ctx).WithField("method", "UnderwritingDecisionBusiness.Save")

	ud := models.UnderwritingDecisionFromAPI(ctx, obj)

	err := b.eventsMan.Emit(ctx, events.UnderwritingDecisionSaveEvent, ud)
	if err != nil {
		logger.WithError(err).Error("could not emit underwriting decision save event")
		return nil, err
	}

	// Drive application status based on the underwriting outcome
	if err = b.applyDecisionToApplication(ctx, logger, ud); err != nil {
		logger.WithError(err).Error("could not apply underwriting decision to application")
		return nil, err
	}

	return ud.ToAPI(), nil
}

func (b *underwritingDecisionBusiness) Get(
	ctx context.Context,
	id string,
) (*originationv1.UnderwritingDecisionObject, error) {
	ud, err := b.udRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrUnderwritingDecisionNotFound
	}
	return ud.ToAPI(), nil
}

func (b *underwritingDecisionBusiness) Search(
	ctx context.Context,
	req *originationv1.UnderwritingDecisionSearchRequest,
	consumer func(ctx context.Context, batch []*originationv1.UnderwritingDecisionObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "UnderwritingDecisionBusiness.Search")

	var searchOpts []data.SearchOption

	cursor := req.GetCursor()
	if cursor != nil {
		offset, offsetErr := strconv.Atoi(cursor.GetPage())
		if offsetErr != nil {
			offset = 0
		}
		searchOpts = append(searchOpts, data.WithSearchOffset(offset), data.WithSearchLimit(int(cursor.GetLimit())))
	}

	andQueryVal := map[string]any{}
	if req.GetApplicationId() != "" {
		andQueryVal["application_id = ?"] = req.GetApplicationId()
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.udRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search underwriting decisions")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.UnderwritingDecision) error {
		var apiResults []*originationv1.UnderwritingDecisionObject
		for _, ud := range res {
			apiResults = append(apiResults, ud.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

// applyDecisionToApplication advances the application based on the underwriting outcome.
func (b *underwritingDecisionBusiness) applyDecisionToApplication(
	ctx context.Context,
	logger *util.LogEntry,
	ud *models.UnderwritingDecision,
) error {
	if b.appBusiness == nil || ud.ApplicationID == "" {
		return nil
	}

	outcome := originationv1.UnderwritingOutcome(ud.Outcome)

	switch outcome { //nolint:exhaustive // unspecified outcome is a no-op
	case originationv1.UnderwritingOutcome_UNDERWRITING_OUTCOME_APPROVE,
		originationv1.UnderwritingOutcome_UNDERWRITING_OUTCOME_COUNTER_OFFER:

		// UNDERWRITING → APPROVED
		if transErr := b.appBusiness.TransitionStatus(
			ctx, ud.ApplicationID,
			originationv1.ApplicationStatus_APPLICATION_STATUS_APPROVED,
			"underwriting approved",
		); transErr != nil {
			return fmt.Errorf("could not transition application to APPROVED: %w", transErr)
		}

		// Update application with approved terms from decision.
		// Re-fetch to get the APPROVED status written by TransitionStatus above.
		app, getErr := b.appRepo.GetByID(ctx, ud.ApplicationID)
		if getErr != nil {
			return fmt.Errorf("could not fetch application after approval: %w", getErr)
		}
		{
			app.ApprovedAmount = ud.ApprovedAmount
			app.ApprovedTermDays = ud.ApprovedTermDays
			app.InterestRate = ud.ApprovedRate
			now := time.Now()
			app.DecidedAt = &now
			offerExpiry := now.AddDate(0, 0, b.offerExpiry)
			app.OfferExpiresAt = &offerExpiry
			// Preserve the APPROVED status — do not overwrite it
			app.Status = int32(originationv1.ApplicationStatus_APPLICATION_STATUS_APPROVED)

			if emitErr := b.eventsMan.Emit(ctx, events.ApplicationSaveEvent, app); emitErr != nil {
				return fmt.Errorf("could not save approved terms on application: %w", emitErr)
			}
		}

		// APPROVED → OFFER_GENERATED
		if transErr := b.appBusiness.TransitionStatus(
			ctx, ud.ApplicationID,
			originationv1.ApplicationStatus_APPLICATION_STATUS_OFFER_GENERATED,
			"offer generated from underwriting approval",
		); transErr != nil {
			return fmt.Errorf("could not transition application to OFFER_GENERATED: %w", transErr)
		}

	case originationv1.UnderwritingOutcome_UNDERWRITING_OUTCOME_REJECT:
		if transErr := b.appBusiness.TransitionStatus(
			ctx, ud.ApplicationID,
			originationv1.ApplicationStatus_APPLICATION_STATUS_REJECTED,
			ud.Reason,
		); transErr != nil {
			return fmt.Errorf("could not transition application to REJECTED: %w", transErr)
		}

	case originationv1.UnderwritingOutcome_UNDERWRITING_OUTCOME_REFER:
		// Refer means manual review needed — no automatic transition
		logger.WithField("application_id", ud.ApplicationID).
			Info("underwriting decision is REFER, awaiting manual review")
	}

	return nil
}
