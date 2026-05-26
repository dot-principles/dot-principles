# CLEAN-ARCH-ARCHITECTURAL-BOUNDARIES - Define Clear Architectural Boundaries

**Layer:** 2 (contextual)
**Categories:** architecture
**Applies-to:** all
**Summary:** Draw explicit boundaries between components and enforce all cross-boundary communication through well-defined interfaces.

## Principle

Draw explicit boundaries between components that change for different reasons or at different rates. Each boundary separates a higher-level policy from a lower-level detail, and communication across the boundary should occur through well-defined interfaces. Boundaries can be enforced at the source level (separate modules), at the deployment level (separate libraries or packages), or at the service level (separate processes) - the choice depends on the cost of crossing the boundary versus the cost of not having one.

## Why it matters

Without explicit boundaries, changes in one part of the system bleed into others, creating a "big ball of mud" where every modification carries unpredictable risk. Architectural boundaries protect stable, high-value components from volatile ones. They allow teams to work independently, enable independent deployability, and make the system's structure visible and enforceable rather than merely aspirational.

## Violations to detect

- Direct access to another component's internal data structures, database tables, or private APIs
- Modules that import internal (non-public) classes from other modules, bypassing the public interface
- Shared mutable state between components that should communicate only through defined interfaces
- A change in one component that routinely forces changes in multiple unrelated components

## Good practice

- Define a public API for each component - only types and functions in the public API may be referenced by other components
- Use language or build-system mechanisms to enforce boundaries (Java modules, Go internal packages, TypeScript project references, Bazel visibility rules)
- Start with simpler boundaries (source-level modules) and promote to deployment or service boundaries only when the cost-benefit analysis justifies it
- Regularly review dependency graphs to detect boundary violations before they accumulate

## Sources

- Martin, Robert C. *Clean Architecture: A Craftsman's Guide to Software Structure and Design*. Prentice Hall, 2017. ISBN 978-0-13-449416-6. Chapter 25: "Layers and Boundaries."
