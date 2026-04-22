# path-utils.sh — Path normalisation helpers for install.sh
# Sourced by install.sh. Defines: normalize_path, normalize_directory_path, expand_path.

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
