# DB-POLYGLOT-PERSISTENCE - Polyglot persistence - use the most appropriate storage technology for each distinct access pattern

**Layer:** 2
**Categories:** database, architecture, scalability
**Applies-to:** microservices, large-scale-systems
**Summary:** Choose the storage technology whose data model best fits each distinct access pattern in the system.

## Principle

Do not force all data into a single storage technology. Different data access patterns have fundamentally different requirements: document stores handle flexible schemas well, graph databases excel at relationship traversal, time-series databases compress and query temporal data efficiently, full-text search engines index and rank text at scale. Use the technology whose data model, query language, and scaling characteristics best match each distinct data problem in the system.

## Why it matters

A single relational database used for everything is often adequate for small systems but becomes a constraint as the system grows. Storing social graph data in SQL requires expensive recursive joins; storing time-series metrics in a document store wastes storage and produces slow aggregations. Polyglot persistence allows each component to use the store it is genuinely best suited to, but it introduces operational complexity - more systems to provision, monitor, backup, and reason about.

## Violations to detect

- Using a relational database for full-text search by implementing LIKE queries on large text columns - produces full table scans instead of inverted index lookups
- Storing time-series data (metrics, sensor readings) in a general-purpose relational or document database when a time-series store (InfluxDB, TimescaleDB, Prometheus) would reduce storage by an order of magnitude and serve range queries natively
- Adding a document store when a relational model with JSONB columns would serve the same purpose with one fewer operational dependency
- Adopting polyglot persistence at the beginning of a project before validating that a single store is genuinely insufficient - premature complexity

## Good practice

- Start with a single, well-understood relational database; introduce additional stores only when a concrete, measured limitation justifies the operational overhead
- Document the rationale for each storage technology choice alongside the access patterns it was chosen to serve
- Each microservice owns its own data store; the choice of store is an internal implementation detail, not a shared dependency
- Ensure each store has a backup, restore, and failover strategy before using it to store production data

## Sources

- Fowler, Martin and Pramod Sadalage. *NoSQL Distilled: A Brief Guide to the Emerging World of Polyglot Persistence*. Addison-Wesley, 2012. ISBN 978-0-321-82662-6. Chapter 1: "Why NoSQL?" and Chapter 2: "Aggregate Data Models."
- Newman, Sam. *Building Microservices*, 2nd ed. O'Reilly, 2021. ISBN 978-1-492-03402-5. Chapter 4: "Microservice Communication Styles."
