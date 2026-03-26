# CODE-CC-AVOID-LOCKS-IN-HOT-PATHS — Avoid holding locks during long-running operations

**Layer:** 2
**Categories:** concurrency, thread-safety, performance
**Applies-to:** all
**Summary:** Hold locks only for the minimum time needed; never perform I/O or long operations inside a critical section.

## Principle

Holding a lock while performing network I/O, disk access, expensive computations, or calls to external services blocks all other threads that need the same lock, degrading throughput and responsiveness. Locks should be held for the minimum time necessary to preserve invariants. Restructure code so that long-running operations execute outside the critical section, then re-acquire the lock briefly to update shared state with the result.

## Why it matters

Lock contention is one of the most common causes of poor scalability in concurrent systems. A single slow operation performed under a widely-shared lock can serialize an entire application, turning a multi-threaded program into a single-threaded one. In severe cases, this leads to thread starvation, cascading timeouts, and system-wide outages.

## Violations to detect

- Performing network calls, database queries, or file I/O while holding a lock
- Calling into user-supplied callbacks or third-party library methods from within a synchronized block
- Holding a lock across an `await` or `yield` point in asynchronous code (which may block the underlying thread or cause lock-ordering violations)
- Synchronized methods or blocks that encompass the entire method body when only a portion requires mutual exclusion

## Good practice

- Narrow synchronized blocks to cover only the state reads and writes that must be atomic
- Copy shared state into local variables under the lock, release the lock, perform the long-running operation, then re-acquire the lock to write back results
- Use concurrent data structures or optimistic techniques (compare-and-swap, versioning) to reduce lock granularity
- Consider read-write locks when reads greatly outnumber writes, allowing concurrent readers while still protecting writes

## Sources

- Goetz, Brian et al. *Java Concurrency in Practice*. Addison-Wesley, 2006. ISBN 978-0-321-34960-6. Chapters 11 and 13.
