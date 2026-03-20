package business

import (
	"context"
	"strconv"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	loansv1 "buf.build/gen/go/antinvestor/loans/protocolbuffers/go/loans/v1"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/loans/service/events"
	"github.com/antinvestor/service-lender/apps/loans/service/models"
	"github.com/antinvestor/service-lender/apps/loans/service/repository"
)

type LoanRestructureBusiness interface {
	Create(ctx context.Context, obj *loansv1.LoanRestructureObject) (*loansv1.LoanRestructureObject, error)
	Approve(ctx context.Context, id string) (*loansv1.LoanRestructureObject, error)
	Reject(ctx context.Context, id, reason string) (*loansv1.LoanRestructureObject, error)
	Search(
		ctx context.Context,
		req *loansv1.LoanRestructureSearchRequest,
		consumer func(ctx context.Context, batch []*loansv1.LoanRestructureObject) error,
	) error
}

type loanRestructureBusiness struct {
	eventsMan           fevents.Manager
	loanRestructureRepo repository.LoanRestructureRepository
	loanAccountRepo     repository.LoanAccountRepository
}

func NewLoanRestructureBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	loanRestructureRepo repository.LoanRestructureRepository,
	loanAccountRepo repository.LoanAccountRepository,
) LoanRestructureBusiness {
	return &loanRestructureBusiness{
		eventsMan:           eventsMan,
		loanRestructureRepo: loanRestructureRepo,
		loanAccountRepo:     loanAccountRepo,
	}
}

func (b *loanRestructureBusiness) Create(
	ctx context.Context,
	obj *loansv1.LoanRestructureObject,
) (*loansv1.LoanRestructureObject, error) {
	logger := util.Log(ctx).WithField("method", "LoanRestructureBusiness.Create")

	lr := models.LoanRestructureFromAPI(ctx, obj)
	lr.State = int32(commonv1.STATE_CREATED)

	err := b.eventsMan.Emit(ctx, events.LoanRestructureSaveEvent, lr)
	if err != nil {
		logger.WithError(err).Error("could not emit loan restructure save event")
		return nil, err
	}

	return lr.ToAPI(), nil
}

func (b *loanRestructureBusiness) Approve(
	ctx context.Context,
	id string,
) (*loansv1.LoanRestructureObject, error) {
	logger := util.Log(ctx).WithField("method", "LoanRestructureBusiness.Approve")

	lr, err := b.loanRestructureRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrRestructureNotFound
	}

	if commonv1.STATE(lr.State) != commonv1.STATE_CREATED {
		return nil, ErrRestructureNotPending
	}

	lr.State = int32(commonv1.STATE_ACTIVE)

	err = b.eventsMan.Emit(ctx, events.LoanRestructureSaveEvent, lr)
	if err != nil {
		logger.WithError(err).Error("could not emit loan restructure save event")
		return nil, err
	}

	// TODO: Apply restructure to loan account (update terms, regenerate schedule)

	return lr.ToAPI(), nil
}

func (b *loanRestructureBusiness) Reject(
	ctx context.Context,
	id, reason string,
) (*loansv1.LoanRestructureObject, error) {
	logger := util.Log(ctx).WithField("method", "LoanRestructureBusiness.Reject")

	lr, err := b.loanRestructureRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrRestructureNotFound
	}

	if commonv1.STATE(lr.State) != commonv1.STATE_CREATED {
		return nil, ErrRestructureNotPending
	}

	lr.State = int32(commonv1.STATE_INACTIVE)
	lr.Reason = reason

	err = b.eventsMan.Emit(ctx, events.LoanRestructureSaveEvent, lr)
	if err != nil {
		logger.WithError(err).Error("could not emit loan restructure save event")
		return nil, err
	}

	return lr.ToAPI(), nil
}

func (b *loanRestructureBusiness) Search(
	ctx context.Context,
	req *loansv1.LoanRestructureSearchRequest,
	consumer func(ctx context.Context, batch []*loansv1.LoanRestructureObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "LoanRestructureBusiness.Search")

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
	if req.GetLoanAccountId() != "" {
		andQueryVal["loan_account_id = ?"] = req.GetLoanAccountId()
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.loanRestructureRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search loan restructures")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.LoanRestructure) error {
		var apiResults []*loansv1.LoanRestructureObject
		for _, lr := range res {
			apiResults = append(apiResults, lr.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}
