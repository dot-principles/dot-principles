# INFRA-HIGH-AVAILABILITY - Eliminate single points of failure across all production infrastructure

**Layer:** 2 (contextual)
**Categories:** infrastructure, availability, resilience, disaster-recovery
**Applies-to:** production-systems, cloud, internet-facing
**Summary:** Deploy across independent failure domains and validate failover regularly against defined RTO and RPO targets.

## Principle

Production infrastructure must be designed with no single points of failure. Compute, network, storage, and platform services must be distributed across independent failure domains - availability zones or regions - so that the loss of any single node, zone, or dependency does not cause a service outage. Define and commit to measurable availability targets (SLOs) and verify them with regular recovery tests.

## Why it matters

Cloud infrastructure is not inherently reliable. Availability zones fail. Managed services have outages. Hardware fails. Single-instance and single-AZ deployments guarantee that the next infrastructure failure causes a production outage. High availability is not about preventing failures - it is about ensuring the system continues to function when they occur, which they will. An availability target that exists only in a document and has never been tested under real failure conditions is not an availability guarantee; it is a hope.

## Violations to detect

- Production databases or services deployed in a single availability zone with no replica or failover target
- No defined RTO (Recovery Time Objective) or RPO (Recovery Point Objective) for any production service
- Disaster recovery procedures documented but never tested - the runbook exists only as theory
- Load balancers or API gateways with a single backend and no automated health-check failover
- Autoscaling groups with a minimum of one instance - a single instance failure removes all serving capacity

## Good practice

- Deploy all stateful components (databases, caches, queues) with replicas in at least two availability zones; use synchronous replication where RPO demands it
- Test recovery regularly: game days, chaos engineering experiments, and DR drills - not only when an incident forces it
- Define RTO and RPO for every production service; design the infrastructure to demonstrably meet them
- Use automated health checks with automated failover, not manual paging, as the primary recovery mechanism
- Document the failure mode of every critical dependency; verify the system degrades gracefully when each is made unavailable

## Sources

- Amazon Web Services. *AWS Well-Architected Framework - Reliability Pillar*. 2023. REL 06-REL 09.
- Nygard, Michael T. *Release It!*, 2nd ed. Pragmatic Bookshelf, 2018. ISBN 978-1-68050-239-8. Chapter 3.
