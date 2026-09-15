Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Assert-DescendantPath {
    param(
        [Parameter(Mandatory)][string]$Root,
        [Parameter(Mandatory)][string]$Path
    )

    $rootFull = [IO.Path]::GetFullPath($Root).TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
    $pathFull = [IO.Path]::GetFullPath($Path)
    if (-not $pathFull.StartsWith($rootFull, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Path is outside the allowed root: $pathFull"
    }
    return $pathFull
}

function Get-IncludedFiles {
    param([Parameter(Mandatory)][string]$Path)

    $root = (Resolve-Path -LiteralPath $Path).Path
    Get-ChildItem -LiteralPath $root -File -Recurse -Force | Where-Object {
        $relative = [IO.Path]::GetRelativePath($root, $_.FullName)
        $segments = $relative -split '[\\/]'
        -not ($segments | Where-Object { $_ -in @('.git', '__pycache__', '.pytest_cache') }) -and
        $_.Name -notin @('.DS_Store', 'Thumbs.db') -and
        $_.Extension -ne '.log'
    }
}

function Get-SkillDirectories {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Root,
        [string[]]$Exclude = @('.system')
    )

    $resolvedRoot = (Resolve-Path -LiteralPath $Root).Path
    Get-ChildItem -LiteralPath $resolvedRoot -Directory -Force |
        Where-Object { $_.Name -notin $Exclude -and (Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') -PathType Leaf) } |
        Sort-Object Name
}

function Get-DirectoryDigest {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Path)

    $root = (Resolve-Path -LiteralPath $Path).Path
    $entries = foreach ($file in @(Get-IncludedFiles -Path $root | Sort-Object FullName)) {
        $relative = [IO.Path]::GetRelativePath($root, $file.FullName).Replace('\', '/')
        $hash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
        "$relative`:$hash"
    }
    $bytes = [Text.Encoding]::UTF8.GetBytes(($entries -join "`n"))
    $digest = [Security.Cryptography.SHA256]::HashData($bytes)
    return [Convert]::ToHexString($digest).ToLowerInvariant()
}

function Test-IsPlaceholderSecret {
    param([string]$Value)
    return $Value -match '(?i)(example|your[-_]|placeholder|dummy|sample|test|xxx|<[^>]+>|\{[^}]+\}|process\.env|\$env:|^\$|Guid|ToString)'
}

function Test-LooksConcreteSecret {
    param([string]$Value)

    $candidate = $Value.Trim().TrimEnd(',', ';')
    # Reviewed non-secret values in vendored skill source. Keep this exact;
    # arbitrary URLs and arbitrary token assignments still need scanning.
    if ($candidate -in @('https://aistudio.baidu.com/account/accessToken', 'set(bm25.tokenize(query))')) {
        return $false
    }
    if ($candidate.Length -lt 16 -or (Test-IsPlaceholderSecret -Value $candidate)) {
        return $false
    }

    $classes = 0
    if ($candidate -cmatch '[a-z]') { $classes++ }
    if ($candidate -cmatch '[A-Z]') { $classes++ }
    if ($candidate -match '[0-9]') { $classes++ }
    if ($candidate -match '[^A-Za-z0-9]') { $classes++ }
    return $classes -ge 3
}

function Test-SkillSecurity {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Path)

    $root = (Resolve-Path -LiteralPath $Path).Path
    $textExtensions = @('.md', '.txt', '.json', '.yaml', '.yml', '.toml', '.ps1', '.psm1', '.sh', '.py', '.js', '.ts', '.tsx', '.jsx', '.html', '.css', '.xml', '.ini', '.cfg', '.conf')
    $forbiddenName = '^(\.env($|\.)|id_(rsa|ed25519)($|\.)|.*\.(pem|key)$|credentials?.*\.json$|secrets?.*\.json$|tokens?.*\.json$)'
    $tokenPatterns = @(
        '(?i)-----BEGIN [A-Z ]*PRIVATE KEY-----',
        '\bgh[pousr]_[A-Za-z0-9]{20,}\b',
        '\bgithub_pat_[A-Za-z0-9_]{20,}\b',
        '\bsk-[A-Za-z0-9_-]{20,}\b',
        '\bAIza[0-9A-Za-z_-]{25,}\b',
        '\bxox[baprs]-[0-9A-Za-z-]{20,}\b',
        '\bfc-[A-Za-z0-9]{20,}\b'
    )

    foreach ($file in @(Get-IncludedFiles -Path $root)) {
        $relative = [IO.Path]::GetRelativePath($root, $file.FullName).Replace('\', '/')
        $isReviewedEnvTemplate = $file.Name -match '^\.env\.(example|sample|template)$'
        if ($file.Name -match $forbiddenName -and -not $isReviewedEnvTemplate) {
            [pscustomobject]@{ Kind = 'ForbiddenFileName'; Path = $relative; Detail = 'Secret-like filename' }
        }

        if ($file.Extension.ToLowerInvariant() -notin $textExtensions -or $file.Length -gt 2MB) {
            continue
        }

        $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction Stop
        if ($null -eq $content) { $content = '' }
        foreach ($pattern in $tokenPatterns) {
            foreach ($match in [regex]::Matches($content, $pattern)) {
                if (-not (Test-IsPlaceholderSecret -Value $match.Value)) {
                    [pscustomobject]@{ Kind = 'SecretContent'; Path = $relative; Detail = 'Credential-like content' }
                    break
                }
            }
        }

        $assignmentPattern = '(?m)^\s*(?:(?:export\s+)?(?:\$env:)?[A-Z0-9_.-]*(?:API[_-]?KEY|TOKEN|SECRET|PASSWORD)[A-Z0-9_.-]*|["''][^"'']*(?i:API[_-]?KEY|TOKEN|SECRET|PASSWORD)[^"'']*["''])\s*[:=]\s*["'']?([^\s"'';]{8,})'
        foreach ($match in [regex]::Matches($content, $assignmentPattern)) {
            $value = $match.Groups[1].Value
            if (Test-LooksConcreteSecret -Value $value) {
                [pscustomobject]@{ Kind = 'SecretContent'; Path = $relative; Detail = 'Concrete secret assignment' }
                break
            }
        }
    }
}

function Export-SkillsSnapshot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$SourceRoot,
        [Parameter(Mandatory)][string]$DestinationRoot,
        [string[]]$Exclude = @('.system')
    )

    $source = (Resolve-Path -LiteralPath $SourceRoot).Path
    New-Item -ItemType Directory -Path $DestinationRoot -Force | Out-Null
    $destination = (Resolve-Path -LiteralPath $DestinationRoot).Path
    if ($destination.Equals($source, [StringComparison]::OrdinalIgnoreCase)) {
        throw 'Source and destination roots must differ.'
    }

    foreach ($skill in @(Get-SkillDirectories -Root $source -Exclude $Exclude)) {
        $findings = @(Test-SkillSecurity -Path $skill.FullName)
        if ($findings.Count -gt 0) {
            Write-Warning "Skipped $($skill.Name): security scan returned $($findings.Count) finding(s)."
            continue
        }

        $target = Join-Path $destination $skill.Name
        Assert-DescendantPath -Root $destination -Path $target | Out-Null
        if (Test-Path -LiteralPath $target) {
            Remove-Item -LiteralPath $target -Recurse -Force
        }
        New-Item -ItemType Directory -Path $target -Force | Out-Null

        $files = @(Get-IncludedFiles -Path $skill.FullName)
        foreach ($file in $files) {
            $relative = [IO.Path]::GetRelativePath($skill.FullName, $file.FullName)
            $targetFile = Assert-DescendantPath -Root $target -Path (Join-Path $target $relative)
            New-Item -ItemType Directory -Path (Split-Path -Parent $targetFile) -Force | Out-Null
            Copy-Item -LiteralPath $file.FullName -Destination $targetFile -Force
        }

        [pscustomobject][ordered]@{
            name = $skill.Name
            source = $skill.FullName
            fileCount = $files.Count
            sizeBytes = [long](($files | Measure-Object -Property Length -Sum).Sum)
            sha256 = Get-DirectoryDigest -Path $target
        }
    }
}

Export-ModuleMember -Function Get-SkillDirectories, Get-DirectoryDigest, Test-SkillSecurity, Export-SkillsSnapshot
