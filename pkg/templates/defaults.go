// Package templates defines the default notification templates used by
// the fintech platform. These templates are registered with the
// notification service on startup if they don't already exist.
package templates

// Template represents a notification template definition.
type Template struct {
	Name        string
	Subject     string
	Body        string
	Category    string // "agent", "loan", "origination", "savings", "system"
	Description string // human-readable description for the management UI
}

// Defaults returns all notification templates the fintech platform requires.
func Defaults() []Template {
	var all []Template
	all = append(all, agentTemplates()...)
	all = append(all, loanTemplates()...)
	all = append(all, originationTemplates()...)
	all = append(all, savingsTemplates()...)
	all = append(all, workflowTemplates()...)
	all = append(all, systemTemplates()...)
	return all
}

func agentTemplates() []Template {
	return []Template{
		// ── Agent Onboarding ─────────────────────────────────────────────
		{
			Name:        "template.fintech.agent.onboarding",
			Subject:     "Welcome — Accept Terms & Conditions",
			Body:        "Hello {{.agent_name}},\n\nYou have been registered as an agent on the lending platform. To activate your account, please log in and accept the Terms & Conditions.\n\nAgent ID: {{.agent_id}}\n\nIf you did not expect this invitation, please contact your administrator.",
			Category:    "agent",
			Description: "Sent when a new agent is created. Contains T&C acceptance invitation.",
		},
		{
			Name:        "template.fintech.agent.activated",
			Subject:     "Agent Account Activated",
			Body:        "Hello {{.agent_name}},\n\nYour agent account has been successfully activated. You now have full access to the lending platform.\n\nYou can begin onboarding clients and processing applications.",
			Category:    "agent",
			Description: "Sent when an agent accepts T&C and their account becomes active.",
		},
		{
			Name:        "template.fintech.agent.deactivated",
			Subject:     "Agent Account Deactivated",
			Body:        "Hello {{.agent_name}},\n\nYour agent account has been deactivated. If you believe this is an error, please contact your branch manager.",
			Category:    "agent",
			Description: "Sent when an agent account is deactivated by an administrator.",
		},
	}
}

func loanTemplates() []Template {
	return []Template{
		{
			Name:        "loan_approved",
			Subject:     "Loan Application Approved",
			Body:        "Your loan of {{.loan_amount}} {{.currency}} has been approved. The funds will be disbursed to your registered account shortly.",
			Category:    "loan",
			Description: "Sent to the borrower when their loan application is approved.",
		},
		{
			Name:        "repayment_received",
			Subject:     "Repayment Received",
			Body:        "Your repayment of {{.amount}} {{.currency}} has been received. Remaining balance: {{.remaining_balance}} {{.currency}}.",
			Category:    "loan",
			Description: "Sent to the borrower when a loan repayment is recorded.",
		},
		{
			Name:        "loan_fully_paid",
			Subject:     "Loan Fully Repaid",
			Body:        "Congratulations! Your loan has been fully repaid. Thank you for your commitment to timely repayment.",
			Category:    "loan",
			Description: "Sent to the borrower when their loan is fully paid off.",
		},
		{
			Name:        "template.fintech.loan.disbursed",
			Subject:     "Loan Disbursed",
			Body:        "Your loan of {{.amount}} {{.currency}} has been disbursed to your account. Ref: {{.reference}}. Your first repayment is due on {{.first_payment_date}}.",
			Category:    "loan",
			Description: "Sent to the borrower when the loan amount is disbursed.",
		},
		{
			Name:        "template.fintech.loan.overdue",
			Subject:     "Loan Payment Overdue",
			Body:        "Your loan payment of {{.amount}} {{.currency}} was due on {{.due_date}} and has not been received. Please make the payment at your earliest convenience to avoid penalties.",
			Category:    "loan",
			Description: "Sent when a loan repayment is overdue.",
		},
		{
			Name:        "template.fintech.loan.penalty",
			Subject:     "Penalty Applied to Loan",
			Body:        "A penalty of {{.penalty_amount}} {{.currency}} has been applied to your loan account due to {{.reason}}. Total outstanding: {{.total_outstanding}} {{.currency}}.",
			Category:    "loan",
			Description: "Sent when a penalty is applied to a loan account.",
		},
	}
}

