# Codex Skills Backup

[![Skills](https://img.shields.io/badge/Personal%20Skills-86-00bcd4)](manifests/personal-skills.json)
[![Verification](https://img.shields.io/badge/Verification-86%2F86-success)](docs/verification-2026-09-15.md)
[![Platform](https://img.shields.io/badge/Platform-Codex-2563eb)](https://github.com/openai/codex)

Reproducible backup of the personal Codex Skills installed and verified by `johnson68878-ops`.

This is a shareable, reproducible collection of 86 Skills assembled, installed and verified for wearable-system architecture, electronics, PCB and mechanical engineering, software delivery, product management, quality systems, web automation, knowledge workflows and AI evaluation. Individual Skills retain their upstream authorship and license terms; this repository does not claim original authorship of third-party content.

This repository vendors **86 personal Skills**, collected from `%USERPROFILE%\.codex\skills` (52) and `%USERPROFILE%\.agents\skills` (34). It intentionally excludes `.system`, authentication data, conversations, browser profiles, Codex configuration credentials, and plugin caches. Plugin-provided Skills are listed in `manifests/plugin-skills.json`; reconnect those plugins separately in Codex App because their account permissions and MCP services cannot be restored by copying files. The current Windows machine has passed the local 86-Skill structure and known-command health audit; account-bound integrations are listed in the verification report.

Read the [original 46-Skill analysis and seven installed additions](docs/SKILLS-46-ANALYSIS.zh-TW.md) for capabilities, engineering use cases, dependencies, and overlap. These are workflow/tool packages, not trained model weights. All seven recommendations in that report are now installed.

For a shareable Traditional Chinese overview of every Skill, including category summaries, use cases, and company rollout guidance, see the [complete 86-Skill categorized guide](docs/SKILLS-CATALOG.zh-TW.md).

To install the complete collection through Codex, copy the ready-made prompt in [Install all 86 Skills with Codex](docs/INSTALL-WITH-CODEX.zh-TW.md). The same guide includes a direct PowerShell command.

## Install on the company computer

Open **PowerShell 7.2 or later** and run:

```powershell
git clone https://github.com/johnson68878-ops/codex-skills-backup.git
Set-Location .\codex-skills-backup
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\install.ps1
.\scripts\verify.ps1
```

All 86 entries restore into `%USERPROFILE%\.codex\skills`. On a machine that already has a same-named Skill in `.agents\skills`, compare it before restoring to avoid cross-directory duplicates. Start a new conversation to refresh discovery; restart Codex App if the new Skills do not appear. Installing Skill files does not install their external CLIs or authorize external services.

The installer is conservative:

- An unchanged Skill is skipped.
- A different existing Skill is moved to `%USERPROFILE%\.codex\skills-backup\<timestamp>\` before replacement.
- `.system` and plugin cache directories are never modified.
- Use `.\scripts\install.ps1 -WhatIf` to preview changes.

If `git clone` requests authentication, sign in to GitHub with an account that can access this private repository. You may alternatively download the repository ZIP from GitHub, extract it, and run the same scripts from the extracted folder.

## Verify later

```powershell
Set-Location .\codex-skills-backup
.\scripts\verify.ps1
```

Verification checks every installed personal Skill against the SHA-256 digest stored in `manifests/personal-skills.json`.

## Refresh this backup from a trusted PC

```powershell
Set-Location .\codex-skills-backup
.\scripts\update-backup.ps1 -AdditionalSkillsRoot "$env:USERPROFILE\.agents\skills"
.\scripts\verify.ps1 -AdditionalSkillsRoot "$env:USERPROFILE\.agents\skills"
.\tests\SkillsBackup.Tests.ps1
.\tests\SkillsHealth.Tests.ps1
.\scripts\Test-SkillsHealth.ps1 -SkillRoots "$env:USERPROFILE\.codex\skills","$env:USERPROFILE\.agents\skills" -ExpectedCount 86 -UseKnownRuntimeRequirements
git status --short
```

Review the changes and security-scan result before committing and pushing.

Omit `-AdditionalSkillsRoot` if there is no additional Skill directory. Duplicate names across roots are rejected before the old snapshot is changed. The additional path is an explicit local input and is not stored in the portable manifest. On a restored machine where all Skills are under `.codex\skills`, the ordinary verification command is sufficient.

`.gitattributes` preserves Skill bytes so Git's newline conversion does not invalidate their digests. The three `planning-with-files` templates omitted by an earlier ignore rule were rebuilt from that Skill's bundled initializer; they are a documented repair, not recovered originals. The manifest records the repaired files.

## Plugin reconnection

After restoring personal Skills, open Codex App and reconnect the plugins you need, such as GitHub, Google Drive and Figma. The inventory in `manifests/plugin-skills.json` documents what was available on the source PC, but it contains no credentials or authorization tokens. See [the dated verification report](docs/verification-2026-09-15.md) for the tested runtimes and remaining sign-in conditions.
