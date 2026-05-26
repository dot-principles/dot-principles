# 12FACTOR-04-BACKING-SERVICES - Backing Services

**Layer:** 2 (contextual)
**Categories:** architecture, cloud-native, dependency-management
**Applies-to:** cloud-native, twelve-factor-apps
**Summary:** Treat all backing services as attached resources configurable via URL; swap them without code changes.

## Principle

Treat backing services - databases, caches, message queues, email services - as attached resources accessed via a URL or credentials stored in config. A twelve-factor app makes no distinction between local and third-party services; both are attached resources that can be swapped without code changes.

## Why it matters

If the code treats a local PostgreSQL instance differently from a hosted one, swapping the local database for a managed cloud service requires code changes rather than a config change. Treating all services as attached resources makes the app portable, testable with local stubs, and resilient to provider changes.

## Violations to detect

- Hardcoded localhost addresses for databases or queues
- Code that behaves differently for "local" vs. "remote" services (e.g., skipping retries for local)
- Direct filesystem access instead of treating file storage as an attached resource (e.g., S3-compatible API)
- Inability to swap a local SMTP server for a hosted mail service without code changes

## Good practice

- Express every backing service as a connection string or URL in environment config
- Write an adapter per service type; inject the configured implementation at startup
- Test with local stubs (e.g., LocalStack, Testcontainers) that implement the same interface as the production service

## Sources

- Wiggins, Adam. *The Twelve-Factor App*. Heroku, 2011. https://12factor.net/backing-services
