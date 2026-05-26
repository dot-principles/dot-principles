# DB-CQRS - CQRS - separate read and write models when they have diverging requirements

**Layer:** 2
**Categories:** database, architecture, scalability, performance
**Applies-to:** distributed-systems, microservices, high-load-systems
**Summary:** Separate command and query models when read and write paths have different scaling or structural requirements.

## Principle

Command Query Responsibility Segregation (CQRS) separates the model used to mutate state (commands) from the model used to query state (queries). The command side applies business rules and writes to a normalised, authoritative store. The query side reads from one or more denormalised, pre-projected read models optimised for specific query shapes. Use CQRS when the read and write models have different scaling, performance, or structural requirements - not by default.

## Why it matters

A single data model that must satisfy both writes and reads ends up as a compromise that is good at neither. Write models need consistency and constraint enforcement; read models need denormalized, join-free projections. Forcing both onto one model produces either slow writes (over-indexed) or slow reads (under-indexed). CQRS allows each model to be optimised independently, but introduces eventual consistency between the two sides that must be explicitly managed.

## Violations to detect

- Using CQRS as the default approach for simple CRUD applications where read and write volumes are comparable - adds complexity without benefit
- Command handlers that perform complex read queries to populate response objects rather than delegating to the read model
- Read models that are updated synchronously inside the command transaction, negating the scalability benefit of separation
- No strategy for handling the eventual consistency window between command execution and read model update (stale reads, missing records)

## Good practice

- Apply CQRS only when there is a measurable divergence in read and write volume, model shape, or scaling requirements - verify the need before adopting it
- Project the read model asynchronously from domain events (event-driven projection) to keep the command and query sides decoupled
- Document the consistency model explicitly: how stale can the read model be, and how does the application behave when a write is not yet visible in the read model?
- Start with a simple shared model and introduce CQRS as a refactoring when load data justifies it, not as an upfront architectural decision

## Sources

- Young, Greg. "CQRS Documents." https://cqrs.files.wordpress.com/2010/11/cqrs_documents.pdf (accessed 2026-03-16).
- Fowler, Martin. "CQRS." martinfowler.com, 2011. https://martinfowler.com/bliki/CQRS.html (accessed 2026-03-16).
- Vernon, Vaughn. *Implementing Domain-Driven Design*. Addison-Wesley, 2013. ISBN 978-0-321-83457-7. Chapter 4: "Architecture."
