# ARCH-ANTI-CORRUPTION-LAYER — Anti-Corruption Layer

**Layer:** 2 (contextual)
**Categories:** architecture, domain-driven-design, integration
**Applies-to:** all
**Summary:** Introduce a translation layer at every external integration boundary to protect your domain model from leakage.

## Principle

When integrating with an external system or a bounded context whose domain model differs from yours, introduce a dedicated translation layer — the Anti-Corruption Layer (ACL) — at the boundary. The ACL translates between the external model and your model, so your domain remains internally consistent and isolated from changes or design choices in the external system.

## Why it matters

Directly importing an external system's model forces your domain to conform to foreign concepts, naming, and structure. As the external system evolves, its design decisions "corrupt" your model and force you to change domain code that has nothing to do with the external system's concerns. An ACL acts as a firewall: external changes are absorbed at the boundary, not propagated throughout your domain.

## Violations to detect

- Domain classes or services that import types directly from an external system's library or API client
- Domain logic that speaks the external system's vocabulary (field names, status codes, error types) rather than your own Ubiquitous Language
- External API response objects used directly as arguments to domain methods
- No translation step between external events/messages and domain events

## Good practice

- Define the ACL as an explicit module or package with a one-way dependency: it knows about both the external model and your domain model, but neither side knows about the ACL's internals
- Write tests that verify translation correctness independently of both sides
- Treat the ACL as a versioned contract — when the external API changes, only the ACL needs updating

## Sources

- Evans, Eric. *Domain-Driven Design: Tackling Complexity in the Heart of Software*. Addison-Wesley, 2003. ISBN 978-0321125217. Chapter 14.
