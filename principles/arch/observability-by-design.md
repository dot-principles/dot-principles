# ARCH-OBSERVABILITY-BY-DESIGN - Observability is an architectural property, not an afterthought

**Layer:** 1 (universal)
**Categories:** architecture, observability, operations, distributed-systems
**Applies-to:** all
**Summary:** Design every system to expose structured logs, metrics, and distributed traces from the outset, not as an afterthought.

## Principle

Observability is an architectural property, not an operational afterthought. Every system must be designed from the outset to expose its internal state through structured logs, metrics, and distributed traces. A system that cannot be interrogated during an incident - without deploying new code - is not production-ready.

## Why it matters

In distributed systems, you cannot attach a debugger or observe execution directly. The only window into what a system is doing is the telemetry it emits. Systems not designed for observability force engineers to infer internal state from external symptoms, leading to longer incident resolution times, incorrect root-cause diagnoses, and heightened deployment risk. Observability designed in from the start is an order of magnitude cheaper than observability retrofitted onto a running system under pressure.

## Violations to detect

- Services with no structured logging - only unstructured strings with no extractable, queryable fields
- No correlation IDs propagated across service boundaries, making distributed traces impossible to reconstruct
- Metrics that describe only infrastructure (CPU, memory) with no service-level indicators (request rate, error rate, latency percentiles)
- No defined SLIs or SLOs - the team cannot state in measurable terms what "working correctly" means
- Alerting based solely on static thresholds rather than SLO error-budget burn rates

## Good practice

- Design services to emit structured logs (JSON), metrics (counters, histograms, gauges), and traces (spans with parent IDs) from day one
- Propagate trace context (W3C TraceContext or OpenTelemetry) across all service boundaries - HTTP headers, message metadata, gRPC metadata
- Define SLIs and SLOs before writing the first line of production code; build dashboards from them
- Ensure every outbound call emits a span; every inbound request is tagged with a correlation ID
- Adopt OpenTelemetry as the instrumentation standard to preserve optionality over backend tooling

## Sources

- Majors, Charity, Fong-Jones, Liz and Miranda, George. *Observability Engineering*. O'Reilly, 2022. ISBN 978-1-4920-7644-5. Chapters 1-3.
- Beyer, Betsy et al. *Site Reliability Engineering*. O'Reilly, 2016. ISBN 978-1-4492-2501-2. Chapter 6 (Monitoring Distributed Systems).
