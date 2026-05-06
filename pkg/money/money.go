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

// Package money provides currency-precision-aware helpers for converting
// between minor-unit int64 amounts (the canonical at-rest form) and the
// google.type.Money wire representation. Unlike the legacy 2-decimal
// helpers in apps/loans/service/models/helpers.go, these honour ISO 4217
// currency-specific minor-unit counts (JPY=0, KWD/BHD/OMR=3, most others=2).
package money

import (
	"errors"
	"fmt"
	"strings"

	moneypb "google.golang.org/genproto/googleapis/type/money"
)

const (
	nanosPerUnit = 1_000_000_000
)

// zeroDecimal lists ISO 4217 codes whose minor unit equals the major unit.
var zeroDecimal = map[string]struct{}{
	"BIF": {}, "CLP": {}, "DJF": {}, "GNF": {}, "ISK": {}, "JPY": {},
	"KMF": {}, "KRW": {}, "PYG": {}, "RWF": {}, "UGX": {}, "UYI": {},
	"VND": {}, "VUV": {}, "XAF": {}, "XOF": {}, "XPF": {},
}

// threeDecimal lists ISO 4217 codes with three decimals.
var threeDecimal = map[string]struct{}{
	"BHD": {}, "IQD": {}, "JOD": {}, "KWD": {}, "LYD": {}, "OMR": {}, "TND": {},
}

// MinorUnitsPerMajor returns 1, 100, or 1000 depending on the currency's
// fractional precision. Unknown codes default to 100 (the most common case).
func MinorUnitsPerMajor(code string) int64 {
	c := strings.ToUpper(code)
	if _, ok := zeroDecimal[c]; ok {
		return 1
	}
	if _, ok := threeDecimal[c]; ok {
		return 1000
	}
	return 100
}

// MinorUnitsToMoney converts an int64 minor-unit amount and ISO 4217 currency
// code into a google.type.Money. The sign of units and nanos always agree.
func MinorUnitsToMoney(minor int64, code string) *moneypb.Money {
	mpm := MinorUnitsPerMajor(code)
	units := minor / mpm
	rem := minor - units*mpm // signed remainder
	nanos := int32(rem * (nanosPerUnit / mpm))
	return &moneypb.Money{CurrencyCode: code, Units: units, Nanos: nanos}
}

// ErrMoneyNilInput indicates a nil *money.Money was passed where a value is required.
var ErrMoneyNilInput = errors.New("money: nil input")

// ErrMoneyCurrencyMismatch indicates the wire money's currency does not
// match the expected currency. Callers should never silently coerce.
var ErrMoneyCurrencyMismatch = errors.New("money: currency mismatch")

// ErrMoneySignMismatch indicates units and nanos have opposite signs, which
// is invalid per google.type.Money semantics.
var ErrMoneySignMismatch = errors.New("money: units and nanos have opposite signs")

// MoneyToMinorUnits converts a *money.Money to int64 minor units, validating
// that the currency matches expectedCurrency and that units/nanos signs agree.
// expectedCurrency must be the non-empty ISO 4217 code the caller expects.
func MoneyToMinorUnits(m *moneypb.Money, expectedCurrency string) (int64, error) {
	if m == nil {
		return 0, ErrMoneyNilInput
	}
	if !strings.EqualFold(m.GetCurrencyCode(), expectedCurrency) {
		return 0, fmt.Errorf("%w: got %q want %q", ErrMoneyCurrencyMismatch,
			m.GetCurrencyCode(), expectedCurrency)
	}
	if (m.GetUnits() > 0 && m.GetNanos() < 0) || (m.GetUnits() < 0 && m.GetNanos() > 0) {
		return 0, ErrMoneySignMismatch
	}
	mpm := MinorUnitsPerMajor(m.GetCurrencyCode())
	return m.GetUnits()*mpm + int64(m.GetNanos())/(nanosPerUnit/mpm), nil
}
