# Requirements

.principles require the following tools to be available on your system.

## Bash

Used by `install.sh` and `uninstall.sh`.

| Platform | Status | How to get it |
|----------|--------|---------------|
| Linux    | Pre-installed | Available on all mainstream distributions |
| macOS    | Requires upgrade | Ships with Bash 3.2 (too old). Install Bash 4+: `brew install bash` |
| Windows  | Requires setup | Install [Git for Windows](https://git-scm.com/download/win) (includes Git Bash), or enable WSL, or use MSYS2/Cygwin — any installation that puts `bash` on `PATH` works |

Minimum version: **Bash 4.0** (for associative arrays and `set -euo pipefail`).

Verify: `bash --version`

### Windows wrapper scripts

On Windows, use `install.ps1` / `uninstall.ps1` (PowerShell) or `install.cmd` / `uninstall.cmd` (Command Prompt) instead of calling `install.sh` directly. These wrappers detect bash on `PATH` and normalize Windows absolute paths before forwarding arguments to bash. See [INSTALL.md](INSTALL.md) for usage.

## AI Model

The `/dot-audit`, `/dot-prime`, and `/dot-scout` commands work with a range of AI models, but premium models are recommended for the best review quality and output formatting.

| Model | Status | Notes |
|-------|--------|-------|
| Claude Haiku 4.5 | Tested | Fast, excellent output |
| Claude Sonnet 4.6 | Tested | Works well |
| GPT-4.1 | Tested | Works well |
| GPT-5.1-mini (low) | Tested | Slow, produces valid JSON but less polished text output |
| Local LLMs | **Not supported** | Not tested, not expected to work |

Premium models (Claude Haiku 4.5+, GPT-4.1+) are recommended — they produce more thorough reviews and better formatted results. The commands rely on the model's ability to follow multi-phase structured prompts, produce valid JSON, and format text output consistently. Smaller or quantized models are likely to skip steps or produce malformed output.

> **Note:** Even with premium models, the formatting of `/dot-audit` results will vary between models and between runs. The principle review itself is performed by the AI, and quality depends on the model — some produce thorough, well-structured audits; others may miss findings or deviate from the output template. The `audit-output.json` file is the most reliable artefact; the text report is best-effort.
