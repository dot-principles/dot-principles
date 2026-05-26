# Rejected Principles

Principles that were evaluated for inclusion and deliberately not added.
This log prevents re-evaluation of the same candidates and documents the reasoning.

## How to use this file

Before proposing a new principle, check here first. If it is already listed, the rationale explains why it was rejected. If circumstances have changed (e.g., a new authoritative source was published, or the overlapping principle was removed), re-open the discussion by referencing the original rejection.

## Format

Each entry: name, source, rejection date, reason, and which existing principle(s) cover the intent.

---

## Rejected entries

### Pipeline: Artifact Immutability
- **Source:** Humble & Farley, *Continuous Delivery*, Ch. 5 (ISBN 978-0-321-60191-9)
- **Rejected:** 2026-03-22
- **Reason:** Directly covered by CD-BUILD-ONCE-DEPLOY-MANY, which states "compile and package the artifact exactly once; promote that same immutable artifact through every environment." The violations and detection guidance are identical.

### Pipeline: Pin Action/Plugin Versions
- **Source:** OpenSSF SLSA v1.0, OWASP CI/CD Security Cheat Sheet
- **Rejected:** 2026-03-22
- **Reason:** Covered by SEC-ARCH-SUPPLY-CHAIN-SECURITY, which explicitly lists "Third-party CI actions referenced by a floating branch or tag rather than a pinned commit SHA" as a violation and includes inspection patterns for GitHub Actions pinned to mutable refs and Docker images pinned by tag instead of digest.

### Separation of Concerns
- **Source:** Dijkstra, "On the role of scientific thought" (1974), EWD 447
- **Rejected:** 2026-03-22
- **Reason:** Overlaps with SOLID-SRP (single reason to change), GRASP-HIGH-COHESION (related responsibilities together), GRASP-LOW-COUPLING (minimize cross-concern dependencies), and CLEAN-ARCH-ARCHITECTURAL-BOUNDARIES (enforce boundaries between concerns). The concept is foundational but already expressed through multiple more specific, more auditable principles.

### Defensive Copying
- **Source:** Bloch, *Effective Java* 3rd ed., Item 50 (ISBN 978-0134685991)
- **Rejected:** 2026-03-22
- **Reason:** Covered by EFFECTIVE-JAVA-MINIMIZE-MUTABILITY (prefer immutable objects, eliminating the need for defensive copies) and CODE-CC-PREFER-IMMUTABLE (prefer immutable data structures). Defensive copying is the workaround when immutability is not achieved - the catalog targets the root cause instead.

### Reactive Manifesto (Responsive, Resilient, Elastic, Message-Driven)
- **Source:** reactivemanifesto.org (Boner et al., 2014)
- **Rejected:** 2026-03-22
- **Reason:** Each of the four traits maps directly to existing principles: Responsive = CODE-PF-PREDICTABLE-LATENCY; Resilient = CODE-RL-FAULT-TOLERANCE + CODE-CS-CIRCUIT-BREAKER; Elastic = 12FACTOR-08-CONCURRENCY; Message-Driven = CODE-AR-ASYNC-MESSAGING + EIP patterns. Adding the manifesto as a separate set would create pure redundancy.

### Unix Philosophy
- **Source:** McIlroy, Bell System Technical Journal (1978); Raymond, *The Art of Unix Programming* (2003, ISBN 978-0131429017)
- **Rejected:** 2026-03-22
- **Reason:** "Do one thing well" = CODE-DX-SMALL-FUNCTIONS + SOLID-SRP. "Write programs to handle text streams" = CODE-AR-PIPES-AND-FILTERS. "Make each program a filter" = same. "Use composition" = GOF-COMPOSITION-OVER-INHERITANCE + CODE-AR-COMPOSABLE-MODULES. The philosophy is sound but already decomposed into more actionable, auditable principles.

### Parallel Inheritance Hierarchies (code smell)
- **Source:** Fowler, *Refactoring* 1st ed. (1999, ISBN 978-0201485677)
- **Rejected:** 2026-03-22
- **Reason:** Fowler himself notes in the 2nd edition that this is a special case of CODE-SMELLS-SHOTGUN-SURGERY (every change to one hierarchy forces a parallel change in the other). Adding it would duplicate the detection guidance.

### Inappropriate Intimacy (code smell)
- **Source:** Fowler, *Refactoring* 1st ed. (1999, ISBN 978-0201485677)
- **Rejected:** 2026-03-22
- **Reason:** Renamed to "Insider Trading" in the 2nd edition, which we already have as CODE-SMELLS-INSIDER-TRADING. Same concept, updated name.

### Duplicated Code (code smell)
- **Source:** Fowler, *Refactoring* 2nd ed. (2018, ISBN 978-0134757599)
- **Rejected:** 2026-03-22
- **Reason:** Directly covered by SIMPLE-DESIGN-NO-DUPLICATION and CODE-CS-DRY. Adding a code-smell entry would triple-cover the same violation.

### Mysterious Name (code smell)
- **Source:** Fowler, *Refactoring* 2nd ed. (2018, ISBN 978-0134757599)
- **Rejected:** 2026-03-22
- **Reason:** Directly covered by CODE-DX-NAMING (name things by what they represent). The violation and detection are identical.

### Mutable Data (code smell)
- **Source:** Fowler, *Refactoring* 2nd ed. (2018, ISBN 978-0134757599)
- **Rejected:** 2026-03-22
- **Reason:** Covered by CODE-CC-PREFER-IMMUTABLE and FP-IMMUTABILITY. Both already flag unnecessary mutability with the same audit approach.
