package business

import (
	"context"

	fieldv1 "buf.build/gen/go/antinvestor/field/protocolbuffers/go/field/v1"
	fevents "github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
	"github.com/antinvestor/service-fintech/apps/identity/service/repository"
)

type AgentBusiness interface {
	Save(ctx context.Context, obj *fieldv1.AgentObject) (*fieldv1.AgentObject, error)
	Get(ctx context.Context, id string) (*fieldv1.AgentObject, error)
	Search(
		ctx context.Context,
		req *fieldv1.AgentSearchRequest,
		consumer func(ctx context.Context, batch []*fieldv1.AgentObject) error,
	) error
	Hierarchy(
		ctx context.Context,
		req *fieldv1.AgentHierarchyRequest,
		consumer func(ctx context.Context, batch []*fieldv1.AgentObject) error,
	) error
	SaveBranch(ctx context.Context, ab *models.AgentBranch) (*models.AgentBranch, error)
	DeleteBranch(ctx context.Context, id string) error
	ListBranchesByAgent(ctx context.Context, agentID string) ([]*models.AgentBranch, error)
	ListBranchesByBranch(ctx context.Context, branchID string) ([]*models.AgentBranch, error)
	GetBranchIDsForAgent(ctx context.Context, agentID string) ([]string, error)
}

type agentBusiness struct {
	eventsMan        fevents.Manager
	maxAgentDepth    int
	organizationRepo repository.OrganizationRepository
	branchRepo       repository.BranchRepository
	agentRepo        repository.AgentRepository
	agentBranchRepo  repository.AgentBranchRepository
	notifier         *AgentNotifier
}

func NewAgentBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	maxAgentDepth int,
	organizationRepo repository.OrganizationRepository,
	branchRepo repository.BranchRepository,
	agentRepo repository.AgentRepository,
	agentBranchRepo repository.AgentBranchRepository,
	notifier *AgentNotifier,
) AgentBusiness {
	return &agentBusiness{
		eventsMan:        eventsMan,
		maxAgentDepth:    maxAgentDepth,
		organizationRepo: organizationRepo,
		branchRepo:       branchRepo,
		agentRepo:        agentRepo,
		agentBranchRepo:  agentBranchRepo,
		notifier:         notifier,
	}
}

func (b *agentBusiness) Save(context.Context, *fieldv1.AgentObject) (*fieldv1.AgentObject, error) {
	return nil, ErrDeprecatedAgentModel
}

func (b *agentBusiness) Get(context.Context, string) (*fieldv1.AgentObject, error) {
	return nil, ErrDeprecatedAgentModel
}

func (b *agentBusiness) Search(
	context.Context,
	*fieldv1.AgentSearchRequest,
	func(context.Context, []*fieldv1.AgentObject) error,
) error {
	return ErrDeprecatedAgentModel
}

func (b *agentBusiness) Hierarchy(
	context.Context,
	*fieldv1.AgentHierarchyRequest,
	func(context.Context, []*fieldv1.AgentObject) error,
) error {
	return ErrDeprecatedAgentModel
}

func (b *agentBusiness) SaveBranch(context.Context, *models.AgentBranch) (*models.AgentBranch, error) {
	return nil, ErrDeprecatedAgentModel
}

func (b *agentBusiness) DeleteBranch(context.Context, string) error {
	return ErrDeprecatedAgentModel
}

func (b *agentBusiness) ListBranchesByAgent(context.Context, string) ([]*models.AgentBranch, error) {
	return nil, ErrDeprecatedAgentModel
}

func (b *agentBusiness) ListBranchesByBranch(context.Context, string) ([]*models.AgentBranch, error) {
	return nil, ErrDeprecatedAgentModel
}

func (b *agentBusiness) GetBranchIDsForAgent(context.Context, string) ([]string, error) {
	return nil, ErrDeprecatedAgentModel
}
