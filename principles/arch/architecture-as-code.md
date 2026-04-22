# ARCH-ARCHITECTURE-AS-CODE — Architecture as Code

**Layer:** 1
**Categories**: architecture, documentation, tooling
**Applies-to**: all
**Summary:** Define the architecture model in version-controlled code so it stays in sync with the system it describes.

## Principle

Express the software architecture — components, relationships, deployments, and boundaries — as a versioned, machine-parseable model in the repository. Use a structured tool (Structurizr DSL, Backstage catalog YAML, ArchiMate in code) rather than static images or slide decks. The code model is the source of truth; diagrams, documentation, and dependency graphs are generated from it.

## Why it matters

Architecture diagrams drawn by hand become stale the moment the system changes. A code-based model is diffable, reviewable, and automatable: drift detection, dependency analysis, and diagram generation can all run in CI. A versioned model also captures the *evolution* of the architecture, not just its current state.

## Violations to detect

- Architecture described only in slide decks or static image files with no structured source
- C4 diagrams drawn in `.drawio` or Visio rather than generated from a DSL or model
- No architecture model in the repository — only README prose describing structure
- Multiple diagram tools in use with no single authoritative model

## Good practice

```
# Structurizr DSL (C4 model)
workspace.dsl           ← model: systems, containers, components, relationships
views/                  ← view definitions (context, container, component, deployment)

# Generate diagrams and docs from the model in CI, not by hand
```

Keep the model lean: define what matters for decision-making, not every class or method.

## Sources

- [Structurizr DSL](https://structurizr.com/dsl) — C4 model as code, renders multiple views
- Brown, Simon. *Software Architecture for Developers*, Vol. 2. Leanpub, 2018. https://leanpub.com/visualising-software-architecture
- [Backstage Software Catalog](https://backstage.io/docs/features/software-catalog/) — service registry as code
