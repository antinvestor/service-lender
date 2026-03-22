package reconciliation

import (
	"context"
	"fmt"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/frame/workerpool"
	"github.com/pitabwire/util"

	groupmodels "github.com/antinvestor/service-lender/apps/group/service/models"
	grouprepo "github.com/antinvestor/service-lender/apps/group/service/repository"
	opsmodels "github.com/antinvestor/service-lender/apps/operations/service/models"
	opsrepo "github.com/antinvestor/service-lender/apps/operations/service/repository"
	"github.com/antinvestor/service-lender/pkg/constants"
)

// Discrepancy represents a balance mismatch.
type Discrepancy struct {
	AccountRef      string
	OwnerID         string
	OwnerType       string
	ExpectedBalance int64 // sum of transfer orders
	ActualBalance   int64 // from ledger/savings service
	Difference      int64
	Currency        string
}

// ReconciliationResult summarizes a reconciliation run.
type ReconciliationResult struct {
	TotalAccounts   int
	MatchedAccounts int
	Discrepancies   []Discrepancy
	Errors          []string
}

// Reconciler performs balance reconciliation.
type Reconciler struct {
	toRepo  opsrepo.TransferOrderRepository
	arRepo  opsrepo.AccountRefRepository
	memRepo grouprepo.MembershipRepository
	grpRepo grouprepo.CustomerGroupRepository
}

func NewReconciler(
	toRepo opsrepo.TransferOrderRepository,
	arRepo opsrepo.AccountRefRepository,
	memRepo grouprepo.MembershipRepository,
	grpRepo grouprepo.CustomerGroupRepository,
) *Reconciler {
	return &Reconciler{
		toRepo:  toRepo,
		arRepo:  arRepo,
		memRepo: memRepo,
		grpRepo: grpRepo,
	}
}

// ReconcileGroup performs balance reconciliation for all accounts in a group.
func (r *Reconciler) ReconcileGroup(ctx context.Context, groupID string) (*ReconciliationResult, error) {
	logger := util.Log(ctx).WithField("method", "Reconciler.ReconcileGroup").WithField("group_id", groupID)
	result := &ReconciliationResult{}

	// Get all members in the group
	members, err := r.memRepo.GetByGroupID(ctx, groupID)
	if err != nil {
		return nil, fmt.Errorf("could not get group members: %w", err)
	}

	// For each member, reconcile their accounts
	for _, member := range members {
		memberAccounts := []string{
			constants.MemberSuspenseAccount(member.GetID()),
			constants.MemberLendingAccount(member.GetID()),
			constants.MemberPeriodicSavingsAccount(member.GetID()),
			constants.MemberLoansAccount(member.GetID()),
		}

		for _, accountName := range memberAccounts {
			result.TotalAccounts++

			// Calculate expected balance from transfer orders
			expectedBalance, calcErr := r.calculateExpectedBalance(ctx, accountName)
			if calcErr != nil {
				result.Errors = append(result.Errors,
					fmt.Sprintf("account %s: could not calculate expected balance: %v", accountName, calcErr))
				continue
			}

			// TODO: Get actual balance from Ledger service
			// For now, we record the expected balance
			result.MatchedAccounts++ // placeholder until ledger integration
			_ = expectedBalance
		}
	}

	// Reconcile group-level accounts
	groupAccounts := []string{
		constants.GroupBankAccount(groupID),
		constants.GroupPenaltyIncomeAccount(groupID),
		constants.GroupInterestIncomeAccount(groupID),
		constants.GroupJoiningFeeAccount(groupID),
		constants.GroupTransactionCostsAccount(groupID),
		constants.GroupServiceFeeAccount(groupID),
		constants.GroupSavingsInterestIncomeAccount(groupID),
	}

	for _, accountName := range groupAccounts {
		result.TotalAccounts++
		expectedBalance, calcErr := r.calculateExpectedBalance(ctx, accountName)
		if calcErr != nil {
			result.Errors = append(result.Errors,
				fmt.Sprintf("account %s: could not calculate expected balance: %v", accountName, calcErr))
			continue
		}
		result.MatchedAccounts++
		_ = expectedBalance
	}

	logger.WithField("total_accounts", result.TotalAccounts).
		WithField("matched", result.MatchedAccounts).
		WithField("discrepancies", len(result.Discrepancies)).
		Info("reconciliation complete")

	return result, nil
}

// calculateExpectedBalance sums all transfer orders that debit or credit an account.
// Balance = sum(credits) - sum(debits).
func (r *Reconciler) calculateExpectedBalance(ctx context.Context, accountRef string) (int64, error) {
	var totalCredits int64
	var totalDebits int64

	// Search for orders where this account is credited
	creditQuery := data.NewSearchQuery(
		data.WithSearchFiltersAndByValue(map[string]any{
			"credit_account_ref = ?": accountRef,
			"state = ?":              int32(constants.StateInactive), // completed orders only
		}),
	)
	creditResults, err := r.toRepo.Search(ctx, creditQuery)
	if err != nil {
		return 0, fmt.Errorf("credit search failed: %w", err)
	}

	err = workerpool.ConsumeResultStream(ctx, creditResults, func(batch []*opsmodels.TransferOrder) error {
		for _, order := range batch {
			totalCredits += order.Amount
		}
		return nil
	})
	if err != nil {
		return 0, fmt.Errorf("credit consume failed: %w", err)
	}

	// Search for orders where this account is debited
	debitQuery := data.NewSearchQuery(
		data.WithSearchFiltersAndByValue(map[string]any{
			"debit_account_ref = ?": accountRef,
			"state = ?":             int32(constants.StateInactive),
		}),
	)
	debitResults, err := r.toRepo.Search(ctx, debitQuery)
	if err != nil {
		return 0, fmt.Errorf("debit search failed: %w", err)
	}

	err = workerpool.ConsumeResultStream(ctx, debitResults, func(batch []*opsmodels.TransferOrder) error {
		for _, order := range batch {
			totalDebits += order.Amount
		}
		return nil
	})
	if err != nil {
		return 0, fmt.Errorf("debit consume failed: %w", err)
	}

	return totalCredits - totalDebits, nil
}

// ReconcileAllActiveGroups runs reconciliation across all active groups.
func (r *Reconciler) ReconcileAllActiveGroups(ctx context.Context) ([]*ReconciliationResult, error) {
	logger := util.Log(ctx).WithField("method", "Reconciler.ReconcileAllActiveGroups")

	// Search for all active groups
	query := data.NewSearchQuery(
		data.WithSearchFiltersAndByValue(map[string]any{
			"state = ?": int32(constants.StateActive),
		}),
	)
	groupResults, err := r.grpRepo.Search(ctx, query)
	if err != nil {
		return nil, fmt.Errorf("could not search active groups: %w", err)
	}

	var results []*ReconciliationResult
	err = workerpool.ConsumeResultStream(ctx, groupResults, func(batch []*groupmodels.CustomerGroup) error {
		for _, group := range batch {
			result, reconcileErr := r.ReconcileGroup(ctx, group.GetID())
			if reconcileErr != nil {
				logger.WithError(reconcileErr).WithField("group_id", group.GetID()).
					Error("reconciliation failed for group")
				continue
			}
			results = append(results, result)
		}
		return nil
	})
	if err != nil {
		return nil, fmt.Errorf("could not consume group results: %w", err)
	}

	logger.WithField("groups_reconciled", len(results)).Info("all-groups reconciliation complete")
	return results, nil
}
