# ARCH-SERVICE-LAYER — Service Layer

**Layer:** 2 (contextual)
**Categories:** architecture, separation-of-concerns
**Applies-to:** all
**Summary:** Define application use cases in a service layer that coordinates domain objects and enforces transactional boundaries.

## Principle

Define an application's boundary with a layer of service objects that coordinate the domain model, enforce transactional boundaries, and express the application's use cases. The service layer is the entry point for all application operations from outside the domain; it orchestrates calls to domain objects, repositories, and infrastructure services.

## Why it matters

Without a service layer, business logic leaks into controllers, event handlers, and batch jobs — duplicating coordination logic and making it impossible to invoke the same use case from different entry points (HTTP, CLI, message consumer) without duplicating code. A service layer provides a single, testable place where each use case is fully expressed.

## Violations to detect

- Business logic or transaction management code in controllers, view handlers, or route handlers rather than in a dedicated service layer
- The same coordination logic duplicated across an HTTP controller and a CLI command handler
- Domain objects calling repositories or external services directly from within business methods
- Service layer methods that contain presentation concerns (serialization, HTTP status codes, template rendering)

## Good practice

- Define one service method per use case; keep service methods thin — they orchestrate, not implement domain logic
- Place all transaction boundaries in the service layer
- Test service methods directly without going through the HTTP/CLI entry point
- Keep the service layer technology-agnostic: it should not depend on the web framework

## Sources

- Fowler, Martin. *Patterns of Enterprise Application Architecture*. Addison-Wesley, 2002. ISBN 978-0321127426. Chapter 9, "Service Layer."
