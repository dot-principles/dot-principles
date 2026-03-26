# INFRA-INFRASTRUCTURE-AS-CODE — All infrastructure is code; nothing is configured manually

**Layer:** 1 (universal)
**Categories:** infrastructure, devops, repeatability
**Applies-to:** all
**Summary:** Declare every infrastructure resource in version-controlled code and apply all changes through an automated pipeline.

## Principle

Every infrastructure resource — servers, networks, load balancers, IAM roles, DNS records, monitoring rules — must be declared in version-controlled code and applied through an automated pipeline. No human should ever log into a production system and make a configuration change directly. If a change cannot be expressed as code, the tooling or process must be fixed until it can.

## Why it matters

Manual changes are invisible, unrepeatable, and unauditable. A server configured by hand cannot be reliably recreated after failure. A firewall rule added through a console disappears from version history. Over time, environments drift apart — what works in staging stops working in production not because of application bugs but because of invisible infrastructure differences. Infrastructure-as-code eliminates drift by making the desired state explicit and enforceable.

## Violations to detect

- Infrastructure resources that exist in cloud consoles but have no corresponding code definition
- Configuration changes applied via SSH, cloud console UI, or CLI outside of a pipeline
- Environment-specific settings hardcoded in code rather than injected via configuration
- No mechanism to detect or alert on configuration drift between declared and actual state
- "Snowflake" servers that cannot be terminated and recreated without data loss or service impact

## Good practice

- Use a declarative IaC tool (Terraform, Pulumi, AWS CDK, CloudFormation) for all resource definitions
- Apply changes exclusively through a CI/CD pipeline with plan/preview before apply
- Run drift detection on a schedule and alert when actual state diverges from declared state
- Store all environment configuration in version control alongside the infrastructure code

## Sources

- Morris, Kief. *Infrastructure as Code*, 2nd ed. O'Reilly, 2020. ISBN 978-1-4920-7522-6. Chapters 1–3.
- Kim, Gene et al. *The DevOps Handbook*, 2nd ed. IT Revolution, 2021. ISBN 978-1-9502-8818-4. Part III.
