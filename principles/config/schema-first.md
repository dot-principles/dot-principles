# CONFIG-SCHEMA-FIRST - Declare a schema for every configuration file

**Layer:** 1 (universal)
**Categories:** configuration, reliability, tooling
**Applies-to:** config
**Summary:** Define a schema declaring every config key before writing values; validate config files against it in CI.

## Principle

Before writing configuration values, define a schema that declares every expected key, its type, constraints, and whether it is required or optional. Config files reference their schema (via `$schema`, a Pydantic model, or equivalent) so that editors, linters, and CI tools can validate them before the application ever runs. Schema and config live together in version control and are updated atomically.

## Why it matters

Without a declared schema, configuration files drift: keys accumulate without documentation, types change silently, and the only truth about what the application expects is buried in application code. A schema-first approach makes config files self-describing, enables editor validation, and closes the gap between "what the app expects" and "what the file says."

## Violations to detect

- Configuration files with no `$schema` field, no referenced JSON Schema, and no associated schema definition
- Config values added or changed without updating the schema definition
- Schema and config that describe different keys (schema defines `db.host`, config has `database.host`)
- No CI step that validates config files against their schema
- Application code is the only documentation of what config keys exist and what types they expect

## Good practice

- Add `$schema: "path/to/schema.json"` or `# yaml-language-server: $schema=...` to YAML files so editors validate on save
- Define application configuration as a typed schema first: Pydantic `BaseSettings`, Spring Boot `@ConfigurationProperties`, Go `envconfig` struct, Zod object, JSON Schema file
- Store the schema alongside the config in VCS; update both in the same commit
- Validate config against schema in CI using `ajv`, `jsonschema`, `check-jsonschema`, or equivalent
- Use schema tooling to generate `.env.example` or config documentation automatically

## Sources

- JSON Schema. "JSON Schema - A Vocabulary for Structural Validation of JSON." https://json-schema.org/specification (accessed 2026-03-22).
- Pydantic. "Settings Management." https://docs.pydantic.dev/latest/concepts/pydantic_settings/ (accessed 2026-03-22).
- Wiggins, Adam. "The Twelve-Factor App - III. Config." https://12factor.net/config (accessed 2026-03-22).
