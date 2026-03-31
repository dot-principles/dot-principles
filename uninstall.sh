#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Flemming N. Larsen — https://github.com/dot-principles/principles
set -euo pipefail

# uninstall.sh — Remove .principles assets from supported AI coding tools
#
# Usage:
#   ./uninstall.sh <project>   # Remove local assets from <project>:
#                              #   Per-group files: .github/instructions/*.instructions.md (scout-generated)
#                              #                    .claude/rules/*.md (scout-generated)
#                              #   Legacy blocks:   .claude/rules/principles.md
#                              #                    .ai/principles.md (hub pattern)
#                              #                    AGENTS.md / CLAUDE.md (inline block)
#                              #   Claude Code: <project>/.claude/commands/<name>.md
#                              #   Copilot CLI: .github/skills/<name>/SKILL.md
#                              #   Copilot IDE: .github/prompts/<name>.prompt.md
#                              #                .github/copilot-instructions.md (.principles block only)
#                              #   Codex:       .agents/skills/<name>/SKILL.md
#                              #   Vendor:      .principles-catalog/
#   ./uninstall.sh --help      # Show this help

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
QUIET=false
TARGET=""
_args=()
_skip_next=false
for _arg in "$@"; do
    if [ "$_skip_next" = true ]; then
        TARGET="$_arg"
        _skip_next=false
        continue
    fi
    case "$_arg" in
        --quiet|-q) QUIET=true ;;
        --target) _skip_next=true ;;
        *) _args+=("$_arg") ;;
    esac
done
set -- "${_args[@]+"${_args[@]}"}"

# Output helper — suppressed in --quiet mode (errors always print via stderr)
qecho() { [ "$QUIET" = false ] && echo -e "$@" || true; }

COMMAND_SOURCE_DIR="$SCRIPT_DIR/commands"

PROJECT_DIR=""
if [ -n "${1:-}" ] && [[ "${1:-}" != --* ]]; then
    PROJECT_DIR="$(normalize_directory_path "$1")"
fi

# Colors (if terminal supports them)
if [ -t 1 ]; then
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    BOLD='\033[1m'
    DIM='\033[0;90m'
    NC='\033[0m'
else
    GREEN='' YELLOW='' RED='' BOLD='' DIM='' NC=''
fi

NEUTRAL="${DIM}-${NC}"

