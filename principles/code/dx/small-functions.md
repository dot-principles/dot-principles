# CODE-DX-SMALL-FUNCTIONS - Keep functions small and single-purpose

**Layer:** 1 (universal)
**Categories:** developer-experience, readability
**Applies-to:** all
**Summary:** Keep functions small, doing one thing only; extract additional responsibilities into named functions.

## Principle

Functions should do one thing, do it well, and do it only. A function should be small enough to be understood at a glance - typically no more than a screenful of code. When a function does more than one thing, extract the additional responsibilities into separate, well-named functions. Small functions with a single purpose are easier to read, test, reuse, and replace.

## Why it matters

Large, multi-purpose functions are the primary source of accidental complexity in codebases. They resist comprehension, resist testing, and resist change. A developer encountering a 200-line function must hold the entire flow in working memory to make any modification safely. Small functions reduce this cognitive burden to a manageable scope.

## Violations to detect

- Functions longer than approximately 20-30 lines (a reasonable heuristic, not an absolute rule)
- Functions with multiple levels of abstraction - high-level orchestration mixed with low-level detail
- Functions with many parameters, suggesting they handle multiple concerns
- Functions that require extensive scrolling to read in their entirety
- Functions whose name requires "and" or "or" to describe what they do

## Inspection

- `awk '/^[[:space:]]*(def |function |func |public |private |protected |static )/{start=NR; name=$0} /^[[:space:]]*\}|^[[:space:]]*end[[:space:]]*$/{if(start && NR-start>30) print FILENAME":"start": long function ("NR-start" lines): "name; start=0}' $(find $TARGET -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.java" -o -name "*.go" -o -name "*.rb" -o -name "*.cs" 2>/dev/null)` | MEDIUM | Functions exceeding 30 lines

## Good practice

- Extract each distinct step or responsibility into its own function with a descriptive name
- Keep functions at a single level of abstraction - a function should either orchestrate or perform detail work, not both
- Use the "extract till you drop" technique: keep extracting until each function does exactly one thing
- Treat the number of function parameters as a smell - more than two or three often signals that a concept should be grouped into an object

## Sources

- Martin, Robert C. *Clean Code: A Handbook of Agile Software Craftsmanship*. Prentice Hall, 2008. ISBN 978-0-13-235088-4. Chapter 3: "Functions."
