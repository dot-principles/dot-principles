# PKG-SAP — Stable Abstractions Principle (SAP)

**Layer:** 2 (contextual)
**Categories:** software-design, package-design, modularity, architecture
**Applies-to:** all
**Summary:** Stable components must consist primarily of abstract types so they remain extensible without modification.

## Principle

A component should be as abstract as it is stable. The more a component is depended upon (stable), the more it should consist of abstract classes and interfaces rather than concrete implementations. Stable concrete components are hard to extend without modifying them; stable abstract components can be extended through new implementations.

## Why it matters

A stable component that is all concrete classes is a rigid anchor. It cannot be extended without modification, violating OCP. The SAP, combined with SDP, ensures that dependencies flow toward stable abstractions — creating a system that is both stable and extensible.

## Violations to detect

- A widely-depended-upon component with no interfaces or abstract classes — only concrete implementations
- A component that is very stable (many incoming deps) but has A (abstractness) close to 0
- Abstract components that are also volatile (few incoming deps) — abstractions no one uses

## Good practice

For each stable component, ask: "are the things others depend on abstract (interfaces, abstract classes, protocols) or concrete?" Push concrete implementations toward less-stable, higher-layer components. Measure abstractness A = (abstract classes / total classes) and plot against instability I; components should cluster near the "main sequence" line A + I ≈ 1.

## Sources

- Martin, Robert C. *Agile Software Development: Principles, Patterns, and Practices*. Prentice Hall, 2002. ISBN 978-0-13-597444-5. Chapter 22.
