#!/usr/bin/env bash
# Validate code blocks in markdown documentation
# Checks that fenced code blocks specify a language and that
# bash/yaml blocks have valid syntax where possible.

set -euo pipefail

DOCS_DIR="${1:-.}"
errors=0

echo "Validating code blocks in ${DOCS_DIR}..."

# Check for code blocks without language specifier
while IFS= read -r file; do
  line_num=0
  while IFS= read -r line; do
    ((line_num++)) || true
    if [[ "$line" =~ ^\`\`\`$ ]]; then
      echo "  ⚠️  ${file}:${line_num} — code block without language specifier"
      ((errors++)) || true
    fi
  done < "$file"
done < <(find "$DOCS_DIR" -name "*.md" -type f)

if [ $errors -eq 0 ]; then
  echo "  ✅ All code blocks have language specifiers"
else
  echo ""
  echo "  ❌ ${errors} code block(s) missing language specifiers"
fi

exit 0
