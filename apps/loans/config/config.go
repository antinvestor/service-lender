package config

import (
	"github.com/pitabwire/frame/config"
)

type LoanManagementConfig struct {
	config.ConfigurationDefault
	OriginationServiceURI                    string `envDefault:"127.0.0.1:7010"                           env:"ORIGINATION_SERVICE_URI"`
	OriginationServiceWorkloadAPITargetPath  string `envDefault:"/ns/origination/sa/service-origination"   env:"ORIGINATION_SERVICE_WORKLOAD_API_TARGET_PATH"`
	IdentityServiceURI                       string `envDefault:"127.0.0.1:7001"                           env:"IDENTITY_SERVICE_URI"`
	IdentityServiceWorkloadAPITargetPath     string `envDefault:"/ns/identity/sa/service-identity"         env:"IDENTITY_SERVICE_WORKLOAD_API_TARGET_PATH"`
	LedgerServiceURI                         string `envDefault:"127.0.0.1:7020"                           env:"LEDGER_SERVICE_URI"`
	LedgerServiceWorkloadAPITargetPath       string `envDefault:"/ns/ledger/sa/service-ledger"             env:"LEDGER_SERVICE_WORKLOAD_API_TARGET_PATH"`
	PaymentServiceURI                        string `envDefault:"127.0.0.1:7030"                           env:"PAYMENT_SERVICE_URI"`
	PaymentServiceWorkloadAPITargetPath      string `envDefault:"/ns/payment/sa/service-payment"           env:"PAYMENT_SERVICE_WORKLOAD_API_TARGET_PATH"`
	NotificationServiceURI                   string `envDefault:"127.0.0.1:7040"                           env:"NOTIFICATION_SERVICE_URI"`
	NotificationServiceWorkloadAPITargetPath string `envDefault:"/ns/notification/sa/service-notification" env:"NOTIFICATION_SERVICE_WORKLOAD_API_TARGET_PATH"`
	TrustageServiceURI                       string `envDefault:"127.0.0.1:7050"                           env:"TRUSTAGE_SERVICE_URI"`
	TrustageServiceWorkloadAPITargetPath     string `envDefault:"/ns/trustage/sa/service-trustage"         env:"TRUSTAGE_SERVICE_WORKLOAD_API_TARGET_PATH"`
	ProfileServiceURI                        string `envDefault:"127.0.0.1:7005"                           env:"PROFILE_SERVICE_URI"`
	ProfileServiceWorkloadAPITargetPath      string `envDefault:"/ns/profile/sa/service-profile"           env:"PROFILE_SERVICE_WORKLOAD_API_TARGET_PATH"`
	TenancyServiceURI                        string `envDefault:"127.0.0.1:7003"                           env:"TENANCY_SERVICE_URI"`
	TenancyServiceWorkloadAPITargetPath      string `envDefault:"/ns/auth/sa/service-tenancy"              env:"TENANCY_SERVICE_WORKLOAD_API_TARGET_PATH"`
	OperationsServiceURI                     string `envDefault:"127.0.0.1:7060"                           env:"OPERATIONS_SERVICE_URI"`
	OperationsServiceWorkloadAPITargetPath   string `envDefault:"/ns/fintech/sa/service-stawi"             env:"OPERATIONS_SERVICE_WORKLOAD_API_TARGET_PATH"`

	DefaultGracePeriodDays   int `envDefault:"3"  env:"DEFAULT_GRACE_PERIOD_DAYS"`
	DelinquencyThresholdDays int `envDefault:"7"  env:"DELINQUENCY_THRESHOLD_DAYS"`
	DefaultThresholdDays     int `envDefault:"90" env:"DEFAULT_THRESHOLD_DAYS"`
}
