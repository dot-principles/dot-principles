# Installation

This guide covers installing `.principles` on Linux, macOS, and Windows.

---

## Prerequisites

- **Bash 4+** — required by `install.sh` / `uninstall.sh`
- **AI model** — Claude Haiku 4.5+, GPT-4.1+, or equivalent

See [REQUIREMENTS.md](REQUIREMENTS.md) for platform-specific setup and model compatibility details.

---

## 1. Clone the repo

```bash
git clone https://github.com/dot-principles/principles.git
cd .principles
```

---

## 2. Install into your project

`.principles` is a **repo-local** install — there is no global install. A `<dir>` argument is always required. The primary command installs everything at once:

### Linux / macOS

```bash
# Install all tools into a project
./install.sh all <project-dir>
```

### Windows

Windows users need bash on `PATH`. The repo ships thin wrapper scripts for both PowerShell and Command Prompt that detect bash and forward arguments to the real `install.sh`.

**Step 1 — get bash.** Install [Git for Windows](https://git-scm.com/download/win) (includes Git Bash). WSL, MSYS2, and Cygwin also work as long as `bash` is on `PATH`.

**Step 2 — run the wrapper.**

**PowerShell:**

```powershell
.\install.ps1 all C:\projects\my-app
```

**Command Prompt:**

```cmd
install.cmd all C:\projects\my-app
```

> **Path note:** `install.cmd` / `uninstall.cmd` normalize backslashes to forward slashes before calling bash. `install.ps1` / `uninstall.ps1` convert `C:\...` paths to a bash-friendly absolute path.

---

## 3. What gets installed

`install.sh all <dir>` writes the following files into `<dir>`:

| File | Purpose |
|------|---------|
| `.claude/commands/dot-scout.md` | `/dot-scout` slash command for Claude Code |
| `.claude/commands/dot-prime.md` | `/dot-prime` slash command for Claude Code |
| `.claude/commands/dot-audit.md` | `/dot-audit` slash command for Claude Code |
| `.github/instructions/` | Per-group principle files for Copilot Code Review (written by `/dot-scout`) |
| `.github/prompts/dot-scout.prompt.md` | `/dot-scout` in VS Code / JetBrains Copilot Chat |
| `.github/prompts/dot-prime.prompt.md` | `/dot-prime` in VS Code / JetBrains Copilot Chat |
| `.github/prompts/dot-audit.prompt.md` | `/dot-audit` in VS Code / JetBrains Copilot Chat |
| `.github/skills/dot-scout/SKILL.md` | `/dot-scout` in Copilot CLI |
| `.github/skills/dot-prime/SKILL.md` | `/dot-prime` in Copilot CLI |
| `.github/skills/dot-audit/SKILL.md` | `/dot-audit` in Copilot CLI |
| `.agents/skills/dot-scout/SKILL.md` | `$dot-scout` in Codex CLI and Codex IDE |
| `.agents/skills/dot-prime/SKILL.md` | `$dot-prime` in Codex CLI and Codex IDE |
| `.agents/skills/dot-audit/SKILL.md` | `$dot-audit` in Codex CLI and Codex IDE |
| `.principles-catalog/` | Vendored principle data (see Section 4) |

**Commit all of these files** so every team member gets the commands automatically:

```bash
cd <project-dir>
git add .claude/ .github/ .agents/ .principles-catalog/
git commit -m "Add .principles AI commands and principle files"
```

You can also install a subset, or use interactive mode:

```bash
# Interactive — select which tools to install
./install.sh <dir>

# Claude Code commands only
./install.sh claude <dir>

# Copilot CLI skills only
./install.sh copilot-cli <dir>

# Copilot IDE prompts only
./install.sh copilot-ide <dir>

# Copilot CLI + IDE (same as copilot-cli + copilot-ide)
./install.sh copilot <dir>

# Codex skills only
./install.sh codex <dir>

# Show what's installed
./install.sh --list <dir>
```

---

## 4. Vendor subcommand — `.principles-catalog/`

The `vendor` subcommand copies the subset of the principle catalog referenced by the project's `.principles` files into `<dir>/.principles-catalog/`:

```bash
./install.sh vendor <project-dir>
```

`install.sh all` runs `vendor` automatically. You only need to run it manually if you add new principles to your `.principles` files after the initial install.

As part of vendoring, `install.sh vendor` also generates `<dir>/.principles-catalog/index.tsv` — a pipe-delimited flat file (`ID|LAYER|SUMMARY`, one line per principle) covering every vendored principle. `/dot-scout` reads this single file to resolve active principles and emit per-group files in one pass, without walking hundreds of individual namespace files. Example entries:

```
CODE-SEC-VALIDATE-INPUT|1|Validate all input at every system boundary; never trust external data.
DDD-AGGREGATE|2|Enforce business invariants within a single aggregate boundary per transaction.
```

**Why commit `.principles-catalog/`?** The installed commands (`/dot-scout`, `/dot-prime`, `/dot-audit`) reference `.principles-catalog/` inside the project. Committing this directory means the commands work for every team member — even without access to the `.principles` repo — and the CI/CD environment gets the same principle data.

`.principles-catalog/` contains the same file structure as the `principles/` directory in this repo, filtered to the namespaces and groups your project actually uses.

---

## 5. Claude Code

After `install.sh all <dir>`, Claude Code slash commands are written to `<dir>/.claude/commands/`. Claude Code discovers these automatically when opened in that project directory.

**Per-group files:** After running `/dot-scout`, per-group principle files are emitted to `.claude/rules/` with `paths:` frontmatter targeting the relevant file types. Claude Code reads everything in `.claude/rules/` as always-on context — no further configuration needed.

Run `/dot-scout` once per project to populate `.principles` files and emit per-group principle files:

```
/dot-scout
/dot-prime     ← before writing code
/dot-audit     ← review against active principles
```

---

## 6. GitHub Copilot

### Copilot CLI (`install.sh copilot-cli <dir>`)

Writes skill files into `.github/skills/`:

| File | Consumed by |
|------|-------------|
| `.github/skills/<name>/SKILL.md` | Copilot CLI (terminal slash commands) |

### Copilot IDE (`install.sh copilot-ide <dir>`)

Writes prompt files into `.github/prompts/`:

| File | Consumed by |
|------|-------------|
| `.github/prompts/<name>.prompt.md` | VS Code / JetBrains / Visual Studio Copilot Chat |

The `copilot` sub-command installs both CLI skills and IDE prompts. This repo ships with pre-populated `.github/prompts/` and `.github/skills/` directories so contributors working in this repo get `/dot-scout`, `/dot-prime`, and `/dot-audit` without running the installer.

**Per-group files:** After `/dot-scout`, one file per active `@group` is written to `.github/instructions/` with `applyTo:` frontmatter listing the file globs for that group. Copilot Code Review activates each file only when reviewing paths that match its globs — keeping each file within the context budget.

---

## 7. Codex

`install.sh all <dir>` (or `install.sh codex <dir>`) writes repo-scoped Codex skills into `.agents/skills/`:

| File | Consumed by |
|------|-------------|
| `.agents/skills/<name>/SKILL.md` | Codex CLI and Codex IDE extension |

Codex reads repo skills from `.agents/skills/`. After install, invoke the workflows as `$dot-scout`, `$dot-prime`, and `$dot-audit` in Codex.

---

## 8. Uninstall

```bash
# Remove all .principles assets from a project
./uninstall.sh <project-dir>
```

The uninstaller:
- Removes per-group principle files from `.github/instructions/` and `.claude/rules/` (files with `<!-- generated by /dot-scout -->` marker)
- Removes `.claude/commands/dot-scout.md`, `dot-prime.md`, `dot-audit.md`
- Removes `.github/skills/dot-scout/`, `dot-prime/`, `dot-audit/` and `.github/prompts/*.prompt.md`
- Removes `.agents/skills/dot-scout/`, `dot-prime/`, `dot-audit/`
- Removes `.principles-catalog/`
- Cleans up legacy assets: `.ai/`, compiled blocks from `AGENTS.md`/`CLAUDE.md`/`copilot-instructions.md`
- Removes legacy `~/.principles` if present from an older install

On Windows, use `uninstall.ps1` or `uninstall.cmd` with the same arguments.

---

## 9. Try it on a branch first

Not ready to commit to a project? Install locally into a throwaway branch:

```bash
cd ~/projects/my-app
git checkout -b try-principles

# Install into this project directory only
/path/to/.principles/install.sh all .
# or on Windows:
# \path\to\.principles\install.ps1 all .

# Run /dot-scout, /dot-prime, /dot-audit — explore without touching your main branch
# When done, delete the branch to remove everything
git checkout main && git branch -D try-principles
```

---

## 10. After installing

Open your AI tool and run the commands:

```
/dot-scout              → detect project profile, create .principles files, emit per-group principle files
/dot-prime              → activate principles before writing code
/dot-audit              → review code with severity-categorized findings
/dot-audit DDD on src/  → force specific principles, ignoring .principles files
```

See [README.md](README.md) for a full walkthrough and examples.
