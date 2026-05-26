# PIPELINE-DEPLOYMENT-GATES - Require explicit approval or conditions before production deployment

**Layer:** 2 (contextual)
**Categories:** reliability, pipeline, security, deployment
**Applies-to:** pipeline
**Summary:** Require explicit approval or automated policy checks before every deployment to a protected environment.

## Principle

Deployment to production or other protected environments must pass through an explicit gate - a manual approval, an automated policy check, or both. The gate must be enforced by the pipeline platform, not by convention or comments. Environment protection rules, required reviewers, and deployment policies ensure that only verified artifacts reach production through an auditable, controlled path.

## Why it matters

Without deployment gates, any pipeline run that reaches the deploy stage - including runs triggered by misconfigured branches, accidental merges, or compromised dependencies - can push directly to production. Gates provide a deliberate checkpoint that separates "code that passed automated checks" from "code that is approved for production." This is especially critical in regulated industries where audit trails of who approved a production deployment are required.

## Violations to detect

- Production deployment steps with no `environment:` declaration or protection rules
- Deploy-to-production jobs triggered directly by push events with no approval gate
- Missing `required_reviewers` on GitHub Environment protection rules for production
- GitLab deploy stages to production without `when: manual` or `protected: true` environment
- Deployment triggered from any branch rather than restricted to `main`/`release` branches
- No distinction between staging and production deployment conditions - same trigger, same permissions
- Azure Pipelines environments without approval checks or exclusive lock policies

## Inspection

- `grep -rnE 'deploy.*prod' --include="*.yml" --include="*.yaml" $TARGET` | MEDIUM | Production deploy step - verify gate exists
- `grep -rnE 'environment:\s*\n\s+name:.*prod' --include="*.yml" --include="*.yaml" $TARGET` | LOW | Environment declaration - verify protection rules

## Good practice

- Use platform-native environment protection rules: GitHub Environments with `required_reviewers`, GitLab protected environments, Azure Pipelines approval checks
- Restrict production deployment triggers to specific branches (`main`, `release/*`) - never deploy to production from feature branches
- Require at least one human approval for production deployments; automate deployment to staging and lower environments
- Log who approved each production deployment and when, creating an audit trail
- Combine manual approval with automated policy checks: deployment gates can verify that the artifact passed all test stages, security scans, and compliance checks before allowing the deployment to proceed
- Use deployment freezes (scheduled or manual) to prevent deployments during high-risk windows

## Sources

- Humble, Jez, and David Farley. *Continuous Delivery*. Addison-Wesley, 2010. ISBN 978-0-321-60191-9. Chapter 8.
- OWASP. "CI/CD Top 10: CICD-SEC-1 - Insufficient Flow Control." https://owasp.org/www-project-top-10-ci-cd-security-risks/CICD-SEC-01-Insufficient-Flow-Control (accessed 2026-03-22).
