# PKG-SDP - Stable Dependencies Principle (SDP)

**Layer:** 2 (contextual)
**Categories:** software-design, package-design, modularity, architecture
**Applies-to:** all
**Summary:** Depend only on components more stable than yourself; keep volatile components at the system's edges.

## Principle

Depend in the direction of stability. A component should only depend on components that are more stable than itself. Stability is measured by the number of incoming dependencies (more depended-upon = more stable) relative to outgoing dependencies (more depending-on = less stable). Depending on an unstable component means your component must change whenever that upstream component changes.

## Why it matters

Depending on volatile components makes a stable component fragile. Changes propagate upstream through dependencies. Stable components absorb change at the edge of the system; volatile components (with no dependents) can be freely changed.

## Violations to detect

- A widely-used core domain component that depends on a volatile plugin or adapter component
- A stable infrastructure module importing from a rapidly-changing feature module
- No conscious thought given to which direction dependencies point relative to stability

## Good practice

Calculate instability I = (outgoing / (outgoing + incoming)) for each component. Arrows should generally flow from unstable (I ≈ 1) toward stable (I ≈ 0). Push volatility to the edges (adapters, UI, plugins) and keep the core stable.

## Sources

- Martin, Robert C. *Agile Software Development: Principles, Patterns, and Practices*. Prentice Hall, 2002. ISBN 978-0-13-597444-5. Chapter 22.
