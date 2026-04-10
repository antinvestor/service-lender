package business

import (
	"context"

	originationv1 "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/origination/service/events"
	"github.com/antinvestor/service-fintech/apps/origination/service/models"
	"github.com/antinvestor/service-fintech/apps/origination/service/repository"
)

type FormTemplateBusiness interface {
	Save(ctx context.Context, obj *originationv1.FormTemplateObject) (*originationv1.FormTemplateObject, error)
	Get(ctx context.Context, id string) (*originationv1.FormTemplateObject, error)
	Search(
		ctx context.Context,
		req *originationv1.FormTemplateSearchRequest,
		consumer func(ctx context.Context, batch []*originationv1.FormTemplateObject) error,
	) error
	Publish(ctx context.Context, id string) (*originationv1.FormTemplateObject, error)
}

type formTemplateBusiness struct {
	eventsMan fevents.Manager
	ftRepo    repository.FormTemplateRepository
}

func NewFormTemplateBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	ftRepo repository.FormTemplateRepository,
) FormTemplateBusiness {
	return &formTemplateBusiness{
		eventsMan: eventsMan,
		ftRepo:    ftRepo,
	}
}

func (b *formTemplateBusiness) Save(
	ctx context.Context,
	obj *originationv1.FormTemplateObject,
) (*originationv1.FormTemplateObject, error) {
	logger := util.Log(ctx).WithField("method", "FormTemplateBusiness.Save")

	isNew := obj.GetId() == ""
	ft := models.FormTemplateFromAPI(ctx, obj)

	if isNew {
		if ft.Status == 0 {
			ft.Status = int32(originationv1.FormTemplateStatus_FORM_TEMPLATE_STATUS_DRAFT)
		}
		if ft.Version == 0 {
			ft.Version = 1
		}
	}

	err := b.eventsMan.Emit(ctx, events.FormTemplateSaveEvent, ft)
	if err != nil {
		logger.WithError(err).Error("could not emit form template save event")
		return nil, err
	}

	return ft.ToAPI(), nil
}

func (b *formTemplateBusiness) Get(ctx context.Context, id string) (*originationv1.FormTemplateObject, error) {
	ft, err := b.ftRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrFormTemplateNotFound
	}
	return ft.ToAPI(), nil
}

func (b *formTemplateBusiness) Search(
	ctx context.Context,
	req *originationv1.FormTemplateSearchRequest,
	consumer func(ctx context.Context, batch []*originationv1.FormTemplateObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "FormTemplateBusiness.Search")

	andQueryVal := map[string]any{}
	if req.GetOrganizationId() != "" {
		andQueryVal["organization_id = ?"] = req.GetOrganizationId()
	}
	if req.GetStatus() != originationv1.FormTemplateStatus_FORM_TEMPLATE_STATUS_UNSPECIFIED {
		andQueryVal["status = ?"] = int32(req.GetStatus())
	}

	return executeSearch(
		ctx,
		logger,
		b.ftRepo.Search,
		req.GetCursor(),
		andQueryVal,
		req.GetQuery(),
		"failed to search form templates",
		func(ft *models.FormTemplate) *originationv1.FormTemplateObject {
			return ft.ToAPI()
		},
		consumer,
	)
}

func (b *formTemplateBusiness) Publish(ctx context.Context, id string) (*originationv1.FormTemplateObject, error) {
	logger := util.Log(ctx).WithField("method", "FormTemplateBusiness.Publish")

	ft, err := b.ftRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrFormTemplateNotFound
	}

	if ft.Status != int32(originationv1.FormTemplateStatus_FORM_TEMPLATE_STATUS_DRAFT) {
		return nil, ErrFormTemplateNotDraft
	}

	ft.Status = int32(originationv1.FormTemplateStatus_FORM_TEMPLATE_STATUS_PUBLISHED)
	ft.Version++

	err = b.eventsMan.Emit(ctx, events.FormTemplateSaveEvent, ft)
	if err != nil {
		logger.WithError(err).Error("could not emit form template save event")
		return nil, err
	}

	return ft.ToAPI(), nil
}
