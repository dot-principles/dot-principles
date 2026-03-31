# .principles

[![License: MIT](https://img.shields.io/badge/tooling-MIT-green.svg)](https://opensource.org/licenses/MIT) [![License: CC BY-SA 4.0](https://img.shields.io/badge/principles-CC%20BY--SA%204.0-blue.svg)](https://creativecommons.org/licenses/by-sa/4.0/)

**Select the engineering principles you want your AI agent to apply — for code, docs, infrastructure, configuration, schemas, and pipelines.**

A curated catalog of engineering principles, organized into a `.principles` hierarchy that projects declare to guide AI-assisted work across all "X as Code" artifact types.

> See [DISCLAIMER.md](DISCLAIMER.md) — this is a proof of concept. Groups are opinionated, gaps exist, and adjustments are expected.

---

## 💡 Why `.principles`?

> *"The AI already knows everything. The question is: does it know what **you** care about?"*

In 2026, AI agents are genuinely impressive. Ask one to review your code and it will draw on a vast body of established software engineering knowledge:

- 🏗️ **Design** — SOLID, Gang of Four (Strategy, Observer, Factory, Decorator…), GRASP, DRY, KISS, YAGNI, Clean Code, Kent Beck's 4 Rules of Simple Design
- 🏛️ **Architecture** — Clean Architecture, Hexagonal / Ports & Adapters, DDD (Aggregates, Bounded Contexts, Repositories, Anti-Corruption Layers), CQRS, Event Sourcing, Microservices patterns, 12-Factor App
- 🔐 **Security** — OWASP Top 10, defense-in-depth, least privilege, zero-trust, secrets hygiene, secure-by-default
- ⚡ **Reliability & Performance** — circuit breakers, bulkhead, idempotency, backpressure, caching strategies, connection pooling, database indexing
- 🧪 **Testing** — test pyramid, TDD, BDD, contract testing, property-based testing, mutation testing
- ☁️ **Infrastructure** — Infrastructure as Code, immutable infrastructure, GitOps, Kubernetes patterns, observability (logs, metrics, traces)

**Knowing all of this is not the same as knowing which of it to apply.**

When an AI agent opens your file and starts writing or reviewing code — it doesn't automatically know:

- Should it scrutinize **security** here? *(Is this a payment handler or a helper utility?)*
- Should **DDD aggregates** guide this design? *(Is this a rich domain model or a thin CRUD layer?)*
- Is **backward compatibility** a hard constraint? *(Is this a public API or an internal module?)*
- Should **concurrency principles** be front-of-mind? *(Is this code on a hot, multi-threaded path?)*

Without that context, the AI picks reasonable defaults. But *reasonable defaults are not your architecture*.

**`.principles` is the bridge between what the AI knows and what it should focus on.** It doesn't teach the AI — it gives it your *intent*. And this applies not just to source code, but to any artifact type treated as code: docs, infrastructure, configuration, schemas, pipelines.

---

### 🌳 A codebase is a tree of different worlds

A real project is rarely uniform. A monorepo typically contains multiple sub-trees with entirely different stacks, concerns, and risk profiles. The `.principles` hierarchy maps directly onto that structure — just like `.gitignore`, rules cascade from the root and subdirectories can **add, narrow, or suppress**:

```
my-project/
├── .principles                    ◄ 🌐 @microservices + @security-focused
│
├── backend/
│   ├── .principles                ◄ ☕ @spring-boot  (Java · REST · DDD)
│   └── src/
│       └── payments/
│           └── .principles        ◄ 💳 CODE-RL-IDEMPOTENCY  (payment-specific scrutiny)
│
├── frontend/
│   ├── .principles                ◄ ⚛️  @react + @typescript
│   └── src/
│
├── infra/
│   └── .principles                ◄ 🏗️  CODE-AR-INFRASTRUCTURE-AS-CODE + CODE-AR-IMMUTABLE-INFRASTRUCTURE
│
└── docs/
    └── .principles                ◄ 📝 (minimal — no security scanning in prose)
```

The `backend/` team gets Spring Boot + DDD focus. The `frontend/` team gets React + TypeScript patterns. The `payments/` service gets extra idempotency scrutiny on top of everything above it. The resolution walks **up** from the file being reviewed to the git root, merging files as it goes — innermost wins:

```mermaid
flowchart LR
    A["payments/.principles<br>CODE-RL-IDEMPOTENCY"]
    B["backend/.principles<br>@spring-boot"]
    C[".principles (root)<br>@microservices<br>@security-focused"]
    D["🔀 Merge<br>innermost wins"]
    E["📚 Load full principle<br>content from catalog"]
    F["🤖 AI agent<br>focused & ready"]

    A --> D
    B --> D
    C --> D
    D --> E
    E --> F
```

---

### 🤖 Let the AI scout your project

You don't need to figure out which principles apply yourself. The `scout` workflow analyzes your file structure, proposes `.principles` placements, and then writes them after your confirmation. In Claude and Copilot you invoke it as `/scout`; in Codex you invoke it as `$scout`. It also emits per-group principle files to `.github/instructions/` and `.claude/rules/` — one file per active group, each targeting only the relevant file types:

```
/scout

→ Analyzing file structure and detecting stack...
→ Detected: Spring Boot backend · React frontend · Terraform infra · Payment domain
→ Writing .principles            → @microservices + @security-focused
→ Writing backend/.principles   → @spring-boot
→ Writing frontend/.principles  → @react + @typescript
→ Writing infra/.principles     → CODE-AR-INFRASTRUCTURE-AS-CODE + CODE-AR-IMMUTABLE-INFRASTRUCTURE
→ Writing backend/src/payments/.principles → CODE-RL-IDEMPOTENCY
→ Emitting per-group files to .github/instructions/ and .claude/rules/...
→   ✓ .github/instructions/spring-boot.instructions.md   (20 principles, **/*.java)
→   ✓ .github/instructions/react.instructions.md          (18 principles, **/*.tsx, **/*.ts)
→   ✓ .github/instructions/container.instructions.md      (10 principles, Dockerfile, **/*.yaml)
→   ✓ .claude/rules/spring-boot.md                        (20 principles, **/*.java)
→   ... (14 files total)

Done ✅  Run `/prime` (or `$prime` in Codex) before your next coding session.
```

Of course you can also write these files manually — the format is just plain text.

---

### 🗂️ Not just code — review any artifact

`.principles` started as a code review tool, but a codebase is more than source files. READMEs, architecture docs, Terraform modules, GitHub Actions workflows, Protobuf schemas — these are all plain text in version control, and they all benefit from principled review.

The system detects the artifact type of the file being reviewed and selects the right stack of principles automatically:

| Artifact type | Examples | Principles |
|---|---|---|
| **Code** | `.java`, `.ts`, `.py`, `.go`, … | SOLID, GoF, fail-fast, input validation, DDD, concurrency, … |
| **Docs** | `README.md`, `DESIGN.md`, `ADR-*.md`, … | DOC-PURPOSE, DOC-MINIMAL, DOC-AUDIENCE, DOC-ACCURACY, … |
| **Config** | `.env`, `application.yaml`, `appsettings.json`, … | 12FACTOR-03, no hardcoded secrets, schema validation, … |
| **Infra** | `.tf`, `Dockerfile`, `Chart.yaml`, … | IaC, immutable infra, idempotency, composable modules, … |
| **Schema** | `.proto`, `.graphql`, `openapi.yaml`, `schema.sql`, … | Backward compatibility, self-describing, consistent naming, … |
| **Pipeline** | `.github/workflows/`, `Jenkinsfile`, … | Idempotency, minimal permissions, no secrets in logs, … |

Run `/audit README.md` and you get doc-specific findings. Run `/audit main.tf` and you get IaC-specific findings. The right principles fire for the right artifact — without any manual configuration.

---

### 🧱 Artifact types, stacks, and layers

The layer model is per-stack. Each artifact type has its own 2–3 layer stack, and a set of truly universal principles applies across all stacks:

```mermaid
flowchart TB
    FILE["📄 File being reviewed"]
    FILE --> DETECT["Artifact Type Detection<br>layers/artifact-types.yaml<br>by extension · path · filename"]

    UNIV["Universal (all types)<br>DRY · KISS · Naming<br>Reveals Intention · YAGNI · ADR"]

    DETECT -->|".java .ts .py ..."| CODE
    DETECT -->|".md README ADR ..."| DOCS
    DETECT -->|".env .yaml .toml ..."| CONFIG
    DETECT -->|".tf Dockerfile ..."| INFRA
    DETECT -->|".proto .graphql ..."| SCHEMA
    DETECT -->|"Jenkinsfile .github/ ..."| PIPELINE

    subgraph CODE ["Code Stack  (layers/code/)"]
        direction TB
        C1["Layer 1 — Universal<br>SOLID · GoF · Fail-fast · Validate input"]
        C2["Layer 2 — Contextual<br>API · DDD · Concurrency · Testing"]
        C3["Layer 3 — Risk<br>Auth · Financial · PII · Legacy"]
        C1 --> C2 --> C3
    end

    subgraph DOCS ["Docs Stack  (layers/docs/)"]
        direction TB
        D1["Layer 1 — Universal<br>DOC-PURPOSE · DOC-MINIMAL<br>Code-for-readers · Reduce cognitive load"]
        D2["Layer 2 — Contextual<br>API docs · Architecture · Tutorial · Reference"]
        D1 --> D2
    end

    subgraph CONFIG ["Config Stack  (layers/config/)"]
        direction TB
        CF1["Layer 1 — Universal<br>12FACTOR-03 · No hardcoded secrets<br>Schema validation"]
        CF2["Layer 2 — Contextual<br>Feature flags · Secrets management"]
        CF1 --> CF2
    end

    subgraph INFRA ["Infra Stack  (layers/infra/)"]
        direction TB
        I1["Layer 1 — Universal<br>IaC · Immutable · Idempotent<br>Composable modules"]
        I2["Layer 2 — Contextual<br>Kubernetes · Terraform · Docker"]
        I3["Layer 3 — Risk<br>Production · IAM · Network exposure"]
        I1 --> I2 --> I3
    end

    subgraph SCHEMA ["Schema Stack  (layers/schema/)"]
        direction TB
        S1["Layer 1 — Universal<br>Backward-compatible · Self-describing<br>Consistent naming"]
        S2["Layer 2 — Contextual<br>Protobuf · OpenAPI · GraphQL · SQL"]
        S1 --> S2
    end

    subgraph PIPELINE ["Pipeline Stack  (layers/pipeline/)"]
        direction TB
        P1["Layer 1 — Universal<br>Idempotent · Minimal permissions<br>No secrets in logs"]
        P2["Layer 2 — Contextual<br>Build · Deploy · Release · Rollback"]
        P1 --> P2
    end

    UNIV --> MERGE["🔀 Merge<br>Universal + Stack layers<br>+ .principles hierarchy"]
    CODE --> MERGE
    DOCS --> MERGE
    CONFIG --> MERGE
    INFRA --> MERGE
    SCHEMA --> MERGE
    PIPELINE --> MERGE
    MERGE --> AI["🤖 AI Agent<br>Focused & Ready"]
```

Layer 1 of each stack always fires for that artifact type. Layer 2 activates based on content signals within the file. Layer 3 (where present) kicks in when risk signals are detected. The universal set — DRY, KISS, YAGNI, Naming, Reveals Intention, ADR — applies across all stacks.

---

### 🔄 Shift left — catch it while you're writing, not after

Traditional code review is valuable. But it happens *after* the code is already written — and the later a problem is caught, the more expensive it is to fix. Rearchitecting after the fact is painful. Rewriting after merge is costly. Finding a security flaw in production is a crisis.

`.principles` supports a **shift-left quality loop** where principles are active *before and during* coding, not just when auditing:

```mermaid
flowchart LR
    S["🔭 /scout<br>Analyze project<br>write .principles"]
    P["⚡ /prime<br>Load principles<br>into coding frame"]
    C["✍️ Write code<br>with the right<br>mindset active"]
    A["🔎 /audit<br>Review against<br>active principles"]
    F["🔧 Fix issues"]
    D["✅ Done"]

    S --> P --> C --> A --> F --> A --> D
```

`/prime` is the key step. It resolves the full `.principles` hierarchy and loads the complete principle guidance into the AI's context *before* a single line is written. The AI doesn't just know the principles in the abstract — it has them front-of-mind as it generates code, the same way an experienced senior developer does when they sit down to work.

`/audit` then gives you the gut-check: not just "does this compile?" or "are there obvious bugs?" — but *"does this code reflect good engineering?"* Critical findings need immediate attention. But you also want the broader signal: is this code well-structured, secure, maintainable, and consistent with the architecture? That's quality assurance, not just bug hunting.

---

### 🧬 Transferring the developer mindset

Here is the deeper insight behind this project.

A great senior developer doesn't consult a checklist before every line they write. They have internalized principles over years of experience — SOLID, clean boundaries, security hygiene, failure modes. That internalized knowledge shapes *how they think* while coding. It's a **mindset**, not a procedure.

AI agents are already technically capable of producing correct, working code. That's not the bottleneck. The bottleneck is that they tend to generate code that *works* without necessarily generating code that is *well-principled* — unless the principles are made explicit.

`.principles` is how you make them explicit. You are not configuring a linter. You are not writing more rules. You are **transferring the mindset** of a principled software engineer to the AI agent working on your codebase.

> 🎯 The AI writes the code. You bring the craft.

---

## 🧠 Philosophy

`.principles` does **not** teach the AI anything. Modern AI agents already know SOLID, OWASP, DDD, and the rest. The point is to **focus and trigger** that knowledge — to give the AI context about *which* principles matter for *this* codebase, delivered as per-group principle files in `.github/instructions/` (Copilot Code Review) and `.claude/rules/` (Claude Code).

Think of it as: the AI instructions tell the agent *how to behave*; `.principles` tells it *which engineering lens to apply*.

`.principles` is built for the **"X as Code"** world. Modern projects treat far more than source code as version-controlled plain text: *docs as code* (READMEs, architecture docs, ADRs), *infrastructure as code* (Terraform, Helm, Dockerfiles), *configuration as code* (application settings, environment definitions), *pipeline as code* (GitHub Actions, Jenkinsfile), *schema as code* (Protobuf, OpenAPI, GraphQL). Each of these artifact types has its own engineering principles, and `.principles` applies the right ones automatically — the system ships with dedicated principle stacks for all six artifact types.

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
| **Layer 1 — Universal**     | Always, for the matched type  | Non-negotiable principles for that artifact type (e.g., code: SOLID, fail-fast; docs: DOC-PURPOSE, DOC-MINIMAL) |
| **Layer 2 — Contextual**    | Based on content signals      | API design, concurrency, data modeling, tutorial vs. reference docs, etc.          |
| **Layer 3 — Risk-elevated** | Based on risk signals         | Security, performance, backward compatibility (code and infra stacks only)         |

### 🛠️ Three commands

Because these are AI commands — not CLI tools — you speak to them in natural language. No need to specify exact file paths unless you want to. The AI understands context.

- 🔭 **`scout`** — `/scout` in Claude/Copilot, `$scout` in Codex. Detects language/framework/domain, creates `.principles` files, then emits per-group principle files to `.github/instructions/` (Copilot Code Review) and `.claude/rules/` (Claude Code).
- ⚡ **`prime`** — `/prime` in Claude/Copilot, `$prime` in Codex. Resolves your `.principles` hierarchy (using per-group files fast path), loads full principle guidance, prepares your coding frame.
- 🔎 **`audit`** — `/audit` in Claude/Copilot, `$audit` in Codex. Resolves your `.principles` hierarchy (using per-group files fast path), loads principle content, reviews code, and groups findings by severity (Critical / High / Medium / Low).

The AI figures out the scope from context:

```
/audit current changes          → reviews only what has changed since last commit
/audit the payment module       → reviews the payments subtree
/audit                          → you decide the scope in conversation
/prime                          → loads principles for whatever you're about to work on

# Force specific principles (ignores .principles files):
/audit DDD on src/orders        → review src/orders against DDD principles
/audit src/orders --with ddd    → same, flag syntax
/audit @ddd src/orders          → same, group-prefix syntax
/audit clean-arch, solid on src → multiple groups, comma-separated
```

## 🚀 Quick start

**Prerequisites:** Bash 4+ — see [REQUIREMENTS.md](REQUIREMENTS.md) for platform-specific setup. Tested with Claude Haiku 4.5, GPT-4.1, and GPT-5.1-mini (low). Premium models recommended for best review quality and formatting. Local LLMs not supported.

```bash
# Clone the repo
git clone https://github.com/dot-principles/principles.git

# Install into your project (Claude Code commands + Copilot files + Codex skills + vendor catalog)
./install.sh all <project-dir>

# Commit the installed files so every team member gets the commands automatically
cd <project-dir>
git add .claude/ .github/ .agents/ .principles-catalog/
git commit -m "Add .principles AI commands and principle files"

# Use it — in Claude Code, Copilot, or Codex:
#   /scout                      → detect profile, create .principles files, emit per-group files
#   /prime                      → before writing code
#   /audit current changes      → review only what changed since last commit
#   /audit directory            → review whatever you describe in conversation
#   /audit DDD on src/          → force DDD principles regardless of .principles files
#   $scout / $prime / $audit    → same workflows in Codex CLI or IDE
```

**GitHub Copilot (VS Code / JetBrains / CLI):** The repo ships with `.github/prompts/` and `.github/skills/` already populated — `/scout`, `/prime`, and `/audit` are available in Copilot Chat (IDE) and Copilot CLI (terminal) as soon as you clone.

**Codex (CLI + IDE):** The repo also ships with `.agents/skills/` populated — use `$scout`, `$prime`, and `$audit` in Codex.

To install into your own project:

```bash
./install.sh all <dir>
```

See [INSTALL.md](INSTALL.md) for full platform instructions (Linux, macOS, Windows) and all supported tools.

## 📚 Principle catalog

**373 principles across 24 namespaces.** The CODE-* prefix alone covers 128 principles across 13 sub-categories. SOLID, GoF, DDD, GRASP, OWASP, 12-Factor, EIP, and more ship in their own namespaces — see [DESIGN.md](DESIGN.md#-2-catalog-structure) for the full catalog:

| Namespace prefix | Area |
|---|---|
| `CODE-CS-` | Computer Science fundamentals & code smells |
| `CODE-API-` | API Design (REST, HTTP, gRPC) |
| `CODE-CC-` | Concurrency |
| `CODE-RL-` | Reliability & Error Handling |
| `CODE-SEC-` | Security (input validation, secrets, cryptography) |
| `CODE-TS-` | Testing Strategy |
| `CODE-OB-` | Observability & Operations |
| `CODE-DX-` | Developer Experience |
| `CODE-TP-` | Type & Pattern Safety |
| `CODE-AR-` | Architecture (messaging, modules, infrastructure) |
| `CODE-PF-` | Performance |
| `SOLID-` | SOLID principles |
| `GOF-` | Gang of Four design patterns |
| `DDD-` | Domain-Driven Design |
| `GRASP-` | GRASP principles |
| `OWASP-` | OWASP Top 10 |
| `12FACTOR-` | Twelve-Factor App |
| `EIP-` | Enterprise Integration Patterns (12 patterns) |
| `SEC-ARCH-` | Security Architecture (all 8 Saltzer & Schroeder) |
| `ARCH-` | System & solution architecture |
| `INFRA-` | Infrastructure (IaC, containers, immutability) |
| `CD-` | Continuous Delivery (trunk-based, semver, …) |
| `PIPELINE-` | CI/CD pipeline (permissions, secrets, gates, …) |
| `SCHEMA-` | Schema & contract design |
| `CONFIG-` | Configuration management |
| `DOC-` | Documentation |
| `CODE-SMELLS-` | All 22 Fowler code smells |
| `FP-` | Functional Programming |
| `A11Y-` | Accessibility (WCAG 2.1 Level A/AA) |
| `SIMPLE-DESIGN-` | Kent Beck's 4 Rules of Simple Design |
| `CLEAN-ARCH-` | Clean Architecture |
| `PKG-` | Package / module design |
| `EFFECTIVE-JAVA-` | Effective Java patterns |

**52 shipped groups** (`@spring-boot`, `@react`, `@microservices`, `@security-focused`, `@a11y`, `@pipeline`, `@container`, `@schema`, `@eip`, `@fp`, `@db`, `@ddd`, `@cd`, `@docs-as-code`, and more) bundle related principles for common stacks. See [DESIGN.md](DESIGN.md#-6-groups) for the full list.

Many principles include **code examples and diagrams** to make the guidance concrete — not just a definition, but a demonstration of the principle in practice.

## 💡 Example review output

> **Note:** The output below is illustrative. Formatting, structure, and level of detail will vary between AI models and even between runs of the same model. The principle review itself is performed by the AI — some models produce thorough, well-structured audits; others may miss findings or deviate from the template. The `audit-output.json` file is the most reliable artefact; the text report is best-effort.

```
Audit complete — 4 findings.

Critical:

- `C:/projects/app/UserRepository.java:47` [CODE-SEC-VALIDATE-INPUT] — SQL query built with string concatenation; user input interpolated directly into query string. → Use parameterized queries (PreparedStatement).

High:

- `C:/projects/app/OrderService.java:23` [CODE-CC-SYNC-SHARED-STATE] — Shared mutable state without synchronization; counter field modified across request threads. → Use AtomicInteger or move state into request scope.

Medium:

- `C:/projects/app/PaymentClient.java:61` [CODE-RL-IDEMPOTENCY] — Non-idempotent retry path; charge() called in retry loop with no idempotency key. → Pass a stable idempotency key so retries do not double-charge.

Low:

- `C:/projects/app/OrderService.java:89` [CODE-DX-NAMING] — Abbreviated name obscures intent; variable named `flg` with no indication of purpose. → Rename to something that expresses what the flag controls.

Summary: 1 critical, 1 high, 1 medium, 1 low
Principle source: .principles hierarchy (2 files)

Generated: C:/projects/app/audit-output.json
```

## 🔧 Extending with your own principles

Fork this repo and add a `principles/corp/` namespace (or any name) for corporate or domain-specific principles. Reference them with `CORP-0001` in your `.principles` files. See [DESIGN.md](DESIGN.md#-10-adding-a-new-namespace) for the full process.

## 🚧 Catalog status

The catalog has grown substantially and now covers all major software engineering domains. All gap areas identified during initial development have been filled. The table below shows what's shipped:

| Area | Status | Highlights |
|---|---|---|
| Functional programming | ✅ Shipped | Pure functions, immutability, referential transparency, higher-order functions |
| Continuous delivery | ✅ Shipped | Trunk-based development, semver, feature flags, fast feedback, blue-green, canary |
| Database / persistence | ✅ Shipped | N+1 avoidance, index for access patterns, schema migrations, outbox pattern |
| OOP / object design | ✅ Shipped | Law of Demeter, Tell Don't Ask, CQS, design by contract |
| Architecture patterns | ✅ Shipped | Hexagonal, Saga, Strangler Fig, Anti-Corruption Layer, Bulkhead, Sidecar, Database-per-Service |
| Security architecture | ✅ Shipped | All 8 Saltzer & Schroeder principles (economy of mechanism, least common mechanism, open design, …) |
| Testing | ✅ Shipped | Test-first, single behaviour, fast tests, test doubles, arrange-act-assert |
| Observability | ✅ Shipped | Structured telemetry, distributed tracing, SLOs, RED method, four golden signals, error budgets |
| Config principles | ✅ Shipped | Schema-first, environment parity, explicit defaults, no hardcoded secrets |
| Schema principles | ✅ Shipped | Field optionality, no polymorphic blobs, enum evolution, self-describing |
| Pipeline principles | ✅ Shipped | Minimal permissions, no secrets in logs, reproducible builds, deployment gates, environment isolation |
| API design | ✅ Shipped | HTTP status codes, HATEOAS, resource nouns, backward compatibility, rate limiting, versioning, gRPC |
| Enterprise Integration | ✅ Shipped | 12 EIP patterns — aggregator, splitter, wire tap, idempotent consumer, message translator, … |
| Accessibility (WCAG 2.1) | ✅ Shipped | Alt text, semantic HTML, keyboard navigation, colour contrast (`@a11y` group) |
| Error handling | ✅ Shipped | Exceptions for exceptional conditions, catch specific exceptions, fail fast |
| Code smells | ✅ Shipped | All 22 Fowler smells (1st + 2nd edition) |

Contributions are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md).

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for requirements, process, and source guidelines.

## 📄 License

- **Principle texts:** [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) — use freely, credit required, share-alike
- **Scripts and tooling:** [MIT](https://opensource.org/licenses/MIT)
- **How to apply this in practice:** see [LICENSE-INTERPRETATION.md](LICENSE-INTERPRETATION.md) for internal use vs distribution, and what users/developers may do and must do
- **Ownership boundary:** see [LICENSE-INTERPRETATION.md](LICENSE-INTERPRETATION.md) (section 10: Ownership and curation scope)

## ☕ Support

If this project is useful to you, you can support ongoing maintenance and updates:

[![Buy Me A Coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://buymeacoffee.com/flemming.n.larsen)

If the image does not load, use this link: [Buy me a coffee](https://buymeacoffee.com/flemming.n.larsen)
