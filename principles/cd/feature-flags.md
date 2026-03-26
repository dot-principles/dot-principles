# CD-FEATURE-FLAGS — Decouple deployment from release; hide incomplete work behind flags, not branches

**Layer:** 2
**Categories:** devops, continuous-delivery, deployment, release-management
**Applies-to:** all
**Summary:** Decouple deployment from release by hiding incomplete features behind runtime flags, not branches.

## Principle

Deployment (shipping code to production) and release (making a feature visible to users) are separate concerns. Incomplete or experimental features are hidden behind runtime flags, not held back in a branch. Code merges to main continuously; the flag controls when users see the feature. Flags are short-lived: once a feature is stable and fully rolled out, the flag and its dead code are removed.

## Why it matters

Long-lived feature branches are a form of integration debt. The longer a branch lives, the more it diverges from main and the costlier the eventual merge. Feature flags eliminate this problem by keeping all code integrated while decoupling user-visible behaviour from deployment. They also enable targeted rollouts, A/B tests, and instant kill switches for production incidents.

## Violations to detect

- Long-lived feature branches serving as a substitute for feature flags
- `if (environment == "production")` or `if (env.ENABLE_FEATURE_X)` blocks that have persisted for more than one release cycle without cleanup
- Feature flag checks with no corresponding cleanup issue or expiry plan
- Feature toggling done by deploying different build artifacts rather than runtime config
- Hardcoded boolean flags (`if (false) { ... }`) left in production code

## Inspection

```bash
# Environment-name conditionals (potential feature-environment coupling)
grep -rn '"production"\|"staging"\|"development"' --include="*.js" --include="*.ts" --include="*.py" --include="*.java" --include="*.go" --include="*.rb" . | grep -i "if\|env\|environment"

# Hardcoded disabled flags
grep -rn "if (false)\|if(false)" --include="*.js" --include="*.ts" --include="*.java" --include="*.kt" .
```

## Good practice

- Introduce a feature flag library or service (LaunchDarkly, Unleash, Flipt, or a simple config-driven map) rather than ad-hoc `if` checks
- Treat flags as temporary: set a deletion date when the flag is created; remove flags once the feature is fully rolled out and stable
- Use flags to enable canary rollouts — gradually increase the percentage of users who see the feature
- Keep flag checks at the outermost layer of the call stack; avoid scattering them through business logic
- Log flag evaluations so you can correlate flag state with production behaviour

## Sources

- Hodgson, Pete. "Feature Toggles (aka Feature Flags)." martinfowler.com. https://martinfowler.com/articles/feature-toggles.html (accessed 2024-01-01).
- Humble, Jez, and David Farley. *Continuous Delivery*. Addison-Wesley, 2010. ISBN 978-0-321-60191-9. Chapter 14.
