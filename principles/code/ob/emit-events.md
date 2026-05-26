# CODE-OB-EMIT-EVENTS - Emit events, not just metrics

**Layer:** 2 (contextual)
**Categories:** observability, operations, reliability
**Applies-to:** all
**Summary:** Emit rich contextual events for every unit of work rather than relying on pre-aggregated metrics.

## Principle

Emit rich, contextual events that capture what happened during a unit of work, rather than relying solely on pre-aggregated metrics (counters, gauges, histograms). An event is an immutable record of a single occurrence - a request handled, a query executed, a job completed - enriched with all relevant dimensions. Events can be aggregated into metrics after the fact, but metrics cannot be decomposed back into events.

## Why it matters

Pre-aggregated metrics answer questions you anticipated when you defined them. Events answer questions you did not know to ask. During a novel incident, engineers need to explore data interactively - slicing by unexpected dimensions, correlating fields, and discovering patterns. Events preserve the raw detail that makes this exploration possible.

## Violations to detect

- Instrumentation that only increments counters or updates gauges without emitting the underlying events
- Systems where the only way to investigate an anomaly is to add new metrics and redeploy
- Telemetry pipelines that aggregate data at collection time, discarding individual event details
- Monitoring dashboards built entirely on pre-aggregated time-series data with no way to drill into individual requests
- Debug information available only in unstructured log files that are not queryable alongside metrics

## Good practice

- Emit one structured event per unit of work (request, transaction, job), enriched with timing, outcome, and contextual fields
- Use wide events - include many fields per event rather than emitting many narrow metric series
- Store events in a system that supports high-cardinality, ad-hoc querying (not just time-series aggregation)
- Derive dashboards and alerts from events rather than maintaining separate metrics pipelines
- Include both success and failure details in events so that normal behavior can be compared to anomalies

## Sources

- Majors, Charity; Fong-Jones, Liz; Miranda, George. *Observability Engineering: Achieving Production Excellence*. O'Reilly, 2022. ISBN 978-1-492-07644-8.
