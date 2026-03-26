# DB-ACID — ACID properties — guarantee correctness of every database transaction

**Layer:** 1
**Categories:** database, transactions, reliability, correctness
**Applies-to:** all
**Summary:** Ensure every database transaction satisfies Atomicity, Consistency, Isolation, and Durability guarantees.

## Principle

Every database transaction must satisfy four properties: Atomicity (all operations in the transaction succeed or none do), Consistency (a transaction brings the database from one valid state to another, respecting all defined constraints), Isolation (concurrent transactions execute as if they were serial, with no partial reads of another transaction's uncommitted work), and Durability (once a transaction is committed, its effects survive crashes and power failures). These four guarantees together define what it means for a database operation to be "correct".

## Why it matters

Without ACID guarantees, concurrent writes produce phantom reads and dirty data, partial failures leave databases in inconsistent states, and hardware crashes silently corrupt records. Applications built on a non-ACID store must re-implement these guarantees in application code — an error-prone exercise that most teams get wrong under edge cases like sudden process death or network partition.

## Violations to detect

- Performing a multi-step operation (debit account A, credit account B) without wrapping it in a single transaction, leaving the database inconsistent if the process dies between steps
- Choosing a database engine or isolation level that silently weakens ACID guarantees (e.g. MySQL MyISAM, or READ UNCOMMITTED isolation) without explicitly documenting the trade-off
- Relying on application-level "compensating" logic to undo partial writes rather than using database transactions
- Running schema migrations outside a transaction block, leaving the schema in an intermediate state if the migration fails

## Good practice

- Always wrap logically atomic multi-step operations in a single database transaction; commit only when all steps succeed
- Choose the appropriate isolation level explicitly and document it — READ COMMITTED for typical OLTP, SERIALIZABLE for financial operations
- Use database constraints (NOT NULL, UNIQUE, foreign keys, CHECK) to enforce the Consistency guarantee at the data layer, not just the application layer
- Verify transaction durability settings in your database configuration (e.g. `fsync=on` in PostgreSQL, `innodb_flush_log_at_trx_commit=1` in MySQL)

## Sources

- Gray, Jim and Andreas Reuter. *Transaction Processing: Concepts and Techniques*. Morgan Kaufmann, 1992. ISBN 978-1-558-60190-1. Chapter 4: "ACID Properties."
- Haerder, T. and A. Reuter. "Principles of Transaction-Oriented Database Recovery." *ACM Computing Surveys*, vol. 15, no. 4, 1983. DOI 10.1145/289.291. (coined the ACID acronym)
