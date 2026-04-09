# Service-specific configuration
SERVICE_NAME := fintech
APP_DIRS     := apps/identity apps/origination apps/loans apps/savings apps/stawi
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
