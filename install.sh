#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Flemming N. Larsen — https://github.com/dot-principles/principles
set -euo pipefail

# install.sh — Deploy .principles to AI coding tools
#
# Usage:
#   ./install.sh claude <dir>      # Install Claude Code slash commands in <dir>/.claude/commands/
#   ./install.sh copilot <dir>     # Generate Copilot assets in <dir>/.github/
#                                  #   .github/instructions/             (per-group files directory)
#                                  #   .github/skills/<name>/SKILL.md   (Copilot CLI slash commands)
#                                  #   .github/prompts/<name>.prompt.md (VS Code / JetBrains / Visual Studio)
#   ./install.sh codex <dir>       # Generate Codex skills in <dir>/.agents/skills/
#   ./install.sh vendor <dir>      # Copy catalog subset to <dir>/.principles-catalog/
#   ./install.sh all <dir>         # Run claude + copilot + codex + vendor in <dir>
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

COMMAND_SOURCE_DIR="$SCRIPT_DIR/commands"

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

codex_skill_description() {
    case "$1" in
        scout)
            echo "Analyse the project, detect language/framework/domain, and create or update .principles files. Use when asked to scout or set up principles in Codex."
            ;;
        prime)
            echo "Resolve the .principles hierarchy, load full principle guidance, and prepare a coding frame. Use when asked to prime or activate principles in Codex."
            ;;
        audit)
            echo "Resolve the .principles hierarchy, load principle content, review code, and group findings by severity (Critical/High/Medium/Low). Use when asked to audit or review code against principles in Codex."
            ;;
        *)
            echo "Run the $1 .principles workflow in Codex."
            ;;
    esac
}

strip_leading_frontmatter() {
    local source_file="$1"

    awk '
        BEGIN { in_frontmatter = 0; saw_frontmatter = 0 }
        NR == 1 && $0 == "---" { in_frontmatter = 1; saw_frontmatter = 1; next }
        in_frontmatter && $0 == "---" { in_frontmatter = 0; next }
        !in_frontmatter { print }
    ' "$source_file"
}

write_codex_skill() {
    local source_file="$1"
    local skill_dir="$2"
    local command_name="$3"

    mkdir -p "$skill_dir"
    local skill_file="$skill_dir/SKILL.md"

    cat > "$skill_file" <<EOF
---
name: $command_name
description: $(codex_skill_description "$command_name")
license: MIT
---

Codex note:
- Treat \`\$ARGUMENTS\` below as the user's request text after invoking this skill.
- References to \`/scout\`, \`/prime\`, and \`/audit\` map to \`\$scout\`, \`\$prime\`, and \`\$audit\` in Codex.

EOF

    cat "$source_file" >> "$skill_file"
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

install_codex_local() {
    local project_dir="$1"

    if [ ! -d "$project_dir" ]; then
        echo -e "${RED}Error: Directory '$project_dir' does not exist.${NC}"
        exit 1
    fi

    echo -e "${BOLD}Installing Codex skills (local: $project_dir)...${NC}"

    local skills_dir="$project_dir/.agents/skills"
    mkdir -p "$skills_dir"

    local skill_count=0
    local file

    for file in "$COMMAND_SOURCE_DIR/"*.md; do
        if [ -f "$file" ]; then
            local command_name
            local stripped_file
            command_name="$(basename "$file" .md)"
            stripped_file="$(mktemp)"
            strip_leading_frontmatter "$file" | sed \
                -e "s|{{PRINCIPLES_DIRECTORY}}|.principles-catalog|g" \
                -e "s|{{VERSION}}|$VERSION|g" \
                > "$stripped_file"
            write_codex_skill "$stripped_file" "$skills_dir/$command_name" "$command_name"
            rm -f "$stripped_file"
            skill_count=$((skill_count + 1))
            echo -e "  ${GREEN}✓${NC} \$$command_name"
        fi
    done

    echo ""
    echo "Codex assets written:"
    echo "  - .agents/skills/<name>/SKILL.md  (${skill_count} skills — Codex CLI + IDE extension)"
    echo ""
    echo "In Codex: mention \$scout, \$prime, or \$audit (CLI or IDE extension)"
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
    for file in "$COMMAND_SOURCE_DIR/"*.md; do
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
    local prompts_dir="$target_dir/prompts"
    local instructions_dir="$target_dir/instructions"

    mkdir -p "$target_dir"
    mkdir -p "$prompts_dir"
    mkdir -p "$instructions_dir"

    echo -e "${BOLD}Installing Copilot skills and prompt commands...${NC}"

    local prompt_count=0
    local file
    local skills_dir="$target_dir/skills"

    for file in "$COMMAND_SOURCE_DIR/"*.md; do
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

    echo -e "  ${GREEN}✓${NC} $instructions_dir/"
    echo ""
    echo "Copilot assets written:"
    echo "  - .github/instructions/             (per-group files written by /scout)"
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

    for dir in "$principles_src"/*/ "$principles_src"/*/*/; do
        [ -d "$dir" ] || continue
        local rel
        rel="${dir#$principles_src/}"
        rel="${rel%/}"
        local dst="$principles_dst/$rel"
        local copied=false
        for context_file in ".context-audit.md" ".context-prime.md" ".context-inspect.md" "catalog.yaml"; do
            if [ -f "$dir/$context_file" ]; then
                mkdir -p "$dst"
                cp "$dir/$context_file" "$dst/"
                copied=true
            fi
        done
        if [ "$copied" = true ]; then
            echo -e "  ${GREEN}✓${NC} principles/$rel/"
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
    for file in "$COMMAND_SOURCE_DIR/"*.md; do
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
    for file in "$COMMAND_SOURCE_DIR/"*.md; do
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
    echo "Codex skills (.agents/skills/):"
    local codex_found=false
    for file in "$COMMAND_SOURCE_DIR/"*.md; do
        if [ -f "$file" ]; then
            local command_name
            command_name="$(basename "$file" .md)"
            local skill_file="$project_dir/.agents/skills/$command_name/SKILL.md"
            if [ -f "$skill_file" ]; then
                echo -e "  ${GREEN}✓${NC} .agents/skills/$command_name/SKILL.md"
                codex_found=true
            fi
        fi
    done
    if [ "$codex_found" = false ]; then
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
    echo "  codex <dir>         Generate Codex skills in <dir>/.agents/skills/"
    echo "  vendor <dir>        Copy catalog subset to <dir>/.principles-catalog/"
    echo "  all <dir>           Run claude + copilot + codex + vendor in <dir>"
    echo ""
    echo "Management:"
    echo "  --list <dir>        Show what's installed in <dir>"
    echo "  --help              Show this help"
    echo "  ./uninstall.sh <dir> Remove local assets from <dir>"
    echo ""
    echo "Examples:"
    echo "  ./install.sh claude ~/projects/my-app"
    echo "  ./install.sh copilot ~/projects/my-app"
    echo "  ./install.sh codex ~/projects/my-app"
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
    codex)
        require_dir "$DIR_ARG"
        "$SCRIPT_DIR/uninstall.sh" --quiet --target codex "$DIR_ARG"
        install_codex_local "$DIR_ARG"
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
        install_codex_local "$DIR_ARG"
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
