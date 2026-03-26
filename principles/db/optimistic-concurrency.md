# DB-OPTIMISTIC-CONCURRENCY — Optimistic concurrency control — detect write conflicts at commit time rather than blocking readers

**Layer:** 2
**Categories:** database, concurrency, transactions, performance
**Applies-to:** all
**Summary:** Use optimistic concurrency in read-heavy workloads; detect conflicts at commit time and retry rather than locking.

## Principle

Allow multiple transactions to read and prepare writes concurrently without acquiring locks. At commit time, verify that the data read during the transaction has not been modified by another committed transaction; if it has, abort and retry. Optimistic concurrency control (OCC) outperforms pessimistic locking in read-heavy, low-conflict workloads — it eliminates lock contention and deadlocks at the cost of occasional retries.

## Why it matters

Pessimistic locking serialises concurrent readers unnecessarily: a long-running read holds locks that block writers, and vice versa. Under high concurrency this produces lock queues, deadlocks, and timeout errors that users experience as slow or failed operations. Optimistic concurrency removes these locks from the read path; retries only occur when conflicts are detected, and in most workloads conflicts are rare.

## Violations to detect

- Using SELECT FOR UPDATE (pessimistic row lock) on read-heavy paths where conflicts are rare, introducing unnecessary serialisation and deadlock risk
- No version column or timestamp field on entities that are subject to concurrent updates — concurrent writes silently overwrite each other with the last writer winning
- Retrying failed OCC transactions indefinitely without a bounded retry limit or backoff — can produce livelock under genuinely high conflict
- Mixing optimistic and pessimistic locking strategies on the same entity without documentation — creates unpredictable behaviour under concurrency

## Good practice

- Add a `version` integer or `updated_at` timestamp column to every entity subject to concurrent mutation; increment or update it on every write
- In the UPDATE statement, include `WHERE id = ? AND version = ?`; if zero rows are affected, a conflict occurred — retry the transaction
- Use ORM-level optimistic locking (Hibernate `@Version`, ActiveRecord optimistic locking, SQLAlchemy `version_id_col`) rather than re-implementing it manually
- Reserve pessimistic locking (`SELECT FOR UPDATE`) for genuinely high-conflict operations where the cost of repeated retries exceeds the cost of holding a lock

## Sources

- Kung, H.T. and John T. Robinson. "On Optimistic Methods for Concurrency Control." *ACM Transactions on Database Systems*, vol. 6, no. 2, 1981. DOI 10.1145/319566.319567.
- Gray, Jim and Andreas Reuter. *Transaction Processing: Concepts and Techniques*. Morgan Kaufmann, 1992. ISBN 978-1-558-60190-1. Chapter 7: "Isolation Concepts."
- Kleppmann, Martin. *Designing Data-Intensive Applications*. O'Reilly, 2017. ISBN 978-1-449-37332-0. Chapter 7: "Transactions."
