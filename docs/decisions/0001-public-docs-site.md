---
status: accepted
date: 2026-05-26
decision-makers: dot-principles contributors
---

# ADR-0001: Keep the public docs site in-repo and reserve `content/` for site prose

## Context and Problem Statement

The `.principles` project already has substantial documentation, but the material is distributed across `README.md`, `INSTALL.md`, `DESIGN.md`, `demo/presentation.md`, and directory-level indexes. That structure works for committed repo readers, but it is a clumsy first experience for developers who are only evaluating the project.

The project needs a public GitHub Pages front door that explains why `.principles` exists, how it works, how to get started, and where to go deeper. At the same time, the repo should keep its Git-native plain-text documentation model and avoid creating a second source of truth.

The `ase-book` repository already proves a workable pattern:

- keep VitePress in the main repo
- use `content/` as the VitePress source directory
- keep `docs/` for architecture notes and ADRs
- deploy with GitHub Actions instead of depending on GitHub Pages' `docs/` folder convention

## Considered Options

* Keep everything in the current root docs only
* Create a separate documentation repository
* Add an in-repo VitePress site and reserve `content/` for public docs prose

## Decision Outcome

Chosen option: add an in-repo VitePress site and reserve `content/` for public docs prose.

The public site will live in `C:\Code\dot-principles` because product, catalog, commands, and documentation evolve together here. The site will use VitePress as a presentation layer for discoverability and onboarding, not as the canonical home for every technical detail.

Canonical ownership stays explicit:

- `README.md` remains the concise GitHub landing page
- `INSTALL.md` remains the install and reference source of truth
- `DESIGN.md` remains the deep architecture source of truth
- `demo/presentation.md` remains the full workflow walkthrough
- `content/` will hold curated public-facing docs pages
- `docs/` will hold docs-about-docs material such as ADRs and architecture notes

The public narrative should reuse the strongest arguments from `C:\Code\ase-book\content\quality\dot-principles.md`, especially:

- AI agents need explicit local standards, not implied tribal knowledge
- engineering guidance should live in plain text close to the code it governs
- `.principles` is valuable because it makes judgment inspectable and reusable
- claims about maturity should stay precise and credible rather than oversold

### Consequences

* Good, because new visitors get a clearer path from curiosity to first use
* Good, because the repo keeps one main source tree and avoids cross-repo drift
* Good, because `content/` cleanly separates public docs prose from architecture documentation in `docs/`
* Good, because the existing deep references remain canonical instead of being duplicated wholesale
* Bad, because the repo gains a Node/VitePress toolchain that contributors must maintain
* Bad, because some concepts will exist in both the site and root docs; this must be managed by clear source-of-truth boundaries

## Pros and Cons of the Options

### Keep everything in the current root docs only

* Good, because it adds no new toolchain
* Good, because all docs stay in already-familiar files
* Bad, because it keeps the current clumsy first-reader experience
* Bad, because `README.md` would have to keep serving both skeptical newcomers and deep technical readers at once

### Create a separate documentation repository

* Good, because it could isolate the docs toolchain from the main repo
* Good, because it could later support a broader marketing or publishing workflow
* Bad, because product and docs would drift more easily
* Bad, because the information architecture and messaging are not stable enough yet to justify the split
* Bad, because contributor updates would need to span multiple repositories for one change

### Add an in-repo VitePress site and reserve `content/` for public docs prose

* Good, because it creates an approachable public front door without moving the source material away from the repo
* Good, because it reuses the already-working `ase-book` VitePress and Pages patterns
* Good, because `content/` is a semantically clear source directory for curated pages
* Good, because `docs/` stays available for architecture notes and ADRs
* Neutral, because contributors must learn the `content/` + `.vitepress/` split instead of the VitePress default

## Validation

This decision will be validated by the implementation work that follows:

- `content/` is used as `srcDir` in `.vitepress/config.mts`
- the public docs build with `npm run docs:build`
- root reference docs remain in place and are linked as canonical references from the site
- GitHub Pages deployment is handled by GitHub Actions rather than by treating `docs/` as the published folder