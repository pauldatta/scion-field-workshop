#!/usr/bin/env bash
# Detect drift between workshop content and Scion source examples.
# Compares key files/patterns in the workshop against the upstream
# Scion repository to flag outdated references.

set -euo pipefail

SCION_SRC="${1:-../../research/scion-source}"
DOCS_DIR="docs"
errors=0

echo "Checking for drift against Scion source at ${SCION_SRC}..."

if [ ! -d "$SCION_SRC" ]; then
  echo "  ⚠️  Scion source directory not found at ${SCION_SRC}"
  echo "     Skipping drift detection."
  exit 0
fi

# Check that referenced example directories still exist
examples=(
  "examples/agent-poker"
  "examples/orchestration-basics/fan-out-parallel"
  "examples/orchestration-basics/sequence"
  "examples/adk_scion_agent"
  "examples/amp"
  "skills/team-creation"
  "skills/scion"
  "extras/agent-viz"
  "extras/scion-a2a-bridge"
  "extras/scion-chat-app"
)

for example in "${examples[@]}"; do
  if [ -d "${SCION_SRC}/${example}" ]; then
    echo "  ✅ ${example} exists"
  else
    echo "  ❌ ${example} — directory missing from source"
    ((errors++)) || true
  fi
done

# Check that key concept files still exist
concept_files=(
  "docs-site/src/content/docs/concepts.md"
  "docs-site/src/content/docs/philosophy.md"
  "supported-harnesses.md"
)

for cf in "${concept_files[@]}"; do
  if [ -f "${SCION_SRC}/${cf}" ]; then
    echo "  ✅ ${cf} exists"
  else
    echo "  ❌ ${cf} — file missing from source"
    ((errors++)) || true
  fi
done

echo ""
if [ $errors -eq 0 ]; then
  echo "  ✅ No drift detected"
else
  echo "  ❌ ${errors} item(s) may have drifted — review Scion source for changes"
fi

exit 0
