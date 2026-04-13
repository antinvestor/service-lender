module buf.build/gen/go/antinvestor/identity/connectrpc/go

go 1.26

require (
	buf.build/gen/go/antinvestor/identity/protocolbuffers/go v0.0.0
	connectrpc.com/connect v1.19.1
)

replace buf.build/gen/go/antinvestor/identity/protocolbuffers/go => ../../protocolbuffers/go
