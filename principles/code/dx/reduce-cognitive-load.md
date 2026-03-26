# CODE-DX-REDUCE-COGNITIVE-LOAD — Reduce cognitive load in code structure

**Layer:** 2 (contextual)
**Categories:** developer-experience, readability
**Applies-to:** all
**Summary:** Structure code so developers hold as few concepts in working memory as possible at any point.

## Principle

Design code structure so that a developer does not have to think more than necessary to understand it. Reduce the number of concepts, decisions, and cross-references a reader must hold in working memory at any point. Just as good interface design makes the right action obvious and the wrong action difficult, good code structure makes the intended flow obvious and misuse difficult.

## Why it matters

Human working memory is limited. When code demands that a developer track too many variables, follow too many indirections, or remember too many conventions simultaneously, errors become inevitable. High cognitive load slows development, increases defect rates, and makes onboarding painful. Code that is easy to think about is code that is easy to work with safely.

## Violations to detect

- Deeply nested control structures (more than two or three levels of indentation)
- Functions that require the reader to scroll back and forth to understand variable lifetimes
- Files that mix unrelated concerns, forcing the reader to mentally filter what is relevant
- Inconsistent patterns within the same codebase — each inconsistency requires the reader to re-learn conventions
- Long parameter lists or complex configuration objects that require cross-referencing documentation

## Good practice

- Use early returns and guard clauses to flatten nested conditionals
- Keep related code physically close together — reduce the distance between a variable's declaration and its use
- Follow consistent patterns and conventions within a codebase so that developers build reliable intuition
- Break complex flows into a sequence of named steps, each understandable in isolation
- Limit the number of concepts introduced in any single file or module

## Sources

- Krug, Steve. *Don't Make Me Think, Revisited: A Common Sense Approach to Web Usability*. 3rd ed. New Riders, 2014. ISBN 978-0-321-96551-6. (Principles of reducing cognitive load, applied here to code structure rather than user interface design.)
