# ARCH-TRANSACTION-SCRIPT - Transaction Script

**Layer:** 2 (contextual)
**Categories:** architecture, domain-logic
**Applies-to:** all
**Summary:** Use Transaction Script only for simple low-complexity domains; avoid it as business logic grows and duplicates.

## Principle

A Transaction Script organises business logic as a single procedure per use case - one script per transaction. Each script retrieves inputs, executes the business logic procedurally, and writes the result back to the database. It is appropriate for simple, low-complexity domains; it degrades into unmaintainable spaghetti as complexity grows and logic is duplicated across scripts.

## Why it matters

Transaction Script is the default pattern for most developers learning to build software. It is straightforward for simple cases but does not scale with domain complexity: shared logic is copy-pasted across scripts, invariants are enforced inconsistently, and the lack of a domain model means there is nowhere to centralise domain concepts. Recognising Transaction Script as a deliberate choice - and knowing when to migrate to a Domain Model - is essential for long-term maintainability.

## Violations to detect

- Business logic duplicated across multiple service or handler methods that all operate on the same underlying concepts
- No domain model: all business logic in service methods that directly manipulate database records
- Invariants enforced differently depending on which entry point is used
- Complex conditional logic in a single service method that should be expressed as domain objects with polymorphism

## Good practice

- Use Transaction Script for genuinely simple CRUD workflows where the domain logic is minimal
- Extract shared logic into helper functions or a Domain Model as soon as duplication or complexity appears
- Treat the presence of copy-pasted logic across scripts as the signal to refactor toward a domain model
- Document the choice of Transaction Script and its complexity threshold

## Sources

- Fowler, Martin. *Patterns of Enterprise Application Architecture*. Addison-Wesley, 2002. ISBN 978-0321127426. Chapter 9, "Transaction Script."
