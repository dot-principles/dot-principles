# CODE-SEC-VALIDATE-INPUT - Validate input at system boundaries

**Layer:** 1 (universal)
**Categories:** security, reliability, api-design
**Applies-to:** all
**Summary:** Validate all input at every system boundary; never trust external data.

## Principle

Never trust data crossing a trust boundary. Validate type, format, range, and length at every entry point: HTTP handlers, CLI arguments, file parsers, message consumers, and deserialization endpoints. Once validated, pass trusted types inward so inner code can rely on invariants without re-checking.

## Why it matters

Unvalidated input is the root cause of injection attacks (SQL, command, path traversal), crashes from malformed data, and subtle corruption that surfaces far from the source. Most entries in the OWASP Top 10 trace back to insufficient input validation.

## Violations to detect

- Raw user input passed directly to database queries, shell commands, or file paths
- Deserialized objects used without schema validation
- Missing length or range checks on numeric or string inputs
- Trust assumptions on data from "internal" services without validation
- Denylists instead of allowlists for input filtering

## Inspection

- `grep -rnE 'eval\(|exec\(' --include="*.py" $TARGET` | HIGH | Direct eval/exec calls
- `grep -rnE 'system\(|popen\(' --include="*.py" --include="*.rb" --include="*.php" $TARGET` | HIGH | Shell command execution
- `grep -rnE '\.query\(.*\+|\.execute\(.*\+|\.raw\(.*\+' --include="*.py" --include="*.js" --include="*.ts" $TARGET` | HIGH | String concatenation in database queries
- `grep -rnE 'shell\s*=\s*True' --include="*.py" $TARGET` | HIGH | Shell injection via subprocess

## Good practice

- Use allowlists over denylists - define what is valid, reject everything else
- Validate at the boundary, then pass strongly-typed validated objects inward
- Use schema validation for structured input (JSON Schema, Protocol Buffers, XML Schema)
- Treat all external input as untrusted, including data from partner APIs and message queues

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 49: "Check parameters for validity."
- OWASP Foundation. "Input Validation Cheat Sheet." https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html
- OWASP Foundation. "OWASP Top 10:2021 - A03 Injection." https://owasp.org/Top10/A03_2021-Injection/
