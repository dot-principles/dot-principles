# CODE-OB-ALERT-ON-SYMPTOMS - Alert on user-visible symptoms, not internal causes

**Layer:** 2 (contextual)
**Categories:** observability, operations, reliability
**Applies-to:** all
**Summary:** Alert on user-visible symptoms like error rates and latency SLOs, not on internal resource signals.
**Audit-scope:** limited - alert rule files (Prometheus rules, Grafana alerts, PagerDuty policies) are readable and inspectable; on-call behaviour and escalation processes are not

## Principle

Write alert rules that fire on user-visible symptoms - elevated error rates, breached latency SLOs, service unavailability - rather than on internal resource signals such as CPU usage, memory consumption, or queue depth. Cause-based alerts tell you that *something* is wrong internally; symptom-based alerts tell you that *users are being hurt*. Reserve cause-based metrics for dashboards and post-incident investigation rather than waking engineers at 3 am.

## Why it matters

Cause-based alerts generate excessive noise. CPU spikes, memory pressure, and queue growth often self-resolve before any user experiences degradation. When every resource fluctuation pages on-call engineers, alert fatigue sets in and real incidents are missed or deprioritised. Conversely, a symptom-based alert that fires when 5% of requests are failing tells engineers immediately that action is required and ties the urgency directly to user impact.

## Violations to detect

- Alerting rules that threshold on CPU, memory, or disk utilisation as the sole trigger for a page
- Alerts on queue depth or connection pool fill with no corresponding check on service-level error or latency impact
- No alerting rules at all linked to user-facing SLOs or error rates
- Alerts expressed as absolute metric thresholds (e.g., `response_time > 500ms`) rather than as SLO burn rates or percentile violations
- On-call runbooks that list "check CPU" as step 1, indicating that cause-based metrics - not symptoms - are the primary operational signal

## Good practice

- Make SLO burn rate the primary alerting signal; let burn-rate thresholds define urgency tiers
- Demote CPU, memory, and saturation metrics to informational dashboards and automated capacity reports
- For alerts that remain cause-based (e.g., disk filling up before a write failure occurs), ensure they are clearly labelled as predictive/capacity alerts and carry lower urgency than symptom alerts
- Include the user-visible impact in every alert description so the on-call engineer immediately understands what users are experiencing
- Review your alert roster regularly: for each alert, ask "does this always require immediate human action, and is it always correlated with user impact?"

## Sources

- Beyer, Betsy; Jones, Chris; Petoff, Jennifer; Murphy, Niall Richard. *Site Reliability Engineering: How Google Runs Production Systems*. O'Reilly, 2016. ISBN 978-1-491-92912-4. Chapter 6 (Monitoring Distributed Systems).
- Beyer, Betsy; Murphy, Niall; Rensin, David; Kawahara, Kent; Thorne, Stephen. *The Site Reliability Workbook*. O'Reilly, 2018. ISBN 978-1-492-02916-2. Chapter 5 (Alerting on SLOs).
