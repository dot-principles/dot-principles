# PKG-ADP — Acyclic Dependencies Principle (ADP)

**Layer:** 1 (universal)
**Categories:** software-design, package-design, modularity, architecture
**Applies-to:** all
**Summary:** Eliminate all cycles in the component dependency graph to enable independent builds and releases.

## Principle

Allow no cycles in the component dependency graph. When components form a cycle, they must be released and tested together as a single unit — eliminating the independence that components are supposed to provide. Breaking cycles requires extracting shared dependencies into new components or applying the Dependency Inversion Principle.

## Why it matters

A dependency cycle makes it impossible to build or test any component in the cycle in isolation. Changing one component may require changing all the others in the cycle. Build times grow and developers cannot work on components independently.

## Violations to detect

- Component A depends on B, B depends on C, C depends back on A (a cycle)
- A shared "utils" component that imports from domain components that themselves import utils — creating a cycle
- Two modules that each import from each other

## Inspection

- `find $TARGET -name "*.ts" -o -name "*.js" | head -1` | MEDIUM | Cycles require static analysis tools, not simple grep; use a dependency analysis tool (dependency-cruiser, ArchUnit, Graphviz) to detect cycles

## Good practice

Draw the component dependency graph. Any directed cycle must be broken. Use DIP (introduce an interface in one component that the other implements) or extract the shared code into a new, lower-level component that both can depend on. Enforce acyclicity with tooling (e.g., ArchUnit in Java, dependency-cruiser in JS/TS).

## Sources

- Martin, Robert C. *Agile Software Development: Principles, Patterns, and Practices*. Prentice Hall, 2002. ISBN 978-0-13-597444-5. Chapter 21.
