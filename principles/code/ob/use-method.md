# CODE-OB-USE-METHOD — For every resource, track Utilisation, Saturation, and Errors (USE Method)

**Layer:** 2 (contextual)
**Categories:** observability, operations, reliability, performance
**Applies-to:** all
**Summary:** For every resource, measure Utilisation, Saturation, and Errors to systematically detect bottlenecks.

## Principle

For every infrastructure resource — CPU, memory, disk, network interface, queue — measure three signals: Utilisation (the percentage of time the resource is busy), Saturation (the degree to which work is queued because the resource is at capacity), and Errors (the count of failed operations on that resource). These three signals, taken together, predict most resource-related performance problems before they become outages.

## Why it matters

When a system slows down or fails, engineers lose time identifying which resource is the bottleneck. The USE Method provides a systematic checklist: work through every resource and check all three signals. Utilisation alone can be misleading (a resource at 50% utilisation may still be saturated if requests queue). Without the saturation and error signals, capacity problems go unnoticed until they cause user impact.

## Violations to detect

- Monitoring dashboards that track only utilisation for a resource but omit saturation and error signals
- Services with CPU and memory utilisation dashboards but no queue-depth or throttle-rate metrics
- Network or disk monitoring limited to throughput gauges with no error counter (packet drops, disk errors)
- Autoscaling or alerting rules based solely on utilisation thresholds with no saturation trigger
- Infrastructure metrics that aggregate across instances, hiding saturation on individual nodes

## Good practice

- For each major resource (CPU, memory, storage I/O, network, thread pools, connection pools), instrument all three USE dimensions
- Expose saturation as a queue-depth, wait-time, or pending-work metric alongside the utilisation percentage
- Include error counters for every resource type — dropped packets, throttled requests, disk I/O errors
- Build a resource checklist as part of your incident runbook so the USE sweep happens systematically
- Use the USE Method as a structured first pass during performance investigations before diving into application-level tracing

## Sources

- Gregg, Brendan. *Systems Performance: Enterprise and the Cloud*, 2nd ed. Addison-Wesley, 2020. ISBN 978-0-13-682045-9. Chapter 2 (Methodology).
- Gregg, Brendan. "The USE Method." https://www.brendangregg.com/usemethod.html (accessed 2026-03-17).
