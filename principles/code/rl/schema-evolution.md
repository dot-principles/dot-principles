# CODE-RL-SCHEMA-EVOLUTION — Plan for schema evolution — design data formats for forward and backward compatibility

**Layer:** 2 (contextual)
**Categories:** reliability, distributed-systems
**Applies-to:** all
**Summary:** Design data schemas for forward and backward compatibility to enable independent service deployments.

## Principle

Data outlives code. Every data format — whether for storage, messaging, or API communication — will need to evolve as requirements change. Design schemas so that new versions of the writer can produce data that old readers can still consume (backward compatibility), and old versions of the writer produce data that new readers can handle (forward compatibility). This enables rolling deployments, independent service upgrades, and long-lived data archives.

## Why it matters

In a distributed system, you cannot upgrade all producers and consumers simultaneously. During rolling deployments, old and new versions of services coexist. If a schema change breaks compatibility, you face a coordination nightmare: every service must be upgraded in lockstep, or the system breaks. Schema evolution with compatibility guarantees allows teams to deploy independently and ensures that data written years ago remains readable by today's software.

## Violations to detect

- Schema changes that remove or rename fields without a deprecation and migration strategy
- Serialization formats (e.g., raw JSON without a schema, language-specific serialization like Java Serializable or Python pickle) that provide no evolution guarantees
- API changes deployed without versioning, breaking existing clients
- Messages or records that cannot be deserialized by a consumer running the previous version of the code

## Good practice

- Use schema evolution-friendly serialization formats such as Protocol Buffers, Avro, or Thrift, which have explicit rules for adding, removing, and renaming fields
- Add new fields as optional with sensible defaults so that old readers can ignore them and new readers handle their absence
- Never reuse field numbers or names for a different purpose — mark old fields as deprecated and reserved
- Enforce compatibility checks in CI using a schema registry or compatibility validation tool before allowing schema changes to be published

## Sources

- Kleppmann, Martin. *Designing Data-Intensive Applications: The Big Ideas Behind Reliable, Scalable, and Maintainable Systems*. O'Reilly, 2017. ISBN 978-1-449-37332-0. Chapter 4: "Encoding and Evolution."
