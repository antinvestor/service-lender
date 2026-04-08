package business

import (
	"context"
	"strconv"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"buf.build/gen/go/antinvestor/tenancy/connectrpc/go/tenancy/v1/tenancyv1connect"
	tenancyv1 "buf.build/gen/go/antinvestor/tenancy/protocolbuffers/go/tenancy/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/identity/service/events"
	"github.com/antinvestor/service-fintech/apps/identity/service/models"
	"github.com/antinvestor/service-fintech/apps/identity/service/repository"
)

type BranchBusiness interface {
	Save(ctx context.Context, obj *identityv1.BranchObject) (*identityv1.BranchObject, error)
	Get(ctx context.Context, id string) (*identityv1.BranchObject, error)
	Search(
		ctx context.Context,
		req *identityv1.BranchSearchRequest,
		consumer func(ctx context.Context, batch []*identityv1.BranchObject) error,
	) error
}

type branchBusiness struct {
	eventsMan        fevents.Manager
	organizationRepo repository.OrganizationRepository
	branchRepo       repository.BranchRepository
	partitionCli     tenancyv1connect.TenancyServiceClient
}

func NewBranchBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	organizationRepo repository.OrganizationRepository,
	branchRepo repository.BranchRepository,
	partitionCli tenancyv1connect.TenancyServiceClient,
) BranchBusiness {
	return &branchBusiness{
		eventsMan:        eventsMan,
		organizationRepo: organizationRepo,
		branchRepo:       branchRepo,
		partitionCli:     partitionCli,
	}
}

func (b *branchBusiness) Save(ctx context.Context, obj *identityv1.BranchObject) (*identityv1.BranchObject, error) {
	logger := util.Log(ctx).WithField("method", "BranchBusiness.Save")

	// Validate organization exists
	org, err := b.organizationRepo.GetByID(ctx, obj.GetOrganizationId())
	if err != nil {
		logger.WithError(err).Warn("organization not found for branch")
		return nil, ErrOrganizationNotFound
	}

	isNew := obj.GetId() == ""
	branch := models.BranchFromAPI(ctx, obj)

	if isNew && branch.State == 0 {
		branch.State = int32(commonv1.STATE_CREATED.Number())
	}

	if isNew {
		orgPartitionID := org.PartitionID
		orgTenantID := org.TenantID

		if b.partitionCli != nil {
			createReq := connect.NewRequest(&tenancyv1.CreatePartitionRequest{
				TenantId:    orgTenantID,
				ParentId:    orgPartitionID,
				Name:        branch.Name,
				Description: "Partition for branch: " + branch.Name,
			})
			resp, createErr := b.partitionCli.CreatePartition(ctx, createReq)
			if createErr != nil {
				logger.WithError(createErr).Warn("failed to create partition for branch, falling back to organization partition")
				branch.PartitionID = orgPartitionID
			} else {
				branch.PartitionID = resp.Msg.GetData().GetId()
			}
		} else {
			logger.Warn("partition client is nil, falling back to organization partition")
			branch.PartitionID = orgPartitionID
		}

		branch.TenantID = orgTenantID
	}

	err = b.eventsMan.Emit(ctx, events.BranchSaveEvent, branch)
	if err != nil {
		logger.WithError(err).Error("could not emit branch save event")
		return nil, err
	}

	return branch.ToAPI(), nil
}

func (b *branchBusiness) Get(ctx context.Context, id string) (*identityv1.BranchObject, error) {
	branch, err := b.branchRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrBranchNotFound
	}
	return branch.ToAPI(), nil
}

//nolint:dupl // similar search logic for different entity types
func (b *branchBusiness) Search(
	ctx context.Context,
	req *identityv1.BranchSearchRequest,
	consumer func(ctx context.Context, batch []*identityv1.BranchObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "BranchBusiness.Search")

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
	if req.GetOrganizationId() != "" {
		andQueryVal["organization_id = ?"] = req.GetOrganizationId()
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
	results, err := b.branchRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search branches")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.Branch) error {
		var apiResults []*identityv1.BranchObject
		for _, branch := range res {
			apiResults = append(apiResults, branch.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}
