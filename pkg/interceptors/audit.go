// Package interceptors provides Connect RPC interceptors for the fintech
// service suite.
package interceptors

import (
	"context"
	"fmt"
	"strings"
	"time"

	"connectrpc.com/connect"
	"github.com/pitabwire/frame/security"
	"github.com/pitabwire/util"
	"google.golang.org/protobuf/encoding/protojson"
	"google.golang.org/protobuf/proto"
)

// AuditInterceptor logs structured audit entries for non-idempotent
// (state-changing) RPC calls made by external users or service accounts.
//
// It is designed to sit at the end of the interceptor chain (after auth,
// tenancy, and function access) so that:
//   - The authenticated claims are available in the context
//   - The request has already passed authorization
//   - It can capture both the request and response
//
// Idempotent RPCs (Get, Search, List — marked with NO_SIDE_EFFECTS in the
// proto) are skipped. Internal system callers (identified by the "internal"
// role) are also skipped to avoid noisy audit trails from service-to-service
// calls.
type AuditInterceptor struct {
	serviceName string
}

// NewAuditInterceptor creates an audit interceptor that tags entries with
// the given service name (e.g. "service_identity", "service_loans").
func NewAuditInterceptor(serviceName string) connect.Interceptor {
	return &AuditInterceptor{serviceName: serviceName}
}

// WrapUnary intercepts unary RPCs. Non-idempotent calls from external
// callers are logged after the handler completes.
func (a *AuditInterceptor) WrapUnary(next connect.UnaryFunc) connect.UnaryFunc {
	return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
		if a.shouldSkip(ctx) {
			return next(ctx, req)
		}

		readOnly := a.isReadOnly(req.Spec())
		start := time.Now()
		procedure := req.Spec().Procedure

		// For mutating calls, always capture request body.
		// For read-only calls, only capture on error.
		var reqSnapshot string
		if !readOnly {
			reqSnapshot = marshalProtoMessage(req.Any())
		}

		resp, err := next(ctx, req)

		// Always audit mutating calls. Audit read-only calls only on error.
		if !readOnly || err != nil {
			if readOnly && reqSnapshot == "" {
				reqSnapshot = marshalProtoMessage(req.Any())
			}
			a.logEntry(ctx, procedure, start, reqSnapshot, resp, err)
		}

		return resp, err
	}
}

// WrapStreamingClient is a pass-through — client streams aren't server-side.
func (a *AuditInterceptor) WrapStreamingClient(next connect.StreamingClientFunc) connect.StreamingClientFunc {
	return next
}

// WrapStreamingHandler intercepts server streaming RPCs. Most streaming
// RPCs are searches (idempotent) so this is largely a no-op, but it will
// catch any non-idempotent streams.
func (a *AuditInterceptor) WrapStreamingHandler(next connect.StreamingHandlerFunc) connect.StreamingHandlerFunc {
	return func(ctx context.Context, conn connect.StreamingHandlerConn) error {
		if a.shouldSkip(ctx) {
			return next(ctx, conn)
		}

		readOnly := a.isReadOnly(conn.Spec())
		start := time.Now()
		err := next(ctx, conn)

		if !readOnly || err != nil {
			a.logEntry(ctx, conn.Spec().Procedure, start, "", nil, err)
		}

		return err
	}
}

// shouldSkip returns true if the call should not be audited at all.
// Internal service-to-service calls are always skipped.
func (a *AuditInterceptor) shouldSkip(ctx context.Context) bool {
	claims := security.ClaimsFromContext(ctx)
	return claims != nil && claims.IsInternalSystem()
}

// isReadOnly returns true if the RPC is idempotent (Get/Search/List).
func (a *AuditInterceptor) isReadOnly(spec connect.Spec) bool {
	return spec.IdempotencyLevel == connect.IdempotencyIdempotent ||
		spec.IdempotencyLevel == connect.IdempotencyNoSideEffects
}

// logEntry writes a structured audit log entry.
func (a *AuditInterceptor) logEntry(
	ctx context.Context,
	procedure string,
	start time.Time,
	requestBody string,
	resp connect.AnyResponse,
	callErr error,
) {
	claims := security.ClaimsFromContext(ctx)

	// Extract resource type and action from the procedure name.
	// e.g. "/identity.v1.IdentityService/OrganizationSave" → "Organization", "Save"
	resourceType, action := parseProcedure(procedure)

	fields := map[string]any{
		"audit":         true,
		"service":       a.serviceName,
		"procedure":     procedure,
		"action":        action,
		"resource_type": resourceType,
		"duration_ms":   time.Since(start).Milliseconds(),
		"success":       callErr == nil,
	}

	if claims != nil {
		fields["profile_id"] = claims.GetProfileID()
		fields["tenant_id"] = claims.GetTenantID()
		fields["partition_id"] = claims.GetPartitionID()
		fields["access_id"] = claims.GetAccessID()
		fields["session_id"] = claims.GetSessionID()
		fields["device_id"] = claims.GetDeviceID()
		fields["roles"] = claims.GetRoles()
	}

	if requestBody != "" {
		fields["request"] = requestBody
	}

	if resp != nil {
		fields["response"] = marshalProtoMessage(resp.Any())
	}

	if callErr != nil {
		fields["error"] = callErr.Error()
	}

	description := fmt.Sprintf("%s %s", action, resourceType)
	if callErr != nil {
		description += " (failed)"
	}

	logger := util.Log(ctx).WithFields(fields)
	defer logger.Release()

	if callErr != nil {
		logger.Warn(description)
	} else {
		logger.Info(description)
	}
}

// parseProcedure extracts a resource type and action from a Connect
// procedure name like "/identity.v1.IdentityService/OrganizationSave".
func parseProcedure(procedure string) (resourceType, action string) {
	// Get the method name after the last "/"
	parts := strings.Split(procedure, "/")
	method := parts[len(parts)-1]

	// Split CamelCase method into resource + action.
	// e.g. "OrganizationSave" → "Organization", "Save"
	// e.g. "LoanAccountCreate" → "LoanAccount", "Create"
	// e.g. "DisbursementCreate" → "Disbursement", "Create"
	for _, suffix := range []string{
		"Save", "Create", "Delete", "Update",
		"Submit", "Approve", "Reject", "Cancel",
		"Record", "Apply", "Complete", "Manage",
	} {
		if strings.HasSuffix(method, suffix) {
			return method[:len(method)-len(suffix)], suffix
		}
	}

	return method, "Execute"
}

// marshalProtoMessage attempts to serialize a proto message to compact JSON.
// Returns empty string on failure — audit logging should never block the RPC.
func marshalProtoMessage(msg any) string {
	pm, ok := msg.(proto.Message)
	if !ok || pm == nil {
		return ""
	}

	marshaler := protojson.MarshalOptions{
		EmitUnpopulated: false,
		UseProtoNames:   true,
	}

	b, err := marshaler.Marshal(pm)
	if err != nil {
		return ""
	}

	// Truncate large payloads to avoid log bloat.
	const maxLen = 4096
	s := string(b)
	if len(s) > maxLen {
		return s[:maxLen] + "...(truncated)"
	}
	return s
}
