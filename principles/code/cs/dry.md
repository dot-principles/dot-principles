# CODE-CS-DRY — DRY: Don't Repeat Yourself

**Layer:** 1 (universal)
**Categories:** code-smells, maintainability, refactoring
**Applies-to:** all
**Summary:** Every piece of knowledge must have a single, authoritative representation in the system.

## Principle

Every piece of knowledge must have a single, unambiguous, authoritative representation within a system. DRY is not about eliminating duplicate lines of code — it is about ensuring that each business rule, algorithm, or policy decision exists in exactly one place. If the same decision is encoded in multiple locations, they will inevitably diverge.

## Why it matters

When knowledge is duplicated, changing a business rule requires finding and updating every copy. Missed copies become bugs. The more copies exist, the harder it becomes to know which one is authoritative, and the more likely it is that a future developer changes the wrong one or only some of them.

## Violations to detect

- The same business rule or calculation implemented in multiple places
- Constants or configuration values defined in more than one location
- Validation logic duplicated between client and server without a shared source of truth
- Database schema knowledge hardcoded in application code instead of derived from the schema
- Copy-pasted code blocks that encode the same decision (not just similar structure)

## Inspection

- `find $TARGET -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.java" -o -name "*.go" -o -name "*.cs" | xargs awk 'NF{print}' 2>/dev/null | sort | uniq -cd | sort -rn | head -20` | LOW | Most frequently duplicated non-blank lines across source files

## Good practice

- Extract shared knowledge into a single authoritative source (function, constant, schema, config)
- Distinguish between knowledge duplication (bad) and structural similarity (sometimes acceptable)
- Three similar lines of code is often better than a premature abstraction — only extract when the duplication represents the same decision
- Use code generation or schema-first approaches to derive code from a single source of truth

## Sources

- Hunt, Andrew; Thomas, David. *The Pragmatic Programmer*, 20th Anniversary ed. Addison-Wesley, 2019. ISBN 978-0-13-595705-9. Chapter 2: "DRY — The Evils of Duplication."
- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Duplicated Code."
