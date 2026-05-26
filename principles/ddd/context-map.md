# DDD-CONTEXT-MAP - Context Map

**Layer:** 2 (contextual)
**Categories:** architecture, domain-driven-design, integration
**Applies-to:** all
**Summary:** Document explicit relationships between Bounded Contexts using a Context Map with named integration patterns.
**Audit-scope:** limited - the relationship type (Conformist vs ACL vs Partnership) is a team decision; what is detectable in code is whether a translation layer exists at all.

## Principle

A Context Map documents all Bounded Contexts in the system and the relationships between them. Each relationship has an explicit type - Partnership, Shared Kernel, Customer-Supplier, Conformist, Anti-Corruption Layer, Open Host Service, or Published Language - that describes the nature of the integration and the power balance between teams. The Context Map makes integration assumptions explicit and visible.

## Why it matters

Integration between Bounded Contexts is the most dangerous source of hidden coupling in large systems. Without a Context Map, teams are unaware of the relationships and dependencies between their contexts - integration happens through shared databases, copy-pasted types, or undocumented implicit contracts. The map makes these relationships explicit so they can be deliberately managed and evolved.

## Violations to detect

- Integration between bounded contexts through a shared database table with no translation layer
- Code importing types from another bounded context's internal module without an explicit contract
- No documented mapping of relationships between contexts, leaving integration patterns implicit and inconsistent
- Context relationships changing without the affected teams being aware of the dependency

## Good practice

- Draw the Context Map before writing integration code
- Assign an explicit relationship type to every context-to-context integration
- Review the Context Map when team structures change - Conway's Law means team changes alter effective context boundaries
- Store the Context Map as an ADR or a versioned diagram in the repository

## Sources

- Evans, Eric. *Domain-Driven Design: Tackling Complexity in the Heart of Software*. Addison-Wesley, 2003. ISBN 978-0321125217. Chapter 14.
