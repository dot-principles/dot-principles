# CODE-CS-EXCEPTIONS-FOR-EXCEPTIONAL-CONDITIONS - Exceptions for exceptional conditions only

**Layer:** 1 (universal)
**Categories:** error-handling, reliability, code-quality
**Applies-to:** all
**Summary:** Use exceptions only for genuinely exceptional conditions, never for ordinary control flow.

## Principle

Exceptions are for exceptional conditions - situations that the caller cannot reasonably be expected to handle in advance or that represent genuine failures. Do not use exceptions as a control-flow mechanism for ordinary branching, loop termination, or expected cases. Overloading exceptions with routine logic obscures intent, degrades performance, and makes code harder to reason about.

## Why it matters

When exceptions are used for normal flow, call sites become impossible to reason about without knowing what a method might throw and when. Catch blocks used for branching hide the actual logic, and callers cannot distinguish genuine failures from ordinary paths. Performance also suffers: constructing and throwing an exception is expensive compared to a conditional check. Code that distinguishes "exceptional" from "expected" is clearer, faster, and safer.

## Violations to detect

- `try/catch` blocks whose catch body implements a non-error branch (e.g., returning a default value, continuing iteration, or redirecting flow)
- Exception-driven loops (`try { while(true) { iter.next(); } } catch (NoSuchElement) {}` pattern)
- Pokémon catches: `catch (Exception e)` or bare `except:` used to swallow any failure and continue
- Using exceptions as an optional-return substitute (throwing when nothing is found instead of returning an empty result)
- `try`/`except` wrapping code that has a cheap, non-throwing guard (`hasNext()`, `containsKey()`, null check)

## Inspection

- `grep -rnE 'catch\s*\([^)]*\)\s*\{[^}]*(continue|return [^;]{0,30};|break)\s*\}' --include="*.java" --include="*.cs" --include="*.kt" $TARGET` | MEDIUM | Catch block used for flow control (continue/return/break)
- `grep -rnE 'while\s*\(\s*true\s*\)[^{]*\{[^}]*\}\s*catch' --include="*.java" --include="*.cs" $TARGET` | HIGH | Infinite loop terminated by exception
- `grep -rnE 'except\s*[A-Za-z]*\s*:\s*\n\s*(pass|return|continue)' --include="*.py" $TARGET` | MEDIUM | Except used to suppress and branch
- `grep -rnE 'catch\s*\(\s*(Exception|Throwable|Error)\s+\w*\)\s*\{' --include="*.java" --include="*.kt" $TARGET` | MEDIUM | Pokémon catch (broad type used for flow)

## Good practice

```java
// Bad: using exception for expected "not found" case
try {
    return map.get(key);
} catch (NullPointerException e) {
    return defaultValue;
}

// Good: use the explicit check
return map.getOrDefault(key, defaultValue);
```

- Use the type system to express optional results (`Optional<T>`, nullable types, `Result<T, E>`) rather than throwing for absence
- Use guard clauses and precondition checks before entering code that might throw
- Reserve exceptions for unrecoverable failure, violated contracts, and genuinely unexpected states

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 69: "Use exceptions only for exceptional conditions."
- Martin, Robert C. *Clean Code*. Prentice Hall, 2008. ISBN 978-0-13-235088-4. Chapter 7: "Error Handling."
