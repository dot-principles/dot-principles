#!/usr/bin/env bash
# check-audit-gates.sh — Verify that Phase 8–10 gate language is intact in all interactive audit files.
# Run locally before pushing, or via CI on PRs that touch audit/skill files.
# Usage: ./tests/check-audit-gates.sh [repo-root]
set -euo pipefail

REPO_ROOT="${1:-$(cd "$(dirname "$0")/.." && pwd)}"

# All three interactive audit files must be checked.
AUDIT_FILES=(
  "$REPO_ROOT/.github/skills/audit/SKILL.md"
  "$REPO_ROOT/.github/prompts/audit.prompt.md"
  "$REPO_ROOT/targets/claude-code/audit.md"
)

# Files that use plain-text output (not ask_user tool) must include the hard-stop phrase.
PLAIN_TEXT_FILES=(
  "$REPO_ROOT/.github/skills/audit/SKILL.md"
  "$REPO_ROOT/targets/claude-code/audit.md"
)

ERRORS=0

check() {
  local file="$1"
  local pattern="$2"
  local label="$3"
  if ! grep -qF "$pattern" "$file"; then
    echo "FAIL [$label]"
    echo "     File   : $file"
    echo "     Missing: $pattern"
    ERRORS=$((ERRORS + 1))
  fi
}

for file in "${AUDIT_FILES[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "FAIL [file-exists] Missing file: $file"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  name="$(basename "$file")"

  check "$file" "## Phase 8"                                    "$name: Phase 8 heading"
  check "$file" "GATE — Requires explicit user approval"        "$name: Phase 8 GATE marker"
  check "$file" "Would you like me to fix these findings"       "$name: Phase 8 fix question"
  check "$file" "Yes, fix them"                                 "$name: Phase 8 Yes choice"
  check "$file" "No, just the report"                          "$name: Phase 8 No choice"
  check "$file" "## Phase 9"                                    "$name: Phase 9 heading"
  check "$file" "## Phase 10"                                   "$name: Phase 10 heading"
done

# Plain-text output files (not using ask_user tool) must include the explicit hard-stop phrase.
for file in "${PLAIN_TEXT_FILES[@]}"; do
  [[ -f "$file" ]] || continue
  name="$(basename "$file")"
  check "$file" "End your response here. Do not call any tools" "$name: Phase 8 hard-stop"
done

if [[ $ERRORS -eq 0 ]]; then
  echo "OK  All Phase 8–10 gate markers verified in ${#AUDIT_FILES[@]} files."
  exit 0
else
  echo ""
  echo "FAIL $ERRORS check(s) failed. The audit gate workflow is incomplete."
  exit 1
fi
