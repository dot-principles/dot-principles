# DB-SCHEMA-MIGRATIONS-AS-CODE - Schema migrations are code - version, review, and automate every schema change

**Layer:** 1
**Categories:** database, devops, maintainability, reliability
**Applies-to:** all
**Summary:** Express every schema change as a versioned migration file reviewed and applied exclusively by automated pipelines.

## Principle

Every database schema change - table creation, column addition, index creation, constraint modification - must be expressed as a versioned migration file that lives in source control, is reviewed like any other code change, and is applied by an automated pipeline. No schema change is made by hand, and no migration is run manually in production. The current schema state is always reproducible from the migration history.

## Why it matters

Manual schema changes produce environments that diverge from each other silently. A column added directly to production but not captured in a migration is missing from staging, CI, and every new developer's local database. When a manual change goes wrong, there is no rollback script and no record of what was changed. Treating migrations as code makes schema state deterministic, reviewable, and recoverable.

## Violations to detect

- Schema changes applied directly to a production or shared database via a client tool (psql, MySQL Workbench, pgAdmin) without a corresponding migration file in version control
- Migration files that are edited after they have been applied to any shared environment - once run, a migration is immutable
- Missing schema migrations for changes that exist in the codebase (e.g. an ORM model references a column that has no migration creating it)
- No automated migration step in the CI/CD pipeline - migrations are run manually before or after deployment

## Good practice

- Use a migration tool with sequential versioning (Flyway, Liquibase, Alembic, Rails Active Record Migrations, golang-migrate) so the applied version is tracked in the database itself
- Make every migration file idempotent or at minimum guarded: `CREATE TABLE IF NOT EXISTS`, `ADD COLUMN IF NOT EXISTS`
- Write both `up` and `down` (rollback) migrations for every change; test rollbacks in CI
- Enforce that no migration file is modified once it has been applied to a shared environment - treat the file as an immutable historical record

## Sources

- Humble, Jez and David Farley. *Continuous Delivery: Reliable Software Releases through Build, Test, and Deployment Automation*. Addison-Wesley, 2010. ISBN 978-0-321-60191-9. Chapter 12: "Managing Data."
- Flyway documentation. "Why database migrations?" Redgate. https://flywaydb.org/documentation/getstarted/why (accessed 2026-03-16).
