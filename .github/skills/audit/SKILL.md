---
name: audit
description: Resolve the .principles hierarchy, load principle content, review code, and group findings by severity (Critical/High/Medium/Low). Supports explicit principle override with --with / @group / on syntax. Use this skill when asked to audit or review code against principles.
license: MIT
---

# Audit

Review a file, directory, or inline code against its activated principles in seven phases. Optionally force specific principles using explicit spec syntax.

## Phase 1 — Parse Arguments, Resolve Input, and Detect Artifact Type

### 1.1 — Parse Arguments for Explicit Principle Spec

Check `$ARGUMENTS` for an explicit principle spec using this precedence:

1. **`--with <spec>`** — if `$ARGUMENTS` contains ` --with `, extract everything after `--with ` as the spec; the text before `--with ` is the target input.
2. **`@<group>` token** — if `$ARGUMENTS` contains one or more `@`-prefixed tokens, extract all `@`-prefixed tokens as the spec (space-joined); the remaining tokens form the target input.
3. **`<spec> on <target>`** — if `$ARGUMENTS` contains ` on ` (space–on–space), split on the first occurrence: left side is the spec, right side is the target input.
4. **No spec** — treat all of `$ARGUMENTS` as the target input (normal mode).

If an explicit spec was detected, record **principle-spec** and set **explicit-mode: true**. Otherwise set **explicit-mode: false**.

### 1.2 — Resolve Input

Determine what to review from the target input resolved in 1.1:

- Empty (explicit-mode false) → respond "What would you like me to review?" and stop.
- Empty (explicit-mode true) → use the current working directory as target.
- File path → read that file.
- Directory path → recursively glob all reviewable files; exclude binaries, lock files, `node_modules`, `vendor`, `dist`, `build`, `.git`, and build artifacts.
- Inline code or text → use it directly.

### 1.3 — Detect Artifact Type

For the target file(s), detect the artifact type by reading `{{PRINCIPLES_DIRECTORY}}/layers/artifact-types.yaml` and matching against its type definitions. Match by file extension, filename, or path pattern in precedence order (infra before config for ambiguous YAML).

Record the detected type: **`code`** | **`docs`** | **`config`** | **`infra`** | **`schema`** | **`pipeline`**

If the target is a directory with mixed artifact types, note the mix; apply per-file type detection in Phase 6.

## Phase 2 — Resolve Principles

**Explicit mode (explicit-mode true):**

For each item in the `<principle-spec>` (split on commas and spaces, trim whitespace):
1. **Group match**: look for `{{PRINCIPLES_DIRECTORY}}/groups/<item-lowercase>.yaml`. If found, read it and expand its `principles` list into the active set; recursively process any `includes` (abort on cycles).
2. **Principle ID match**: if no group file matched, add the item directly to the active set (case-insensitive).
3. **No match**: report "Unknown principle or group: \<item\>. Check available groups in `{{PRINCIPLES_DIRECTORY}}/groups/`." and stop.

Record source as: `explicit: <principle-spec>`. Skip Phase 3 and proceed to Phase 4.

**Normal mode (explicit-mode false):**

### Fast Path — Check for Compiled Block

Before walking `.principles` files, check for a compiled block in this order:
1. `.claude/rules/principles.md`
2. `.ai/principles.md`
3. `AGENTS.md`
4. `.github/copilot-instructions.md`

Check the FIRST file that exists and contains `<!-- .principles: begin`. If found:

1. Parse all principle IDs from the block (lines matching `- PRINCIPLE-ID: ...` — the ID is everything before the first colon).
2. Use these as the **active principle set** — skip the `.principles` tree walk entirely.
3. Record source as: `compiled-block: <filename>`

If no compiled block is found, or if parsing fails for any reason, proceed with the tree walk below.

Walk up from the target path to the git repo root (`.git/`) or max 10 levels, collecting every `.principles` file. Order: root → target.

**If no `.principles` files found: skip to Phase 3.**

### Directives

Lines starting with `:` are configuration directives. Parse them before processing IDs:

- `:max_principles N` — cap the total number of active principles to N. When trimming to fit:
  1. Universal principles (from `artifact-types.yaml`) are **always retained**
  2. Stack layer 1 principles are **always retained**
  3. Layer 3 risk-elevated principles — next priority
  4. Layer 2 context-dependent principles — lowest priority, dropped first

### Seed — Universal + Stack Layer 1

**Step 1 — Universal principles** (active for ALL artifact types):

Read `{{PRINCIPLES_DIRECTORY}}/layers/artifact-types.yaml` → `universal` section. Add all listed IDs to the active set:

