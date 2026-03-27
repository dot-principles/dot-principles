# Changelog

All notable changes to `.principles` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

> **Note:** `.principles` is in its early days — this is an experimental release. The system is being actively used and iterated on, but expect rough edges, evolving formats, and breaking changes as things stabilize.

---

## [v0.7.1] — 2026-03-28

### Changed

- **Split `code/.context-audit.md` into sub-namespace files** — the monolithic 1102-line audit context file for the `code` namespace has been split into 11 per-sub-namespace files (`code/api/`, `code/ar/`, `code/cc/`, `code/cs/`, `code/dx/`, `code/ob/`, `code/pf/`, `code/rl/`, `code/sec/`, `code/tp/`, `code/ts/`). The largest file (`code/cs/`) is now ~230 lines. This fixes "file is too large" errors during `/audit` when many `CODE-*` principles are active.
- **Split `code/.context-prime.md` into sub-namespace files** — the 1454-line prime context file was similarly split into 11 per-sub-namespace files. The same prefix table update applies to the `/prime` skill.

### Fixed

- **Namespace prefix table** — added 11 sub-namespace entries (`CODE-CS-*` → `code/cs/`, `CODE-API-*` → `code/api/`, etc.) to the longest-prefix-match table in both the audit and prime skills. `CODE-*` remains as a fallback. Updated in `targets/claude-code/audit.md`, `targets/claude-code/prime.md`, `.github/prompts/audit.prompt.md`, and `.github/prompts/prime.prompt.md`.
- **Duplicate `CODE-API-*` entries removed** — 5 API principles that were duplicated between `code/.context-audit.md` and `code/api/.context-audit.md` now exist only in `code/api/`.

---

## [v0.7.0] — 2026-03-27

### Added

- **Gated fix-to-PR workflow** (Phases 8–10) — after the read-only review (Phases 1–7), `/audit` now offers three optional gated phases that handle fix, commit, and PR creation. Each phase is a mandatory approval checkpoint — the default is always to stop and ask:
  - **Phase 8 — Fix** — asks "Would you like me to fix these findings?"; on approval creates a `fix-<target-slug>` branch, applies every finding's `fix` field, and runs existing tests.
  - **Phase 9 — Commit** — presents the commit message and PR body for review, then offers three choices: *commit only*, *commit and push*, or *exit*.
  - **Phase 10 — Pull Request** — asks "Shall I open a pull request?"; on approval creates a PR targeting the default branch with a structured body (summary, per-finding rationale, changes table).
- **Structured commit message and PR body formats** — gated workflow produces a `fix(<target>): resolve <N> audit findings (<severities>)` commit message with per-finding line items, and a PR body with severity-grouped rationale sections and a changes table.

### Changed

- **Strict state-machine semantics** — identifying issues ≠ permission to fix; fixing ≠ permission to commit; committing ≠ permission to push or open a PR. Silence, hints, context, or likely intent do not count as approval. Phases cannot be skipped, combined, or inferred.

---

## [v0.6.0] — 2026-03-24

### Added

- **`**Summary:**` field** — all 374 principle files now include a `**Summary:**` field: a one-line, actionable rule appearing after `**Applies-to:**`. Used in the compiled block and required for all new contributions (see [CONTRIBUTING.md](CONTRIBUTING.md)).
- **Compact principle index** (`index.tsv`) — `install.sh vendor` generates a pipe-delimited flat file (`ID|LAYER|SUMMARY`) of all 373 principles at `.principles-catalog/index.tsv`; `/scout` reads this single file to build the compiled block in one pass, eliminating per-namespace file walking.
- **Compiled block** — `/scout` Phase 6 compiles all active principles into a compact `<!-- .principles: begin --> … <!-- .principles: end -->` block and injects it into three targets:
  - `.claude/rules/principles.md` — created if absent; Claude Code reads this directory automatically
  - `AGENTS.md` — three-case handling: hub layout (`.ai/principles.md` created + table row added), simple layout (block injected directly), absent (file created from scratch)
  - `.github/copilot-instructions.md` — injected unless the file is a pointer/redirect file
