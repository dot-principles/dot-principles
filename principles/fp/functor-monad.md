# FP-FUNCTOR-MONAD - Functor and monad abstractions

**Layer:** 2 (contextual)
**Categories:** functional-programming, abstraction, type-safety, error-handling
**Applies-to:** all
**Summary:** Use functor and monad abstractions to compose operations over contextual types uniformly via map and flatMap.

## Principle

A functor is any type that supports `map`: applying a function to a value inside a context without unwrapping the context. A monad additionally supports `flatMap`/`bind`: sequencing operations where each step may produce a new context, and flattening the result. These abstractions unify `Option`, `Either`, `List`, `Future`/`Promise`, and `IO` under a common interface, so the same compositional reasoning applies to all of them.

## Why it matters

Without these abstractions, every context type requires its own ad-hoc composition pattern: manual null-checking for `Option`, nested try/catch for exceptions, callback nesting for async, nested loops for collections. Functor and monad give a single vocabulary - `map` for transforming, `flatMap` for sequencing - that works uniformly across all of these contexts, reducing cognitive overhead and enabling generic utilities that work across context types.

## Violations to detect

- Manual unwrapping of `Option`/`Maybe` with an `if-present` check followed by rewrapping the result, where `map` would suffice
- Nested `flatMap` chains that could be expressed as `for`-comprehensions or `do`-notation for readability
- Manually chaining `Promise.then` callbacks in patterns that could use `async`/`await` (which is syntactic sugar for monad sequencing)
- Writing separate transformation utilities for `Option<T>`, `List<T>`, and `Future<T>` that differ only in the container type

## Good practice

- Prefer `map` over manual unwrap-transform-rewrap sequences: `option.map(f)` instead of `if (option.isPresent()) Some(f(option.get())) else None`
- Use `flatMap` to sequence fallible or context-producing operations without manual nesting: `findUser(id).flatMap(user => findOrder(user.orderId))`
- Use `for`-comprehensions (Scala, Haskell `do`-notation, F# computation expressions) to express chains of `flatMap` in a readable imperative-looking style
- Learn the functor and monad laws (identity, composition, associativity) to understand when your abstractions are well-behaved and can be reasoned about equationally

## Sources

- Hutton, Graham. *Programming in Haskell*, 2nd ed. Cambridge University Press, 2016. ISBN 978-1-316-62622-1. Chapter 12.
- Chiusano, Paul and Bjarnason, Rúnar. *Functional Programming in Scala*. Manning, 2014. ISBN 978-1-61729-065-7. Chapters 11-12.
- Milewski, Bartosz. *Category Theory for Programmers*. Self-published, 2019. https://github.com/hmemcpy/milewski-ctfp-pdf (accessed 2026-03-16). Parts I-II.
