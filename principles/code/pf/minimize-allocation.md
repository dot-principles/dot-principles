# CODE-PF-MINIMIZE-ALLOCATION - Avoid premature allocation - minimize garbage and allocation pressure

**Layer:** 3 (risk-elevated)
**Categories:** performance
**Applies-to:** all
**Summary:** Minimize object creation in hot paths to reduce GC pressure and prevent unpredictable pauses.

## Principle

Reduce unnecessary object creation in performance-sensitive code paths. Every allocation consumes memory bandwidth, increases garbage collector pressure, and may trigger collection pauses at unpredictable times. Reuse objects where safe, prefer value types or stack allocation when available, and avoid creating short-lived objects in tight loops. The goal is not to avoid allocation entirely - it is to avoid wasteful allocation that delivers no value.

## Why it matters

In garbage-collected languages, allocation is cheap in isolation but expensive in aggregate. Each unnecessary object shortens the interval between GC cycles, increases the amount of work the collector must do, and raises the probability of a stop-the-world pause. In latency-sensitive applications - trading systems, game loops, real-time services - even brief GC pauses can violate SLAs. In non-GC languages, excessive allocation fragments the heap and increases allocator overhead.

## Violations to detect

- Object creation inside tight loops when the object could be allocated once and reused (e.g., creating iterators, formatters, or buffers per iteration)
- Autoboxing of primitives in hot paths (e.g., storing `int` values in `Map<Integer, Integer>` in Java)
- String concatenation in loops using immutable string types instead of a mutable builder
- Defensive copying of large objects on every method call when immutability could be guaranteed structurally

## Good practice

- Reuse objects via object pools, thread-local caches, or pre-allocated buffers in performance-critical paths
- Prefer primitive types and value types over boxed or heap-allocated wrappers in hot loops
- Use `StringBuilder`, `ByteBuffer`, or equivalent mutable types for incremental construction in loops
- Profile allocation rates with tools (e.g., Java Flight Recorder allocation profiling, .NET allocation tracking, Go pprof heap profiles) to identify the top allocation sites before optimizing

## Sources

- Thompson, Martin. Various talks and articles on low-latency Java and allocation-free design. https://mechanical-sympathy.blogspot.com/
- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 6: "Avoid creating unnecessary objects."
