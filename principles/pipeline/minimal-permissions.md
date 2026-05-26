# PIPELINE-MINIMAL-PERMISSIONS - Run pipeline jobs with minimal permissions

**Layer:** 1 (universal)
**Categories:** security, pipeline
**Applies-to:** pipeline
**Summary:** Grant each pipeline job only the minimum permissions and secrets required for its specific task.

## Principle

Every pipeline job - build, test, deploy, release - should run with the minimum permissions required to complete its specific task. Broad IAM roles, wildcard scopes (`*`), inherited admin credentials, or reused service accounts with accumulated permissions violate this principle. Permissions should be scoped per job, not inherited from a shared "pipeline user".

## Why it matters

Over-permissioned pipelines are a high-value attack surface. A compromised build step with write access to all production environments can escalate to a full production breach. Supply chain attacks increasingly target CI/CD systems because pipelines often run with elevated credentials. Minimal permissions limit blast radius: a compromised job can only damage what it was specifically permitted to touch.

## Violations to detect

- A single pipeline service account with admin or broad write access used across all jobs
- `permissions: write-all` or `permissions: {}` (defaults to write) in GitHub Actions workflows
- IAM roles with `Action: "*"` or `Resource: "*"` assigned to pipeline execution roles
- Secrets with broad scope (e.g., AWS root credentials) passed to all pipeline steps
- Deploy steps that receive the same credentials as build steps
- No explicit `permissions:` declaration in GitHub Actions jobs (defaults to inherited repo permissions)

## Inspection

- `grep -n "permissions: write-all\|Action.*\*.*Resource.*\*" $TARGET` | HIGH | Overly broad permissions

## Good practice

- Declare explicit minimum permissions per job in CI config: read for build/test, write only for deploy
- In GitHub Actions: `permissions: contents: read` for build jobs; `permissions: id-token: write` only for OIDC-based deploy jobs
- Use short-lived credentials via OIDC federation rather than long-lived static secrets
- Create separate service accounts per pipeline stage; never share credentials across build and deploy
- Apply principle of least privilege to secret access: only the secrets a job actually needs, not a master set
- Audit pipeline permissions in the same security reviews as application IAM policies

## Sources

- OWASP. "CI/CD Security Cheat Sheet." OWASP Cheat Sheet Series. https://cheatsheetseries.owasp.org/cheatsheets/CI_CD_Security_Cheat_Sheet.html (accessed 2026-03-18).
- GitHub. "Controlling permissions for GITHUB_TOKEN." https://docs.github.com/en/actions/security-guides/automatic-token-authentication (accessed 2026-03-18).
