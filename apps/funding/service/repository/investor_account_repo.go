package repository

import (
	"context"
	"fmt"
	"strings"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/funding/service/models"
)

// stateActive is the numeric value for the active state used in database queries.
const stateActive = 3

// sanitizeJSONKey removes any characters that could break JSON structure,
// allowing only alphanumeric characters, hyphens, and underscores.
func sanitizeJSONKey(s string) string {
	var b strings.Builder
	for _, r := range s {
		if (r >= 'a' && r <= 'z') || (r >= 'A' && r <= 'Z') || (r >= '0' && r <= '9') || r == '-' || r == '_' {
			b.WriteRune(r)
		}
	}
	return b.String()
}

// InvestorAccountRepository provides data access for investor accounts.
type InvestorAccountRepository interface {
	datastore.BaseRepository[*models.InvestorAccount]
	GetByInvestorID(ctx context.Context, investorID string) ([]*models.InvestorAccount, error)
	GetEligibleForLoan(
		ctx context.Context,
		currency string,
		interestRate int64,
		amount int64,
		productType string,
		region string,
	) ([]*models.InvestorAccount, error)
	GetAffiliatedForGroup(
		ctx context.Context,
		groupID string,
		currency string,
		interestRate int64,
	) ([]*models.InvestorAccount, error)
}

// NewInvestorAccountRepository creates a new InvestorAccountRepository.
func NewInvestorAccountRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) InvestorAccountRepository {
	return &investorAccountRepository{
		BaseRepository: datastore.NewBaseRepository(ctx, dbPool, workMan, func() *models.InvestorAccount {
			return &models.InvestorAccount{}
		}),
	}
}

type investorAccountRepository struct {
	datastore.BaseRepository[*models.InvestorAccount]
}

func (r *investorAccountRepository) GetByInvestorID(
	ctx context.Context,
	investorID string,
) ([]*models.InvestorAccount, error) {
	var accounts []*models.InvestorAccount
	err := r.Pool().DB(ctx, true).Where("investor_id = ?", investorID).Find(&accounts).Error
	return accounts, err
}

// GetEligibleForLoan returns investor accounts that match the loan criteria.
// Results are ordered by utilization ratio ASC (least-utilized investors first)
// so that idle capital is deployed before heavily-utilized capital, ensuring
// fair rotation across all investors.
func (r *investorAccountRepository) GetEligibleForLoan(
	ctx context.Context,
	currency string,
	interestRate int64,
	amount int64,
	productType string,
	region string,
) ([]*models.InvestorAccount, error) {
	var accounts []*models.InvestorAccount

	db := r.Pool().DB(ctx, true).
		Where("currency = ?", currency).
		Where("state = ?", stateActive).
		Where("min_interest_rate = 0 OR min_interest_rate <= ?", interestRate).
		Where("max_exposure = 0 OR (reserved_balance + ?) <= max_exposure", amount)

	if productType != "" {
		db = db.Where(
			"allowed_products IS NULL OR allowed_products @> ?",
			fmt.Sprintf(`{"%s": true}`, sanitizeJSONKey(productType)),
		)
	}
	if region != "" {
		db = db.Where(
			"allowed_regions IS NULL OR allowed_regions @> ?",
			fmt.Sprintf(`{"%s": true}`, sanitizeJSONKey(region)),
		)
	}

	// Order by utilization ratio ASC: investors whose capital is least deployed
	// get priority. This ensures fair rotation — every investor's money works.
	// Utilization = total_deployed / (available_balance + total_deployed).
	// NULLIF prevents division by zero; COALESCE defaults to 0 for fresh accounts.
	err := db.Order("COALESCE(total_deployed * 1.0 / NULLIF(available_balance + total_deployed, 0), 0) ASC, last_deployed_at ASC NULLS FIRST, available_balance DESC").
		Find(&accounts).
		Error
	return accounts, err
}

// GetAffiliatedForGroup returns investor accounts affiliated with a specific group.
// Ordered by utilization ratio ASC for fair rotation.
func (r *investorAccountRepository) GetAffiliatedForGroup(
	ctx context.Context,
	groupID string,
	currency string,
	interestRate int64,
) ([]*models.InvestorAccount, error) {
	var accounts []*models.InvestorAccount
	err := r.Pool().DB(ctx, true).
		Where("group_affiliations @> ?", fmt.Sprintf(`{"%s": true}`, sanitizeJSONKey(groupID))).
		Where("currency = ?", currency).
		Where("state = ?", stateActive).
		Where("min_interest_rate = 0 OR min_interest_rate <= ?", interestRate).
		Order("COALESCE(total_deployed * 1.0 / NULLIF(available_balance + total_deployed, 0), 0) ASC, last_deployed_at ASC NULLS FIRST, available_balance DESC").
		Find(&accounts).Error
	return accounts, err
}
