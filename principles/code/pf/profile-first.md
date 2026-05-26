# CODE-PF-PROFILE-FIRST - Measure before optimizing - profile, don't guess

**Layer:** 3 (risk-elevated)
**Categories:** performance
**Applies-to:** all
**Summary:** Always profile to identify actual bottlenecks before making any performance optimization.
**Audit-scope:** excluded - the core violation ("optimized without profiling data") is a process event, not a code state; no artifact in the codebase proves or disproves whether profiling occurred

## Principle

Never optimize based on intuition alone. Before changing code for performance, measure it with a profiler to identify the actual bottleneck. Programmers are notoriously bad at predicting where a program spends its time - the real hotspot is almost never where you expect. Establish a performance baseline, make one change, and measure again to verify the improvement.

## Why it matters

As Knuth famously warned, "premature optimization is the root of all evil." Optimizing code that is not on the critical path wastes development time and often makes the code harder to read, maintain, and debug - all for no measurable benefit. Worse, misguided optimizations can introduce bugs or pessimize performance by defeating compiler optimizations or disrupting cache behavior. Profiling directs effort to the places where it will actually make a difference.

## Violations to detect

- Performance-motivated code changes with no profiling data or benchmark results to justify them
- Hand-rolled data structures or algorithms used "for performance" in code that is not on a measured hot path
- Micro-optimizations (bit manipulation, loop unrolling, manual inlining) in application-level code without profiling evidence
- Readability sacrificed for speculative performance gains with no measurement before or after

## Good practice

- Use language-appropriate profiling tools (e.g., perf, async-profiler, py-spy, Chrome DevTools, BenchmarkDotNet) to identify actual bottlenecks before optimizing
- Write reproducible benchmarks that isolate the code under test and account for warm-up, GC, and measurement noise
- Document the performance requirement (latency target, throughput goal) that motivates the optimization
- Keep the unoptimized version available (in comments or version control) so the trade-off between clarity and performance remains visible

## Sources

- Knuth, Donald E. "Structured Programming with go to Statements." *ACM Computing Surveys*, Vol. 6, No. 4, 1974, pp. 261-301. DOI: 10.1145/356635.356640.
- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 67: "Optimize judiciously."
