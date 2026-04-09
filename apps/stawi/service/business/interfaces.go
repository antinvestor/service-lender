package business

import (
	"context"

	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"

	"github.com/antinvestor/service-fintech/apps/stawi/service/models"
)

// ClientGroupBusiness handles customer group lifecycle operations.
type ClientGroupBusiness interface {
	Create(ctx context.Context, group *identityv1.ClientGroupObject) (*identityv1.ClientGroupObject, error)
	Get(ctx context.Context, id string) (*identityv1.ClientGroupObject, error)
	Transition(ctx context.Context, groupID string, newState int32, reason string) error
	CheckFormation(ctx context.Context, groupID string) (map[string]interface{}, error)
	WelcomeGroup(ctx context.Context, groupID string) error
	SetupLedgerAccounts(ctx context.Context, groupID string) error
	RegisterWithLender(ctx context.Context, groupID string) error
}

// MembershipBusiness handles group membership operations.
type MembershipBusiness interface {
	Create(ctx context.Context, membership *identityv1.MembershipObject) (*identityv1.MembershipObject, error)
	Get(ctx context.Context, id string) (*identityv1.MembershipObject, error)
	GetByGroupID(ctx context.Context, groupID string) ([]*identityv1.MembershipObject, error)
	UpdateRole(ctx context.Context, membershipID string, role int32) error
	CheckPeriodicPayment(ctx context.Context, membershipID string) (map[string]interface{}, error)
}

// TenureBusiness handles tenure lifecycle operations.
type TenureBusiness interface {
	Open(ctx context.Context, groupID string) (*models.Tenure, error)
	Close(ctx context.Context, tenureID string) error
	GetActive(ctx context.Context, groupID string) (*models.Tenure, error)
}

// PeriodBusiness handles period lifecycle operations.
type PeriodBusiness interface {
	Open(ctx context.Context, groupID string) (*models.Period, error)
	Close(ctx context.Context, periodID string) error
	GetCurrent(ctx context.Context, groupID string) (*models.Period, error)
}

// MotionBusiness handles group voting/decision operations.
type MotionBusiness interface {
	Create(ctx context.Context, motion *models.Motion) (*models.Motion, error)
	Vote(ctx context.Context, motionID, membershipID string, choice int32) error
}
