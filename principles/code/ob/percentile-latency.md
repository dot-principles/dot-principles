# CODE-OB-PERCENTILE-LATENCY — Measure latency with histograms and report tail percentiles, not averages

**Layer:** 2 (contextual)
**Categories:** observability, operations, reliability, performance
**Applies-to:** all
**Summary:** Report tail percentiles (p99, p99.9) for latency; never rely on mean or maximum values alone.

## Principle

Record request latency as a histogram and report tail percentiles — p99, p99.9, and p50 — rather than mean or maximum values. The mean conceals the experience of the worst-affected users; the maximum is dominated by outliers and is statistically unstable. Tail latency matters: in systems that fan out requests across many backends, the slowest component determines the end-user response time, so the p99 of each downstream call compounds across the call chain.

## Why it matters

A service with an average latency of 50ms can still have 1% of requests taking 2 seconds — affecting tens of thousands of users per day at moderate scale. Averages mask this entirely. In a microservices fan-out of N parallel calls, the probability that *at least one* takes more than the p99 latency approaches certainty as N grows. This compounding tail effect means that high percentile latency is a first-class correctness concern, not merely a polish issue.

## Violations to detect

- Latency captured as a gauge or counter (e.g., sum of durations) rather than a histogram or summary type
- Monitoring dashboards that display only mean or average latency with no percentile breakdown
- Alerting rules that fire on average latency breaching a threshold rather than on p99 or p95
- SLOs expressed as mean response time rather than percentile-based targets
- Histogram bucket boundaries that are too coarse (e.g., only 100ms and 1s) to distinguish p95 from p99 in the expected latency range

## Good practice

- Use histogram metric types (Prometheus `histogram`, OpenTelemetry `ExplicitBucketHistogram`) for all latency measurements
- Set histogram bucket boundaries to span the expected latency range with enough resolution to compute p95 and p99 meaningfully
- Report and alert on p99 (and p99.9 for latency-sensitive services) as the primary user-experience signal
- Express SLOs in terms of percentile latency: "p99 of successful requests < 300ms"
- When measuring fan-out operations, measure latency at each individual downstream call so tail contributors can be identified

## Sources

- Dean, Jeff; Barroso, Luiz André. "The Tail at Scale." *Communications of the ACM*, 56(2):74–80, 2013. DOI 10.1145/2408776.2408794.
- Beyer, Betsy; Jones, Chris; Petoff, Jennifer; Murphy, Niall Richard. *Site Reliability Engineering: How Google Runs Production Systems*. O'Reilly, 2016. ISBN 978-1-491-92912-4. Chapter 6 (Monitoring Distributed Systems).
