# CODE-RL-CONSISTENCY-MODELS - Choose consistency models explicitly - strong vs. eventual

**Layer:** 2 (contextual)
**Categories:** reliability, distributed-systems
**Applies-to:** all
**Summary:** Choose consistency models explicitly per operation based on correctness requirements, not by accident.

## Principle

Distributed systems must make explicit trade-offs between consistency, availability, and partition tolerance. Do not default to a consistency model by accident - choose it deliberately based on the business requirements of each operation. Some operations (e.g., financial transactions, inventory reservations) require strong consistency, while others (e.g., user profile updates, recommendation feeds) can tolerate eventual consistency. Making this choice explicit prevents both unnecessary performance costs and subtle data correctness bugs.

## Why it matters

Strong consistency provides the simplest programming model - every read sees the latest write - but it comes at the cost of latency and availability during network partitions. Eventual consistency improves availability and performance but introduces the possibility of stale reads, conflicts, and temporary anomalies that application code must handle. Choosing the wrong model leads either to an over-engineered system that sacrifices availability for consistency it does not need, or to a system that silently serves stale or conflicting data for operations that require correctness.

## Violations to detect

- Data stores or replication strategies chosen without documenting or discussing the consistency model they provide
- Application code that assumes strong consistency when reading from an eventually consistent store (e.g., read-after-write without causal consistency)
- Critical business operations (payments, inventory) implemented on top of eventually consistent storage without compensation or conflict-resolution logic
- Distributed caches used without considering staleness windows or invalidation strategies

## Good practice

- Document the consistency requirement for each data entity or operation as part of the system design
- Use strong consistency (linearizability, serializable transactions) for operations where correctness is more important than latency
- Use eventual consistency for operations that can tolerate temporary staleness, and design the user experience to accommodate it (e.g., "your changes may take a moment to appear")
- When using eventual consistency, implement conflict detection and resolution strategies - last-writer-wins, version vectors, or application-level merge logic

## Sources

- Kleppmann, Martin. *Designing Data-Intensive Applications: The Big Ideas Behind Reliable, Scalable, and Maintainable Systems*. O'Reilly, 2017. ISBN 978-1-449-37332-0. Chapter 5: "Replication." Chapter 9: "Consistency and Consensus."
