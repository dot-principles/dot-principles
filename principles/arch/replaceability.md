# ARCH-REPLACEABILITY - Design for replaceability, not permanence

**Layer:** 2 (contextual)
**Categories:** architecture, evolutionary-architecture, maintainability
**Applies-to:** all
**Summary:** Design every component to be replaceable without requiring changes to its neighbors; prefer explicit versioned interfaces.

## Principle

Treat every architectural component - services, databases, frameworks, messaging systems - as replaceable rather than permanent. Design boundaries and interfaces so that any component can be swapped out without requiring changes to adjacent components. Prefer fitness functions over big-bang migration: define measurable criteria that continuously verify the architecture remains aligned with its goals.

## Why it matters

Technology evolves. A framework chosen in 2018 may be a liability in 2025. Teams that treated their choices as permanent investments find themselves locked in by coupling; teams that treated them as current best options find replacement straightforward. Replaceability also forces the discipline of clear interfaces, which independently improves testability and comprehension.

## Violations to detect

- Business logic that imports framework types directly rather than through an abstraction layer
- Service-to-service calls that use a vendor SDK rather than an interface that could be swapped
- Database schema types (e.g. PostgreSQL-specific arrays, MongoDB documents) leaking into domain models
- No agreed fitness function or architectural test suite that would alert the team when boundaries erode

## Good practice

- Define an anti-corruption layer at every external boundary (framework, database, third-party API)
- Write architectural fitness functions - automated tests that assert structural invariants (e.g. ArchUnit, Dependency Cruiser)
- Evaluate components on a replacement timeline, not a permanence assumption
- Document what would need to change if the component were replaced - short lists indicate good boundaries

## Sources

- Ford, Neal, Parsons, Rebecca and Kua, Patrick. *Building Evolutionary Architectures*, 2nd ed. O'Reilly, 2022. ISBN 978-1-4920-9754-9. Chapters 2-4.
- Martin, Robert C. *Clean Architecture*. Prentice Hall, 2017. ISBN 978-0-13-449416-6. Chapter 5.
