# SIMPLE-DESIGN-REVEALS-INTENTION - Reveals Intention

**Layer:** 1 (universal)
**Categories:** software-design, readability, simplicity
**Applies-to:** all
**Summary:** Every name and structure must reveal its purpose so that readers need not decipher the code.

## Principle

Code should clearly communicate its purpose to the reader. Every name, structure, and abstraction should reveal the programmer's intent so that another developer can understand what the code does and why without needing to decipher it. Beck states that the code should "reveal intention" - making the system easy to understand is the second most important rule of simple design.

## Why it matters

Code is read far more often than it is written. When code obscures its intent through cryptic names, clever tricks, or unclear structure, every future reader pays a tax in comprehension time. Intention-revealing code reduces bugs caused by misunderstanding, makes onboarding faster, and lowers the cost of maintenance.

## Violations to detect

- Variable or function names that are single letters, abbreviations, or meaningless (e.g., `d`, `tmp2`, `processData`)
- Boolean parameters or magic numbers without explanation
- Complex expressions that could be extracted into a well-named variable or method
- Comments that explain *what* the code does rather than the code being self-explanatory
- Inconsistent naming conventions within the same codebase

## Good practice

- Choose names that describe the domain concept, not the implementation detail (e.g., `elapsedTimeInDays` not `d`)
- Extract complex conditionals into methods or variables with descriptive names
- Replace magic numbers and strings with named constants
- Use domain language from the project's ubiquitous vocabulary
- Structure code so that reading it top-down tells a coherent story

## Sources

- Beck, Kent. *Extreme Programming Explained: Embrace Change*, 2nd ed. Addison-Wesley, 2004. ISBN 978-0-321-27865-4.
- Fowler, Martin. "BeckDesignRules." https://martinfowler.com/bliki/BeckDesignRules.html
