package business

import (
	"context"
	"strconv"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	lenderv1 "buf.build/gen/go/antinvestor/lender/protocolbuffers/go/lender/v1"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/identity/service/events"
	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/antinvestor/service-lender/apps/identity/service/repository"
)

type BorrowerBusiness interface {
	Save(ctx context.Context, obj *lenderv1.BorrowerObject) (*lenderv1.BorrowerObject, error)
	Get(ctx context.Context, id string) (*lenderv1.BorrowerObject, error)
	Search(
		ctx context.Context,
		req *lenderv1.BorrowerSearchRequest,
		consumer func(ctx context.Context, batch []*lenderv1.BorrowerObject) error,
	) error
	Reassign(ctx context.Context, req *lenderv1.BorrowerReassignRequest) (*lenderv1.BorrowerObject, error)
}

type borrowerBusiness struct {
	eventsMan    fevents.Manager
	agentRepo    repository.AgentRepository
	borrowerRepo repository.BorrowerRepository
	bahRepo      repository.BorrowerAssignmentHistoryRepository
	branchRepo   repository.BranchRepository
}

func NewBorrowerBusiness(_ context.Context, eventsMan fevents.Manager,
	agentRepo repository.AgentRepository, borrowerRepo repository.BorrowerRepository,
	bahRepo repository.BorrowerAssignmentHistoryRepository, branchRepo repository.BranchRepository,
) BorrowerBusiness {
	return &borrowerBusiness{
		eventsMan:    eventsMan,
		agentRepo:    agentRepo,
		borrowerRepo: borrowerRepo,
		bahRepo:      bahRepo,
		branchRepo:   branchRepo,
	}
}

func (b *borrowerBusiness) Save(ctx context.Context, obj *lenderv1.BorrowerObject) (*lenderv1.BorrowerObject, error) {
	logger := util.Log(ctx).WithField("method", "BorrowerBusiness.Save")

	// Validate agent exists and is active
	agent, err := b.agentRepo.GetByID(ctx, obj.GetAgentId())
	if err != nil {
		logger.WithError(err).Warn("agent not found for borrower")
		return nil, ErrAgentNotFound
	}

	if commonv1.STATE(agent.State) != commonv1.STATE_ACTIVE &&
		commonv1.STATE(agent.State) != commonv1.STATE_CREATED {
		return nil, ErrAgentInactive
	}

	borrower := models.BorrowerFromAPI(ctx, obj)

	if borrower.State == 0 {
		borrower.State = int32(commonv1.STATE_CREATED.Number())
	}

	err = b.eventsMan.Emit(ctx, events.BorrowerSaveEvent, borrower)
	if err != nil {
		logger.WithError(err).Error("could not emit borrower save event")
		return nil, err
	}

	return borrower.ToAPI(), nil
}

func (b *borrowerBusiness) Get(ctx context.Context, id string) (*lenderv1.BorrowerObject, error) {
	borrower, err := b.borrowerRepo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	return borrower.ToAPI(), nil
}

//nolint:dupl // similar search logic for different entity types
func (b *borrowerBusiness) Search(
	ctx context.Context,
	req *lenderv1.BorrowerSearchRequest,
	consumer func(ctx context.Context, batch []*lenderv1.BorrowerObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "BorrowerBusiness.Search")

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
	if req.GetAgentId() != "" {
		andQueryVal["agent_id = ?"] = req.GetAgentId()
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	if req.GetQuery() != "" {
		searchOpts = append(searchOpts,
			data.WithSearchFiltersOrByValue(
				map[string]any{"searchable @@ websearch_to_tsquery( 'english', ?) ": req.GetQuery()},
			),
		)
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.borrowerRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search borrowers")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.Borrower) error {
		var apiResults []*lenderv1.BorrowerObject
		for _, borrower := range res {
			apiResults = append(apiResults, borrower.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

func (b *borrowerBusiness) Reassign(
	ctx context.Context,
	req *lenderv1.BorrowerReassignRequest,
) (*lenderv1.BorrowerObject, error) {
	logger := util.Log(ctx).WithField("method", "BorrowerBusiness.Reassign")

	borrower, err := b.borrowerRepo.GetByID(ctx, req.GetBorrowerId())
	if err != nil {
		return nil, ErrBorrowerNotFound
	}

	if borrower.AgentID == req.GetNewAgentId() {
		return nil, ErrReassignSameAgent
	}

	// Validate new agent exists
	newAgent, err := b.agentRepo.GetByID(ctx, req.GetNewAgentId())
	if err != nil {
		return nil, ErrAgentNotFound.Extend("new agent not found")
	}

	// Validate both agents are in the same bank
	oldAgent, err := b.agentRepo.GetByID(ctx, borrower.AgentID)
	if err != nil {
		return nil, ErrAgentNotFound.Extend("current agent not found")
	}

	oldBranch, err := b.branchRepo.GetByID(ctx, oldAgent.BranchID)
	if err != nil {
		return nil, ErrBranchNotFound
	}

	newBranch, err := b.branchRepo.GetByID(ctx, newAgent.BranchID)
	if err != nil {
		return nil, ErrBranchNotFound
	}

	if oldBranch.BankID != newBranch.BankID {
		return nil, ErrReassignCrossBank
	}

	// Create assignment history record
	history := &models.BorrowerAssignmentHistory{
		BorrowerID:      borrower.GetID(),
		PreviousAgentID: borrower.AgentID,
		NewAgentID:      req.GetNewAgentId(),
		Reason:          req.GetReason(),
	}
	history.GenID(ctx)

	err = b.bahRepo.Create(ctx, history)
	if err != nil {
		logger.WithError(err).Error("could not save assignment history")
		return nil, err
	}

	// Update borrower's agent
	borrower.AgentID = req.GetNewAgentId()
	_, err = b.borrowerRepo.Update(ctx, borrower, "agent_id")
	if err != nil {
		logger.WithError(err).Error("could not update borrower agent")
		return nil, err
	}

	logger.WithField("borrower_id", borrower.GetID()).
		WithField("old_agent", history.PreviousAgentID).
		WithField("new_agent", history.NewAgentID).
		Info("borrower reassigned")

	return borrower.ToAPI(), nil
}
