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

type ApplicationDocumentBusiness interface {
	Save(
		ctx context.Context,
		obj *originationv1.ApplicationDocumentObject,
	) (*originationv1.ApplicationDocumentObject, error)
	Get(ctx context.Context, id string) (*originationv1.ApplicationDocumentObject, error)
	Search(
		ctx context.Context,
		req *originationv1.ApplicationDocumentSearchRequest,
		consumer func(ctx context.Context, batch []*originationv1.ApplicationDocumentObject) error,
	) error
}

type applicationDocumentBusiness struct {
	eventsMan fevents.Manager
	docRepo   repository.ApplicationDocumentRepository
}

func NewApplicationDocumentBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	docRepo repository.ApplicationDocumentRepository,
) ApplicationDocumentBusiness {
	return &applicationDocumentBusiness{
		eventsMan: eventsMan,
		docRepo:   docRepo,
	}
}

func (b *applicationDocumentBusiness) Save(
	ctx context.Context,
	obj *originationv1.ApplicationDocumentObject,
) (*originationv1.ApplicationDocumentObject, error) {
	logger := util.Log(ctx).WithField("method", "ApplicationDocumentBusiness.Save")

	isNew := obj.GetId() == ""
	doc := models.ApplicationDocumentFromAPI(ctx, obj)

	if isNew && doc.VerificationStatus == 0 {
		doc.VerificationStatus = int32(originationv1.VerificationStatus_VERIFICATION_STATUS_PENDING)
	}

	err := b.eventsMan.Emit(ctx, events.ApplicationDocumentSaveEvent, doc)
	if err != nil {
		logger.WithError(err).Error("could not emit application document save event")
		return nil, err
	}

	return doc.ToAPI(), nil
}

func (b *applicationDocumentBusiness) Get(
	ctx context.Context,
	id string,
) (*originationv1.ApplicationDocumentObject, error) {
	doc, err := b.docRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrApplicationDocumentNotFound
	}
	return doc.ToAPI(), nil
}

func (b *applicationDocumentBusiness) Search(
	ctx context.Context,
	req *originationv1.ApplicationDocumentSearchRequest,
	consumer func(ctx context.Context, batch []*originationv1.ApplicationDocumentObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "ApplicationDocumentBusiness.Search")

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
	if req.GetDocumentType() != originationv1.DocumentType_DOCUMENT_TYPE_UNSPECIFIED {
		andQueryVal["document_type = ?"] = int32(req.GetDocumentType())
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.docRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search application documents")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.ApplicationDocument) error {
		var apiResults []*originationv1.ApplicationDocumentObject
		for _, doc := range res {
			apiResults = append(apiResults, doc.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}
