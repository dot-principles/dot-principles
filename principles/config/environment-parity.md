# CONFIG-ENVIRONMENT-PARITY — Keep config structure identical across environments

**Layer:** 1 (universal)
**Categories:** configuration, reliability, devops
**Applies-to:** config
**Summary:** Keep config schema identical across all environments; vary only values, never structure or branching behaviour.

## Principle

The schema and structure of configuration — which keys exist, what sections they belong to, and what types they have — must be identical across all deployment environments (development, staging, production). Only the values differ. Application code must never branch on environment name to change its behaviour; use explicit configuration values instead. Every environment is a faithful structural replica of production, loaded from environment-specific values.

## Why it matters

When dev and production config schemas diverge, a missing or renamed key in production is only discovered at deployment — not in development or CI. Environment-specific branching in code (`if NODE_ENV === "production"`) hides prod-only code paths that never execute in lower environments, making the most critical paths the least tested. Parity makes every environment a trusted preview of the next.

## Violations to detect

- Application code branching on environment name: `if os.getenv("ENV") == "production":`, `if (process.env.NODE_ENV === 'production')`, `if (spring.profiles.active == "prod")`
- Config files with keys present in one environment but absent in another (dev has `debug_sql: true`, prod has no `debug_sql` key at all)
- Different config schema versions or structures per environment
- Features enabled in production by absence of a key rather than by an explicit value
- Hard-coded environment detection replacing configurable values

## Inspection

- `grep -rn "NODE_ENV.*production\|ENV.*production\|profiles.active.*prod" --include="*.js" --include="*.ts" --include="*.py" --include="*.java" $TARGET` | MEDIUM | Environment-name branching in application code

## Good practice

- Use a single config schema for all environments; populate it with environment-specific values via environment variables, secrets management, or per-environment `.env` files
- Replace `if env == "production": enable_feature_x()` with `feature_x_enabled: ${FEATURE_X_ENABLED:-false}` in config
- Use Spring Profiles, Pydantic Settings, or Helm values files to inject environment-specific values — not environment-name checks in code
- Test with production-like configuration values in CI to surface schema drift early
- Validate that all environments use the same config schema version in CD pipelines

## Sources

- Wiggins, Adam. "The Twelve-Factor App — VII. Dev/Prod Parity." https://12factor.net/dev-prod-parity (accessed 2026-03-22).
- Humble, Jez & Farley, David. *Continuous Delivery: Reliable Software Releases through Build, Test, and Deployment Automation*. Addison-Wesley, 2010. ISBN 978-0-321-60191-9. Chapter 2 (Configuration Management).
