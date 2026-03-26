# CONFIG-EXPLICIT-OVER-CONVENTIONAL — Prefer explicit keys over magic conventions

**Layer:** 1 (universal)
**Categories:** configuration, maintainability, readability
**Applies-to:** config
**Summary:** Make every configuration key and its effect explicit; never rely on undocumented framework conventions.

## Principle

Configuration keys and their effects must be explicit and self-evident — not dependent on knowing a framework's undocumented defaults or magic conventions. Every key that influences behaviour should be named and present in the config file. When a framework treats an absent key as "use the default", that default must be documented in the schema, not discovered by reading the framework source.

## Why it matters

Convention-based configuration creates invisible coupling between config files and framework internals. When defaults change between framework versions, or when a new team member inherits the system, implicit conventions become subtle bugs. A config file that is only understandable to someone who knows the framework deeply is a maintenance liability — it looks correct but hides assumptions.

## Violations to detect

- Absent config keys relied upon to trigger a framework default (e.g., omitting `spring.main.banner-mode` rather than setting it explicitly)
- Magic values used as signals: empty strings, `0`, `null`, or absent keys to mean "disabled" without documentation
- Config files that require reading framework documentation to understand which defaults are in effect
- Commented-out keys with no explanation of what enabling them would do
- Framework auto-configuration relied upon without being declared in config

## Good practice

- Name every key that influences behaviour, even when the value matches the default; this makes intent visible and diffs meaningful
- Document what each key does and what value the application uses when it is absent
- Use schema `default` declarations (Pydantic `Field(default=...)`, JSON Schema `"default"`) rather than burying fallback logic in application code
- Prefer `feature_x_enabled: false` over omitting the key entirely
- Keep a `.env.example` or `config.example.yaml` that lists every supported key with a description and example value

## Sources

- Hunt, Andrew & Thomas, David. *The Pragmatic Programmer: Your Journey to Mastery*. 20th Anniversary Edition. Addison-Wesley, 2019. ISBN 978-0-13-595705-9. Tip 14: "There Are No Final Decisions" (favour explicitness over hidden defaults).
- Wiggins, Adam. "The Twelve-Factor App — III. Config." https://12factor.net/config (accessed 2026-03-22).
