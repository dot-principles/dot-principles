# DDD-SHARED-KERNEL — Shared Kernel

**Layer:** 2 (contextual)
**Categories:** architecture, domain-driven-design, integration
**Applies-to:** all
**Summary:** Share only a minimal, explicitly agreed-upon subset of the domain model and require bilateral consent for any change.

## Principle

A Shared Kernel is a small, explicitly agreed-upon subset of the domain model that two or more Bounded Contexts share. Any change to the Shared Kernel requires bilateral coordination and agreement between the teams that own the participating contexts — no team may change it unilaterally. The kernel should be kept as small as possible to minimise coordination cost.

## Why it matters

Sharing code between bounded contexts is tempting but dangerous: it creates tight coupling between teams and contexts. A Shared Kernel makes that coupling explicit and puts governance around it. Without this governance, shared code grows organically as teams add to it for their own needs, and changes in it break consumers without warning.

## Violations to detect

- Shared library or package that grows continuously as each consuming team adds domain types it needs, with no governance over what belongs in the shared kernel
- Changes to shared domain types made without coordinating with all consuming teams
- Shared kernel containing logic specific to one context rather than genuinely shared domain concepts

## Good practice

- Define the Shared Kernel boundary explicitly in a dedicated package or module with a clear owner
- Establish a change process: no changes without both teams reviewing and agreeing
- Keep the Shared Kernel small — common Value Objects, shared IDs, common events
- Treat the kernel as a highly stable, conservative API

## Sources

- Evans, Eric. *Domain-Driven Design: Tackling Complexity in the Heart of Software*. Addison-Wesley, 2003. ISBN 978-0321125217. Chapter 14.
