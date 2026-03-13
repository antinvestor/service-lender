package events

import (
	"context"
	"errors"

	"github.com/antinvestor/service-ant-lender/apps/identity/service/models"
	"github.com/antinvestor/service-ant-lender/apps/identity/service/repository"
	"github.com/pitabwire/util"
)

const BranchSaveEvent = "branch.save"

type BranchSave struct {
	branchRepo repository.BranchRepository
}

func NewBranchSave(_ context.Context, branchRepo repository.BranchRepository) *BranchSave {
	return &BranchSave{branchRepo: branchRepo}
}

func (e *BranchSave) Name() string         { return BranchSaveEvent }
func (e *BranchSave) PayloadType() any     { return &models.Branch{} }

func (e *BranchSave) Validate(_ context.Context, payload any) error {
	branch, ok := payload.(*models.Branch)
	if !ok {
		return errors.New("payload is not of type models.Branch")
	}
	if branch.GetID() == "" {
		return errors.New("branch ID should already have been set")
	}
	return nil
}

func (e *BranchSave) Execute(ctx context.Context, payload any) error {
	branch := payload.(*models.Branch)

	logger := util.Log(ctx).WithField("type", e.Name()).WithField("branch_id", branch.GetID())
	defer logger.Release()
	logger.Debug("event handler started")

	err := e.branchRepo.Create(ctx, branch)
	if err != nil {
		logger.WithError(err).Error("could not save branch to db")
		return err
	}

	logger.Debug("event handler completed successfully")
	return nil
}
