# CD-BLUE-GREEN-DEPLOYMENT - Maintain two identical environments; switch traffic between them to release with zero downtime

**Layer:** 2
**Categories:** devops, continuous-delivery, deployment, reliability
**Applies-to:** all
**Summary:** Deploy to an idle environment first, run smoke tests, then switch traffic; keep the previous environment for instant rollback.
**Audit-scope:** limited - whether two environments are maintained requires inspecting deployment infrastructure; deployment scripts and pipeline config are partially auditable.

## Principle

Maintain two production-identical environments - blue and green. At any time, one is live and one is idle. Deploy the new version to the idle environment, run smoke tests against it, then switch the load balancer to route traffic to it. The previous environment remains intact and active for an instant rollback if problems emerge. After confidence is established, the old environment is decommissioned or becomes the next idle target.

## Why it matters

In-place deployments interrupt service: old code is torn down while new code is brought up, leaving a window where the service is unavailable or degraded. Blue-green deployment eliminates that window entirely. It also provides a safe rollback path - flipping the load balancer is faster and more reliable than re-deploying the old version from scratch.

## Violations to detect

- Deployment scripts that stop the running service, update binaries in place, and restart - with no parallel environment
- No rollback mechanism beyond re-deploying the previous artifact from CI (slow and error-prone)
- Load balancer or DNS configuration that cannot route to an alternate environment
- Database schema changes applied in-place that are incompatible with the previous application version

## Good practice

- Keep the idle environment warm and up to date with infrastructure (OS patches, config) - only the application version differs
- Run the full smoke test suite against the idle environment before switching traffic
- Make database schema changes backward-compatible so both versions can run against the same database during the switchover window
- Keep the previous environment live for at least one deployment cycle before decommissioning it
- Automate the traffic switch as the final step of the deployment pipeline

## Sources

- Humble, Jez, and David Farley. *Continuous Delivery*. Addison-Wesley, 2010. ISBN 978-0-321-60191-9. Chapter 10.
- Fowler, Martin. "BlueGreenDeployment." martinfowler.com, 2010. https://martinfowler.com/bliki/BlueGreenDeployment.html (accessed 2024-01-01).
