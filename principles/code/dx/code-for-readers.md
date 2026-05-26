# CODE-DX-CODE-FOR-READERS - Write code for the reader, not the writer

**Layer:** 1 (universal)
**Categories:** developer-experience, readability
**Applies-to:** all
**Summary:** Write code to be read by humans first; prioritize clarity over cleverness in every choice.

## Principle

Programs must be written for people to read, and only incidentally for machines to execute. Prioritize clarity over cleverness. Every choice - naming, structure, formatting, abstraction level - should optimize for the next developer who will read this code, who may be a teammate, a future maintainer, or your future self.

## Why it matters

Code is read many more times than it is written. The time saved by writing terse or clever code is dwarfed by the cumulative time every future reader spends deciphering it. Clear code reduces onboarding time, lowers defect rates, and makes reviews faster. Code that is easy to read is easy to change correctly.

## Violations to detect

- Clever one-liners that compress complex logic into an unreadable expression
- Unnecessary use of obscure language features when a straightforward alternative exists
- Code that relies on implicit behavior or side effects that the reader must already know about
- Deeply nested conditionals or ternary chains that require careful unwinding to understand
- Uncommented "magic numbers" or boolean flags whose meaning is not self-evident

## Good practice

- Prefer explicit over implicit - make control flow, data transformations, and dependencies visible
- Use intermediate variables with descriptive names to break up complex expressions
- Write code that reads top-to-bottom like a narrative, with each function calling the next at a consistent level of abstraction
- When choosing between two correct approaches, choose the one that will be clearer to a reader unfamiliar with the code
- Use comments to explain why, not what - the code should explain what

## Sources

- Martin, Robert C. *Clean Code: A Handbook of Agile Software Craftsmanship*. Prentice Hall, 2008. ISBN 978-0-13-235088-4.
- Abelson, Harold; Sussman, Gerald Jay. *Structure and Interpretation of Computer Programs*. 2nd ed. MIT Press, 1996. ISBN 978-0-262-51087-5. Preface: "Programs must be written for people to read, and only incidentally for machines to execute."
