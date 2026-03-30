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
| `.claude/commands/scout.md` | `/scout` slash command for Claude Code |
| `.claude/commands/prime.md` | `/prime` slash command for Claude Code |
| `.claude/commands/audit.md` | `/audit` slash command for Claude Code |
| `.github/instructions/` | Per-group principle files for Copilot Code Review (written by `/scout`) |
| `.github/prompts/scout.prompt.md` | `/scout` in VS Code / JetBrains Copilot Chat |
| `.github/prompts/prime.prompt.md` | `/prime` in VS Code / JetBrains Copilot Chat |
| `.github/prompts/audit.prompt.md` | `/audit` in VS Code / JetBrains Copilot Chat |
| `.github/skills/scout/SKILL.md` | `/scout` in Copilot CLI |
| `.github/skills/prime/SKILL.md` | `/prime` in Copilot CLI |
| `.github/skills/audit/SKILL.md` | `/audit` in Copilot CLI |
| `.principles-catalog/` | Vendored principle data (see Section 4) |

**Commit all of these files** so every team member gets the commands automatically:

```bash
cd <project-dir>
git add .claude/ .github/ .principles-catalog/
git commit -m "Add .principles AI commands and principle files"
```

You can also install a subset if needed:

```bash
# Claude Code commands only
./install.sh claude <dir>

# GitHub Copilot files only
./install.sh copilot <dir>
```

---

## 4. Vendor subcommand — `.principles-catalog/`

The `vendor` subcommand copies the subset of the principle catalog referenced by the project's `.principles` files into `<dir>/.principles-catalog/`:

```bash
./install.sh vendor <project-dir>
```

`install.sh all` runs `vendor` automatically. You only need to run it manually if you add new principles to your `.principles` files after the initial install.

As part of vendoring, `install.sh vendor` also generates `<dir>/.principles-catalog/index.tsv` — a pipe-delimited flat file (`ID|LAYER|SUMMARY`, one line per principle) covering every vendored principle. `/scout` reads this single file to resolve active principles and emit per-group files in one pass, without walking hundreds of individual namespace files. Example entries:

```
CODE-SEC-VALIDATE-INPUT|1|Validate all input at every system boundary; never trust external data.
DDD-AGGREGATE|2|Enforce business invariants within a single aggregate boundary per transaction.
```

**Why commit `.principles-catalog/`?** The installed commands (`/scout`, `/prime`, `/audit`) reference `.principles-catalog/` inside the project. Committing this directory means the commands work for every team member — even without access to the `.principles` repo — and the CI/CD environment gets the same principle data.

`.principles-catalog/` contains the same file structure as the `principles/` directory in this repo, filtered to the namespaces and groups your project actually uses.

---

## 5. Claude Code

After `install.sh all <dir>`, Claude Code slash commands are written to `<dir>/.claude/commands/`. Claude Code discovers these automatically when opened in that project directory.

**Per-group files:** After running `/scout`, per-group principle files are emitted to `.claude/rules/` with `paths:` frontmatter targeting the relevant file types. Claude Code reads everything in `.claude/rules/` as always-on context — no further configuration needed.

Run `/scout` once per project to populate `.principles` files and emit per-group principle files:

```
/scout
/prime     ← before writing code
/audit     ← review against active principles
```

---

## 6. GitHub Copilot

`install.sh all <dir>` (or `install.sh copilot <dir>`) writes into `.github/` inside that project:

| File | Consumed by |
|------|-------------|
| `.github/instructions/<group>.instructions.md` | Copilot Code Review (path-targeted, written by `/scout`) |
| `.github/prompts/<name>.prompt.md` | VS Code / JetBrains / Visual Studio Copilot Chat |
| `.github/skills/<name>/SKILL.md` | Copilot CLI (terminal slash commands) |

This repo ships with pre-populated `.github/prompts/` and `.github/skills/` directories so contributors working in this repo get `/scout`, `/prime`, and `/audit` without running the installer.

**Per-group files:** After `/scout`, one file per active `@group` is written to `.github/instructions/` with `applyTo:` frontmatter listing the file globs for that group. Copilot Code Review activates each file only when reviewing paths that match its globs — keeping each file within the context budget.

---

## 7. Uninstall

```bash
# Remove all .principles assets from a project
./uninstall.sh <project-dir>
```

The uninstaller:
- Removes per-group principle files from `.github/instructions/` and `.claude/rules/` (files with `<!-- generated by /scout -->` marker)
- Removes `.claude/commands/scout.md`, `prime.md`, `audit.md`
- Removes `.principles-catalog/`
- Cleans up legacy assets: `.ai/`, compiled blocks from `AGENTS.md`/`CLAUDE.md`/`copilot-instructions.md`
- Removes legacy `~/.principles` if present from an older install

On Windows, use `uninstall.ps1` or `uninstall.cmd` with the same arguments.

---

## 8. Try it on a branch first

Not ready to commit to a project? Install locally into a throwaway branch:

```bash
cd ~/projects/my-app
git checkout -b try-principles

# Install into this project directory only
/path/to/.principles/install.sh all .
# or on Windows:
# \path\to\.principles\install.ps1 all .

# Run /scout, /prime, /audit — explore without touching your main branch
# When done, delete the branch to remove everything
git checkout main && git branch -D try-principles
```

---

## 9. After installing

Open your AI tool and run the commands:

```
/scout              → detect project profile, create .principles files, emit per-group principle files
/prime              → activate principles before writing code
/audit              → review code with severity-categorized findings
/audit DDD on src/  → force specific principles, ignoring .principles files
```

See [README.md](README.md) for a full walkthrough and examples.

