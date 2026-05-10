#!/usr/bin/env bash
# ============================================================
# Scion Workshop — Environment Prerequisite Checker
# ============================================================
# Validates and optionally installs prerequisites for the
# Scion Multi-Agent Orchestration Workshop.
#
# Usage: bash scripts/check-env.sh
# Linked to: make check-env
# ============================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

PASS="${GREEN}✅${NC}"
FAIL="${RED}❌${NC}"
WARN="${YELLOW}⚠️${NC}"

errors=0
warnings=0

header() {
  echo ""
  echo -e "${BOLD}${CYAN}═══════════════════════════════════════════${NC}"
  echo -e "${BOLD}${CYAN}  Scion Workshop — Environment Check${NC}"
  echo -e "${BOLD}${CYAN}═══════════════════════════════════════════${NC}"
  echo ""
}

check_command() {
  local cmd="$1"
  local name="$2"
  local min_version="${3:-}"
  local install_hint="${4:-}"

  if command -v "$cmd" &>/dev/null; then
    local version
    version=$("$cmd" --version 2>&1 | head -1 || echo "unknown")
    echo -e "  ${PASS} ${name}: ${version}"
    return 0
  else
    echo -e "  ${FAIL} ${name}: not found"
    if [ -n "$install_hint" ]; then
      echo -e "      ${YELLOW}→ Install: ${install_hint}${NC}"
    fi
    ((errors++)) || true
    return 1
  fi
}

check_docker_running() {
  if docker info &>/dev/null 2>&1; then
    echo -e "  ${PASS} Docker daemon: running"
    return 0
  else
    echo -e "  ${FAIL} Docker daemon: not running"
    echo -e "      ${YELLOW}→ Start Docker Desktop or run: sudo systemctl start docker${NC}"
    ((errors++)) || true
    return 1
  fi
}

check_go_version() {
  if command -v go &>/dev/null; then
    local go_version
    go_version=$(go version | grep -oE 'go[0-9]+\.[0-9]+' | sed 's/go//')
    local major minor
    major=$(echo "$go_version" | cut -d. -f1)
    minor=$(echo "$go_version" | cut -d. -f2)
    if [ "$major" -ge 1 ] && [ "$minor" -ge 22 ]; then
      echo -e "  ${PASS} Go ${go_version} (>= 1.22 required)"
      return 0
    else
      echo -e "  ${FAIL} Go ${go_version} found, but >= 1.22 required"
      ((errors++)) || true
      return 1
    fi
  else
    echo -e "  ${FAIL} Go: not found"
    echo -e "      ${YELLOW}→ Install: brew install go (macOS) or https://go.dev/dl/${NC}"
    ((errors++)) || true
    return 1
  fi
}

check_node_version() {
  if command -v node &>/dev/null; then
    local node_version
    node_version=$(node --version | sed 's/v//')
    local major
    major=$(echo "$node_version" | cut -d. -f1)
    if [ "$major" -ge 18 ]; then
      echo -e "  ${PASS} Node.js ${node_version} (>= 18 required)"
      return 0
    else
      echo -e "  ${FAIL} Node.js ${node_version} found, but >= 18 required"
      ((errors++)) || true
      return 1
    fi
  else
    echo -e "  ${FAIL} Node.js: not found"
    echo -e "      ${YELLOW}→ Install: brew install node (macOS) or https://nodejs.org/${NC}"
    ((errors++)) || true
    return 1
  fi
}

check_scion() {
  if command -v scion &>/dev/null; then
    local version
    version=$(scion version 2>&1 || scion --version 2>&1 || echo "installed")
    echo -e "  ${PASS} Scion: ${version}"
    return 0
  else
    echo -e "  ${WARN} Scion: not found (will build from source if Go is available)"
    ((warnings++)) || true
    return 1
  fi
}

build_scion() {
  echo ""
  echo -e "${BOLD}Building Scion from source...${NC}"

  if ! command -v go &>/dev/null; then
    echo -e "  ${FAIL} Cannot build Scion: Go is not installed"
    ((errors++)) || true
    return 1
  fi

  local scion_src="../../research/scion-source"
  if [ ! -d "$scion_src" ]; then
    echo -e "  ${WARN} Scion source not found at ${scion_src}"
    echo -e "  ${YELLOW}→ Clone Scion: git clone --depth=1 https://github.com/GoogleCloudPlatform/scion.git ${scion_src}${NC}"
    ((warnings++)) || true
    return 1
  fi

  echo -e "  Building from ${scion_src}..."
  (cd "$scion_src" && go install ./cmd/scion/...) 2>&1 | sed 's/^/  /'

  if command -v scion &>/dev/null; then
    echo -e "  ${PASS} Scion built and installed successfully"
    return 0
  else
    echo -e "  ${FAIL} Scion build failed"
    ((errors++)) || true
    return 1
  fi
}

# ============================================================
# Main
# ============================================================

header

echo -e "${BOLD}Core Dependencies${NC}"
check_go_version
check_command "git" "Git" "2.40" "brew install git"
check_command "docker" "Docker CLI" "" "https://docs.docker.com/get-docker/"
check_docker_running
check_node_version
check_command "jq" "jq" "" "brew install jq"

echo ""
echo -e "${BOLD}Scion${NC}"
if ! check_scion; then
  read -rp "  Build Scion from source? (y/N) " build_answer
  if [[ "$build_answer" =~ ^[Yy]$ ]]; then
    build_scion
  fi
fi

echo ""
echo -e "${BOLD}Optional (for docs development)${NC}"
check_command "mkdocs" "MkDocs" "" "pip install mkdocs-material"
check_command "npx" "npx" "" "Included with Node.js"

# ============================================================
# Summary
# ============================================================

echo ""
echo -e "${BOLD}${CYAN}═══════════════════════════════════════════${NC}"
if [ $errors -eq 0 ]; then
  echo -e "${BOLD}${GREEN}  ✅ All prerequisites met — ready for workshop!${NC}"
else
  echo -e "${BOLD}${RED}  ❌ ${errors} issue(s) found — resolve before the workshop${NC}"
fi
if [ $warnings -gt 0 ]; then
  echo -e "${BOLD}${YELLOW}  ⚠️  ${warnings} warning(s) — review above${NC}"
fi
echo -e "${BOLD}${CYAN}═══════════════════════════════════════════${NC}"
echo ""

exit $errors
