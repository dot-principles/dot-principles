# 12FACTOR-08-CONCURRENCY - Concurrency

**Layer:** 2 (contextual)
**Categories:** architecture, cloud-native, scalability
**Applies-to:** cloud-native, twelve-factor-apps
**Summary:** Scale out by running more stateless process instances; assign distinct workloads to distinct process types.

## Principle

Scale out via the process model. Assign different workloads to different process types (web processes, worker processes, clock processes). Scale horizontally by running more instances of a process type rather than making a single process larger.

## Why it matters

Threading and forking within a single process are limited by the machine's resources and complicate state management. The process model maps workloads to Unix process primitives, enabling independent scaling of each workload type and reliable operation under a process manager.

## Violations to detect

- Monolithic process handling web requests, background jobs, and scheduled tasks in the same runtime with shared state
- Scaling strategy that is exclusively vertical (bigger machines) with no horizontal process model
- Background threads spawned inside the web process sharing memory with request handlers
- No process type distinction - all work done in one type of process regardless of its nature

## Good practice

- Define process types in a `Procfile` or equivalent: `web: ./server`, `worker: ./worker`, `clock: ./scheduler`
- Scale web and worker processes independently based on load
- Use a process manager (systemd, Kubernetes, Heroku dynos) rather than daemonizing manually
- Keep each process type focused on one workload category

## Sources

- Wiggins, Adam. *The Twelve-Factor App*. Heroku, 2011. https://12factor.net/concurrency
