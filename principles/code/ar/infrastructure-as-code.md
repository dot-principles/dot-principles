# CODE-AR-INFRASTRUCTURE-AS-CODE — Define all infrastructure as code — no manual changes to environments

**Layer:** 2
**Categories:** architecture, infrastructure, devops
**Applies-to:** all
**Summary:** Define all infrastructure as version-controlled code; never provision or modify environments through manual steps.

## Principle

Every piece of infrastructure — servers, networks, load balancers, DNS records, firewall rules, monitoring configuration — should be defined in source-controlled code that can be executed to provision and update environments. No changes should be made by logging into a console, clicking through a UI, or running ad-hoc commands. The code definition is the single source of truth for what infrastructure exists and how it is configured.

## Why it matters

Manual infrastructure changes create configuration drift: environments that were supposed to be identical diverge in invisible ways, causing "works on staging but fails in production" failures. When infrastructure is defined as code, every change is versioned, reviewable, and reproducible. You can rebuild any environment from scratch, audit who changed what, and test infrastructure changes before applying them to production.

## Violations to detect

- Infrastructure provisioned or modified through a cloud provider's web console without corresponding code changes
- SSH sessions used to install packages, change configuration files, or modify firewall rules on running servers
- Environment-specific knowledge that exists only in a team member's head or in a wiki, not in code
- Configuration files that are manually copied between environments rather than generated from a single source
- Scripts that include hardcoded IP addresses, credentials, or environment-specific values instead of parameterized definitions

## Good practice

- Use a declarative infrastructure tool (Terraform, Pulumi, CloudFormation, Crossplane) to define all infrastructure resources
- Store all infrastructure definitions in version control alongside application code
- Treat manual changes as incidents — if someone makes a manual fix, follow up by encoding that change in the infrastructure code
- Use separate state files or stacks per environment, but keep the definitions parameterized so all environments use the same code
- Include infrastructure definitions in code review — review infrastructure changes with the same rigor as application code

## Sources

- Morris, Kief. *Infrastructure as Code*, 2nd ed. O'Reilly, 2020. ISBN 978-1-098-11467-1. Chapter 1: "What Is Infrastructure as Code?"
