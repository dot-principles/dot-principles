# CONFIG-CHANGE-TRACEABILITY - All configuration changes must be versioned, reviewed, and auditable

**Layer:** 2 (contextual)
**Categories:** configuration, auditability, security, devops
**Applies-to:** config
**Summary:** Every configuration change must flow through version control and peer review, producing a full audit trail.

## Principle

Every change to a configuration value must be traceable: who changed it, what changed, when, and why. Configuration changes flow through version control and peer review - the same process as code changes. Ad-hoc manual edits to configuration on running systems are prohibited except in declared, time-limited break-glass procedures that are logged and followed by a post-incident config reconciliation.

## Why it matters

Configuration changes are a leading cause of production incidents. Without traceability, diagnosing "what changed before the outage" requires guesswork. Without review, a single misconfiguration - a wrong timeout, a missing flag, a rotated key not propagated - can take down a service. GitOps and change-management disciplines extend code review and audit practices to the configuration plane.

## Violations to detect

- Configuration files that exist only on running servers and are not committed to version control
- Evidence of SSH-based or console-based config edits (files with modification timestamps that post-date the last deploy)
- Config values in production that differ from what is declared in VCS without a documented reason
- Secrets management systems (Vault, AWS Secrets Manager) used without audit logging enabled
- No record of who approved a configuration change or why

## Good practice

- Commit all configuration files to version control; require pull request approval before merging config changes
- Use GitOps workflows (ArgoCD, Flux, GitHub Actions) to deploy config from VCS, ensuring the running config matches the declared config
- Enable audit logging in secrets management systems: Vault audit devices, AWS CloudTrail for Secrets Manager, Azure Policy
- Define and document break-glass procedures for emergency config changes; require a follow-up PR to reconcile VCS within 24 hours
- Include config diffs in deployment manifests so reviewers see exactly what changed

## Sources

- Humble, Jez & Farley, David. *Continuous Delivery: Reliable Software Releases through Build, Test, and Deployment Automation*. Addison-Wesley, 2010. ISBN 978-0-321-60191-9. Chapter 2 (Configuration Management).
- Beyer, Betsy et al. *Site Reliability Engineering: How Google Runs Production Systems*. O'Reilly, 2016. ISBN 978-1-491-92912-4. Chapter 25 (Data Processing Pipelines - Configuration Management).
- Weaveworks. "GitOps - Operations by Pull Request." https://www.weave.works/blog/gitops-operations-by-pull-request (2017, accessed 2026-03-22).
