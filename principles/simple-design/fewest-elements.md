# SIMPLE-DESIGN-FEWEST-ELEMENTS — Fewest Elements

**Layer:** 1 (universal)
**Categories:** software-design, simplicity
**Applies-to:** all
**Summary:** Include the fewest classes and abstractions possible once tests pass, intent is clear, and duplication is removed.

## Principle

After satisfying the first three rules — passing tests, revealing intention, and removing duplication — the design should contain the fewest classes, methods, modules, and other structural elements possible. Do not add abstractions, indirections, or layers that are not justified by the other three rules. This is Beck's fourth rule, and it has the lowest priority: never sacrifice testability, clarity, or duplication removal for minimalism.

## Why it matters

Over-engineering adds complexity that makes code harder to navigate, understand, and change. Speculative abstractions, unnecessary wrapper classes, and premature generalizations all increase the surface area a developer must comprehend. Keeping the element count minimal ensures the design stays as simple as possible while still meeting the higher-priority rules.

## Violations to detect

- Wrapper classes or interfaces with only one implementation and no clear extension point
- Abstract base classes created "just in case" with no current need for polymorphism
- Layers of indirection that add no value (e.g., a service that simply delegates to another service)
- Configuration or factory classes for things that could be direct instantiation
- Speculative generality — type parameters, plugin architectures, or strategy patterns introduced before a second use case exists

## Good practice

- Start with the simplest implementation that passes tests, communicates intent, and avoids duplication
- Add abstractions only when you have a concrete, current need — not a hypothetical future one
- Regularly review existing code for elements that no longer serve a purpose and remove them
- Prefer fewer, well-named elements over many fine-grained ones when both satisfy the higher rules
- Apply YAGNI (You Aren't Gonna Need It) as a practical guide: if the only justification is "we might need it later," leave it out

## Sources

- Beck, Kent. *Extreme Programming Explained: Embrace Change*, 2nd ed. Addison-Wesley, 2004. ISBN 978-0-321-27865-4.
- Fowler, Martin. "BeckDesignRules." https://martinfowler.com/bliki/BeckDesignRules.html
