# SEC-ARCH-SEPARATION-OF-PRIVILEGE - Require multiple independent conditions to grant access

**Layer:** 2 (contextual)
**Categories:** security, architecture, access-control
**Applies-to:** all
**Summary:** Require two or more independent conditions to grant access to any sensitive resource or operation.

## Principle

Access to a protected resource or operation must depend on satisfying two or more independent conditions. No single credential, approval, or factor should be sufficient to perform a sensitive action. Separating privilege across independent conditions means that compromising one factor does not automatically grant access - the attacker must independently compromise each required factor.

## Why it matters

Single-factor access creates a single point of compromise. A stolen password, a compromised API key, or a single approver acting alone can grant full access to sensitive resources. Requiring multiple independent conditions - a second authentication factor, a separate approver, a countersignature from a different system - means the attacker must breach multiple independent channels simultaneously. This is the principle behind multi-factor authentication, dual-key safe deposit boxes, and two-person integrity controls in nuclear launch procedures. Every major breach post-mortem that identifies "single credential compromised" as root cause is a failure of separation of privilege.

## Violations to detect

- Authentication that accepts a single factor (password only) for access to sensitive operations without requiring a second independent factor
- Deployment pipelines where a single developer can merge and deploy to production without a second approval
- Administrative actions (user deletion, role escalation, data export) that require only a single authenticated session - no re-authentication, MFA challenge, or countersignature
- API keys or service accounts that grant broad access without requiring a secondary authorisation token scoped to the specific operation
- Secret management systems where a single identity can read production secrets without a co-signer or break-glass audit trail
- Infrastructure-as-code changes that can be applied by a single actor without peer review or approval gate

## Good practice

- Require multi-factor authentication (MFA) for all human access to sensitive systems - password plus TOTP, FIDO2, or hardware key
- Enforce mandatory code review and a second approval for merges to protected branches and production deployments
- Implement dual-authorisation for destructive or irreversible operations: require two independent identities to confirm
- Use separate credentials for authentication (identity) and authorisation (permission), so that compromising one does not automatically grant the other
- For secret access, require both identity verification and a scoped access token issued by a separate authorisation service
- Log and alert on any operation that bypasses the normal multi-condition access flow (break-glass procedures)

## Sources

- Saltzer, J.H. and Schroeder, M.D. "The Protection of Information in Computer Systems." *Proceedings of the IEEE*, 63(9), 1975. DOI 10.1109/PROC.1975.9939. (Principle of Separation of Privilege.)
- NIST. *Special Publication 800-63B: Digital Identity Guidelines - Authentication and Lifecycle Management.* 2017. https://doi.org/10.6028/NIST.SP.800-63b (Multi-factor authentication requirements.)