cleanup_dir_if_empty() {
    local dir="$1"

    if [ -d "$dir" ] && [ -z "$(find "$dir" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]; then
        rmdir "$dir"
    fi
}

print_header() {
    qecho ""
    qecho "${BOLD}.principles uninstaller${NC}"
    qecho "───────────────────────────"
}

show_usage() {
    print_header
    echo ""
    echo -e "Usage: $0 ${BOLD}<dir>${NC}"
    echo ""
    echo "Removes .principles assets for Claude Code, GitHub Copilot, Codex, and vendor catalog."
    echo ""
    echo -e "  ${BOLD}<dir>${NC}               Remove local assets from <dir>:"
    echo -e "                        ${DIM}Per-group files:${NC} .github/instructions/*.instructions.md (scout-generated)"
    echo -e "                                         .claude/rules/*.md (scout-generated)"
    echo -e "                        ${DIM}Legacy blocks:${NC}   .claude/rules/principles.md, .ai/principles.md,"
    echo "                                         AGENTS.md, CLAUDE.md (stripped inline)"
    echo -e "                        ${DIM}Claude Code:${NC}     .claude/commands/<name>.md"
    echo -e "                        ${DIM}Copilot CLI:${NC}     .github/skills/<name>/SKILL.md"
    echo -e "                        ${DIM}Copilot IDE:${NC}     .github/prompts/<name>.prompt.md"
    echo "                                         .github/copilot-instructions.md (.principles block only)"
    echo -e "                        ${DIM}Codex:${NC}           .agents/skills/<name>/SKILL.md"
    echo -e "                        ${DIM}Vendor:${NC}          .principles-catalog/"
    echo ""
    echo "Options:"
    echo -e "  ${BOLD}--help${NC}              Show this help"
    echo -e "  ${BOLD}--target <name>${NC}     Only remove assets for one target"
    echo "                      (compiled | claude | copilot | codex | vendor)"
}

uninstall_claude() {
    local project_dir="$1"
    local target_dir="$project_dir/.claude/commands"

    qecho "${BOLD}Removing Claude Code slash commands (local: $project_dir)...${NC}"

    local count=0
    local found_target=false
    local file

    for file in "$COMMAND_SOURCE_DIR/"*.md; do
        if [ -f "$file" ]; then
            found_target=true
            local installed_file="$target_dir/$(basename "$file")"
            if [ -f "$installed_file" ]; then
                rm "$installed_file"
                count=$((count + 1))
                qecho "  ${GREEN}✓${NC} /$(basename "$file" .md)"
            fi
        fi
    done

    if [ "$found_target" = false ]; then
        echo -e "${RED}Error: No shared command source files found in $COMMAND_SOURCE_DIR.${NC}" >&2
        exit 1
    fi

    if [ $count -eq 0 ]; then
        qecho "  ${NEUTRAL} No current commands found to remove."
    else
        qecho ""
        qecho "Removed ${GREEN}$count${NC} commands."
    fi

    cleanup_dir_if_empty "$target_dir"
    cleanup_dir_if_empty "$project_dir/.claude"
}

uninstall_copilot() {
    local project_dir="$1"
    uninstall_copilot_local "$project_dir"
}

uninstall_copilot_local() {
    local project_dir="$1"
    local target_file="$project_dir/.github/copilot-instructions.md"
    local prompts_dir="$project_dir/.github/prompts"
    local skills_dir="$project_dir/.github/skills"

    qecho "${BOLD}Removing GitHub Copilot instructions...${NC}"

    if [ ! -f "$target_file" ]; then
        qecho "  ${NEUTRAL} No Copilot instructions found to remove."
    else
        local temp_file
        temp_file="$(mktemp)"

        awk '
            BEGIN { in_block=0; removed=0 }
            /^<!-- .principles: begin -->$/ { in_block=1; removed=1; next }
            /^<!-- .principles: end -->$/   { if (in_block) { in_block=0; next } }
            !in_block { print }
            END { exit removed ? 0 : 1 }
        ' "$target_file" > "$temp_file" || {
            rm -f "$temp_file"
            qecho "  ${NEUTRAL} No .principles Copilot instructions found to remove."
            temp_file=""
        }

        if [ -n "${temp_file:-}" ]; then
            # Trim trailing blank lines left after block removal
            awk '{lines[NR]=$0; if(/[^[:space:]]/) last=NR} END{for(i=1;i<=last;i++) print lines[i]}' \
                "$temp_file" > "${temp_file}.t" && mv "${temp_file}.t" "$temp_file"

            if grep -q '[^[:space:]]' "$temp_file"; then
                mv "$temp_file" "$target_file"
                qecho "  ${GREEN}✓${NC} .github/copilot-instructions.md (removed .principles block)"
            else
                rm -f "$temp_file" "$target_file"
                qecho "  ${GREEN}✓${NC} .github/copilot-instructions.md"
            fi
        fi
    fi

    qecho ""
    qecho "${BOLD}Removing GitHub Copilot skills...${NC}"

    local skill_count=0
    local file
    for file in "$COMMAND_SOURCE_DIR/"*.md; do
        if [ -f "$file" ]; then
            local command_name
            command_name="$(basename "$file" .md)"
            local skill_dir="$skills_dir/$command_name"
            if [ -d "$skill_dir" ]; then
                rm -rf "$skill_dir"
                skill_count=$((skill_count + 1))
                qecho "  ${GREEN}✓${NC} .github/skills/$command_name/"
            fi
        fi
    done

    if [ $skill_count -eq 0 ]; then
        qecho "  ${NEUTRAL} No Copilot skills found to remove."
    fi

    qecho ""
    qecho "${BOLD}Removing GitHub Copilot prompt commands...${NC}"

    local prompt_count=0
    for file in "$COMMAND_SOURCE_DIR/"*.md; do
        if [ -f "$file" ]; then
            local prompt_file="$prompts_dir/$(basename "$file" .md).prompt.md"
            if [ -f "$prompt_file" ]; then
                rm "$prompt_file"
                prompt_count=$((prompt_count + 1))
                qecho "  ${GREEN}✓${NC} .github/prompts/$(basename "$prompt_file")"
            fi
        fi
    done

    if [ $prompt_count -eq 0 ]; then
        qecho "  ${NEUTRAL} No Copilot prompt commands found to remove."
    fi

    cleanup_dir_if_empty "$skills_dir"
    cleanup_dir_if_empty "$prompts_dir"
    cleanup_dir_if_empty "$project_dir/.github"
}

