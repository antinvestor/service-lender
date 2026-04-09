package business

import (
	"context"
	"strconv"

	originationv1 "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/origination/service/events"
	"github.com/antinvestor/service-fintech/apps/origination/service/models"
	"github.com/antinvestor/service-fintech/apps/origination/service/repository"
)

type FormSubmissionBusiness interface {
	Save(ctx context.Context, obj *originationv1.FormSubmissionObject) (*originationv1.FormSubmissionObject, error)
	Get(ctx context.Context, id string) (*originationv1.FormSubmissionObject, error)
	Search(
		ctx context.Context,
		req *originationv1.FormSubmissionSearchRequest,
		consumer func(ctx context.Context, batch []*originationv1.FormSubmissionObject) error,
	) error
}

type formSubmissionBusiness struct {
	eventsMan fevents.Manager
	fsRepo    repository.FormSubmissionRepository
}

func NewFormSubmissionBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	fsRepo repository.FormSubmissionRepository,
) FormSubmissionBusiness {
	return &formSubmissionBusiness{
		eventsMan: eventsMan,
		fsRepo:    fsRepo,
	}
}

func (b *formSubmissionBusiness) Save(
	ctx context.Context,
	obj *originationv1.FormSubmissionObject,
) (*originationv1.FormSubmissionObject, error) {
	logger := util.Log(ctx).WithField("method", "FormSubmissionBusiness.Save")

	fs := models.FormSubmissionFromAPI(ctx, obj)

	err := b.eventsMan.Emit(ctx, events.FormSubmissionSaveEvent, fs)
	if err != nil {
		logger.WithError(err).Error("could not emit form submission save event")
		return nil, err
	}

	return fs.ToAPI(), nil
}

func (b *formSubmissionBusiness) Get(ctx context.Context, id string) (*originationv1.FormSubmissionObject, error) {
	fs, err := b.fsRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrFormSubmissionNotFound
	}
	return fs.ToAPI(), nil
}

func (b *formSubmissionBusiness) Search(
	ctx context.Context,
	req *originationv1.FormSubmissionSearchRequest,
	consumer func(ctx context.Context, batch []*originationv1.FormSubmissionObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "FormSubmissionBusiness.Search")

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
	if req.GetTemplateId() != "" {
		andQueryVal["template_id = ?"] = req.GetTemplateId()
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.fsRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search form submissions")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.FormSubmission) error {
		var apiResults []*originationv1.FormSubmissionObject
		for _, fs := range res {
			apiResults = append(apiResults, fs.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}
