param(
    [Parameter(Mandatory)][string[]]$SkillRoots,
    [int]$ExpectedCount = 0,
    [hashtable]$RuntimeRequirements = @{},
    [switch]$UseKnownRuntimeRequirements,
    [switch]$Json
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Long-running hosts keep the PATH value they inherited at startup. Merge the
# latest persisted Windows PATH values so commands installed during this task
# are audited without requiring Codex or the terminal to restart first.
if ($IsWindows) {
    $persistedPath = @(
        [Environment]::GetEnvironmentVariable('Path', 'User')
        [Environment]::GetEnvironmentVariable('Path', 'Machine')
        $env:Path
    ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    $env:Path = $persistedPath -join [IO.Path]::PathSeparator
}

if ($UseKnownRuntimeRequirements) {
    $RuntimeRequirements = @{
        'agent-reach' = @('agent-reach', 'mcporter', 'yt-dlp', 'ffmpeg')
        'awesome-skills' = @('npx')
        'browser-use' = @('browser-use', 'browser-harness')
        'codex-ppt' = @('python|py')
        'defuddle' = @('defuddle')
        'firecrawl' = @('firecrawl')
        'gh-fix-ci' = @('gh')
        'find-skills' = @('npx')
        'hyperframes' = @('hyperframes', 'ffmpeg', 'ffprobe')
        'image-to-editable-ppt' = @('editppt')
        'jupyter-notebook' = @('uv', 'python|py')
        'obsidian-cli' = @('obsidian')
        'remotion-best-practices' = @('node', 'npm|pnpm')
        'screenshot' = @('pwsh')
        'speech' = @('python|py')
        'superdesign' = @('npx')
        'transcribe' = @('python|py')
        'ui-ux-pro-max' = @('python|py')
        'writing-skills' = @('node')
    }
}

$skillDirectories = @($SkillRoots | ForEach-Object {
    $root = (Resolve-Path -LiteralPath $_).Path
    Get-ChildItem -LiteralPath $root -Directory -Force | Where-Object {
        $_.Name -ne '.system' -and (Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') -PathType Leaf)
    }
} | Sort-Object Name)

$skillResults = foreach ($skill in $skillDirectories) {
    $brokenReferences = [Collections.Generic.List[string]]::new()
    foreach ($markdown in @(Get-ChildItem -LiteralPath $skill.FullName -Filter '*.md' -File -Recurse -Force)) {
        $content = Get-Content -LiteralPath $markdown.FullName -Raw
        $insideFence = $false
        $contentForLinks = @(foreach ($line in @($content -split '\r?\n')) {
            if ($line -match '^[ \t]*(?:`{3,}|~{3,})') {
                $insideFence = -not $insideFence
                continue
            }
            if (-not $insideFence) { $line }
        }) -join "`n"
        $contentForLinks = [regex]::Replace($contentForLinks, '`[^`\r\n]*`', '')
        foreach ($match in [regex]::Matches($contentForLinks, '!?(?:\[[^\]]*\])\(([^)]+)\)')) {
            $target = $match.Groups[1].Value.Trim().Trim('<', '>')
            if ($target -match '^(?:https?://|mailto:|data:|#)' -or $target -match '^skill://') { continue }
            $target = ($target -split '\s+["'']', 2)[0]
            $target = ($target -split '#', 2)[0]
            if ([string]::IsNullOrWhiteSpace($target)) { continue }
            $decoded = [Uri]::UnescapeDataString($target).Replace('/', [IO.Path]::DirectorySeparatorChar)
            $resolvedTarget = [IO.Path]::GetFullPath((Join-Path $markdown.DirectoryName $decoded))
            if (-not (Test-Path -LiteralPath $resolvedTarget)) {
                $relativeMarkdown = [IO.Path]::GetRelativePath($skill.FullName, $markdown.FullName).Replace('\', '/')
                $brokenReferences.Add("$relativeMarkdown -> $target")
            }
        }
    }

    $missingCommands = [Collections.Generic.List[string]]::new()
    if ($RuntimeRequirements.ContainsKey($skill.Name)) {
        foreach ($requirement in @($RuntimeRequirements[$skill.Name])) {
            $alternatives = @($requirement -split '\|')
            $found = @($alternatives | Where-Object { Get-Command $_ -ErrorAction SilentlyContinue }).Count -gt 0
            if (-not $found) { $missingCommands.Add($requirement) }
        }
    }

    [pscustomobject]@{
        name = $skill.Name
        path = $skill.FullName
        brokenReferences = @($brokenReferences)
        missingCommands = @($missingCommands)
        healthy = ($brokenReferences.Count -eq 0 -and $missingCommands.Count -eq 0)
    }
}

$brokenCount = @($skillResults | ForEach-Object { $_.brokenReferences }).Count
$missingCount = @($skillResults | ForEach-Object { $_.missingCommands }).Count
$countMatches = ($ExpectedCount -le 0 -or $skillDirectories.Count -eq $ExpectedCount)
$result = [pscustomobject]@{
    healthy = ($countMatches -and $brokenCount -eq 0 -and $missingCount -eq 0)
    summary = [pscustomobject]@{
        skills = $skillDirectories.Count
        expectedSkills = $ExpectedCount
        countMatches = $countMatches
        brokenReferences = $brokenCount
        missingCommands = $missingCount
    }
    skills = @($skillResults)
}

if ($Json) { $result | ConvertTo-Json -Depth 8 }
else { $result; if (-not $result.healthy) { exit 1 } }
