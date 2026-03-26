# CODE-CC-DOCUMENT-THREAD-SAFETY — Document thread-safety guarantees

**Layer:** 2
**Categories:** concurrency, thread-safety, performance
**Applies-to:** all
**Summary:** Document every class's thread-safety guarantees explicitly as part of its public contract.

## Principle

Every class or module that may be used in a concurrent context should clearly document its thread-safety guarantees: whether it is immutable, thread-safe, conditionally thread-safe (safe only if callers hold specific locks), or not thread-safe at all. Without explicit documentation, users of the class must guess—and they will guess wrong. Thread-safety is part of a class's contract, just like its method signatures and invariants.

## Why it matters

When thread-safety properties are undocumented, callers either add unnecessary synchronization (hurting performance) or omit necessary synchronization (introducing data races). Ambiguity compounds across teams and over time as the original author's intent is lost. Explicit documentation prevents both over-synchronization and under-synchronization.

## Violations to detect

- Public classes or interfaces used in concurrent contexts with no thread-safety documentation
- Javadoc or comments that are vague (e.g., "this class is synchronized") without specifying which operations are safe and under what conditions
- Classes annotated as `@ThreadSafe` whose implementations contain unguarded mutable state
- Lock-ordering protocols that exist only in the original developer's memory and are not written down

## Good practice

- Use annotations like `@ThreadSafe`, `@NotThreadSafe`, and `@GuardedBy("lock")` (from `javax.annotation.concurrent` or equivalent) to make guarantees machine-readable
- For conditionally thread-safe classes, document which lock a caller must hold and for which operations
- Document lock-ordering requirements to prevent deadlocks when multiple locks are involved
- When thread-safety properties change (e.g., a previously single-threaded class becomes shared), update the documentation as part of the same change

## Sources

- Goetz, Brian et al. *Java Concurrency in Practice*. Addison-Wesley, 2006. ISBN 978-0-321-34960-6. Chapter 4, Section 4.5.
