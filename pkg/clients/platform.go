package clients

import (
	"context"
	"fmt"

	"buf.build/gen/go/antinvestor/files/connectrpc/go/files/v1/filesv1connect"
	"buf.build/gen/go/antinvestor/identity/connectrpc/go/identity/v1/identityv1connect"
	"buf.build/gen/go/antinvestor/ledger/connectrpc/go/ledger/v1/ledgerv1connect"
	"buf.build/gen/go/antinvestor/loans/connectrpc/go/loans/v1/loansv1connect"
	"buf.build/gen/go/antinvestor/notification/connectrpc/go/notification/v1/notificationv1connect"
	"buf.build/gen/go/antinvestor/origination/connectrpc/go/origination/v1/originationv1connect"
	"buf.build/gen/go/antinvestor/payment/connectrpc/go/payment/v1/paymentv1connect"
	"buf.build/gen/go/antinvestor/profile/connectrpc/go/profile/v1/profilev1connect"
	"buf.build/gen/go/antinvestor/savings/connectrpc/go/savings/v1/savingsv1connect"
	"buf.build/gen/go/antinvestor/tenancy/connectrpc/go/tenancy/v1/tenancyv1connect"
	"github.com/antinvestor/common"
	"github.com/antinvestor/common/connection"
	"github.com/pitabwire/util"
)

// ServiceEndpoints holds the URI for every platform service.
// If an endpoint is empty, its client is skipped during initialisation.
type ServiceEndpoints struct {
	IdentityURI     string
	OriginationURI  string
	LoanMgmtURI     string
	SavingsURI      string
	LedgerURI       string
	PaymentURI      string
	NotificationURI string
	FilesURI        string
	ProfileURI      string
	PartitionURI    string
}

// PlatformClients holds all external service client connections.
type PlatformClients struct {
	LenderIdentity     identityv1connect.FieldServiceClient
	LenderRegistry     identityv1connect.IdentityServiceClient
	LenderOrigination  originationv1connect.OriginationServiceClient
	LenderLoanMgmt     loansv1connect.LoanManagementServiceClient
	LenderSavings      savingsv1connect.SavingsServiceClient
	LedgerClient       ledgerv1connect.LedgerServiceClient
	PaymentClient      paymentv1connect.PaymentServiceClient
	NotificationClient notificationv1connect.NotificationServiceClient
	FilesClient        filesv1connect.FilesServiceClient
	ProfileClient      profilev1connect.ProfileServiceClient
	TenancyClient      tenancyv1connect.TenancyServiceClient
}

