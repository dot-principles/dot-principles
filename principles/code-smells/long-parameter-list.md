# CODE-SMELLS-LONG-PARAMETER-LIST — Long Parameter List

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, maintainability
**Applies-to:** all
**Summary:** Replace long parameter lists with parameter objects to reduce complexity and prevent call-site errors.

## Principle

A method with too many parameters is hard to understand and easy to call incorrectly. Long parameter lists often indicate that the method is doing too much, that related parameters should be bundled into an object, or that data that could be derived from existing objects is being passed explicitly.

## Why it matters

Long parameter lists are hard to read, easy to get wrong (especially when several parameters share the same type), and frequently change as requirements evolve. Each addition to the list is a backwards-incompatible change for callers. Bundling related parameters into an object gives them a name and a home.

## Violations to detect

- Methods or functions with more than four or five parameters
- Multiple parameters of the same type next to each other in a signature (easy to swap accidentally)
- Parameters that are always passed together (a Data Clump waiting to become an object)
- Boolean "flag" parameters that control method behavior (should be two separate methods)

## Good practice

- Introduce a Parameter Object for groups of related parameters
- Use Preserve Whole Object: pass the object rather than extracting individual fields to pass separately
- Split methods with flag parameters into two clearly-named methods
- If a parameter could be derived from an existing object the method already receives, remove it and compute it internally

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
