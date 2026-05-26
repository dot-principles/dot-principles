# INFRA-IMMUTABLE-INFRASTRUCTURE - Infrastructure is immutable: replace, never patch

**Layer:** 2 (contextual)
**Categories:** infrastructure, devops, reliability
**Applies-to:** cloud, containerised, vm-based
**Summary:** Never modify running infrastructure; replace it by deploying a freshly built, versioned artifact from a pipeline.

## Principle

Once a server, container image, or VM is deployed, it is never modified in place. Patches, configuration changes, and application updates are applied by building a new artifact and deploying it to replace the old one. Running infrastructure is treated as read-only. This principle applies at every level: base images, machine images, container images, and runtime configuration.

## Why it matters

Mutable servers accumulate undocumented state. Packages are installed, files are edited, services are restarted with different arguments - none of which appears in version history. The longer a server runs, the more it diverges from the original specification and from its peers. Immutable infrastructure eliminates this class of problem: if a server cannot be modified, it cannot drift, and every running instance is provably identical to what version control says it should be.

## Violations to detect

- Configuration management runs (Ansible, Chef, Puppet) that modify running servers rather than building new images
- `apt install` or `yum install` run directly on a production server
- Application deployments that copy files onto a running instance rather than swapping the entire container or VM
- Images or AMIs built interactively ("log in and configure it") rather than from a reproducible pipeline
- Long-running VMs or containers with uptime measured in months or years

## Good practice

- Use a container image or machine image as the deployment unit; never SSH in to change it
- Build images in a CI pipeline from a versioned Dockerfile or Packer template
- Deploy with a blue-green or rolling strategy that replaces instances rather than updating them
- Set short TTLs or rotation schedules for infrastructure to prevent long-lived state from accumulating

## Sources

- Morris, Kief. *Infrastructure as Code*, 2nd ed. O'Reilly, 2020. ISBN 978-1-4920-7522-6. Chapter 6.
- Fowler, Martin. "ImmutableServer." *martinfowler.com*, 2013. https://martinfowler.com/bliki/ImmutableServer.html
