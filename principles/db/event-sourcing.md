# DB-EVENT-SOURCING - Event sourcing - persist state as an immutable log of domain events

**Layer:** 2
**Categories:** database, architecture, reliability, auditability
**Applies-to:** event-driven, domain-driven-design, audit-critical-systems
**Summary:** Store the full sequence of immutable events rather than current state; derive state by replaying the log.

## Principle

Instead of storing the current state of an entity, store the full sequence of events that produced that state. Each event is an immutable, timestamped fact - "OrderPlaced", "ItemAdded", "PaymentApplied" - appended to an event log. Current state is derived by replaying all events for an entity. The event log is the system of record; projections and read models are derived views that can be rebuilt at any time from the log.

## Why it matters

Mutable state storage discards history - the database shows what is, not how it got there. Debugging, auditing, and root-cause analysis require reconstructing a sequence of events that was never recorded. Event sourcing makes the complete history a first-class artefact: every state transition is recorded, every past state is replayable, and temporal queries ("what did this order look like at 3pm?") are trivial.

## Violations to detect

- Storing current state only (e.g. `status = 'SHIPPED'`) when the history of transitions is required for audit, debugging, or dispute resolution
- Mutating event records after they have been stored - events are immutable facts; modifying them corrupts the historical record
- Event stores without event versioning or schema evolution strategy - events written today must remain readable when the schema changes in future
- Rebuilding current state from events on every request without snapshotting for long-lived entities - performance degrades as the event log grows

## Good practice

- Name events as past-tense facts that describe what happened, not what should happen: `OrderShipped`, not `ShipOrder`
- Implement snapshots at configurable intervals for aggregates with long event histories, so state reconstruction does not require replaying the full log
- Version event schemas using an event registry; define upgrade functions that translate old event versions to the current schema when replaying
- Separate the event store from read projections; projections are rebuilt from events whenever required - treat them as caches, not sources of truth

## Sources

- Young, Greg. "Event Sourcing." https://cqrs.files.wordpress.com/2010/11/cqrs_documents.pdf (accessed 2026-03-16).
- Fowler, Martin. "Event Sourcing." martinfowler.com, 2005. https://martinfowler.com/eaaDev/EventSourcing.html (accessed 2026-03-16).
- Vernon, Vaughn. *Implementing Domain-Driven Design*. Addison-Wesley, 2013. ISBN 978-0-321-83457-7. Chapter 8: "Domain Events."
