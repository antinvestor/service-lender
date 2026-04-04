package business

import (
	"context"
	"fmt"
	"strings"

	"buf.build/gen/go/antinvestor/field/connectrpc/go/field/v1/fieldv1connect"
	fieldv1 "buf.build/gen/go/antinvestor/field/protocolbuffers/go/field/v1"
	originationv1 "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/origination/service/models"
	"github.com/antinvestor/service-lender/apps/origination/service/repository"
)

// RiskFlag represents a single risk finding from automated assessment.
type RiskFlag struct {
	Code     string // machine-readable code e.g. "NAME_MISMATCH"
	Severity string // "block", "review", "info"
	Message  string // human-readable explanation
}

// RiskAssessmentResult is the outcome of automated risk checks.
type RiskAssessmentResult struct {
	Passed bool       // true if no blocking flags
	Flags  []RiskFlag // all findings, including info-level
}

// RiskAssessor runs automated fraud and data-quality checks on direct
// client loan applications. These checks replace the manual KYC and
// verification workflow — the client was onboarded by an agent, but the
// system still validates factual consistency and fraud signals.
type RiskAssessor struct {
	identityCli fieldv1connect.FieldServiceClient
	appRepo     repository.ApplicationRepository
}

func NewRiskAssessor(
	identityCli fieldv1connect.FieldServiceClient,
	appRepo repository.ApplicationRepository,
) *RiskAssessor {
	return &RiskAssessor{identityCli: identityCli, appRepo: appRepo}
}

// Assess runs all automated checks and returns the result.
// A result with Passed=false means the application should be routed
// to manual review rather than auto-approved.
func (r *RiskAssessor) Assess(ctx context.Context, app *models.Application) RiskAssessmentResult {
	logger := util.Log(ctx).WithField("method", "RiskAssessor.Assess").
		WithField("application_id", app.GetID())

	var flags []RiskFlag

	// 1. Verify client identity data consistency
	if clientFlags := r.checkClientDataConsistency(ctx, app); len(clientFlags) > 0 {
		flags = append(flags, clientFlags...)
	}

	// 2. Check agent onboarding velocity (fraud signal)
	if agentFlags := r.checkAgentOnboardingVelocity(ctx, app); len(agentFlags) > 0 {
		flags = append(flags, agentFlags...)
	}

	// 3. Check for duplicate applications from same client in short window
	if dupeFlags := r.checkRecentApplicationFrequency(ctx, app); len(dupeFlags) > 0 {
		flags = append(flags, dupeFlags...)
	}

	// Determine pass/fail: any "block" severity flag fails the assessment
	passed := true
	for _, f := range flags {
		if f.Severity == "block" || f.Severity == "review" {
			passed = false
			break
		}
	}

	if !passed {
		logger.WithField("flags", len(flags)).Warn("risk assessment flagged issues")
	} else {
		logger.Info("risk assessment passed")
	}

	return RiskAssessmentResult{Passed: passed, Flags: flags}
}

// checkClientDataConsistency verifies that the application's KYC data
// matches the client record in the identity service.
func (r *RiskAssessor) checkClientDataConsistency(ctx context.Context, app *models.Application) []RiskFlag {
	if r.identityCli == nil || app.ClientID == "" {
		return nil
	}

	resp, err := r.identityCli.ClientGet(ctx, connect.NewRequest(&fieldv1.ClientGetRequest{
		Id: app.ClientID,
	}))
	if err != nil {
		return []RiskFlag{{
			Code:     "CLIENT_LOOKUP_FAILED",
			Severity: "review",
			Message:  fmt.Sprintf("could not verify client record: %v", err),
		}}
	}

	client := resp.Msg.GetData()
	var flags []RiskFlag

	// Name mismatch: compare application KYC name against identity record
	if app.KycData != nil {
		kycName, _ := app.KycData["full_name"].(string)
		if kycName != "" && client.GetName() != "" {
			if !namesMatch(kycName, client.GetName()) {
				flags = append(flags, RiskFlag{
					Code:     "NAME_MISMATCH",
					Severity: "review",
					Message: fmt.Sprintf("application name %q does not match identity record %q",
						kycName, client.GetName()),
				})
			}
		}

		// ID number consistency: if KYC has an ID number, verify it matches
		// the identity record's properties
		kycIDNumber, _ := app.KycData["id_number"].(string)
		if kycIDNumber != "" && client.GetProperties() != nil {
			registeredID := ""
			if v := client.GetProperties().GetFields(); v != nil {
				if idField, ok := v["id_number"]; ok {
					registeredID = idField.GetStringValue()
				}
			}
			if registeredID != "" && kycIDNumber != registeredID {
				flags = append(flags, RiskFlag{
					Code:     "ID_NUMBER_MISMATCH",
					Severity: "block",
					Message: fmt.Sprintf("application ID %q does not match registered ID %q",
						kycIDNumber, registeredID),
				})
			}
		}
	}

	// Client state check: must be active
	if client.GetState() != 3 { // StateActive
		flags = append(flags, RiskFlag{
			Code:     "CLIENT_NOT_ACTIVE",
			Severity: "block",
			Message:  fmt.Sprintf("client state is %d, expected active (3)", client.GetState()),
		})
	}

	return flags
}

