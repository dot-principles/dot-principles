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

# Convert a Windows-style path (C:\... or C:/...) to a path the current bash understands.
# Under WSL, uses wslpath. Under Git Bash / native Linux/macOS, returns the path unchanged.
normalize_path() {
    local p="$1"
    if [[ -n "$p" && "$p" =~ ^[A-Za-z]:[/\\] ]]; then
        if command -v wslpath &>/dev/null; then
            wslpath -u "$p"
            return
        fi
        # Git Bash / MSYS2: convert backslashes to forward slashes
        p="${p//\\//}"
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

# Expand a path from a config file: strip CRLF + whitespace, expand leading ~,
# and normalize Windows-style backslash paths (Git Bash / WSL).
expand_path() {
    local p="${1%$'\r'}"
    p="${p#"${p%%[![:space:]]*}"}"
    p="${p%"${p##*[![:space:]]}"}"
    case "$p" in
        '~')   p="$HOME" ;;
        '~'/*) p="$HOME/${p:2}" ;;
    esac
    p="$(normalize_path "$p")"
    printf '%s' "$p"
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
    DIM='\033[0;90m'
    NC='\033[0m'
else
    GREEN='' YELLOW='' RED='' BOLD='' DIM='' NC=''
fi

print_header() {
    echo ""
    echo -e "${BOLD}.principles installer${NC}"
    echo "─────────────────────────"
}

TEMPLATE_DIR="$SCRIPT_DIR/templates"

# ---------------------------------------------------------------------------
# Template-driven installer
# ---------------------------------------------------------------------------
# Each AI tool is defined by two files in templates/<tool>/:
#   manifest.cfg  — key=value config (OUTPUT_DIR, OUTPUT_FILE, PATCHES, etc.)
#   wrapper.md    — output skeleton with {{COMMAND_NAME}}, {{FRONTMATTER}}, {{COMMAND_BODY}}
#
# The source of truth is commands/*.md with YAML frontmatter containing:
#   description, argument-hint, allowed-tools, version, authors
# ---------------------------------------------------------------------------

# Extract the YAML frontmatter body (lines between the --- delimiters, exclusive).
extract_frontmatter_body() {
    local source_file="$1"
    awk '
        BEGIN { in_fm = 0; saw_fm = 0 }
        NR == 1 && $0 == "---" { in_fm = 1; saw_fm = 1; next }
        in_fm && $0 == "---" { in_fm = 0; next }
        in_fm { print }
    ' "$source_file"
}

# Extract everything after the closing --- of the leading frontmatter.
extract_command_body() {
    local source_file="$1"
    awk '
        BEGIN { in_fm = 0; saw_fm = 0; done_fm = 0 }
        NR == 1 && $0 == "---" { in_fm = 1; saw_fm = 1; next }
        in_fm && $0 == "---" { in_fm = 0; done_fm = 1; next }
        done_fm { print }
    ' "$source_file"
}

# Install commands for one tool using its template directory.
# Usage: install_from_template <template_dir> <project_dir>
install_from_template() {
    local template_dir="$1"
    local project_dir="$2"

    if [ ! -d "$project_dir" ]; then
        echo -e "${RED}Error: Directory '$project_dir' does not exist.${NC}"
        exit 1
    fi

    # Source the manifest (sets TOOL_ID, TOOL_LABEL, OUTPUT_DIR, OUTPUT_FILE, PATCHES)
    local TOOL_ID="" TOOL_LABEL="" OUTPUT_DIR="" OUTPUT_FILE="" PATCHES="" INSTALL_SUBCOMMAND=""
    # shellcheck disable=SC1090
    source "$template_dir/manifest.cfg"
    # Strip trailing CR in case manifest has Windows line endings (CRLF)
    TOOL_ID="${TOOL_ID%$'\r'}"

    local wrapper_file="$template_dir/wrapper.md"
    if [ ! -f "$wrapper_file" ]; then
        echo -e "${RED}Error: Missing wrapper.md in $template_dir${NC}"
        exit 1
    fi

    echo -e "${BOLD}Installing $TOOL_LABEL commands (local: $project_dir)...${NC}"

    local count=0
    local file

    while IFS= read -r file; do
        [ -f "$file" ] || continue
        local command_name command_slug
        command_name="${file#$COMMAND_SOURCE_DIR/}"
        command_name="${command_name%.md}"
        command_slug="${command_name//\//-}"

        # Temp files for intermediate content
        local tmp_fm tmp_body tmp_output
        tmp_fm="$(mktemp)"
        tmp_body="$(mktemp)"
        tmp_output="$(mktemp)"

        # 1. Extract frontmatter and command body from source into temp files
        extract_frontmatter_body "$file" > "$tmp_fm"
        extract_command_body "$file" > "$tmp_body"

        # 2. Apply standard substitutions to frontmatter
        sed -i -e "s|{{VERSION}}|$VERSION|g" "$tmp_fm"

        # 3. Apply standard substitutions to command body
        sed -i \
            -e "s|{{PRINCIPLES_DIRECTORY}}|.principles-catalog|g" \
            -e "s|{{VERSION}}|$VERSION|g" \
            "$tmp_body"

        # 4. Apply tool-specific patches (if any)
        if [ -n "$PATCHES" ]; then
            sed -i -e "$PATCHES" "$tmp_body"
        fi

        # 5. Expand wrapper template: replace placeholders with file contents
        #    Process line by line: {{COMMAND_NAME}} is inline, {{FRONTMATTER}}
        #    and {{COMMAND_BODY}} replace the entire line with file contents.
        while IFS= read -r line || [ -n "$line" ]; do
            local expanded
            expanded="${line//\{\{COMMAND_NAME\}\}/$command_name}"
            expanded="${expanded//\{\{COMMAND_SLUG\}\}/$command_slug}"
            if [[ "$expanded" == *'{{FRONTMATTER}}'* ]]; then
                # Output prefix before {{FRONTMATTER}}, then file, then suffix
                local prefix="${expanded%%\{\{FRONTMATTER\}\}*}"
                local suffix="${expanded#*\{\{FRONTMATTER\}\}}"
                [ -n "$prefix" ] && printf '%s' "$prefix"
                cat "$tmp_fm"
                [ -n "$suffix" ] && printf '%s\n' "$suffix"
            elif [[ "$expanded" == *'{{COMMAND_BODY}}'* ]]; then
                local prefix="${expanded%%\{\{COMMAND_BODY\}\}*}"
                local suffix="${expanded#*\{\{COMMAND_BODY\}\}}"
                [ -n "$prefix" ] && printf '%s' "$prefix"
                cat "$tmp_body"
                [ -n "$suffix" ] && printf '%s' "$suffix"
            else
                printf '%s\n' "$expanded"
            fi
        done < "$wrapper_file" > "$tmp_output"

        # 6. Resolve output path and write
        local resolved_dir resolved_file
        resolved_dir="$(echo "$OUTPUT_DIR" | sed "s|{{COMMAND_NAME}}|$command_name|g; s|{{COMMAND_SLUG}}|$command_slug|g")"
        resolved_file="$(echo "$OUTPUT_FILE" | sed "s|{{COMMAND_NAME}}|$command_name|g; s|{{COMMAND_SLUG}}|$command_slug|g")"

        local target_path="$project_dir/$resolved_dir"
        mkdir -p "$(dirname "$target_path/$resolved_file")"
        cp "$tmp_output" "$target_path/$resolved_file"

        rm -f "$tmp_fm" "$tmp_body" "$tmp_output"

        count=$((count + 1))
        local display_name
        if [ "$TOOL_ID" = "claude" ]; then
            display_name="${command_name//\//:}"
        else
            display_name="$command_slug"
        fi
        echo -e "  ${GREEN}✓${NC} $display_name"
    done < <(find "$COMMAND_SOURCE_DIR" -name "*.md" -type f | sort)

    echo ""
    echo -e "Installed ${BOLD}$count${NC} commands to $resolved_dir"
}

# ---------------------------------------------------------------------------
# install.cfg — records which targets are installed
# ---------------------------------------------------------------------------
# Written to .principles-catalog/install.cfg so /dot-scout Phase 6 knows which
# review outputs to emit. Each line is a target ID (e.g. claude, copilot-cli).

# Read existing install.cfg into an associative array.  Returns target IDs in
# the INSTALLED_TARGETS associative array (keys = target IDs, values = "1").
declare -A INSTALLED_TARGETS
# CLI-supplied extra catalog directories (populated by arg parsing before dispatch).
EXTRA_CATALOGS_CLI=()
# Namespace and group registries used during vendor to detect conflicts.
declare -A REGISTERED_NAMESPACES
declare -A REGISTERED_GROUPS
read_install_cfg() {
    local cfg_file="$1/.principles-catalog/install.cfg"
    INSTALLED_TARGETS=()
    if [ -f "$cfg_file" ]; then
        while IFS= read -r line || [ -n "$line" ]; do
            # Skip comments and blank lines
            [[ "$line" =~ ^[[:space:]]*# ]] && continue
            [[ -z "${line// /}" ]] && continue
            INSTALLED_TARGETS["$line"]="1"
        done < "$cfg_file"
    fi
}

# Write install.cfg from the INSTALLED_TARGETS associative array.
write_install_cfg() {
    local project_dir="$1"
    local cfg_dir="$project_dir/.principles-catalog"
    mkdir -p "$cfg_dir"
    local cfg_file="$cfg_dir/install.cfg"
    {
        echo "# .principles install.cfg — installed targets"
        echo "# Auto-generated by install.sh — do not edit manually."
        echo "# Skills read this file to know which targets are installed."
        for target in "${!INSTALLED_TARGETS[@]}"; do
            echo "$target"
        done
    } | sort > "$cfg_file"
}

# Mark targets as installed.  Call before write_install_cfg.
mark_targets() {
    for t in "$@"; do
        INSTALLED_TARGETS["$t"]="1"
    done
}

# Remove targets.  Call before write_install_cfg.
unmark_targets() {
    for t in "$@"; do
        unset "INSTALLED_TARGETS[$t]"
    done
}

generate_compact_index() {
    local catalog_dir="$1"
    shift
    local index_file="$catalog_dir/index.tsv"
    local tmp="$index_file.tmp"

    {
        find "$SCRIPT_DIR/principles" -name "*.md" \
            ! -name ".context-*.md" \
            ! -name "TEMPLATE.md" \
            ! -name "AUDIT-SCOPE.md" \
            ! -name "catalog.yaml" | sort
        for extra in "$@"; do
            [ -d "$extra/principles" ] || continue
            find "$extra/principles" -name "*.md" \
                ! -name ".context-*.md" \
                ! -name "AUDIT-SCOPE.md" \
                ! -name "catalog.yaml" | sort
        done
    } | while IFS= read -r f; do

        local id layer summary
        id="$(head -1 "$f" | sed 's/^# \([A-Z0-9][A-Z0-9_-]*\) .*/\1/')"
        layer="$(grep -m1 '^\*\*Layer:\*\*' "$f" | sed 's/\*\*Layer:\*\* \([0-9]\).*/\1/')"
        summary="$(grep -m1 '^\*\*Summary:\*\*' "$f" | sed 's/^\*\*Summary:\*\* //')"

        if [ -n "$id" ] && [ -n "$layer" ] && [ -n "$summary" ]; then
            printf '%s|%s|%s\n' "$id" "$layer" "$summary"
        fi
    done | sort -u > "$tmp"

    mv "$tmp" "$index_file"
    echo -e "  ${GREEN}✓${NC} index.tsv ($(wc -l < "$index_file") principles)"
}

# Copy context files from one namespace directory into the catalog.
# Returns 0 on success, 1 if namespace is invalid (missing catalog.yaml).
vendor_namespace_context_files() {
    local ns_dir="$1"
    local principles_dst="$2"
    local rel="$3"

    if [ ! -f "$ns_dir/catalog.yaml" ]; then
        echo -e "  ${YELLOW}⚠${NC} Extra catalog: namespace '$rel' has no catalog.yaml (skipping)"
        return 1
    fi

    local dst="$principles_dst/$rel"
    mkdir -p "$dst"
    for context_file in ".context-audit.md" ".context-prime.md" ".context-inspect.md" ".context-scout.md" "catalog.yaml"; do
        [ -f "$ns_dir/$context_file" ] && cp "$ns_dir/$context_file" "$dst/"
    done

    if [ ! -f "$ns_dir/.context-prime.md" ]; then
        echo -e "    ${YELLOW}⚠${NC} principles/$rel/ has no .context-prime.md — /dot-prime will have limited guidance for these principles"
    fi
    return 0
}

# Merge one extra catalog directory into the vendored catalog.
vendor_extra_catalog() {
    local extra_dir="$1"
    local catalog_dir="$2"
    local label="${extra_dir/#$HOME/\~}"

    if [ ! -d "$extra_dir" ]; then
        echo -e "  ${YELLOW}⚠${NC} Extra catalog not found: $label (skipping)"
        return
    fi

    echo -e "  ${BOLD}Extra:${NC} $label"
    local principles_dst="$catalog_dir/principles"
    local ns_count=0
    local group_count=0

    # Merge principles namespaces (1-level and 2-level deep, matching built-in behavior)
    if [ -d "$extra_dir/principles" ]; then
        local principles_src="$extra_dir/principles"
        for ns_dir in "$principles_src"/*/ "$principles_src"/*/*/; do
            [ -d "$ns_dir" ] || continue
            local rel
            rel="${ns_dir#$principles_src/}"
            rel="${rel%/}"

            if [ "${REGISTERED_NAMESPACES[$rel]+_}" ]; then
                echo -e "    ${YELLOW}⚠${NC} Namespace '$rel' already registered from '${REGISTERED_NAMESPACES[$rel]}' (skipping)"
                continue
            fi

            if vendor_namespace_context_files "$ns_dir" "$principles_dst" "$rel"; then
                REGISTERED_NAMESPACES["$rel"]="$label"
                echo -e "    ${GREEN}✓${NC} principles/$rel/"
                ns_count=$((ns_count + 1))
            fi
        done
    fi

    # Merge groups (individual files, with conflict detection)
    if [ -d "$extra_dir/groups" ]; then
        local groups_dst="$catalog_dir/groups"
        mkdir -p "$groups_dst"
        for group_file in "$extra_dir/groups"/*.yaml; do
            [ -f "$group_file" ] || continue
            local group_name
            group_name="${group_file##*/}"
            group_name="${group_name%.yaml}"

            if [ "${REGISTERED_GROUPS[$group_name]+_}" ]; then
                echo -e "    ${YELLOW}⚠${NC} Group '$group_name' already registered from '${REGISTERED_GROUPS[$group_name]}' (skipping)"
                continue
            fi

            cp "$group_file" "$groups_dst/"
            REGISTERED_GROUPS["$group_name"]="$label"
            echo -e "    ${GREEN}✓${NC} groups/$group_name.yaml"
            group_count=$((group_count + 1))
        done
    fi

    if [ "$ns_count" -eq 0 ] && [ "$group_count" -eq 0 ]; then
        if [ ! -d "$extra_dir/principles" ] && [ ! -d "$extra_dir/groups" ]; then
            echo -e "    ${YELLOW}⚠${NC} No principles/ or groups/ directory found in $label"
        fi
    fi
}

