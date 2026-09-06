#!/usr/bin/env bash
# check-retired-prime.sh - Verify that upgrades remove retired dot-prime assets.
# Usage: ./tests/check-retired-prime.sh [repo-root]
set -euo pipefail

REPO_ROOT="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
TEST_ROOT="$(mktemp -d)"
PROJECT_DIR="$TEST_ROOT/project"
TEST_HOME="$TEST_ROOT/home"
trap 'rm -rf "$TEST_ROOT"' EXIT

mkdir -p \
    "$PROJECT_DIR/.agents/skills/dot-prime" \
    "$PROJECT_DIR/.agents/skills/user" \
    "$PROJECT_DIR/.github/skills/dot-prime" \
    "$PROJECT_DIR/.github/prompts" \
    "$PROJECT_DIR/.claude/commands/dot" \
    "$PROJECT_DIR/.claude/commands" \
    "$PROJECT_DIR/.agents/principles-catalog" \
    "$TEST_HOME"

printf '%s\n' '---' 'generated-by: ".principles v0.13.2"' '---' \
    > "$PROJECT_DIR/.agents/skills/dot-prime/SKILL.md"
printf '%s\n' '---' 'generated-by: user' '---' \
    > "$PROJECT_DIR/.agents/skills/user/SKILL.md"
printf '%s\n' '---' 'generated-by: ".principles v0.13.2"' '---' \
    > "$PROJECT_DIR/.github/skills/dot-prime/SKILL.md"
printf '%s\n' '---' 'generated-by: ".principles v0.13.2"' '---' \
    > "$PROJECT_DIR/.github/prompts/dot-prime.prompt.md"
printf '%s\n' '---' 'generated-by: ".principles v0.13.2"' '---' \
    > "$PROJECT_DIR/.claude/commands/dot/prime.md"
printf '%s\n' 'legacy prime command' > "$PROJECT_DIR/.claude/commands/dot-prime.md"
printf '%s\n' '# legacy install without target metadata' > "$PROJECT_DIR/.agents/principles-catalog/install.cfg"

if [ ! -f "$REPO_ROOT/commands/dot/audit.md" ] || [ ! -f "$REPO_ROOT/commands/dot/scout.md" ]; then
    echo "FAIL [current commands] scout or audit source is missing"
    exit 1
fi
if [ -e "$REPO_ROOT/commands/dot/prime.md" ] || [ -e "$REPO_ROOT/.agents/skills/dot-prime" ]; then
    echo "FAIL [retired source] dot-prime source or generated skill still exists"
    exit 1
fi
if find "$REPO_ROOT/principles" -name '.context-prime.md' -print -quit | grep -q .; then
    echo "FAIL [retired context] built-in prime context still exists"
    exit 1
fi

HOME="$TEST_HOME" bash "$REPO_ROOT/install.sh" vendor "$PROJECT_DIR" >/dev/null

for retired in \
    "$PROJECT_DIR/.agents/skills/dot-prime" \
    "$PROJECT_DIR/.github/skills/dot-prime" \
    "$PROJECT_DIR/.github/prompts/dot-prime.prompt.md" \
    "$PROJECT_DIR/.claude/commands/dot/prime.md" \
    "$PROJECT_DIR/.claude/commands/dot-prime.md"; do
    if [ -e "$retired" ]; then
        echo "FAIL [upgrade cleanup] retired asset remains: $retired"
        exit 1
    fi
done

for current in \
    "$PROJECT_DIR/.agents/skills/dot-audit/SKILL.md" \
    "$PROJECT_DIR/.agents/skills/dot-scout/SKILL.md"; do
    if [ ! -f "$current" ]; then
        echo "FAIL [current install] missing replacement asset: $current"
        exit 1
    fi
done

if [ ! -f "$PROJECT_DIR/.agents/skills/user/SKILL.md" ]; then
    echo "FAIL [user asset] unmarked user skill was removed"
    exit 1
fi
if find "$PROJECT_DIR/.agents/principles-catalog" -name '.context-prime.md' -print -quit | grep -q .; then
    echo "FAIL [catalog cleanup] prime context was copied to adopter catalog"
    exit 1
fi

echo "OK  Retired dot-prime assets are removed during vendor upgrades."
