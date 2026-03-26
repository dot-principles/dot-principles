# ARCH-API-GATEWAY — API Gateway

**Layer:** 2 (contextual)
**Categories:** architecture, api-design, microservices
**Applies-to:** all
**Summary:** Route all external traffic through a single API gateway that enforces authentication, rate limiting, and routing.

## Principle

Route all external client traffic through a single entry-point service — the API Gateway — that handles cross-cutting concerns: authentication, authorization, rate limiting, SSL termination, request routing, and response aggregation. Clients communicate only with the gateway; internal services are not directly addressable from outside the system.

## Why it matters

Without a gateway, every internal service must independently implement auth, rate limiting, TLS, and CORS. Clients must know the addresses of multiple internal services, creating coupling between clients and deployment topology. A gateway provides a stable, versioned public surface while allowing internal services to evolve independently.

## Violations to detect

- External clients that call internal microservice endpoints directly, bypassing the gateway
- Cross-cutting concerns (auth, rate limiting, logging of ingress traffic) implemented redundantly in each internal service
- A gateway that contains domain logic or business rules rather than delegating to downstream services

## Good practice

- The gateway handles only cross-cutting infrastructure concerns; it does not own business logic
- Authenticate and authorize at the gateway; pass authenticated identity downstream in a signed header
- Version the gateway's public API surface independently of internal service APIs
- Treat the gateway as a high-availability infrastructure component — test it with load and chaos

## Sources

- Richardson, Chris. *Microservices Patterns*. Manning, 2018. ISBN 978-1617294549. Chapter 8.
- Newman, Sam. *Building Microservices*, 2nd ed. O'Reilly, 2021. ISBN 978-1492034029.
