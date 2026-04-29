#!/usr/bin/env bash
# check-audit-gates.sh — Verify that Phase 8–10 gate language is intact in all interactive audit files.
# Run locally before pushing, or via CI on PRs that touch audit/skill files.
# Usage: ./tests/check-audit-gates.sh [repo-root]
set -euo pipefail

REPO_ROOT="${1:-$(cd "$(dirname "$0")/.." && pwd)}"

# All interactive audit files must be checked.
# .agents/skills/ is the canonical install location (run `./install.sh vendor .` first).
# .github/prompts/ is a thin wrapper with no gate content — not checked here.
AUDIT_FILES=(
  "$REPO_ROOT/.agents/skills/dot-audit/SKILL.md"
  "$REPO_ROOT/commands/dot/audit.md"
)

# Files that use plain-text output (not ask_user tool) must include the hard-stop phrase.
PLAIN_TEXT_FILES=(
  "$REPO_ROOT/.agents/skills/dot-audit/SKILL.md"
  "$REPO_ROOT/commands/dot/audit.md"
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
  check "$file" "How would you like to proceed"                 "$name: Phase 9 commit question"
  check "$file" "Commit only"                                   "$name: Phase 9 Commit-only choice"
  check "$file" "Commit and push"                               "$name: Phase 9 Commit-and-push choice"
  check "$file" "Exit"                                          "$name: Phase 9 Exit choice"
  check "$file" "## Phase 10"                                   "$name: Phase 10 heading"
  check "$file" "Shall I open a pull request"                   "$name: Phase 10 PR question"
  check "$file" "Yes, open PR"                                  "$name: Phase 10 Yes choice"
  check "$file" "No, keep the branch"                           "$name: Phase 10 No choice"
done

# Plain-text output files (not using ask_user tool) must include the explicit hard-stop phrase
# for all three gates (Phase 8, 9, and 10 each end with this instruction).
for file in "${PLAIN_TEXT_FILES[@]}"; do
  [[ -f "$file" ]] || continue
  name="$(basename "$file")"
  count=$(grep -cF "End your response here. Do not call any tools" "$file" || true)
  if [[ "$count" -lt 3 ]]; then
    echo "FAIL [$name: hard-stop count]"
    echo "     File   : $file"
    echo "     Expected: 3 occurrences of hard-stop (Phases 8, 9, 10); found: $count"
    ERRORS=$((ERRORS + 1))
  fi
done

if [[ $ERRORS -eq 0 ]]; then
  echo "OK  All Phase 8–10 gate markers verified in ${#AUDIT_FILES[@]} files."
  exit 0
else
  echo ""
  echo "FAIL $ERRORS check(s) failed. The audit gate workflow is incomplete."
  exit 1
fi
