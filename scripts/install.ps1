param(
    [string]$RepositoryRoot = (Split-Path -Parent $PSScriptRoot),
    [string]$CodexHome = (Join-Path $env:USERPROFILE '.codex'),
    [string]$BackupTimestamp = (Get-Date -Format 'yyyyMMdd-HHmmss'),
    [switch]$WhatIf
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Import-Module (Join-Path $PSScriptRoot 'SkillsBackup.psm1') -Force

$repository = (Resolve-Path -LiteralPath $RepositoryRoot).Path
$manifestPath = Join-Path $repository 'manifests\personal-skills.json'
$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$skillsRoot = Join-Path $CodexHome 'skills'
$backupRoot = Join-Path $CodexHome ("skills-backup\" + $BackupTimestamp)

foreach ($skill in @($manifest.skills)) {
    if ($skill.name -notmatch '^[A-Za-z0-9][A-Za-z0-9._-]*$') {
        throw "Unsafe Skill name in manifest: $($skill.name)"
    }
    $source = [IO.Path]::GetFullPath((Join-Path $repository $skill.source))
    $repositoryPrefix = $repository.TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
    if (-not $source.StartsWith($repositoryPrefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Manifest source escapes repository: $($skill.source)"
    }
    if (-not (Test-Path -LiteralPath (Join-Path $source 'SKILL.md') -PathType Leaf)) {
        throw "Snapshot is missing SKILL.md for $($skill.name)"
    }

    $target = [IO.Path]::GetFullPath((Join-Path $skillsRoot $skill.name))
    $skillsPrefix = [IO.Path]::GetFullPath($skillsRoot).TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
    if (-not $target.StartsWith($skillsPrefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Destination escapes Skills root: $target"
    }

    if ($WhatIf) {
        Write-Output "WHATIF: install $($skill.name) to $target"
        continue
    }

    New-Item -ItemType Directory -Path $skillsRoot -Force | Out-Null
    if (Test-Path -LiteralPath $target) {
        $currentDigest = Get-DirectoryDigest -Path $target
        if ($currentDigest -eq $skill.sha256) {
            Write-Output "Unchanged: $($skill.name)"
            continue
        }
        $backupTarget = Join-Path $backupRoot $skill.name
        New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
        if (Test-Path -LiteralPath $backupTarget) {
            throw "Backup destination already exists: $backupTarget"
        }
        Move-Item -LiteralPath $target -Destination $backupTarget
        Write-Output "Preserved previous version: $backupTarget"
    }

    Copy-Item -LiteralPath $source -Destination $target -Recurse
    Write-Output "Installed: $($skill.name)"
}