// NewPlatformClients creates all platform service clients using the given
// endpoints. cfg is passed through to connection.NewServiceClient for auth
// resolution. Clients whose endpoint is empty are left nil with a warning.
func NewPlatformClients(ctx context.Context, cfg any, endpoints ServiceEndpoints) (*PlatformClients, error) {
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

	warnSkip := func(name string) {
		log.Warn(fmt.Sprintf("Skipping %s client: no endpoint configured", name))
	}

	// --- Identity (Field + Registry) ---
	if endpoints.IdentityURI != "" {
		cli, err := connection.NewServiceClient(ctx, cfg, common.ServiceTarget{
			Endpoint:  endpoints.IdentityURI,
			Audiences: []string{"service_lender_identity"},
		}, identityv1connect.NewFieldServiceClient)
		trackErr("lender-identity", err)
		pc.LenderIdentity = cli

		regCli, err := connection.NewServiceClient(ctx, cfg, common.ServiceTarget{
			Endpoint:  endpoints.IdentityURI,
			Audiences: []string{"service_lender_identity"},
		}, identityv1connect.NewIdentityServiceClient)
		trackErr("lender-registry", err)
		pc.LenderRegistry = regCli
	} else {
		warnSkip("lender-identity")
	}

	// --- Origination ---
	if endpoints.OriginationURI != "" {
		cli, err := connection.NewServiceClient(ctx, cfg, common.ServiceTarget{
			Endpoint:  endpoints.OriginationURI,
			Audiences: []string{"service_lender_origination"},
		}, originationv1connect.NewOriginationServiceClient)
		trackErr("lender-origination", err)
		pc.LenderOrigination = cli
	} else {
		warnSkip("lender-origination")
	}

	// --- Loan Management ---
	if endpoints.LoanMgmtURI != "" {
		cli, err := connection.NewServiceClient(ctx, cfg, common.ServiceTarget{
			Endpoint:  endpoints.LoanMgmtURI,
			Audiences: []string{"service_lender_loans"},
		}, loansv1connect.NewLoanManagementServiceClient)
		trackErr("lender-loan-management", err)
		pc.LenderLoanMgmt = cli
	} else {
		warnSkip("lender-loan-management")
	}

	// --- Savings ---
	if endpoints.SavingsURI != "" {
		cli, err := connection.NewServiceClient(ctx, cfg, common.ServiceTarget{
			Endpoint:  endpoints.SavingsURI,
			Audiences: []string{"service_lender_savings"},
		}, savingsv1connect.NewSavingsServiceClient)
		trackErr("lender-savings", err)
		pc.LenderSavings = cli
	} else {
		warnSkip("lender-savings")
	}

	// --- Ledger ---
	if endpoints.LedgerURI != "" {
		cli, err := connection.NewServiceClient(ctx, cfg, common.ServiceTarget{
			Endpoint:  endpoints.LedgerURI,
			Audiences: []string{"service_ledger"},
		}, ledgerv1connect.NewLedgerServiceClient)
		trackErr("ledger", err)
		pc.LedgerClient = cli
	} else {
		warnSkip("ledger")
	}

	// --- Payment ---
	if endpoints.PaymentURI != "" {
		cli, err := connection.NewServiceClient(ctx, cfg, common.ServiceTarget{
			Endpoint:  endpoints.PaymentURI,
			Audiences: []string{"service_payment"},
		}, paymentv1connect.NewPaymentServiceClient)
		trackErr("payment", err)
		pc.PaymentClient = cli
	} else {
		warnSkip("payment")
	}

	// --- Notification ---
	if endpoints.NotificationURI != "" {
		cli, err := connection.NewServiceClient(ctx, cfg, common.ServiceTarget{
			Endpoint:  endpoints.NotificationURI,
			Audiences: []string{"service_notification"},
		}, notificationv1connect.NewNotificationServiceClient)
		trackErr("notification", err)
		pc.NotificationClient = cli
	} else {
		warnSkip("notification")
	}

	// --- Files ---
	if endpoints.FilesURI != "" {
		cli, err := connection.NewServiceClient(ctx, cfg, common.ServiceTarget{
			Endpoint:  endpoints.FilesURI,
			Audiences: []string{"service_file"},
		}, filesv1connect.NewFilesServiceClient)
		trackErr("files", err)
		pc.FilesClient = cli
	} else {
		warnSkip("files")
	}

	// --- Profile ---
	if endpoints.ProfileURI != "" {
		cli, err := connection.NewServiceClient(ctx, cfg, common.ServiceTarget{
			Endpoint:  endpoints.ProfileURI,
			Audiences: []string{"service_profile"},
		}, profilev1connect.NewProfileServiceClient)
		trackErr("profile", err)
		pc.ProfileClient = cli
	} else {
		warnSkip("profile")
	}

	// --- Partition ---
	if endpoints.PartitionURI != "" {
		cli, err := connection.NewServiceClient(ctx, cfg, common.ServiceTarget{
			Endpoint:  endpoints.PartitionURI,
			Audiences: []string{"service_partition"},
		}, tenancyv1connect.NewTenancyServiceClient)
		trackErr("partition", err)
		pc.TenancyClient = cli
	} else {
		warnSkip("partition")
	}

	return pc, firstErr
}
