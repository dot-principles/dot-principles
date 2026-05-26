# CODE-PF-DATA-LOCALITY - Optimize data locality - keep related data close in memory

**Layer:** 3 (risk-elevated)
**Categories:** performance
**Applies-to:** all
**Summary:** Arrange data in memory so that items accessed together are stored contiguously for cache efficiency.

## Principle

Arrange data in memory so that items accessed together are stored together. Modern CPUs do not fetch individual bytes from main memory - they fetch entire cache lines (typically 64 bytes). When related data is spread across distant memory addresses, each access triggers a cache miss, stalling the CPU for hundreds of cycles. By co-locating related data, you ensure that a single cache line fetch brings multiple useful values into the cache simultaneously.

## Why it matters

On modern hardware, computation is cheap but memory access is expensive. An L1 cache hit takes roughly 1 nanosecond; a main memory access takes 50-100 nanoseconds. For data-intensive workloads, the bottleneck is almost always memory bandwidth and latency, not arithmetic. A program that processes a compact, contiguous array can be 10-100x faster than one that chases pointers through a scattered heap - not because the algorithm is different, but because the data layout is cache-friendly.

## Violations to detect

- Pointer-heavy data structures (linked lists, tree nodes with heap-allocated children) used for large collections traversed in hot paths
- Object-oriented designs where each entity is a separately allocated object with references to other separately allocated objects, leading to pointer chasing on traversal
- Parallel arrays or maps keyed by ID where a single contiguous structure would keep related fields together
- Frequent random access into very large data sets without consideration of cache behavior

## Good practice

- Use arrays or array-backed collections for data that is traversed sequentially in performance-critical paths
- Consider structure-of-arrays (SoA) layout when hot-path processing touches only a subset of each record's fields, so that accessed fields are packed contiguously
- Pool or arena-allocate objects that are created and accessed together, reducing heap fragmentation and improving spatial locality
- Minimize the size of hot data structures - smaller objects mean more of them fit in cache, reducing miss rates

## Sources

- Drepper, Ulrich. "What Every Programmer Should Know About Memory." 2007. https://people.freebsd.org/~lstewart/articles/cpumemory.pdf
