# PKG-CCP - Common Closure Principle (CCP)

**Layer:** 2 (contextual)
**Categories:** software-design, package-design, modularity, maintainability
**Applies-to:** all
**Summary:** Group into one component only the classes that change at the same time for the same reasons.

## Principle

Gather into components the classes that change for the same reasons at the same times. Separate into different components the classes that change at different times for different reasons. This is the Single Responsibility Principle applied at the component level.

## Why it matters

When a change touches many components, it requires coordinating many separate releases and re-validating many consumers. Grouping classes that change together keeps the blast radius of any change small - one reason to change means one component to release.

## Violations to detect

- A single change (e.g., a new authentication requirement) touches classes spread across many components
- Unrelated things bundled together mean that any change to one forces re-release of the whole bundle
- No discernible axis of change within a component - classes that clearly change for different reasons

## Good practice

When a change causes modifications to many components, consider regrouping the affected classes into one component. Ask: "what forces would cause this class to change, and which other classes change for the same reason?"

## Sources

- Martin, Robert C. *Agile Software Development: Principles, Patterns, and Practices*. Prentice Hall, 2002. ISBN 978-0-13-597444-5. Chapter 20.
