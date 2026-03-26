# GRASP-PURE-FABRICATION — Pure Fabrication

**Layer:** 2 (contextual)
**Categories:** software-design, responsibility-assignment
**Applies-to:** all
**Summary:** Invent infrastructure classes with no domain equivalent to isolate technical concerns and keep domain objects clean.

## Principle

When no domain class is a suitable candidate for a responsibility — because assigning it there would violate High Cohesion or Low Coupling — invent a class that does not represent a domain concept but exists solely to fulfil the design need.

## Why it matters

Forcing every responsibility onto domain objects leads to bloated, low-cohesion domain classes. Pure Fabrication allows infrastructure and coordination concerns (persistence, logging, caching, formatting) to be isolated in dedicated classes, keeping domain objects clean and focused.

## Violations to detect

- Domain classes (e.g., `Order`, `Customer`) accumulating persistence, serialisation, or notification logic
- Business objects with methods that exist for technical reasons rather than domain reasons
- Heavy coupling between domain objects and infrastructure because "the domain object is the nearest class"
- God-service classes that accumulate every operation that doesn't fit elsewhere

## Good practice

- Create a `CustomerRepository` (pure fabrication) to handle persistence, leaving `Customer` focused on domain behaviour
- Create a `PaymentGatewayAdapter` to handle external payment API calls
- Name pure fabrications by their role, not by a domain concept they don't represent
- Accept that some classes will not map to domain concepts — that is intentional

## Sources

- Larman, Craig. *Applying UML and Patterns: An Introduction to Object-Oriented Analysis and Design and Iterative Development*. 3rd ed. Prentice Hall, 2004. ISBN 978-0-13-148906-6. Chapter 17.
