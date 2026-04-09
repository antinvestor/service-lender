package business

import (
	"context"
	"errors"

	fevents "github.com/pitabwire/frame/events"

	identitymodels "github.com/antinvestor/service-fintech/apps/identity/service/models"
	identityrepo "github.com/antinvestor/service-fintech/apps/identity/service/repository"
	"github.com/antinvestor/service-fintech/pkg/clients"
)

type membershipBusiness struct {
	eventsMan fevents.Manager
	memRepo   identityrepo.MembershipRepository
	clients   *clients.PlatformClients
}

func NewMembershipBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	memRepo identityrepo.MembershipRepository,
	pc *clients.PlatformClients,
) MembershipBusiness {
	return &membershipBusiness{eventsMan: eventsMan, memRepo: memRepo, clients: pc}
}

func (b *membershipBusiness) Create(
	_ context.Context,
	_ *identitymodels.Membership,
) (*identitymodels.Membership, error) {
	return nil, errors.New("group membership operations are not yet available for this product")
}

func (b *membershipBusiness) Get(ctx context.Context, id string) (*identitymodels.Membership, error) {
	return b.memRepo.GetByID(ctx, id)
}

func (b *membershipBusiness) GetByGroupID(ctx context.Context, groupID string) ([]*identitymodels.Membership, error) {
	return b.memRepo.GetByGroupID(ctx, groupID, 0, 1000)
}

func (b *membershipBusiness) UpdateRole(_ context.Context, _ string, _ int32) error {
	return errors.New("group membership operations are not yet available for this product")
}

func (b *membershipBusiness) CheckPeriodicPayment(
	_ context.Context,
	_ string,
) (map[string]interface{}, error) {
	return nil, errors.New("group membership operations are not yet available for this product")
}
