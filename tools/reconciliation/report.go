package reconciliation

import (
	"fmt"
	"strings"
)

// FormatReport generates a human-readable reconciliation report.
func FormatReport(results []*Result) string {
	var sb strings.Builder

	sb.WriteString("=== Balance Reconciliation Report ===\n\n")

	totalAccounts := 0
	totalMatched := 0
	totalDiscrepancies := 0
	totalErrors := 0

	for i, result := range results {
		fmt.Fprintf(&sb, "--- Group %d ---\n", i+1)
		fmt.Fprintf(&sb, "  Accounts checked: %d\n", result.TotalAccounts)
		fmt.Fprintf(&sb, "  Matched: %d\n", result.MatchedAccounts)
		fmt.Fprintf(&sb, "  Discrepancies: %d\n", len(result.Discrepancies))

		for _, d := range result.Discrepancies {
			fmt.Fprintf(&sb, "    MISMATCH: %s (%s/%s)\n", d.AccountRef, d.OwnerType, d.OwnerID)
			fmt.Fprintf(&sb, "      Expected: %d, Actual: %d, Diff: %d %s\n",
				d.ExpectedBalance, d.ActualBalance, d.Difference, d.Currency)
		}

		if len(result.Errors) > 0 {
			fmt.Fprintf(&sb, "  Errors: %d\n", len(result.Errors))
			for _, e := range result.Errors {
				fmt.Fprintf(&sb, "    ERROR: %s\n", e)
			}
		}
		sb.WriteString("\n")

		totalAccounts += result.TotalAccounts
		totalMatched += result.MatchedAccounts
		totalDiscrepancies += len(result.Discrepancies)
		totalErrors += len(result.Errors)
	}

	sb.WriteString("=== Summary ===\n")
	fmt.Fprintf(&sb, "Total accounts: %d\n", totalAccounts)
	fmt.Fprintf(&sb, "Matched: %d\n", totalMatched)
	fmt.Fprintf(&sb, "Discrepancies: %d\n", totalDiscrepancies)
	fmt.Fprintf(&sb, "Errors: %d\n", totalErrors)

	if totalDiscrepancies == 0 && totalErrors == 0 {
		sb.WriteString("\nSTATUS: ALL BALANCES RECONCILED SUCCESSFULLY\n")
	} else {
		sb.WriteString("\nSTATUS: RECONCILIATION ISSUES FOUND - REVIEW REQUIRED\n")
	}

	return sb.String()
}

// FormatCSV generates a CSV report of discrepancies.
func FormatCSV(results []*Result) string {
	var sb strings.Builder
	sb.WriteString("account_ref,owner_type,owner_id,expected_balance,actual_balance,difference,currency\n")

	for _, result := range results {
		for _, d := range result.Discrepancies {
			fmt.Fprintf(&sb, "%s,%s,%s,%d,%d,%d,%s\n",
				d.AccountRef, d.OwnerType, d.OwnerID,
				d.ExpectedBalance, d.ActualBalance, d.Difference, d.Currency)
		}
	}

	return sb.String()
}
