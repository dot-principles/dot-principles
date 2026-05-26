# ARCH-ACTIVE-RECORD - Active Record Pattern

**Layer:** 2 (contextual)
**Categories:** architecture, data-access
**Applies-to:** all
**Summary:** Use Active Record only for simple CRUD domains where the data model and domain model are closely aligned.

## Principle

An Active Record is a domain object that wraps a single database row and includes both data and the data access logic for that row - methods like `save()`, `find()`, `delete()`. It is the appropriate pattern for simple CRUD domains where the data model and the domain model are closely aligned. It should not be used when rich domain behaviour, complex invariants, or significant business logic is needed.

## Why it matters

Active Record is a pragmatic choice for simple applications because it removes the need for a separate mapping layer. However, it tightly couples domain objects to the database schema and makes unit testing without a database very difficult. When used in domains with complex business logic, it leads to fat models that mix persistence and domain concerns, violating the Single Responsibility Principle.

## Violations to detect

- Active Record objects used in domains with complex business logic, multi-step workflows, or invariants that span multiple records
- Business rules expressed as callbacks on the Active Record's persistence lifecycle (`before_save`, `after_create`)
- Active Record objects directly used as view models or API response objects, exposing all persisted fields by default

## Good practice

- Prefer Active Record for simple CRUD scenarios in small applications or rapid prototyping
- Migrate to Data Mapper / Repository when the domain grows complex
- Clearly document the trade-off when Active Record is chosen: future developers need to know the boundary of its appropriate use
- Avoid embedding business logic in lifecycle callbacks

## Sources

- Fowler, Martin. *Patterns of Enterprise Application Architecture*. Addison-Wesley, 2002. ISBN 978-0321127426. Chapter 10, "Active Record."
