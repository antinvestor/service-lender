# Service-specific configuration
SERVICE_NAME := lender
APP_DIRS     := apps/identity apps/origination apps/loans apps/savings

# Disable common Makefile's Flutter targets — we override them below
HAS_UI       := false
UI_DIR       := ui

# Flutter config
FLUTTER_HOME   ?= $(HOME)/flutter
FLUTTER        := $(FLUTTER_HOME)/bin/flutter
DART           := $(FLUTTER_HOME)/bin/dart

# Production OAuth client ID (dev is the default in app_config.dart)
OIDC_CLIENT_ID_PROD ?= d6qbqdkpf2t52mcunf60
OIDC_ISSUER_PROD    ?= https://oauth2.stawi.org

# Bootstrap: download shared Makefile.common if missing
ifeq (,$(wildcard .tmp/Makefile.common))
  $(shell mkdir -p .tmp && curl -sSfL https://raw.githubusercontent.com/antinvestor/common/main/Makefile.common -o .tmp/Makefile.common)
endif

include .tmp/Makefile.common

# ==============================================================================
# Flutter UI targets
# ==============================================================================

.PHONY: flutter-install
flutter-install: ## Download and install Flutter SDK (stable) if not present
	@if [ -x "$(FLUTTER)" ]; then \
		echo "Flutter already installed: $$("$(FLUTTER)" --version | head -1)"; \
	else \
		echo "==> Installing Flutter SDK (stable)..."; \
		FLUTTER_URL=$$(curl -s https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json \
			| python3 -c "import json,sys; r=json.load(sys.stdin); print('https://storage.googleapis.com/flutter_infra_release/releases/' + [x for x in r['releases'] if x['hash']==r['current_release']['stable']][0]['archive'])"); \
		echo "Downloading $$FLUTTER_URL"; \
		curl -sL "$$FLUTTER_URL" | tar xJ -C "$(dir $(FLUTTER_HOME))"; \
		"$(FLUTTER)" precache --web; \
		echo "Flutter installed: $$("$(FLUTTER)" --version | head -1)"; \
	fi

.PHONY: ui-deps
ui-deps: flutter-install ## Install Flutter dependencies
	cd $(UI_DIR) && "$(FLUTTER)" pub get

.PHONY: ui-generate
ui-generate: ui-deps ## Run build_runner code generation
	@if grep -q 'build_runner' $(UI_DIR)/pubspec.yaml 2>/dev/null; then \
		cd $(UI_DIR) && "$(DART)" run build_runner build --delete-conflicting-outputs; \
	fi

.PHONY: ui-analyze
ui-analyze: ui-deps ## Analyze Flutter code
	cd $(UI_DIR) && "$(FLUTTER)" analyze

.PHONY: ui-test
ui-test: ui-generate ## Run Flutter tests
	cd $(UI_DIR) && "$(FLUTTER)" test

.PHONY: ui-build-dev
ui-build-dev: ui-generate ## Build Flutter web (development — dev client ID)
	cd $(UI_DIR) && "$(FLUTTER)" build web \
		--profile \
		--base-href="/" \
		--source-maps
	@echo "Dev build: $(UI_DIR)/build/web/"

.PHONY: ui-build-prod
ui-build-prod: ui-generate ## Build Flutter web (production — prod client ID)
	cd $(UI_DIR) && "$(FLUTTER)" build web \
		--release \
		--base-href="/" \
		--tree-shake-icons \
		--dart-define=OIDC_CLIENT_ID=$(OIDC_CLIENT_ID_PROD) \
		--dart-define=OIDC_ISSUER=$(OIDC_ISSUER_PROD)
	@echo "Production build: $(UI_DIR)/build/web/"

.PHONY: ui-build
ui-build: ui-build-dev ## Default UI build (development)

.PHONY: ui-clean
ui-clean: ## Clean Flutter build artifacts
	cd $(UI_DIR) && "$(FLUTTER)" clean
	rm -rf $(UI_DIR)/build

# ------------------------------------------------------------------------------
# Override aggregate targets to include UI
# ------------------------------------------------------------------------------

.PHONY: all
all: proto-lint build test lint ui-analyze ## Full pipeline: protos, Go, Flutter

.PHONY: clean
clean: ui-clean ## Delete all generated / temporary files
	rm -rf $(BIN)
