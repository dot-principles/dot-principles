# INFRA-LEAST-PRIVILEGE - Every identity gets only the minimum permissions it requires

**Layer:** 1 (universal)
**Categories:** infrastructure, security, iam, access-control
**Applies-to:** all
**Summary:** Grant every identity only the minimum permissions required for its function; no standing admin access.

## Principle

Every identity - human user, service account, CI pipeline, or automated process - must be granted only the minimum permissions required to perform its defined function, for only the duration those permissions are needed. No standing administrative access. No wildcard policies. No shared credentials between services.

## Why it matters

Overly permissive IAM policies are one of the most common vectors for cloud security incidents. A compromised service account with broad permissions enables lateral movement across the entire infrastructure. The blast radius of any credential leak, insider threat, or supply-chain compromise is bounded by the permissions of the identity involved. Least-privilege does not prevent compromise - it limits its consequences.

## Violations to detect

- Service accounts with `admin`, `*`, or broad wildcard permissions when narrower permissions are sufficient
- Human users with permanent administrative access rather than just-in-time elevated access
- Multiple services sharing a single service account rather than having distinct identities with distinct roles
- CI/CD pipelines with deployment permissions broader than the environment they deploy to
- No regular access review or automated alerting on unused or overly broad permissions

## Good practice

- Apply least-privilege at every layer: cloud IAM, Kubernetes RBAC, database roles, OS file permissions
- Use just-in-time access for administrative operations - grant elevated permissions for the duration of a task, then revoke automatically
- Assign each service its own identity (service account, IAM role, Kubernetes ServiceAccount) with only the permissions it requires
- Use IAM access analysers and policy linters to detect overly permissive policies and permissions that have never been used
- Review and tighten permissions as part of every service decommission and team offboarding

## Sources

- Saltzer, J.H. and Schroeder, M.D. "The Protection of Information in Computer Systems." *Proceedings of the IEEE*, 63(9), 1975. (Principle of Least Privilege.)
- Amazon Web Services. *AWS Well-Architected Framework - Security Pillar*. 2023. SEC 02: Identity and Access Management.
