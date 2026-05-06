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

package models

import (
	moneyx "github.com/pitabwire/util/money"
	money "google.golang.org/genproto/googleapis/type/money"
)

// MoneyToMinorUnits converts a *money.Money to minor units and currency code.
// Precision follows ISO 4217 via moneyx.Decimals (JPY=0, KWD/BHD/OMR=3, else=2).
func MoneyToMinorUnits(m *money.Money) (int64, string) {
	if m == nil {
		return 0, ""
	}
	cc := m.GetCurrencyCode()
	return moneyx.ToSmallestUnit(m, moneyx.Decimals(cc)), cc
}

// MinorUnitsToMoney converts minor units (e.g. cents) and a currency code to a
// *money.Money proto message. Precision follows ISO 4217 via moneyx.Decimals.
func MinorUnitsToMoney(v int64, currencyCode string) *money.Money {
	return moneyx.FromMinorUnitsByCurrency(currencyCode, v)
}