| ID | Title |
|----|-------|
| SIMPLE-DESIGN-REVEALS-INTENTION | Reveals intention |
| CODE-CS-DRY | DRY: Don't Repeat Yourself |
| CODE-CS-KISS | KISS: Keep It Simple |
| CODE-DX-NAMING | Name things by what they represent |
| ARCH-DECISION-RECORDS | Architecture Decision Records |
| CODE-CS-YAGNI | YAGNI: You Aren't Gonna Need It |

**Step 2 — Stack layer 1** (active for the detected artifact type):

Read `{{PRINCIPLES_DIRECTORY}}/layers/<detected-type>/layer-1-universal.md`. Add all principle IDs from the table in that file to the active set.

### Process Each .principles File (root → target)

1. Skip blank lines and `#` comments.
2. `:directive value` → parse as a configuration directive (see above).
3. `@group` → read `{{PRINCIPLES_DIRECTORY}}/groups/<group>.yaml`, expand `principles` into the active set; recursively process `includes` (abort on cycles).
4. Bare `ID` → add to active set (case-insensitive).
5. `!ID` → add to exclusion set.

`final_active = active_set MINUS exclusion_set` (then apply `:max_principles` cap if set) · Source: `.principles hierarchy (N files)`

## Phase 3 — Dynamic Detection (fallback)

**Only if explicit-mode is false AND Phase 2 found no `.principles` files.**

### Layer 1 — Seed

Same as Phase 2 seeding: universal principles + stack layer 1 from `{{PRINCIPLES_DIRECTORY}}/layers/<detected-type>/layer-1-universal.md`.

### Layer 2 — Context-Dependent

Read `{{PRINCIPLES_DIRECTORY}}/layers/<detected-type>/layer-2-contexts.yaml`.

Activate ALL matching contexts by scanning the target file(s) content for the signals listed in each context. For each matching context, add its `activate` principle IDs to the active set.

### Layer 3 — Risk-Elevated

Check for `{{PRINCIPLES_DIRECTORY}}/layers/<detected-type>/layer-3-risk-signals.yaml`. If present, scan the target file(s) for the signals listed in each risk category. For each matching category, add its `elevate` principle IDs to the elevated set — violations of elevated principles are promoted one severity level (Low→Medium, Medium→High, High→Critical).

Record source as: `dynamic detection (<type> stack)`

## Phase 4 — Load Principle Content

**Compiled-block fast path (source is `compiled-block: <filename>`):**

Derive unique namespaces from the active principle ID prefixes. Use the longest-prefix match from this table:

| ID prefix | Directory |
|-----------|-----------|
| `CODE-SMELLS-*` | `code-smells/` |
| `SEC-ARCH-*` | `sec-arch/` |
| `CLEAN-ARCH-*` | `clean-arch/` |
| `SIMPLE-DESIGN-*` | `simple-design/` |
| `EFFECTIVE-JAVA-*` | `effective-java/` |
| `12FACTOR-*` | `12factor/` |
| `PIPELINE-*` | `pipeline/` |
| `SEC-ARCH-*` | `sec-arch/` |
| `CODE-*` | `code/` |
| `SOLID-*` | `solid/` |
| `DDD-*` | `ddd/` |
| `GOF-*` | `gof/` |
| `GRASP-*` | `grasp/` |
| `OWASP-*` | `owasp/` |
| `EIP-*` | `eip/` |
| `FP-*` | `fp/` |
| `A11Y-*` | `a11y/` |
| `INFRA-*` | `infra/` |
| `CONFIG-*` | `config/` |
| `SCHEMA-*` | `schema/` |
| `DOCS-*` | `docs/` |
| `DB-*` | `db/` |
| `CD-*` | `cd/` |
| `ARCH-*` | `arch/` |
| `PKG-*` | `pkg/` |

For each unique namespace, read `.principles-catalog/principles/<namespace>/.context-audit.md` and filter to entries whose `### ID` is in the active set. Use the **Principle** and **Violations to detect** content in Phase 6.

If `.principles-catalog/` is not present, fall back to the standard loading below.

**Standard loading (all other sources):**

For each namespace in the active ID set, read one file:

```
{{PRINCIPLES_DIRECTORY}}/principles/<namespace>/.context-audit.md
```

Filter to entries whose `### ID` is in the final active set. Use the **Principle** and **Violations to detect** content in Phase 6.

Namespace derivation: `CODE-CS-DRY` → namespace `code`, `SOLID-SRP` → namespace `solid`, `DOC-PURPOSE` → namespace `docs`, `CONFIG-NO-HARDCODED-SECRETS` → namespace `config`, `SCHEMA-SELF-DESCRIBING` → namespace `schema`, `PIPELINE-MINIMAL-PERMISSIONS` → namespace `pipeline`.

