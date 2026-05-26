# CODE-SMELLS-DATA-CLASS - Data Class

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, object-oriented
**Applies-to:** all
**Summary:** Give data classes meaningful behavior; eliminate passive data holders that scatter logic into other classes.

## Principle

A Data Class is a class that contains only fields and the getters and setters for them, and nothing else. It is a passive data holder with no real behavior of its own. Other classes use data classes as data bags, doing all the work externally - a classic symptom of an anemic domain model.

## Why it matters

Data classes push logic into whatever code uses them, scattering related behavior across the codebase and violating Tell Don't Ask. The class that owns the data should typically own the behavior that operates on that data. Data classes also expose all their state, making encapsulation impossible.

## Violations to detect

- Classes with only fields, constructors, and getters/setters - no methods with real logic
- Logic that could be a method on Class A is instead written in Class B, which calls A's getters
- Domain objects with no behavior (anemic domain model), all logic in service classes
- DTOs used as domain objects rather than just as transfer structures

## Good practice

- Move behavior that operates exclusively on a data class's fields into that class
- Accept that some classes are legitimately passive (DTOs, value objects, records for data transfer) - the smell applies to domain-layer classes that should have behavior
- Start by moving the most obvious operations: comparisons, calculations, validations that only use the class's own data

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
