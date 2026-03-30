package config

import (
	"github.com/pitabwire/frame/config"
)

type OriginationConfig struct {
	config.ConfigurationDefault

	// Identity service (internal lender service)
	IdentityServiceURI                   string `envDefault:"127.0.0.1:7001"                                 env:"IDENTITY_SERVICE_URI"`
	IdentityServiceWorkloadAPITargetPath string `envDefault:"/ns/lender-identity/sa/service-lender-identity" env:"IDENTITY_SERVICE_WORKLOAD_API_TARGET_PATH"`

	// Loan management service (internal lender service)
	LoanMgmtServiceURI                   string `envDefault:"127.0.0.1:7002"                                   env:"LOANMGMT_SERVICE_URI"`
	LoanMgmtServiceWorkloadAPITargetPath string `envDefault:"/ns/lender-loan-mgmt/sa/service-lender-loan-mgmt" env:"LOANMGMT_SERVICE_WORKLOAD_API_TARGET_PATH"`

	// Profile service (external)
	ProfileServiceURI                   string `envDefault:"127.0.0.1:7005"                 env:"PROFILE_SERVICE_URI"`
	ProfileServiceWorkloadAPITargetPath string `envDefault:"/ns/profile/sa/service-profile" env:"PROFILE_SERVICE_WORKLOAD_API_TARGET_PATH"`

	// Partition service (external)
	TenancyServiceURI                   string `envDefault:"127.0.0.1:7003"              env:"TENANCY_SERVICE_URI"`
	TenancyServiceWorkloadAPITargetPath string `envDefault:"/ns/auth/sa/service-tenancy" env:"TENANCY_SERVICE_WORKLOAD_API_TARGET_PATH"`

	// Business config
	OfferExpiryDays   int `envDefault:"7"  env:"OFFER_EXPIRY_DAYS"`
	MaxDocumentSizeMB int `envDefault:"10" env:"MAX_DOCUMENT_SIZE_MB"`
	DraftExpiryDays   int `envDefault:"30" env:"DRAFT_EXPIRY_DAYS"`
}
