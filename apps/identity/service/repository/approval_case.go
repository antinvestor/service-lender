package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
)

type ApprovalCaseRepository interface {
	datastore.BaseRepository[*models.ApprovalCase]
	GetOpenBySubject(
		ctx context.Context,
		subjectType, subjectID, caseType string,
	) (*models.ApprovalCase, error)
}

type approvalCaseRepository struct {
	datastore.BaseRepository[*models.ApprovalCase]
}

func NewApprovalCaseRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) ApprovalCaseRepository {
	return &approvalCaseRepository{
		BaseRepository: datastore.NewBaseRepository[*models.ApprovalCase](
			ctx, dbPool, workMan, func() *models.ApprovalCase { return &models.ApprovalCase{} },
		),
	}
}

func (r *approvalCaseRepository) GetOpenBySubject(
	ctx context.Context,
	subjectType, subjectID, caseType string,
) (*models.ApprovalCase, error) {
	approvalCase := &models.ApprovalCase{}
	err := r.Pool().DB(ctx, true).
		Where(
			"subject_type = ? AND subject_id = ? AND case_type = ? AND status IN ?",
			subjectType, subjectID, caseType, []string{"pending_verification", "pending_approval"},
		).
		Order("created_at DESC").
		First(approvalCase).Error
	if err != nil {
		return nil, err
	}
	return approvalCase, nil
}
