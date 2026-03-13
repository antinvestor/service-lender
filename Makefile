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
	rm -rf app-ui/lib/sdk/src/lender app-ui/lib/sdk/src/google app-ui/lib/sdk/src/buf app-ui/lib/sdk/src/common app-ui/lib/sdk/src/gnostic
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
# UI
# ------------------------------------------------------------------------------

.PHONY: ui-sdk
ui-sdk: proto-generate

.PHONY: ui-get
ui-get: ui-sdk
	cd app-ui && flutter pub get

.PHONY: ui-codegen
ui-codegen: ui-get
	cd app-ui && dart run build_runner build --delete-conflicting-outputs

.PHONY: ui-run
ui-run: ui-codegen
	cd app-ui && flutter run

.PHONY: ui-run-web
ui-run-web: ui-codegen
	cd app-ui && flutter run -d chrome

.PHONY: ui-run-linux
ui-run-linux: ui-codegen
	cd app-ui && flutter run -d linux

.PHONY: ui-test
ui-test: ui-codegen
	cd app-ui && flutter test

.PHONY: ui-analyze
ui-analyze: ui-get
	cd app-ui && flutter analyze --no-fatal-infos

# ------------------------------------------------------------------------------
# All
# ------------------------------------------------------------------------------

.PHONY: all
all: proto-lint proto-generate build vet
