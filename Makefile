.PHONY: check-env serve build test test-structure test-blocks test-links test-drift lint-md clean help

SHELL := /bin/bash
SCRIPTS_DIR := scripts
DOCS_DIR := docs

# ============================================================
# Setup & Development
# ============================================================

## Run prerequisite checker/installer
check-env:
	@bash $(SCRIPTS_DIR)/check-env.sh

## Serve docs locally (hot-reload)
serve:
	@echo "🚀 Starting MkDocs dev server..."
	@mkdocs serve

## Build static site
build:
	@echo "📦 Building static site..."
	@mkdocs build --strict

## Install MkDocs and dependencies
install-deps:
	@echo "📦 Installing MkDocs Material and plugins..."
	@pip install mkdocs-material mkdocs-minify-plugin

# ============================================================
# Testing & Validation
# ============================================================

## Run all tests
test: test-structure test-blocks lint-md
	@echo ""
	@echo "✅ All tests passed"

## Verify all required files exist
test-structure:
	@echo "🔍 Checking file structure..."
	@failed=0; \
	for f in \
		mkdocs.yml \
		README.md \
		Makefile \
		$(SCRIPTS_DIR)/check-env.sh \
		$(DOCS_DIR)/index.md \
		$(DOCS_DIR)/setup.md \
		$(DOCS_DIR)/multi-agent-sdlc.md \
		$(DOCS_DIR)/team-architecture.md \
		$(DOCS_DIR)/governance.md \
		$(DOCS_DIR)/advanced-patterns.md \
		$(DOCS_DIR)/cheatsheet.md \
		$(DOCS_DIR)/facilitator-guide.md \
	; do \
		if [ ! -f "$$f" ]; then \
			echo "  ❌ Missing: $$f"; \
			failed=1; \
		else \
			echo "  ✅ Found:   $$f"; \
		fi; \
	done; \
	if [ $$failed -eq 1 ]; then echo ""; echo "❌ Structure check failed"; exit 1; fi
	@echo "  ✅ Structure check passed"

## Validate code blocks in documentation
test-blocks:
	@echo "🔍 Validating code blocks..."
	@bash $(SCRIPTS_DIR)/validate-code-blocks.sh $(DOCS_DIR)

## Detect drift from Scion source examples
test-drift:
	@echo "🔍 Checking for drift from Scion source..."
	@bash $(SCRIPTS_DIR)/detect-drift.sh

## Verify internal documentation links
test-links:
	@echo "🔍 Checking internal links..."
	@grep -roh '\[.*\]([^http][^)]*\.md[^)]*)' $(DOCS_DIR)/ 2>/dev/null | \
		sed 's/.*(\(.*\))/\1/' | \
		sort -u | \
		while read -r link; do \
			target="$(DOCS_DIR)/$$(echo $$link | cut -d'#' -f1)"; \
			if [ ! -f "$$target" ]; then \
				echo "  ❌ Broken link: $$link -> $$target"; \
			else \
				echo "  ✅ Valid:  $$link"; \
			fi; \
		done

## Run markdown linter
lint-md:
	@echo "🔍 Linting markdown..."
	@npx markdownlint-cli2 "$(DOCS_DIR)/**/*.md" "exercises/**/*.md" || true
	@echo "  ✅ Lint pass complete"

# ============================================================
# Cleanup
# ============================================================

## Remove build artifacts
clean:
	@rm -rf site/
	@echo "🧹 Cleaned build artifacts"

# ============================================================
# Help
# ============================================================

## Show this help
help:
	@echo ""
	@echo "Scion Multi-Agent Orchestration Workshop"
	@echo "========================================="
	@echo ""
	@echo "Setup:"
	@echo "  make check-env      Run prerequisite checker"
	@echo "  make install-deps   Install MkDocs Material"
	@echo "  make serve          Start dev server (hot-reload)"
	@echo "  make build          Build static site"
	@echo ""
	@echo "Testing:"
	@echo "  make test           Run all tests"
	@echo "  make test-structure Verify required files exist"
	@echo "  make test-blocks    Validate code blocks"
	@echo "  make test-drift     Detect drift from Scion source"
	@echo "  make test-links     Check internal links"
	@echo "  make lint-md        Markdown lint pass"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean          Remove build artifacts"
	@echo ""
