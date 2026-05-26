# PIPELINE-ENVIRONMENT-ISOLATION - Pipeline stages must not share mutable state

**Layer:** 1 (universal)
**Categories:** reliability, pipeline, security
**Applies-to:** pipeline
**Summary:** Run each pipeline stage in an isolated context with explicit artifact passing and per-stage credentials.

## Principle

Each pipeline stage - build, test, deploy - must execute in an isolated context with its own workspace, credentials, and environment variables. Stages must not share mutable filesystem state, database connections, or environment variables beyond what is explicitly passed as stage outputs. A failing or compromised stage must not be able to corrupt the workspace of another stage.

## Why it matters

Shared mutable state between pipeline stages is a source of flaky builds, phantom test passes, and security escalation. A test stage that writes to a shared directory can cause a subsequent deploy stage to ship untested files. Shared credentials mean a compromised build step can access production secrets intended only for the deploy step. Isolation ensures that each stage is self-contained: its inputs are explicit, its outputs are intentional, and its failures are contained.

## Violations to detect

- Shared filesystem mounts or working directories between build and deploy stages without explicit artifact passing
- Environment variables with production credentials available to all stages including build and test
- Pipeline steps that write to a shared global cache used by subsequent steps without versioning or scoping
- Database or service connections shared across test and deploy stages
- Reuse of the same container instance across stages rather than starting fresh per stage
- `services:` or `docker-compose` blocks in CI that persist across unrelated stages

## Inspection

- `grep -rnE 'cache:\s*\n\s+key:.*\$CI_PIPELINE_ID' --include="*.yml" --include="*.yaml" $TARGET` | MEDIUM | Pipeline-scoped cache may leak state across stages
- `grep -rnE 'artifacts:\s*\n\s+untracked:\s+true' --include="*.yml" --include="*.yaml" $TARGET` | MEDIUM | Untracked artifacts may pass unintended files between stages

## Good practice

- Use explicit artifact passing between stages: one stage produces a named artifact, the next stage downloads it by name
- Scope credentials per stage: build steps receive read-only registry credentials, deploy steps receive deploy credentials, never both
- Run each stage in a fresh container or clean workspace; do not carry over filesystem state from previous stages
- Scope pipeline caches to the branch and stage, not globally across the entire pipeline
- Use environment protection rules (GitHub Environments, GitLab protected environments) to restrict which stages can access which secrets
- Pass only the minimum required outputs between stages - not the entire workspace

## Sources

- Humble, Jez, and David Farley. *Continuous Delivery*. Addison-Wesley, 2010. ISBN 978-0-321-60191-9. Chapter 4.
- OWASP. "CI/CD Security Cheat Sheet." OWASP Cheat Sheet Series. https://cheatsheetseries.owasp.org/cheatsheets/CI_CD_Security_Cheat_Sheet.html (accessed 2026-03-22).
