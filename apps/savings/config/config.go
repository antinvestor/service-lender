package config

import (
	"github.com/pitabwire/frame/config"
)

type SavingsConfig struct {
	config.ConfigurationDefault

	// Identity service (internal lender service)
	IdentityServiceURI                   string `envDefault:"127.0.0.1:7001"                  env:"IDENTITY_SERVICE_URI"`
	IdentityServiceWorkloadAPITargetPath string `envDefault:"/ns/fintech/sa/service-identity" env:"IDENTITY_SERVICE_WORKLOAD_API_TARGET_PATH"`

	// Operations service: the gateway through which all ledger postings are
	// made. Every deposit and withdrawal issues a transfer order against this
	// service so the double-entry ledger mirrors the savings state.
	OperationsServiceURI                   string `envDefault:"127.0.0.1:7060"                    env:"OPERATIONS_SERVICE_URI"`
	OperationsServiceWorkloadAPITargetPath string `envDefault:"/ns/fintech/sa/service-operations" env:"OPERATIONS_SERVICE_WORKLOAD_API_TARGET_PATH"`
}
