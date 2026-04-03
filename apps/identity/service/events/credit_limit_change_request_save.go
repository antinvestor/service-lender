package events

import (
	"context"
	"errors"

	"github.com/pitabwire/util"
	"gorm.io/gorm"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/antinvestor/service-lender/apps/identity/service/repository"
)

const CreditLimitChangeRequestSaveEvent = "credit_limit_change_request.save"

type creditLimitChangeRequestSave struct {
	repo repository.CreditLimitChangeRequestRepository
}

func NewCreditLimitChangeRequestSave(
	_ context.Context,
	repo repository.CreditLimitChangeRequestRepository,
) *creditLimitChangeRequestSave {
	return &creditLimitChangeRequestSave{repo: repo}
}

func (e *creditLimitChangeRequestSave) Name() string {
	return CreditLimitChangeRequestSaveEvent
}

func (e *creditLimitChangeRequestSave) PayloadType() any {
	return &models.CreditLimitChangeRequest{}
}

func (e *creditLimitChangeRequestSave) Validate(_ context.Context, payload any) error {
	req, ok := payload.(*models.CreditLimitChangeRequest)
	if !ok {
		return errors.New("invalid payload type for credit_limit_change_request.save")
	}
	if req.ClientID == "" {
		return errors.New("client_id is required")
	}
	return nil
}

func (e *creditLimitChangeRequestSave) Execute(ctx context.Context, payload any) error {
	req, ok := payload.(*models.CreditLimitChangeRequest)
	if !ok {
		return errors.New("invalid payload type for credit_limit_change_request.save")
	}
	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "client_id": req.ClientID})

	existing, err := e.repo.GetByID(ctx, req.ID)
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		logger.WithError(err).Error("failed to check existing record")
		return err
	}

	if existing != nil && existing.GetID() != "" {
		_, err = e.repo.Update(ctx, req)
		if err != nil {
			logger.WithError(err).Error("failed to update record")
			return err
		}
		return nil
	}

	err = e.repo.Create(ctx, req)
	if err != nil {
		logger.WithError(err).Error("failed to create record")
		return err
	}
	return nil
}
