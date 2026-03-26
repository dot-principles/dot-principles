# CD-CANARY-RELEASE — Route a controlled slice of traffic to the new version before rolling it out fully

**Layer:** 2
**Categories:** devops, continuous-delivery, deployment, reliability, risk-management
**Applies-to:** all
**Summary:** Route a small fraction of traffic to the new version and roll back automatically if metrics degrade.
**Audit-scope:** limited — traffic routing percentages are deployment infrastructure concerns; deployment configuration and progressive rollout specs are auditable.

## Principle

Deploy the new version alongside the old, then gradually shift traffic — starting with a small percentage (1–5%) and increasing as confidence grows. Monitor error rates, latency, and business metrics for the canary cohort. If metrics degrade, roll back by redirecting all traffic to the stable version. If they hold, promote the canary to 100%.

## Why it matters

All-or-nothing deployments expose every user to a bad release simultaneously. A canary release limits the blast radius: a defect that affects 1% of traffic causes 1% of the damage of a full rollout, and it surfaces the problem before it becomes a major incident. Canary releases also validate real-world performance under production traffic — a property that staging environments cannot fully replicate.

## Violations to detect

- Deployment configuration that routes 100% of traffic to the new version immediately on deploy with no gradual rollout
- No automated rollback triggered by error rate or latency thresholds
- No observable metric difference between canary and stable traffic cohorts
- Progressive rollout strategy defined only in documentation or a runbook, not in pipeline or deployment config

## Good practice

- Use a service mesh (Istio, Linkerd), ingress controller, or feature flag to control the traffic split
- Define automated rollback criteria: if error rate > X% or p99 latency increases by Y%, roll back automatically
- Start canaries at 1–5% of traffic; increase in steps (10%, 25%, 50%, 100%) with a monitoring soak time between each step
- Keep the canary and stable versions running concurrently; ensure database schema is backward-compatible with both
- Track canary cohort metrics separately from baseline to make the comparison meaningful

## Sources

- Humble, Jez, and David Farley. *Continuous Delivery*. Addison-Wesley, 2010. ISBN 978-0-321-60191-9. Chapter 10.
- Fowler, Martin. "CanaryRelease." martinfowler.com, 2014. https://martinfowler.com/bliki/CanaryRelease.html (accessed 2024-01-01).
