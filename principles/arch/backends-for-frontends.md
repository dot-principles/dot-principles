# ARCH-BACKENDS-FOR-FRONTENDS - Backends for Frontends (BFF)

**Layer:** 2 (contextual)
**Categories:** architecture, api-design, microservices
**Applies-to:** all
**Summary:** Create a dedicated backend service per client type; never build one general-purpose API for all clients.

## Principle

Create a dedicated backend service for each distinct client type (web browser, mobile app, third-party API consumer) rather than a single general-purpose API that tries to serve all clients. Each BFF is owned by the team that owns the frontend it serves and tailors its response shapes, aggregation, and caching to the specific needs of that client.

## Why it matters

A single shared backend accumulates per-client conditional logic - `if (client == "mobile") { ... }` - that makes the API harder to evolve and creates accidental coupling between unrelated frontends. One frontend's performance requirements or data-shape preferences force compromises on all others. A BFF gives each client team autonomy to evolve their API contract without coordinating with unrelated clients.

## Violations to detect

- A single API handler containing conditional branches that return different response shapes depending on a client identifier in the request header
- API response payloads containing fields that are used only by one of several consumer types
- API versioning driven by the conflicting needs of different client types rather than by breaking changes in the domain

## Good practice

- Each BFF is responsible for aggregating calls to downstream services and shaping the response for its specific client
- BFFs do not own domain logic - they are thin orchestration layers that call authoritative downstream services
- Keep BFFs small and client-specific; if two clients have identical needs, a shared API is fine

## Sources

- Newman, Sam. *Building Microservices*, 2nd ed. O'Reilly, 2021. ISBN 978-1492034029. Chapter 14.
- Newman, Sam. "Pattern: Backends For Frontends." samnewman.io/patterns/architectural/bff/ (2015, accessed 2026-03-17).
