#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Flemming N. Larsen — https://github.com/dot-principles/principles
set -euo pipefail

# install.sh — Deploy .principles to AI coding tools
#
# Usage:
#   ./install.sh <dir>              # Interactive: select which tools to install
#   ./install.sh claude <dir>       # Install Claude Code slash commands in <dir>/.claude/commands/
#   ./install.sh copilot <dir>      # Generate all Copilot assets in <dir>/.github/ (CLI + IDE)
#   ./install.sh copilot-cli <dir>  # Generate Copilot CLI skills in <dir>/.github/skills/
#   ./install.sh copilot-ide <dir>  # Generate Copilot IDE prompts in <dir>/.github/prompts/
#   ./install.sh codex <dir>        # Generate Codex skills in <dir>/.agents/skills/
#   ./install.sh vendor <dir>       # Copy catalog subset to <dir>/.principles-catalog/
#   ./install.sh all <dir>          # Run claude + copilot + codex + vendor in <dir>
#   ./install.sh --list <dir>       # Show what's installed in <dir>
#   ./uninstall.sh <dir>            # Remove local assets from <dir>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="$(cat "$SCRIPT_DIR/VERSION" | tr -d '[:space:]')"
COMMAND_SOURCE_DIR="$SCRIPT_DIR/commands"
TEMPLATE_DIR="$SCRIPT_DIR/templates"

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

# shellcheck source=lib/path-utils.sh
source "$SCRIPT_DIR/lib/path-utils.sh"
# shellcheck source=lib/config.sh
source "$SCRIPT_DIR/lib/config.sh"
# shellcheck source=lib/template.sh
source "$SCRIPT_DIR/lib/template.sh"
# shellcheck source=lib/vendor.sh
source "$SCRIPT_DIR/lib/vendor.sh"
# shellcheck source=lib/ui.sh
source "$SCRIPT_DIR/lib/ui.sh"

# Main
print_header

# Strip --extra-catalog <path> pairs from args before subcommand dispatch.
# Paths are expanded (~ → $HOME) and stored in EXTRA_CATALOGS_CLI.
_cleaned_args=()
_skip_next=false
for _arg in "$@"; do
    if [ "$_skip_next" = true ]; then
        EXTRA_CATALOGS_CLI+=("$(expand_path "$_arg")")
        _skip_next=false
    elif [ "$_arg" = "--extra-catalog" ]; then
        _skip_next=true
    else
        _cleaned_args+=("$_arg")
    fi
done
if [ "${#_cleaned_args[@]}" -gt 0 ]; then
    set -- "${_cleaned_args[@]}"
else
    set --
fi

# Detect whether arg 1 is a known target or a directory (for interactive mode).
# If arg 1 is a directory that exists (and not a known target), treat as interactive.
ARG1="${1:-}"
ARG2="${2:-}"

require_dir() {
    local dir="$1"
    if [ -z "$dir" ]; then
        echo -e "${RED}Error: A project directory is required.${NC}"
        echo "Usage: $0 <tool> <dir>"
        exit 1
    fi
}

is_known_target() {
    case "$1" in
        claude|copilot|copilot-cli|copilot-ide|codex|vendor|all|--list|-l|--help|-h) return 0 ;;
        *) return 1 ;;
    esac
}

if [ -n "$ARG1" ] && ! is_known_target "$ARG1" && [ -d "$(normalize_directory_path "$ARG1")" ]; then
    # Interactive mode: first arg is a directory
    DIR_ARG="$(normalize_directory_path "$ARG1")"
    interactive_install "$DIR_ARG"
