# 12FACTOR-09-DISPOSABILITY - Disposability

**Layer:** 2 (contextual)
**Categories:** architecture, cloud-native, resilience
**Applies-to:** cloud-native, twelve-factor-apps
**Summary:** Design processes to start quickly, shut down gracefully on SIGTERM, and survive sudden death safely.
**Audit-scope:** limited - can detect missing SIGTERM handlers, ack-before-process patterns, and startup migrations; cannot measure actual startup time (requires running the app)

## Principle

Maximise robustness with fast startup and graceful shutdown. Processes should start in seconds, shut down gracefully on SIGTERM (finishing in-flight requests, returning jobs to the queue), and be resilient to sudden death. The system must be safe to kill at any moment.

## Why it matters

Slow startups delay scaling responses and make deployments painful. Ungraceful shutdowns corrupt in-flight work and leave queues in an inconsistent state. Apps that are not safe to kill cannot be restarted by a process manager, deployed with rolling updates, or auto-healed by the platform.

## Violations to detect

- Startup time measured in minutes rather than seconds
- No SIGTERM handler - process killed mid-request with no cleanup
- Jobs removed from the queue before they are completed (message acknowledgement before processing)
- Shared mutable state that is corrupted when a process dies unexpectedly
- Initialisation logic that runs long database migrations inline at startup

## Good practice

- Implement a SIGTERM handler: stop accepting new work, finish current work, exit cleanly
- For queue workers: use acknowledgement-after-processing (not at-receipt) so killed workers re-queue their jobs
- Run database migrations as a separate release step, not at app startup
- Use health-check endpoints so orchestrators know when the process is ready

## Sources

- Wiggins, Adam. *The Twelve-Factor App*. Heroku, 2011. https://12factor.net/disposability
