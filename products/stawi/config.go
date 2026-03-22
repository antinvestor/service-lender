package stawi

// ProductConfig defines SACCO/Grameen-model product configuration.
// These are product-level defaults that can be overridden per group.
type ProductConfig struct {
	// Group formation
	MinGroupSize int32 `envDefault:"5"  env:"STAWI_MIN_GROUP_SIZE"`
	MaxGroupSize int32 `envDefault:"50" env:"STAWI_MAX_GROUP_SIZE"`

	// Tenure and periods
	GroupLifeDuration int32  `envDefault:"52"     env:"STAWI_GROUP_LIFE_DURATION"` // periods per tenure
	PeriodType        string `envDefault:"WEEKLY" env:"STAWI_PERIOD_TYPE"`

	// Leverage
	MinLeverage int64 `envDefault:"190" env:"STAWI_MIN_LEVERAGE"` // basis points (1.90x)
	MaxLeverage int64 `envDefault:"220" env:"STAWI_MAX_LEVERAGE"` // basis points (2.20x)

	// Loan terms
	LoanInterestRatePA  int64 `envDefault:"2400" env:"STAWI_LOAN_INTEREST_RATE"`  // basis points (24%)
	LoanInsuranceRate   int64 `envDefault:"0"    env:"STAWI_LOAN_INSURANCE_RATE"` // basis points
	LoanTenurePeriods   int32 `envDefault:"4"    env:"STAWI_LOAN_TENURE_PERIODS"`
	LoanGracePeriod     int32 `envDefault:"1"    env:"STAWI_LOAN_GRACE_PERIOD"`
	LoanMaturityPeriods int32 `envDefault:"4"    env:"STAWI_LOAN_MATURITY_PERIODS"`

	// Savings
	RegistrationFee int64 `envDefault:"0" env:"STAWI_REGISTRATION_FEE"` // minor units

	// Fees
	ServiceFeePercentage int64 `envDefault:"1000" env:"STAWI_SERVICE_FEE_PCT"` // basis points (10%)

	// Penalties (escalating fine tiers, basis points)
	LateFineRate1 int64 `envDefault:"1000" env:"STAWI_LATE_FINE_1"` // 10%
	LateFineRate2 int64 `envDefault:"2000" env:"STAWI_LATE_FINE_2"` // 20%
	LateFineRate3 int64 `envDefault:"3000" env:"STAWI_LATE_FINE_3"` // 30%

	// Funding proportions (basis points, must sum to 10000)
	FundingInternalSavings int64 `envDefault:"6500" env:"STAWI_FUNDING_INTERNAL"` // 65%
	FundingInternalExtra   int64 `envDefault:"2000" env:"STAWI_FUNDING_EXTRA"`    // 20%
	FundingExternalLending int64 `envDefault:"1500" env:"STAWI_FUNDING_EXTERNAL"` // 15%
}

// FineRates returns the escalating fine rates as a slice.
func (c *ProductConfig) FineRates() []int64 {
	return []int64{c.LateFineRate1, c.LateFineRate2, c.LateFineRate3}
}
