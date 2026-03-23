package business

import (
	"context"
	"errors"

	fevents "github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-lender/apps/group/service/models"
	"github.com/antinvestor/service-lender/apps/group/service/repository"
	"github.com/antinvestor/service-lender/pkg/clients"
)

type membershipBusiness struct {
	eventsMan fevents.Manager
	memRepo   repository.MembershipRepository
	clients   *clients.PlatformClients
}

func NewMembershipBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	memRepo repository.MembershipRepository,
	pc *clients.PlatformClients,
) MembershipBusiness {
	return &membershipBusiness{eventsMan: eventsMan, memRepo: memRepo, clients: pc}
}

func (b *membershipBusiness) Create(ctx context.Context, membership *models.Membership) (*models.Membership, error) {
	return nil, errors.New("group membership operations are not yet available for this product")
}

func (b *membershipBusiness) Get(ctx context.Context, id string) (*models.Membership, error) {
	return b.memRepo.GetByID(ctx, id)
}

func (b *membershipBusiness) GetByGroupID(ctx context.Context, groupID string) ([]*models.Membership, error) {
	return b.memRepo.GetByGroupID(ctx, groupID)
}

func (b *membershipBusiness) UpdateRole(ctx context.Context, membershipID string, role int32) error {
	return errors.New("group membership operations are not yet available for this product")
}

func (b *membershipBusiness) CheckPeriodicPayment(
	ctx context.Context,
	membershipID string,
) (map[string]interface{}, error) {
	return nil, errors.New("group membership operations are not yet available for this product")
}
