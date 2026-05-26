# CODE-OB-SERVICE-LEVEL-OBJECTIVES - Define and measure SLOs (Service Level Objectives)

**Layer:** 2 (contextual)
**Categories:** observability, operations, reliability
**Applies-to:** all
**Summary:** Define explicit SLOs quantifying reliability targets and continuously measure performance against them.

## Principle

Define explicit Service Level Objectives that quantify the reliability your users expect - for example, "99.9% of requests complete in under 300ms" - and continuously measure performance against them. SLOs provide an objective framework for deciding when the system is healthy enough to ship new features and when engineering effort must shift to reliability work.

## Why it matters

Without SLOs, reliability decisions are driven by intuition or politics. Teams either over-invest in reliability (gold-plating systems that are already good enough) or under-invest until a catastrophic outage forces attention. SLOs create an error budget - the measurable gap between perfect and the target - that teams can spend on velocity, making the reliability-versus-speed tradeoff explicit and data-driven.

## Violations to detect

- Services running in production with no defined SLOs
- SLOs defined but never measured or reported on
- Alerting based solely on arbitrary thresholds unconnected to user-facing impact
- SLOs set at 100% (an unachievable target that provides no error budget)
- SLIs (Service Level Indicators) that do not reflect the user's actual experience (e.g., measuring server CPU instead of request latency)

## Good practice

- Choose SLIs that reflect what users experience: availability, latency, correctness, and throughput
- Set SLO targets based on user expectations and business requirements, not aspirational perfection
- Calculate and track error budgets - the allowed amount of unreliability within a time window
- Use error budget depletion to trigger reliability investments (freeze feature work, focus on stability)
- Review and adjust SLOs periodically as the product and user expectations evolve

## Sources

- Majors, Charity; Fong-Jones, Liz; Miranda, George. *Observability Engineering: Achieving Production Excellence*. O'Reilly, 2022. ISBN 978-1-492-07644-8.
