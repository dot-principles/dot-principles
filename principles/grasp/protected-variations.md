# GRASP-PROTECTED-VARIATIONS — Protected Variations

**Layer:** 2 (contextual)
**Categories:** software-design, stability, extensibility
**Applies-to:** all
**Summary:** Wrap every predicted point of variation behind a stable interface so change is confined to one boundary.

## Principle

Identify points of predicted variation or instability and assign responsibilities to create a stable interface around them. Wrap the unstable element so that variation does not propagate through the system.

## Why it matters

Every system has points of change: third-party APIs are replaced, database engines are swapped, business rules evolve. If code throughout the system depends directly on these unstable points, any change creates a wave of modifications. Protected Variations localises the impact of change to a single boundary.

## Violations to detect

- Direct usage of a third-party library's types scattered throughout business logic (no abstraction layer)
- Business logic that encodes details likely to change (tax rates, fee structures, external service contracts)
- A change to a low-level module requiring modifications in many high-level modules
- No abstraction boundary at the edge of an external system (payment provider, message broker, storage)

## Good practice

- Define your own interfaces at integration boundaries; let adapters implement them
- Isolate volatile business rules behind a policy interface or strategy
- Apply the Open/Closed Principle at identified variation points
- Use the Stable Dependencies Principle: depend in the direction of stability

## Sources

- Larman, Craig. *Applying UML and Patterns: An Introduction to Object-Oriented Analysis and Design and Iterative Development*. 3rd ed. Prentice Hall, 2004. ISBN 978-0-13-148906-6. Chapter 17.
- Martin, Robert C. *Clean Architecture*. Prentice Hall, 2017. ISBN 978-0-13-449416-6. Part IV.
