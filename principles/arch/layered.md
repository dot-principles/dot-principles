# ARCH-LAYERED - Layered Architecture

**Layer:** 2 (contextual)
**Categories:** architecture, separation-of-concerns
**Applies-to:** all
**Summary:** Organize code into layers where each layer depends only on the layer directly below it; never skip layers.

## Principle

Organise software into horizontal layers where each layer has a specific responsibility and may only depend on the layer directly below it. Common layering: Presentation → Application/Business Logic → Domain → Infrastructure/Persistence. No layer may skip a layer to reach one further down, and no lower layer may depend on a higher layer.

## Why it matters

Layering creates predictable dependency direction, making each layer independently testable and replaceable. Violations - presentation logic in the database layer, business logic in controllers, data access in the UI - produce code that cannot be tested without instantiating the full stack and cannot be changed without ripple effects across unrelated concerns.

## Violations to detect

- Controllers or view handlers containing business logic or database queries
- Domain objects importing web framework types or ORM annotations directly
- Persistence layer calling back into business logic
- Tests that cannot exercise one layer without instantiating all layers

## Good practice

- Map each layer to a package or module boundary; enforce the rule with architectural tests (ArchUnit, Dependency Cruiser, import-linter)
- Define clear interfaces at each layer boundary
- Keep business logic in the domain/application layer - the persistence layer is a detail

## Sources

- Buschmann, Frank et al. *Pattern-Oriented Software Architecture Vol. 1: A System of Patterns*. Wiley, 1996. ISBN 978-0471958697. Chapter 2, "Layers."
- Fowler, Martin. *Patterns of Enterprise Application Architecture*. Addison-Wesley, 2002. ISBN 978-0321127426.
