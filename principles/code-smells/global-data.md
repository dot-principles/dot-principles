# CODE-SMELLS-GLOBAL-DATA - Global Data

**Layer:** 1 (universal)
**Categories:** code-smells, refactoring, coupling, maintainability
**Applies-to:** all
**Summary:** Eliminate global mutable state; restrict data access and modification to narrowly scoped locations.

## Principle

Global Data is any data that can be accessed and modified from anywhere in the codebase - global variables, class variables (static mutable fields), singletons, and global constants that hold mutable state. Global data is the most insidious form of coupling: you can never tell what code changes it, and finding all places it affects requires searching the entire codebase.

## Why it matters

Global mutable state makes a program's behavior depend on history - the sequence in which code runs - rather than on local inputs. It makes testing hard (tests share state and interfere with each other), makes concurrency dangerous (race conditions), and makes the code hard to reason about in isolation.

## Violations to detect

- Mutable static fields accessed from multiple classes
- Singleton objects that hold mutable application state and are accessed globally
- Global configuration objects that can be modified at runtime from anywhere
- Module-level mutable variables (in Python, JavaScript, etc.) read and written across many files

## Inspection

- `grep -rnE '\bstatic\b.*\b(var|let|field)\b|static [a-zA-Z]+ [a-zA-Z]+ =' --include="*.java" --include="*.ts" --include="*.js" $TARGET` | MEDIUM | Mutable static fields (verify not constants)

## Good practice

- Encapsulate global data behind a class that controls access and change
- Pass data as parameters rather than accessing it globally
- Prefer immutable global constants (truly `final`/`const`) over mutable global state
- Use dependency injection to make dependencies explicit rather than implicit through globals

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