install_vendor() {
    local project_dir="$1"

    if [ ! -d "$project_dir" ]; then
        echo -e "${RED}Error: Directory '$project_dir' does not exist.${NC}"; exit 1
    fi

    # --- Collect extra catalog paths ---
    local extra_catalogs=()

    # 1. User config: ~/.principles-extra
    local user_cfg="$HOME/.principles-extra"
    if [ -f "$user_cfg" ]; then
        while IFS= read -r line || [ -n "$line" ]; do
            local ep
            ep="$(expand_path "$line")"
            [[ -z "$ep" || "$ep" =~ ^# ]] && continue
            extra_catalogs+=("$ep")
        done < "$user_cfg"
    fi

    # 2. Project config: <project_dir>/.principles-extra
    local proj_cfg="$project_dir/.principles-extra"
    if [ -f "$proj_cfg" ]; then
        while IFS= read -r line || [ -n "$line" ]; do
            local ep
            ep="$(expand_path "$line")"
            [[ -z "$ep" || "$ep" =~ ^# ]] && continue
            # Resolve relative paths against the project directory
            if [[ ! "$ep" = /* ]]; then
                ep="$project_dir/$ep"
            fi
            extra_catalogs+=("$ep")
        done < "$proj_cfg"
    fi

    # 3. CLI flags (already expanded by arg parsing)
    if [ "${#EXTRA_CATALOGS_CLI[@]}" -gt 0 ]; then
        for p in "${EXTRA_CATALOGS_CLI[@]}"; do
            extra_catalogs+=("$p")
        done
    fi

    echo -e "${BOLD}Vendoring catalog to: $project_dir/.principles-catalog/${NC}"

    local catalog_dir="$project_dir/.principles-catalog"
    mkdir -p "$catalog_dir"

    # Reset registries — built-in namespaces are registered first to prevent shadowing
    REGISTERED_NAMESPACES=()
    REGISTERED_GROUPS=()

    for dir in "$SCRIPT_DIR/principles"/*/ "$SCRIPT_DIR/principles"/*/*/; do
        [ -d "$dir" ] || continue
        local rel="${dir#$SCRIPT_DIR/principles/}"; rel="${rel%/}"
        REGISTERED_NAMESPACES["$rel"]="built-in"
    done
    for f in "$SCRIPT_DIR/groups"/*.yaml; do
        [ -f "$f" ] || continue
        local g="${f##*/}"; g="${g%.yaml}"
        REGISTERED_GROUPS["$g"]="built-in"
    done

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
        for context_file in ".context-audit.md" ".context-prime.md" ".context-inspect.md" ".context-scout.md" "catalog.yaml"; do
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

    # Merge extra catalogs
    if [ "${#extra_catalogs[@]}" -gt 0 ]; then
        echo ""
        echo -e "${BOLD}Merging extra catalogs...${NC}"
        for extra_dir in "${extra_catalogs[@]}"; do
            vendor_extra_catalog "$extra_dir" "$catalog_dir"
        done
    fi

    generate_compact_index "$catalog_dir" "${extra_catalogs[@]+"${extra_catalogs[@]}"}"

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
    while IFS= read -r file; do
        local command_name="${file#$COMMAND_SOURCE_DIR/}"; command_name="${command_name%.md}"
        if [ -f "$file" ] && [ -f "$project_dir/.claude/commands/$command_name.md" ]; then
            echo -e "  ${GREEN}✓${NC} /${command_name//\//\:}"
            found=true
        fi
    done < <(find "$COMMAND_SOURCE_DIR" -name "*.md" -type f | sort)
    if [ "$found" = false ]; then
        echo "  (none)"
    fi

    echo ""
    echo "Copilot CLI skills (.github/skills/):"
    local copilot_cli_found=false
    while IFS= read -r file; do
        local command_name="${file#$COMMAND_SOURCE_DIR/}"; command_name="${command_name%.md}"
        local command_slug="${command_name//\//-}"
        local skill_file="$project_dir/.github/skills/$command_slug/SKILL.md"
        if [ -f "$skill_file" ]; then
            echo -e "  ${GREEN}✓${NC} .github/skills/$command_slug/SKILL.md"
            copilot_cli_found=true
        fi
    done < <(find "$COMMAND_SOURCE_DIR" -name "*.md" -type f | sort)
    if [ "$copilot_cli_found" = false ]; then
        echo "  (none)"
    fi

    echo ""
    echo "Copilot IDE prompts (.github/prompts/):"
    local copilot_ide_found=false
    while IFS= read -r file; do
        local command_name="${file#$COMMAND_SOURCE_DIR/}"; command_name="${command_name%.md}"
        local command_slug="${command_name//\//-}"
        local prompt_file="$project_dir/.github/prompts/$command_slug.prompt.md"
        if [ -f "$prompt_file" ]; then
            echo -e "  ${GREEN}✓${NC} .github/prompts/$command_slug.prompt.md"
            copilot_ide_found=true
        fi
    done < <(find "$COMMAND_SOURCE_DIR" -name "*.md" -type f | sort)
    if [ "$copilot_ide_found" = false ]; then
        echo "  (none)"
    fi

    echo ""
    echo "Codex skills (.agents/skills/):"
    local codex_found=false
    while IFS= read -r file; do
        local command_name="${file#$COMMAND_SOURCE_DIR/}"; command_name="${command_name%.md}"
        local command_slug="${command_name//\//-}"
        local skill_file="$project_dir/.agents/skills/$command_slug/SKILL.md"
        if [ -f "$skill_file" ]; then
            echo -e "  ${GREEN}✓${NC} .agents/skills/$command_slug/SKILL.md"
            codex_found=true
        fi
    done < <(find "$COMMAND_SOURCE_DIR" -name "*.md" -type f | sort)
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

    echo ""
    echo "Review integration (emitted by /dot-scout at runtime):"
    read_install_cfg "$project_dir"
    local review_found=false
    if [ "${INSTALLED_TARGETS[copilot-review]:-}" = "1" ]; then
        echo -e "  ${GREEN}✓${NC} Copilot Code Review → .github/instructions/"
        review_found=true
    fi
    if [ "${INSTALLED_TARGETS[claude-review]:-}" = "1" ]; then
        echo -e "  ${GREEN}✓${NC} Claude Code Review  → REVIEW.md"
        review_found=true
    fi
    if [ "$review_found" = false ]; then
        echo "  (none — re-run installer to enable review targets)"
    fi
}

show_usage() {
    echo ""
    echo -e "Usage: $0 [${BOLD}<target>${NC}] ${BOLD}<dir>${NC}"
    echo ""
    echo -e "${BOLD}Targets:${NC}"
    echo -e "  ${BOLD}claude${NC} <dir>        Install slash commands in <dir>/.claude/commands/"
    echo -e "  ${BOLD}copilot${NC} <dir>       Install Copilot CLI + IDE (same as copilot-cli + copilot-ide)"
    echo -e "  ${BOLD}copilot-cli${NC} <dir>   Install Copilot CLI skills in <dir>/.github/skills/"
    echo -e "  ${BOLD}copilot-ide${NC} <dir>   Install Copilot IDE prompts in <dir>/.github/prompts/"
    echo -e "  ${BOLD}codex${NC} <dir>         Install Codex skills in <dir>/.agents/skills/"
    echo -e "  ${BOLD}vendor${NC} <dir>        Update catalog + reinstall any previously installed skills"
    echo -e "  ${BOLD}all${NC} <dir>           All commands + review + vendor in <dir>"
    echo ""
    echo -e "${BOLD}Interactive:${NC}"
    echo -e "  ${BOLD}<dir>${NC}               Select tools interactively (includes review options)"
    echo ""
    echo -e "${BOLD}Management:${NC}"
    echo -e "  ${BOLD}--list${NC} <dir>        Show what's installed in <dir>"
    echo -e "  ${BOLD}--help${NC}              Show this help"
    echo "  ./uninstall.sh <dir> Remove local assets from <dir>"
    echo ""
    echo -e "${DIM}Review integration (controlled via interactive mode or 'all'):${NC}"
    echo -e "  Copilot Code Review → .github/instructions/ ${DIM}(emitted by /dot-scout)${NC}"
    echo -e "  Claude Code Review  → REVIEW.md             ${DIM}(emitted by /dot-scout)${NC}"
    echo ""
    echo -e "${BOLD}Examples:${NC}"
    echo "  ./install.sh ~/projects/my-app           # Interactive"
    echo "  ./install.sh claude ~/projects/my-app"
    echo "  ./install.sh copilot ~/projects/my-app"
    echo "  ./install.sh codex ~/projects/my-app"
    echo "  ./install.sh all ~/projects/my-app"
    echo ""
    echo -e "${BOLD}Extra catalogs (corporate or personal principles):${NC}"
    echo -e "  ${BOLD}--extra-catalog${NC} <path>  Merge an additional principles directory into .principles-catalog/"
    echo "                         Can be repeated. Paths in ~/.principles-extra and <dir>/.principles-extra"
    echo "                         are loaded automatically (one path per line, # for comments)."
    echo ""
    echo "  ./install.sh vendor ~/projects/my-app --extra-catalog ~/acme-principles"
    echo "  ./install.sh all    ~/projects/my-app --extra-catalog ~/acme-principles"
    echo ""
    echo "  See INSTALL.md for corporate and personal setup instructions."
}

# Interactive tool selection — two-level menu
interactive_install() {
    local project_dir="$1"

    if ! [ -t 0 ]; then
        echo -e "${RED}Error: Interactive mode requires a terminal. Use a named target instead.${NC}"
        show_usage
        exit 1
    fi

    # Load existing install.cfg to preserve previous selections
    read_install_cfg "$project_dir"

    # ── Step 1: Select AI agents ──────────────────────────────────────────
    echo ""
    echo "Which AI agents do you use?"
    echo ""
    echo "  1) GitHub Copilot   (CLI, IDE, Code Review)"
    echo "  2) Claude Code      (commands, Code Review)"
    echo "  3) Codex            (CLI / IDE skills)"
    echo ""
    echo "  a) All of the above"
    echo "  q) Quit"
    echo ""
    printf "Select agents (e.g. 1 2, or 'a' for all): "
    read -r agent_selection

    if [ -z "$agent_selection" ] || [ "$agent_selection" = "q" ]; then
        echo "Cancelled."
        exit 0
    fi

    local do_copilot=false do_claude=false do_codex=false

    if [ "$agent_selection" = "a" ] || [ "$agent_selection" = "A" ]; then
        do_copilot=true; do_claude=true; do_codex=true
    else
        for token in $agent_selection; do
            case "$token" in
                1) do_copilot=true ;;
                2) do_claude=true ;;
                3) do_codex=true ;;
                *) echo -e "${YELLOW}Warning: Unknown selection '$token' — skipped${NC}" ;;
            esac
        done
    fi

    local installed_any=false

    # ── Step 2a: Copilot sub-menu ─────────────────────────────────────────
    if [ "$do_copilot" = true ]; then
        echo ""
        echo "GitHub Copilot — what to install?"
        echo ""
        echo "  1) Copilot CLI              → .github/skills/"
        echo "  2) Copilot IDE              → .github/prompts/"
        echo "  3) Copilot Code Review      → .github/instructions/  (emitted by /dot-scout)"
        echo "  4) Copilot CLI (1) + Review (3)"
        echo "  5) Copilot IDE (2) + Review (3)"
        echo "  6) All (1, 2, 3)"
        echo ""
        printf "Select (1-6): "
        read -r copilot_choice

        local cp_cli=false cp_ide=false cp_review=false
        case "${copilot_choice:-}" in
            1) cp_cli=true ;;
            2) cp_ide=true ;;
            3) cp_review=true ;;
            4) cp_cli=true; cp_review=true ;;
            5) cp_ide=true; cp_review=true ;;
            6) cp_cli=true; cp_ide=true; cp_review=true ;;
            *) echo -e "${YELLOW}Invalid choice — installing all Copilot targets${NC}"
               cp_cli=true; cp_ide=true; cp_review=true ;;
        esac

        if [ "$cp_cli" = true ]; then
            "$SCRIPT_DIR/uninstall.sh" --quiet --target copilot "$project_dir"
            install_from_template "$TEMPLATE_DIR/copilot-cli" "$project_dir"
            mark_targets copilot-cli
            echo ""; installed_any=true
        fi
        if [ "$cp_ide" = true ]; then
            install_from_template "$TEMPLATE_DIR/copilot-ide" "$project_dir"
            mark_targets copilot-ide
            echo ""; installed_any=true
        fi
        if [ "$cp_review" = true ]; then
            mark_targets copilot-review
            installed_any=true
        fi
    fi

    # ── Step 2b: Claude sub-menu ──────────────────────────────────────────
    if [ "$do_claude" = true ]; then
        echo ""
        echo "Claude Code — what to install?"
        echo ""
        echo "  1) Claude Code              → .claude/commands/"
        echo "  2) Claude Code Review       → REVIEW.md              (emitted by /dot-scout)"
        echo "  3) All (1, 2)"
        echo ""
        printf "Select (1-3): "
        read -r claude_choice

        local cl_code=false cl_review=false
        case "${claude_choice:-}" in
            1) cl_code=true ;;
            2) cl_review=true ;;
            3) cl_code=true; cl_review=true ;;
            *) echo -e "${YELLOW}Invalid choice — installing all Claude targets${NC}"
               cl_code=true; cl_review=true ;;
        esac

        if [ "$cl_code" = true ]; then
            "$SCRIPT_DIR/uninstall.sh" --quiet --target claude "$project_dir"
            install_from_template "$TEMPLATE_DIR/claude" "$project_dir"
            mark_targets claude
            echo ""; installed_any=true
        fi
        if [ "$cl_review" = true ]; then
            mark_targets claude-review
            installed_any=true
        fi
    fi

    # ── Step 2c: Codex (no sub-menu) ──────────────────────────────────────
    if [ "$do_codex" = true ]; then
        echo ""
        "$SCRIPT_DIR/uninstall.sh" --quiet --target codex "$project_dir"
        install_from_template "$TEMPLATE_DIR/codex" "$project_dir"
        mark_targets codex
        echo ""; installed_any=true
    fi

    # ── Auto: vendor catalog ──────────────────────────────────────────────
    if [ "$installed_any" = true ]; then
        echo ""
        "$SCRIPT_DIR/uninstall.sh" --quiet --target vendor "$project_dir"
        install_vendor "$project_dir"
        mark_targets vendor

        write_install_cfg "$project_dir"

        # Summary
        local has_review=false
        if [ "${INSTALLED_TARGETS[copilot-review]:-}" = "1" ] || [ "${INSTALLED_TARGETS[claude-review]:-}" = "1" ]; then
            has_review=true
        fi
        if [ "$has_review" = true ]; then
            echo ""
            echo -e "${BOLD}Review integration enabled — run /dot-scout to emit review files:${NC}"
            [ "${INSTALLED_TARGETS[copilot-review]:-}" = "1" ] && echo "  Copilot Code Review  → .github/instructions/   (applyTo: frontmatter)"
            [ "${INSTALLED_TARGETS[claude-review]:-}" = "1" ]  && echo "  Claude Code Review   → REVIEW.md               (severity-grouped)"
        fi
    else
        echo "Nothing selected."
    fi
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