// checkAgentOnboardingVelocity detects suspicious agent activity.
// If the agent has onboarded an unusually high number of clients in a
// short time window, it may indicate fraudulent bulk registration.
func (r *RiskAssessor) checkAgentOnboardingVelocity(ctx context.Context, app *models.Application) []RiskFlag {
	if r.identityCli == nil || app.AgentID == "" {
		return nil
	}

	// Search for clients onboarded by this agent
	stream, err := r.identityCli.ClientSearch(ctx, connect.NewRequest(
		(&fieldv1.ClientSearchRequest_builder{
			AgentId: app.AgentID,
		}).Build(),
	))
	if err != nil {
		return nil // can't check, skip
	}
	defer stream.Close()

	// Count how many clients this agent has — if the service returns a large
	// batch we stop counting at the threshold.
	const velocityThreshold = 50
	clientCount := 0
	for stream.Receive() {
		resp := stream.Msg()
		clientCount += len(resp.GetData())
		if clientCount >= velocityThreshold {
			break
		}
	}

	// A high client count alone isn't proof of fraud — it's an info-level
	// signal that can be combined with other factors.
	if clientCount >= velocityThreshold {
		return []RiskFlag{{
			Code:     "AGENT_HIGH_ONBOARDING_VOLUME",
			Severity: "info",
			Message: fmt.Sprintf("agent %s has onboarded %d+ clients — verify legitimacy",
				app.AgentID, clientCount),
		}}
	}

	return nil
}

// checkRecentApplicationFrequency detects clients who have had multiple
// recent terminal applications (cancelled, declined, rejected) which
// may indicate application cycling or fraud.
func (r *RiskAssessor) checkRecentApplicationFrequency(ctx context.Context, app *models.Application) []RiskFlag {
	if app.ClientID == "" {
		return nil
	}

	// Count recent rejected/cancelled applications
	recentTerminalStatuses := []int32{
		int32(originationv1.ApplicationStatus_APPLICATION_STATUS_CANCELLED),
		int32(originationv1.ApplicationStatus_APPLICATION_STATUS_REJECTED),
		int32(originationv1.ApplicationStatus_APPLICATION_STATUS_OFFER_DECLINED),
	}

	query := data.NewSearchQuery(
		data.WithSearchFiltersAndByValue(map[string]any{
			"client_id = ?": app.ClientID,
			"status IN (?)": recentTerminalStatuses,
		}),
		data.WithSearchLimit(10),
	)

	results, err := r.appRepo.Search(ctx, query)
	if err != nil {
		return nil
	}

	count := 0
	_ = workerpoolConsumeStream(ctx, results, func(batch []*models.Application) error {
		count += len(batch)
		return nil
	})

	const frequencyThreshold = 3
	if count >= frequencyThreshold {
		return []RiskFlag{{
			Code:     "HIGH_APPLICATION_REJECTION_RATE",
			Severity: "review",
			Message: fmt.Sprintf("client has %d rejected/cancelled applications recently",
				count),
		}}
	}

	return nil
}

// namesMatch does a case-insensitive comparison of two names, accounting
// for minor variations in whitespace and ordering.
func namesMatch(a, b string) bool {
	a = strings.ToLower(strings.TrimSpace(a))
	b = strings.ToLower(strings.TrimSpace(b))

	if a == b {
		return true
	}

	// Compare sorted word sets to handle name reordering
	// e.g. "John Doe" vs "Doe John"
	aParts := strings.Fields(a)
	bParts := strings.Fields(b)

	if len(aParts) != len(bParts) {
		return false
	}

	aSet := make(map[string]int, len(aParts))
	for _, p := range aParts {
		aSet[p]++
	}
	for _, p := range bParts {
		aSet[p]--
	}
	for _, v := range aSet {
		if v != 0 {
			return false
		}
	}

	return true
}
