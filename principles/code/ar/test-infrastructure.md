# CODE-AR-TEST-INFRASTRUCTURE — Test infrastructure code like application code

**Layer:** 2
**Categories:** architecture, infrastructure, devops
**Applies-to:** all
**Summary:** Test infrastructure code at every level — static analysis, unit, integration, and compliance — before applying it.

## Principle

Infrastructure code must be tested at multiple levels, just as application code is. This includes static analysis and linting, unit tests for individual modules, integration tests that provision real infrastructure in an isolated environment, and compliance tests that verify security and policy requirements. Untested infrastructure code is just as risky as untested application code — the blast radius is often larger.

## Why it matters

Infrastructure mistakes can take down entire environments, expose sensitive data, or create security vulnerabilities. Unlike application bugs that affect a single feature, a misconfigured network rule or an overly permissive IAM policy can compromise everything. Testing infrastructure code before applying it catches misconfigurations, policy violations, and regressions early, when they are cheap to fix rather than after they cause an incident.

## Violations to detect

- Infrastructure modules with no tests of any kind — no linting, no unit tests, no integration tests
- Infrastructure code that is only tested by applying it to production and checking whether anything breaks
- Tests that only validate syntax but never actually provision resources to verify behavior
- Security and compliance requirements verified only by manual audit rather than automated policy tests
- Test environments that do not match production topology closely enough to catch real issues

## Good practice

- Run static analysis and linting on every commit (e.g., `terraform validate`, `tflint`, `cfn-lint`, `checkov`)
- Write unit tests for infrastructure modules using tools like Terratest, Kitchen-Terraform, or Pulumi's testing frameworks
- Maintain an isolated test environment where integration tests provision real infrastructure, verify it works, and tear it down
- Include policy-as-code tests (Open Policy Agent, Sentinel) that enforce security, tagging, and compliance rules
- Run infrastructure tests in CI on every pull request — do not merge untested infrastructure changes

## Sources

- Morris, Kief. *Infrastructure as Code*, 2nd ed. O'Reilly, 2020. ISBN 978-1-098-11467-1. Chapter 14: "Testing Infrastructure Code."
