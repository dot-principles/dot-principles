# ARCH-STRANGLER-FIG — Strangler Fig Application

**Layer:** 2 (contextual)
**Categories:** architecture, migration, evolutionary-architecture
**Applies-to:** all
**Summary:** Incrementally replace legacy systems by routing traffic to a new implementation piece by piece; never big-bang rewrite.

## Principle

Incrementally replace a legacy system by intercepting calls at the boundary and routing them to a new implementation piece by piece. Both the old and new systems run simultaneously. As functionality is migrated to the new system, the corresponding routes are switched. When all routes are migrated, the legacy system is decommissioned.

## Why it matters

Big-bang rewrites carry enormous risk: months or years of work that cannot be released until complete, no ability to validate the new system under real load, and no rollback path if the rewrite fails. The Strangler Fig allows continuous delivery throughout the migration, validates each migrated piece against production traffic, and limits risk to the slice currently being moved.

## Violations to detect

- Rewriting the entire system before switching any traffic to it
- No routing layer between clients and the legacy/new implementation — making it impossible to switch individual routes
- Migrating functionality without verifying correctness under production traffic before decommissioning the legacy path

## Good practice

- Introduce a façade/proxy at the boundary that intercepts all traffic
- Migrate one capability at a time; route it to the new implementation
- Verify behaviour under production load before decommissioning the legacy path for that capability
- Use feature flags to control the routing switch per capability

## Sources

- Fowler, Martin. "Strangler Fig Application." martinfowler.com/bliki/StranglerFigApplication.html (2004, accessed 2026-03-17).
- Newman, Sam. *Monolith to Microservices*. O'Reilly, 2019. ISBN 978-1492047841.
