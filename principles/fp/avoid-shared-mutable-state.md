# FP-AVOID-SHARED-MUTABLE-STATE — Avoid shared mutable state

**Layer:** 1 (universal)
**Categories:** functional-programming, concurrency, reliability, software-design
**Applies-to:** all
**Summary:** Eliminate shared mutable state; transform data through pipelines to prevent race conditions and action-at-a-distance bugs.

## Principle

State that is both shared (accessible from multiple locations in the program) and mutable (can change after creation) is the primary source of concurrency bugs, race conditions, and action-at-a-distance defects. Prefer designs where data flows through transformation pipelines — each step produces a new value — rather than designs where multiple components coordinate by reading and writing shared variables.

## Why it matters

Race conditions caused by shared mutable state are notoriously difficult to reproduce, diagnose, and fix because their manifestation depends on non-deterministic thread scheduling. Even in single-threaded code, shared mutable state makes it impossible to reason about a function in isolation — you must trace every code path that could have modified the state before the function ran.

## Violations to detect

- Module-level or class-level mutable fields read and written by multiple methods or threads
- Passing mutable collections into functions that then modify them, creating hidden output channels
- Singleton objects used as shared mutable registries
- Callback functions that capture and mutate variables from an outer scope
- Thread-unsafe use of shared state without synchronisation (no lock, no atomic, no actor)

## Inspection

- `grep -rn "static.*=\|global " --include="*.ts" --include="*.js" --include="*.py" $TARGET` | MEDIUM | Static or global mutable variables

## Good practice

- Favour passing data explicitly as function arguments and returning transformed results; avoid implicit shared channels
- Where shared state is unavoidable (e.g., a cache), encapsulate it behind a single owner — an actor, a locked struct, or a thread-safe abstraction — so the mutation is localised and controlled
- Use message-passing concurrency (actors, channels, queues) instead of shared-memory concurrency where possible
- Replace stateful loops with `map`, `filter`, `reduce` pipelines that express the transformation without mutation

## Sources

- Hughes, John. "Why Functional Programming Matters." *The Computer Journal*, 32(2), 1989. https://www.cs.kent.ac.uk/people/staff/dat/miranda/whyfp90.pdf
- Chiusano, Paul and Bjarnason, Rúnar. *Functional Programming in Scala*. Manning, 2014. ISBN 978-1-61729-065-7. Chapter 1.
- Goetz, Brian et al. *Java Concurrency in Practice*. Addison-Wesley, 2006. ISBN 978-0-321-34960-6. Chapter 2.
