# CONFIG-EXPLICIT-DEFAULTS - Declare and document defaults for every optional key

**Layer:** 1 (universal)
**Categories:** configuration, reliability, maintainability
**Applies-to:** config
**Summary:** Declare every optional config key's default explicitly in the schema, not buried in application fallback logic.

## Principle

Every optional configuration key must have an explicit, documented default value declared in the schema or configuration reference - not inferred from application fallback logic buried in code. Defaults must be safe and correct for local development but clearly unsuitable for production without conscious override; production values must always be set explicitly. No configuration key's default should be a surprise.

## Why it matters

Implicit defaults are hidden assumptions. A connection timeout defaulting to 30 seconds, a pool size defaulting to 10, or a log level defaulting to `DEBUG` are invisible until a production incident surfaces them. When defaults live in application code rather than configuration schemas, they are hard to find, easy to overlook in code review, and impossible to validate without running the application.

## Violations to detect

- `os.getenv("KEY", "fallback")` or `config.get("key", default)` where the fallback is not declared in the schema or documented anywhere
- Schema definitions with no `default` field for optional keys
- Production running on development-safe defaults because explicit values were never set
- Configuration documentation that does not list defaults for optional keys
- Default values that change between framework versions without notice (convention, not declaration)

## Good practice

- Declare defaults in schema: Pydantic `Field(default=30)`, JSON Schema `"default": 30`, Spring Boot `@Value("${timeout:30}")`, Go `envconfig` `default:"30"`
- Document each default inline: what it is, why it was chosen, and when it should be overridden
- Make production-unsafe defaults obvious: `log_level: DEBUG  # override to INFO or WARNING in production`
- Use separate `.env.example` or `values.example.yaml` showing recommended production values next to development defaults
- Include schema-default validation in integration tests to catch silent default changes after framework upgrades

## Sources

- Wiggins, Adam. "The Twelve-Factor App - III. Config." https://12factor.net/config (accessed 2026-03-22).
- Pydantic. "Fields - Default Values." https://docs.pydantic.dev/latest/concepts/fields/#default-values (accessed 2026-03-22).
- Spring Framework. "Externalized Configuration." Spring Boot Reference Documentation. https://docs.spring.io/spring-boot/reference/features/external-config.html (accessed 2026-03-22).
