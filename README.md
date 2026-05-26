# .principles

[![License: MIT](https://img.shields.io/badge/tooling-MIT-green.svg)](https://opensource.org/licenses/MIT) [![License: CC BY-SA 4.0](https://img.shields.io/badge/principles-CC%20BY--SA%204.0-blue.svg)](https://creativecommons.org/licenses/by-sa/4.0/) [![GitHub release](https://img.shields.io/github/v/release/dot-principles/dot-principles.github.io)](https://github.com/dot-principles/dot-principles.github.io/releases)

**Select the engineering principles you want your AI agent to apply - for code, docs, infrastructure, configuration, schemas, and pipelines.**

A curated catalog of engineering principles, organized into a `.principles` hierarchy that projects declare to guide AI-assisted work across all "X as Code" artifact types.

> See [DISCLAIMER.md](DISCLAIMER.md) - this is a proof of concept. Groups are opinionated, gaps exist, and adjustments are expected.

> 🌐 **Guided docs:** [dot-principles.github.io](https://dot-principles.github.io/) — Why → Examples → Getting Started → Commands → How It Works → Extending
>
> 📦 **Latest release:** [v0.13.1](https://github.com/dot-principles/dot-principles.github.io/releases/latest) - see [all releases](https://github.com/dot-principles/dot-principles.github.io/releases) and [CHANGELOG](CHANGELOG.md).

---

## Why `.principles`?

AI coding agents already know a great deal of software engineering. What they do **not** automatically know is which principles matter in *your* repo, in *this* subtree, for *this* kind of artifact.

That is the gap `.principles` fills.

- It gives AI tools **local engineering intent**, not just generic knowledge.
- It works across **code, docs, infra, config, schemas, and pipelines**.
- It makes principle selection **plain-text, inspectable, and version-controlled**.
- It supports a practical loop: **`dot-scout` → `dot-prime` → code → `dot-audit`**.

If you want the fuller narrative, start with [Why `.principles`](https://dot-principles.github.io/why).

## Start here

| If you want to... | Start here |
|---|---|
| Understand the value proposition | [Why `.principles`](https://dot-principles.github.io/why) |
| Install it and try it quickly | [Getting Started](https://dot-principles.github.io/getting-started) |
| Understand the hierarchy and artifact model | [How It Works](https://dot-principles.github.io/how-it-works) |
| Learn what each command does | [Commands](https://dot-principles.github.io/commands) |
| Add your own company or domain catalog | [Extending](https://dot-principles.github.io/extending) |
| See an end-to-end walkthrough | [Examples](https://dot-principles.github.io/examples) and [demo/presentation.md](demo/presentation.md) |

## At a glance

### What it is

`.principles` is a portable, repo-local configuration system for AI-assisted engineering. It tells an agent which principles apply to which part of a codebase, then loads those principles before coding or reviewing.

### Why it helps

Specs tell the agent what the system should do. Tests prove whether it does it. `.principles` helps answer whether the result is well-shaped according to the standards the team wants applied.

### What stays canonical

- [`INSTALL.md`](INSTALL.md) - full install and platform guide
- [`DESIGN.md`](DESIGN.md) - architecture and contributor reference
- [`demo/presentation.md`](demo/presentation.md) - end-to-end user walkthrough

### Quick example

```text
my-project/
├── .principles
├── backend/.principles
├── backend/src/payments/.principles
└── docs/.principles
```

The root can set broad defaults. Subtrees can add more specific groups or suppress rules where local context differs. The system walks upward from the file being reviewed, merges the active hierarchy, and loads the relevant principle content.

See [How It Works](https://dot-principles.github.io/how-it-works) for the fuller model.

---

## 🧠 Philosophy

`.principles` does **not** teach the AI anything - modern agents already know SOLID, OWASP, DDD, and the rest. It **focuses and triggers** that knowledge: giving the AI context about *which* principles matter for *this* codebase and artifact type. See [DESIGN.md §1](DESIGN.md#️-1-overview) for the full architectural rationale.

## ⚙️ How it works

Place a `.principles` file in your project root (and optionally in subdirectories) to declare which principles apply:

```
# Activate all Spring Boot principles (includes java)
@spring-boot

# Add a specific principle
CODE-OB-SERVICE-LEVEL-OBJECTIVES

# Suppress a principle for this subtree
!CODE-API-HATEOAS
```

The system walks up from the reviewed file to the git root, collecting `.principles` files and merging them (outermost first, innermost last). The AI then reads the full principle content before coding or reviewing.

### 🗂️ Layer model

Each artifact type has its own stack of layers in `layers/<type>/`. Within each stack:

| Layer                       | When                          | What                                                                               |
|-----------------------------|-------------------------------|------------------------------------------------------------------------------------|
| **Universal (cross-stack)** | Always, for all types         | DRY · KISS · YAGNI · Naming · Reveals Intention · ADR |
| **Layer 1 - Universal**     | Always, for the matched type  | Non-negotiable principles for that artifact type (e.g., code: SOLID, fail-fast; docs: DOC-PURPOSE, DOC-MINIMAL) |
| **Layer 2 - Contextual**    | Based on content signals      | API design, concurrency, data modeling, tutorial vs. reference docs, etc.          |
| **Layer 3 - Risk-elevated** | Based on risk signals         | Security, performance, backward compatibility (code and infra stacks only)         |

### 🛠️ Three commands

Because these are AI commands - not CLI tools - you speak to them in natural language. No need to specify exact file paths unless you want to. The AI understands context.

- 🔭 **`dot-scout`** - `/dot-scout` in Claude/Copilot, `$dot-scout` in Codex. Detects language/framework/domain, creates `.principles` files, then emits per-group principle files to `.github/instructions/` (Copilot Code Review) and `.claude/rules/` (Claude Code).
- ⚡ **`dot-prime`** - `/dot-prime` in Claude/Copilot, `$dot-prime` in Codex. Resolves your `.principles` hierarchy (using per-group files fast path), loads full principle guidance, prepares your coding frame.
- 🔎 **`dot-audit`** - `/dot-audit` in Claude/Copilot, `$dot-audit` in Codex. Resolves your `.principles` hierarchy (using per-group files fast path), loads principle content, reviews code, and groups findings by severity (Critical / High / Medium / Low).

The AI figures out the scope from context:

```
# Claude / Copilot (use $dot-audit / $dot-prime in Codex):
/dot-audit current changes          → reviews only what has changed since last commit
/dot-audit the payment module       → reviews the payments subtree
/dot-audit                          → you decide the scope in conversation
/dot-prime                          → loads principles for whatever you're about to work on

# Force specific principles (ignores .principles files):
/dot-audit DDD on src/orders        → review src/orders against DDD principles
/dot-audit src/orders --with ddd    → same, flag syntax
/dot-audit @ddd src/orders          → same, group-prefix syntax
/dot-audit clean-arch, solid on src → multiple groups, comma-separated
```

## 🚀 Quick start

**Prerequisites:** Bash 4+ - see [REQUIREMENTS.md](REQUIREMENTS.md) for platform-specific setup. Tested with Claude Haiku 4.5, GPT-4.1, and GPT-5.1-mini (low). Premium models recommended for best review quality and formatting. Local LLMs not supported.

```bash
# Clone the repo
git clone https://github.com/dot-principles/dot-principles.github.io.git

# Install into your project (Claude Code commands + Copilot files + Codex skills + vendor catalog)
./install.sh all <project-dir>

# Commit the installed files so every team member gets the commands automatically
cd <project-dir>
git add .claude/ .github/ .agents/ .principles-catalog/
git commit -m "Add .principles AI commands and principle files"

# Use it - in Claude Code, Copilot, or Codex:
#   /dot-scout                      → detect profile, create .principles files, emit per-group files
#   /dot-prime                      → before writing code
#   /dot-audit current changes      → review only what changed since last commit
#   /dot-audit directory            → review whatever you describe in conversation
#   /dot-audit DDD on src/          → force DDD principles regardless of .principles files
#   $dot-scout / $dot-prime / $dot-audit    → same workflows in Codex CLI or IDE
```

**GitHub Copilot (VS Code / JetBrains / CLI):** The repo ships with `.github/prompts/` and `.github/skills/` already populated - `/dot-scout`, `/dot-prime`, and `/dot-audit` are available in Copilot Chat (IDE) and Copilot CLI (terminal) as soon as you clone.

**Codex (CLI + IDE):** The repo also ships with `.agents/skills/` populated - use `$dot-scout`, `$dot-prime`, and `$dot-audit` in Codex.

To install into your own project:

```bash
./install.sh all <dir>
```

See [INSTALL.md](INSTALL.md) for full platform instructions (Linux, macOS, Windows) and all supported tools.

### ➕ Corporate & personal principles

Plug in your own principles alongside the built-in catalog - no fork needed. Create an extra catalog directory following the same structure as `principles/`, then register it:

```bash
# Register for all your projects (user-level)
echo ~/acme-principles >> ~/.principles-extra

# Or per-project
echo /shared/acme-principles >> my-project/.principles-extra

# Or on the CLI
./install.sh vendor my-project --extra-catalog ~/acme-principles
```

Corporate and personal catalogs work simultaneously - just list both in `~/.principles-extra`. See [INSTALL.md §9](INSTALL.md#9-corporate--personal-principles) for the full setup guide. A starter template lives in [`templates/extra-catalog/`](templates/extra-catalog/). A complete working example lives at [`github.com/dot-principles/example-catalog`](https://github.com/dot-principles/example-catalog) (Plain-Text-as-Code namespace).

## 📚 Principle catalog

**375 principles across 32 namespaces** - `CODE-*`, `SOLID-`, `GOF-`, `DDD-`, `GRASP-`, `OWASP-`, `12FACTOR-`, `EIP-`, `SEC-ARCH-`, `ARCH-`, `INFRA-`, `CD-`, `PIPELINE-`, `SCHEMA-`, `CONFIG-`, `DOC-`, `FP-`, `A11Y-`, `SIMPLE-DESIGN-`, `CLEAN-ARCH-`, `PKG-`, `EFFECTIVE-JAVA-`, and more. See [DESIGN.md §2](DESIGN.md#-2-catalog-structure) for the full namespace reference and [DESIGN.md §7](DESIGN.md#-7-groups) for the 53 shipped groups.

Many principles include **code examples and diagrams** to make the guidance concrete.

## 💡 Example review output

> **Note:** The output below is illustrative. Formatting, structure, and level of detail will vary between AI models and even between runs of the same model. The principle review itself is performed by the AI - some models produce thorough, well-structured audits; others may miss findings or deviate from the template. The `audit-output.json` file is the most reliable artefact; the text report is best-effort.

```
Audit complete - 4 findings.

Critical:

- `C:/projects/app/UserRepository.java:47` [CODE-SEC-VALIDATE-INPUT] - SQL query built with string concatenation; user input interpolated directly into query string. → Use parameterized queries (PreparedStatement).

High:

- `C:/projects/app/OrderService.java:23` [CODE-CC-SYNC-SHARED-STATE] - Shared mutable state without synchronization; counter field modified across request threads. → Use AtomicInteger or move state into request scope.

Medium:

- `C:/projects/app/PaymentClient.java:61` [CODE-RL-IDEMPOTENCY] - Non-idempotent retry path; charge() called in retry loop with no idempotency key. → Pass a stable idempotency key so retries do not double-charge.

Low:

- `C:/projects/app/OrderService.java:89` [CODE-DX-NAMING] - Abbreviated name obscures intent; variable named `flg` with no indication of purpose. → Rename to something that expresses what the flag controls.

Summary: 1 critical, 1 high, 1 medium, 1 low
Principle source: .principles hierarchy (2 files)

Generated: C:/projects/app/audit-output.json
```

## 🔧 Extending with your own principles

Fork this repo and add a `principles/corp/` namespace (or any name) for corporate or domain-specific principles. Reference them with `CORP-0001` in your `.principles` files. See [DESIGN.md](DESIGN.md#-11-adding-a-new-namespace) for the full process.

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for requirements, process, and source guidelines.

## 📄 License

- **Principle texts:** [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) - use freely, credit required, share-alike
- **Scripts and tooling:** [MIT](https://opensource.org/licenses/MIT)
- **How to apply this in practice:** see [LICENSE-INTERPRETATION.md](LICENSE-INTERPRETATION.md) for internal use vs distribution, and what users/developers may do and must do
- **Ownership boundary:** see [LICENSE-INTERPRETATION.md](LICENSE-INTERPRETATION.md) (section 10: Ownership and curation scope)

## ☕ Support

If this project is useful to you, you can support ongoing maintenance and updates:

[![Buy Me A Coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://buymeacoffee.com/flemming.n.larsen)

If the image does not load, use this link: [Buy me a coffee](https://buymeacoffee.com/flemming.n.larsen)
