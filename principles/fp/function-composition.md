# FP-FUNCTION-COMPOSITION - Function composition

**Layer:** 2 (contextual)
**Categories:** functional-programming, software-design, maintainability
**Applies-to:** all
**Summary:** Build complex behaviour by composing small, single-purpose functions where each output feeds the next input.

## Principle

Build complex behaviour by combining small, single-purpose functions where the output of one becomes the input of the next. Composition is the primary mechanism for building large programs from small, tested, reusable pieces - analogous to how Unix pipelines combine simple tools. Each composed function remains independently testable and reusable.

## Why it matters

When logic is encoded in large, monolithic functions, every change risks breaking multiple concerns simultaneously. Composed pipelines of small functions are easier to reason about - each step has one job and can be verified independently. Composition also enables reuse: a function written for one pipeline can be dropped into another without modification.

## Violations to detect

- Functions longer than ~20 lines that mix multiple transformation steps into a single body
- Duplicated transformation sequences in different parts of the codebase that could be extracted and composed
- Intermediate variables named `temp`, `result`, `data` that exist solely to thread a value from one step to the next
- Nested function calls more than 3 levels deep that could be flattened with a pipe or compose operator

## Good practice

- Write functions that take one input and return one output; keep them short enough to understand without scrolling
- Use `compose` or `pipe` operators/utilities to assemble pipelines declaratively (`pipe(validate, transform, format)`)
- Name composed pipelines after what they accomplish, not how (`processOrder` not `validateThenTransformThenFormat`)
- Test each constituent function independently before testing the composed pipeline

## Sources

- Hughes, John. "Why Functional Programming Matters." *The Computer Journal*, 32(2), 1989. https://www.cs.kent.ac.uk/people/staff/dat/miranda/whyfp90.pdf
- Chiusano, Paul and Bjarnason, Rúnar. *Functional Programming in Scala*. Manning, 2014. ISBN 978-1-61729-065-7. Chapter 2.
- Bird, Richard and Wadler, Philip. *Introduction to Functional Programming*. Prentice Hall, 1988. ISBN 0-13-484197-7. Chapter 1.
