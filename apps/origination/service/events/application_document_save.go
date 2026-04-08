package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/origination/service/models"
	"github.com/antinvestor/service-fintech/apps/origination/service/repository"
)

const ApplicationDocumentSaveEvent = "application_document.save"

type ApplicationDocumentSave struct {
	repo repository.ApplicationDocumentRepository
}

func NewApplicationDocumentSave(
	_ context.Context,
	repo repository.ApplicationDocumentRepository,
) *ApplicationDocumentSave {
	return &ApplicationDocumentSave{repo: repo}
}

func (e *ApplicationDocumentSave) Name() string     { return ApplicationDocumentSaveEvent }
func (e *ApplicationDocumentSave) PayloadType() any { return &models.ApplicationDocument{} }

func (e *ApplicationDocumentSave) Validate(_ context.Context, payload any) error {
	doc, ok := payload.(*models.ApplicationDocument)
	if !ok {
		return errors.New("payload is not of type models.ApplicationDocument")
	}
	if doc.GetID() == "" {
		return errors.New("application document ID should already have been set")
	}
	return nil
}

func (e *ApplicationDocumentSave) Execute(ctx context.Context, payload any) error {
	doc, ok := payload.(*models.ApplicationDocument)
	if !ok {
		return errors.New("payload is not of type models.ApplicationDocument")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "application_document_id": doc.GetID()})
	defer logger.Release()

	existing, getErr := e.repo.GetByID(ctx, doc.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.repo.Update(ctx, doc); err != nil {
			logger.WithError(err).Error("could not update application document in db")
			return err
		}
		return nil
	}

	if err := e.repo.Create(ctx, doc); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create application document in db")
		return err
	}

	return nil
}
