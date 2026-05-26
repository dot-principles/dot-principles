# CODE-CC-SAFE-PUBLICATION - Never publish a reference to an incompletely constructed object

**Layer:** 2
**Categories:** concurrency, thread-safety, performance
**Applies-to:** all
**Summary:** Never let `this` escape a constructor; publish object references to other threads only after construction completes.

## Principle

An object is "published" when a reference to it becomes accessible to code outside its current scope. If publication happens before the constructor has finished executing, other threads may observe the object in a partially initialized state-with default or stale field values-even if all fields are set by the time the constructor returns. This includes implicit publication via the `this` reference escaping during construction.

## Why it matters

When an incompletely constructed object is visible to other threads, those threads may read zero/null field values, see an object whose invariants do not yet hold, or encounter a permanently broken view of the object's state. These defects are timing-dependent and extremely difficult to reproduce, yet they can cause serious data corruption or crashes.

## Violations to detect

- Passing `this` to another object or registering a listener/callback from within a constructor
- Starting a thread from inside a constructor (the new thread can see the partially constructed object)
- Storing `this` in a static field or shared collection during construction
- Publishing an object reference through a non-volatile field without safe-publication idioms (e.g., assigning to a plain field that another thread reads)

## Good practice

- Do not let `this` escape during construction-use static factory methods to perform post-construction registration
- If construction requires starting a thread or registering a listener, do it in a separate `start()` or `initialize()` method called after the constructor completes
- Use safe-publication idioms: `volatile` fields, `final` fields (which guarantee visibility after construction), `AtomicReference`, or initialization within a synchronized block
- Prefer immutable objects, which are safely published as soon as the constructor completes as long as all fields are `final`

## Sources

- Goetz, Brian et al. *Java Concurrency in Practice*. Addison-Wesley, 2006. ISBN 978-0-321-34960-6. Chapter 3, Sections 3.2 and 3.5.
