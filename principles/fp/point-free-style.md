# FP-POINT-FREE-STYLE — Point-free style

**Layer:** 2 (contextual)
**Categories:** functional-programming, software-design, abstraction
**Applies-to:** haskell, f#, scala, typescript, javascript, clojure, elm
**Summary:** Define functions by composing transformations without naming arguments to focus on the pipeline, not the data.

## Principle

Point-free (tacit) style defines functions by composing other functions without explicitly naming the arguments (the "points") being passed through. Instead of `const process = (x) => transform(normalise(x))`, write `const process = compose(transform, normalise)`. The focus shifts from the data flowing through the pipeline to the transformations themselves.

## Why it matters

Named intermediate arguments in simple pipeline functions are noise: they add syntax without adding information. Point-free style removes this noise, making the transformation pipeline the subject of the code. It also encourages composability — functions must accept and return compatible types to be composed without manual wiring, which surfaces design problems early.

## Violations to detect

- Wrapper lambdas or arrow functions whose entire body is a single function call with their argument: `(x) => f(x)` instead of just `f`
- Intermediate variable names in simple pipelines that add no semantic information: `const result = pipe(x, step1, step2)` vs `const result = pipe(step1, step2)(x)` with a named pipeline
- Functions defined as `(a, b) => combine(f(a), g(b))` where `liftA2(combine)(f)(g)` would express the same idea point-free

## Good practice

- Apply point-free style selectively: use it where the argument name adds no meaning; revert to explicit arguments when naming the argument clarifies the intent
- Avoid deeply nested point-free expressions — if the composed function requires a comment to explain what it does, the style is obscuring rather than clarifying
- Use `pipe` (left-to-right composition) for readability: `const process = pipe(validate, normalise, transform)` reads in the order of execution
- Treat point-free style as a tool for removing noise, not a goal in itself — never sacrifice readability to achieve it

## Sources

- Bird, Richard and Wadler, Philip. *Introduction to Functional Programming*. Prentice Hall, 1988. ISBN 0-13-484197-7. Chapter 1.
- Hutton, Graham. *Programming in Haskell*, 2nd ed. Cambridge University Press, 2016. ISBN 978-1-316-62622-1. Chapter 4.
- Lipovaca, Miran. *Learn You a Haskell for Great Good!*. No Starch Press, 2011. ISBN 978-1-59327-283-8. Chapter 5.
