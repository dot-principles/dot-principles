# 12FACTOR-11-LOGS — Logs

**Layer:** 2 (contextual)
**Categories:** architecture, cloud-native, observability
**Applies-to:** cloud-native, twelve-factor-apps
**Summary:** Write all logs to stdout as an unbuffered event stream; let the platform handle routing and storage.

## Principle

Treat logs as event streams. An app should never concern itself with routing or storage of its log output. Write all logs to stdout as an unbuffered stream of time-ordered events. The execution environment captures the stream and routes it to its destination.

## Why it matters

Apps that manage their own log files couple themselves to the filesystem, require log rotation configuration, and complicate log aggregation across multiple instances. Treating logs as stdout streams lets the platform — not the app — decide where logs go: a terminal in development, a log aggregator in production.

## Violations to detect

- Log files written directly to the local filesystem by the application
- Custom log rotation logic inside the application
- Different logging configuration for development and production that changes what is captured
- Logs that are buffered and not emitted until a threshold is reached, losing events on crash
- Structured events mixed with unstructured text in the same log stream

## Good practice

- Write all log output to stdout and stderr; let the platform (Docker, Kubernetes, Heroku) route it
- Use structured logging (JSON) so log aggregators can parse and query events
- Include a correlation/trace ID in every log line to connect events across services
- Use log levels (DEBUG, INFO, WARN, ERROR) consistently; never log sensitive data

## Sources

- Wiggins, Adam. *The Twelve-Factor App*. Heroku, 2011. https://12factor.net/logs
