package business

import (
	"context"
	"strconv"

	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/identity/service/events"
	"github.com/antinvestor/service-fintech/apps/identity/service/models"
	"github.com/antinvestor/service-fintech/apps/identity/service/repository"
)

type FormSubmissionBusiness interface {
	Save(ctx context.Context, obj *identityv1.FormSubmissionObject) (*identityv1.FormSubmissionObject, error)
	Get(ctx context.Context, id string) (*identityv1.FormSubmissionObject, error)
	Search(
		ctx context.Context,
		req *identityv1.FormSubmissionSearchRequest,
		consumer func(ctx context.Context, batch []*identityv1.FormSubmissionObject) error,
	) error
}

type formSubmissionBusiness struct {
	eventsMan          fevents.Manager
	formSubmissionRepo repository.FormSubmissionRepository
	formTemplateRepo   repository.FormTemplateRepository
}

func NewFormSubmissionBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	formSubmissionRepo repository.FormSubmissionRepository,
	formTemplateRepo repository.FormTemplateRepository,
) FormSubmissionBusiness {
	return &formSubmissionBusiness{
		eventsMan:          eventsMan,
		formSubmissionRepo: formSubmissionRepo,
		formTemplateRepo:   formTemplateRepo,
	}
}

func (b *formSubmissionBusiness) Save(
	ctx context.Context,
	obj *identityv1.FormSubmissionObject,
) (*identityv1.FormSubmissionObject, error) {
	logger := util.Log(ctx).WithField("method", "FormSubmissionBusiness.Save")

	fs := models.FormSubmissionFromAPI(ctx, obj)

	// Validate submission against template if template ID is provided.
	if fs.TemplateID != "" {
		if err := b.validateAgainstTemplate(ctx, logger, fs); err != nil {
			return nil, err
		}
	}

	err := b.eventsMan.Emit(ctx, events.FormSubmissionSaveEvent, fs)
	if err != nil {
		logger.WithError(err).Error("could not emit form submission save event")
		return nil, err
	}

	return fs.ToAPI(), nil
}

// validateAgainstTemplate checks that the form submission includes all required
// fields defined in the form template and that the template is published.
func (b *formSubmissionBusiness) validateAgainstTemplate(
	ctx context.Context,
	logger *util.LogEntry,
	fs *models.FormSubmission,
) error {
	template, err := b.formTemplateRepo.GetByID(ctx, fs.TemplateID)
	if err != nil {
		return ErrFormTemplateNotFound
	}

	// Template must be published before accepting submissions.
	if template.Status != int32(identityv1.FormTemplateStatus_FORM_TEMPLATE_STATUS_PUBLISHED) {
		return ErrFormTemplateNotPublished
	}

	// Store template version at submission time.
	fs.TemplateVersion = template.Version

	// Check required fields are present in submission data.
	fields := models.FieldsToAPI(template.Fields)
	if len(fields) == 0 || fs.Data == nil {
		return nil
	}

	var missingFields []string
	for _, field := range fields {
		if !field.GetRequired() {
			continue
		}
		key := field.GetKey()
		if key == "" {
			continue
		}
		if _, exists := fs.Data[key]; !exists {
			missingFields = append(missingFields, key)
		}
	}

	if len(missingFields) > 0 {
		logger.WithField("missing_fields", missingFields).
			WithField("template_id", fs.TemplateID).
			Warn("form submission missing required fields")
		return ErrFormSubmissionMissingFields
	}

	return nil
}

func (b *formSubmissionBusiness) Get(ctx context.Context, id string) (*identityv1.FormSubmissionObject, error) {
	fs, err := b.formSubmissionRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrFormSubmissionNotFound
	}
	return fs.ToAPI(), nil
}

func (b *formSubmissionBusiness) Search(
	ctx context.Context,
	req *identityv1.FormSubmissionSearchRequest,
	consumer func(ctx context.Context, batch []*identityv1.FormSubmissionObject) error,
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
	if req.GetEntityId() != "" {
		andQueryVal["entity_id = ?"] = req.GetEntityId()
	}
	if req.GetEntityType() != "" {
		andQueryVal["entity_type = ?"] = req.GetEntityType()
	}
	if req.GetTemplateId() != "" {
		andQueryVal["template_id = ?"] = req.GetTemplateId()
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.formSubmissionRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search form submissions")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.FormSubmission) error {
		var apiResults []*identityv1.FormSubmissionObject
		for _, fs := range res {
			apiResults = append(apiResults, fs.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}
