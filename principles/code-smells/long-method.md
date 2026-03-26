# CODE-SMELLS-LONG-METHOD — Long Method

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, maintainability
**Applies-to:** all
**Summary:** Extract logically distinct blocks from long methods into well-named, single-purpose methods.

## Principle

A method should do one thing, and its body should communicate that one thing clearly. When a method grows long, it is almost always doing more than one thing — each conceptual block deserves its own well-named method. The key heuristic is not line count but whether you feel the need to write a comment explaining what a section of code does; that section is a candidate for extraction.

## Why it matters

Short, single-purpose methods are easier to understand, test, and reuse. Long methods accumulate conditional logic, temporary variables, and hidden side effects that make reasoning about behaviour difficult and increase the likelihood of bugs during modification.

## Violations to detect

- Methods longer than roughly 10–15 lines that contain multiple conceptual steps
- Comments within a method that explain "what the next block does" — a sign that block should be its own method
- Multiple levels of nesting (loops inside conditionals inside loops)
- Temporary variables used to pass data between sections of the same method

## Good practice

- Extract each logical step into a method whose name describes the intent (Extract Function)
- Replace temp variables with queries where possible (Replace Temp with Query)
- Use Decompose Conditional to turn complex if/else chains into named methods
- Let method names carry the explanatory weight that comments previously held

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
