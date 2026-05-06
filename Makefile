# Service-specific configuration
SERVICE_NAME := fintech
APP_DIRS     := apps/identity apps/origination apps/loans apps/savings apps/funding apps/operations apps/stawi apps/limits
HAS_UI       := true
UI_DIR       := ui

# Production OAuth — passed to flutter build via --dart-define.
# Dev builds use no flags (app_config.dart defaults to the dev client ID).
OIDC_CLIENT_ID_PROD ?= d6qbqdkpf2t52mcunf60
OIDC_ISSUER_PROD    ?= https://oauth2.stawi.org

# Bootstrap: download shared Makefile.common if missing
ifeq (,$(wildcard .tmp/Makefile.common))
  $(shell mkdir -p .tmp && curl -sSfL https://raw.githubusercontent.com/antinvestor/common/main/Makefile.common -o .tmp/Makefile.common)
endif

include .tmp/Makefile.common

# Dart proto modules — each gets its own buf.gen.dart.<module>.yaml so that
# generation is scoped to a single module and dart packages don't leak each
# other's types. See proto/buf.gen.dart.*.yaml.
DART_MODULES := identity field loans savings funding operations limits

.PHONY: proto-generate-dart
proto-generate-dart: $(BIN)/buf ## Regenerate the per-module dart SDKs
	@if [ ! -d "$(PROTO_DIR)" ]; then exit 0; fi
	@for pkg in $(DART_MODULES); do \
		for other in $(DART_MODULES); do \
			[ "$$pkg" = "$$other" ] && continue; \
			rm -rf sdk/dart/$$pkg/lib/src/$$other; \
		done; \
	done
	@for m in $(DART_MODULES); do \
		echo "==> dart $$m"; \
		(cd $(PROTO_DIR) && buf generate --template buf.gen.dart.$$m.yaml $$m); \
	done

# Wire dart generation into the standard proto-generate pipeline.
proto-generate: proto-generate-dart

# Override prod build to inject this service's production credentials
.PHONY: ui-build-prod
ui-build-prod: ui-generate ## Build Flutter web (production — prod client ID)
	cd $(UI_DIR) && "$(FLUTTER)" build web \
		--release \
		--base-href="/" \
		--tree-shake-icons \
		--dart-define=OIDC_CLIENT_ID=$(OIDC_CLIENT_ID_PROD) \
		--dart-define=OIDC_ISSUER=$(OIDC_ISSUER_PROD)
	@echo "Production build: $(UI_DIR)/build/web/"
