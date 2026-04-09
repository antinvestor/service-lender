package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/origination/service/models"
	"github.com/antinvestor/service-fintech/apps/origination/service/repository"
)

const FormSubmissionSaveEvent = "form_submission.save"

type FormSubmissionSave struct {
	repo repository.FormSubmissionRepository
}

func NewFormSubmissionSave(_ context.Context, repo repository.FormSubmissionRepository) *FormSubmissionSave {
	return &FormSubmissionSave{repo: repo}
}

func (e *FormSubmissionSave) Name() string     { return FormSubmissionSaveEvent }
func (e *FormSubmissionSave) PayloadType() any { return &models.FormSubmission{} }

func (e *FormSubmissionSave) Validate(_ context.Context, payload any) error {
	fs, ok := payload.(*models.FormSubmission)
	if !ok {
		return errors.New("payload is not of type models.FormSubmission")
	}
	if fs.GetID() == "" {
		return errors.New("form submission ID should already have been set")
	}
	return nil
}

func (e *FormSubmissionSave) Execute(ctx context.Context, payload any) error {
	fs, ok := payload.(*models.FormSubmission)
	if !ok {
		return errors.New("payload is not of type models.FormSubmission")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "form_submission_id": fs.GetID()})
	defer logger.Release()

	existing, getErr := e.repo.GetByID(ctx, fs.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.repo.Update(ctx, fs); err != nil {
			logger.WithError(err).Error("could not update form submission in db")
			return err
		}
		return nil
	}

	if err := e.repo.Create(ctx, fs); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create form submission in db")
		return err
	}

	return nil
}
