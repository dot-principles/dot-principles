# 12FACTOR-03-CONFIG - Config

**Layer:** 2 (contextual)
**Categories:** architecture, cloud-native, security, configuration
**Applies-to:** cloud-native, twelve-factor-apps
**Summary:** Store all config in environment variables; never hardcode credentials or environment-specific values in code.

## Principle

Store config in the environment, not in the code. Config is everything that varies between deploys (staging, production, developer environments) - database URLs, credentials, external service addresses. Code does not change between deploys; config does.

## Why it matters

Config hardcoded in source is a security risk (credentials in version control) and an operational hazard (the wrong environment's database URL is one copy-paste away). Environment-based config allows the same build artifact to be deployed to any environment without modification.

## Violations to detect

- Database URLs, API keys, or passwords hardcoded in source files
- Environment names hardcoded in conditional logic (e.g., `if env == "production"`)
- Config files checked into version control that contain credentials
- Different build artifacts for different environments instead of one artifact with environment-injected config

## Good practice

- Read all config from environment variables at startup
- Use secrets management systems (Vault, AWS Secrets Manager, Kubernetes Secrets) for sensitive values
- Validate required environment variables at startup and fail fast with a clear error if any are missing
- Keep config flat and explicit - avoid complex config file formats when environment variables suffice

## Sources

- Wiggins, Adam. *The Twelve-Factor App*. Heroku, 2011. https://12factor.net/config
