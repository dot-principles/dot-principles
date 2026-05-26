# CODE-PF-MECHANICAL-SYMPATHY - Understand mechanical sympathy - align code with hardware realities

**Layer:** 3 (risk-elevated)
**Categories:** performance
**Applies-to:** all
**Summary:** Write code that works with hardware characteristics like cache lines and branch prediction, not against them.

## Principle

Write software that works with the underlying hardware rather than against it. Modern CPUs, memory hierarchies, and I/O subsystems have specific performance characteristics - branch prediction, cache line sizes, prefetching behavior, NUMA topology - that significantly affect throughput and latency. Code that respects these characteristics can be orders of magnitude faster than code that ignores them, even when both are algorithmically identical.

## Why it matters

The term "mechanical sympathy," borrowed from racing, means understanding how the machine works so you can get the best out of it. On modern hardware, a cache miss to main memory costs roughly 100x more than an L1 cache hit. A branch misprediction wastes 10-20 cycles. False sharing between cores can reduce throughput to a fraction of what the hardware can deliver. For performance-critical code, ignoring these realities means leaving most of the hardware's capability on the table.

## Violations to detect

- Data structures with poor cache locality used in hot loops (e.g., linked lists traversed in performance-critical paths when arrays would suffice)
- Multi-threaded code where frequently written fields from different threads share a cache line (false sharing)
- Memory access patterns that defeat hardware prefetching - random access through large data sets when sequential access is feasible
- Branchy code in hot paths that could be restructured to be branch-free or more predictable

## Good practice

- Prefer contiguous, array-based data structures for data accessed sequentially in hot paths - they are cache-friendly and prefetcher-friendly
- Pad or align frequently written fields in concurrent data structures to avoid false sharing across cache lines
- Understand the memory hierarchy of your target platform and design data layouts accordingly - structure of arrays vs. array of structures
- Benchmark on realistic hardware - results from a developer laptop may not reflect production server characteristics

## Sources

- Thompson, Martin. "Mechanical Sympathy." https://mechanical-sympathy.blogspot.com/
- Thompson, Martin; Farley, Dave; Barker, Michael; Gee, Patricia; Stewart, Andrew. "Disruptor: High performance alternative to bounded queues for exchanging data between concurrent threads." LMAX Exchange, 2011. https://lmax-exchange.github.io/disruptor/disruptor.html
