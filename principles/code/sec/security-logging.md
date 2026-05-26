# CODE-SEC-SECURITY-LOGGING - Log security events and monitor for attacks

**Layer:** 2 (contextual)
**Categories:** security
**Applies-to:** all
**Summary:** Log all security-relevant events with full context and actively monitor for anomalous patterns and attacks.

## Principle

Log all security-relevant events and actively monitor them to detect and respond to attacks. Security Logging and Monitoring Failures (A09:2021) occur when applications do not record enough information to detect breaches, when logs are only stored locally, when alerting thresholds are absent, or when incident response processes are not in place. Without adequate logging and monitoring, breaches go undetected for months.

## Why it matters

The average time to detect a breach is measured in months, not minutes. Without logging, there is no evidence trail for forensic analysis and no trigger for automated response. Attackers rely on the absence of monitoring to operate undetected, escalate access, and exfiltrate data. Regulatory frameworks (GDPR, PCI DSS, HIPAA) also mandate audit logging of security-relevant events.

## Violations to detect

- Login attempts (successful and failed) not logged
- Access control failures, input validation failures, and privilege escalations not logged
- Logs that do not include sufficient context (timestamp, user identity, source IP, action, resource)
- Log data only stored on the local application server with no central aggregation
- No alerting configured for suspicious patterns (repeated auth failures, unusual data access)
- Sensitive data (passwords, tokens, PII) written into log entries

## Good practice

- Log all authentication events, access control decisions, input validation failures, and administrative actions
- Include structured context in every log entry: timestamp, user ID, source IP, action, resource, and outcome
- Send logs to a centralized, tamper-resistant logging system (SIEM) in near-real time
- Configure alerts for anomalous patterns: brute-force attempts, privilege escalation, unusual volumes of access
- Never log sensitive data - mask or exclude passwords, tokens, credit card numbers, and PII
- Establish and regularly test an incident response plan that uses log data for investigation and remediation

## Sources

- OWASP Foundation. "OWASP Top 10:2021 - A09:2021 Security Logging and Monitoring Failures." https://owasp.org/Top10/A09_2021-Security_Logging_and_Monitoring_Failures/
