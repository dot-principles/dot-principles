# CODE-CC-SYNC-SHARED-STATE - Guard shared mutable state with synchronization

**Layer:** 2
**Categories:** concurrency, thread-safety, performance
**Applies-to:** all
**Summary:** Guard every access to shared mutable data with a consistent synchronization mechanism.

## Principle

Whenever multiple threads can access the same mutable data, every access-both reads and writes-must be guarded by the same synchronization mechanism. Without this discipline, threads may observe stale or partially-updated values due to compiler reordering, CPU caching, and the absence of happens-before guarantees. The choice of mechanism (locks, atomic variables, concurrent data structures) matters less than applying it consistently to every code path that touches the shared state.

## Why it matters

Unsynchronized access to shared mutable state produces data races whose symptoms-corrupted data, lost updates, infinite loops on stale flags-are intermittent and nearly impossible to reproduce in testing. These bugs often surface only under production load, making them among the most expensive defects to diagnose and fix.

## Violations to detect

- Reading or writing a field that is accessed by multiple threads without holding the appropriate lock or using an atomic/volatile qualifier
- Synchronizing writes but not reads to the same variable (a common oversight that breaks visibility guarantees)
- Using different locks to guard the same piece of shared state
- Performing compound check-then-act sequences (e.g., `if (!map.containsKey(k)) map.put(k, v)`) without holding a lock across the entire operation

## Good practice

- Identify every piece of shared mutable state and document which lock protects it
- Use the same lock for all accesses-reads and writes-to a given variable or invariant
- Prefer higher-level constructs (concurrent collections, atomic variables) that encapsulate synchronization correctly
- Minimize the scope of shared mutable state; the less there is, the less you need to synchronize

## Sources

- Goetz, Brian et al. *Java Concurrency in Practice*. Addison-Wesley, 2006. ISBN 978-0-321-34960-6. Chapters 2-3.
