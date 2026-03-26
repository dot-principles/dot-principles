# ARCH-SIDECAR — Deploy cross-cutting concerns as co-located sidecars, not as embedded library code

**Layer:** 2 (contextual)
**Categories:** architecture, microservices, deployment, separation-of-concerns
**Applies-to:** all
**Summary:** Deploy cross-cutting operational concerns as independent co-located sidecar processes, not as in-process libraries.

## Principle

Cross-cutting operational concerns — service mesh proxying, log shipping, secrets rotation, metrics scraping, certificate management, config watching — must be deployed as separate co-located processes (sidecars) rather than embedded as in-process libraries. The sidecar shares the same network namespace and lifecycle as the main container but is independently versioned, replaced, and operated.

## Why it matters

When operational concerns are libraries embedded in the application, every service team carries the maintenance burden of upgrading them. A log-shipping library update requires redeploying every service. An mTLS library vulnerability requires coordinated patching across the entire fleet. Sidecar deployment decouples the operational concern from the business logic: the platform team can update Envoy or Fluentd independently of the application, enforce policy uniformly, and evolve infrastructure without touching service code. This is the foundation of service mesh and zero-trust networking.

## Violations to detect

- Logging, metrics, or tracing SDKs that write to external aggregators embedded directly in application code when a log-shipping sidecar exists in the deployment platform
- In-process secrets rotation logic (polling Vault, refreshing certificates) in services deployed on Kubernetes where a secrets CSI driver or agent sidecar is available
- `httpd`, `nginx`, or similar reverse proxy started in the same process or container entrypoint as the application
- Service-level mTLS implemented as library calls rather than delegated to an Envoy/Istio sidecar
- Configuration hot-reload logic embedded in services deployed on a platform where a config-watcher sidecar is the standard

## Inspection

- `grep -rnE 'VaultClient|vault\.read|rotate.*cert|refreshToken.*secret' --include="*.java" --include="*.go" --include="*.py" --include="*.ts" $TARGET` | MEDIUM | In-process secrets rotation — consider delegating to sidecar/CSI driver
- `grep -rnE 'FileWatcher|watchFile|inotify|polling.*config' --include="*.java" --include="*.go" --include="*.py" $TARGET` | LOW | In-process config file watching — verify platform does not provide a sidecar
- `grep -rnE 'fluentd\|logstash\|splunk' --include="*.java" --include="*.go" --include="*.py" --include="*.ts" $TARGET` | LOW | Log-shipper client library — verify sidecar deployment is not available

## Good practice

```yaml
# Good: Envoy sidecar handles mTLS, retries, observability
# Application only speaks plain HTTP to localhost
spec:
  containers:
  - name: my-service
    image: my-service:1.2.3
    # No TLS code, no retry logic, no metrics library
  - name: envoy
    image: envoy:v1.29
    # Handles mTLS, circuit breaking, distributed tracing
```

- Let the application write structured logs to stdout; let a sidecar (Fluentd, Filebeat) collect and forward them
- Delegate certificate provisioning and rotation to cert-manager or the Kubernetes CSI secrets driver
- Use the service mesh sidecar for retries, circuit breaking, and timeout policy rather than coding them in every service
- Separate the sidecar lifecycle from the application lifecycle — the platform can restart the sidecar independently
- Apply this pattern selectively: small services with no platform mesh do not need a sidecar; the cost/benefit is context-dependent

## Sources

- Burns, Brendan, et al. *Designing Distributed Systems*. O'Reilly, 2018. Chapter 2: "The Sidecar Pattern."
- Richardson, Chris. *Microservices Patterns*. Manning, 2018. ISBN 978-1617294549.
- Microsoft Azure Architecture Center. "Sidecar pattern." https://learn.microsoft.com/en-us/azure/architecture/patterns/sidecar
