# CONFIG-SCHEMA-VALIDATION — Validate configuration against a schema at startup

**Layer:** 1 (universal)
**Categories:** reliability, configuration
**Applies-to:** config
**Summary:** Validate all configuration against a schema at startup and fail immediately on any missing or malformed value.

## Principle

Configuration should be validated against a schema at application startup. Missing required values, incorrect types, out-of-range values, and malformed URLs should cause an immediate, descriptive startup failure — not a silent default, a null pointer, or a runtime crash minutes into operation. The application should refuse to start rather than run in a misconfigured state.

## Why it matters

Configuration errors are one of the most common causes of production incidents. When missing or malformed config is not caught at startup, the application appears to start normally but fails later — often at the worst possible moment (first request, first database call, first scheduled job). Early validation converts late, confusing failures into early, clear ones.

## Violations to detect

- Configuration values read with `os.getenv("KEY")` or equivalent without any validation of presence or format
- Optional-by-default config reads where a missing value silently falls back to `None`, `null`, or an empty string in a production-critical path
- Database hostnames, port numbers, URLs, or timeouts used directly without format validation
- No startup check that required environment variables are set
- Configuration values validated only at first use (lazy validation) rather than at startup (eager validation)

## Good practice

- Use a typed configuration schema: Pydantic `BaseSettings`, Spring Boot's `@ConfigurationProperties` with `@Validated`, Go's `envconfig` with `required` tags, .NET's `IOptions<T>` with data annotations
- Validate at the composition root — before any application logic runs
- Fail with a descriptive error naming the missing key and its expected format: `Missing required configuration: DATABASE_URL (expected: postgres://host:port/db)`
- Separate required from optional config in the schema; optional values should have explicit documented defaults
- Include configuration validation in integration tests to catch schema drift

## Sources

- Wiggins, Adam. "The Twelve-Factor App — III. Config." https://12factor.net/config (accessed 2026-03-18).
- Richardson, Chris. *Microservices Patterns*. Manning, 2018. ISBN 978-1-61729-454-9. Chapter 11 (health checks and startup validation).
