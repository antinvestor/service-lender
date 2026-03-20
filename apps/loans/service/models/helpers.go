package models

import (
	"fmt"
	"strconv"
	"strings"
	"time"

	"github.com/pitabwire/frame/data"
)

const timeLayout = time.RFC3339

// MinorUnitsToString converts an int64 minor-unit amount (e.g. cents) to a
// decimal string with two fractional digits. 123456 -> "1234.56".
func MinorUnitsToString(v int64) string {
	whole := v / 100
	frac := v % 100
	if frac < 0 {
		frac = -frac
	}
	return fmt.Sprintf("%d.%02d", whole, frac)
}

// StringToMinorUnits parses a decimal string (e.g. "1234.56") into int64 minor
// units. Uses string splitting to avoid float precision issues. Returns 0 on
// parse error.
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

// BasisPointsToString converts basis points (int64) to a percentage string.
// 1500 -> "15.00".
func BasisPointsToString(v int64) string {
	whole := v / 100
	frac := v % 100
	if frac < 0 {
		frac = -frac
	}
	return fmt.Sprintf("%d.%02d", whole, frac)
}

// StringToBasisPoints parses a percentage string into basis points.
// Uses string splitting to avoid float precision issues. "15.00" -> 1500.
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
		if v, ok := m[key]; ok {
			if s, ok := v.(string); ok {
				result = append(result, s)
			}
		}
	}
	return result
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