func originationTemplates() []Template {
	return []Template{
		{
			Name:        "application_under_review",
			Subject:     "Application Under Review",
			Body:        "Your loan application has been submitted and is currently under review. We will notify you once a decision has been made.",
			Category:    "origination",
			Description: "Sent to the applicant when their application is submitted for review.",
		},
		{
			Name:        "template.fintech.application.verified",
			Subject:     "Application Verification Complete",
			Body:        "Your loan application has passed verification and is now being reviewed by our underwriting team.",
			Category:    "origination",
			Description: "Sent when application verification is completed successfully.",
		},
		{
			Name:        "template.fintech.application.rejected",
			Subject:     "Application Not Approved",
			Body:        "We regret to inform you that your loan application was not approved at this time. Reason: {{.reason}}. You may re-apply after {{.reapply_period}}.",
			Category:    "origination",
			Description: "Sent when a loan application is rejected during underwriting.",
		},
		{
			Name:        "template.fintech.loan_terms.generated",
			Subject:     "Loan Terms Available",
			Body:        "Approved loan terms of {{.amount}} {{.currency}} at {{.interest_rate}}% interest for {{.term_days}} days are ready for your review. Please accept or decline the terms.",
			Category:    "origination",
			Description: "Sent when approved loan request terms are ready for the applicant.",
		},
	}
}

func savingsTemplates() []Template {
	return []Template{
		{
			Name:        "template.fintech.savings.deposit",
			Subject:     "Deposit Received",
			Body:        "A deposit of {{.amount}} {{.currency}} has been credited to your savings account. New balance: {{.balance}} {{.currency}}.",
			Category:    "savings",
			Description: "Sent when a deposit is made to a savings account.",
		},
		{
			Name:        "template.fintech.savings.withdrawal",
			Subject:     "Withdrawal Processed",
			Body:        "A withdrawal of {{.amount}} {{.currency}} has been processed from your savings account. Remaining balance: {{.balance}} {{.currency}}.",
			Category:    "savings",
			Description: "Sent when a withdrawal is made from a savings account.",
		},
	}
}

func workflowTemplates() []Template {
	return []Template{
		{
			Name:        "template.fintech.case.verification_required",
			Subject:     "Verification Required: {{.case_type_label}}",
			Body:        "Case {{.case_id}} requires verification before it can proceed.\n\nSummary: {{.summary}}\nSubject: {{.subject_type}} {{.subject_id}}\nRequested by: {{.requested_by}}\nRequested value: {{.requested_value}}\nComment: {{.comment}}",
			Category:    "workflow",
			Description: "Sent to verifiers when a reusable approval case is created and requires verification.",
		},
		{
			Name:        "template.fintech.case.approval_required",
			Subject:     "Approval Required: {{.case_type_label}}",
			Body:        "Case {{.case_id}} is ready for approval.\n\nSummary: {{.summary}}\nSubject: {{.subject_type}} {{.subject_id}}\nRequested by: {{.requested_by}}\nRequested value: {{.requested_value}}\nComment: {{.comment}}",
			Category:    "workflow",
			Description: "Sent to approvers when a reusable approval case is ready for approval.",
		},
		{
			Name:        "template.fintech.case.approved",
			Subject:     "Case Approved: {{.case_type_label}}",
			Body:        "Your case {{.case_id}} has been approved and the requested change has now been actualized.\n\nSummary: {{.summary}}\nSubject: {{.subject_type}} {{.subject_id}}\nRequested value: {{.requested_value}}",
			Category:    "workflow",
			Description: "Sent to the requester when a reusable approval case is approved.",
		},
		{
			Name:        "template.fintech.case.rejected",
			Subject:     "Case Rejected: {{.case_type_label}}",
			Body:        "Your case {{.case_id}} has been rejected.\n\nSummary: {{.summary}}\nSubject: {{.subject_type}} {{.subject_id}}\nRequested value: {{.requested_value}}\nComment: {{.comment}}",
			Category:    "workflow",
			Description: "Sent to the requester when a reusable approval case is rejected.",
		},
	}
}

func systemTemplates() []Template {
	return []Template{
		{
			Name:        "template.fintech.system.welcome",
			Subject:     "Welcome to the Platform",
			Body:        "Welcome to the lending platform, {{.name}}! Your account has been set up and you can now access the system.",
			Category:    "system",
			Description: "General welcome message for new platform users.",
		},
		{
			Name:        "template.fintech.system.password_reset",
			Subject:     "Password Reset Request",
			Body:        "A password reset has been requested for your account. Use code {{.code}} to reset your password. This code expires in {{.expiry_minutes}} minutes.",
			Category:    "system",
			Description: "Sent when a user requests a password reset.",
		},
	}
}

// ByCategory returns templates grouped by category.
func ByCategory() map[string][]Template {
	result := make(map[string][]Template)
	for _, t := range Defaults() {
		result[t.Category] = append(result[t.Category], t)
	}
	return result
}

// CategoryLabels returns human-readable labels for template categories.
func CategoryLabels() map[string]string {
	return map[string]string{
		"agent":       "Agent Management",
		"loan":        "Loan Lifecycle",
		"origination": "Loan Origination",
		"savings":     "Savings",
		"workflow":    "Workflow Cases",
		"system":      "System",
	}
}
