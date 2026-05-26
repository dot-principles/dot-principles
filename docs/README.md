# Documentation Architecture

This repository now has a dedicated documentation architecture for a public GitHub Pages site.

The goal is not to replace the repo's existing plain-text documentation. The goal is to add a clearer front door for developers who are curious about `.principles`, while keeping the deep technical references in their current canonical locations.

## Reader journey

| Reader question | Public docs layer owns | Canonical reference remains |
|---|---|---|
| Why does `.principles` exist? | VitePress landing page and narrative pages under `content/` | `README.md` for GitHub-native summary |
| How do I get started? | Guided getting-started path under `content/` | `INSTALL.md` for full install and reference detail |
| How does it work? | Visitor-oriented explanation of hierarchy, commands, and extension points | `DESIGN.md` for architecture and contributor detail |
| What does the workflow feel like? | Public examples and demo-oriented pages under `content/` | `demo/presentation.md` for the full walkthrough |
| Where do I change docs chrome and structure? | `.vitepress/` and `content/` | This `docs/` tree for decisions about the docs system |

## Ownership boundaries

- `content/` is the public docs source for GitHub Pages.
- `.vitepress/` owns site chrome, navigation, theme config, and build behavior.
- `README.md` remains the GitHub landing page and concise repo entry point.
- `INSTALL.md`, `DESIGN.md`, and `demo/presentation.md` remain canonical deep references.
- `docs/` holds documentation about the documentation system itself: architecture notes, ADRs, and maintenance guidance.

## Why the site stays in this repo

The docs site lives in `C:\Code\dot-principles`, not in a separate repository.

- The product and its documentation evolve together here.
- This repo already requires documentation updates for meaningful changes.
- A second repo would create avoidable drift between the product, the catalog, and the public story.

## Public narrative themes to reuse

The public docs should keep reusing the strongest arguments from `C:\Code\ase-book\content\quality\dot-principles.md`:

- AI coding agents need explicit, local guidance instead of vague team folklore.
- `.principles` turns engineering judgment into plain-text rules that travel with the codebase.
- The value is practical governance, not abstract manifesto writing.
- The workflow should feel inspectable, text-first, and Git-native.
- Credibility depends on honest scope: useful today, still evolving, and strongest when teams adapt it to their own repo.

## Related decisions

| ADR | Title | Status |
|---|---|---|
| [0001](decisions/0001-public-docs-site.md) | Keep the public docs site in-repo and reserve `content/` for site prose | accepted |

## Contributor guidance

- [authoring.md](authoring.md) defines the writing bar for public docs pages and repo-facing docs updates.