# CD-PIPELINE-AS-CODE - CI/CD pipeline definitions are committed to version control alongside application code

**Layer:** 1
**Categories:** devops, continuous-delivery, automation, version-control
**Applies-to:** all
**Summary:** Commit every CI/CD pipeline step to version control and review it like application code.

## Principle

The CI/CD pipeline - every build, test, and deployment step - is defined in code committed to version control and reviewed like any other change. Pipeline definitions live in the repository they govern (Jenkinsfile, `.github/workflows/`, `.gitlab-ci.yml`, `Buildkite pipeline.yml`, etc.). Pipelines configured only in a CI tool's UI are invisible, unreviewed, and not reproducible.

## Why it matters

A pipeline defined only in a GUI is a single point of failure: if the tool loses its configuration or the configuration is changed without review, the pipeline is gone and the change history is gone with it. Treating pipeline definitions as code subjects them to the same version control, review, and reproducibility guarantees as application code. It also enables the pipeline itself to be tested and evolved safely.

## Violations to detect

- No pipeline definition file in the repository (no `Jenkinsfile`, no `.github/workflows/*.yml`, no `.gitlab-ci.yml`, no `.circleci/config.yml`, no `azure-pipelines.yml`, etc.)
- Pipeline steps documented in a wiki or README as manual instructions rather than encoded in pipeline config
- Comments in the pipeline file noting that critical steps are defined "in the Jenkins UI" or equivalent
- Multiple versions of the pipeline for different environments maintained outside version control

## Inspection

```bash
# Check for common CI/CD pipeline definition files
ls Jenkinsfile .gitlab-ci.yml azure-pipelines.yml 2>/dev/null
ls .github/workflows/*.yml .github/workflows/*.yaml 2>/dev/null
ls .circleci/config.yml .buildkite/pipeline.yml 2>/dev/null
```

## Good practice

- Store pipeline definitions in the root of the repository or in a well-known directory (`.github/workflows/`, `.circleci/`, etc.)
- Apply the same code review standards to pipeline changes as to application code - require approval before merging
- Use pipeline templates or shared libraries to avoid duplicating pipeline logic across services
- Pin action/plugin versions to specific commits or version tags to prevent silent pipeline changes from upstream updates
- Test pipeline changes in a branch before merging; use dry-run modes where available

## Sources

- Morris, Kief. *Infrastructure as Code*, 2nd ed. O'Reilly, 2020. ISBN 978-1-098-11467-1. Chapter 9.
- Jenkins. "Pipeline." https://www.jenkins.io/doc/book/pipeline/ (accessed 2024-01-01).
