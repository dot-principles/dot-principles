# ARCH-BULKHEAD - Bulkhead Pattern

**Layer:** 2 (contextual)
**Categories:** architecture, reliability, resilience
**Applies-to:** all
**Summary:** Isolate subsystem resources into separate pools so one failure cannot exhaust resources needed by others.

## Principle

Partition a system's resources (thread pools, connection pools, process pools) into isolated compartments - bulkheads - so that an overload or failure in one subsystem cannot exhaust the resources needed by others. Each subsystem is allocated its own fixed pool; exhausting it has no effect on other subsystems.

## Why it matters

In a system with shared resource pools, a slow or failing dependency can occupy all available threads or connections, making the entire system unresponsive - even for paths that do not depend on the failing component. Bulkhead isolation limits the blast radius of failures: one dependency's misbehaviour degrades only the functionality that depends on it.

## Violations to detect

- A single shared thread pool or connection pool used for all outbound dependencies - one slow dependency can exhaust it and block all others
- HTTP clients with no per-host connection limits sharing a global pool
- Synchronous calls to unreliable external services on the same thread pool as user-facing request handling

## Good practice

- Assign a separate, bounded thread pool or connection pool to each external dependency
- Configure pool sizes based on expected concurrency and acceptable degradation
- Combine with circuit breakers to fail fast when a bulkhead is exhausted rather than queuing indefinitely
- Monitor pool saturation as a key health signal

## Sources

- Nygard, Michael T. *Release It! Design and Deploy Production-Ready Software*, 2nd ed. Pragmatic Bookshelf, 2018. ISBN 978-1680502398. Chapter 5.
- Netflix Tech Blog. "Fault Tolerance in a High Volume, Distributed System." (2012).
