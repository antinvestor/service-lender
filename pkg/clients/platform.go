package clients

import (
	"context"
	"fmt"

	"buf.build/gen/go/antinvestor/identity/connectrpc/go/identity/v1/identityv1connect"
	apis "github.com/antinvestor/apis/go/common"
	"github.com/antinvestor/apis/go/common/connection"
	"github.com/pitabwire/util"
)

// PlatformClients holds all external service client connections.
// Fields are progressively enabled as proto types are published to buf BSR.
type PlatformClients struct {
	// Currently available (published to buf BSR)
	LenderIdentity identityv1connect.FieldServiceClient
	LenderRegistry identityv1connect.IdentityServiceClient

	// Pending buf BSR publication:
	// LenderOrigination    originationv1connect.OriginationServiceClient
	// LenderLoanManagement loansv1connect.LoanManagementServiceClient
	// LenderSavings        savingsv1connect.SavingsServiceClient

	// Platform services (add as API packages are imported):
	// LedgerClient       ledgerv1connect.LedgerServiceClient
	// PaymentClient      paymentv1connect.PaymentServiceClient
	// NotificationClient notificationv1connect.NotificationServiceClient
	// ProfileClient      profilev1connect.ProfileServiceClient
	// PartitionClient    partitionv1connect.PartitionServiceClient
}

// NewPlatformClients creates all platform service clients.
func NewPlatformClients(ctx context.Context, cfg interface{}) (*PlatformClients, error) {
	log := util.Log(ctx)
	pc := &PlatformClients{}
	var firstErr error

	trackErr := func(name string, err error) {
		if err != nil {
			log.WithError(err).Warn(fmt.Sprintf("Could not setup %s client", name))
			if firstErr == nil {
				firstErr = err
			}
		}
	}

	// Lender Identity (Field) client
	identityCli, err := connection.NewServiceClient(ctx, cfg, apis.ServiceTarget{
		Endpoint:  "127.0.0.1:7001",
		Audiences: []string{"service_lender_identity"},
	}, identityv1connect.NewFieldServiceClient)
	trackErr("lender-identity", err)
	pc.LenderIdentity = identityCli

	// Lender Registry (Identity) client
	registryCli, err := connection.NewServiceClient(ctx, cfg, apis.ServiceTarget{
		Endpoint:  "127.0.0.1:7001",
		Audiences: []string{"service_lender_identity"},
	}, identityv1connect.NewIdentityServiceClient)
	trackErr("lender-registry", err)
	pc.LenderRegistry = registryCli

	// NOTE: Origination, LoanManagement, and Savings clients will be enabled
	// once their proto types are published to the buf BSR.

	return pc, firstErr
}
