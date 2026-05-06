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

package money

import (
	"strconv"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	moneypb "google.golang.org/genproto/googleapis/type/money"
)

func TestMinorUnitsPerMajor(t *testing.T) {
	tests := []struct {
		name string
		code string
		want int64
	}{
		{"USD", "USD", 100}, {"KES", "KES", 100}, {"EUR", "EUR", 100}, {"GBP", "GBP", 100},
		{"JPY", "JPY", 1}, {"KRW", "KRW", 1},
		{"KWD", "KWD", 1000}, {"BHD", "BHD", 1000}, {"OMR", "OMR", 1000},
		{"lowercase usd", "usd", 100},
		{"empty", "", 100},
		{"unknown XXX", "XXX", 100},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			assert.Equal(t, tc.want, MinorUnitsPerMajor(tc.code))
		})
	}
}

func TestMinorUnitsToMoney(t *testing.T) {
	tests := []struct {
		name     string
		minor    int64
		currency string
		units    int64
		nanos    int32
	}{
		{"USD 1234.56", 123456, "USD", 1234, 560_000_000},
		{"USD zero", 0, "USD", 0, 0},
		{"JPY 500", 500, "JPY", 500, 0},
		{"KWD 1.234", 1234, "KWD", 1, 234_000_000},
		{"USD negative", -250, "USD", -2, -500_000_000},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			got := MinorUnitsToMoney(tc.minor, tc.currency)
			assert.Equal(t, tc.currency, got.GetCurrencyCode())
			assert.Equal(t, tc.units, got.GetUnits())
			assert.Equal(t, tc.nanos, got.GetNanos())
		})
	}
}

func TestMoneyToMinorUnits(t *testing.T) {
	tests := []struct {
		name             string
		input            *moneypb.Money
		expectedCurrency string
		want             int64
		wantErr          bool
	}{
		{"USD round-trip", &moneypb.Money{CurrencyCode: "USD", Units: 1234, Nanos: 560_000_000}, "USD", 123456, false},
		{"JPY 500", &moneypb.Money{CurrencyCode: "JPY", Units: 500}, "JPY", 500, false},
		{"KWD 1.234", &moneypb.Money{CurrencyCode: "KWD", Units: 1, Nanos: 234_000_000}, "KWD", 1234, false},
		{"currency mismatch", &moneypb.Money{CurrencyCode: "USD", Units: 100}, "KES", 0, true},
		{"nil input", nil, "USD", 0, true},
		{"sign mismatch units/nanos", &moneypb.Money{CurrencyCode: "USD", Units: 1, Nanos: -100}, "USD", 0, true},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			got, err := MoneyToMinorUnits(tc.input, tc.expectedCurrency)
			if tc.wantErr {
				require.Error(t, err)
				return
			}
			require.NoError(t, err)
			assert.Equal(t, tc.want, got)
		})
	}
}

func TestRoundTrip(t *testing.T) {
	for _, code := range []string{"USD", "KES", "JPY", "KWD"} {
		for _, minor := range []int64{-12345, 0, 1, 99, 100, 12345, 1_000_000_000} {
			t.Run(code+"/"+strconv.FormatInt(minor, 10), func(t *testing.T) {
				m := MinorUnitsToMoney(minor, code)
				back, err := MoneyToMinorUnits(m, code)
				require.NoError(t, err)
				assert.Equal(t, minor, back)
			})
		}
	}
}
