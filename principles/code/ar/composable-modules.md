# CODE-AR-COMPOSABLE-MODULES — Keep infrastructure modules small and composable

**Layer:** 2
**Categories:** architecture, infrastructure, devops
**Applies-to:** all
**Summary:** Organize infrastructure into small, focused, independently manageable modules with clear inputs and outputs.

## Principle

Infrastructure code should be organized into small, focused, independently manageable modules — each responsible for a single concern such as a network, a database cluster, or a compute group. These modules should be composed together to build complete environments, rather than defining everything in a single monolithic stack. Each module should have a clear interface (inputs and outputs), be independently testable, and be reusable across environments and projects.

## Why it matters

Monolithic infrastructure stacks are slow to plan, risky to change, and impossible to reuse. A change to a DNS record should not require re-evaluating the entire infrastructure graph. When a single stack contains networking, compute, databases, and monitoring, a failure in any part blocks changes to all parts. Small modules reduce blast radius, enable parallel work by different teams, and make it practical to test individual components in isolation.

## Violations to detect

- A single Terraform state file or CloudFormation stack that manages an entire environment's infrastructure
- Infrastructure modules that take dozens of input variables because they handle too many concerns
- Copy-pasted infrastructure code across environments or projects instead of shared, parameterized modules
- Modules with circular dependencies or tight coupling that cannot be applied independently
- Infrastructure changes that require a full environment plan/apply cycle even when only a small component changed

## Good practice

- Organize infrastructure into modules by logical component: networking, compute, database, monitoring, DNS
- Define clear input variables and output values for each module — treat modules like functions with explicit interfaces
- Use module registries or Git repositories to share and version infrastructure modules across teams and projects
- Keep each module's state independent so it can be planned and applied without affecting unrelated components
- Compose modules in environment-level configurations that wire outputs from one module into inputs of another

## Sources

- Morris, Kief. *Infrastructure as Code*, 2nd ed. O'Reilly, 2020. ISBN 978-1-098-11467-1. Chapter 16: "Building Stacks from Components."
