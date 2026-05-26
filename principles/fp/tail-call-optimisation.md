# FP-TAIL-CALL-OPTIMISATION - Tail-call optimisation

**Layer:** 2 (contextual)
**Categories:** functional-programming, performance, reliability
**Applies-to:** haskell, scala, erlang, elixir, f#, clojure, kotlin
**Summary:** Use tail-recursive calls or trampolining to achieve O(1) stack space for deep recursive computations.

## Principle

A recursive call is in tail position when it is the very last operation performed before the function returns - the caller has nothing left to do after the recursive call completes. Runtimes that implement tail-call optimisation (TCO) reuse the current stack frame for tail calls, making tail-recursive functions consume O(1) stack space regardless of recursion depth. When TCO is not available, use trampolining or an explicit stack.

## Why it matters

Without TCO, deep recursion overflows the call stack. This is not a theoretical concern: recursive processing of large data structures (trees, lists, streams) in production regularly hits stack limits. The fix - manually converting clean recursive logic into a loop with an accumulator - sacrifices readability and the structural clarity of the recursive form. Tail-recursive style preserves both.

## Violations to detect

- Recursive functions processing unbounded input where the recursive call is NOT in tail position (e.g., `1 + recurse(n-1)` - the addition happens after the recursive call)
- `@tailrec` annotation missing in Scala on functions intended to be tail-recursive (the compiler will not verify tail position without it)
- Deep recursion in runtimes without TCO (JVM without Scala/Kotlin optimisation, most JavaScript engines) on inputs that could be large
- Accumulator pattern implemented incorrectly, accumulating after the recursive call rather than before it

## Inspection

- `grep -rn "@tailrec" --include="*.scala" $TARGET` | LOW | Verify @tailrec annotations are present on intended tail-recursive Scala functions

## Good practice

- Rewrite non-tail-recursive functions to pass an accumulator argument, moving the combining operation from after the recursive call to before it
- In Scala, annotate intended tail-recursive functions with `@tailrec` to get a compile-time guarantee
- In languages without native TCO (JavaScript, Java), use trampolining (returning thunks and bouncing through a loop) for deep recursion
- Replace extremely deep recursion over known data structures with explicit stack-based iterative algorithms as a last resort

## Sources

- Abelson, Harold and Sussman, Gerald Jay. *Structure and Interpretation of Computer Programs*, 2nd ed. MIT Press, 1996. ISBN 978-0-262-51087-5. Section 1.2.1.
- Chiusano, Paul and Bjarnason, Rúnar. *Functional Programming in Scala*. Manning, 2014. ISBN 978-1-61729-065-7. Chapter 2.
- Hutton, Graham. *Programming in Haskell*, 2nd ed. Cambridge University Press, 2016. ISBN 978-1-316-62622-1. Chapter 6.
