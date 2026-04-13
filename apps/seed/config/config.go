package config

import (
	"github.com/pitabwire/frame/config"
)

// SeedConfig is the service configuration for the seed direct-to-client
// lending product. Seed composes existing platform services rather than
// duplicating primitives: identity provides KYC and client lookup,
// loans owns loan requests, loan accounts, and repayment history,
// operations issues the transfer orders, and the ledger keeps the
// double-entry record.
type SeedConfig struct {
	config.ConfigurationDefault

	// Identity service — used to verify KYC and resolve client identities.
	IdentityServiceURI                   string `envDefault:"127.0.0.1:7001"                  env:"IDENTITY_SERVICE_URI"`
	IdentityServiceWorkloadAPITargetPath string `envDefault:"/ns/fintech/sa/service-identity" env:"IDENTITY_SERVICE_WORKLOAD_API_TARGET_PATH"`

	// Loans service — used to create loan requests, loan accounts, trigger
	// disbursement, and observe paid-off transitions that feed the credit profile.
	LoanMgmtServiceURI                   string `envDefault:"127.0.0.1:7011"                 env:"LOAN_MGMT_SERVICE_URI"`
	LoanMgmtServiceWorkloadAPITargetPath string `envDefault:"/ns/loans/sa/service-loan-mgmt" env:"LOAN_MGMT_SERVICE_WORKLOAD_API_TARGET_PATH"`

	// Operations service — used to provision client suspense accounts
	// at first-loan-request time.
	OperationsServiceURI                   string `envDefault:"127.0.0.1:7060"                    env:"OPERATIONS_SERVICE_URI"`
	OperationsServiceWorkloadAPITargetPath string `envDefault:"/ns/fintech/sa/service-operations" env:"OPERATIONS_SERVICE_WORKLOAD_API_TARGET_PATH"`

	// Tenancy service.
	TenancyServiceURI                   string `envDefault:"127.0.0.1:7003"              env:"TENANCY_SERVICE_URI"`
	TenancyServiceWorkloadAPITargetPath string `envDefault:"/ns/auth/sa/service-tenancy" env:"TENANCY_SERVICE_WORKLOAD_API_TARGET_PATH"`
}