- **`/audit` fast path** — reads compiled block (tier 1) instead of tree-walking `.principles` files; loads `.context-audit.md` per namespace (tier 2) for full guidance.
- **`/prime` fast path** — same fast path: compiled block as tier 1, `.context-prime.md` per namespace as tier 2.
- **`vendor` subcommand** — `install.sh vendor <dir>` copies the catalog subset referenced by the project's `.principles` files into `<dir>/.principles-catalog/`. Commit this directory so the compiled block and fast paths work without the full catalog repo present.
- **AGENTS.md as cross-agent injection target** — AGENTS.md is now a first-class injection target for the compiled block, enabling any agent that reads AGENTS.md (OpenAI Codex, Claude Code, Copilot, etc.) to receive the active principle set automatically.

### Changed

- **Repo-only install** — `install.sh` now requires a `<dir>` argument; global install (without `<dir>`) is no longer supported. The primary install command is `./install.sh all <project-dir>`.
- **No more `~/.principles`** — principle data is no longer copied to a global `~/.principles` directory. Commands reference `.principles-catalog/` inside the project. The `{{PRINCIPLES_DIRECTORY}}` placeholder now resolves to the project-local `.principles-catalog/`.

### Removed

- **Global install** — `./install.sh claude`, `./install.sh copilot`, and `./install.sh all` without a `<dir>` argument are no longer supported.
- **`~/.principles` data directory** — removed from the install/uninstall flow.
- **Cursor support** — Cursor is no longer a supported install target; the `.cursor/rules/principles.mdc` target has been dropped.

### Fixed

- **Uninstall** — now strips compiled blocks from `.claude/rules/principles.md`, `.ai/principles.md`, `AGENTS.md`, and `CLAUDE.md`; removes `.principles-catalog/`; removes legacy `~/.principles` if present.

---

## [v0.5.0] — 2026-03-23

### Added

