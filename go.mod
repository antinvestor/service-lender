module github.com/antinvestor/service-lender

go 1.26

require (
	buf.build/gen/go/antinvestor/common/protocolbuffers/go v1.36.11-20260219054105-fe125014d75c.1
	buf.build/gen/go/antinvestor/lender/connectrpc/go v0.0.0-00010101000000-000000000000
	buf.build/gen/go/antinvestor/lender/protocolbuffers/go v0.0.0-00010101000000-000000000000
	buf.build/gen/go/antinvestor/partition/connectrpc/go v1.19.1-20260306034803-bec59545427a.2
	buf.build/gen/go/antinvestor/profile/connectrpc/go v1.19.1-20260219062039-499f582dea7e.2
	connectrpc.com/connect v1.19.1
	github.com/antinvestor/apis/go/common v1.55.13
	github.com/antinvestor/apis/go/partition v1.55.13
	github.com/antinvestor/apis/go/profile v1.55.13
	github.com/pitabwire/frame v1.78.3
	github.com/pitabwire/util v0.6.1
	google.golang.org/protobuf v1.36.11
)
