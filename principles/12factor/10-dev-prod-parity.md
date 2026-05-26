# 12FACTOR-10-DEV-PROD-PARITY - Dev/Prod Parity

**Layer:** 2 (contextual)
**Categories:** architecture, cloud-native, quality
**Applies-to:** cloud-native, twelve-factor-apps
**Summary:** Keep development, staging, and production environments as similar as possible to prevent environment-specific bugs.
**Audit-scope:** limited - can detect env-conditional branches and hard-coded local connection strings; cannot verify whether dev and prod use different backing services (requires deployment config)

## Principle

Keep development, staging, and production as similar as possible. Minimise the gap in time (deploy frequently), personnel (developers deploy their own code), and tools (use the same backing services in all environments). Differences between environments are a primary source of bugs that only appear in production.

## Why it matters

The "works on my machine" failure mode is caused by environment divergence. SQLite in dev and PostgreSQL in production have different SQL dialects, concurrency behaviour, and constraint enforcement. Differences in OS, library versions, and service configurations make bugs invisible until they reach the environment where they matter most.

## Violations to detect

- Different database engines in development and production (SQLite vs. PostgreSQL, H2 vs. MySQL)
- Long-lived feature branches that are only merged and deployed infrequently
- No staging environment - code goes directly from development to production
- Developers who write code but do not deploy or observe it in production
- Environment-specific workarounds or conditional code paths for dev vs. production

## Good practice

- Use Docker Compose or Testcontainers to run real backing services locally
- Deploy small changes frequently rather than large batches infrequently
- Make developers responsible for deploying and monitoring their changes in production
- Use infrastructure-as-code so all environments are defined from the same templates

## Sources

- Wiggins, Adam. *The Twelve-Factor App*. Heroku, 2011. https://12factor.net/dev-prod-parity
