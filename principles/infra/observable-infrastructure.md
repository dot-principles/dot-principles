# INFRA-OBSERVABLE-INFRASTRUCTURE - All infrastructure emits centralised, structured telemetry

**Layer:** 1 (universal)
**Categories:** infrastructure, observability, operations, monitoring
**Applies-to:** all
**Summary:** Emit structured, centralised telemetry from every infrastructure layer and alert on leading indicators.

## Principle

Every infrastructure layer - compute, network, storage, and platform services - must emit structured telemetry: logs, metrics, and health signals. Centralise this telemetry into a queryable observability platform. Infrastructure that cannot be observed cannot be reliably operated; incidents on unobserved infrastructure are diagnosed by intuition rather than evidence.

## Why it matters

Application observability tells you what the application is doing. Infrastructure observability tells you what the platform under it is doing. Both are necessary. An application that appears healthy but is running on a node with a degraded network interface, a disk at 99% capacity, or a misconfigured load balancer is a system waiting to fail. Without infrastructure-level telemetry, the first signal of a platform problem is often a user-facing outage. The second problem is time: incidents without centralised, correlated telemetry take far longer to diagnose and resolve.

## Violations to detect

- Infrastructure resources (VMs, containers, databases, load balancers) with no logging or metrics configured
- Logs accessible only by SSH-ing into the host - not centralised or searchable
- No alerting on infrastructure-level leading indicators: disk utilisation trending up, memory pressure, network error rates, certificate expiry
- Application and infrastructure observability in disconnected stacks - correlating a request trace to a host metric requires logging into two separate systems
- Alerts with no linked runbook or documented response procedure

## Good practice

- Centralise all infrastructure logs in a single queryable platform with consistent structured formatting (JSON)
- Emit metrics from all infrastructure components; alert on leading indicators (disk >80%) not lagging ones (disk 100%)
- Tag all infrastructure resources consistently; use tags to correlate resource-level metrics with application-level traces in the same platform
- Set up synthetic monitoring and health probes for every external-facing endpoint
- Configure certificate, licence, and quota expiry alerts with sufficient lead time to act without incident pressure

## Sources

- Beyer, Betsy et al. *Site Reliability Engineering*. O'Reilly, 2016. ISBN 978-1-4492-2501-2. Chapter 6 (Monitoring Distributed Systems).
- Kim, Gene et al. *The DevOps Handbook*, 2nd ed. IT Revolution, 2021. ISBN 978-1-9502-8818-4. Part IV.
