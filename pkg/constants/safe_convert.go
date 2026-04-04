package constants

import "math"

// SafeInt32FromInt64 safely converts an int64 to int32, clamping to
// math.MaxInt32 / math.MinInt32 on overflow.
func SafeInt32FromInt64(v int64) int32 {
	if v > math.MaxInt32 {
		return math.MaxInt32
	}
	if v < math.MinInt32 {
		return math.MinInt32
	}
	return int32(v)
}

// SafeInt32FromInt safely converts an int to int32, clamping to
// math.MaxInt32 / math.MinInt32 on overflow.
func SafeInt32FromInt(v int) int32 {
	if v > math.MaxInt32 {
		return math.MaxInt32
	}
	if v < math.MinInt32 {
		return math.MinInt32
	}
	return int32(v)
}
