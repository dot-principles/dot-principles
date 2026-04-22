# PTAC-COMPOSABLE-FILES — Composable Files

**Layer:** 1
**Categories**: structure, maintainability, modularity
**Applies-to**: all
**Summary:** Keep files small, focused, and composable rather than large and monolithic.

## Principle

Each file should express one coherent concept or concern. Compose larger systems by combining small, focused files rather than packing everything into a single large file.

## Why it matters

Large monolithic files are hard to navigate, review, and reason about — for humans and AI tools alike. A 2000-line Terraform module, a 500-line GitHub Actions workflow, or a 300-line Markdown document overwhelms the reader and makes targeted reviews impossible. Small, composable files can be read in full, reviewed in isolation, and combined without understanding the whole.

## Violations to detect

- Single files exceeding 300 lines (flag for review, not automatic violation)
- Configuration or documentation files that mix multiple unrelated concerns
- Infrastructure modules that provision unrelated resource types
- A single workflow file containing more than 5 logical stages that could be separate files
- Monolithic README files that serve as both reference documentation, tutorial, and changelog

## Good practice

```
# Monolithic (avoid)              # Composable (prefer)
infra/main.tf (800 lines)         infra/network.tf
                                  infra/compute.tf
                                  infra/storage.tf
                                  infra/iam.tf

docs/everything.md                docs/quickstart.md
                                  docs/reference.md
                                  docs/architecture.md
```

## Sources

- [Plain-Text-as-Code](https://github.com/Plain-Text-as-Code) — composability principle
- Robert C. Martin, *Clean Code*, Chapter 5: "Formatting", Prentice Hall, 2008. ISBN 978-0-13-235088-4.
