package business

import (
	"context"
	"strconv"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/identity/service/events"
	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/antinvestor/service-lender/apps/identity/service/repository"
)

type MembershipBusiness interface {
	Save(ctx context.Context, obj *identityv1.MembershipObject) (*identityv1.MembershipObject, error)
	Get(ctx context.Context, id string) (*identityv1.MembershipObject, error)
	Search(
		ctx context.Context,
		req *identityv1.MembershipSearchRequest,
		consumer func(ctx context.Context, batch []*identityv1.MembershipObject) error,
	) error
}

type membershipBusiness struct {
	eventsMan      fevents.Manager
	groupRepo      repository.GroupRepository
	membershipRepo repository.MembershipRepository
}

func NewMembershipBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	groupRepo repository.GroupRepository,
	membershipRepo repository.MembershipRepository,
) MembershipBusiness {
	return &membershipBusiness{
		eventsMan:      eventsMan,
		groupRepo:      groupRepo,
		membershipRepo: membershipRepo,
	}
}

func (b *membershipBusiness) Save(
	ctx context.Context,
	obj *identityv1.MembershipObject,
) (*identityv1.MembershipObject, error) {
	logger := util.Log(ctx).WithField("method", "MembershipBusiness.Save")

	// Validate group exists
	_, err := b.groupRepo.GetByID(ctx, obj.GetGroupId())
	if err != nil {
		logger.WithError(err).Warn("group not found for membership")
		return nil, ErrGroupNotFound
	}

	isNew := obj.GetId() == ""
	membership := models.MembershipFromAPI(ctx, obj)

	if isNew && membership.State == 0 {
		membership.State = int32(commonv1.STATE_CREATED.Number())
	}

	err = b.eventsMan.Emit(ctx, events.MembershipSaveEvent, membership)
	if err != nil {
		logger.WithError(err).Error("could not emit membership save event")
		return nil, err
	}

	return membership.ToAPI(), nil
}

func (b *membershipBusiness) Get(ctx context.Context, id string) (*identityv1.MembershipObject, error) {
	membership, err := b.membershipRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrMembershipNotFound
	}
	return membership.ToAPI(), nil
}

func (b *membershipBusiness) Search(
	ctx context.Context,
	req *identityv1.MembershipSearchRequest,
	consumer func(ctx context.Context, batch []*identityv1.MembershipObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "MembershipBusiness.Search")

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
	if req.GetGroupId() != "" {
		andQueryVal["group_id = ?"] = req.GetGroupId()
	}
	if req.GetProfileId() != "" {
		andQueryVal["profile_id = ?"] = req.GetProfileId()
	}
	if req.GetRole() != identityv1.MembershipRole_MEMBERSHIP_ROLE_UNSPECIFIED {
		andQueryVal["role = ?"] = int32(req.GetRole())
	}
	if req.GetMembershipType() != identityv1.MembershipType_MEMBERSHIP_TYPE_UNSPECIFIED {
		andQueryVal["membership_type = ?"] = int32(req.GetMembershipType())
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
	results, err := b.membershipRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search memberships")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.Membership) error {
		var apiResults []*identityv1.MembershipObject
		for _, membership := range res {
			apiResults = append(apiResults, membership.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}
