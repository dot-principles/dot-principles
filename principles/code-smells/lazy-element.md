# CODE-SMELLS-LAZY-ELEMENT — Lazy Element

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, maintainability
**Applies-to:** all
**Summary:** Remove or inline abstractions that do not justify their existence with meaningful logic or reuse.

## Principle

A Lazy Element is a class, function, or module that does not do enough to justify its existence. It may have been created with good intentions — anticipating growth that never came, or extracting something that turned out to be used only once — but it now adds a layer of indirection without adding clarity or capability. When an element no longer pulls its weight, the right move is to inline it and remove the extra abstraction.

## Why it matters

Every named abstraction — a class, a function, a module — is a thing a reader must understand and remember. An element that does almost nothing forces the reader to follow a pointer that leads nowhere useful: they open the file or navigate to the definition only to find a thin wrapper. This friction accumulates. Lazy elements also resist deletion because they look like real code; they tend to persist indefinitely, cluttering the design and misleading future readers about the system's true structure.

## Violations to detect

- A class with only one method and no state — the class adds no value over the method alone
- A function that does nothing but call another function with the same arguments and no transformation
- A module or file that exports a single item and is imported in only one place
- An interface with a single implementation that is never swapped, injected, or tested in isolation
- A base class or abstract class with a single concrete subclass where the hierarchy serves no design purpose

## Good practice

- Inline the element: fold the function body into its only caller, or collapse the class into the code that uses it
- Delete the abstraction if the wrapper provides no meaningful renaming, transformation, or extension point
- Apply the "would removing this break anything except the renaming?" test — if the answer is no, remove it
- Distinguish from intentional extension points: a single-implementation interface that exists for future testability or pluggability is not lazy, but document the reason explicitly

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
