# DB-EVENTUAL-CONSISTENCY — Eventual consistency — distributed systems that favour availability must explicitly manage staleness

**Layer:** 2
**Categories:** database, distributed-systems, reliability, architecture
**Applies-to:** distributed-systems, microservices, cloud-native
**Summary:** Design systems for eventual consistency explicitly; implement conflict detection and read guarantees where required.

## Principle

In distributed systems that prioritise availability over strong consistency (per the CAP theorem), replicas may temporarily diverge, and reads may return stale data. This is "eventual consistency": if no new writes occur, all replicas will converge to the same state eventually. Systems built on eventually consistent stores must be explicitly designed for this model — conflict detection, read-your-writes routing, monotonic reads, and causal consistency must be considered and implemented where required.

## Why it matters

Treating an eventually consistent store as if it were strongly consistent produces silent data races: a user writes data and immediately reads back a stale version, a record deleted by one service is served as present by another, and concurrent writes produce conflicting states that neither the database nor the application resolves. These bugs are difficult to reproduce, hard to debug, and often discovered only from customer complaints.

## Violations to detect

- Reading from the same database immediately after writing without accounting for replication lag — assuming read-your-writes when the store does not guarantee it
- Services that treat "no record found" on an eventually consistent store as authoritative without considering that the record may simply not have replicated yet
- Concurrent write paths with no conflict detection or last-write-wins policy, allowing conflicting updates to silently overwrite each other
- No documentation of the consistency model for each data store used — developers assume stronger guarantees than the store provides

## Good practice

- Explicitly document the consistency model for every data store in the system and code defensively against the actual guarantees, not stronger ones
- For read-your-writes requirements, route the user's reads to the same replica they wrote to, use session tokens tied to a write version, or read from the primary
- Design conflict resolution explicitly: last-write-wins (with vector clocks or timestamps), merge functions, or application-level conflict detection
- Use causal consistency tokens (supported by MongoDB, Cosmos DB, and others) when operations must respect a happened-before relationship

## Sources

- Vogels, Werner. "Eventually Consistent." *ACM Queue*, vol. 6, no. 6, 2008. DOI 10.1145/1466443.1466448.
- Pritchett, Dan. "BASE: An Acid Alternative." *ACM Queue*, vol. 6, no. 3, 2008. DOI 10.1145/1394127.1394128.
- Kleppmann, Martin. *Designing Data-Intensive Applications*. O'Reilly, 2017. ISBN 978-1-449-37332-0. Chapter 5: "Replication" and Chapter 9: "Consistency and Consensus."
