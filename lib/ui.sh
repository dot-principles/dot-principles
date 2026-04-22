# ui.sh — User-facing commands for install.sh
# Sourced by install.sh. Defines: list_installed, show_usage, interactive_install.
# Requires: $SCRIPT_DIR, $TEMPLATE_DIR, $COMMAND_SOURCE_DIR, color variables,
# INSTALLED_TARGETS, read_install_cfg, mark_targets, install_from_template, install_vendor.

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
    done < <(list_command_files)
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
    done < <(list_command_files)
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
    done < <(list_command_files)
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
    done < <(list_command_files)
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
