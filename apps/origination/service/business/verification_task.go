package business

import (
	"context"
	"strconv"
	"time"

	originationv1 "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/origination/service/events"
	"github.com/antinvestor/service-lender/apps/origination/service/models"
	"github.com/antinvestor/service-lender/apps/origination/service/repository"
)

type VerificationTaskBusiness interface {
	Save(ctx context.Context, obj *originationv1.VerificationTaskObject) (*originationv1.VerificationTaskObject, error)
	Get(ctx context.Context, id string) (*originationv1.VerificationTaskObject, error)
	Search(
		ctx context.Context,
		req *originationv1.VerificationTaskSearchRequest,
		consumer func(ctx context.Context, batch []*originationv1.VerificationTaskObject) error,
	) error
	Complete(ctx context.Context, req *originationv1.VerificationTaskCompleteRequest) (*originationv1.VerificationTaskObject, error)
}

type verificationTaskBusiness struct {
	eventsMan   fevents.Manager
	vtRepo      repository.VerificationTaskRepository
	appBusiness ApplicationBusiness
}

func NewVerificationTaskBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	vtRepo repository.VerificationTaskRepository,
	appBusiness ApplicationBusiness,
) VerificationTaskBusiness {
	return &verificationTaskBusiness{
		eventsMan:   eventsMan,
		vtRepo:      vtRepo,
		appBusiness: appBusiness,
	}
}

func (b *verificationTaskBusiness) Save(ctx context.Context, obj *originationv1.VerificationTaskObject) (*originationv1.VerificationTaskObject, error) {
	logger := util.Log(ctx).WithField("method", "VerificationTaskBusiness.Save")

	isNew := obj.GetId() == ""
	vt := models.VerificationTaskFromAPI(ctx, obj)

	if isNew && vt.Status == 0 {
		vt.Status = int32(originationv1.VerificationStatus_VERIFICATION_STATUS_PENDING)
	}

	err := b.eventsMan.Emit(ctx, events.VerificationTaskSaveEvent, vt)
	if err != nil {
		logger.WithError(err).Error("could not emit verification task save event")
		return nil, err
	}

	return vt.ToAPI(), nil
}

func (b *verificationTaskBusiness) Get(ctx context.Context, id string) (*originationv1.VerificationTaskObject, error) {
	vt, err := b.vtRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrVerificationTaskNotFound
	}
	return vt.ToAPI(), nil
}

//nolint:dupl // similar search logic for different entity types
func (b *verificationTaskBusiness) Search(
	ctx context.Context,
	req *originationv1.VerificationTaskSearchRequest,
	consumer func(ctx context.Context, batch []*originationv1.VerificationTaskObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "VerificationTaskBusiness.Search")

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
	if req.GetAssignedTo() != "" {
		andQueryVal["assigned_to = ?"] = req.GetAssignedTo()
	}
	if req.GetStatus() != originationv1.VerificationStatus_VERIFICATION_STATUS_UNSPECIFIED {
		andQueryVal["status = ?"] = int32(req.GetStatus())
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.vtRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search verification tasks")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.VerificationTask) error {
		var apiResults []*originationv1.VerificationTaskObject
		for _, vt := range res {
			apiResults = append(apiResults, vt.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

func (b *verificationTaskBusiness) Complete(
	ctx context.Context,
	req *originationv1.VerificationTaskCompleteRequest,
) (*originationv1.VerificationTaskObject, error) {
	logger := util.Log(ctx).WithField("method", "VerificationTaskBusiness.Complete")

	vt, err := b.vtRepo.GetByID(ctx, req.GetId())
	if err != nil {
		return nil, ErrVerificationTaskNotFound
	}

	vt.Status = int32(req.GetStatus())
	vt.Notes = req.GetNotes()
	if req.GetResults() != nil {
		vt.Results = (&data.JSONMap{}).FromProtoStruct(req.GetResults())
	}
	now := time.Now()
	vt.CompletedAt = &now

	err = b.eventsMan.Emit(ctx, events.VerificationTaskSaveEvent, vt)
	if err != nil {
		logger.WithError(err).Error("could not emit verification task save event")
		return nil, err
	}

	// Check if all verification tasks for this application are now complete.
	// If so, advance the application to UNDERWRITING.
	b.checkAndAdvanceApplication(ctx, logger, vt.ApplicationID)

	return vt.ToAPI(), nil
}

// checkAndAdvanceApplication checks whether all verification tasks for the application
// have passed. If so, transitions the application from VERIFICATION → UNDERWRITING.
func (b *verificationTaskBusiness) checkAndAdvanceApplication(
	ctx context.Context,
	logger *util.LogEntry,
	applicationID string,
) {
	if b.appBusiness == nil || applicationID == "" {
		return
	}

	// Find all tasks for this application
	query := data.NewSearchQuery(
		data.WithSearchFiltersAndByValue(map[string]any{"application_id = ?": applicationID}),
	)
	results, err := b.vtRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Warn("could not search verification tasks for application")
		return
	}

	allPassed := true
	hasAny := false
	err = workerpoolConsumeStream(ctx, results, func(batch []*models.VerificationTask) error {
		for _, task := range batch {
			hasAny = true
			if task.Status != int32(originationv1.VerificationStatus_VERIFICATION_STATUS_PASSED) {
				allPassed = false
			}
		}
		return nil
	})
	if err != nil {
		logger.WithError(err).Warn("error consuming verification tasks stream")
		return
	}

	if !hasAny || !allPassed {
		return
	}

	logger.WithField("application_id", applicationID).
		Info("all verification tasks passed, advancing to UNDERWRITING")

	if transErr := b.appBusiness.TransitionStatus(
		ctx, applicationID,
		originationv1.ApplicationStatus_APPLICATION_STATUS_UNDERWRITING,
		"all verification tasks passed",
	); transErr != nil {
		logger.WithError(transErr).Warn("could not advance application to UNDERWRITING")
	}
}
