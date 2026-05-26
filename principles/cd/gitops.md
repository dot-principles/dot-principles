# CD-GITOPS - Infrastructure and application state is declared in git; an operator continuously reconciles actual state to match

**Layer:** 2
**Categories:** devops, infrastructure, continuous-delivery, version-control
**Applies-to:** all
**Summary:** Declare all infrastructure state in git and let an automated operator continuously reconcile the live environment.

## Principle

The desired state of all infrastructure and application configuration is stored in git as the single source of truth. An automated operator (Argo CD, Flux, etc.) watches the repository and continuously reconciles the live environment to match the declared state. Changes to production are made by merging a pull request, not by running commands.

## Why it matters

Manual changes to infrastructure - even well-intentioned ones - diverge from the declared state and are impossible to audit, reproduce, or roll back reliably. Git provides an immutable audit log, a review mechanism (pull requests), and a rollback path (revert a commit). Continuous reconciliation means drift is detected and corrected automatically rather than accumulating silently.

## Violations to detect

- Deployment or infrastructure configuration that lives only in a CI/CD tool's UI, not in version control
- Direct `kubectl apply`, `helm upgrade`, or cloud console changes made without a corresponding git commit
- Environment state that cannot be fully reconstructed from the repository
- Absence of a reconciliation operator - changes are pushed rather than pulled by a controller
- Infrastructure "drift" where the live environment diverges from what is in git with no alert

## Good practice

- Store all Kubernetes manifests, Helm values, and Terraform state in git; use Argo CD or Flux to apply them
- Gate production changes behind a pull request with required reviewers
- Configure the reconciliation operator to alert on drift rather than silently accepting it
- Use separate repositories or directories for different environment tiers (or Argo CD ApplicationSets)
- Treat secrets separately - use a secrets manager with git-stored references, never plaintext secrets in git

## Sources

- Limoncelli, Thomas A. "GitOps: A Path to More Self-service IT." *ACM Queue*, vol. 16, no. 3, 2018. https://doi.org/10.1145/3237461.3238585
- Weaveworks. "GitOps - Operations by Pull Request." https://www.weave.works/blog/gitops-operations-by-pull-request (accessed 2024-01-01).
