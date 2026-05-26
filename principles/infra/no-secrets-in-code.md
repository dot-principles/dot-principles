# INFRA-NO-SECRETS-IN-CODE - Secrets never appear in code, config files, or logs

**Layer:** 1 (universal)
**Categories:** infrastructure, security, devops
**Applies-to:** all
**Summary:** Inject secrets at runtime from a secrets manager; never store credentials in code, config files, or logs.

## Principle

Passwords, API keys, tokens, certificates, and connection strings must never be stored in source code, committed to version control, written into configuration files that are checked in, or emitted to logs. Secrets are injected at runtime from a dedicated secrets manager. The test for compliance is simple: deleting the secrets manager should make every environment non-functional, while cloning the repository should reveal no working credentials.

## Why it matters

A secret committed to git is compromised - not just now, but for the full lifetime of the repository history. Rotation does not help if the old secret remains in git history. Secrets in logs are harvested by anyone with log access, which is typically a much wider audience than intended. The blast radius of a leaked secret ranges from account takeover to full infrastructure compromise.

## Violations to detect

- Credentials, tokens, or connection strings appearing in any `.env`, `application.yml`, `config.json`, or similar file committed to version control
- Hardcoded secrets anywhere in application source code
- Secrets passed as environment variables set in Dockerfiles or CI pipeline definitions committed to git
- Log statements that print request headers, environment variables, or error messages containing credentials
- Infrastructure code (Terraform, CloudFormation) with secrets as literal values rather than references to a secrets manager

## Good practice

- Use a secrets manager (HashiCorp Vault, AWS Secrets Manager, Azure Key Vault, GCP Secret Manager) as the single source of truth for all credentials
- Inject secrets as environment variables or mounted files at container/VM startup - never bake them into images
- Run a secret scanning tool (truffleHog, detect-secrets, GitHub secret scanning) in CI and as a pre-commit hook
- Rotate secrets on a schedule and immediately on any suspected exposure

## Sources

- OWASP. "A02:2021 - Cryptographic Failures." *OWASP Top Ten 2021*. https://owasp.org/Top10/A02_2021-Cryptographic_Failures/
- Morris, Kief. *Infrastructure as Code*, 2nd ed. O'Reilly, 2020. ISBN 978-1-4920-7522-6. Chapter 14.
