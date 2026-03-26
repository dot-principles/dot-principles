#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Flemming N. Larsen — https://github.com/dot-principles/principles
set -euo pipefail

# install.sh — Deploy .principles to AI coding tools
#
# Usage:
#   ./install.sh claude <dir>      # Install Claude Code slash commands in <dir>/.claude/commands/
#   ./install.sh copilot <dir>     # Generate Copilot assets in <dir>/.github/
#                                  #   .github/copilot-instructions.md  (all Copilot clients)
#                                  #   .github/skills/<name>/SKILL.md   (Copilot CLI slash commands)
#                                  #   .github/prompts/<name>.prompt.md (VS Code / JetBrains / Visual Studio)
#   ./install.sh vendor <dir>      # Copy catalog subset to <dir>/.principles-catalog/
#   ./install.sh all <dir>         # Run claude + copilot + vendor in <dir>
#   ./install.sh --list <dir>      # Show what's installed in <dir>
#   ./uninstall.sh <dir>           # Remove local assets from <dir>

# Convert a Windows-style path (C:\... or C:/...) to a path the current bash understands.
# Under WSL, uses wslpath. Under Git Bash / native Linux/macOS, returns the path unchanged.
normalize_path() {
    local p="$1"
    if [[ -n "$p" && "$p" =~ ^[A-Za-z]:[/\\] ]]; then
        if command -v wslpath &>/dev/null; then
            wslpath -u "$p"
            return
        fi
    fi
    printf '%s' "$p"
}

normalize_directory_path() {
    local dir
    dir="$(normalize_path "$1")"
    if [ -z "$dir" ]; then
        printf '%s' "$dir"
        return
    fi

    case "$dir" in
        /|[A-Za-z]:/)
            printf '%s' "$dir"
            return
            ;;
    esac

    while [ "${dir%/}" != "$dir" ]; do
        dir="${dir%/}"
    done

    printf '%s' "$dir"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="$(cat "$SCRIPT_DIR/VERSION" | tr -d '[:space:]')"

CLAUDE_TARGETS_DIR="$SCRIPT_DIR/targets/claude-code"

# Colors (if terminal supports them)
if [ -t 1 ]; then
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    BOLD='\033[1m'
    NC='\033[0m'
else
    GREEN='' YELLOW='' RED='' BOLD='' NC=''
fi

print_header() {
    echo ""
    echo -e "${BOLD}.principles installer${NC}"
    echo "─────────────────────────"
}

copilot_prompt_description() {
    case "$1" in
        scout)
            echo "Detect project profile and create or update .principles files (Experimental)"
            ;;
        prime)
            echo "Activate code principles before writing code (Experimental)"
            ;;
        audit)
            echo "Review code against the active principles and group findings by severity (Experimental)"
            ;;
        *)
            echo "Run the $1 .principles workflow (Experimental)"
            ;;
    esac
}

copilot_skill_description() {
    case "$1" in
        scout)
            echo "Analyse the project, detect language/framework/domain, and create or update .principles files. Use this skill when asked to scout, detect project profile, or set up principles."
            ;;
        prime)
            echo "Resolve the .principles hierarchy, load full principle guidance, and prepare a coding frame. Use this skill when asked to prime, activate principles, or before writing code."
            ;;
        audit)
            echo "Resolve the .principles hierarchy, load principle content, review code, and group findings by severity (Critical/High/Medium/Low). Use this skill when asked to audit or review code against principles."
            ;;
        *)
            echo "Run the $1 .principles workflow."
            ;;
    esac
}

write_principles_body() {
    local target_file="$1"
    cat >> "$target_file" << 'PRINCIPLES_EOF'
# Code Principles — AI Coding Guidelines

When writing or reviewing code, follow the layered principle system below.

## Layer 1 — Always Active

Non-negotiable fundamentals that apply to every line of code: single responsibility, no duplication, reveal intention, fail fast, validate input, delete dead code.

## Layer 2 — Context-Dependent

Additional principles activated by what you're building. Covers API design, concurrency, domain modeling, testing, cloud-native, and infrastructure patterns.

## Layer 3 — Risk-Elevated

Extra scrutiny for high-risk areas where mistakes are costly or hard to reverse: authentication, financial transactions, personal data (PII), public APIs, performance-critical paths, and distributed systems.
PRINCIPLES_EOF
}


