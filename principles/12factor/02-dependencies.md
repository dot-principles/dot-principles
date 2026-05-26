# 12FACTOR-02-DEPENDENCIES - Dependencies

**Layer:** 2 (contextual)
**Categories:** architecture, cloud-native, dependency-management
**Applies-to:** cloud-native, twelve-factor-apps
**Summary:** Explicitly declare and isolate all dependencies; never rely on implicit system-wide packages.

## Principle

Explicitly declare and isolate dependencies. Never rely on the implicit existence of system-wide packages. Use a dependency declaration manifest and an isolation mechanism so that the app's dependency set is complete, consistent, and reproducible across all environments.

## Why it matters

Implicit dependencies create works-on-my-machine failures. If an app relies on a system tool or library that happens to be installed on production but not in CI, the deploy is fragile. Explicit declaration ensures that a fresh checkout can be built and run anywhere without manual environment setup.

## Violations to detect

- Relying on globally installed system packages (e.g., `ImageMagick`, `curl`) that are not declared in the project
- No lock file - dependencies pinned to a range rather than an exact resolved version
- Instructions to "manually install X before running" in the README
- Vendored dependencies not version-controlled or reproduced at build time

## Good practice

- Use `package.json`/`package-lock.json`, `pom.xml`, `go.mod`, `requirements.txt` + `pip freeze`, etc., to fully declare all dependencies
- Use Docker or similar isolation to prevent ambient system tools from masking missing declarations
- Pin exact versions in lock files for reproducible builds

## Sources

- Wiggins, Adam. *The Twelve-Factor App*. Heroku, 2011. https://12factor.net/dependencies
