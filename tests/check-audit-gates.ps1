# check-audit-gates.ps1 — Verify that Phase 8–10 gate language is intact in all interactive audit files.
# Run locally before pushing, or via CI on PRs that touch audit/skill files.
# Usage: ./tests/check-audit-gates.ps1 [repo-root]
param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)

$AuditFiles = @(
    Join-Path $RepoRoot ".agents\skills\audit\SKILL.md"
    Join-Path $RepoRoot ".github\skills\audit\SKILL.md"
    Join-Path $RepoRoot ".github\prompts\audit.prompt.md"
    Join-Path $RepoRoot "commands\audit.md"
)

# Files that use plain-text output (not ask_user tool) must include the hard-stop phrase.
$PlainTextFiles = @(
    Join-Path $RepoRoot ".agents\skills\audit\SKILL.md"
    Join-Path $RepoRoot ".github\skills\audit\SKILL.md"
    Join-Path $RepoRoot "commands\audit.md"
)

$Errors = 0

function Check-Marker {
    param([string]$File, [string]$Pattern, [string]$Label)
    $content = Get-Content $File -Raw -ErrorAction SilentlyContinue
    if ($null -eq $content -or -not $content.Contains($Pattern)) {
        Write-Host "FAIL [$Label]"
        Write-Host "     File   : $File"
        Write-Host "     Missing: $Pattern"
        $script:Errors++
    }
}

foreach ($file in $AuditFiles) {
    if (-not (Test-Path $file)) {
        Write-Host "FAIL [file-exists] Missing file: $file"
        $Errors++
        continue
    }

    $name = Split-Path -Leaf $file

    Check-Marker $file "## Phase 8"                                    "$name: Phase 8 heading"
    Check-Marker $file "GATE — Requires explicit user approval"        "$name: Phase 8 GATE marker"
    Check-Marker $file "Would you like me to fix these findings"       "$name: Phase 8 fix question"
    Check-Marker $file "Yes, fix them"                                 "$name: Phase 8 Yes choice"
    Check-Marker $file "No, just the report"                          "$name: Phase 8 No choice"
    Check-Marker $file "## Phase 9"                                    "$name: Phase 9 heading"
    Check-Marker $file "How would you like to proceed"                 "$name: Phase 9 commit question"
    Check-Marker $file "Commit only"                                   "$name: Phase 9 Commit-only choice"
    Check-Marker $file "Commit and push"                               "$name: Phase 9 Commit-and-push choice"
    Check-Marker $file "Exit"                                          "$name: Phase 9 Exit choice"
    Check-Marker $file "## Phase 10"                                   "$name: Phase 10 heading"
    Check-Marker $file "Shall I open a pull request"                   "$name: Phase 10 PR question"
    Check-Marker $file "Yes, open PR"                                  "$name: Phase 10 Yes choice"
    Check-Marker $file "No, keep the branch"                           "$name: Phase 10 No choice"
}

# Plain-text output files (not using ask_user tool) must include the explicit hard-stop phrase
# for all three gates (Phases 8, 9, and 10 each end with this instruction).
foreach ($file in $PlainTextFiles) {
    if (-not (Test-Path $file)) { continue }
    $name = Split-Path -Leaf $file
    $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
    $count = ([regex]::Matches($content, [regex]::Escape("End your response here. Do not call any tools"))).Count
    if ($count -lt 3) {
        Write-Host "FAIL [$name: hard-stop count]"
        Write-Host "     File   : $file"
        Write-Host "     Expected: 3 occurrences of hard-stop (Phases 8, 9, 10); found: $count"
        $script:Errors++
    }
}

if ($Errors -eq 0) {
    Write-Host "OK  All Phase 8-10 gate markers verified in $($AuditFiles.Count) files."
    exit 0
} else {
    Write-Host ""
    Write-Host "FAIL $Errors check(s) failed. The audit gate workflow is incomplete."
    exit 1
}
