package interceptors

import (
	"context"
	"errors"
	"testing"
	"time"

	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"
)

func TestAuditInterceptorLogEntryHandlesTypedNilResponseOnError(t *testing.T) {
	interceptor := &AuditInterceptor{serviceName: "service_identity"}
	var resp *connect.Response[identityv1.BranchSaveResponse]

	require.NotPanics(t, func() {
		interceptor.logEntry(
			context.Background(),
			"/identity.v1.IdentityService/BranchSave",
			time.Now(),
			`{"data":{"name":"Central Branch"}}`,
			resp,
			errors.New("approval case actor is required"),
		)
	})
}