else
    DIR_ARG="$(normalize_directory_path "$ARG2")"

    case "$ARG1" in
        claude)
            require_dir "$DIR_ARG"
            read_install_cfg "$DIR_ARG"
            "$SCRIPT_DIR/uninstall.sh" --quiet --target claude "$DIR_ARG"
            install_from_template "$TEMPLATE_DIR/claude" "$DIR_ARG"
            echo ""
            "$SCRIPT_DIR/uninstall.sh" --quiet --target vendor "$DIR_ARG"
            install_vendor "$DIR_ARG"
            mark_targets claude vendor
            write_install_cfg "$DIR_ARG"
            ;;
        copilot)
            require_dir "$DIR_ARG"
            read_install_cfg "$DIR_ARG"
            "$SCRIPT_DIR/uninstall.sh" --quiet --target copilot "$DIR_ARG"
            install_from_template "$TEMPLATE_DIR/copilot-cli" "$DIR_ARG"
            echo ""
            install_from_template "$TEMPLATE_DIR/copilot-ide" "$DIR_ARG"
            echo ""
            "$SCRIPT_DIR/uninstall.sh" --quiet --target vendor "$DIR_ARG"
            install_vendor "$DIR_ARG"
            mark_targets copilot-cli copilot-ide vendor
            write_install_cfg "$DIR_ARG"
            ;;
        copilot-cli)
            require_dir "$DIR_ARG"
            read_install_cfg "$DIR_ARG"
            "$SCRIPT_DIR/uninstall.sh" --quiet --target copilot "$DIR_ARG"
            install_from_template "$TEMPLATE_DIR/copilot-cli" "$DIR_ARG"
            echo ""
            "$SCRIPT_DIR/uninstall.sh" --quiet --target vendor "$DIR_ARG"
            install_vendor "$DIR_ARG"
            mark_targets copilot-cli vendor
            write_install_cfg "$DIR_ARG"
            ;;
        copilot-ide)
            require_dir "$DIR_ARG"
            read_install_cfg "$DIR_ARG"
            install_from_template "$TEMPLATE_DIR/copilot-ide" "$DIR_ARG"
            echo ""
            "$SCRIPT_DIR/uninstall.sh" --quiet --target vendor "$DIR_ARG"
            install_vendor "$DIR_ARG"
            mark_targets copilot-ide vendor
            write_install_cfg "$DIR_ARG"
            ;;
        codex)
            require_dir "$DIR_ARG"
            read_install_cfg "$DIR_ARG"
            "$SCRIPT_DIR/uninstall.sh" --quiet --target codex "$DIR_ARG"
            install_from_template "$TEMPLATE_DIR/codex" "$DIR_ARG"
            echo ""
            "$SCRIPT_DIR/uninstall.sh" --quiet --target vendor "$DIR_ARG"
            install_vendor "$DIR_ARG"
            mark_targets codex vendor
            write_install_cfg "$DIR_ARG"
            ;;
        vendor)
            require_dir "$DIR_ARG"
            read_install_cfg "$DIR_ARG"
            # Re-install any previously installed skill/command targets so they stay
            # in sync with the current dot-principles version.  This means a single
            # `./install.sh vendor <dir>` is sufficient to update both the catalog
            # and all installed AI skill files after a dot-principles update.
            if [ "${INSTALLED_TARGETS[claude]:-}" = "1" ]; then
                "$SCRIPT_DIR/uninstall.sh" --quiet --target claude "$DIR_ARG"
                install_from_template "$TEMPLATE_DIR/claude" "$DIR_ARG"
                echo ""
            fi
            if [ "${INSTALLED_TARGETS[copilot-cli]:-}" = "1" ] || [ "${INSTALLED_TARGETS[copilot-ide]:-}" = "1" ]; then
                "$SCRIPT_DIR/uninstall.sh" --quiet --target copilot "$DIR_ARG"
                if [ "${INSTALLED_TARGETS[copilot-cli]:-}" = "1" ]; then
                    install_from_template "$TEMPLATE_DIR/copilot-cli" "$DIR_ARG"
                    echo ""
                fi
                if [ "${INSTALLED_TARGETS[copilot-ide]:-}" = "1" ]; then
                    install_from_template "$TEMPLATE_DIR/copilot-ide" "$DIR_ARG"
                    echo ""
                fi
            fi
            if [ "${INSTALLED_TARGETS[codex]:-}" = "1" ]; then
                "$SCRIPT_DIR/uninstall.sh" --quiet --target codex "$DIR_ARG"
                install_from_template "$TEMPLATE_DIR/codex" "$DIR_ARG"
                echo ""
            fi
            "$SCRIPT_DIR/uninstall.sh" --quiet --target vendor "$DIR_ARG"
            install_vendor "$DIR_ARG"
            mark_targets vendor
            write_install_cfg "$DIR_ARG"
            ;;
        all)
            require_dir "$DIR_ARG"
            read_install_cfg "$DIR_ARG"
            "$SCRIPT_DIR/uninstall.sh" --quiet "$DIR_ARG"
            install_from_template "$TEMPLATE_DIR/claude" "$DIR_ARG"
            echo ""
            install_from_template "$TEMPLATE_DIR/copilot-cli" "$DIR_ARG"
            echo ""
            install_from_template "$TEMPLATE_DIR/copilot-ide" "$DIR_ARG"
            echo ""
            install_from_template "$TEMPLATE_DIR/codex" "$DIR_ARG"
            echo ""
            install_vendor "$DIR_ARG"
            mark_targets claude copilot-cli copilot-ide codex copilot-review claude-review vendor
            write_install_cfg "$DIR_ARG"
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
            echo -e "${RED}Unknown target: $ARG1${NC}"
            show_usage
            exit 1
            ;;
    esac
fi

echo ""
echo "Done."
