# ARCH-DATA-MAPPER - Data Mapper

**Layer:** 2 (contextual)
**Categories:** architecture, data-access, separation-of-concerns
**Applies-to:** all
**Summary:** Use a dedicated mapper to transfer data between domain objects and the database, keeping both fully independent.

## Principle

Use a dedicated Mapper object to transfer data between domain objects and the database, keeping both sides completely independent of each other. The domain object does not know how it is persisted; the database schema does not constrain the domain model's design. The Mapper is the only place that knows about both.

## Why it matters

When domain objects contain persistence logic (SQL queries, ORM annotations that drive schema, serialisation details), the domain model is constrained by the database's design. Changing the schema requires changing domain code; testing domain logic requires a database. A Data Mapper cleanly separates these concerns so each can evolve independently.

## Violations to detect

- Domain classes annotated with ORM persistence annotations (JPA `@Entity`, `@Column`; ActiveRecord `belongs_to`; Django `Model` subclasses) that couple their structure to the schema
- Domain objects with `save()`, `find()`, or `delete()` methods
- Business logic that cannot be tested without a database connection because persistence is embedded in domain objects

## Good practice

- Domain objects are plain classes (POJOs, data classes, structs) with no awareness of persistence
- Mappers (ORM configurations, repository implementations) translate between domain objects and rows/documents
- Changes to the schema require changing only the mapper, not the domain model
- Test domain logic with no database by injecting a fake repository

## Sources

- Fowler, Martin. *Patterns of Enterprise Application Architecture*. Addison-Wesley, 2002. ISBN 978-0321127426. Chapter 10, "Data Mapper."
