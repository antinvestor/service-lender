package decimalx

import (
	"math"

	"github.com/cockroachdb/apd/v3"
	"google.golang.org/genproto/googleapis/type/money"
)

// ToMoney converts a Decimal to a google.type.Money protobuf message.
// Units holds the integer part; Nanos holds the fractional part scaled to 10^9.
func ToMoney(currency string, amount Decimal) *money.Money {
	a := amount.inner()

	// Quantize to DecimalPrecision digits after the decimal point so the
	// fractional part is clean.
	cleaned := new(apd.Decimal)
	_, _ = ctx.Quantize(cleaned, a, -DecimalPrecision)

	// Extract the integer part (units).
	units := new(apd.Decimal)
	_, _ = ctx.Quantize(units, cleaned, 0)

	// fractional = cleaned - units
	frac := new(apd.Decimal)
	_, _ = ctx.Sub(frac, cleaned, units)

	// nanos = fractional * NanoSize
	nanosD := new(apd.Decimal)
	_, _ = ctx.Mul(nanosD, frac, apd.New(NanoSize, 0))

	// Round nanos to integer.
	nanosRounded := new(apd.Decimal)
	_, _ = ctx.Quantize(nanosRounded, nanosD, 0)

	unitsI64, _ := units.Int64()
	nanosI64, _ := nanosRounded.Int64()

	// Clamp nanos to int32 range (safety, matching payment service).
	if nanosI64 > math.MaxInt32 {
		nanosI64 = math.MaxInt32
	} else if nanosI64 < math.MinInt32 {
		nanosI64 = math.MinInt32
	}

	return &money.Money{
		CurrencyCode: currency,
		Units:        unitsI64,
		Nanos:        int32(nanosI64),
	}
}

// FromMoney converts a google.type.Money protobuf message back to a Decimal.
func FromMoney(m *money.Money) Decimal {
	if m == nil {
		return Zero()
	}
	units := apd.New(m.GetUnits(), 0)
	nanos := apd.New(int64(m.GetNanos()), -9)
	result := new(apd.Decimal)
	_, _ = ctx.Add(result, units, nanos)
	return Decimal{d: result}
}

// CompareMoney compares two Money values numerically, returning -1, 0, or 1.
// Both values are converted to Decimal for comparison.
func CompareMoney(a, b *money.Money) int {
	da := FromMoney(a)
	db := FromMoney(b)
	return da.Cmp(db)
}
