# CONFIG-NO-HARDCODED-SECRETS - Never hardcode secrets in configuration files

**Layer:** 1 (universal)
**Categories:** security, configuration
**Applies-to:** config
**Summary:** Never commit secrets to version control; supply them at runtime via dedicated secrets management tooling.

## Principle

Secrets - passwords, API keys, tokens, database credentials, private keys, and certificates - must never appear in configuration files committed to version control. Configuration files in VCS are readable by everyone with repo access, stored permanently in history, and often copied across environments. Use secrets management tooling (Vault, AWS Secrets Manager, Azure Key Vault, environment injection) to supply secrets at runtime.

## Why it matters

A hardcoded secret in a committed config file is effectively a public credential. Once committed, it exists in git history even after deletion. Repository access (including read-only) exposes every secret ever committed. Secrets rotate; hardcoded values do not. Breaches from leaked credentials are among the most common causes of data breaches.

## Violations to detect

- Passwords, API keys, tokens, or private keys appearing as literal string values in `.env`, `.yaml`, `.json`, `.properties`, or `.conf` files
- `password: mysecretpassword` or `api_key: sk-abc123...` in any configuration file
- Connection strings with embedded credentials: `postgres://user:password@host/db`
- Private key or certificate content embedded inline in config
- `SECRET_KEY = "hardcoded-value"` in settings files

## Inspection

- `grep -rn "password\s*[:=]\s*['\"].\+" --include="*.yaml" --include="*.yml" --include="*.env" --include="*.properties" $TARGET` | HIGH | Possible hardcoded password
- `grep -rn "api_key\s*[:=]\s*['\"].\+" --include="*.yaml" --include="*.json" $TARGET` | HIGH | Possible hardcoded API key

## Good practice

- Use environment variable references: `password: ${DB_PASSWORD}` or `password: {{ env "DB_PASSWORD" }}`
- Use secrets management integrations: Vault agent injection, AWS Secrets Manager rotation, Kubernetes secrets referenced via `secretKeyRef`
- Store only `.env.example` (with placeholder values) in VCS; `.env` in `.gitignore`
- Rotate any secret that has been committed, even temporarily - git history is permanent
- Use `git-secrets`, `detect-secrets`, or `truffleHog` in CI to catch accidental commits

## Sources

- OWASP. "Secrets Management Cheat Sheet." OWASP Cheat Sheet Series. https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html (accessed 2026-03-18).
- Wiggins, Adam. "The Twelve-Factor App - III. Config." https://12factor.net/config (accessed 2026-03-18).
