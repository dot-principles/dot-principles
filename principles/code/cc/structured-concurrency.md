# CODE-CC-STRUCTURED-CONCURRENCY - Design for structured concurrency (parent scope owns child tasks)

**Layer:** 2
**Categories:** concurrency, thread-safety, performance
**Applies-to:** all
**Summary:** Scope every concurrent task to a parent that awaits completion, propagates cancellation, and surfaces child errors.

## Principle

In structured concurrency, every concurrent task is launched within a well-defined scope, and that scope does not complete until all of its child tasks have finished, failed, or been cancelled. Just as structured programming replaced `goto` with blocks that have a single entry and exit, structured concurrency replaces fire-and-forget thread spawning with scoped task ownership. The parent scope is responsible for the outcomes of its children-it propagates cancellation downward and exceptions upward.

## Why it matters

Unstructured concurrency-launching tasks with no clear owner-leads to leaked threads, orphaned background work, silently swallowed exceptions, and resource leaks that are difficult to detect. Structured concurrency makes the lifetime of concurrent work predictable and observable, simplifying error handling, cancellation, debugging, and resource cleanup.

## Violations to detect

- Launching tasks that outlive their parent scope with no mechanism to await or cancel them
- Fire-and-forget patterns where the result or failure of a background task is never checked
- Cancellation logic that does not propagate to child tasks, leaving orphaned work running
- Using `GlobalScope.launch` (Kotlin), detached tasks, or unowned thread submissions where a scoped alternative exists
- Exception handling that swallows errors from child tasks without propagating them to the parent

## Good practice

- Use scoped concurrency primitives: `coroutineScope` / `supervisorScope` (Kotlin), `TaskGroup` (Python 3.11+), `StructuredTaskScope` (Java 21+), or `withTaskGroup` (Swift)
- Ensure that the parent scope waits for all child tasks before returning, whether they succeed or fail
- Propagate cancellation: when a parent scope is cancelled, all child tasks should be cancelled cooperatively
- When one child task fails, decide explicitly whether to cancel siblings (default in `coroutineScope`) or let them continue (`supervisorScope`) - do not leave this to chance
- Treat the concurrency scope boundary as a resource boundary: open resources before the scope, close them after all children complete

## Sources

- Goetz, Brian et al. *Java Concurrency in Practice*. Addison-Wesley, 2006. ISBN 978-0-321-34960-6. Chapters 6-7 (task execution and cancellation).
- Elizarov, Roman. "Structured Concurrency." Kotlin Documentation. https://kotlinlang.org/docs/coroutines-basics.html
