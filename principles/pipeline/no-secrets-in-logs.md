# PIPELINE-NO-SECRETS-IN-LOGS — Never expose secrets in pipeline logs

**Layer:** 1 (universal)
**Categories:** security, pipeline
**Applies-to:** pipeline
**Summary:** Never echo secrets in pipeline output; use masked variables and pass credentials via stdin or credential helpers.

## Principle

Secrets, tokens, passwords, and credentials must never appear in CI/CD pipeline logs or job output. Pipeline logs are often stored for extended periods, accessible to a broader audience than the secrets themselves, and sometimes exported to external log aggregators. Use masked variables, secrets management integrations, and log redaction to ensure credentials never appear in plain text in any pipeline output.

## Why it matters

Pipeline logs are a common source of accidental credential exposure. Debugging a failed deployment often involves printing environment variables or command output — and a single `echo $SECRET` or verbose curl command can leak a credential into a log that is accessible to the whole engineering team, stored in a log aggregation system, or included in a bug report. Unlike a code commit, log exposure may not trigger alerts or be noticed until damage has occurred.

## Violations to detect

- `echo $DATABASE_PASSWORD` or `print(os.environ["SECRET"])` in pipeline scripts
- Verbose curl/wget commands with `-v` flag that print request headers including `Authorization:` tokens
- Commands that expand secrets inline: `mysql -u root -p$DB_PASS` (exposes the password in process list and verbose logs)
- Environment variable dumps (`env`, `printenv`, `set -x` in bash) that run when secrets are in scope
- Log statements inside pipeline steps that include request/response bodies containing tokens
- `set -x` bash debug mode active globally in scripts that handle secrets

## Inspection

- `grep -n "echo.*\$.*PASSWORD\|echo.*\$.*SECRET\|echo.*\$.*TOKEN\|echo.*\$.*KEY" $TARGET` | HIGH | Possible secret echo in logs

## Good practice

- Always use masked/secret variables in CI/CD platforms (GitHub Actions secrets, GitLab masked variables, Jenkins credentials binding)
- Never use `set -x` in script sections that handle secrets; wrap only the non-secret sections if debug logging is needed
- Use dedicated credential helpers: `docker login` via credential stores, git credential managers, not inline passwords
- Pass secrets via stdin or a credentials file rather than command-line arguments (which appear in process lists)
- Audit pipeline logs periodically with secret scanning tools (e.g., `truffleHog`, `detect-secrets`)
- Rotate any secret that may have appeared in a log

## Sources

- OWASP. "CI/CD Security Cheat Sheet." OWASP Cheat Sheet Series. https://cheatsheetseries.owasp.org/cheatsheets/CI_CD_Security_Cheat_Sheet.html (accessed 2026-03-18).
- GitLab. "Masked variables." https://docs.gitlab.com/ee/ci/variables/#mask-a-cicd-variable (accessed 2026-03-18).
