package models

import (
	"strconv"
	"time"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util/decimalx"
	money "google.golang.org/genproto/googleapis/type/money"
)

const timeLayout = time.RFC3339

const (
	// decimalPrecision is the number of decimal places for minor unit conversions (cents).
	decimalPrecision = 2
	// minorUnitsPerUnit is the number of minor units (cents) per major unit.
	minorUnitsPerUnit = 100
	// nanosPerMinorUnit converts minor units to nanos for google.type.Money.
	nanosPerMinorUnit = 10_000_000
)

// MinorUnitsToString converts an int64 minor-unit amount (e.g. cents) to a
// decimal string with two fractional digits. 123456 -> "1234.56".
func MinorUnitsToString(v int64) string {
	return decimalx.FromMinorUnits(v, decimalPrecision).String()
}

// StringToMinorUnits parses a decimal string (e.g. "1234.56") into int64 minor
// units. Uses string splitting to avoid float precision issues. Returns 0 on
// parse error.
func StringToMinorUnits(s string) int64 {
	d, err := decimalx.NewFromString(s)
	if err != nil {
		return 0
	}
	return d.ToMinorUnits(decimalPrecision)
}

// BasisPointsToString converts basis points (int64) to a percentage string.
// 1500 -> "15.00".
func BasisPointsToString(v int64) string {
	return decimalx.FromMinorUnits(v, decimalPrecision).String()
}

// StringToBasisPoints parses a percentage string into basis points.
// Uses string splitting to avoid float precision issues. "15.00" -> 1500.
func StringToBasisPoints(s string) int64 {
	d, err := decimalx.NewFromString(s)
	if err != nil {
		return 0
	}
	return d.ToMinorUnits(decimalPrecision)
}

// TimeToString converts a *time.Time to an RFC3339 string.
// Returns "" for nil.
func TimeToString(t *time.Time) string {
	if t == nil {
		return ""
	}
	return t.Format(timeLayout)
}

// StringToTime parses an RFC3339 string into *time.Time.
// Returns nil on empty or parse error.
func StringToTime(s string) *time.Time {
	if s == "" {
		return nil
	}
	t, err := time.Parse(timeLayout, s)
	if err != nil {
		return nil
	}
	return &t
}

// jsonMapToStringSlice converts a JSONMap that stores a list of documents
// (keyed by index) back to a []string.
func jsonMapToStringSlice(m data.JSONMap) []string {
	if m == nil {
		return nil
	}
	result := make([]string, 0, len(m))
	for i := range len(m) {
		key := strconv.Itoa(i)
		if v, exists := m[key]; exists {
			if s, isStr := v.(string); isStr {
				result = append(result, s)
			}
		}
	}
	return result
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

// MoneyToMinorUnits converts a *money.Money to minor units (int64) and currency code.
func MoneyToMinorUnits(m *money.Money) (int64, string) {
	if m == nil {
		return 0, ""
	}
	return m.GetUnits()*minorUnitsPerUnit + int64(m.GetNanos())/nanosPerMinorUnit, m.GetCurrencyCode()
}

// stringSliceToJSONMap converts a []string into a JSONMap keyed by index.
func stringSliceToJSONMap(ss []string) data.JSONMap {
	if len(ss) == 0 {
		return nil
	}
	m := data.JSONMap{}
	for i, s := range ss {
		m[strconv.Itoa(i)] = s
	}
	return m
}
