# ARCH-UNIT-OF-WORK — Unit of Work

**Layer:** 2 (contextual)
**Categories:** architecture, data-access, reliability
**Applies-to:** all
**Summary:** Track all domain changes in a Unit of Work and commit them in one coordinated database transaction at completion.

## Principle

Track all domain objects that are created, modified, or deleted during a business operation in a single Unit of Work object. At commit time, the Unit of Work performs a single coordinated write — inserting, updating, and deleting all changed objects in one transaction. No individual operation writes to the database until the Unit of Work is committed.

## Why it matters

Issuing one database write per object change is both inefficient and fragile: partial failures leave the database in an inconsistent state, and performance suffers from N round trips. A Unit of Work batches all changes and commits them atomically, giving all-or-nothing guarantees and reducing database round trips to one per business operation.

## Violations to detect

- Code that calls `save()` / `update()` / `insert()` on individual objects one at a time within a business operation, without coordinating all writes in a single transaction
- Business operations that can partially succeed — some objects written, others not — because there is no encompassing transaction
- ORM sessions or transaction scopes opened and closed inside individual repository methods rather than at the service/use-case boundary

## Good practice

- Open a Unit of Work / transaction at the service-layer boundary; register all domain objects changed during the operation; commit or roll back as a single unit
- Let the ORM (JPA, Entity Framework, SQLAlchemy) manage the identity map and dirty tracking within the Unit of Work
- Never commit inside a loop — collect all changes first, then flush

## Sources

- Fowler, Martin. *Patterns of Enterprise Application Architecture*. Addison-Wesley, 2002. ISBN 978-0321127426. Chapter 11, "Unit of Work."
