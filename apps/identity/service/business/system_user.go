package business

import (
	"context"

	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	fevents "github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-fintech/apps/identity/service/repository"
)

type SystemUserBusiness interface {
	Save(ctx context.Context, obj *identityv1.SystemUserObject) (*identityv1.SystemUserObject, error)
	Get(ctx context.Context, id string) (*identityv1.SystemUserObject, error)
	Search(
		ctx context.Context,
		req *identityv1.SystemUserSearchRequest,
		consumer func(ctx context.Context, batch []*identityv1.SystemUserObject) error,
	) error
}

type systemUserBusiness struct {
	eventsMan      fevents.Manager
	branchRepo     repository.BranchRepository
	systemUserRepo repository.SystemUserRepository
}

func NewSystemUserBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	branchRepo repository.BranchRepository,
	systemUserRepo repository.SystemUserRepository,
) SystemUserBusiness {
	return &systemUserBusiness{
		eventsMan:      eventsMan,
		branchRepo:     branchRepo,
		systemUserRepo: systemUserRepo,
	}
}

func (b *systemUserBusiness) Save(context.Context, *identityv1.SystemUserObject) (*identityv1.SystemUserObject, error) {
	return nil, ErrDeprecatedSystemUserModel
}

func (b *systemUserBusiness) Get(context.Context, string) (*identityv1.SystemUserObject, error) {
	return nil, ErrDeprecatedSystemUserModel
}

func (b *systemUserBusiness) Search(
	context.Context,
	*identityv1.SystemUserSearchRequest,
	func(context.Context, []*identityv1.SystemUserObject) error,
) error {
	return ErrDeprecatedSystemUserModel
}
