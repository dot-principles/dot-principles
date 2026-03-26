# DDD-BOUNDED-CONTEXT — Bounded Context

**Layer:** 2 (contextual)
**Categories:** domain-modeling, domain-driven-design
**Applies-to:** all
**Summary:** Define explicit model boundaries and map inter-context relationships rather than forcing a single unified model.

## Principle

A Bounded Context is an explicit boundary within which a particular domain model applies. The same real-world concept may be represented differently in different Bounded Contexts — and that is intentional. Rather than forcing a single unified model across an entire system, define clear boundaries where each model is internally consistent, and establish explicit mappings (context maps) for how models relate across boundaries.

## Why it matters

Large systems that attempt to maintain a single, all-encompassing domain model inevitably produce a tangled "Big Ball of Mud" where every change risks unintended side effects across unrelated parts of the system. Bounded Contexts allow teams to evolve their models independently, reduce coupling between subsystems, and prevent one team's modeling choices from corrupting another's. Without explicit boundaries, model concepts become overloaded and lose their precision.

## Violations to detect

- A single domain class that tries to serve multiple contexts (e.g., a `Product` class used identically in catalog, pricing, and shipping, growing increasingly bloated)
- Shared database tables that couple different subsystems through a common schema with no translation layer
- Code that imports domain classes from another module or service without an explicit anti-corruption layer or translation
- Absence of any documented context map showing how different parts of the system relate

## Good practice

- Draw explicit boundaries around each model and define them in terms of team ownership, code modules, or deployable services
- Create a Context Map that documents the relationships between Bounded Contexts (e.g., Shared Kernel, Customer-Supplier, Conformist, Anti-Corruption Layer)
- Use separate model classes in each context even for the same real-world concept, with explicit translation at the boundary
- Align Bounded Contexts with team boundaries where possible to reduce coordination overhead

## Sources

- Evans, Eric. *Domain-Driven Design: Tackling Complexity in the Heart of Software*. Addison-Wesley, 2003. ISBN 978-0-321-12521-7. Chapter 14.
