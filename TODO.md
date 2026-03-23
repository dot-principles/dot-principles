# TODO — Principle gaps to fill

Gap analysis performed 2026-03-22. Criteria: established published source, code-auditable per CONTRIBUTING.md, no duplication with existing catalog.

---

## Tier 1 — High-value gaps

### 1. ~~Pipeline namespace is skeletal (2 principles)~~ DONE

`pipeline/` expanded from 2 to 6 principles. Added `reproducible-builds`, `environment-isolation`, `fail-fast-pipeline` (layer 1), and `deployment-gates` (layer 2). Layer files, context files, and inspect patterns updated. `artifact-immutability` and `pin-action-versions` rejected — see [REJECTED.md](REJECTED.md).

- [x] `pipeline/reproducible-builds`
- [x] `pipeline/environment-isolation`
- [x] `pipeline/fail-fast-pipeline`
- [x] `pipeline/deployment-gates` (added — explicit approval gates for production deployments)

### 2. ~~Saltzer & Schroeder missing security design principles~~ DONE

`sec-arch/` now has all 8 Saltzer & Schroeder (1975) principles covered. `code/sec/` covers complete-mediation and fail-safe-defaults; `infra/` covers least-privilege. The remaining 5 added to `sec-arch/`. Layer files, context files, catalog, and `security-focused` group updated.

- [x] `sec-arch/economy-of-mechanism` (with inspection)
- [x] `sec-arch/separation-of-privilege`
- [x] `sec-arch/least-common-mechanism` (with inspection)
- [x] `sec-arch/psychological-acceptability` (`Audit-scope: limited`)
- [x] `sec-arch/open-design` (with inspection)

### 3. ~~Schema namespace is skeletal (1 principle)~~ DONE

`schema/` expanded from 1 to 4 principles. Added `field-optionality`, `no-polymorphic-blobs`, `enum-evolution` (all layer 1). Context files, inspect file, layer files, and catalog updated. Also added missing `SCHEMA-SELF-DESCRIBING` entry to `catalog.yaml` and added `avro` context to `layer-2-contexts.yaml`.

- [x] `schema/field-optionality` (with inspection)
- [x] `schema/no-polymorphic-blobs` (with inspection)
- [x] `schema/enum-evolution` (with inspection)

### 4. ~~Container / Dockerfile best practices~~ DONE

`infra/` expanded with 4 container-specific principles. Sources: CIS Docker Benchmark v1.6.0, OWASP Docker Security Cheat Sheet, Docker official Dockerfile best practices, OpenSSF SLSA v1.0. Layer files, context files, inspect file, catalog, and `security-focused` group updated.

- [x] `infra/non-root-container` — Containers must not run as root. Auditable: missing `USER` directive in Dockerfile, `runAsUser: 0` in K8s manifests.
- [x] `infra/pin-base-images` — Base images must use digest or specific version tags, never `latest`. Auditable: `FROM image:latest`, `FROM image` (no tag).
- [x] `infra/minimize-image-layers` — Use multi-stage builds and combine RUN commands to minimize layers and image size. Auditable: multiple sequential `RUN apt-get`, no multi-stage pattern, `COPY . .` before dependency install.
- [x] `infra/no-secrets-in-image` — Secrets must not be baked into image layers via `COPY`, `ADD`, or `ENV`. Auditable: `COPY .env`, `ENV PASSWORD=`, `ARG` used for secrets without `--mount=type=secret`.

---

## Tier 2 — Notable gaps

### 5. ~~Missing code smells~~ DONE

`code-smells/` expanded from 18 to 22 principles — all 22 Fowler 1st-edition smells now covered, plus 2 smells introduced in the 2nd edition. Source: Fowler, Martin. *Refactoring*, 2nd ed. (ISBN 978-0-13-475759-9). Context files, group, and catalog updated. 9 previously missing catalog entries also backfilled.

- [x] `code-smells/lazy-element` — A class, function, or module that does too little to justify its existence.
- [x] `code-smells/middle-man` — A class that delegates almost everything to another class.
- [x] `code-smells/mutable-data` — Data that can be changed from multiple places in hard-to-trace ways. (2nd ed addition)
- [x] `code-smells/loops` — Imperative loops that should be replaced with pipeline operations. (2nd ed addition, `Audit-scope: limited`)

### 6. ~~Missing EIP patterns~~ DONE

`eip/` expanded from 5 to 12 principles. All 4 TODO patterns added; 3 additional auditable patterns added beyond the TODO list. `idempotent-consumer` included — differentiated from `CODE-RL-IDEMPOTENCY` by focusing on the consumer-side dedup-store implementation. Source: Hohpe & Woolf, *Enterprise Integration Patterns* (ISBN 978-0321200686). Context files, group, and catalog updated (EIP section added to catalog — was previously missing entirely).

