package models

import (
	"strconv"

	money "google.golang.org/genproto/googleapis/type/money"
)

// MoneyToMinorUnits converts a *money.Money to minor units (int64) and currency code.
func MoneyToMinorUnits(m *money.Money) (int64, string) {
	if m == nil {
		return 0, ""
	}
	return m.GetUnits()*percentageDivisor + int64(m.GetNanos())/moneyNanosFactor, m.GetCurrencyCode()
}

// BasisPointsToString converts basis points stored as int64 to a string.
// For example, 1250 becomes "1250".
func BasisPointsToString(v int64) string {
	return strconv.FormatInt(v, 10)
}

// StringToBasisPoints converts a string to basis points (int64).
// Returns 0 on parse error.
func StringToBasisPoints(s string) int64 {
	v, err := strconv.ParseInt(s, 10, 64)
	if err != nil {
		return 0
	}
	return v
}
