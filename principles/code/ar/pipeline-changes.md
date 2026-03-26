# CODE-AR-PIPELINE-CHANGES — Make infrastructure changes through a pipeline, not direct access

**Layer:** 2
**Categories:** architecture, infrastructure, devops
**Applies-to:** all
**Summary:** Apply all infrastructure changes through an automated pipeline; never run commands directly from a workstation.

## Principle

Infrastructure changes should flow through an automated pipeline — commit code, run validation, plan the change, get approval, apply it. No one should apply infrastructure changes by running commands directly from their workstation. The pipeline is the only path to production infrastructure, ensuring that every change is tested, reviewed, and auditable.

## Why it matters

Direct access to infrastructure tooling means that changes bypass testing, review, and audit controls. A mistyped command can destroy production resources. Without a pipeline, there is no reliable record of what was changed, when, by whom, or why. Pipelines enforce consistency: every change goes through the same validation steps, regardless of who initiates it or how urgent it seems.

## Violations to detect

- Engineers running `terraform apply` or equivalent commands directly from their local machines against production
- Infrastructure credentials distributed to individual developer workstations for production environments
- Changes applied outside of the pipeline and then reverse-engineered into code after the fact
- No automated validation (linting, plan review, policy checks) before infrastructure changes are applied
- Emergency "hotfix" processes that permanently bypass the pipeline rather than using a fast-track pipeline path

## Good practice

- Set up CI/CD pipelines (GitHub Actions, GitLab CI, Jenkins, etc.) that automatically run `plan`/`preview` on pull requests and `apply` on merge
- Restrict production infrastructure credentials to the pipeline service account — individual engineers should not have direct apply permissions
- Include policy-as-code checks (Open Policy Agent, Sentinel, Checkov) in the pipeline to catch security and compliance violations before apply
- Provide a break-glass procedure for genuine emergencies that still logs all actions and requires post-incident reconciliation with code
- Make the pipeline output (plan diffs) visible in pull requests so reviewers can see exactly what will change

## Sources

- Morris, Kief. *Infrastructure as Code*, 2nd ed. O'Reilly, 2020. ISBN 978-1-098-11467-1. Chapter 9: "Delivery Pipeline for Infrastructure."
