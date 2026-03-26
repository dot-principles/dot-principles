# 12FACTOR-12-ADMIN-PROCESSES — Admin Processes

**Layer:** 2 (contextual)
**Categories:** architecture, cloud-native, operations
**Applies-to:** cloud-native, twelve-factor-apps
**Summary:** Run admin tasks as one-off processes using the same code, environment, and config as the running app.

## Principle

Run admin and management tasks — database migrations, one-time data fixes, console sessions — as one-off processes in the same environment as the regular long-running processes. Admin code ships with the application code and runs against the same release.

## Why it matters

Admin tasks run outside the normal request/response cycle but must operate against production data. If they run in a different environment, with different code, or with different config, they can diverge from the app's assumptions and cause data corruption or subtle breakages.

## Violations to detect

- Database migrations run from a developer's local machine directly against production
- Admin scripts maintained in a separate repository with separate dependencies and config
- One-time data fixes applied via raw SQL executed outside the app's migration framework
- Manual server access (SSH + psql) to perform tasks that could be encapsulated in an admin command

## Good practice

- Package migrations and admin commands in the app's source; run them as `heroku run`, `kubectl exec`, or equivalent
- Use database migration frameworks (Flyway, Liquibase, Alembic, ActiveRecord migrations) — never raw SQL applied manually
- Test admin commands in staging before running in production, using the same deployment mechanism
- Log admin process runs with who ran them, when, and what was changed

## Sources

- Wiggins, Adam. *The Twelve-Factor App*. Heroku, 2011. https://12factor.net/admin-processes