uninstall_codex() {
    local project_dir="$1"
    local skills_dir="$project_dir/.agents/skills"

    qecho "${BOLD}Removing Codex skills...${NC}"

    local skill_count=0
    local file
    for file in "$COMMAND_SOURCE_DIR/"*.md; do
        if [ -f "$file" ]; then
            local command_name
            command_name="$(basename "$file" .md)"
            local skill_dir="$skills_dir/$command_name"
            if [ -d "$skill_dir" ]; then
                rm -rf "$skill_dir"
                skill_count=$((skill_count + 1))
                qecho "  ${GREEN}✓${NC} .agents/skills/$command_name/"
            fi
        fi
    done

    if [ $skill_count -eq 0 ]; then
        qecho "  ${NEUTRAL} No Codex skills found to remove."
    fi

    cleanup_dir_if_empty "$skills_dir"
    cleanup_dir_if_empty "$project_dir/.agents"
}

uninstall_compiled_blocks() {
    local project_dir="$1"

    qecho "${BOLD}Removing per-group principle files and legacy compiled blocks...${NC}"

    local found=false

    # Per-group files in .github/instructions/ — remove scout-generated files only
    local instructions_dir="$project_dir/.github/instructions"
    if [ -d "$instructions_dir" ]; then
        local file
        for file in "$instructions_dir"/*.instructions.md; do
            [ -f "$file" ] || continue
            if grep -q "<!-- generated by /scout" "$file" 2>/dev/null; then
                rm "$file"
                found=true
                qecho "  ${GREEN}✓${NC} .github/instructions/$(basename "$file")"
            fi
        done
        cleanup_dir_if_empty "$instructions_dir"
    fi

    # Per-group files in .claude/rules/ — remove scout-generated files only
    local rules_dir="$project_dir/.claude/rules"
    if [ -d "$rules_dir" ]; then
        local file
        for file in "$rules_dir"/*.md; do
            [ -f "$file" ] || continue
            if grep -q "<!-- generated by /scout" "$file" 2>/dev/null; then
                rm "$file"
                found=true
                qecho "  ${GREEN}✓${NC} .claude/rules/$(basename "$file")"
            fi
        done
        cleanup_dir_if_empty "$rules_dir"
        cleanup_dir_if_empty "$project_dir/.claude"
    fi

    # Legacy: .claude/rules/principles.md — remove file entirely if it was created by scout
    local claude_rules="$project_dir/.claude/rules/principles.md"
    if [ -f "$claude_rules" ]; then
        rm "$claude_rules"
        found=true
        qecho "  ${GREEN}✓${NC} .claude/rules/principles.md (legacy)"
        cleanup_dir_if_empty "$project_dir/.claude/rules"
        cleanup_dir_if_empty "$project_dir/.claude"
    fi

    # Legacy: .ai/principles.md — remove file, remove row from AGENTS.md table
    local ai_principles="$project_dir/.ai/principles.md"
    if [ -f "$ai_principles" ]; then
        rm "$ai_principles"
        found=true
        qecho "  ${GREEN}✓${NC} .ai/principles.md (legacy)"
        cleanup_dir_if_empty "$project_dir/.ai"

        # Remove the reference row from AGENTS.md if present
        local agents_file="$project_dir/AGENTS.md"
        if [ -f "$agents_file" ] && grep -q "\.ai/principles\.md" "$agents_file"; then
            local tmp
            tmp="$(mktemp)"
            grep -v "\.ai/principles\.md" "$agents_file" > "$tmp"
            mv "$tmp" "$agents_file"
            qecho "  ${GREEN}✓${NC} AGENTS.md (removed .ai/principles.md reference)"
        fi
    fi

    # Legacy: AGENTS.md — strip compiled block if injected directly
    local agents_file="$project_dir/AGENTS.md"
    if [ -f "$agents_file" ] && grep -q "^<!-- .principles: begin" "$agents_file"; then
        local tmp result_file
        tmp="$(mktemp)"
        awk '
            BEGIN { in_block=0; removed=0 }
            /^<!-- \.principles: begin/ { in_block=1; removed=1; next }
            /^<!-- \.principles: end -->$/ { if (in_block) { in_block=0; next } }
            !in_block { print }
            END { exit removed ? 0 : 1 }
        ' "$agents_file" > "$tmp" && {
            result_file="$(mktemp)"
            awk '{lines[NR]=$0; if(/[^[:space:]]/) last=NR} END{for(i=1;i<=last;i++) print lines[i]}' \
                "$tmp" > "$result_file"
            if grep -q '[^[:space:]]' "$result_file"; then
                mv "$result_file" "$agents_file"
            else
                rm -f "$result_file" "$agents_file"
            fi
            rm -f "$tmp"
            found=true
            qecho "  ${GREEN}✓${NC} AGENTS.md (removed .principles block, legacy)"
        } || rm -f "$tmp"
    fi

    # Legacy: CLAUDE.md — strip compiled block if injected directly
    local claude_file="$project_dir/CLAUDE.md"
    if [ -f "$claude_file" ] && grep -q "^<!-- .principles: begin" "$claude_file"; then
        local tmp result_file
        tmp="$(mktemp)"
        awk '
            BEGIN { in_block=0; removed=0 }
            /^<!-- \.principles: begin/ { in_block=1; removed=1; next }
            /^<!-- \.principles: end -->$/ { if (in_block) { in_block=0; next } }
            !in_block { print }
            END { exit removed ? 0 : 1 }
        ' "$claude_file" > "$tmp" && {
            result_file="$(mktemp)"
            awk '{lines[NR]=$0; if(/[^[:space:]]/) last=NR} END{for(i=1;i<=last;i++) print lines[i]}' \
                "$tmp" > "$result_file"
            if grep -q '[^[:space:]]' "$result_file"; then
                mv "$result_file" "$claude_file"
            else
                rm -f "$result_file" "$claude_file"
            fi
            rm -f "$tmp"
            found=true
            qecho "  ${GREEN}✓${NC} CLAUDE.md (removed .principles block, legacy)"
        } || rm -f "$tmp"
    fi

    if [ "$found" = false ]; then
        qecho "  ${NEUTRAL} No per-group files or compiled blocks found to remove."
    fi
}

uninstall_vendor() {
    local project_dir="$1"

    qecho "${BOLD}Removing vendor catalog...${NC}"

    if [ -d "$project_dir/.principles-catalog" ]; then
        rm -rf "$project_dir/.principles-catalog"
        qecho "  ${GREEN}✓${NC} Removed .principles-catalog/"
    else
        qecho "  ${NEUTRAL} No .principles-catalog found to remove."
    fi
}

require_project_dir() {
    if [ -z "$PROJECT_DIR" ]; then
        echo -e "${RED}Error: A project directory is required.${NC}"
        echo "Usage: $0 <dir>"
        exit 1
    fi
    if [ ! -d "$PROJECT_DIR" ]; then
        echo -e "${RED}Error: Directory '$PROJECT_DIR' does not exist.${NC}"
        exit 1
    fi
}

run_uninstall() {
    require_project_dir

    print_header
    qecho ""

    if [ -z "$TARGET" ] || [ "$TARGET" = "compiled" ]; then
        uninstall_compiled_blocks "$PROJECT_DIR"
        qecho ""
    fi
    if [ -z "$TARGET" ] || [ "$TARGET" = "claude" ]; then
        uninstall_claude "$PROJECT_DIR"
        qecho ""
    fi
    if [ -z "$TARGET" ] || [ "$TARGET" = "copilot" ]; then
        uninstall_copilot "$PROJECT_DIR"
        qecho ""
    fi
    if [ -z "$TARGET" ] || [ "$TARGET" = "codex" ]; then
        uninstall_codex "$PROJECT_DIR"
        qecho ""
    fi
    if [ -z "$TARGET" ] || [ "$TARGET" = "vendor" ]; then
        uninstall_vendor "$PROJECT_DIR"
        qecho ""
    fi

    # Remove legacy ~/.principles if it exists
    if [ -d "$HOME/.principles" ]; then
        rm -rf "$HOME/.principles"
        qecho "  ${GREEN}✓${NC} Removed legacy ~/.principles (no longer used)"
        qecho ""
    fi

    qecho "Done."
}

case "${1:-}" in
    --help|-h)
        show_usage
        ;;
    "")
        echo -e "${RED}Error: A project directory is required.${NC}"
        echo "Usage: $0 <dir>"
        exit 1
        ;;
    *)
        if [[ "$1" == -* ]]; then
            echo -e "${RED}Unknown option: $1${NC}"
            show_usage
            exit 1
        fi

        run_uninstall
        ;;
esac
