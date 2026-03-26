# CD-TRUNK-BASED-DEVELOPMENT — Commit to the main branch frequently; avoid long-lived feature branches

**Layer:** 1
**Categories:** devops, continuous-delivery, version-control, collaboration
**Applies-to:** all
**Summary:** Integrate to the main branch at least daily; use feature flags to hide incomplete work instead of branches.
**Audit-scope:** limited — branch lifetime requires git history; code snapshot can reveal documented branching policies in CONTRIBUTING.md or README.

## Principle

Developers integrate their work into the main branch (trunk) at least daily, keeping branches short-lived — hours, not days. If a feature is not complete, it is hidden behind a feature flag or dark-launched, not kept in a branch. The main branch is always in a releasable state.

## Why it matters

Long-lived feature branches accumulate divergence from main. Merging them is painful, creates integration conflicts, and delays discovery of incompatibilities between parallel workstreams. Trunk-based development forces continuous integration at the code level, surfaces conflicts immediately, and ensures the team always works from a shared, tested baseline.

## Violations to detect

- Feature branches that exist for more than a few days without being merged
- Integration branches used to batch together multiple feature branches before merging to main
- A CONTRIBUTING.md or branching policy that mandates long-lived feature branches
- Release branches maintained in parallel with the main branch for extended periods
- Merge commits that bundle weeks of diverged history into a single giant integration

## Good practice

- Merge to main at least once per day per developer; use feature flags to hide incomplete work
- Keep pull requests small and focused — a PR that takes more than a day to review is too large
- Set branch protection rules that require CI to pass, then merge and delete the branch immediately
- Prefer rebase-and-merge or squash-merge to keep history linear and bisectable
- Use short-lived branches for code review only — branch, open PR, merge, delete

## Sources

- Humble, Jez, and David Farley. *Continuous Delivery*. Addison-Wesley, 2010. ISBN 978-0-321-60191-9. Chapter 13.
- Forsgren, Nicole, Jez Humble, and Gene Kim. *Accelerate: The Science of Lean Software and DevOps*. IT Revolution, 2018. ISBN 978-1-942788-33-1. Chapter 4.
- Hammant, Paul. "Trunk Based Development." https://trunkbaseddevelopment.com (accessed 2024-01-01).
