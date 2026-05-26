# CODE-CS-FAIL-FAST - Fail fast, fail loudly

**Layer:** 1 (universal)
**Categories:** reliability, error-handling, debugging
**Applies-to:** all
**Summary:** Detect errors as early as possible and report them clearly; never silently continue in a broken state.

## Principle

When something goes wrong, detect it as early as possible and report it clearly. Do not silently swallow errors, return default values for invalid input, or continue execution in an inconsistent state. The closer the failure is to its cause, the easier it is to diagnose and fix.

## Why it matters

Silent failures are the most expensive kind of bug. They allow corrupted data to propagate, bad state to accumulate, and symptoms to appear far from the cause. A null pointer exception three layers deep is harder to debug than a validation error at the entry point. Systems that fail fast are easier to operate, debug, and trust.

## Violations to detect

- Empty `catch` blocks that swallow exceptions without logging or re-throwing
- Methods that return `null` or a default value when the input is invalid, instead of throwing
- Catch-all exception handlers (`catch (Exception e)`) that hide specific failure modes
- Boolean return values for operations that can fail in multiple ways
- Error codes ignored by callers (return value not checked)
- `TODO: handle error` comments left in catch blocks

## Inspection

- `grep -rnE 'catch\s*\([^)]*\)\s*\{\s*\}' --include="*.java" --include="*.js" --include="*.ts" --include="*.cs" $TARGET` | HIGH | Empty catch blocks swallowing exceptions
- `grep -rnE '^\s*except:\s*$|^\s*except\s+Exception\s*:' --include="*.py" $TARGET` | HIGH | Bare except or overly broad exception handler
- `grep -rnE 'catch\s*\{' --include="*.kt" --include="*.swift" $TARGET` | MEDIUM | Catch-all without specific exception type
- `grep -rnE 'TODO.*handle.*error|FIXME.*error' -i $TARGET` | MEDIUM | Deferred error handling

## Good practice

- Validate preconditions at the start of functions and throw immediately on violation
- Use specific exception types that describe what went wrong, not generic ones
- Log errors with enough context to diagnose the problem (input values, state, correlation IDs)
- Prefer exceptions or Result types over error codes - they cannot be silently ignored
- In distributed systems, propagate errors with context rather than swallowing them at service boundaries

## Sources

- Hunt, Andrew; Thomas, David. *The Pragmatic Programmer*, 20th Anniversary ed. Addison-Wesley, 2019. ISBN 978-0-13-595705-9. Topic 24: "Dead Programs Tell No Lies."
- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 72: "Favor the use of standard exceptions." Item 77: "Don't ignore exceptions."
- Shore, Jim. "Fail Fast." https://www.martinfowler.com/ieeeSoftware/failFast.pdf. IEEE Software, 2004.
