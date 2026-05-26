# ARCH-SERVICE-BOUNDARIES - Define and enforce explicit service boundaries

**Layer:** 2 (contextual)
**Categories:** architecture, distributed-systems, domain-driven-design
**Applies-to:** microservices, distributed-systems, service-oriented
**Summary:** Own data exclusively within each service and communicate across boundaries only through versioned explicit contracts.

## Principle

Every service owns its data and exposes it only through a defined interface - never through shared databases, shared memory, or direct access to another service's internal model. Boundaries are drawn along business capability lines, not technical layer lines. Services within a boundary are cohesive; services across a boundary are loosely coupled through versioned, explicit contracts.

## Why it matters

Shared databases are the most common way that microservices lose their independence. When two services share a table, a schema change in one breaks the other - the systems are logically separate but physically coupled. Explicit contracts force teams to think about versioning, backward compatibility, and consumer impact before making changes rather than discovering the consequences in production.

## Violations to detect

- Two or more services reading from or writing to the same database table
- A service calling another service's internal API rather than its published contract
- Domain objects crossing service boundaries without translation (shared library of domain types)
- Services deployed together because they cannot function independently
- No contract test (consumer-driven or provider-driven) verifying the boundary

## Good practice

- Each service has its own database schema; data sharing happens via events or API calls
- Use consumer-driven contract testing (Pact, Spring Cloud Contract) at every service boundary
- Publish and version contracts explicitly; follow semantic versioning for breaking changes
- Map service boundaries to bounded contexts in the domain model

## Sources

- Newman, Sam. *Building Microservices*, 2nd ed. O'Reilly, 2021. ISBN 978-1-4920-3442-1. Chapters 2-4.
- Evans, Eric. *Domain-Driven Design*. Addison-Wesley, 2003. ISBN 978-0-3211-2521-7. Part IV.
