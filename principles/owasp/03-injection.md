# OWASP-03-INJECTION - Injection

**Layer:** 3 (risk-elevated)
**Categories:** security, injection, input-validation
**Applies-to:** all
**Summary:** Use parameterised queries and structured APIs for all interpreter calls; never concatenate user data into commands.

## Principle

Never mix untrusted data with commands or queries. Injection flaws - SQL, NoSQL, OS command, LDAP, template injection - occur when hostile data is sent to an interpreter as part of a command or query, allowing an attacker to alter the intended execution.

## Why it matters

Injection is one of the most dangerous vulnerability classes. A single unsanitised parameter in a SQL query can give an attacker full read/write access to the database, exfiltrate all user data, or execute OS commands. The impact is typically Critical with trivial exploitability.

## Violations to detect

- String concatenation or interpolation to build SQL queries with user-supplied data
- OS command construction using user input (e.g., `exec("ping " + userInput)`)
- Template engines rendering user-supplied content without escaping (Server-Side Template Injection)
- Dynamic LDAP queries or XML/XPath expressions built from user input
- ORM raw query methods called with unsanitised input instead of parameterised equivalents

## Good practice

- Use parameterised queries / prepared statements for all database access - never string interpolation
- For OS commands: use APIs that pass arguments as arrays (never shell interpolation), or avoid OS commands entirely
- Validate and allowlist input at the boundary; reject input that does not match expected format
- Apply the principle of least privilege to database accounts: the app's DB user should not have DROP or admin privileges

## Sources

- OWASP Foundation. "A03:2021 - Injection." *OWASP Top 10*, 2021. https://owasp.org/Top10/A03_2021-Injection/
- OWASP Foundation. "SQL Injection Prevention Cheat Sheet." https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html
