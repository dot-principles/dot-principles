# AI Agent Instructions

This is the **dot-principles** repository — a curated catalog of software engineering
principles and the tooling (`dot-scout`, `dot-audit`, `dot-prime`) that makes them
accessible to AI coding agents across all artifact types.

> **Taste your own medicine.** This repo enforces its own principles on itself.
> `.principles` files are active, Copilot review instructions are generated, and every
> AI-assisted change must pass the checks below before merging.

---

## Setup

If dot-principles tooling is not installed globally, vendor the catalog locally first:

```bash
./install.sh vendor .
```

This creates `.agents/principles-catalog/` at the repo root, which the commands below require.

---

## Documentation — keep these files current

Every change must update the relevant documentation files:

| File | When to update |
|------|----------------|
| **`README.md`** | Any user-facing change: new commands, changed install steps, new groups, changed `.principles` format |
| **`CHANGELOG.md`** | Every change — follow the existing `## [version] - YYYY-MM-DD` format; add entries under the appropriate release heading |
| **`DESIGN.md`** | Any structural or architectural change: new command phases, changes to the `.principles` hierarchy rules, principle schema changes, new artifact types |
| **`demo/presentation.md`** | Any change that affects the end-to-end user experience: new commands, changed workflow steps, new output format, updated install flow |

---

## Before any release

1. Run `dot-scout` to re-analyse this repo and refresh the generated principle files:

   ```
   /dot-scout
   ```

2. Confirm generated files are up to date and commit them:
   - `.github/instructions/*.instructions.md`
   - `REVIEW.md` (if Claude is active)
   - `.principles` files at any updated paths

3. Bump `VERSION`, update `CHANGELOG.md`, and tag the release.

---

## Before merging changes to `principles/` or `commands/`

Run `dot-audit` on the affected paths:

```
/dot-audit principles/<changed-dir>
/dot-audit commands/
```

All findings must be resolved or explicitly accepted (with rationale) before merging.

---

## Tests

Run the audit gate regression test before pushing:

```bash
./tests/check-audit-gates.sh
```

All checks must pass (exit 0). This test verifies that the interactive audit workflow
gates (Phases 8–10) are intact in all audit command files.

---

## Active principles

This repo has `.principles` files that define which principles govern AI-assisted work
here. The generated Copilot review instruction files live in `.github/instructions/`.

Run `/dot-prime` before starting any significant change to load the active rule set:

```
/dot-prime
```

The active set covers: documentation quality (`@docs`), shell script hygiene (`@source-code`), and plain-text practices (`@ptac`).
