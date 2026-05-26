# CODE-AR-IMMUTABLE-INFRASTRUCTURE - Design infrastructure for immutability - replace, don't patch

**Layer:** 2
**Categories:** architecture, infrastructure, devops
**Applies-to:** all
**Summary:** Replace infrastructure components by building new immutable instances; never modify running instances in place.

## Principle

Infrastructure components should be treated as immutable after creation. When a change is needed - a new OS patch, a configuration update, a new application version - build a new instance with the change baked in and replace the old one, rather than modifying the running instance in place. Servers, containers, and infrastructure components should be disposable and reproducible, not precious and hand-maintained.

## Why it matters

Mutable infrastructure accumulates hidden state over time: patches applied in one order, packages added for debugging and never removed, configuration files hand-edited. This configuration drift makes instances unreproducible and fragile - rebuilding from scratch produces something subtly different from what is running. Immutable infrastructure eliminates drift by definition: every instance is built from the same image or definition, and no changes are made after deployment.

## Violations to detect

- SSH access used routinely to patch, update, or reconfigure running production servers
- Configuration management tools (Ansible, Chef, Puppet) running in "converge" mode on long-lived mutable servers as the primary change mechanism
- Servers that have been running for months or years without being rebuilt from their definitions
- Deployment processes that modify running instances (e.g., pulling new code onto a running server) rather than deploying new instances
- Snowflake servers that cannot be rebuilt because their current state is unknown

## Good practice

- Build machine images (AMIs, VM images) or container images with all dependencies and configuration baked in at build time
- Deploy new versions by launching new instances from the updated image and draining traffic from old instances (blue-green or rolling deployment)
- Disable or tightly restrict SSH access to production instances - if you need to debug, connect to a disposable clone
- Use auto-scaling groups or orchestrators (Kubernetes) that automatically replace failed instances with fresh ones from the current image
- Treat any manual change to a running instance as technical debt that must be encoded into the build process

## Sources

- Morris, Kief. *Infrastructure as Code*, 2nd ed. O'Reilly, 2020. ISBN 978-1-098-11467-1. Chapter 8: "Patterns for Updating and Changing Infrastructure."
