# CODE-OB-HEALTH-CHECK-API - Expose liveness and readiness health check endpoints

**Layer:** 2 (contextual)
**Categories:** observability, operations, reliability
**Applies-to:** all
**Summary:** Expose dedicated liveness and readiness endpoints on every service for orchestrators and load balancers.

## Principle

Every service should expose dedicated health check endpoints that return machine-readable status indicating whether the instance is alive (liveness) and whether it is ready to accept traffic (readiness). Liveness reports whether the process is running and not deadlocked. Readiness reports whether it has completed initialisation and its dependencies (database, cache, downstream services) are reachable. Orchestrators, load balancers, and monitoring systems use these endpoints to route traffic and restart unhealthy instances.

## Why it matters

Without health endpoints, orchestrators have no reliable signal to distinguish a slow but healthy service from a deadlocked or misconfigured one. Load balancers continue routing traffic to instances that are booting or failing quietly. Distinguishing liveness from readiness prevents a common failure mode: killing and restarting a service that is alive but still initialising its connection pool, creating a restart loop and extending the outage.

## Violations to detect

- Services with no HTTP health endpoint, relying solely on process-level liveness detection
- A single combined health endpoint with no distinction between liveness and readiness semantics
- Health endpoints that always return 200 OK without checking the actual status of dependencies
- Health checks that perform expensive operations (full database migrations, large queries) on every poll
- Health responses returned as unstructured text rather than a machine-readable format (e.g., JSON `{"status": "ok"}`)

## Inspection

```
# Check for common health endpoint route patterns
grep -r 'health\|liveness\|readiness\|alive\|ready' --include='*.go' --include='*.ts' --include='*.py' --include='*.java' -l
```

## Good practice

- Implement separate `/health/live` (or `/healthz`) and `/health/ready` (or `/readyz`) endpoints
- Liveness should be lightweight - check only that the process is not deadlocked; avoid I/O
- Readiness should check critical dependencies (database connectivity, required config) but use cached results to bound latency
- Return a structured JSON body with a status field and, optionally, per-dependency detail
- Register health endpoints in your service framework's router before authentication middleware so they are always reachable

## Sources

- Richardson, Chris. *Microservices Patterns: With Examples in Java*. Manning, 2018. ISBN 978-1-617-29454-9. Chapter 11 (Developing production-ready services).
- Kubernetes. "Configure Liveness, Readiness and Startup Probes." https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ (accessed 2026-03-17).