- **2 new arch microservices patterns** (`arch` namespace) — `ARCH-SIDECAR` and `ARCH-DATABASE-PER-SERVICE` (both layer 2). Added to `microservices.yaml` group and `arch` context files. Sources: Burns et al. *Designing Distributed Systems* (O'Reilly, 2018); Richardson *Microservices Patterns* ISBN 978-1617294549; Newman *Building Microservices* 2nd ed. ISBN 978-1492034025.
- **1 new CD principle** (`cd` namespace) — `CD-SEMANTIC-VERSIONING` (layer 1). Added to `cd.yaml` group, `pipeline/layer-2-contexts.yaml` release context, and `cd/.context-inspect.md`. Sources: semver.org (Preston-Werner); conventionalcommits.org.
- **4 new accessibility principles** (`a11y` namespace, new) — `A11Y-ALT-TEXT`, `A11Y-SEMANTIC-HTML`, `A11Y-KEYBOARD-NAVIGATION`, `A11Y-COLOR-CONTRAST` (all layer 2; `A11Y-COLOR-CONTRAST` is `Audit-scope: limited`). New `@a11y` group, `.context-inspect.md`, `.context-prime.md`, and `.context-audit.md` created. `accessibility` context added to `layers/code/layer-2-contexts.yaml`; frontend extensions (`.html`, `.tsx`, `.jsx`, `.vue`, `.svelte`, `.css`, `.scss`, `.sass`) added to `artifact-types.yaml` code stack. Source: W3C WCAG 2.1 (SC 1.1.1, 1.3.1, 1.4.3, 1.4.11, 2.1.1, 4.1.2).
- **3 new groups** — `@pipeline` (12 principles: all PIPELINE-* and key CD-*), `@container` (10 principles: all infra container principles + pipeline security), `@schema` (5 principles: all SCHEMA-* + backward compatibility). Addresses group coverage gaps for pipeline, container/infra, and schema-heavy repos.
- **`microservices.yaml` group updated** — added 7 new EIP principles (`EIP-AGGREGATOR`, `EIP-SPLITTER`, `EIP-WIRE-TAP`, `EIP-IDEMPOTENT-CONSUMER`, `EIP-MESSAGE-TRANSLATOR`, `EIP-CONTENT-ENRICHER`, `EIP-RETURN-ADDRESS`) and 2 new arch principles (`ARCH-SIDECAR`, `ARCH-DATABASE-PER-SERVICE`).
- **6 PIPELINE-* catalog entries backfilled** — `PIPELINE-REPRODUCIBLE-BUILDS`, `PIPELINE-ENVIRONMENT-ISOLATION`, `PIPELINE-FAIL-FAST-PIPELINE`, `PIPELINE-DEPLOYMENT-GATES`, `PIPELINE-MINIMAL-PERMISSIONS`, `PIPELINE-NO-SECRETS-IN-LOGS` were present as files but absent from `catalog.yaml`; all added.
- **2 new error-handling principles** (`code/cs` namespace) — `CODE-CS-EXCEPTIONS-FOR-EXCEPTIONAL-CONDITIONS` and `CODE-CS-CATCH-SPECIFIC-EXCEPTIONS` (both layer 1). Completes the error-handling gap identified in the Tier 2 gap analysis. Sources: Bloch, *Effective Java* 3rd ed. items 69 & 73 (ISBN 978-0-13-468599-1); Martin, *Clean Code* ch. 7 (ISBN 978-0-13-235088-4). Inspection entries added to `principles/code/.context-inspect.md`.
- **New `@docs-as-code` group** — focused profile for repos where documentation is versioned alongside code and built in CI (MkDocs, Docusaurus, Antora). Contains 7 principles: `DOC-AS-CODE`, `DOC-CLOSE-TO-CODE`, `DOC-UNIQUE`, `DOC-ADDRESSABLE`, `ARCH-DECISION-RECORDS`, `CODE-CS-DRY`, `PIPELINE-REPRODUCIBLE-BUILDS`. Distinct from the full `@docs` group, which covers writing-quality principles.

---

## [v0.4.0] — 2026-03-22

### Added

- **7 new EIP principles** (`eip` namespace, 5 → 12) — `EIP-AGGREGATOR`, `EIP-SPLITTER`, `EIP-WIRE-TAP`, `EIP-IDEMPOTENT-CONSUMER`, `EIP-MESSAGE-TRANSLATOR`, `EIP-CONTENT-ENRICHER`, `EIP-RETURN-ADDRESS` (all layer 2). Source: Hohpe & Woolf, *Enterprise Integration Patterns*, ISBN 978-0321200686.
- **4 new code smell principles** (`code-smells` namespace, 18 → 22) — `CODE-SMELLS-LAZY-ELEMENT`, `CODE-SMELLS-MIDDLE-MAN`, `CODE-SMELLS-MUTABLE-DATA`, `CODE-SMELLS-LOOPS` (`Audit-scope: limited`). Completes all 22 Fowler 1st-edition smells plus 2 additions from the 2nd edition. Source: Fowler, *Refactoring* 2nd ed., ISBN 978-0-13-475759-9.
- **4 new container / Dockerfile principles** (`infra` namespace) — `INFRA-NON-ROOT-CONTAINER`, `INFRA-PIN-BASE-IMAGES`, `INFRA-MINIMIZE-IMAGE-LAYERS`, `INFRA-NO-SECRETS-IN-IMAGE` (all layer 1, with inspection). Added to `security-focused` group and `layers/infra/layer-2-contexts.yaml` containers context. Sources: CIS Docker Benchmark v1.6.0, OWASP Docker Security Cheat Sheet, Docker Dockerfile best practices, OpenSSF SLSA v1.0.
- **5 new security architecture principles** (`sec-arch` namespace) — `SEC-ARCH-ECONOMY-OF-MECHANISM`, `SEC-ARCH-SEPARATION-OF-PRIVILEGE`, `SEC-ARCH-LEAST-COMMON-MECHANISM`, `SEC-ARCH-OPEN-DESIGN` (all with inspection), `SEC-ARCH-PSYCHOLOGICAL-ACCEPTABILITY` (`Audit-scope: limited`). Completes all 8 Saltzer & Schroeder (1975) principles. Source: DOI 10.1109/PROC.1975.9939.
- **3 new schema design principles** (`schema` namespace, 1 → 4) — `SCHEMA-FIELD-OPTIONALITY`, `SCHEMA-NO-POLYMORPHIC-BLOBS`, `SCHEMA-ENUM-EVOLUTION` (all layer 1, with inspection). New `avro` context in `layers/schema/layer-2-contexts.yaml`. Sources: proto3 guide, Avro spec 1.11.1, Kleppmann ISBN 978-1-449-37332-0.
- **4 new pipeline principles** (`pipeline` namespace, 2 → 6) — `PIPELINE-REPRODUCIBLE-BUILDS`, `PIPELINE-ENVIRONMENT-ISOLATION`, `PIPELINE-FAIL-FAST-PIPELINE` (layer 1), `PIPELINE-DEPLOYMENT-GATES` (layer 2); all with inspection. Sources: Humble & Farley ISBN 978-0-321-60191-9, OpenSSF SLSA v1.0, Forsgren et al. ISBN 978-1-942788-33-1.
- **6 new configuration principles** (`config` namespace, 2 → 8) — `CONFIG-SCHEMA-FIRST`, `CONFIG-EXPLICIT-OVER-CONVENTIONAL`, `CONFIG-ENVIRONMENT-PARITY`, `CONFIG-EXPLICIT-DEFAULTS` (layer 1), `CONFIG-CHANGE-TRACEABILITY`, `CONFIG-MINIMAL-SURFACE` (layer 2, with inspection). Layer and context files updated.
- **8 new documentation principles** (`docs` namespace) — `DOC-AS-CODE`, `DOC-CLOSE-TO-CODE`, `DOC-UNIQUE`, `DOC-TASK-ORIENTED`, `DOC-SCANNABLE`, `DOC-OBJECTIVE`, `DOC-SELF-CONTAINED`, `DOC-ADDRESSABLE`. Sources: Gentle ISBN 978-1365418730, Martraire ISBN 978-0134689326, Baker ISBN 978-1937434281, NN/G 1997, and others.
- **8 new API design principles** (`code/api` namespace) — `CODE-API-RATE-LIMITING`, `CODE-API-PROBLEM-DETAILS`, `CODE-API-PAGINATION`, `CODE-API-HTTP-CACHING`, `CODE-API-CONDITIONAL-REQUESTS`, `CODE-API-CONTENT-NEGOTIATION`, `CODE-API-API-VERSIONING`, `CODE-API-GRPC-PROTOBUF` (most with inspection). Sources: RFC 6585, 7807/9457, 9111, 7232, 7231/9110, 8594; Richardson & Ruby; Google API Design Guide.
- **`REJECTED.md`** — new file logging considered-but-rejected candidates with rationale.
- **New `.context-inspect.md` files** for `infra`, `pipeline`, `schema`, and `sec-arch` namespaces; `code/api` inspect file created.
- **Context and layer files updated** across all 9 affected namespaces (`eip`, `code-smells`, `infra`, `sec-arch`, `schema`, `pipeline`, `config`, `docs`, `code/api`).

### Fixed

- **Missing catalog entries backfilled** — `eip` (5 principles), `code-smells` (9 principles), and `SCHEMA-SELF-DESCRIBING` were present as files but absent from `catalog.yaml`; all added.

---

## [v0.3.2] — 2026-03-22

### Changed

- **`/audit` explicit principle override** — `/audit` now accepts an explicit principle spec to force a specific principle set, bypassing `.principles` files and dynamic detection entirely. Three equivalent syntaxes are supported:
  - `<spec> on <target>` — natural language: `/audit DDD on src/orders`
  - `<target> --with <spec>` — flag syntax: `/audit src/orders --with DDD`
  - `@<group> <target>` — group-prefix syntax: `/audit @ddd src/orders`
  - Multiple groups supported comma-separated: `/audit clean-arch, solid on src/`
  - `principle_source` in `audit-output.json` reports `explicit: <spec>` when override is active.

---

## [v0.3.1] — 2026-03-19

### Added

- **Version metadata in command frontmatter** — `/audit`, `/prime`, and `/scout` source files now carry `version`, `description`, `argument-hint`, and `authors` fields in YAML frontmatter, stamped at install time from `VERSION`.

### Fixed

- **Copilot CLI global skills management** — `install.sh` and `uninstall.sh` now correctly create, update, and remove `~/.copilot/skills/<name>/SKILL.md` entries for global Copilot CLI installations.

---

## [v0.3.0] — 2026-03-18

### Changed

- **Artifact-type layer system** — `layers/artifact-types.yaml` classifies every reviewed file into one of 6 stacks (`code`, `docs`, `config`, `infra`, `pipeline`, `schema`), each with its own `layer-1-universal.md` and `layer-2-contexts.yaml` (plus `layer-3-risk-signals.yaml` for `code` and `infra`). A shared universal set of 6 principles (`SIMPLE-DESIGN-REVEALS-INTENTION`, `CODE-CS-DRY`, `CODE-CS-KISS`, `CODE-CS-YAGNI`, `CODE-DX-NAMING`, `ARCH-DECISION-RECORDS`) applies across all stacks; stack-specific layers add targeted principles on top. Type detection uses file extension, filename, and path-pattern signals, with `infra` evaluated before `config` to resolve ambiguous YAML files (e.g. `Chart.yaml`, `values.yaml`).

### Added

- **11 new continuous delivery principles** in new `cd` namespace — `CD-TRUNK-BASED-DEVELOPMENT`, `CD-KEEP-BUILD-GREEN` (with inspection), `CD-DEPLOY-ON-EVERY-COMMIT`, `CD-FEATURE-FLAGS` (with inspection), `CD-FAST-FEEDBACK-LOOPS`, `CD-GITOPS`, `CD-BLUE-GREEN-DEPLOYMENT`, `CD-CANARY-RELEASE`, `CD-DEPLOYMENT-SMOKE-TESTS`, `CD-PIPELINE-AS-CODE` (with inspection), `CD-BUILD-ONCE-DEPLOY-MANY` (with inspection). New `groups/cd.yaml`, catalog, and context files created.
- **24 new architecture and integration principles** — 15 in `arch` namespace (Hexagonal Architecture, Saga, Strangler Fig, Layered Architecture, Microkernel, Anti-Corruption Layer, BFF, Bulkhead, Service Layer, Unit of Work, MVC, API Gateway, Data Mapper, Active Record, Transaction Script); 4 DDD strategic patterns in `ddd` namespace (Context Map, Shared Kernel, Open Host Service, Published Language); 5 Enterprise Integration Patterns in new `eip` namespace (Correlation Identifier, Content-Based Router, Dead Letter Channel, Message Filter, Claim Check). `eip` catalog, context, and group files created. `groups/microservices.yaml` and `groups/ddd.yaml` updated.
- **7 new observability principles** in `code/ob` — USE Method (Gregg), RED Method (Wilkie), Error Budget burn-rate alerting (with inspection), Four Golden Signals, Health Check API — Richardson (with inspection), Percentile-based latency (Dean & Barroso), Alert on symptoms not causes. `groups/microservices.yaml`, context files, and `catalog.yaml` (242 principles) updated.
- **7 new testing principles** in `code/ts` — Test Data Builder, Humble Object, No Test Logic in Production (with inspection), Characterization Tests (`Audit-scope: limited`), Test Pyramid, Consumer-Driven Contracts, Property-Based Testing.
- **Audit-scope metadata** — `principles/AUDIT-SCOPE.md` added; 8 principle files annotated (4 excluded, 4 limited).
- **`CONTRIBUTING.md`** — code auditability and no-redundancy requirements added.
- **`principles/TEMPLATE.md`** — optional `**Audit-scope:**` field documented.

---

## [v0.2.0] — 2026-03-17

### Changed

- **Installer copies principle data to `~/.principles`** — created on install, refreshed on every run; `{{PRINCIPLES_DIRECTORY}}` placeholder substituted at install time in command files. Global uninstall removes `~/.principles`; local uninstalls leave it intact.

### Added

- **14 new database principles** in new `db` namespace — `DB-ACID`, `DB-SCHEMA-MIGRATIONS-AS-CODE`, `DB-CAP-THEOREM`, `DB-AVOID-N-PLUS-ONE` (with inspection), `DB-INDEX-FOR-ACCESS-PATTERNS`, `DB-THIRD-NORMAL-FORM`, `DB-CQRS`, `DB-OUTBOX-PATTERN`, `DB-EVENTUAL-CONSISTENCY`, `DB-EVENT-SOURCING`, `DB-OPTIMISTIC-CONCURRENCY`, `DB-TWO-PHASE-LOCKING`, `DB-POLYGLOT-PERSISTENCE`, `DB-DENORMALIZE-INTENTIONALLY`. New `@db` group and context files.
- **7 new security principles** — 4 in `code/sec` (`DEFENSE-IN-DEPTH`, `FAIL-SAFE-DEFAULTS` with inspection, `COMPLETE-MEDIATION`, `PRIVACY-BY-DESIGN`) and 3 in new `sec-arch` namespace (`THREAT-MODELLING`, `ZERO-TRUST`, `SUPPLY-CHAIN-SECURITY` with inspection). `groups/security-focused.yaml` updated.
- **27 new OOP/object-design principles** — `pkg` namespace (6 Package Principles, Martin); `gof` additions (Law of Demeter, Null Object); `code/cs` additions (Design by Contract, Tell Don't Ask, Information Hiding, Uniform Access); 9 Fowler code smells; 5 Effective Java items; `DDD-SPECIFICATION`.
- **20 functional programming principles** in new `fp` namespace — 4 universal (pure functions, referential transparency, immutability, no shared mutable state), 16 contextual. New `@fp` group and 11 new language groups (`@javascript`, `@swift`, `@ruby`, `@php`, `@scala`, `@cpp`, `@c`, `@dart`, `@elixir`, `@haskell`, `@fsharp`).

---

## [v0.1.0] — 2026-03-15

**Initial release.**

### Highlights

- **187 principle files** across **13 top-level namespaces** — `12factor`, `arch`, `clean-arch`, `code`, `code-smells`, `ddd`, `effective-java`, `gof`, `grasp`, `infra`, `owasp`, `simple-design`, `solid`
- **30 pre-defined groups** — `@spring-boot`, `@react`, `@angular`, `@django`, `@fastapi`, `@microservices`, `@security-focused`, `@clean-arch`, `@solid`, `@typescript`, and more
- **3 AI commands** — `/scout`, `/prime`, `/audit`
- **3-layer model** — Universal, Contextual, and Risk-Elevated principles
- **Hierarchical `.principles` file resolution** — project-level overrides with inheritance
- **Cross-platform installer** — Bash, PowerShell, and CMD wrapper scripts
- **3 target platforms** — Claude Code, GitHub Copilot, Cursor
- **Full documentation suite** — README, DESIGN.md, INSTALL.md, REQUIREMENTS.md, and more
- **Inspection sections** — `.context-inspect.md` files and inline `## Inspection` sections with `grep` patterns for automated principle verification across `code/` and `solid/` namespaces
- **Improved catalog** — restructured `principles/catalog.yaml` with expanded metadata
- **Enhanced audit command** — richer inspection-driven audit flow in `targets/claude-code/audit.md`
- **CONTRIBUTING.md** — contributor guidelines added
- **Layer refinements** — updated universal layer, context mappings, and risk signals

### What's Next

See [TODO.md](TODO.md) for the roadmap.

---

[v0.7.0]: https://github.com/dot-principles/dot-principles/releases/tag/v0.7.0
[v0.6.0]: https://github.com/dot-principles/dot-principles/releases/tag/v0.6.0
[v0.5.0]: https://github.com/dot-principles/dot-principles/releases/tag/v0.5.0
[v0.4.0]: https://github.com/dot-principles/dot-principles/releases/tag/v0.4.0
[v0.3.2]: https://github.com/dot-principles/dot-principles/releases/tag/v0.3.2
[v0.3.1]: https://github.com/dot-principles/dot-principles/releases/tag/v0.3.1
[v0.3.0]: https://github.com/dot-principles/principles/releases/tag/v0.3.0
[v0.2.0]: https://github.com/dot-principles/principles/releases/tag/v0.2.0
[v0.1.0]: https://github.com/dot-principles/principles/releases/tag/v0.1.0
