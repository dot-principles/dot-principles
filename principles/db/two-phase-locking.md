# DB-TWO-PHASE-LOCKING — Two-phase locking — acquire all locks before releasing any to guarantee serializability

**Layer:** 2
**Categories:** database, concurrency, transactions, correctness
**Applies-to:** relational-databases, high-conflict-systems
**Summary:** Acquire all locks before releasing any; keep transactions short to prevent deadlocks and serializability violations.

## Principle

Two-Phase Locking (2PL) is the standard protocol for achieving conflict-serializable transaction schedules. A transaction operates in two phases: a growing phase in which it acquires locks (shared for reads, exclusive for writes) and never releases any, followed by a shrinking phase in which it releases locks and never acquires new ones. This strict ordering guarantees that no two concurrent transactions can interleave in a way that produces a non-serializable result.

## Why it matters

Without a locking protocol, concurrent transactions can interleave to produce anomalies — dirty reads, non-repeatable reads, phantom reads, and lost updates — that violate application invariants. 2PL prevents all of these at the cost of reduced concurrency: transactions that need the same data must wait for each other. Understanding 2PL explains why database isolation levels exist, what deadlocks are and why they occur, and why long-running transactions are expensive.

## Violations to detect

- Long-running transactions that hold locks for the duration of a slow computation or external HTTP call, blocking all other transactions that need the same rows
- Transactions that read a resource, perform a lengthy operation, then write back — a lost update anomaly that 2PL under REPEATABLE READ would prevent but READ COMMITTED would not
- Application-managed lock sequences that differ between code paths — if two code paths lock tables A then B and B then A respectively, they will deadlock under concurrent execution
- Choosing SERIALIZABLE isolation without understanding its performance impact — 2PL under SERIALIZABLE holds range locks that block inserts into predicate ranges

## Good practice

- Understand the isolation level each database operation runs under and match it to the anomaly tolerance of the business operation
- Keep transactions short: acquire locks, perform the minimal necessary work, commit; avoid network calls, user interaction, or slow computations inside a transaction
- Establish a consistent lock ordering across all code paths that access multiple tables or rows to prevent deadlocks
- Use advisory locks (Postgres `pg_advisory_lock`) for application-level serialisation when row-level 2PL is too coarse or when coordinating distributed operations

## Sources

- Gray, Jim. "Notes on Data Base Operating Systems." *Operating Systems: An Advanced Course*, Lecture Notes in Computer Science vol. 60. Springer, 1978. ISBN 978-3-540-08755-7.
- Gray, Jim and Andreas Reuter. *Transaction Processing: Concepts and Techniques*. Morgan Kaufmann, 1992. ISBN 978-1-558-60190-1. Chapter 7: "Isolation Concepts."
