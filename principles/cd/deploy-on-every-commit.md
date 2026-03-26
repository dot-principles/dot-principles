# CD-DEPLOY-ON-EVERY-COMMIT — The pipeline should be capable of releasing any green commit to production

**Layer:** 2
**Categories:** devops, continuous-delivery, automation, deployment
**Applies-to:** all
**Summary:** Automate the pipeline so any green commit can be deployed to production without manual intervention.
**Audit-scope:** limited — whether every commit is actually deployed requires observing pipeline runs; code can show whether automated deployment configuration exists at all.

## Principle

Every commit that passes all automated tests should be in a deployable state. The deployment pipeline must be capable of taking any green commit to production without manual intervention. This does not require deploying every commit, but it requires that the capability exists — there are no manual steps that gate a release outside of deliberate human approval.

## Why it matters

If releasing requires manual steps not captured in the pipeline, releases become rare, large, and risky. Teams that release infrequently accumulate change — more unknowns, larger blast radii, longer recovery windows. The goal is to make each change small enough and the pipeline trustworthy enough that deploying is unremarkable.

## Violations to detect

- No deployment automation at all — release requires a developer to manually run commands
- Deployment pipeline that stops short of production and requires out-of-band steps to complete the release
- Release steps documented only in a runbook, not encoded in pipeline configuration
- Separate "release scripts" maintained outside the repository by a specific team member
- Manual environment-promotion steps (e.g., "log in to the server and restart the service")

## Good practice

- Encode every deployment step in pipeline configuration checked into version control
- Use continuous deployment for low-risk services; use continuous delivery (automated pipeline with a human approval gate) where business constraints require it
- Automate all environment promotions (dev → staging → production) with a single pipeline trigger
- Treat the deployment pipeline as production code — review changes, test it, and keep it green

## Sources

- Humble, Jez, and David Farley. *Continuous Delivery*. Addison-Wesley, 2010. ISBN 978-0-321-60191-9. Chapter 1.
- Forsgren, Nicole, Jez Humble, and Gene Kim. *Accelerate: The Science of Lean Software and DevOps*. IT Revolution, 2018. ISBN 978-1-942788-33-1.
