package business

import (
	"context"

	"buf.build/gen/go/antinvestor/tenancy/connectrpc/go/tenancy/v1/tenancyv1connect"
	tenancyv1 "buf.build/gen/go/antinvestor/tenancy/protocolbuffers/go/tenancy/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/identity/service/events"
	"github.com/antinvestor/service-fintech/apps/identity/service/repository"

	fevents "github.com/pitabwire/frame/events"
)

// maxLoginTargets is the maximum number of child login targets returned per drill-down.
const maxLoginTargets = 100

// LoginClientBusiness manages OAuth client creation for partition-scoped login.
// This is independent from org/branch creation — clients can be enabled or disabled separately.
type LoginClientBusiness interface {
	// EnableForOrganization creates an OAuth client for an organization's partition.
	EnableForOrganization(ctx context.Context, organizationID string) (string, error)
	// EnableForBranch creates an OAuth client for a branch's partition.
	EnableForBranch(ctx context.Context, branchID string) (string, error)
	// GetLoginTargets resolves child login targets for a given OAuth client_id.
	GetLoginTargets(ctx context.Context, clientID string) (*LoginTargetsResponse, error)
}

type loginClientBusiness struct {
	eventsMan        fevents.Manager
	organizationRepo repository.OrganizationRepository
	branchRepo       repository.BranchRepository
	partitionCli     tenancyv1connect.TenancyServiceClient
	redirectURIs     []string
	audiences        []string
}

func NewLoginClientBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	organizationRepo repository.OrganizationRepository,
	branchRepo repository.BranchRepository,
	partitionCli tenancyv1connect.TenancyServiceClient,
	redirectURIs, audiences []string,
) LoginClientBusiness {
	return &loginClientBusiness{
		eventsMan:        eventsMan,
		organizationRepo: organizationRepo,
		branchRepo:       branchRepo,
		partitionCli:     partitionCli,
		redirectURIs:     redirectURIs,
		audiences:        audiences,
	}
}

func (b *loginClientBusiness) EnableForOrganization(ctx context.Context, organizationID string) (string, error) {
	logger := util.Log(ctx).WithField("method", "LoginClientBusiness.EnableForOrganization")

	org, err := b.organizationRepo.GetByID(ctx, organizationID)
	if err != nil {
		return "", ErrOrganizationNotFound
	}

	if org.ClientID != "" {
		logger.Info("organization already has a login client")
		return org.ClientID, nil
	}

	clientID, err := b.createClientForPartition(ctx, logger, org.PartitionID, org.Name)
	if err != nil {
		return "", err
	}

	org.ClientID = clientID
	err = b.eventsMan.Emit(ctx, events.OrganizationSaveEvent, org)
	if err != nil {
		logger.WithError(err).Error("could not persist client_id on organization")
		return "", err
	}

	return clientID, nil
}

func (b *loginClientBusiness) EnableForBranch(ctx context.Context, branchID string) (string, error) {
	logger := util.Log(ctx).WithField("method", "LoginClientBusiness.EnableForBranch")

	branch, err := b.branchRepo.GetByID(ctx, branchID)
	if err != nil {
		return "", ErrBranchNotFound
	}

	if branch.ClientID != "" {
		logger.Info("branch already has a login client")
		return branch.ClientID, nil
	}

	clientID, err := b.createClientForPartition(ctx, logger, branch.PartitionID, branch.Name)
	if err != nil {
		return "", err
	}

	branch.ClientID = clientID
	err = b.eventsMan.Emit(ctx, events.BranchSaveEvent, branch)
	if err != nil {
		logger.WithError(err).Error("could not persist client_id on branch")
		return "", err
	}

	return clientID, nil
}

func (b *loginClientBusiness) createClientForPartition(
	ctx context.Context,
	logger *util.LogEntry,
	partitionID, name string,
) (string, error) {
	if b.partitionCli == nil {
		return "", ErrLoginClientCreationFailed
	}

	resp, err := b.partitionCli.CreateClient(ctx, connect.NewRequest(
		&tenancyv1.CreateClientRequest{
			Name:          name + " Login",
			Type:          "public",
			GrantTypes:    []string{"authorization_code", "refresh_token"},
			ResponseTypes: []string{"code"},
			RedirectUris:  b.redirectURIs,
			Scopes:        "openid profile offline_access",
			Audiences:     b.audiences,
			Owner: &tenancyv1.CreateClientRequest_PartitionId{
				PartitionId: partitionID,
			},
		},
	))
	if err != nil {
		logger.WithError(err).Error("failed to create OAuth client for partition")
		return "", ErrLoginClientCreationFailed
	}

	return resp.Msg.GetData().GetClientId(), nil
}

// LoginTarget represents a drill-down login target returned by the login targets endpoint.
type LoginTarget struct {
	Name     string `json:"name"`
	Code     string `json:"code"`
	ClientID string `json:"client_id"`
	Type     string `json:"type"` // "organization" or "branch"
}

// LoginTargetsResponse is the response from the login targets endpoint.
type LoginTargetsResponse struct {
	Targets []LoginTarget `json:"targets"`
	Current struct {
		Name string `json:"name"`
		Type string `json:"type"` // "root", "organization", or "branch"
	} `json:"current"`
}

// GetLoginTargets resolves child login targets for a given OAuth client_id.
// Root client → returns organizations. Org client → returns branches.
func (b *loginClientBusiness) GetLoginTargets(ctx context.Context, clientID string) (*LoginTargetsResponse, error) {
	logger := util.Log(ctx).WithField("method", "LoginClientBusiness.GetLoginTargets")

	if b.partitionCli == nil {
		return nil, ErrLoginClientCreationFailed
	}

	// Resolve client_id → partition
	clientResp, err := b.partitionCli.GetClient(ctx, connect.NewRequest(
		&tenancyv1.GetClientRequest{ClientId: clientID},
	))
	if err != nil {
		logger.WithError(err).Warn("failed to resolve client_id")
		return nil, err
	}

	partition := clientResp.Msg.GetData().GetPartition()
	if partition == nil {
		return nil, ErrLoginClientCreationFailed
	}

	partitionID := partition.GetId()
	partitionName := partition.GetName()

	response := &LoginTargetsResponse{}

	// Check if this partition belongs to an organization
	org, err := b.organizationRepo.GetByPartitionID(ctx, partitionID)
	if err == nil && org != nil {
		// Org-level: return branches
		response.Current.Name = org.Name
		response.Current.Type = "organization"

		branches, brErr := b.branchRepo.GetByOrganizationID(ctx, org.GetID(), 0, maxLoginTargets)
		if brErr != nil {
			logger.WithError(brErr).Warn("failed to fetch branches")
			return response, nil
		}

		for _, branch := range branches {
			if branch.ClientID == "" {
				continue
			}
			response.Targets = append(response.Targets, LoginTarget{
				Name:     branch.Name,
				Code:     branch.Code,
				ClientID: branch.ClientID,
				Type:     "branch",
			})
		}

		return response, nil
	}

	// Root-level: return organizations with login clients
	response.Current.Name = partitionName
	response.Current.Type = "root"

	orgs, orgErr := b.organizationRepo.GetByTenantID(ctx, partition.GetTenantId(), 0, maxLoginTargets)
	if orgErr != nil {
		logger.WithError(orgErr).Warn("failed to fetch organizations")
		return response, nil
	}

	for _, o := range orgs {
		if o.ClientID == "" {
			continue
		}
		response.Targets = append(response.Targets, LoginTarget{
			Name:     o.Name,
			Code:     o.Code,
			ClientID: o.ClientID,
			Type:     "organization",
		})
	}

	return response, nil
}