## Phase 5 — Pre-Scan

**Output nothing during this phase.**

Run deterministic, machine-executable commands to narrow the search space before LLM reasoning.

### 5.1 — Load Inspection Patterns

For each namespace in the active ID set, check for:

```
{{PRINCIPLES_DIRECTORY}}/principles/<namespace>/.context-inspect.md
```

Filter to entries whose `### ID` is in the final active set. Each entry contains one or more commands in this format:

```
- `command` | SEVERITY_HINT | description
```

Principles with entries in `.context-inspect.md` are **"inspected"**. Principles without entries are **"semantic-only"** (handled entirely by LLM reasoning in Phase 6 Step 2).

### 5.2 — Execute Commands

For each inspection command:

1. Replace `$TARGET` with the actual path from Phase 1.
2. Run the command using bash.
3. Collect hits as: `{principle_id, severity_hint, file, line, match_text, description}`.
4. If a command produces no output or fails, skip silently.

### 5.3 — Build Pre-Scan Manifest

Group all hits by file. The result is the **pre-scan manifest** — a map of `file → [{principle_id, severity_hint, line, match_text, description}]`.

Track two sets:
- **Inspected principles** — those that had at least one command in `.context-inspect.md` (regardless of whether hits were found)
- **Semantic-only principles** — all remaining active principles

## Phase 6 — Review

**Output nothing during this phase.**

### Step 1 — Guided Review (pre-scan hits)

For each file in the pre-scan manifest:

1. Read the file (or at minimum ±10 lines around each hit).
2. For each hit, evaluate it against the principle's **Violations to detect** from Phase 4.
3. **Confirm** → record as a finding (use the severity hint as a starting point, adjust based on context; elevated → promote one level).
4. **Dismiss** → false positive, do not report.

### Step 2 — Semantic-Only Review

**Read every file** collected in Phase 1. Apply only the **semantic-only principles** (those without inspection patterns). Do not substitute grep, search, or pattern-matching tools for reading — you must read and understand each file's logic, structure, and intent.

For each file, evaluate it against the semantic-only principle set appropriate to its artifact type.

### Step 3 — Opportunistic Findings

While reading files in Steps 1 and 2, if you encounter a clear violation of **any** active principle (including inspected ones not flagged by pre-scan), record it as a finding.

### Recording Findings

For each violation found, record: principle ID, severity (Critical/High/Medium/Low, elevated → promote one level), absolute file path with forward slashes, line number, one sentence describing what is wrong, and a concrete fix grounded in the principle.

## Phase 7 — Output

**Step 1.** Write `audit-output.json` to the **repository root** (where `.git/` is) with this structure:

```json
{
  "findings": [
    {
      "severity":     "HIGH",
      "principle_id": "DOC-PURPOSE",
      "title":        "one-line description",
      "file":         "C:/absolute/path/to/file.md",
      "line":         42,
      "description":  "what is wrong",
      "fix":          "concrete fix"
    }
  ],
  "summary": {
    "critical": 0,
    "high": 1,
    "medium": 0,
    "low": 0,
    "active_principles": ["DOC-PURPOSE", "CODE-CS-DRY"],
    "principle_source": ".principles hierarchy (2 files)",
    "artifact_type": "docs"
  }
}
```

- `severity`: `CRITICAL`, `HIGH`, `MEDIUM`, or `LOW`
- `file`: absolute path, forward slashes; `""` if unavailable
- `line`: integer; `0` if unavailable
- `findings`: `[]` if no issues found
- `principle_source`: `.principles hierarchy (N files)` | `dynamic detection (<type> stack)` | `explicit: <spec>`

**Step 2.** Output a compact text report grouped by severity. Use this exact template:

```
Audit complete — {N} findings.

Critical:

- `{absolute/file.ext}:{line}` [{PRINCIPLE-ID}] — {description}. → {fix}.

High:

- `{absolute/file.ext}:{line}` [{PRINCIPLE-ID}] — {description}. → {fix}.

Medium:

- `{absolute/file.ext}:{line}` [{PRINCIPLE-ID}] — {description}. → {fix}.

Low:

- `{absolute/file.ext}:{line}` [{PRINCIPLE-ID}] — {description}. → {fix}.

Summary: {critical} critical, {high} high, {medium} medium, {low} low
Artifact type: {detected-type}
Principle source: {source}

Generated: {absolute path}/audit-output.json
```

- Group findings by severity (Critical / High / Medium / Low). Omit empty severity groups.
- Use absolute file paths with forward slashes, wrapped in backticks.
- Principle ID in brackets: `[DOC-PURPOSE]`.
- One line per finding.
- If no findings: output `Audit complete — 0 findings.` followed by the Summary and Generated lines.
