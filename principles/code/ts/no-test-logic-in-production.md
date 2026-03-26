# CODE-TS-NO-TEST-LOGIC-IN-PRODUCTION — Never add test-specific branches to production code

**Layer:** 2 (contextual)
**Categories:** testing, quality, reliability
**Applies-to:** all
**Summary:** Never add test-only branches to production code; use dependency injection or seams instead.

## Principle

Production code must not contain branches, imports, or configuration that exist solely to accommodate tests. Test-specific conditionals — environment guards, `if testing`, `if process.env.NODE_ENV === 'test'`, `#ifdef TEST`, or references to test package names — indicate that the code is not designed for testability. Use dependency injection, seams, or the Humble Object pattern instead.

## Why it matters

Test-only branches ship to production and can be exploited or cause unexpected behaviour. They also mask the real design problem: the code was not written to be testable. Every such branch is evidence of a missing abstraction — a seam where a dependency should be injected.

## Violations to detect

- Production source files containing `if (env === "test")`, `if (process.env.NODE_ENV === "test")`, or `if (testing)` guards
- Production classes that import or reference test packages (`junit`, `pytest`, `testify`, `jest`, `XCTest`)
- Feature flags or configuration keys whose sole purpose is to disable real behaviour during test execution
- Constructors or methods with a boolean parameter like `isTest` or `useFake` that changes code paths
- Commented-out code blocks labelled "for testing only"

## Inspection

- `grep -rnE 'NODE_ENV.*test|env.*==.*["\x27]test["\x27]|if.*testing|IS_TEST|isTest\s*=' --include="*.js" --include="*.ts" --include="*.py" --include="*.go" --include="*.java" --include="*.cs" $TARGET` | HIGH | Test-specific environment guards in source files
- `grep -rnE 'import.*junit|import.*pytest|import.*testify|import.*XCTest' --include="*.java" --include="*.go" --include="*.swift" $TARGET` | HIGH | Test framework imports in non-test source files

## Good practice

- Use dependency injection to supply real or substitute implementations at the call site; the production class never knows which it received
- Apply the Humble Object pattern (see CODE-TS-HUMBLE-OBJECT) to move untestable infrastructure concerns to a thin shell
- Use environment-agnostic feature flags backed by a configuration interface rather than hard-coded env checks
- If a seam is needed in an existing codebase, extract an interface and inject it — do not add a conditional

## Sources

- Meszaros, Gerard. *xUnit Test Patterns: Refactoring Test Code*. Addison-Wesley, 2007. ISBN 978-0-13-149505-0. Chapter 16 "Test Logic in Production" (anti-pattern).
- Feathers, Michael. *Working Effectively with Legacy Code*. Prentice Hall, 2004. ISBN 978-0-13-117705-5. Chapter 3 "Sensing and Separation" (seams).
