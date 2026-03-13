package apperrors

import (
	"fmt"
	"strings"
)

const (
	BadRequest      = 400
	Unauthorised    = 401
	Forbidden       = 403
	NotFound        = 404
	Conflict        = 409
	Unprocessable   = 422
	TooManyRequests = 429

	InternalServerError = 500
	BadGateway          = 502
	ServiceUnavailable  = 503
	GatewayTimeout      = 504
)

var (
	ErrInvalidInput = Error{ //nolint:gochecknoglobals // sentinel error
		code:    BadRequest,
		message: "Invalid input provided",
	}
	ErrMissingRequiredData = Error{ //nolint:gochecknoglobals // sentinel error
		code:    BadRequest,
		message: "Required data is missing",
	}
	ErrDataNotFound = Error{ //nolint:gochecknoglobals // sentinel error
		code:    NotFound,
		message: "Requested data not found",
	}
	ErrDataConflict = Error{ //nolint:gochecknoglobals // sentinel error
		code:    Conflict,
		message: "Data conflict occurred",
	}
	ErrDataValidation = Error{ //nolint:gochecknoglobals // sentinel error
		code:    Unprocessable,
		message: "Data validation failed",
	}
	ErrForbiddenAccess = Error{ //nolint:gochecknoglobals // sentinel error
		code:    Forbidden,
		message: "Access forbidden",
	}
)

type Error struct {
	code    int
	message string
}

func NewError(code int, message string) *Error {
	return &Error{
		code:    code,
		message: message,
	}
}

func (e *Error) Error() string {
	return fmt.Sprintf("%d  : - %s  ", e.code, e.message)
}

func (e *Error) ErrorCode() int {
	return e.code
}

func (e *Error) Extend(message string) *Error {
	return &Error{
		code:    e.code,
		message: fmt.Sprintf("%s - %s", e.message, message),
	}
}

func (e *Error) Override(errs ...error) error {
	extraInfo := make([]string, len(errs))
	for i, err := range errs {
		extraInfo[i] = err.Error()
	}
	return fmt.Errorf("%w\nAdditional errors:\n%s", e, strings.Join(extraInfo, "\n"))
}

func (e *Error) IsRetriable() bool {
	return e.code >= 500 && e.code < 600
}
