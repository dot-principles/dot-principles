---
name: scout
description: Analyse a project to detect which principles apply and create or update .principles files encoding that analysis. Use when the user runs /dot-scout [path] to map principles to a codebase.
argument-hint: "[directory-path]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
version: 0.8.1
authors: Flemming N. Larsen (https://github.com/flemming-n-larsen)
license: MIT
---

Codex note:
- Treat `$ARGUMENTS` below as the user's request text after invoking this skill.
- References to `/dot-scout`, `/dot-prime`, and `/dot-audit` map to `$dot-scout`, `$dot-prime`, and `$dot-audit` in Codex.


# Scout

You are analysing a project to determine which principles apply and creating or updating `.principles` files to encode that. Follow these six phases exactly.

## Phase 1 — Resolve Target and Bootstrap Catalog

Determine the target directory:

- If `$ARGUMENTS` is a **directory path**: use it as the target.
- If `$ARGUMENTS` is **empty**: use the current working directory.
- If `$ARGUMENTS` is a **file path**: use its containing directory.

Confirm the target exists. If not, report an error and stop.

Walk up from the target to find the **git root** (directory containing `.git/`). Record both the target directory and the git root — the hierarchy spans between them.

### 1.1 — Bootstrap Catalog

Check whether `.principles-catalog/index.tsv` exists at the git root.

If **not present**, try to auto-vendor it now (before any other phase):

1. Search for the dot-principles `install.sh` in these locations (in order):
   - `<git-root>/../dot-principles/install.sh`
   - `<git-root>/../../dot-principles/dot-principles/install.sh`
   - `~/Code/dot-principles/dot-principles/install.sh`
   - Run: `find ~ -maxdepth 5 -name "install.sh" -path "*/dot-principles/*" 2>/dev/null | head -1`

2. If found: run `<path-to-install.sh> vendor <git-root>` and report:
   > "✓ Catalog vendored to .principles-catalog/ — proceeding."

3. If not found: report:
   > "⚠️ `.principles-catalog/` not found. Group lookups will use the hardcoded catalog below."
   > "  To vendor: clone dot-principles and run `./install.sh vendor <git-root>`"
   > Continue using the hardcoded group list in Phase 3 (custom groups won't be available).

Record whether the catalog is available: **catalog-available: true/false**

## Phase 2 — Detect Profile

Analyse the target directory (and subdirectories) to build a profile per directory. For each directory, detect:

### Code artifact signals

| Signal | Language / Framework |
|--------|---------------------|
| `*.java`, `pom.xml`, `build.gradle` | Java |
| `*.ts`, `tsconfig.json` | TypeScript |
| `*.py`, `pyproject.toml`, `requirements.txt` | Python |
| `*.go`, `go.mod` | Go |
| `*.cs`, `*.csproj`, `*.sln` | C# |
| `*.rs`, `Cargo.toml` | Rust |
| `*.rb`, `Gemfile` | Ruby |
| `*.php`, `composer.json` | PHP |
| `@SpringBootApplication`, `spring-boot` in build file | Spring Boot |
| `@Entity`, `spring-data-jpa` dependency | Spring Data JPA |
| `react`, `jsx`, `tsx` imports | React |
| `@NgModule`, `@Component` | Angular |
| `django` in requirements | Django |
| `fastapi` import | FastAPI |
| `express` in package.json | Express |

### Domain signals (for code artifact type)

| Signal | Domain |
|--------|--------|
| `payment`, `billing`, `invoice`, `stripe`, `checkout` | Financial |
| `auth`, `login`, `oauth`, `jwt`, `session` | Authentication |
| `user`, `profile`, `email`, `address`, `PII` | Personal data |
| `microservice`, `service-mesh`, `saga` | Distributed systems |

### Non-code artifact type signals

| Directory / files | Artifact type | Group |
|-------------------|---------------|-------|
| `docs/`, `*.md` files (README, DESIGN, ADR, CONTRIBUTING) | docs | `@docs` |
| `.github/workflows/`, `Jenkinsfile`, `*.gitlab-ci.yml`, `azure-pipelines.yml` | pipeline | `@pipeline` |
| `*.tf`, `*.tfvars`, `Dockerfile`, `docker-compose.*`, `Chart.yaml`, `k8s/`, `infra/`, `terraform/` | infra | `@infra` |
| `*.proto`, `*.graphql`, `openapi.yaml`, `swagger.yaml`, `schema.sql` | schema | `@schema` |
| `.env`, `application.yaml`, `appsettings.json`, `*.properties` | config | `@config` |

### Per-directory profiling

For projects with multiple subdirectories, detect profiles per directory:
- `src/main/` vs `src/test/` — different testing principles for test dirs
- `src/security/`, `src/auth/` — security-focused principles
- `frontend/`, `ui/`, `web/` — UI interaction principles
- `docs/`, `doc/` — documentation principles (`@docs`)
- `infra/`, `terraform/`, `k8s/`, `deploy/` — infrastructure principles (`@infra`)
- `.github/workflows/` — pipeline principles (`@pipeline`)

Record a profile map: `{ directory → [detected groups] }`

## Phase 3 — Propose .principles Placements

Based on the profile map from Phase 2, propose where to place `.principles` files and what to put in each.

### Placement strategy

1. **Git root `.principles`**: Activate groups that apply to the whole project
2. **Subdirectory `.principles`**: Activate additional groups or exclude principles that don't apply to that subtree

### Available groups (from `.principles-catalog/groups/`)

Reference these groups by their filename (without `.yaml`):

**Language groups:** `java`, `typescript`, `python`, `go`, `csharp`, `rust`
**Framework groups:** `spring-boot`, `spring-data-jpa`, `react`, `angular`, `django`, `fastapi`
**Cross-cutting code groups:** `microservices`, `security-focused`
**Artifact-type groups:** `docs`, `infra`, `config`, `schema`, `pipeline`

Also list any custom groups found in `.principles-catalog/groups/` that aren't listed above.

### Proposal format

For each proposed file, show:
```
[path]/.principles
  @group1          ← reason
  @group2          ← reason
  CODE-OB-SERVICE-LEVEL-OBJECTIVES      ← specific principle for this directory
  !CODE-TS-TEST-FIRST     ← exclusion and why
```

Ask for confirmation before writing: "I propose creating/updating N .principles files. Proceed? (yes to write, no to review proposals)"

Wait for user confirmation. If the user says no or requests changes, adjust proposals and ask again.

## Phase 4 — Check Existing .principles Files

Before writing, check for existing `.principles` files at the proposed paths.

For each existing file:
- Read its current contents
- Preserve all existing entries (including `!exclusions` and comments)
- Only **add** new entries that aren't already present
- **Never remove** existing entries — that is the human's decision
- If the file already has all proposed additions, mark it as **unchanged**

Determine final action per file: `created` | `updated` | `unchanged`

## Phase 5 — Write Files and Report

Write or update each file as determined in Phase 4.

### File format

```
# Generated by /dot-scout
# Detected: [artifact-type] / [language/framework/domain]
# Last analysed: [date]

@group1
@group2

# Direct includes
CODE-OB-SERVICE-LEVEL-OBJECTIVES
```

Do not add comments to lines that were already present in an existing file — only add comments to newly added entries.

### Report

After writing, output:

```
.principles analysis complete

Files written:
  ✓ created   /path/to/.principles         (@spring-boot, @security-focused)
  ✓ created   /path/to/docs/.principles    (@docs)
  ✓ updated   /path/to/src/.principles     (added @react)
  — unchanged /path/to/infra/.principles   (no changes needed)

Active groups resolved:
  @spring-boot → @java, CODE-API-STANDARD-HTTP-METHODS, DDD-REPOSITORY, OWASP-03-INJECTION ... (N principles)
  @docs → DOC-PURPOSE, DOC-MINIMAL, DOC-AUDIENCE, DOC-ACCURACY, DOC-EXAMPLES, DOC-PROGRESSIVE-DISCLOSURE ... (N principles)

Next steps:
  - Run /dot-prime to activate principles before writing
  - Run /dot-audit <target> to review against these principles
  - Edit .principles files manually to add !exclusions or direct principle IDs
```

## Phase 6 — Emit AI Review Integration Files

### 6.0 — Detect AI Tools

Scan the git root for signals that indicate which AI coding/review tools are active.

**Copilot detection** — any match = Copilot active:
- `.github/copilot-instructions.md` exists
- `.github/copilot-setup-steps.yml` exists
- Any `.github/instructions/*.instructions.md` file exists (previous /dot-scout run)

**Claude detection** — any match = Claude active:
- `CLAUDE.md` exists at git root
- `.claude/` directory exists
- `REVIEW.md` exists at git root (previous /dot-scout run)

After detection, present findings and ask:

> AI tool detection:
>   Copilot: ✓ / ✗ (signal found)
>   Claude:  ✓ / ✗ (signal found)
>
> Generate review instruction files for detected tools? (yes / no / select)

- **yes** → proceed with all detected tools
- **no** → skip rest of Phase 6
- **select** → let user pick which tools to generate for

Record: **copilot-active: true/false**, **claude-active: true/false**

### 6.1 — Resolve the Active Set

If **catalog-available: false** (set in Phase 1), report:
> "⚠️ Per-group files skipped — catalog not available. Run `./install.sh vendor <git-root>` and re-run /dot-scout."
> Skip the rest of Phase 6.

Read `.principles-catalog/index.tsv`. Each line is `ID|LAYER|SUMMARY`.

From the active principle set (resolved via `.principles` hierarchy), look up each active ID in the index to get its Layer and Summary.

For each active `@group`, read `.principles-catalog/groups/<name>.yaml` and note:
- The group's `principles:` list (filtered to only IDs in the active set, after `!exclusions`)
- The group's `globs:` list. If the group has `includes:`, recursively union any **explicitly declared** `globs:` from included groups (groups with no `globs:` field contribute nothing — do not default them to `**/*` here). Only after this union is complete, if the result is still empty, default to `["**/*"]`.

Any active IDs not found in index.tsv: include with summary "—" and log a warning.

### 6.2 — Clean Stale Files

Scan for files that contain the marker `<!-- generated by /dot-scout`:

**`.github/instructions/`:**
- If **copilot-active is false**: delete ALL scout-generated files in this directory
- If **copilot-active is true**: delete only files whose group is not in the current active set
- If file is `principles-core.instructions.md` and copilot-active is true: keep it (will be overwritten in 6.3)

**`REVIEW.md` at git root:**
- If **claude-active is false** and the file has the scout marker: delete it

Files **without** the `<!-- generated by /dot-scout` marker are user-created — never touch them.

### 6.3 — Emit Copilot Instruction Files

**Skip entirely if copilot-active is false.**

Create directory `.github/instructions/` if it does not exist.

**For each active `@group`:**

Build the file content first, then enforce the **4,000 character limit** (Copilot Code Review truncates beyond this):

```markdown
<!-- generated by /dot-scout vVERSION — do not edit manually, re-run /dot-scout to refresh -->
---
applyTo:
  - "**/*.java"
---
# Group Name Principles

- PRINCIPLE-ID: Summary text here
- PRINCIPLE-ID: Summary text here
```

**4k char enforcement:** After building the content for a group:
- If content ≤ 4,000 chars → write as `.github/instructions/<group>.instructions.md`
- If content > 4,000 chars → split into numbered files (`<group>-1.instructions.md`, `<group>-2.instructions.md`, …), each ≤ 4,000 chars. Split at principle-line boundaries (never mid-line). Each split file gets its own complete frontmatter header and `<!-- generated by /dot-scout` marker.

Rules:
- VERSION from `.principles-catalog/` or the repo's VERSION file
- The `applyTo:` values come from the group's resolved `globs:` (union of own + explicitly declared includes' globs; defaults to `**/*` only if none found)
- Only include principles that are in the active set (post-exclusion)
- Keep summaries on one line: `- ID: Summary`
- The `# Group Name Principles` heading uses the group's `name:` field from the YAML, title-cased

**Core principles file:**

Write `principles-core.instructions.md` (apply 4k splitting if needed) with `applyTo: "**/*"` containing:
- All Layer 1 universal principles (from `.principles-catalog/layers/artifact-types.yaml` → `universal:`)
- All stack Layer 1 principles (from `.principles-catalog/layers/<detected-stack>/layer-1-universal.md`)
- Any bare principle IDs from `.principles` files that do not belong to any active `@group`

### 6.4 — Emit REVIEW.md for Claude Code Review

**Skip entirely if claude-active is false.**

Generate a single `REVIEW.md` at the git root. Budget: **~10,000 characters / ~150 instructions max.**

```markdown
<!-- generated by /dot-scout vVERSION — do not edit manually, re-run /dot-scout to refresh -->
# Code Review Rules

## Critical — Always flag these

- PRINCIPLE-ID: Summary text here

## Important — Flag when violated

- PRINCIPLE-ID: Summary text here

## Style — Flag as nits

- PRINCIPLE-ID: Summary text here
```

**Priority ordering** (fill from top; if over budget, truncate from the bottom of Style upward):

1. **Critical section:** Security principles (OWASP-\*, CODE-SEC-\*), fail-fast and error handling (CODE-CS-FAIL-FAST, CODE-RL-\*)
2. **Important section:** Domain principles (DDD-\*, EIP-\*), architecture (SOLID-\*, CLEAN-ARCH-\*, ARCH-\*), observability (CODE-OB-\*)
3. **Style section:** Code quality (CODE-DX-\*, CODE-CS-\*), framework-specific (EFFECTIVE-JAVA-\*, spring-specific)

### 6.5 — Report

After writing, output:

```
AI tool integration:
  Copilot detected: ✓ / ✗ (signal)
  Claude detected:  ✓ / ✗ (signal)

Files written:
  ✓ .github/instructions/ddd.instructions.md               (13 principles, **/*.java, 1877 chars)
  ✓ .github/instructions/microservices-1.instructions.md    (20 principles, **/*.java, 3998 chars)
  ✓ .github/instructions/microservices-2.instructions.md    (16 principles, **/*.java, 3549 chars)
  ✓ .github/instructions/principles-core.instructions.md    (29 principles, **/*,      3200 chars)
  ✓ REVIEW.md                                               (87 principles, 9.2k chars)

Cleaned:
  ✗ deleted .github/instructions/old-group.instructions.md  (group removed)

Tip: commit .principles-catalog/ so CI and PR bots can use it without local install.
```
