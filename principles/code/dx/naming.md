# CODE-DX-NAMING — Name things by what they represent

**Layer:** 1 (universal)
**Categories:** developer-experience, readability, maintainability
**Applies-to:** all
**Summary:** Every name must reveal intent; never use a name that requires a comment to explain it.

## Principle

Names should reveal intent. A variable, function, class, or module name should tell the reader what it represents or what it does, not how it is implemented. The name should make the code readable without requiring comments to explain it. If a name requires a comment, the name is wrong.

## Why it matters

Code is read far more often than it is written. Poor names force every future reader to decode what the author meant, wasting time and increasing the risk of misunderstanding. Good names make code self-documenting and reduce the need for explanatory comments that can drift out of sync with the code.

## Violations to detect

- Single-letter variables outside of trivial loop counters (`i`, `j` in `for` loops are acceptable)
- Names that describe implementation rather than purpose (`list`, `map`, `data`, `temp`, `result`)
- Abbreviated names that sacrifice clarity (`usr`, `mgr`, `proc`, `impl`)
- Boolean variables or methods without a predicate form (`flag`, `status` instead of `isActive`, `hasPermission`)
- Functions named with vague verbs (`handle`, `process`, `manage`, `do`) without specifying what

## Inspection

- `grep -rnE '\b(temp|tmp|data|result|retval|foo|bar|baz)\b\s*=' --include="*.py" --include="*.js" --include="*.ts" --include="*.java" --include="*.go" --include="*.cs" $TARGET` | LOW | Generic variable names lacking intent
- `grep -rnE '(var|let|const|int|string|auto)\s+[a-z]\s*[=;,)]' --include="*.js" --include="*.ts" --include="*.java" --include="*.go" --include="*.cs" $TARGET` | LOW | Single-letter variable names (non-loop)

## Good practice

- Use domain vocabulary — name things using the language of the problem domain, not technical jargon
- Make the name proportional to its scope — wider scope demands more descriptive names
- Use verb phrases for functions (`calculateTotal`, `validateInput`), noun phrases for values and types (`orderTotal`, `UserAccount`)
- If you struggle to name something, it may have too many responsibilities — consider splitting it

## Sources

- Martin, Robert C. *Clean Code*. Prentice Hall, 2008. ISBN 978-0-13-235088-4. Chapter 2: "Meaningful Names."
- Beck, Kent. *Implementation Patterns*. Addison-Wesley, 2007. ISBN 978-0-321-41309-3. Chapter 3: "A Theory of Programming."
