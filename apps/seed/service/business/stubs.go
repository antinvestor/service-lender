package business

import (
	"context"

	"github.com/pitabwire/util"
)

// AlwaysVerifiedKYC is a placeholder KYCVerifier that treats every
// client as KYC-verified. It is intentionally simple so the seed
// cmd/main.go can boot in development without needing a real identity
// integration wired up.
//
// PRODUCTION DEPLOYMENTS MUST REPLACE THIS. Seed refuses to make any
// credit decisions without a verified KYC status, and a real verifier
// belongs behind the identity service's ClientDataList RPC checking
// for the specific document types the deployment's KYC checklist
// requires.
type AlwaysVerifiedKYC struct{}

// VerifyClient returns KYCStatusVerified for every client.
func (AlwaysVerifiedKYC) VerifyClient(ctx context.Context, clientID string) (KYCStatus, error) {
	util.Log(ctx).
		WithField("method", "AlwaysVerifiedKYC.VerifyClient").
		WithField("client_id", clientID).
		Warn("stub KYCVerifier in use; replace with real identity integration before production")
	return KYCStatusVerified, nil
}

// StubLoanCreator is a placeholder LoanCreator that records the intent
// of each stage without actually calling the upstream loans service.
// It returns synthetic ids the seed business layer can persist on the
// LoanRequest row so the audit trail is complete.
//
// PRODUCTION DEPLOYMENTS MUST REPLACE THIS with a real implementation
// backed by loansv1connect.LoanManagementServiceClient, chained through
// LoanRequestSave → LoanRequestApprove → LoanAccountCreate →
// DisbursementCreate.
type StubLoanCreator struct{}

// CreateApplication records the intent of creating an application and
// returns a synthetic id.
func (StubLoanCreator) CreateApplication(
	ctx context.Context,
	req LoanCreationRequest,
) (string, error) {
	util.Log(ctx).
		WithField("method", "StubLoanCreator.CreateApplication").
		WithField("client_id", req.ClientID).
		WithField("amount", req.Amount).
		Warn("stub LoanCreator in use; no application actually created")
	return "stub-application-" + req.IdempotencyKey, nil
}

// CreateLoanAccount records the intent of creating a loan account and
// returns a synthetic id.
func (StubLoanCreator) CreateLoanAccount(
	ctx context.Context,
	applicationID string,
) (string, error) {
	util.Log(ctx).
		WithField("method", "StubLoanCreator.CreateLoanAccount").
		WithField("application_id", applicationID).
		Warn("stub LoanCreator in use; no loan account actually created")
	return "stub-loan-" + applicationID, nil
}

// Disburse records the intent of disbursing and returns a synthetic id.
func (StubLoanCreator) Disburse(
	ctx context.Context,
	loanAccountID string,
	idempotencyKey string,
) (string, error) {
	util.Log(ctx).
		WithField("method", "StubLoanCreator.Disburse").
		WithField("loan_account_id", loanAccountID).
		Warn("stub LoanCreator in use; no disbursement actually executed")
	return "stub-disb-" + idempotencyKey, nil
}
