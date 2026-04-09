package models

import (
	"strconv"
	"time"

	originationv1 "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util/decimalx"
	money "google.golang.org/genproto/googleapis/type/money"
)

const (
	// decimalPrecision is the number of decimal places for minor unit conversions (cents).
	decimalPrecision = 2
	// minorUnitsPerUnit is the number of minor units (cents) per major unit.
	minorUnitsPerUnit = 100
	// nanosPerMinorUnit converts minor units to nanos for google.type.Money.
	nanosPerMinorUnit = 10_000_000
)

// MinorUnitsToString converts minor units (e.g. cents) stored as int64 to a decimal string.
// For example, 123456 becomes "1234.56".
func MinorUnitsToString(v int64) string {
	return decimalx.FromMinorUnits(v, decimalPrecision).String()
}

// StringToMinorUnits converts a decimal string to minor units (int64).
// Uses string splitting to avoid float precision issues.
// For example, "1234.56" becomes 123456.
func StringToMinorUnits(s string) int64 {
	d, err := decimalx.NewFromString(s)
	if err != nil {
		return 0
	}
	return d.ToMinorUnits(decimalPrecision)
}

// BasisPointsToString converts basis points stored as int64 to a percentage string.
// For example, 1250 becomes "12.50".
func BasisPointsToString(v int64) string {
	return decimalx.FromMinorUnits(v, decimalPrecision).String()
}

// StringToBasisPoints converts a percentage string to basis points (int64).
// Uses string splitting to avoid float precision issues.
// For example, "12.50" becomes 1250.
func StringToBasisPoints(s string) int64 {
	d, err := decimalx.NewFromString(s)
	if err != nil {
		return 0
	}
	return d.ToMinorUnits(decimalPrecision)
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

// MinorUnitsToMoney converts minor units (e.g. cents) and a currency code to a
// *money.Money proto message. 123456 with "KES" becomes {CurrencyCode:"KES", Units:1234, Nanos:560000000}.
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
// Returns (0, "") for nil input.
func MoneyToMinorUnits(m *money.Money) (int64, string) {
	if m == nil {
		return 0, ""
	}
	return m.GetUnits()*minorUnitsPerUnit + int64(m.GetNanos())/nanosPerMinorUnit, m.GetCurrencyCode()
}

// jsonMapToStringSlice converts a JSONMap keyed by index back to a []string.
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

// formFieldDefinitionsToAPI converts a JSONMap (keyed by index) of field definitions
// back to a slice of proto FormFieldDefinition messages.
func formFieldDefinitionsToAPI(m data.JSONMap) []*originationv1.FormFieldDefinition {
	if m == nil {
		return nil
	}

	result := make([]*originationv1.FormFieldDefinition, 0, len(m))
	for i := range len(m) {
		key := strconv.Itoa(i)
		v, exists := m[key]
		if !exists {
			continue
		}

		fieldMap, ok := v.(map[string]interface{})
		if !ok {
			continue
		}

		field := &originationv1.FormFieldDefinition{
			Key:               mapStr(fieldMap, "key"),
			Label:             mapStr(fieldMap, "label"),
			FieldType:         originationv1.FormFieldType(mapInt32(fieldMap, "field_type")),
			Group:             originationv1.FormFieldGroup(mapInt32(fieldMap, "group")),
			Required:          mapBool(fieldMap, "required"),
			Description:       mapStr(fieldMap, "description"),
			Placeholder:       mapStr(fieldMap, "placeholder"),
			DefaultValue:      mapStr(fieldMap, "default_value"),
			ValidationPattern: mapStr(fieldMap, "validation_pattern"),
			ValidationMessage: mapStr(fieldMap, "validation_message"),
			Options:           mapStringSlice(fieldMap, "options"),
			MinLength:         mapInt32(fieldMap, "min_length"),
			MaxLength:         mapInt32(fieldMap, "max_length"),
			MinValue:          mapStr(fieldMap, "min_value"),
			MaxValue:          mapStr(fieldMap, "max_value"),
			Order:             mapInt32(fieldMap, "order"),
			Section:           mapStr(fieldMap, "section"),
			Encrypted:         mapBool(fieldMap, "encrypted"),
		}

		result = append(result, field)
	}

	return result
}

// formFieldDefinitionsFromAPI converts a slice of proto FormFieldDefinition messages
// into a JSONMap keyed by index for storage.
func formFieldDefinitionsFromAPI(fields []*originationv1.FormFieldDefinition) data.JSONMap {
	if len(fields) == 0 {
		return nil
	}

	m := data.JSONMap{}
	for i, f := range fields {
		fieldMap := map[string]interface{}{
			"key":                f.GetKey(),
			"label":              f.GetLabel(),
			"field_type":         int32(f.GetFieldType()),
			"group":              int32(f.GetGroup()),
			"required":           f.GetRequired(),
			"description":        f.GetDescription(),
			"placeholder":        f.GetPlaceholder(),
			"default_value":      f.GetDefaultValue(),
			"validation_pattern": f.GetValidationPattern(),
			"validation_message": f.GetValidationMessage(),
			"min_length":         f.GetMinLength(),
			"max_length":         f.GetMaxLength(),
			"min_value":          f.GetMinValue(),
			"max_value":          f.GetMaxValue(),
			"order":              f.GetOrder(),
			"section":            f.GetSection(),
			"encrypted":          f.GetEncrypted(),
		}
		if len(f.GetOptions()) > 0 {
			opts := make([]interface{}, len(f.GetOptions()))
			for j, o := range f.GetOptions() {
				opts[j] = o
			}
			fieldMap["options"] = opts
		}
		m[strconv.Itoa(i)] = fieldMap
	}

	return m
}

// mapStr extracts a string value from a map.
func mapStr(m map[string]interface{}, key string) string {
	v, ok := m[key]
	if !ok || v == nil {
		return ""
	}
	s, isStr := v.(string)
	if isStr {
		return s
	}
	return ""
}

// mapInt32 extracts an int32 value from a map (JSON numbers are float64).
func mapInt32(m map[string]interface{}, key string) int32 {
	v, ok := m[key]
	if !ok || v == nil {
		return 0
	}
	switch n := v.(type) {
	case float64:
		return int32(n)
	case int:
		return int32(n)
	case int32:
		return n
	case int64:
		return int32(n)
	}
	return 0
}

// mapBool extracts a bool value from a map.
func mapBool(m map[string]interface{}, key string) bool {
	v, ok := m[key]
	if !ok || v == nil {
		return false
	}
	b, isBool := v.(bool)
	return isBool && b
}

// mapStringSlice extracts a []string from a map (JSON arrays are []interface{}).
func mapStringSlice(m map[string]interface{}, key string) []string {
	v, ok := m[key]
	if !ok || v == nil {
		return nil
	}
	arr, isArr := v.([]interface{})
	if !isArr {
		return nil
	}
	result := make([]string, 0, len(arr))
	for _, item := range arr {
		if s, isStr := item.(string); isStr {
			result = append(result, s)
		}
	}
	return result
}
