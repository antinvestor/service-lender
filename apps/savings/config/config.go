package config

import (
	"github.com/pitabwire/frame/config"
)

type SavingsConfig struct {
	config.ConfigurationDefault

	// Identity service (internal lender service)
	IdentityServiceURI                   string `envDefault:"127.0.0.1:7001"                                 env:"IDENTITY_SERVICE_URI"`
	IdentityServiceWorkloadAPITargetPath string `envDefault:"/ns/fintech/sa/service-identity" env:"IDENTITY_SERVICE_WORKLOAD_API_TARGET_PATH"`
}
