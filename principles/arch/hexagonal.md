# ARCH-HEXAGONAL — Hexagonal Architecture (Ports & Adapters)

**Layer:** 2 (contextual)
**Categories:** architecture, ports-and-adapters, testability
**Applies-to:** all
**Summary:** Keep the application core free of infrastructure dependencies by exposing ports implemented by swappable adapters.

## Principle

The application core (domain + use cases) has no dependency on any infrastructure technology. All dependencies point inward. The core exposes Ports — interfaces it requires or provides. Adapters implement those interfaces for specific technologies (HTTP, databases, message brokers, CLIs). Swapping a database means writing a new adapter, not touching the core.

## Why it matters

Coupling to frameworks and infrastructure makes logic hard to test in isolation and hard to migrate. Hexagonal architecture enforces the discipline that the core is oblivious to how it is invoked or what it persists to — making unit testing trivial and infrastructure replacement safe.

## Violations to detect

- Application/domain classes importing framework types (javax.persistence, Spring annotations, Flask routes, Express req/res) directly
- Business logic methods that construct database queries or make HTTP calls
- No interface boundary between the use-case layer and the infrastructure layer
- Tests of business logic that require a running database or live HTTP server

## Good practice

- Define Port interfaces in the domain/application layer
- Implement Adapters in a separate infrastructure layer
- Depend on ports, inject adapters
- Test the core with in-memory adapter stubs — no I/O required

## Sources

- Cockburn, Alistair. "Hexagonal Architecture." alistair.cockburn.us/hexagonal-architecture/ (2005, accessed 2026-03-17).
- Freeman, Steve & Pryce, Nat. *Growing Object-Oriented Software, Guided by Tests*. Addison-Wesley, 2009. ISBN 978-0321503626.
