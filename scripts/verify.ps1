param(
    [string]$RepositoryRoot = (Split-Path -Parent $PSScriptRoot),
    [string]$CodexHome = (Join-Path $env:USERPROFILE '.codex')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Import-Module (Join-Path $PSScriptRoot 'SkillsBackup.psm1') -Force

$repository = (Resolve-Path -LiteralPath $RepositoryRoot).Path
$manifest = Get-Content -LiteralPath (Join-Path $repository 'manifests\personal-skills.json') -Raw | ConvertFrom-Json
$skillsRoot = Join-Path $CodexHome 'skills'
$failures = [Collections.Generic.List[string]]::new()

foreach ($skill in @($manifest.skills)) {
    $target = Join-Path $skillsRoot $skill.name
    if (-not (Test-Path -LiteralPath (Join-Path $target 'SKILL.md') -PathType Leaf)) {
        $failures.Add("Missing: $($skill.name)")
        continue
    }
    $actual = Get-DirectoryDigest -Path $target
    if ($actual -ne $skill.sha256) {
        $failures.Add("Modified: $($skill.name)")
    }
}

if ($failures.Count -gt 0) {
    throw "Skill verification failed: $($failures -join '; ')"
}

Write-Output "Verified $(@($manifest.skills).Count) personal Skills."
