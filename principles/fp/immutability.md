# FP-IMMUTABILITY — Immutability as design

**Layer:** 1 (universal)
**Categories:** functional-programming, software-design, concurrency, reliability
**Applies-to:** all
**Summary:** Prefer immutable data structures; produce new values on transformation and make mutation the explicit exception.

## Principle

Prefer data structures that cannot be changed after creation. When a transformation is needed, produce a new value rather than modifying the existing one. Make mutation explicit, localised, and the exception rather than the default — reserve it for performance-critical boundaries where the cost of copying is demonstrably unacceptable.

## Why it matters

Mutable shared state is the primary source of concurrency bugs, unexpected aliasing, and action-at-a-distance defects where changing one part of the system silently corrupts another. Immutable data eliminates this class of bug entirely: a value that cannot change cannot be unexpectedly changed by another thread, another function, or a callback.

## Violations to detect

- Data structures passed to functions that are then mutated inside the function (aliasing)
- Publicly settable fields on objects that represent domain concepts
- Shared mutable state accessed from multiple threads without synchronisation
- `for` loops that accumulate results by mutating an outer variable instead of using `map`/`reduce`
- Returning internal mutable collections from getters (defensive copy missing)

## Inspection

- `grep -rn "var " --include="*.scala" --include="*.kt" $TARGET` | MEDIUM | Mutable variable declarations in Scala/Kotlin (prefer val)
- `grep -rn "\.push\|\.pop\|\.splice\|\.sort(" --include="*.ts" --include="*.js" $TARGET` | LOW | In-place array mutation methods

## Good practice

- Default to `const`, `val`, `final`, or `readonly` in every language that supports it; require an explicit reason to use a mutable binding
- Use persistent/structural-sharing data structures (immutable lists, maps, sets) from libraries when full copies would be too expensive
- At mutation boundaries (e.g., building a result incrementally), use a local mutable accumulator and return an immutable value once construction is complete
- In languages without native immutability enforcement, use `Object.freeze()`, `Collections.unmodifiableList()`, or equivalent to signal intent

## Sources

- Chiusano, Paul and Bjarnason, Rúnar. *Functional Programming in Scala*. Manning, 2014. ISBN 978-1-61729-065-7. Chapter 1.
- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 17: "Minimise mutability."
- Abelson, Harold and Sussman, Gerald Jay. *Structure and Interpretation of Computer Programs*, 2nd ed. MIT Press, 1996. ISBN 978-0-262-51087-5. Section 3.1.
