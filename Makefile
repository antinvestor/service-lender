SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:
.DELETE_ON_ERROR:
.DEFAULT_GOAL := all

GO ?= go

# ------------------------------------------------------------------------------
# Proto
# ------------------------------------------------------------------------------

.PHONY: proto-lint
proto-lint:
	cd proto && buf format -w && buf lint

.PHONY: proto-generate
proto-generate:
	cd proto && buf dep update && buf generate

.PHONY: proto-push
proto-push:
	cd proto && buf push

# ------------------------------------------------------------------------------
# Go
# ------------------------------------------------------------------------------

.PHONY: tidy
tidy:
	$(GO) mod tidy

.PHONY: build
build: tidy
	$(GO) build ./...

.PHONY: vet
vet:
	$(GO) vet ./...

.PHONY: test
test:
	$(GO) test -race -cover ./...

.PHONY: build-identity
build-identity: tidy
	$(GO) build -o bin/identity ./apps/identity/cmd/main.go

# ------------------------------------------------------------------------------
# All
# ------------------------------------------------------------------------------

.PHONY: all
all: proto-lint proto-generate build vet
