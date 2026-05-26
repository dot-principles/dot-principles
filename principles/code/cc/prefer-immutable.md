# CODE-CC-PREFER-IMMUTABLE - Prefer immutable objects for thread safety

**Layer:** 2
**Categories:** concurrency, thread-safety, performance
**Applies-to:** all
**Summary:** Design shared objects to be immutable after construction so they require no synchronization to be thread-safe.

## Principle

Immutable objects-those whose state cannot be modified after construction-are inherently thread-safe because concurrent readers can never observe an inconsistent state. By designing value-carrying classes to be immutable, you eliminate an entire category of concurrency bugs without any synchronization overhead. When mutation is needed, create a new instance rather than modifying the existing one.

## Why it matters

Every piece of mutable shared state is a potential source of data races. Immutable objects can be freely shared across threads, cached, and used as hash-map keys without defensive copying or locking. This simplifies reasoning about program correctness and removes a significant class of subtle, hard-to-reproduce bugs.

## Violations to detect

- Classes shared between threads that expose public mutable fields or setter methods
- Data-holder objects with mutable collections that are passed across thread boundaries without copying
- Objects that are technically immutable but leak mutable internal references (e.g., returning a mutable `Date` or `List` from a getter)
- Using mutable objects as keys in concurrent maps

## Good practice

- Make fields `final` (or `readonly`, `val`, `const` in other languages) and set them only in the constructor
- Do not provide setter methods on objects shared across threads
- Return defensive copies of any mutable internal state (collections, arrays, dates) from accessors
- Use language-level immutability support: records in Java 16+, `data class` with `val` in Kotlin, `readonly struct` in C#, frozen dataclasses in Python

## Sources

- Goetz, Brian et al. *Java Concurrency in Practice*. Addison-Wesley, 2006. ISBN 978-0-321-34960-6. Chapter 3, Section 3.4.
