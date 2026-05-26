# CODE-CS-WET - WET: Write Every Time

**Layer:** 1 (universal)
**Categories:** code-smells, maintainability, refactoring
**Applies-to:** all
**Summary:** Eliminate duplicated knowledge; never encode the same rule or policy in multiple places.

## Principle

WET (Write Every Time) is the named anti-pattern opposite to DRY. WET code duplicates knowledge - the same business rule, calculation, or policy encoded in multiple places - so that any change requires writing the same fix every time, in every copy. Recognising WET code is the first step to eliminating it.

The related heuristic: tolerate a single duplication (a second copy is a signal); treat a third copy as a requirement to unify. This guards against the opposite failure - premature abstraction from a single example.

## Why it matters

WET code makes change expensive and error-prone. When knowledge lives in three places, a bug fix applied to two becomes a new bug in the third. The more copies exist, the harder it is to know which is authoritative, and the more likely future developers will update only some of them. WET code is a primary driver of regression bugs and maintenance overhead.

## Violations to detect

- The same business rule or formula implemented in multiple services, classes, or functions
- Validation logic that exists independently on client, server, and database
- Copy-pasted code blocks that encode the same decision across three or more callsites
- Multiple constants or configuration values with the same meaning defined separately
- Tests that duplicate the logic they are testing instead of asserting outcomes

## Good practice

- A single duplication is tolerable; a third copy is the signal to extract a shared source of truth
- Before extracting, confirm the copies represent the same *concept*, not just similar *structure* - superficially similar code that serves different purposes should stay separate
- Apply DRY to knowledge, not to lines: two unrelated functions that happen to look alike are not WET
- In tests, prefer duplication over shared helpers that couple test cases to each other

## Sources

- Hunt, Andrew; Thomas, David. *The Pragmatic Programmer*, 20th Anniversary ed. Addison-Wesley, 2019. ISBN 978-0-13-595705-9.
- Fowler, Martin. *Refactoring*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9.