write_copilot_skill() {
    local source_file="$1"
    local skill_dir="$2"
    local command_name="$3"

    mkdir -p "$skill_dir"
    local skill_file="$skill_dir/SKILL.md"

    cat > "$skill_file" <<EOF
---
name: $command_name
description: $(copilot_skill_description "$command_name")
license: MIT
---

EOF

    cat "$source_file" >> "$skill_file"
}


write_copilot_prompt() {
    local source_file="$1"
    local prompt_file="$2"
    local command_name="$3"

    cat > "$prompt_file" <<EOF
---
description: $(copilot_prompt_description "$command_name")
mode: agent
---

EOF

    cat "$source_file" >> "$prompt_file"
}

install_claude() {
    local project_dir="$1"

    if [ ! -d "$project_dir" ]; then
        echo -e "${RED}Error: Directory '$project_dir' does not exist.${NC}"; exit 1
    fi

    local target_dir="$project_dir/.claude/commands"
    echo -e "${BOLD}Installing Claude Code slash commands (local: $project_dir)...${NC}"

    mkdir -p "$target_dir"

    local count=0
    for file in "$CLAUDE_TARGETS_DIR/"*.md; do
        if [ -f "$file" ]; then
            sed -e "s|{{PRINCIPLES_DIRECTORY}}|.principles-catalog|g" -e "s|{{VERSION}}|$VERSION|g" "$file" > "$target_dir/$(basename "$file")"
            count=$((count + 1))
            echo -e "  ${GREEN}✓${NC} /$(basename "$file" .md)"
        fi
    done

    echo ""
    echo -e "Installed ${BOLD}$count${NC} commands to $target_dir"
    echo ""
    echo "Available commands:"
    echo "  /scout  — Detect project profile and generate .principles placements"
    echo "  /prime  — Activate principles before writing code"
    echo "  /audit  — Review code with severity-categorized findings; use /audit <spec> on <target> to force specific principles"
}

install_copilot_local() {
    local project_dir="$1"

    if [ ! -d "$project_dir" ]; then
        echo -e "${RED}Error: Directory '$project_dir' does not exist.${NC}"
        exit 1
    fi

    echo -e "${BOLD}Generating Copilot instructions for: $project_dir${NC}"

    local target_dir="$project_dir/.github"
    local target_file="$target_dir/copilot-instructions.md"
    local prompts_dir="$target_dir/prompts"

    mkdir -p "$target_dir"
    mkdir -p "$prompts_dir"

    # Build the new block in a temp file
    local block_file
    block_file="$(mktemp)"
    echo "<!-- .principles: begin -->" > "$block_file"
    write_principles_body "$block_file"
    echo "<!-- .principles: end -->" >> "$block_file"

    if [ ! -f "$target_file" ] || [ ! -s "$target_file" ]; then
        # New or empty file: create with just the block
        cp "$block_file" "$target_file"
    elif grep -q "^<!-- .principles: begin -->$" "$target_file"; then
        # Existing block found: replace it in-place
        local result_file
        result_file="$(mktemp)"
        awk '
            BEGIN { in_block=0 }
            /^<!-- .principles: begin -->$/ { in_block=1; next }
            /^<!-- .principles: end -->$/ { if (in_block) { in_block=0; next } }
            !in_block { print }
        ' "$target_file" > "$result_file"
        # Trim trailing blank lines, then append the new block
        awk '{lines[NR]=$0; if(/[^[:space:]]/) last=NR} END{for(i=1;i<=last;i++) print lines[i]}' \
            "$result_file" > "${result_file}.t" && mv "${result_file}.t" "$result_file"
        [ -s "$result_file" ] && echo "" >> "$result_file"
        cat "$block_file" >> "$result_file"
        mv "$result_file" "$target_file"
    else
        # Existing file without our block: append
        echo "" >> "$target_file"
        cat "$block_file" >> "$target_file"
    fi

    rm -f "$block_file"

    echo -e "${BOLD}Installing Copilot skills and prompt commands...${NC}"

    local prompt_count=0
    local file
    local skills_dir="$target_dir/skills"

    for file in "$CLAUDE_TARGETS_DIR/"*.md; do
        if [ -f "$file" ]; then
            local command_name
            local prompt_file
            command_name="$(basename "$file" .md)"
            prompt_file="$prompts_dir/$command_name.prompt.md"
            # For audit: rewrite ~/.claude/ paths to project-relative paths
            local patched_file
            patched_file="$(mktemp)"
            sed \
                -e "s|{{PRINCIPLES_DIRECTORY}}|.principles-catalog|g" \
                -e "s|{{VERSION}}|$VERSION|g" \
                -e 's|~/.claude/audit-output\.json|.github/scripts/audit-output.json|g' \
                "$file" > "$patched_file"
            write_copilot_prompt "$patched_file" "$prompt_file" "$command_name"
            write_copilot_skill "$patched_file" "$skills_dir/$command_name" "$command_name"
            rm -f "$patched_file"
            prompt_count=$((prompt_count + 1))
            echo -e "  ${GREEN}✓${NC} /$command_name"
        fi
    done

    echo -e "  ${GREEN}✓${NC} $target_file"
    echo ""
    echo "Copilot assets written:"
    echo "  - .github/copilot-instructions.md"
    echo "  - .github/skills/<name>/SKILL.md  (${prompt_count} skills  — Copilot CLI slash commands)"
    echo "  - .github/prompts/*.prompt.md      (${prompt_count} prompts — VS Code prompt files)"
    echo ""
    echo "In Copilot CLI: use /audit, /prime, /scout  (or run '/skills reload' if already in a session)"
    echo "In VS Code:     type /audit, /prime, /scout  in Copilot Chat"
}

