package business

import (
	"context"
	"fmt"
	"time"

	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/funding/service/events"
	"github.com/antinvestor/service-lender/apps/funding/service/models"
	"github.com/antinvestor/service-lender/apps/funding/service/repository"
	"github.com/antinvestor/service-lender/pkg/constants"
)

type investorAccountBusiness struct {
	eventsMan fevents.Manager
	iaRepo    repository.InvestorAccountRepository
}

func NewInvestorAccountBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	iaRepo repository.InvestorAccountRepository,
) InvestorAccountBusiness {
	return &investorAccountBusiness{eventsMan: eventsMan, iaRepo: iaRepo}
}

func (b *investorAccountBusiness) Create(
	ctx context.Context,
	account *models.InvestorAccount,
) (*models.InvestorAccount, error) {
	logger := util.Log(ctx).WithField("method", "InvestorAccountBusiness.Create")

	account.State = int32(constants.StateActive)
	account.GenID(ctx)

	if err := b.eventsMan.Emit(ctx, events.InvestorAccountSaveEvent, account); err != nil {
		logger.WithError(err).Error("could not create investor account")
		return nil, fmt.Errorf("create investor account: %w", err)
	}

	logger.WithField("account_id", account.GetID()).Info("investor account created")
	return account, nil
}

func (b *investorAccountBusiness) Get(
	ctx context.Context,
	accountID string,
) (*models.InvestorAccount, error) {
	return b.iaRepo.GetByID(ctx, accountID)
}

func (b *investorAccountBusiness) GetByInvestorID(
	ctx context.Context,
	investorID string,
) ([]*models.InvestorAccount, error) {
	return b.iaRepo.GetByInvestorID(ctx, investorID)
}

func (b *investorAccountBusiness) Deposit(
	ctx context.Context,
	accountID string,
	amount int64,
) error {
	logger := util.Log(ctx).WithField("method", "InvestorAccountBusiness.Deposit")

	if amount <= 0 {
		return fmt.Errorf("deposit amount must be positive, got %d", amount)
	}

	account, err := b.iaRepo.GetByID(ctx, accountID)
	if err != nil {
		return fmt.Errorf("investor account not found: %w", err)
	}

	account.AvailableBalance += amount

	if err = b.eventsMan.Emit(ctx, events.InvestorAccountSaveEvent, account); err != nil {
		logger.WithError(err).Error("could not update investor account after deposit")
		return fmt.Errorf("deposit: %w", err)
	}

	logger.WithFields(map[string]any{"account_id": accountID, "amount": amount}).Info("deposit processed")
	return nil
}

func (b *investorAccountBusiness) Withdraw(
	ctx context.Context,
	accountID string,
	amount int64,
) error {
	logger := util.Log(ctx).WithField("method", "InvestorAccountBusiness.Withdraw")

	if amount <= 0 {
		return fmt.Errorf("withdrawal amount must be positive, got %d", amount)
	}

	account, err := b.iaRepo.GetByID(ctx, accountID)
	if err != nil {
		return fmt.Errorf("investor account not found: %w", err)
	}

	available := account.AvailableBalance - account.ReservedBalance
	if amount > available {
		return fmt.Errorf("insufficient available balance: requested %d, available %d", amount, available)
	}

	account.AvailableBalance -= amount

	if err = b.eventsMan.Emit(ctx, events.InvestorAccountSaveEvent, account); err != nil {
		logger.WithError(err).Error("could not update investor account after withdrawal")
		return fmt.Errorf("withdraw: %w", err)
	}

	logger.WithFields(map[string]any{"account_id": accountID, "amount": amount}).Info("withdrawal processed")
	return nil
}

func (b *investorAccountBusiness) GetAvailable(
	ctx context.Context,
	accountID string,
) (int64, error) {
	account, err := b.iaRepo.GetByID(ctx, accountID)
	if err != nil {
		return 0, fmt.Errorf("investor account not found: %w", err)
	}

	available := account.AvailableBalance - account.ReservedBalance
	if available < 0 {
		available = 0
	}
	return available, nil
}

// ReserveBalance increases the reserved balance for an investor account
// when capital is committed to a loan.
func (b *investorAccountBusiness) ReserveBalance(
	ctx context.Context,
	accountID string,
	amount int64,
) error {
	if amount <= 0 {
		return nil
	}

	account, err := b.iaRepo.GetByID(ctx, accountID)
	if err != nil {
		return fmt.Errorf("investor account not found: %w", err)
	}

	account.ReservedBalance += amount
	account.TotalDeployed += amount
	now := time.Now()
	account.LastDeployedAt = &now

	return b.eventsMan.Emit(ctx, events.InvestorAccountSaveEvent, account)
}

// ReleaseBalance decreases reserved balance and optionally returns capital
// when a loan is repaid.
func (b *investorAccountBusiness) ReleaseBalance(
	ctx context.Context,
	accountID string,
	principalReturned int64,
	interestEarned int64,
) error {
	account, err := b.iaRepo.GetByID(ctx, accountID)
	if err != nil {
		return fmt.Errorf("investor account not found: %w", err)
	}

	if principalReturned > 0 {
		account.ReservedBalance -= principalReturned
		if account.ReservedBalance < 0 {
			account.ReservedBalance = 0
		}
		account.AvailableBalance += principalReturned
	}

	account.TotalReturned += principalReturned + interestEarned
	if interestEarned > 0 {
		account.AvailableBalance += interestEarned
	}

	return b.eventsMan.Emit(ctx, events.InvestorAccountSaveEvent, account)
}

// AbsorbLoss records a loss against an investor account.
func (b *investorAccountBusiness) AbsorbLoss(
	ctx context.Context,
	accountID string,
	lossAmount int64,
) error {
	if lossAmount <= 0 {
		return nil
	}

	account, err := b.iaRepo.GetByID(ctx, accountID)
	if err != nil {
		return fmt.Errorf("investor account not found: %w", err)
	}

	// Reduce reserved balance (the loan is being written off)
	account.ReservedBalance -= lossAmount
	if account.ReservedBalance < 0 {
		account.ReservedBalance = 0
	}

	return b.eventsMan.Emit(ctx, events.InvestorAccountSaveEvent, account)
}
