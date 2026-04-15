// Copyright 2023-2026 Ant Investor Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package business

import (
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/metric"
)

var savingsMeter = otel.Meter("service-savings")

var (
	SavingsAccountsOpened, _ = savingsMeter.Int64Counter("savings_accounts_opened_total",
		metric.WithDescription("New savings accounts opened"),
		metric.WithUnit("{account}"))

	SavingsDeposits, _ = savingsMeter.Int64Counter("savings_deposits_total",
		metric.WithDescription("Savings deposits completed"),
		metric.WithUnit("{deposit}"))

	SavingsDepositsAmount, _ = savingsMeter.Float64Counter("savings_deposits_amount_total",
		metric.WithDescription("Total amount deposited into savings"),
		metric.WithUnit("{currency_unit}"))

	SavingsWithdrawals, _ = savingsMeter.Int64Counter("savings_withdrawals_total",
		metric.WithDescription("Savings withdrawals approved"),
		metric.WithUnit("{withdrawal}"))

	SavingsWithdrawalsAmount, _ = savingsMeter.Float64Counter("savings_withdrawals_amount_total",
		metric.WithDescription("Total amount withdrawn from savings"),
		metric.WithUnit("{currency_unit}"))

	SavingsInterestAccruedAmount, _ = savingsMeter.Float64Counter("savings_interest_accrued_amount_total",
		metric.WithDescription("Total interest accrued on savings accounts"),
		metric.WithUnit("{currency_unit}"))
)

// MetricInfo describes a registered OTel counter for discoverability.
type MetricInfo struct {
	Name        string `json:"name"`
	Type        string `json:"type"`
	Unit        string `json:"unit"`
	Description string `json:"description"`
}

// RegisteredMetrics returns the list of all OTel counters registered by
// the savings business package.
func RegisteredMetrics() []MetricInfo {
	return []MetricInfo{
		{
			Name:        "savings_accounts_opened_total",
			Type:        "counter",
			Unit:        "count",
			Description: "New savings accounts opened",
		},
		{Name: "savings_deposits_total", Type: "counter", Unit: "count", Description: "Savings deposits completed"},
		{
			Name:        "savings_deposits_amount_total",
			Type:        "counter",
			Unit:        "currency_unit",
			Description: "Total amount deposited into savings",
		},
		{
			Name:        "savings_withdrawals_total",
			Type:        "counter",
			Unit:        "count",
			Description: "Savings withdrawals approved",
		},
		{
			Name:        "savings_withdrawals_amount_total",
			Type:        "counter",
			Unit:        "currency_unit",
			Description: "Total amount withdrawn from savings",
		},
		{
			Name:        "savings_interest_accrued_amount_total",
			Type:        "counter",
			Unit:        "currency_unit",
			Description: "Total interest accrued on savings accounts",
		},
	}
}
