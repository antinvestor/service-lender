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
	money "google.golang.org/genproto/googleapis/type/money"
)

const (
	// minorUnitsPerUnit is the number of minor units (cents) per major unit.
	minorUnitsPerUnit = 100
	// nanosPerMinorUnit converts minor units to nanos for google.type.Money.
	nanosPerMinorUnit = 10_000_000
)

// MoneyToMinorUnits converts a *money.Money to minor units and currency code.
func MoneyToMinorUnits(m *money.Money) (int64, string) {
	if m == nil {
		return 0, ""
	}
	return m.GetUnits()*minorUnitsPerUnit + int64(m.GetNanos())/nanosPerMinorUnit, m.GetCurrencyCode()
}

// MinorUnitsToMoney converts minor units (e.g. cents) and a currency code to a
// *money.Money proto message.
func MinorUnitsToMoney(v int64, currencyCode string) *money.Money {
	units := v / minorUnitsPerUnit
	nanos := (v % minorUnitsPerUnit) * nanosPerMinorUnit
	return &money.Money{
		CurrencyCode: currencyCode,
		Units:        units,
		Nanos:        int32(nanos),
	}
}
