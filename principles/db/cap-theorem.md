# DB-CAP-THEOREM - CAP theorem - a distributed store can guarantee at most two of consistency, availability, and partition tolerance

**Layer:** 2
**Categories:** database, distributed-systems, architecture, reliability
**Applies-to:** distributed-systems, microservices, cloud-native
**Summary:** Explicitly choose between consistency and availability during partitions before a distributed system is designed.

## Principle

In any distributed data store, you can guarantee at most two of three properties simultaneously: Consistency (every read reflects the most recent write), Availability (every request receives a non-error response, though it may not be the most recent data), and Partition tolerance (the system continues operating when network partitions prevent some nodes from communicating). Because network partitions are unavoidable in distributed systems, the real choice is between consistency (CP) and availability (AP) during a partition event.

## Why it matters

Ignoring the CAP theorem leads to systems that make implicit, undocumented consistency guarantees that they cannot honour under network faults. When a partition occurs and the system's behaviour is undefined, engineers are forced to make high-pressure decisions without a pre-agreed trade-off. Explicitly choosing CP vs AP aligns the system's failure behaviour with product and business requirements before the incident.

## Violations to detect

- Distributed data stores configured to advertise strong consistency but with no mechanism to reject reads from partitioned replicas - the guarantee cannot actually be kept
- Architecture documents that choose a database without stating whether the system requires CP or AP behaviour under partition
- Multi-region deployments with synchronous replication and no defined fallback when replication lag causes write failures - implicit choice of CP without acknowledging the availability cost
- Read-your-writes requirements in a system backed by an eventually consistent store, with no sticky routing or version-checking strategy

## Good practice

- Document the explicit CP vs AP choice for every distributed data store and explain which product scenarios drove it
- For AP stores (Cassandra, DynamoDB, CouchDB), design the application to handle stale reads and conflicting writes; implement reconciliation or last-write-wins semantics
- For CP stores (HBase, Zookeeper, etcd), design the application to handle unavailability during partition events - timeouts, retries with backoff, and graceful degradation
- Revisit the choice as access patterns evolve; a store that starts as AP may need CP guarantees as regulatory or financial requirements emerge

## Sources

- Brewer, Eric A. "Towards Robust Distributed Systems." *Proceedings of the 19th Annual ACM Symposium on Principles of Distributed Computing (PODC)*, 2000. (keynote that introduced the CAP conjecture)
- Gilbert, Seth and Nancy Lynch. "Brewer's Conjecture and the Feasibility of Consistent, Available, Partition-Tolerant Web Services." *ACM SIGACT News*, vol. 33, no. 2, 2002. DOI 10.1145/564585.564601. (formal proof)
- Kleppmann, Martin. *Designing Data-Intensive Applications*. O'Reilly, 2017. ISBN 978-1-449-37332-0. Chapter 9: "Consistency and Consensus."
