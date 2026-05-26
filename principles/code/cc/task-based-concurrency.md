# CODE-CC-TASK-BASED-CONCURRENCY - Prefer task-based concurrency over raw threads

**Layer:** 2
**Categories:** concurrency, thread-safety, performance
**Applies-to:** all
**Summary:** Express concurrent work as tasks submitted to an executor; never manage threads directly.

## Principle

Rather than creating and managing threads directly, express concurrent work as tasks submitted to an executor or thread pool. Task-based concurrency decouples the unit of work from the mechanism of execution, enabling the runtime or framework to manage thread lifecycle, pooling, scheduling, and resource limits. This produces code that is simpler, more portable, and easier to tune for different hardware.

## Why it matters

Creating threads directly ties application logic to OS-level resource management. Each raw thread consumes significant memory for its stack, and unbounded thread creation under load can exhaust system resources, leading to `OutOfMemoryError` or OS-level failures. Thread pools bound resource consumption, amortize thread creation costs, and provide a natural point for applying backpressure, timeouts, and monitoring.

## Violations to detect

- Creating `new Thread(runnable).start()` (or equivalent) instead of submitting to an executor or thread pool
- Unbounded thread creation in response to incoming requests or events
- Manual thread lifecycle management (tracking threads in lists, interrupting them individually) instead of using executor shutdown protocols
- Using `Thread.sleep()` for scheduling instead of `ScheduledExecutorService` or timer-based abstractions

## Good practice

- Use `ExecutorService` (Java), `goroutines` with bounded worker pools (Go), `Task.Run` (C#), `asyncio` tasks (Python), or equivalent framework-level abstractions
- Configure thread pool sizes based on the nature of the work: CPU-bound tasks benefit from pools sized to the number of cores; I/O-bound tasks can use larger pools
- Use `Future`, `CompletableFuture`, `Promise`, or `async/await` to compose task results and handle errors
- Implement graceful shutdown by shutting down executors and waiting for in-flight tasks to complete before exiting

## Sources

- Goetz, Brian et al. *Java Concurrency in Practice*. Addison-Wesley, 2006. ISBN 978-0-321-34960-6. Chapters 6 and 8.
