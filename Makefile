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

.PHONY: format
format:
	find . -name '*.go' -not -path './.git/*' -exec sed -i '/^import (/,/^)/{/^$$/ d}' {} +
	find . -name '*.go' -not -path './.git/*' -exec goimports -w {} +
	golangci-lint run --fix -c .golangci.yaml

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

UI_WEB_PORT := 5174
UI_CHROME_FLAGS := --web-browser-flag="--disable-web-security" --web-browser-flag="--user-data-dir=/tmp/chrome-cors-disabled"

# Full setup: regenerate proto SDK, fetch deps, run codegen. Use after proto changes.
.PHONY: ui-setup
ui-setup: proto-generate
	cd app-ui && flutter pub get && dart run build_runner build --delete-conflicting-outputs

.PHONY: ui-get
ui-get:
	cd app-ui && flutter pub get

.PHONY: ui-codegen
ui-codegen:
	cd app-ui && dart run build_runner build --delete-conflicting-outputs

.PHONY: ui-run
ui-run:
	cd app-ui && flutter run

.PHONY: ui-run-web
ui-run-web:
	cd app-ui && flutter run -d chrome --web-port=$(UI_WEB_PORT) $(UI_CHROME_FLAGS)

.PHONY: ui-run-linux
ui-run-linux:
	cd app-ui && flutter run -d linux

.PHONY: ui-build-web
ui-build-web:
	cd app-ui && flutter build web --release

.PHONY: ui-test
ui-test:
	cd app-ui && flutter test

.PHONY: ui-analyze
ui-analyze:
	cd app-ui && flutter analyze --no-fatal-infos

# ------------------------------------------------------------------------------
# All
# ------------------------------------------------------------------------------

.PHONY: all
all: proto-lint proto-generate build vet
