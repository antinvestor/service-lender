package models

import (
	"strconv"
	"strings"
	"time"
)

// MinorUnitsToString converts minor units (e.g. cents) stored as int64 to a decimal string.
// For example, 123456 becomes "1234.56".
func MinorUnitsToString(v int64) string {
	if v == 0 {
		return "0.00"
	}
	whole := v / 100
	frac := v % 100
	if frac < 0 {
		frac = -frac
	}
	return strconv.FormatInt(whole, 10) + "." + padLeft(strconv.FormatInt(frac, 10), 2)
}

// StringToMinorUnits converts a decimal string to minor units (int64).
// Uses string splitting to avoid float precision issues.
// For example, "1234.56" becomes 123456.
func StringToMinorUnits(s string) int64 {
	if s == "" {
		return 0
	}
	negative := false
	if len(s) > 0 && s[0] == '-' {
		negative = true
		s = s[1:]
	}
	parts := strings.SplitN(s, ".", 2)
	whole, _ := strconv.ParseInt(parts[0], 10, 64)
	var frac int64
	if len(parts) == 2 {
		f := parts[1]
		if len(f) > 2 {
			f = f[:2]
		}
		for len(f) < 2 {
			f += "0"
		}
		frac, _ = strconv.ParseInt(f, 10, 64)
	}
	result := whole*100 + frac
	if negative {
		return -result
	}
	return result
}

// BasisPointsToString converts basis points stored as int64 to a percentage string.
// For example, 1250 becomes "12.50".
func BasisPointsToString(v int64) string {
	if v == 0 {
		return "0.00"
	}
	whole := v / 100
	frac := v % 100
	if frac < 0 {
		frac = -frac
	}
	return strconv.FormatInt(whole, 10) + "." + padLeft(strconv.FormatInt(frac, 10), 2)
}

// StringToBasisPoints converts a percentage string to basis points (int64).
// Uses string splitting to avoid float precision issues.
// For example, "12.50" becomes 1250.
func StringToBasisPoints(s string) int64 {
	if s == "" {
		return 0
	}
	negative := false
	if len(s) > 0 && s[0] == '-' {
		negative = true
		s = s[1:]
	}
	parts := strings.SplitN(s, ".", 2)
	whole, _ := strconv.ParseInt(parts[0], 10, 64)
	var frac int64
	if len(parts) == 2 {
		f := parts[1]
		if len(f) > 2 {
			f = f[:2]
		}
		for len(f) < 2 {
			f += "0"
		}
		frac, _ = strconv.ParseInt(f, 10, 64)
	}
	result := whole*100 + frac
	if negative {
		return -result
	}
	return result
}

// TimeToString converts a *time.Time to an RFC3339 string. Returns "" if nil.
func TimeToString(t *time.Time) string {
	if t == nil {
		return ""
	}
	return t.Format(time.RFC3339)
}

// StringToTime converts an RFC3339 string to *time.Time. Returns nil on error or empty string.
func StringToTime(s string) *time.Time {
	if s == "" {
		return nil
	}
	t, err := time.Parse(time.RFC3339, s)
	if err != nil {
		return nil
	}
	return &t
}

func padLeft(s string, length int) string {
	for len(s) < length {
		s = "0" + s
	}
	return s
}
