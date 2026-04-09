ARG TARGETOS=linux
ARG TARGETARCH=amd64

# ---------- Builder ----------
FROM golang:1.26 AS builder
WORKDIR /app

ARG REPOSITORY
ARG VERSION=dev
ARG REVISION=none
ARG BUILDTIME

COPY go.mod go.sum ./
RUN go mod download

COPY ./apps/funding ./apps/funding
COPY ./apps/identity ./apps/identity
COPY ./apps/stawi ./apps/stawi
COPY ./pkg ./pkg

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
	go build -trimpath \
	-ldflags="-s -w \
	-X github.com/pitabwire/frame/version.Repository=${REPOSITORY} \
	-X github.com/pitabwire/frame/version.Version=${VERSION} \
	-X github.com/pitabwire/frame/version.Commit=${REVISION} \
	-X github.com/pitabwire/frame/version.Date=${BUILDTIME}" \
	-o /app/binary ./apps/funding/cmd/main.go

# ---------- Final ----------
FROM cgr.dev/chainguard/static:latest
USER 65532:65532
WORKDIR /
COPY --from=builder /app/binary /service
ENTRYPOINT ["/service"]
