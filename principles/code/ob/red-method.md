# CODE-OB-RED-METHOD - For every service, track Rate, Errors, and Duration (RED Method)

**Layer:** 2 (contextual)
**Categories:** observability, operations, reliability
**Applies-to:** all
**Summary:** Instrument every service with Rate, Errors, and Duration as the minimum request-scoped signals.

## Principle

For every service (or meaningful request-handling component), instrument three request-scoped signals: Rate (the number of requests per second the service is receiving), Errors (the number of requests that are failing), and Duration (the distribution of response times, typically as a histogram). These three signals define the user-visible health of a service and are the minimum instrumentation needed to determine whether the service is performing acceptably.

## Why it matters

Without Rate, Errors, and Duration on every service, engineers cannot answer the most basic operational questions: Is the service being called? Is it succeeding? Is it fast? Gaps in any one dimension hide problems - a service may show a low error rate while its latency has tripled, or a high request rate while errors go uncounted. RED provides a consistent, minimal instrumentation contract that makes services comparable and debuggable.

## Violations to detect

- Services that emit no request-rate metric (no way to distinguish zero load from failure)
- Error counters that only track 5xx responses, omitting application-level errors returned in 2xx bodies
- Latency tracked as a single gauge or average rather than a histogram or summary (conceals tail latency)
- Services that instrument some but not all three RED signals, leaving partial observability gaps
- Instrumentation absent from internal services because they are "not customer-facing"

## Good practice

- Instrument Rate, Errors, and Duration at every service boundary, not only at the API gateway
- Count errors at the application level (business-rule failures, validation errors) in addition to HTTP 5xx
- Record Duration as a histogram so percentiles (p50, p95, p99) can be derived; never rely solely on averages
- Use a consistent metric naming convention across services so RED dashboards are reusable
- Apply RED instrumentation to asynchronous consumers (queue workers, event handlers) by measuring message processing rate, processing failures, and processing duration

## Sources

- Wilkie, Tom. "The RED Method: Key Metrics for Microservices Architecture." *GrafanaCon EU 2018*. https://grafana.com/blog/2018/08/02/the-red-method-how-to-instrument-your-services/ (accessed 2026-03-17).
- Sridharan, Cindy. *Distributed Systems Observability*. O'Reilly, 2018. ISBN 978-1-492-03364-9. Chapter 4.