generate_compact_index() {
    local catalog_dir="$1"
    local index_file="$catalog_dir/index.tsv"
    local tmp="$index_file.tmp"

    find "$SCRIPT_DIR/principles" -name "*.md" \
        ! -name ".context-*.md" \
        ! -name "TEMPLATE.md" \
        ! -name "AUDIT-SCOPE.md" \
        ! -name "catalog.yaml" | sort | while IFS= read -r f; do

        local id layer summary
        id="$(head -1 "$f" | sed 's/^# \([A-Z0-9][A-Z0-9_-]*\) .*/\1/')"
        layer="$(grep -m1 '^\*\*Layer:\*\*' "$f" | sed 's/\*\*Layer:\*\* \([0-9]\).*/\1/')"
        summary="$(grep -m1 '^\*\*Summary:\*\*' "$f" | sed 's/^\*\*Summary:\*\* //')"

        if [ -n "$id" ] && [ -n "$layer" ] && [ -n "$summary" ]; then
            printf '%s|%s|%s\n' "$id" "$layer" "$summary"
        fi
    done | sort > "$tmp"

    mv "$tmp" "$index_file"
    echo -e "  ${GREEN}✓${NC} index.tsv ($(wc -l < "$index_file") principles)"
}

install_vendor() {
    local project_dir="$1"

    if [ ! -d "$project_dir" ]; then
        echo -e "${RED}Error: Directory '$project_dir' does not exist.${NC}"; exit 1
    fi

    echo -e "${BOLD}Vendoring catalog to: $project_dir/.principles-catalog/${NC}"

    local catalog_dir="$project_dir/.principles-catalog"
    mkdir -p "$catalog_dir"

    cp -r "$SCRIPT_DIR/groups"  "$catalog_dir/"
    cp -r "$SCRIPT_DIR/layers"  "$catalog_dir/"
    echo -e "  ${GREEN}✓${NC} groups/"
    echo -e "  ${GREEN}✓${NC} layers/"

    local principles_src="$SCRIPT_DIR/principles"
    local principles_dst="$catalog_dir/principles"
    mkdir -p "$principles_dst"

    for ns_dir in "$principles_src"/*/; do
        [ -d "$ns_dir" ] || continue
        local ns
        ns="$(basename "$ns_dir")"
        local ns_dst="$principles_dst/$ns"
        local copied=false
        for context_file in ".context-audit.md" ".context-prime.md" ".context-inspect.md" "catalog.yaml"; do
            if [ -f "$ns_dir/$context_file" ]; then
                mkdir -p "$ns_dst"
                cp "$ns_dir/$context_file" "$ns_dst/"
                copied=true
            fi
        done
        if [ "$copied" = true ]; then
            echo -e "  ${GREEN}✓${NC} principles/$ns/"
        fi
    done

    for top_file in "TEMPLATE.md" "AUDIT-SCOPE.md" "catalog.yaml"; do
        if [ -f "$principles_src/$top_file" ]; then
            cp "$principles_src/$top_file" "$principles_dst/"
            echo -e "  ${GREEN}✓${NC} principles/$top_file"
        fi
    done

    generate_compact_index "$catalog_dir"

    echo ""
    echo "Catalog vendored to $catalog_dir"
    echo "Skills resolve principles from .principles-catalog/ (relative to git root)."
}

list_installed() {
    local project_dir="$1"
    echo -e "${BOLD}Installed .principles (project: $project_dir):${NC}"
    echo ""

    echo "Claude Code commands (.claude/commands/):"
    local found=false
    for file in "$CLAUDE_TARGETS_DIR/"*.md; do
        if [ -f "$file" ] && [ -f "$project_dir/.claude/commands/$(basename "$file")" ]; then
            echo -e "  ${GREEN}✓${NC} /$(basename "$file" .md)"
            found=true
        fi
    done
    if [ "$found" = false ]; then
        echo "  (none)"
    fi

    echo ""
    echo "Copilot skills (.github/skills/):"
    local copilot_found=false
    for file in "$CLAUDE_TARGETS_DIR/"*.md; do
        if [ -f "$file" ]; then
            local command_name
            command_name="$(basename "$file" .md)"
            local skill_file="$project_dir/.github/skills/$command_name/SKILL.md"
            if [ -f "$skill_file" ]; then
                echo -e "  ${GREEN}✓${NC} .github/skills/$command_name/SKILL.md"
                copilot_found=true
            fi
        fi
    done
    if [ "$copilot_found" = false ]; then
        echo "  (none)"
    fi

    echo ""
    echo "Vendor catalog (.principles-catalog/):"
    if [ -d "$project_dir/.principles-catalog" ]; then
        echo -e "  ${GREEN}✓${NC} .principles-catalog/"
    else
        echo "  (none)"
    fi
}

show_usage() {
    echo ""
    echo "Usage: $0 <target> <dir>"
    echo ""
    echo "Targets:"
    echo "  claude <dir>        Install slash commands in <dir>/.claude/commands/"
    echo "  copilot <dir>       Generate Copilot assets in <dir>/.github/"
    echo "  vendor <dir>        Copy catalog subset to <dir>/.principles-catalog/"
    echo "  all <dir>           Run claude + copilot + vendor in <dir>"
    echo ""
    echo "Management:"
    echo "  --list <dir>        Show what's installed in <dir>"
    echo "  --help              Show this help"
    echo "  ./uninstall.sh <dir> Remove local assets from <dir>"
    echo ""
    echo "Examples:"
    echo "  ./install.sh claude ~/projects/my-app"
    echo "  ./install.sh copilot ~/projects/my-app"
    echo "  ./install.sh vendor ~/projects/my-app"
    echo "  ./install.sh all ~/projects/my-app"
}

require_dir() {
    local dir="$1"
    if [ -z "$dir" ]; then
        echo -e "${RED}Error: A project directory is required.${NC}"
        echo "Usage: $0 <tool> <dir>"
        exit 1
    fi
}

# Main
print_header

DIR_ARG="$(normalize_directory_path "${2:-}")"

case "${1:-}" in
    claude)
        require_dir "$DIR_ARG"
        "$SCRIPT_DIR/uninstall.sh" --quiet --target claude "$DIR_ARG"
        install_claude "$DIR_ARG"
        ;;
    copilot)
        require_dir "$DIR_ARG"
        "$SCRIPT_DIR/uninstall.sh" --quiet --target copilot "$DIR_ARG"
        install_copilot_local "$DIR_ARG"
        ;;
    vendor)
        require_dir "$DIR_ARG"
        "$SCRIPT_DIR/uninstall.sh" --quiet --target vendor "$DIR_ARG"
        install_vendor "$DIR_ARG"
        ;;
    all)
        require_dir "$DIR_ARG"
        "$SCRIPT_DIR/uninstall.sh" --quiet "$DIR_ARG"
        install_claude "$DIR_ARG"
        echo ""
        install_copilot_local "$DIR_ARG"
        echo ""
        install_vendor "$DIR_ARG"
        ;;
    --list|-l)
        require_dir "$DIR_ARG"
        list_installed "$DIR_ARG"
        ;;
    --help|-h)
        show_usage
        ;;
    "")
        show_usage
        ;;
    *)
        echo -e "${RED}Unknown target: $1${NC}"
        show_usage
        exit 1
        ;;
esac

echo ""
echo "Done."
