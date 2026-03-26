# CODE-CS-CATCH-SPECIFIC-EXCEPTIONS — Catch the most specific exception type possible

**Layer:** 1 (universal)
**Categories:** error-handling, reliability, code-quality
**Applies-to:** all
**Summary:** Always catch the most specific exception type; never catch root exception types silently.

## Principle

Always catch the most specific exception type that matches the failure you intend to handle. Never catch a root type (`Exception`, `Throwable`, `BaseException`, `\Throwable`) unless you are at a top-level boundary (e.g., a global error handler or shutdown hook) and you intend to log-and-terminate, not silently continue.

## Why it matters

Catching a broad type masks unrelated failures. A `catch (Exception e)` will silently swallow `NullPointerException`, `OutOfMemoryError`, programming bugs, and security exceptions alongside the one case you actually intended to handle. This hides bugs, makes recovery logic incorrect, and makes the codebase unreliable. Specific catches document intent, surface unexpected failures loudly, and ensure recovery is only attempted when recovery is actually appropriate.

## Violations to detect

- `catch (Exception e)` in Java/C#/Kotlin that does anything other than re-throw, log-and-rethrow, or top-level shutdown
- `except Exception:` or bare `except:` in Python (catches `KeyboardInterrupt`, `SystemExit`, programming errors)
- `catch (\Throwable $e)` in PHP at non-boundary layers
- `catch (err)` in JavaScript/TypeScript inside library or service code (not a top-level handler)
- Re-catching a broad type and suppressing it (`catch (Exception e) { /* ignore */ }`)

## Inspection

- `grep -rnE 'catch\s*\(\s*(Exception|Throwable)\s+\w+\)' --include="*.java" --include="*.kt" $TARGET` | HIGH | Overly broad catch type (Java/Kotlin)
- `grep -rnE 'catch\s*\(\s*Exception\s+\w+\)' --include="*.cs" $TARGET` | HIGH | Overly broad catch type (C#)
- `grep -rnE '^\s*except\s*:\s*$|^\s*except\s+Exception\s*:' --include="*.py" $TARGET` | HIGH | Bare or broad except clause (Python)
- `grep -rnE 'catch\s*\(\\\\Throwable\s+' --include="*.php" $TARGET` | HIGH | Catching root Throwable in PHP
- `grep -rnE 'catch\s*\([^)]*\)\s*\{\s*\}' --include="*.java" --include="*.js" --include="*.ts" --include="*.cs" $TARGET` | HIGH | Caught and silently swallowed

## Good practice

```java
// Bad: catches programming errors, I/O failures, and everything else indiscriminately
try {
    processOrder(order);
} catch (Exception e) {
    log.warn("Something went wrong", e);
}

// Good: handle only the cases you expect and can recover from
try {
    processOrder(order);
} catch (InsufficientStockException e) {
    notifyInventoryTeam(e.getItemId());
} catch (PaymentGatewayException e) {
    scheduleRetry(order.getId());
}
// Let unexpected exceptions propagate to the top-level handler
```

- Catch one exception type per `catch` block where possible; avoid multi-catch for unrelated types
- At top-level / framework boundaries (servlet filters, message consumers, scheduled jobs), a broad catch is acceptable — log it and fail the unit of work, do not silently continue
- In languages with checked exceptions, declare thrown types precisely so callers can make informed decisions

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 73: "Throw exceptions appropriate to the abstraction." Item 77: "Don't ignore exceptions."
- Martin, Robert C. *Clean Code*. Prentice Hall, 2008. ISBN 978-0-13-235088-4. Chapter 7: "Error Handling."
