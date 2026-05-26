# CODE-PF-PREDICTABLE-LATENCY - Design for predictable latency - avoid lock contention and GC pauses in hot paths

**Layer:** 3 (risk-elevated)
**Categories:** performance
**Applies-to:** all
**Summary:** Eliminate lock contention and GC pressure in hot paths to ensure consistent, predictable response times.

## Principle

In latency-sensitive code paths, design for predictability, not just throughput. Avoid sources of unpredictable delay: lock contention that forces threads to wait on each other, garbage collection pauses that halt all application threads, and system calls that may block for an indeterminate time. Prefer lock-free algorithms, bounded allocation, and non-blocking I/O in paths where consistent response times matter more than peak throughput.

## Why it matters

Many systems are judged not by average latency but by tail latency - the 99th or 99.9th percentile response time. A single lock contention event or GC pause can spike a request's latency by orders of magnitude, violating SLAs and degrading user experience. Systems that appear fast under light load can become unpredictable under contention. Designing for predictable latency requires eliminating or bounding the sources of jitter in the hot path.

## Violations to detect

- Synchronized blocks or mutex locks held during I/O operations or across slow code paths, creating a serialization bottleneck
- Hot-path code that allocates heavily, triggering frequent garbage collection cycles
- Unbounded blocking operations (e.g., `synchronized`, `Lock.lock()`, `channel send` with no timeout) in request-handling threads
- Shared mutable state protected by a single coarse-grained lock when finer-grained or lock-free alternatives exist

## Good practice

- Use lock-free or wait-free data structures (e.g., compare-and-swap rings, the LMAX Disruptor pattern) for inter-thread communication in hot paths
- Minimize allocation in the hot path - pre-allocate buffers, reuse objects, and avoid autoboxing to reduce GC pressure
- Separate latency-sensitive work from background work onto different thread pools, so GC pauses or lock contention in batch processing do not affect real-time requests
- Monitor and alert on tail latency (p99, p99.9) in addition to averages, and use latency histograms to detect jitter caused by contention or GC events

## Sources

- Thompson, Martin. "Mechanical Sympathy." https://mechanical-sympathy.blogspot.com/
- Gil, Gil Tene. "Understanding Java Garbage Collection and What You Can Do About It." Various conference talks and Azul Systems publications. https://www.azul.com/resources/
