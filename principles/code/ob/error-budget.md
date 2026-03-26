# CODE-OB-ERROR-BUDGET — Operationalise reliability through error budget burn-rate alerting

**Layer:** 2 (contextual)
**Categories:** observability, operations, reliability
**Applies-to:** all
**Summary:** Alert on SLO burn rate and treat reliability as highest priority when the error budget is exhausted.

## Principle

An SLO's error budget — the permitted amount of unreliability within a rolling window — should drive alerting and engineering policy. Alert on *burn rate* (how fast the budget is being consumed) rather than on instantaneous metric thresholds. Use a multi-window, multi-burn-rate strategy: a fast burn catches severe outages quickly; a slow burn catches subtle degradation that would exhaust the budget before the window closes. When the budget is exhausted, treat reliability work as the team's highest priority.

## Why it matters

Alerting on fixed metric thresholds (e.g., "error rate > 1%") does not tell you whether the problem actually threatens user experience over time. A brief spike may consume almost no budget; a sustained 0.5% degradation may exhaust it before the SLO window closes. Burn-rate alerting connects every alert to user impact, cuts alert noise from transient spikes, and surfaces slow-burning degradation that threshold alerting misses.

## Violations to detect

- Alerting rules expressed as absolute metric thresholds with no reference to a budget consumption rate
- SLOs defined but no corresponding burn-rate alert rules in the codebase or alert configuration
- A single alert window (e.g., 1-hour only) with no companion long-window (e.g., 6-hour or 3-day) alert to catch slow burns
- Error budget tracked in a spreadsheet or external document rather than derived from live SLI data
- Feature development continuing in code reviews and merges with no mechanism to pause when the error budget is exhausted

## Inspection

```
# Flag alert rules with no burn_rate or budget reference (Prometheus rule files)
grep -r 'alert:' --include='*.yaml' --include='*.yml' -l | xargs grep -L 'burn_rate\|error_budget\|budget'
```

## Good practice

- Express alert conditions as burn-rate multiples (e.g., 14× = budget exhausted in 1 hour) across two windows (5 min + 1 hour for fast; 30 min + 6 hour for slow)
- Keep alert rule files in version control alongside application code so budget policy is reviewable
- Display remaining error budget on team dashboards, updated in near-real-time from SLI data
- Establish and document a policy: at what burn level does feature work pause? Who approves exceptions?
- Regularly review budget consumption history to recalibrate SLO targets

## Sources

- Beyer, Betsy; Jones, Chris; Petoff, Jennifer; Murphy, Niall Richard. *Site Reliability Engineering: How Google Runs Production Systems*. O'Reilly, 2016. ISBN 978-1-491-92912-4. Chapter 3 (Embracing Risk).
- Beyer, Betsy; Murphy, Niall; Rensin, David; Kawahara, Kent; Thorne, Stephen. *The Site Reliability Workbook*. O'Reilly, 2018. ISBN 978-1-492-02916-2. Chapter 5 (Alerting on SLOs).
