# 12FACTOR-06-PROCESSES — Processes

**Layer:** 2 (contextual)
**Categories:** architecture, cloud-native, scalability
**Applies-to:** cloud-native, twelve-factor-apps
**Summary:** Run stateless, share-nothing processes; store all persistent state in external backing services.

## Principle

Execute the app as one or more stateless processes. Processes share nothing. Any data that must persist is stored in a stateful backing service. Memory and the local filesystem may be used only as a brief, single-transaction cache — never as a durable store shared across requests.

## Why it matters

Stateful processes cannot be scaled horizontally: adding a second instance creates state divergence. Sticky sessions, in-process caches, and local file storage create hidden dependencies on a specific process instance, making rolling restarts, auto-scaling, and failover unreliable.

## Violations to detect

- Session state stored in process memory instead of an external store (Redis, database)
- Files written to the local filesystem expected to persist across restarts or be available to other instances
- In-process caches that are not invalidated correctly when multiple instances are running
- Sticky session routing in load balancers used to paper over stateful process design

## Good practice

- Store sessions in Redis, Memcached, or a database; never in local memory
- Use object storage (S3-compatible) for files that must persist; use the filesystem only for ephemeral scratch space
- Design each request to be completable by any process instance
- Use distributed locks (backed by Redis or a database) if coordination between processes is truly necessary

## Sources

- Wiggins, Adam. *The Twelve-Factor App*. Heroku, 2011. https://12factor.net/processes
