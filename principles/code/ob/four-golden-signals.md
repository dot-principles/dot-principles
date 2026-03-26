# CODE-OB-FOUR-GOLDEN-SIGNALS — Instrument every service for Latency, Traffic, Errors, and Saturation

**Layer:** 2 (contextual)
**Categories:** observability, operations, reliability
**Applies-to:** all
**Summary:** Instrument every service to expose Latency, Traffic, Errors, and Saturation as the minimum signals.

## Principle

Every service should be instrumented to expose four signals: Latency (how long requests take, distinguishing successful from failed requests), Traffic (the demand placed on the service — requests per second, messages per second), Errors (the rate of requests that fail, explicitly or implicitly), and Saturation (how "full" the service is — the utilisation of its most constrained resource). These four dimensions cover the most common causes of user-visible service degradation.

## Why it matters

Monitoring that is incomplete across any of these four dimensions leaves blind spots. A service may appear healthy in error rate and latency while silently approaching saturation — the queue is full before the first timeout fires. Conversely, focusing only on saturation ignores the quality of traffic flowing through headroom. The Four Golden Signals provide the minimum coverage to detect and diagnose degradation before or as it becomes user-visible.

## Violations to detect

- Services with latency dashboards that show only averages or maximums, not percentile distributions
- Latency metrics that do not distinguish between the latency of successful requests and error responses (errors are typically fast and distort averages downward)
- Traffic metrics absent from a service (impossible to correlate load changes with error or latency changes)
- Saturation metrics absent — no queue depth, thread pool utilisation, or connection pool fill metrics
- Error counters that capture only HTTP 5xx responses, omitting soft errors (timeouts, partial failures, fallback responses)

## Good practice

- Treat all four signals as mandatory instrumentation, added during initial service development
- For latency, record histograms with enough bucket resolution to compute p50, p95, and p99; keep error-response latency separate so it does not distort the success-case distribution
- For saturation, identify the service's most constrained resource (CPU, goroutine pool, DB connection pool) and expose its fill percentage
- Build a standard Four Golden Signals dashboard template so every new service gets baseline visibility automatically
- Use the four signals as the entry point for incident investigation before drilling into traces

## Sources

- Beyer, Betsy; Jones, Chris; Petoff, Jennifer; Murphy, Niall Richard. *Site Reliability Engineering: How Google Runs Production Systems*. O'Reilly, 2016. ISBN 978-1-491-92912-4. Chapter 6 (Monitoring Distributed Systems).
- Google SRE Team. "Monitoring Distributed Systems." https://sre.google/sre-book/monitoring-distributed-systems/ (accessed 2026-03-17).
