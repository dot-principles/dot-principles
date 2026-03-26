# CODE-CC-HIGHER-LEVEL-CONCURRENCY — Use higher-level concurrency utilities over wait/notify

**Layer:** 2
**Categories:** concurrency, thread-safety, performance
**Applies-to:** all
**Summary:** Use high-level concurrency utilities instead of raw wait/notify to avoid subtle synchronization bugs.

## Principle

Low-level threading primitives such as `wait()`, `notify()`, and `notifyAll()` (or their equivalents: condition variables, manual signaling) are difficult to use correctly and easy to misuse. Modern platforms provide higher-level concurrency utilities—blocking queues, latches, semaphores, executors, futures, and concurrent collections—that encapsulate the tricky synchronization logic and have been thoroughly tested. Prefer these building blocks over hand-rolled wait/notify protocols.

## Why it matters

Incorrect use of wait/notify leads to missed signals, spurious wake-ups, lost notifications, and deadlocks—bugs that are subtle, intermittent, and resistant to testing. Higher-level utilities handle these edge cases internally, significantly reducing the surface area for concurrency bugs while also producing clearer, more maintainable code.

## Violations to detect

- Direct use of `Object.wait()`, `Object.notify()`, or `Object.notifyAll()` (Java) or their equivalents in other languages when a standard utility exists for the same pattern
- Hand-built producer-consumer queues using raw locks and conditions instead of `BlockingQueue` or channel abstractions
- Manual thread coordination with boolean flags and sleep loops instead of `CountDownLatch`, `CyclicBarrier`, or similar constructs
- Implementing a thread pool from scratch rather than using an `ExecutorService`, `ThreadPoolExecutor`, or language-standard equivalent

## Good practice

- Use `BlockingQueue` (Java), `Channel` (Go, Kotlin), or `asyncio.Queue` (Python) for producer-consumer patterns
- Use `CountDownLatch` or `CyclicBarrier` for coordinating the start or completion of multiple threads
- Use `ExecutorService` or equivalent frameworks to manage thread lifecycles and task submission
- Use `CompletableFuture`, `Promise`, or `async/await` for composing asynchronous results
- If you must use `wait()`, always call it in a loop that re-checks the condition predicate, and prefer `notifyAll()` over `notify()`

## Sources

- Goetz, Brian et al. *Java Concurrency in Practice*. Addison-Wesley, 2006. ISBN 978-0-321-34960-6. Chapters 5 and 14.
