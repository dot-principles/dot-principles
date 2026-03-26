# GRASP-POLYMORPHISM — Polymorphism

**Layer:** 2 (contextual)
**Categories:** software-design, extensibility
**Applies-to:** all
**Summary:** Replace type-based conditionals with polymorphic dispatch; let each type handle its own variant behavior.

## Principle

When behaviour varies by type, assign responsibility for the variation to the types themselves using polymorphic operations, rather than asking the caller to identify the type and conditionally execute variant logic.

## Why it matters

Type-based conditional logic (`if/else` or `switch` on type) must be updated in every location whenever a new type is added. Polymorphism encapsulates type-specific behaviour in the type itself, making the system open to new types without modifying existing callers.

## Violations to detect

- `switch` or `if/else` chains that dispatch behaviour based on a type field, enum, or `instanceof` check
- The same type-dispatching logic duplicated in multiple places
- Adding a new type requires modifying multiple existing classes
- An explicit type tag field (e.g., `String type = "CREDIT"`) used instead of a class hierarchy

## Good practice

- Replace type checks with virtual dispatch: define a common interface, let each type implement its variant
- Use the strategy pattern when the variation is behaviour injected at runtime
- Use the visitor pattern when you need to add operations to a stable type hierarchy without modifying it
- Introduce polymorphism at the second variation — not prematurely at the first

## Sources

- Larman, Craig. *Applying UML and Patterns: An Introduction to Object-Oriented Analysis and Design and Iterative Development*. 3rd ed. Prentice Hall, 2004. ISBN 978-0-13-148906-6. Chapter 17.
- Gamma, Erich, Richard Helm, Ralph Johnson, and John Vlissides. *Design Patterns*. Addison-Wesley, 1994. ISBN 978-0-20-163361-0.
