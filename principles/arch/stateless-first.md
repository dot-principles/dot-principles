# ARCH-STATELESS-FIRST — Design service instances to be stateless

**Layer:** 2 (contextual)
**Categories:** architecture, scalability, cloud-native, resilience
**Applies-to:** services, apis, web-applications
**Summary:** Design service instances to hold no state beyond a single request; store all session state in an external store.

## Principle

Design service instances to hold no state beyond the lifetime of a single request. Session data, user context, and processing state must live in an external store — a cache, database, or message queue — not in memory on a running instance. Stateless instances can be started, stopped, and replaced without coordination, enabling horizontal scaling and zero-downtime deployments.

## Why it matters

Stateful instances are sticky. Load balancers must route a user to the same instance that holds their session, creating invisible coupling between the client and a specific host. When that host is terminated for a deployment, scaling event, or failure, in-flight state is lost and users are disrupted. Stateless instances have no such requirement: any instance can handle any request, and any instance can be terminated at any time. This is the architectural property that makes cloud-native auto-scaling, rolling deployments, and fault-tolerant redundancy possible.

## Violations to detect

- In-memory session stores that require sticky load balancer sessions — requests from the same user must reach the same instance
- Local file system writes to non-mounted paths that disappear when the container is restarted
- Background processing state held in instance memory with no external checkpoint — a restart loses progress
- Deployment procedures that require draining specific instances rather than replacing them uniformly
- Inability to run more than one instance of a service simultaneously due to in-process shared mutable state

## Good practice

- Store session and user state in a distributed cache (Redis, Memcached) or the primary database; use signed tokens (JWT) to carry identity without server-side session
- Treat the local file system as ephemeral: write durable data to object storage (S3, GCS, Azure Blob)
- Checkpoint multi-step processing state to an external queue or database; design jobs to be resumable, not restartable from scratch
- Validate statelessness by running multiple instances concurrently and routing requests randomly — any behavioural differences indicate residual state

## Sources

- Wiggins, Adam. *The Twelve-Factor App*. 2011. https://12factor.net/processes (Factor VI: Processes).
- Newman, Sam. *Building Microservices*, 2nd ed. O'Reilly, 2021. ISBN 978-1-4920-3402-5. Chapter 5.