- [x] `eip/aggregator` — Combine related messages into a composite message; explicit completion condition and timeout required.
- [x] `eip/splitter` — Decompose a composite message into individual messages with correlation tracking.
- [x] `eip/wire-tap` — Passive monitoring copy of messages to secondary channel without affecting primary flow.
- [x] `eip/idempotent-consumer` — Consumer-side dedup store to safely discard duplicate at-least-once deliveries.
- [x] `eip/message-translator` — Dedicated boundary component translating between external and internal message formats. (extended)
- [x] `eip/content-enricher` — Augment messages with additional data at a dedicated pipeline stage. (extended)
- [x] `eip/return-address` — Request message carries the reply channel address for dynamic async request-reply routing. (extended)

### 7. ~~Error handling principles~~ DONE

`code/cs/` expanded with 2 error-handling principles. Sources: Bloch, *Effective Java* items 69 & 73; Martin, *Clean Code* ch. 7. Catalog, inspect file, and changelog updated.

- [x] `code/cs/exceptions-for-exceptional-conditions` — Do not use exceptions for ordinary control flow. Source: Effective Java item 69 (ISBN 978-0134685991), Clean Code ch. 7. Auditable: catch blocks used for branching logic, exception-driven loops, Pokemon catches.
- [x] `code/cs/catch-specific-exceptions` — Catch the most specific exception type possible; never catch generic `Exception`/`Throwable`/`BaseException`. Source: Effective Java item 73. Auditable: `catch (Exception e)`, `except Exception:`, `catch (\Throwable $e)`.

### 8. ~~Accessibility / WCAG~~ DONE

New `a11y/` namespace created with 4 principles. `@a11y` group, `.context-inspect.md`, `.context-prime.md`, `.context-audit.md` created. `accessibility` context added to code layer-2-contexts; frontend extensions added to artifact-types. Source: W3C WCAG 2.1 (SC 1.1.1, 1.3.1, 1.4.3, 2.1.1, 4.1.2).

- [x] `a11y/alt-text` — Images must have meaningful alternative text. Auditable: `<img>` without `alt`, `alt=""` on informative images.
- [x] `a11y/semantic-html` — Use semantic HTML elements over generic `<div>`/`<span>` with ARIA roles. Auditable: `<div onclick=`, clickable divs without role/tabindex, missing landmark elements.
- [x] `a11y/keyboard-navigation` — Interactive elements must be keyboard-accessible. Auditable: `onClick` without `onKeyDown`/`onKeyPress`, non-focusable interactive elements, missing `tabIndex`.
- [x] `a11y/color-contrast` — Audit-scope: limited. Partially auditable via hardcoded color values in CSS/styled-components, but full evaluation requires rendering.

### 9. ~~Semantic Versioning~~ DONE

- [x] `cd/semantic-versioning` — Version numbers must communicate the nature of changes (breaking, feature, fix). Source: semver.org (Tom Preston-Werner). Auditable: `0.x` in production dependencies, version strings not following semver pattern, CHANGELOG gaps.

### 10. ~~Architecture — missing microservices patterns~~ DONE

`arch/` expanded with 2 new microservices patterns. Sources: Burns et al. *Designing Distributed Systems*; Richardson *Microservices Patterns* ISBN 978-1617294549. Context files and `microservices.yaml` group updated.

- [x] `arch/sidecar` — Deploy auxiliary concerns (logging, proxying, config) as a co-located process rather than embedding in the service. Auditable: cross-cutting concerns baked into application code that should be sidecar-deployed.
- [x] `arch/database-per-service` — Each service owns its data store; no direct database sharing across service boundaries. Auditable: shared database connection strings, cross-service table joins, shared schemas.

---

## Group coverage notes

Even when a principle exists in the catalog, it may not activate for certain project profiles if no group includes it. Review these:

- [x] `microservices.yaml` — EIP principles (all 12), ARCH-SIDECAR, ARCH-DATABASE-PER-SERVICE added
- [x] `security-focused.yaml` — Saltzer & Schroeder principles added
- [x] Pipeline principles — `pipeline.yaml` group created (12 principles: all PIPELINE-* + key CD-*)
- [x] Container/infra principles — `container.yaml` group created (10 principles: all container INFRA-* + pipeline security)
- [x] Schema principles — `schema.yaml` group created (5 principles: all SCHEMA-* + backward compatibility)

---

Rejected candidates (with rationale) are logged in [REJECTED.md](REJECTED.md).
