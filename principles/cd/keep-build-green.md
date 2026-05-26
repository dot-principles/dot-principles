# CD-KEEP-BUILD-GREEN - A failing build is the team's highest priority; nothing else ships until it passes

**Layer:** 1
**Categories:** devops, continuous-delivery, testing, quality
**Applies-to:** all
**Summary:** Treat a failing main branch build as the team's highest priority; nothing ships until it passes.

## Principle

The CI build must always pass on the main branch. When it breaks, fixing it is the entire team's top priority - no new work is merged until the build is green. A build that is allowed to stay red loses its value as a quality gate: teams stop trusting it and begin working around it.

## Why it matters

A broken build on main means the codebase is in an unknown state. Features cannot be released, problems cannot be isolated, and every developer who pulls main is contaminated. Tolerance for red builds trains the team to ignore build failures, eventually rendering CI meaningless. The build must be fast, reliable, and treated as non-negotiable.

## Violations to detect

- Skipped or disabled tests in CI configuration (`--ignore-failures`, `continueOnError: true`, `|| true` after test commands)
- Tests marked as `@Ignore`, `@Disabled`, `skip(...)`, or `xit(...)` without a linked issue or expiry date
- CI pipeline configured to proceed to deployment even when test stages fail
- `TODO: fix this test` comments near disabled or commented-out test assertions
- Build scripts that suppress or swallow error exit codes to force a green status

## Inspection

```bash
# Skipped/disabled tests (Java/Kotlin)
grep -rn "@Ignore\|@Disabled" --include="*.java" --include="*.kt" .

# Skipped tests (JavaScript/TypeScript)
grep -rn "\bxit\b\|\bxdescribe\b\|test\.skip\|it\.skip\|describe\.skip" --include="*.js" --include="*.ts" --include="*.spec.*" .

# Skipped tests (Python)
grep -rn "@unittest.skip\|pytest.mark.skip\|skipTest" --include="*.py" .

# CI error suppression
grep -rn "|| true\|continueOnError\|ignore_errors\|continue-on-error" --include="*.yml" --include="*.yaml" --include="Makefile" --include="Jenkinsfile" .
```

## Good practice

- Treat a red main branch as a production incident - stop new work and revert or fix immediately
- If a test is genuinely flaky, fix it or delete it - never disable it
- Set branch protection rules that block merging when CI is red
- Use a shared dashboard or Slack/Teams notifications so every team member sees the build status immediately
- If fixing the breakage takes more than an hour, revert the offending commit and fix forward on a branch

## Sources

- Humble, Jez, and David Farley. *Continuous Delivery*. Addison-Wesley, 2010. ISBN 978-0-321-60191-9. Chapter 3.
- Fowler, Martin. "Continuous Integration." martinfowler.com, 2006. https://martinfowler.com/articles/continuousIntegration.html (accessed 2024-01-01).
