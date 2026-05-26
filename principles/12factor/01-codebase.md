# 12FACTOR-01-CODEBASE - Codebase

**Layer:** 2 (contextual)
**Categories:** architecture, cloud-native, deployment
**Applies-to:** cloud-native, twelve-factor-apps
**Summary:** Maintain one codebase per app in version control; deploy it to many environments without branching.

## Principle

One codebase tracked in version control, deployed to many environments. If there are multiple codebases, it is a distributed system - each component of which may independently be a twelve-factor app. Multiple apps sharing the same code should extract that code into a library.

## Why it matters

Multiple codebases for the same app make coordinated deployments error-prone, drift inevitable, and traceability impossible. A single codebase is the source of truth; every deploy is a known revision of it.

## Violations to detect

- Copying code between repositories instead of extracting a shared library
- Manual patching of deployed servers rather than deploying from version control
- Environment-specific branches (e.g., `branch-production`) diverging from the main codebase
- Multiple apps in a single repository without clear module boundaries (monorepo confusion)

## Good practice

- One repo → many deploys (staging, production, developer preview) - each is a different deployed version of the same codebase
- Use package managers and versioned libraries for shared code; never copy-paste across repos
- Track every deploy to a specific commit SHA for full auditability

## Sources

- Wiggins, Adam. *The Twelve-Factor App*. Heroku, 2011. https://12factor.net/codebase
